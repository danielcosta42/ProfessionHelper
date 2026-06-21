-- Profession Helper - Farm Session Tracker
-- Tracks gold earned per hour, items looted, and session stats.
-- All session state is in-memory only (not SavedVariables).
--
-- Architecture:
--   - Uses PH.Event   for PLAYER_MONEY / CHAT_MSG_LOOT (all loot types, incl. fishing) / CHAT_MSG_MONEY
--   - Uses PH.Logger  instead of PH:Print()
--   - Uses PH.Compat  for GetMoney wrapper

local PH = _G.ProfessionHelper

PH.FarmTracker = {
    active = false,
    startTime = 0,
    startGold = 0,
    currentGold = 0,
    -- Loot tracking
    itemsLooted = {},  -- { [itemName] = { count, icon, quality, unitPrice, vendorPrice, itemID } }
    rawGoldLooted = 0, -- copper from mob drops
    vendorLootValue = 0, -- copper: sum of (count * vendor sellPrice) for all items
    estimatedLootValue = 0, -- copper: sum of (count * TSM unitPrice) for all items
    -- History for the graph
    goldSnapshots = {}, -- { {time, gold}, ... }
    snapshotInterval = 30, -- seconds between snapshots
    lastSnapshot = 0,
}

local FT = PH.FarmTracker

-------------------------------------------------------------------------------
-- Session Control
-------------------------------------------------------------------------------

function FT:Start()
    if self.active then
        PH.Logger.Info(PH.L["FARM_ALREADY_ACTIVE"])
        return
    end

    self.active      = true
    self.startTime   = GetTime()
    self.startGold   = PH.Compat.GetMoney()
    self.currentGold = self.startGold
    self.itemsLooted           = {}
    self.rawGoldLooted         = 0
    self.vendorLootValue       = 0
    self.estimatedLootValue    = 0
    self.goldSnapshots         = {}
    self.lastSnapshot          = GetTime()

    table.insert(self.goldSnapshots, { time = 0, gold = 0 })

    PH.Logger.Info("|cff00ff00" .. PH.L["FARM_STARTED_MSG"] .. PH.TSM:FormatMoney(self.startGold))
    PH:ShowFarmTrackerUI()

    -- Subscribe through central event bus; owner = "FarmTracker" for easy removal.
    -- Callbacks receive (event, ...) from the bus — name the first arg explicitly so
    -- the actual payload is passed correctly to OnEvent.
    PH.Event:On("PLAYER_MONEY",    function(evt, ...) FT:OnEvent(evt, ...) end, "FarmTracker")
    PH.Event:On("CHAT_MSG_LOOT",   function(evt, ...) FT:OnEvent(evt, ...) end, "FarmTracker")
    PH.Event:On("CHAT_MSG_MONEY",  function(evt, ...) FT:OnEvent(evt, ...) end, "FarmTracker")

    PH.Event:Fire("PH_FARM_STARTED")
end

function FT:Stop()
    if not self.active then
        PH.Logger.Info(PH.L["FARM_NOT_ACTIVE"])
        return
    end

    self.active   = false
    local elapsed = GetTime() - self.startTime
    local earned  = PH.Compat.GetMoney() - self.startGold
    local gph     = self:CalculateGoldPerHour()

    PH.Logger.Info("|cffff0000" .. PH.L["FARM_ENDED"] .. "|r")
    PH.Logger.Info(string.format(PH.L["FARM_STAT_DURATION"],       self:FormatDuration(elapsed)))
    PH.Logger.Info(string.format(PH.L["FARM_STAT_GOLD_EARNED"],    PH.TSM:FormatMoney(earned)))
    PH.Logger.Info(string.format(PH.L["FARM_STAT_GOLD_PER_HOUR"],  PH.TSM:FormatMoney(gph)))

    local topItems = self:GetTopItems(5)
    if #topItems > 0 then
        PH.Logger.Info(PH.L["FARM_TOP_ITEMS"])
        for _, item in ipairs(topItems) do
            PH.Logger.Info(string.format("  %s x%d", item.name, item.count))
        end
    end

    -- Remove all FarmTracker subscriptions at once
    PH.Event:Off("FarmTracker")
    PH.Event:Fire("PH_FARM_STOPPED")
end

function FT:Reset()
    if self.active then self:Stop() end
    self.startTime          = 0
    self.startGold          = 0
    self.currentGold        = 0
    self.itemsLooted        = {}
    self.rawGoldLooted      = 0
    self.vendorLootValue    = 0
    self.estimatedLootValue = 0
    self.goldSnapshots      = {}
    self.lastSnapshot       = 0

    PH.Logger.Info(PH.L["FARM_RESET_MSG"])

    if PH.FarmTrackerFrame then
        PH:UpdateFarmTrackerUI()
    end
end

function FT:Toggle()
    if self.active then
        self:Stop()
    else
        self:Start()
    end
end

-------------------------------------------------------------------------------
-- Calculations
-------------------------------------------------------------------------------

function FT:GetElapsedTime()
    if not self.active or self.startTime == 0 then return 0 end
    return GetTime() - self.startTime
end

function FT:GetGoldEarned()
    if self.startGold == 0 then return 0 end
    return PH.Compat.GetMoney() - self.startGold
end

function FT:GetVendorLootValue()
    return self.vendorLootValue or 0
end

function FT:GetEstimatedLootValue()
    return self.estimatedLootValue or 0
end

function FT:RecalcEstimatedLootValue()
    local vendor, tsm = 0, 0
    for _, data in pairs(self.itemsLooted) do
        if data.vendorPrice and data.vendorPrice > 0 then
            vendor = vendor + (data.vendorPrice * data.count)
        end
        if data.unitPrice and data.unitPrice > 0 then
            tsm = tsm + (data.unitPrice * data.count)
        end
    end
    self.vendorLootValue    = vendor
    self.estimatedLootValue = tsm
end

function FT:CalculateGoldPerHour()
    local elapsed = self:GetElapsedTime()
    if elapsed < 1 then return 0 end
    -- Include estimated loot value (TSM prices) + wallet gold change
    local earned = self:GetGoldEarned() + self:GetEstimatedLootValue()
    -- extrapolate to 1 hour
    return math.floor(earned * (3600 / elapsed))
end

function FT:FormatDuration(seconds)
    if not seconds or seconds < 0 then seconds = 0 end
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = math.floor(seconds % 60)
    if h > 0 then
        return string.format("%dh %02dm %02ds", h, m, s)
    elseif m > 0 then
        return string.format("%dm %02ds", m, s)
    else
        return string.format("%ds", s)
    end
end

function FT:GetTopItems(limit)
    local sorted = {}
    for name, data in pairs(self.itemsLooted) do
        table.insert(sorted, { name = name, count = data.count, icon = data.icon, quality = data.quality, unitPrice = data.unitPrice or 0 })
    end
    table.sort(sorted, function(a, b) return a.count > b.count end)

    local result = {}
    for i = 1, math.min(limit or 10, #sorted) do
        table.insert(result, sorted[i])
    end
    return result
end

-------------------------------------------------------------------------------
-- Event Handler (called by PH.Event subscriptions set up in Start())
-------------------------------------------------------------------------------

function FT:OnEvent(event, ...)
    if not self.active then return end

    if event == "PLAYER_MONEY" then
        self.currentGold = PH.Compat.GetMoney()

        local now = GetTime()
        if now - self.lastSnapshot >= self.snapshotInterval then
            self.lastSnapshot = now
            table.insert(self.goldSnapshots, {
                time = now - self.startTime,
                gold = self:GetGoldEarned(),
            })
            -- Cap to ~3 hours of data (360 × 30s)
            if #self.goldSnapshots > 360 then
                table.remove(self.goldSnapshots, 1)
            end
        end

        if PH.FarmTrackerFrame and PH.FarmTrackerFrame:IsShown() then
            PH:UpdateFarmTrackerUI()
        end

    elseif event == "CHAT_MSG_LOOT" then
        local msg = ...
        local itemLink, countStr

        -- Try all "multiple" templates: regular loot, fishing/pushed (auto-loot), crafted
        local multiTemplates = {
            LOOT_ITEM_SELF_MULTIPLE,
            LOOT_ITEM_PUSHED_SELF_MULTIPLE,  -- fishing with auto-loot / items pushed to bag
            LOOT_ITEM_CREATED_SELF_MULTIPLE, -- crafted (Tailoring, Alchemy, etc.)
        }
        for _, tmpl in ipairs(multiTemplates) do
            if tmpl and not itemLink then
                local pat = tmpl:gsub("%%s", "(.+)"):gsub("%%d", "(%%d+)")
                itemLink, countStr = string.match(msg, pat)
            end
        end

        -- Try all "single" templates
        if not itemLink then
            local singleTemplates = {
                LOOT_ITEM_SELF,
                LOOT_ITEM_PUSHED_SELF,  -- fishing with auto-loot / items pushed to bag
                LOOT_ITEM_CREATED_SELF, -- crafted (Tailoring, Alchemy, etc.)
            }
            for _, tmpl in ipairs(singleTemplates) do
                if tmpl and not itemLink then
                    local pat = tmpl:gsub("%%s", "(.+)")
                    itemLink = string.match(msg, pat)
                end
            end
            -- Hardcoded fallback for non-localized or unknown formats
            if not itemLink then
                itemLink, countStr = string.match(msg, "receive loot: (.+)x(%d+)")
                if not itemLink then
                    itemLink = string.match(msg, "receive loot: (.+)")
                end
            end
            countStr = countStr or "1"
        end

        if itemLink then
            local count    = tonumber(countStr) or 1
            local itemName = PH.Compat.GetItemInfo(itemLink)
            if itemName then
                if not self.itemsLooted[itemName] then
                    local unitPrice = 0
                    local itemID    = tonumber(string.match(itemLink, "item:(%d+)"))
                    if PH.TSM then
                        unitPrice = PH.TSM:GetItemPrice(itemName) or 0
                        if unitPrice == 0 and itemID then
                            unitPrice = PH.TSM:GetItemPriceByID(itemID) or 0
                        end
                    end
                    local _, _, quality, _, _, _, _, _, _, icon, vendorPrice = GetItemInfo(itemLink)
                    self.itemsLooted[itemName] = {
                        count       = 0,
                        icon        = icon,
                        quality     = quality or 1,
                        unitPrice   = unitPrice,
                        vendorPrice = vendorPrice or 0,
                        itemID      = itemID,
                    }
                end
                self.itemsLooted[itemName].count = self.itemsLooted[itemName].count + count
                self:RecalcEstimatedLootValue()
            end
        end

    elseif event == "CHAT_MSG_MONEY" then
        local msg          = ...
        local gold, silver, copper = 0, 0, 0
        if GOLD_AMOUNT then
            local pat  = GOLD_AMOUNT:gsub("%%d", "(%%d+)")
            gold       = tonumber(string.match(msg, pat)) or 0
        end
        if SILVER_AMOUNT then
            local pat  = SILVER_AMOUNT:gsub("%%d", "(%%d+)")
            silver     = tonumber(string.match(msg, pat)) or 0
        end
        if COPPER_AMOUNT then
            local pat  = COPPER_AMOUNT:gsub("%%d", "(%%d+)")
            copper     = tonumber(string.match(msg, pat)) or 0
        end
        self.rawGoldLooted = self.rawGoldLooted + (gold * 10000) + (silver * 100) + copper
    end
end
