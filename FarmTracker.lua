-- Profession Helper - Farm Session Tracker
-- Tracks gold earned per hour, items looted, and session stats

ProfessionHelper = ProfessionHelper or {}
local PH = ProfessionHelper

PH.FarmTracker = {
    active = false,
    startTime = 0,
    startGold = 0,
    currentGold = 0,
    -- Loot tracking
    itemsLooted = {},  -- { [itemName] = { count, icon, quality, unitPrice, itemID } }
    rawGoldLooted = 0, -- copper from mob drops
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
        PH:Print("Sessão de farm já está ativa! Use |cff00ccff/ph farm stop|r para parar.")
        return
    end

    self.active = true
    self.startTime = GetTime()
    self.startGold = GetMoney()
    self.currentGold = self.startGold
    self.itemsLooted = {}
    self.rawGoldLooted = 0
    self.estimatedLootValue = 0
    self.goldSnapshots = {}
    self.lastSnapshot = GetTime()

    -- Initial snapshot
    table.insert(self.goldSnapshots, { time = 0, gold = 0 })

    PH:Print("|cff00ff00Sessão de farm iniciada!|r Gold inicial: " .. PH.TSM:FormatMoney(self.startGold))

    -- Show tracker UI
    PH:ShowFarmTrackerUI()

    -- Register loot events
    FT:RegisterEvents()
end

function FT:Stop()
    if not self.active then
        PH:Print("Nenhuma sessão de farm ativa.")
        return
    end

    self.active = false
    local elapsed = GetTime() - self.startTime
    local earned = GetMoney() - self.startGold
    local gph = self:CalculateGoldPerHour()

    PH:Print("|cffff0000Sessão de farm encerrada.|r")
    PH:Print(string.format("Duração: %s", self:FormatDuration(elapsed)))
    PH:Print(string.format("Gold ganho: %s", PH.TSM:FormatMoney(earned)))
    PH:Print(string.format("Gold/hora: %s", PH.TSM:FormatMoney(gph)))

    -- Print top items
    local topItems = self:GetTopItems(5)
    if #topItems > 0 then
        PH:Print("Top itens farmados:")
        for _, item in ipairs(topItems) do
            PH:Print(string.format("  %s x%d", item.name, item.count))
        end
    end

    FT:UnregisterEvents()
end

function FT:Reset()
    if self.active then
        self:Stop()
    end
    self.startTime = 0
    self.startGold = 0
    self.currentGold = 0
    self.itemsLooted = {}
    self.rawGoldLooted = 0
    self.estimatedLootValue = 0
    self.goldSnapshots = {}
    self.lastSnapshot = 0

    PH:Print("Sessão de farm resetada.")

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
    return GetMoney() - self.startGold
end

function FT:GetEstimatedLootValue()
    return self.estimatedLootValue or 0
end

function FT:RecalcEstimatedLootValue()
    local total = 0
    for _, data in pairs(self.itemsLooted) do
        if data.unitPrice and data.unitPrice > 0 then
            total = total + (data.unitPrice * data.count)
        end
    end
    self.estimatedLootValue = total
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
-- Event Handling
-------------------------------------------------------------------------------

function FT:RegisterEvents()
    if not self.eventFrame then
        self.eventFrame = CreateFrame("Frame")
    end
    self.eventFrame:RegisterEvent("PLAYER_MONEY")
    self.eventFrame:RegisterEvent("CHAT_MSG_LOOT")
    self.eventFrame:RegisterEvent("CHAT_MSG_MONEY")
    self.eventFrame:SetScript("OnEvent", function(frame, event, ...)
        FT:OnEvent(event, ...)
    end)
end

function FT:UnregisterEvents()
    if self.eventFrame then
        self.eventFrame:UnregisterAllEvents()
    end
end

function FT:OnEvent(event, ...)
    if not self.active then return end

    if event == "PLAYER_MONEY" then
        self.currentGold = GetMoney()

        -- Take periodic snapshot for trend
        local now = GetTime()
        if now - self.lastSnapshot >= self.snapshotInterval then
            self.lastSnapshot = now
            table.insert(self.goldSnapshots, {
                time = now - self.startTime,
                gold = self:GetGoldEarned(),
            })
            -- Cap snapshots to prevent memory bloat (keep last 360 = 3 hours at 30s interval)
            if #self.goldSnapshots > 360 then
                table.remove(self.goldSnapshots, 1)
            end
        end

        -- Update UI
        if PH.FarmTrackerFrame and PH.FarmTrackerFrame:IsShown() then
            PH:UpdateFarmTrackerUI()
        end

    elseif event == "CHAT_MSG_LOOT" then
        local msg = ...
        -- Parse loot message using WoW global string patterns (locale-independent)
        local itemLink, countStr
        -- Try multi-stack pattern first: LOOT_ITEM_SELF_MULTIPLE = "You receive loot: %sx%d."
        if LOOT_ITEM_SELF_MULTIPLE then
            local pat = LOOT_ITEM_SELF_MULTIPLE:gsub("%%s", "(.+)"):gsub("%%d", "(%%d+)")
            itemLink, countStr = string.match(msg, pat)
        end
        if not itemLink then
            -- Single item pattern: LOOT_ITEM_SELF = "You receive loot: %s."
            if LOOT_ITEM_SELF then
                local pat = LOOT_ITEM_SELF:gsub("%%s", "(.+)")
                itemLink = string.match(msg, pat)
            end
            if not itemLink then
                -- Fallback to English
                itemLink, countStr = string.match(msg, "receive loot: (.+)x(%d+)")
                if not itemLink then
                    itemLink = string.match(msg, "receive loot: (.+)")
                end
            end
            countStr = countStr or "1"
        end
        if itemLink then
            local count = tonumber(countStr) or 1
            local itemName, _, itemQuality, _, _, _, _, _, _, itemIcon = GetItemInfo(itemLink)
            if itemName then
                if not self.itemsLooted[itemName] then
                    -- Look up TSM price for this item
                    local unitPrice = 0
                    local itemID = tonumber(string.match(itemLink, "item:(%d+)"))
                    if PH.TSM and PH.TSM.IsAvailable and PH.TSM:IsAvailable() then
                        -- Try by name first (uses Materials table), then by ID
                        unitPrice = PH.TSM:GetItemPrice(itemName) or 0
                        if unitPrice == 0 and itemID and PH.TSM.GetItemPriceByID then
                            unitPrice = PH.TSM:GetItemPriceByID(itemID) or 0
                        end
                    end
                    self.itemsLooted[itemName] = { count = 0, icon = itemIcon, quality = itemQuality or 1, unitPrice = unitPrice, itemID = itemID }
                end
                self.itemsLooted[itemName].count = self.itemsLooted[itemName].count + count
                self:RecalcEstimatedLootValue()
            end
        end

    elseif event == "CHAT_MSG_MONEY" then
        local msg = ...
        -- Parse raw gold drops using locale-aware patterns
        -- WoW provides GOLD_AMOUNT ("%d Gold"), SILVER_AMOUNT ("%d Silver"), COPPER_AMOUNT ("%d Copper")
        local gold, silver, copper = 0, 0, 0
        if GOLD_AMOUNT then
            local gPat = GOLD_AMOUNT:gsub("%%d", "(%%d+)")
            gold = tonumber(string.match(msg, gPat)) or 0
        end
        if SILVER_AMOUNT then
            local sPat = SILVER_AMOUNT:gsub("%%d", "(%%d+)")
            silver = tonumber(string.match(msg, sPat)) or 0
        end
        if COPPER_AMOUNT then
            local cPat = COPPER_AMOUNT:gsub("%%d", "(%%d+)")
            copper = tonumber(string.match(msg, cPat)) or 0
        end
        local total = (gold * 10000) + (silver * 100) + copper
        self.rawGoldLooted = self.rawGoldLooted + total
    end
end
