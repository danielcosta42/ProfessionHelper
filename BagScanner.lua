-- Profession Helper - Bag & Bank Scanner
-- Scans character bags (and bank when open) to count materials already owned.
-- Results are stored in ProfessionHelperDB.inventory[charKey][itemName] = count
-- and used by PathCalculator to adjust shopping-list "buy" quantities.

ProfessionHelper = ProfessionHelper or {}
local PH = ProfessionHelper

PH.BagScanner = {}
local BS = PH.BagScanner

-------------------------------------------------------------------------------
-- Constants
-------------------------------------------------------------------------------
local NUM_BAG_SLOTS = 4  -- bags 0..4 (0 = backpack, 1-4 = equipped bags)

-------------------------------------------------------------------------------
-- Helpers
-------------------------------------------------------------------------------

function BS:GetCharKey()
    local name  = UnitName("player") or "Unknown"
    local realm = GetRealmName()     or "Unknown"
    return name .. "-" .. realm
end

-- Ensure inventory table exists for this character
local function EnsureInventory(charKey)
    if not ProfessionHelperDB.inventory then
        ProfessionHelperDB.inventory = {}
    end
    if not ProfessionHelperDB.inventory[charKey] then
        ProfessionHelperDB.inventory[charKey] = {}
    end
end

-------------------------------------------------------------------------------
-- Scanning
-------------------------------------------------------------------------------

-- Scan all equipped bags (not bank) and accumulate item counts
function BS:ScanBags()
    local charKey = self:GetCharKey()
    EnsureInventory(charKey)

    -- Reset counts so items we no longer carry get cleared
    -- We only clear bag slots — bank slots are preserved separately
    local inv = ProfessionHelperDB.inventory[charKey]
    inv._bags = {}  -- temp bucket

    for bag = 0, NUM_BAG_SLOTS do
        local slots = GetContainerNumSlots(bag)
        if slots then
            for slot = 1, slots do
                local itemLink = GetContainerItemLink(bag, slot)
                if itemLink then
                    local itemName = GetItemInfo(itemLink)
                    if itemName then
                        local _, count = GetContainerItemInfo(bag, slot)
                        count = count or 0
                        inv._bags[itemName] = (inv._bags[itemName] or 0) + count
                    end
                end
            end
        end
    end

    -- Merge bags + bank into the top-level per-item count
    self:_MergeInventory(charKey)
end

-- Scan bank slots (call only when bank frame is open)
function BS:ScanBank()
    local charKey = self:GetCharKey()
    EnsureInventory(charKey)

    local inv = ProfessionHelperDB.inventory[charKey]
    inv._bank = inv._bank or {}
    -- Clear old bank data before fresh scan
    inv._bank = {}

    -- Bank slots: bags 5..11 in TBC Classic
    for bag = 5, 11 do
        local slots = GetContainerNumSlots(bag)
        if slots and slots > 0 then
            for slot = 1, slots do
                local itemLink = GetContainerItemLink(bag, slot)
                if itemLink then
                    local itemName = GetItemInfo(itemLink)
                    if itemName then
                        local _, count = GetContainerItemInfo(bag, slot)
                        count = count or 0
                        inv._bank[itemName] = (inv._bank[itemName] or 0) + count
                    end
                end
            end
        end
    end

    self:_MergeInventory(charKey)
end

-- Merge _bags + _bank into the flat [itemName] = count table
function BS:_MergeInventory(charKey)
    local inv = ProfessionHelperDB.inventory[charKey]
    local bags = inv._bags or {}
    local bank = inv._bank or {}

    -- Build a set of all known names
    local names = {}
    for k in pairs(bags) do names[k] = true end
    for k in pairs(bank) do names[k] = true end

    for name in pairs(names) do
        inv[name] = (bags[name] or 0) + (bank[name] or 0)
    end
end

-------------------------------------------------------------------------------
-- Query API
-------------------------------------------------------------------------------

-- Returns count of itemName in current character's inventory (bags + bank)
function BS:GetCount(itemName)
    if not itemName then return 0 end
    local charKey = self:GetCharKey()
    local inv = ProfessionHelperDB.inventory
    if not inv or not inv[charKey] then return 0 end
    return inv[charKey][itemName] or 0
end

-------------------------------------------------------------------------------
-- Initialization & events
-------------------------------------------------------------------------------

function BS:Initialize()
    if not ProfessionHelperDB.inventory then
        ProfessionHelperDB.inventory = {}
    end
    self:RegisterEvents()
    -- Initial bag scan (bank not available at login)
    self:ScanBags()
end

function BS:RegisterEvents()
    if self.eventFrame then return end
    self.eventFrame = CreateFrame("Frame")
    self.eventFrame:RegisterEvent("BAG_UPDATE_DELAYED")
    self.eventFrame:RegisterEvent("BANKFRAME_OPENED")
    self.eventFrame:SetScript("OnEvent", function(_, event)
        if event == "BAG_UPDATE_DELAYED" then
            BS:ScanBags()
        elseif event == "BANKFRAME_OPENED" then
            BS:ScanBank()
        end
    end)
end
