-- Profession Helper - Bag & Bank Scanner
-- Scans character bags (and bank when open) to count materials already owned.
-- Results are stored in ProfessionHelperDB.inventory[charKey] via PH.DB.
--
-- Architecture:
--   - Uses PH.Compat  for C_Container API (polyfilled for Classic/TBC/WotLK)
--   - Uses PH.Identity for character key lookups
--   - Uses PH.DB      for all SavedVariables access
--   - Uses PH.Event   for WoW event subscriptions

local PH = _G.ProfessionHelper

PH.BagScanner = {}
local BS = PH.BagScanner

local NUM_BAG_SLOTS  = 4   -- bags 0..4 (0 = backpack, 1-4 = equipped bags)
local NUM_BANK_FIRST = 5
local NUM_BANK_LAST  = 11  -- bank bags 5..11

-------------------------------------------------------------------------------
-- Scanning
-------------------------------------------------------------------------------

-- Scan all equipped bags (not bank) and update per-character inventory.
function BS:ScanBags()
    local charKey = PH.Identity:GetCharKey()
    local invPath = "inventory." .. charKey
    PH.DB:Ensure(invPath)

    -- Reset bag counts before fresh scan (bank counts preserved separately)
    local bags = {}

    for bag = 0, NUM_BAG_SLOTS do
        local slots = PH.Compat.GetContainerNumSlots(bag)
        if slots and slots > 0 then
            for slot = 1, slots do
                local link = PH.Compat.GetContainerItemLink(bag, slot)
                if link then
                    local itemName = PH.Compat.GetItemInfo(link)
                    if itemName then
                        local info  = PH.Compat.GetContainerItemInfo(bag, slot)
                        local count = (info and info.stackCount) or 0
                        bags[itemName] = (bags[itemName] or 0) + count
                    end
                end
            end
        end
    end

    PH.DB:Set(invPath .. "._bags", bags)
    self:_MergeInventory(charKey)
    PH.Event:Fire("PH_BAG_SCANNED")
end

-- Scan bank slots (call only when the bank frame is open).
function BS:ScanBank()
    local charKey = PH.Identity:GetCharKey()
    local invPath = "inventory." .. charKey
    PH.DB:Ensure(invPath)

    local bank = {}
    for bag = NUM_BANK_FIRST, NUM_BANK_LAST do
        local slots = PH.Compat.GetContainerNumSlots(bag)
        if slots and slots > 0 then
            for slot = 1, slots do
                local link = PH.Compat.GetContainerItemLink(bag, slot)
                if link then
                    local itemName = PH.Compat.GetItemInfo(link)
                    if itemName then
                        local info  = PH.Compat.GetContainerItemInfo(bag, slot)
                        local count = (info and info.stackCount) or 0
                        bank[itemName] = (bank[itemName] or 0) + count
                    end
                end
            end
        end
    end

    PH.DB:Set(invPath .. "._bank", bank)
    self:_MergeInventory(charKey)
end

-- Merge _bags + _bank into the flat [itemName] = count top-level table.
function BS:_MergeInventory(charKey)
    local invPath = "inventory." .. charKey
    local bags    = PH.DB:Get(invPath .. "._bags") or {}
    local bank    = PH.DB:Get(invPath .. "._bank") or {}

    local merged = {}
    for k in pairs(bags) do merged[k] = true end
    for k in pairs(bank) do merged[k] = true end

    for name in pairs(merged) do
        PH.DB:Set(invPath .. "." .. name, (bags[name] or 0) + (bank[name] or 0))
    end
end

-------------------------------------------------------------------------------
-- Query API
-------------------------------------------------------------------------------

-- Returns the total count (bags + bank) of itemName for the current character.
function BS:GetCount(itemName)
    if not itemName then return 0 end
    local charKey = PH.Identity:GetCharKey()
    return PH.DB:Get("inventory." .. charKey .. "." .. itemName) or 0
end

-- Returns the full inventory snapshot for the current character.
function BS:GetAllCounts()
    local charKey = PH.Identity:GetCharKey()
    return PH.DB:Get("inventory." .. charKey) or {}
end

-- Returns a flat { [itemName] = count } table summing inventory across all known
-- alts on the current realm, excluding the current character.
function BS:GetAllAltCounts()
    local realmKey  = PH.Identity:GetRealmKey()
    local myCharKey = PH.Identity:GetCharKey()
    local charData  = PH.DB:Get("characters." .. realmKey)
    if not charData then return {} end

    local totals = {}
    for charName in pairs(charData) do
        local altKey = charName .. "-" .. realmKey
        if altKey ~= myCharKey then
            local inv = PH.DB:Get("inventory." .. altKey) or {}
            for itemName, count in pairs(inv) do
                -- skip sub-tables like _bags and _bank
                if type(count) == "number" then
                    totals[itemName] = (totals[itemName] or 0) + count
                end
            end
        end
    end
    return totals
end

-- Returns total count of itemName across all known alts (excluding current char).
function BS:GetAltCount(itemName)
    if not itemName then return 0 end
    local realmKey  = PH.Identity:GetRealmKey()
    local myCharKey = PH.Identity:GetCharKey()
    local charData  = PH.DB:Get("characters." .. realmKey)
    if not charData then return 0 end

    local total = 0
    for charName in pairs(charData) do
        local altKey = charName .. "-" .. realmKey
        if altKey ~= myCharKey then
            local count = PH.DB:Get("inventory." .. altKey .. "." .. itemName) or 0
            total = total + count
        end
    end
    return total
end

-------------------------------------------------------------------------------
-- Initialization
-- Called from Core/Init.lua after PH.DB and PH.Event are ready.
-------------------------------------------------------------------------------

function BS:Initialize()
    PH.DB:Ensure("inventory")

    -- Subscribe through the central event bus — no local eventFrame
    PH.Event:On("BAG_UPDATE_DELAYED", function()
        BS:ScanBags()
    end, "BagScanner")

    PH.Event:On("BANKFRAME_OPENED", function()
        BS:ScanBank()
    end, "BagScanner")

    -- Initial scan on startup
    self:ScanBags()
end
