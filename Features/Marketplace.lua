-- Profession Helper - Marketplace (scanner + capability matcher + peer mesh)
--
-- Local half (no network): scans public Trade/General/LFG chat for crafting
-- REQUESTS (WTB / "quem faz") and OFFERS (WTS), matches requests against what
-- THIS account can craft (known recipes across alts), priced via TSM.
--
-- Network half (Phase 2): gossips ORDERS to other ProfessionHelper users over the
-- delivering buses (guild + group + SAY proximity; CHANNEL is blocked on this
-- client) so demand seen by ANY peer reaches crafters realm-region-wide, and reads
-- the ChehulNet presence mesh to list the crafter peers online. One-click opens a
-- prefilled whisper (human sends it — never auto-spam).

local PH = _G.ProfessionHelper

PH.Marketplace = {}
local MP = PH.Marketplace

MP.LISTING_TTL = 600       -- an in-memory local listing stays "open" this long
MP.NET_TTL     = 600       -- a peer-gossiped order stays "open" this long
MP.NET_PREFIX  = "PHMkt"   -- addon-message prefix for marketplace gossip
MP.NET_PROTO   = "PHM1"    -- payload protocol tag
MP.FLUSH_EVERY = 6         -- seconds between gossip sends (well under the throttle)

-- Chat worth scanning (base channel name, lowercased, substring match).
local MARKET_CHANNELS = {
    "trade", "com\195\169rcio", "comercio", "general", "geral",
    "lookingforgroup", "world",
}

local REQUEST_WORDS = {
    "wtb", "lfw", "looking for", "who can", "who make", "can anyone", "can someone",
    "quem faz", "quem cria", "quem crafta", "quem pode", "procuro", "preciso",
    "compro", "alguem faz", "algu\195\169m faz", "quien", "necesito", "busco",
}
local OFFER_WORDS = {
    "wts", "selling", "sell ", "vendo", "vendendo", "\195\160 venda", "a venda",
    "craft service", "se vende", "en venta",
}

-------------------------------------------------------------------------------
-- Helpers
-------------------------------------------------------------------------------

local function ContainsAny(text, list)
    for _, w in ipairs(list) do
        if text:find(w, 1, true) then return true end
    end
    return false
end

local function IsMarketChannel(baseName)
    if not baseName then return false end
    return ContainsAny(baseName:lower(), MARKET_CHANNELS)
end

local function ExtractItems(msg)
    local items, seen = {}, {}
    for id, name in msg:gmatch("|Hitem:(%d+):[^|]*|h%[(.-)%]|h") do
        id = tonumber(id)
        if id and not seen[id] then
            seen[id] = true
            items[#items + 1] = { id = id, name = name }
        end
    end
    return items
end

local function Short(name)
    return (Ambiguate and Ambiguate(name or "", "short")) or name
end

-------------------------------------------------------------------------------
-- Craftable index (cross-alt): index[lowerItemName] = { {char, prof, recipe}, ... }
-------------------------------------------------------------------------------

function MP:BuildCraftableIndex()
    local realmKey = PH.Identity:GetRealmKey()
    local index = {}
    local chars = (PH.AltManager and PH.AltManager:GetAllCharsOnRealm()) or {}
    for _, char in ipairs(chars) do
        local profs = PH.DB:Get("knownRecipes." .. char.name .. "-" .. realmKey)
        if type(profs) == "table" then
            for profName, recipes in pairs(profs) do
                for recipeName in pairs(recipes) do
                    local key = recipeName:lower()
                    if not index[key] then index[key] = {} end
                    table.insert(index[key], { char = char.name, prof = profName, recipe = recipeName })
                end
            end
        end
    end
    self._index = index
    self._indexDirty = false
    return index
end

function MP:GetCraftableIndex()
    if not self._index or self._indexDirty then
        return self:BuildCraftableIndex()
    end
    return self._index
end

function MP:WhoCanCraft(name)
    if not name then return nil end
    return self:GetCraftableIndex()[name:lower()]
end

-------------------------------------------------------------------------------
-- Listings: local scanned (self.listings) + peer-gossiped (self.netListings)
-------------------------------------------------------------------------------

function MP:AddListing(kind, who, itemID, name, note)
    if not who or not name then return end
    local id = kind .. ":" .. who .. ":" .. tostring(itemID or name)
    self.listings[id] = { kind = kind, who = who, itemID = itemID, name = name, note = note, ts = time() }
    -- Gossip my freshly-scanned ORDERS to ProfessionHelper peers (once each).
    if kind == "order" and not self._broadcasted[id] then
        self._broadcasted[id] = true
        self.sendQueue[#self.sendQueue + 1] = { itemID = itemID or 0, name = name, who = who }
    end
    PH.Event:Fire("PH_MARKET_UPDATED")
end

function MP:AddNetOrder(who, itemID, name, heardFrom)
    if not who or not name then return end
    local id = "net:" .. who .. ":" .. tostring((itemID ~= 0 and itemID) or name)
    self.netListings[id] = {
        kind = "order", who = who, itemID = (itemID ~= 0) and itemID or nil,
        name = name, source = "net", heardFrom = heardFrom, ts = time(),
    }
    PH.Event:Fire("PH_MARKET_UPDATED")
end

function MP:Prune()
    local now = time()
    for id, l in pairs(self.listings) do
        if (now - (l.ts or 0)) > MP.LISTING_TTL then self.listings[id] = nil end
    end
    for id, l in pairs(self.netListings) do
        if (now - (l.ts or 0)) > MP.NET_TTL then self.netListings[id] = nil end
    end
end

-------------------------------------------------------------------------------
-- Scanner
-------------------------------------------------------------------------------

function MP:OnChat(msg, sender, baseName)
    if not msg or not sender or msg == "" then return end
    if not IsMarketChannel(baseName) then return end
    if Short(sender) == PH.Identity:GetCharName() then return end

    local lower = msg:lower()
    local kind
    if ContainsAny(lower, REQUEST_WORDS) then
        kind = "order"
    elseif ContainsAny(lower, OFFER_WORDS) then
        kind = "offer"
    else
        return
    end

    local items = ExtractItems(msg)
    if #items == 0 then
        if kind == "order" then
            for key, who in pairs(self:GetCraftableIndex()) do
                if lower:find(key, 1, true) then
                    self:AddListing(kind, Short(sender), nil, who[1].recipe, msg)
                    break
                end
            end
        end
        return
    end
    for _, item in ipairs(items) do
        self:AddListing(kind, Short(sender), item.id, item.name, msg)
    end
end

-------------------------------------------------------------------------------
-- Peer mesh: gossip ORDERS + read the ChehulNet crafter directory
-------------------------------------------------------------------------------

-- Broadcast a payload to ProfessionHelper peers over the shared mesh: guild +
-- group + SAY proximity (hidden, immediate) AND the realm-wide dedicated channel
-- (flushed on the user's next click). One transport for the whole Chehul family.
function MP:Broadcast(payload)
    local Mesh = _G.ChehulMesh
    if not Mesh then return false end
    Mesh:Guild(MP.NET_PREFIX, payload)
    Mesh:Group(MP.NET_PREFIX, payload)
    Mesh:Proximity(MP.NET_PREFIX, payload)
    Mesh:Realm(MP.NET_PREFIX, payload) -- realm-wide
    return true
end

-- Flush one queued order per tick (throttle-safe).
function MP:FlushQueue()
    self:Prune()
    local item = table.remove(self.sendQueue, 1)
    if not item then return end
    -- PHM1|O|<itemID>|<name>|<requester>
    self:Broadcast(table.concat({ MP.NET_PROTO, "O", tostring(item.itemID or 0), item.name, item.who }, "|"))
end

-- Registered with ChehulMesh; called as handler(payload, sender, dist).
function MP:OnNet(payload, sender)
    if not sender or type(payload) ~= "string" then return end
    local proto, op, itemID, name, requester = strsplit("|", payload)
    if proto ~= MP.NET_PROTO then return end
    local short = Short(sender)
    if short == PH.Identity:GetCharName() then return end -- ignore my own gossip
    if op == "O" and name and name ~= "" then
        self.netStats.recv = self.netStats.recv + 1
        -- who = the original requester (so a crafter whispers the right person).
        self:AddNetOrder((requester ~= "" and requester) or short, tonumber(itemID) or 0, name, short)
    end
end

-- Crafter peers online (from the ChehulNet presence mesh): { name, class, level, profs, who }.
function MP:GetCrafters()
    local out = {}
    local CN = _G.ChehulNet
    if not (CN and CN.Peers) then return out end
    for name, p in pairs(CN:Peers()) do
        if p.addons and p.addons.ph then
            local profs = p.caps and p.caps:match("craft:([^,]+)")
            out[#out + 1] = {
                who = name, name = name, isCrafter = true,
                class = p.class, level = p.level,
                profs = profs and (profs:gsub("/", ", ")) or nil,
            }
        end
    end
    table.sort(out, function(a, b) return (a.name or "") < (b.name or "") end)
    return out
end

-------------------------------------------------------------------------------
-- Board queries
-------------------------------------------------------------------------------

local function ByNewest(a, b) return (a.ts or 0) > (b.ts or 0) end

local function PriceOf(name)
    if PH.TSM and PH.TSM.GetItemPrice then return PH.TSM:GetItemPrice(name) end
    return nil
end

-- All open requests (local scan + peer gossip), newest first.
function MP:GetOrders()
    self:Prune()
    local out, seen = {}, {}
    local function add(l, isNet)
        local key = (l.who or "") .. ":" .. tostring(l.itemID or l.name)
        if seen[key] then return end
        seen[key] = true
        out[#out + 1] = {
            who = l.who, name = l.name, itemID = l.itemID, note = l.note, ts = l.ts,
            source = isNet and "net" or "scan", heardFrom = l.heardFrom,
            canCraft = self:WhoCanCraft(l.name), price = PriceOf(l.name),
        }
    end
    for _, l in pairs(self.listings) do if l.kind == "order" then add(l, false) end end
    for _, l in pairs(self.netListings) do add(l, true) end
    table.sort(out, ByNewest)
    return out
end

function MP:GetOpportunities()
    local out = {}
    for _, o in ipairs(self:GetOrders()) do
        if o.canCraft then out[#out + 1] = o end
    end
    return out
end

function MP:GetMyOffers()
    local index = self:GetCraftableIndex()
    local out = {}
    for _, makers in pairs(index) do
        local name = makers[1].recipe
        local chars, seen = {}, {}
        for _, m in ipairs(makers) do
            if not seen[m.char] then seen[m.char] = true; chars[#chars + 1] = m.char end
        end
        out[#out + 1] = { name = name, chars = chars, prof = makers[1].prof, price = PriceOf(name) }
    end
    table.sort(out, function(a, b) return a.name < b.name end)
    return out
end

-- One-click: open a prefilled whisper (human presses Enter).
function MP:WhisperFor(entry)
    if not entry or not entry.who then return end
    local msg
    if entry.isCrafter then
        msg = PH.L["MP_WHISPER_CRAFTER"] or "hi, are you crafting right now?"
    else
        msg = (PH.L["MP_WHISPER_PREFILL"] or "I can craft") .. " " .. (entry.name or "")
    end
    if ChatFrame_OpenChat then
        ChatFrame_OpenChat("/w " .. entry.who .. " " .. msg)
    end
end

-------------------------------------------------------------------------------
-- Init
-------------------------------------------------------------------------------

function MP:Initialize()
    PH.DB:Ensure("marketplace")
    self.listings = {}
    self.netListings = {}
    self.sendQueue = {}
    self._broadcasted = {}
    self.netStats = { recv = 0 }
    self._indexDirty = true

    if PH.Config:Get("marketplace_scan") ~= false then
        PH.Event:On("CHAT_MSG_CHANNEL", function(_, message, sender,
                _lang, chanName, _p2, _flags, _zoneID, _idx, baseName)
            self:OnChat(message, sender, baseName or chanName)
        end, "Marketplace")
    end

    -- Peer gossip over the shared mesh (guild/group/proximity + realm-wide).
    if _G.ChehulMesh then
        _G.ChehulMesh:Register(MP.NET_PREFIX, function(payload, sender)
            self:OnNet(payload, sender)
        end)
    end
    if C_Timer and C_Timer.NewTicker then
        C_Timer.NewTicker(MP.FLUSH_EVERY, function() self:FlushQueue() end)
    end

    PH.Event:On("PH_RECIPE_SCANNED", function() self._indexDirty = true end, "Marketplace")
    PH.Event:On("PH_CHAR_UPDATED", function() self._indexDirty = true end, "Marketplace")
end
