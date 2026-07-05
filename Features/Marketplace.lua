-- Profession Helper - Marketplace (Phase 1: local scanner + capability matcher)
--
-- Turns the profession data the addon already has (known recipes across alts,
-- inventory, prices) into a "crafter marketplace" WITHOUT any networking:
--   * scans public Trade/General/LFG chat for crafting REQUESTS (WTB / "quem faz")
--     and OFFERS (WTS), parsing item links into structured listings;
--   * matches requests against what THIS account can craft (known recipes across
--     all alts) to surface fillable "opportunities", priced via TSM;
--   * lists "my offers" — everything my characters can craft.
-- One-click opens a prefilled whisper (human sends it — never auto-spam).
--
-- Listings are in-memory + TTL'd (live chat, not a database). Only settings
-- persist. This is the transport-free Phase 1 of docs/MARKETPLACE-DESIGN.md; the
-- guild/proximity/ChehulNet network is a later phase.

local PH = _G.ProfessionHelper

PH.Marketplace = {}
local MP = PH.Marketplace

MP.LISTING_TTL = 600 -- an in-memory listing stays "open" this long (seconds)

-- Chat that is worth scanning (base channel name, lowercased, substring match).
local MARKET_CHANNELS = {
    "trade", "com\195\169rcio", "comercio", "general", "geral",
    "lookingforgroup", "world",
}

-- Intent keywords (pt/en/es). A listing needs an item AND one of these words, so
-- the item constraint keeps false positives low.
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
-- Small helpers
-------------------------------------------------------------------------------

local function ContainsAny(text, list)
    for _, w in ipairs(list) do
        if text:find(w, 1, true) then
            return true
        end
    end
    return false
end

local function IsMarketChannel(baseName)
    if not baseName then return false end
    local n = baseName:lower()
    return ContainsAny(n, MARKET_CHANNELS)
end

-- Extract every distinct item {id, name} from a chat line's hyperlinks.
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

-------------------------------------------------------------------------------
-- Craftable index — "what can this account make", across all alts on the realm.
-- index[lowerItemName] = { { char, prof, recipe }, ... }
-------------------------------------------------------------------------------

function MP:BuildCraftableIndex()
    local realmKey = PH.Identity:GetRealmKey()
    local index = {}
    local chars = (PH.AltManager and PH.AltManager:GetAllCharsOnRealm()) or {}
    for _, char in ipairs(chars) do
        local charKey = char.name .. "-" .. realmKey
        local profs = PH.DB:Get("knownRecipes." .. charKey)
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

-- Who (which of my chars) can craft an item named `name`, or nil.
function MP:WhoCanCraft(name)
    if not name then return nil end
    local hit = self:GetCraftableIndex()[name:lower()]
    return hit
end

-------------------------------------------------------------------------------
-- Listings (in-memory, TTL'd)
-------------------------------------------------------------------------------

function MP:AddListing(kind, who, itemID, name, note)
    if not who or not name then return end
    local id = kind .. ":" .. who .. ":" .. tostring(itemID or name)
    self.listings[id] = {
        kind = kind, who = who, itemID = itemID, name = name,
        note = note, ts = time(),
    }
    PH.Event:Fire("PH_MARKET_UPDATED")
end

function MP:Prune()
    local now = time()
    for id, l in pairs(self.listings) do
        if (now - (l.ts or 0)) > MP.LISTING_TTL then
            self.listings[id] = nil
        end
    end
end

-------------------------------------------------------------------------------
-- Scanner
-------------------------------------------------------------------------------

function MP:OnChat(msg, sender, baseName)
    if not msg or not sender or msg == "" then return end
    if not IsMarketChannel(baseName) then return end
    if sender == PH.Identity:GetCharName() then return end -- ignore my own posts

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
        -- No item link: still capture an order if it names something we can craft.
        if kind == "order" then
            for key, who in pairs(self:GetCraftableIndex()) do
                if lower:find(key, 1, true) then
                    self:AddListing(kind, sender, nil, who[1].recipe, msg)
                    break
                end
            end
        end
        return
    end

    for _, item in ipairs(items) do
        self:AddListing(kind, sender, item.id, item.name, msg)
    end
end

-------------------------------------------------------------------------------
-- Board queries
-------------------------------------------------------------------------------

local function ByNewest(a, b)
    return (a.ts or 0) > (b.ts or 0)
end

-- Suggested price for an item name (TSM/cache), or nil.
local function PriceOf(name)
    if PH.TSM and PH.TSM.GetItemPrice then
        return PH.TSM:GetItemPrice(name)
    end
    return nil
end

-- All open requests, newest first. Each: { who, name, itemID, note, ts, canCraft }.
function MP:GetOrders()
    self:Prune()
    local out = {}
    for _, l in pairs(self.listings) do
        if l.kind == "order" then
            out[#out + 1] = {
                who = l.who, name = l.name, itemID = l.itemID, note = l.note, ts = l.ts,
                canCraft = self:WhoCanCraft(l.name),
                price = PriceOf(l.name),
            }
        end
    end
    table.sort(out, ByNewest)
    return out
end

-- Only the requests THIS account can fill, newest first.
function MP:GetOpportunities()
    local out = {}
    for _, o in ipairs(self:GetOrders()) do
        if o.canCraft then
            out[#out + 1] = o
        end
    end
    return out
end

-- Everything my characters can craft, sorted by name. Each: { name, chars, prof, price }.
function MP:GetMyOffers()
    local index = self:GetCraftableIndex()
    local out = {}
    for _, makers in pairs(index) do
        local name = makers[1].recipe
        local chars = {}
        local seen = {}
        for _, m in ipairs(makers) do
            if not seen[m.char] then
                seen[m.char] = true
                chars[#chars + 1] = m.char
            end
        end
        out[#out + 1] = {
            name = name, chars = chars, prof = makers[1].prof, price = PriceOf(name),
        }
    end
    table.sort(out, function(a, b) return a.name < b.name end)
    return out
end

-- One-click: open a prefilled whisper to the requester (human presses Enter).
function MP:WhisperFor(entry)
    if not entry or not entry.who then return end
    local msg = string.format("%s %s", PH.L["MP_WHISPER_PREFILL"] or "I can craft", entry.name or "")
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
    self._indexDirty = true

    if PH.Config:Get("marketplace_scan") ~= false then
        PH.Event:On("CHAT_MSG_CHANNEL", function(_, message, sender,
                _lang, chanName, _p2, _flags, _zoneID, _idx, baseName)
            self:OnChat(message, sender, baseName or chanName)
        end, "Marketplace")
    end

    -- Rebuild the craftable index when recipes/alts change.
    PH.Event:On("PH_RECIPE_SCANNED", function() self._indexDirty = true end, "Marketplace")
    PH.Event:On("PH_CHAR_UPDATED", function() self._indexDirty = true end, "Marketplace")
end
