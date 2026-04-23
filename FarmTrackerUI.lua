-- Profession Helper - Farm Tracker UI
-- Premium minimalist floating widget (matches main UI style)

ProfessionHelper = ProfessionHelper or {}
local PH = ProfessionHelper
local FT = PH.FarmTracker

-- Flat backdrop helper (same pattern as main UI)
local FLAT_BG = {
    bgFile   = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\Buttons\\WHITE8X8",
    edgeSize = 1,
}

-------------------------------------------------------------------------------
-- Floating Tracker Window
-------------------------------------------------------------------------------

function PH:ShowFarmTrackerUI()
    if self.FarmTrackerFrame then
        self.FarmTrackerFrame:Show()
        self:UpdateFarmTrackerUI()
        return
    end

    local frame = CreateFrame("Frame", "ProfessionHelperFarmTracker", UIParent, "BackdropTemplate")
    frame:SetSize(260, 200)
    frame:SetPoint("TOPRIGHT", -80, -200)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:SetClampedToScreen(true)
    frame:SetFrameStrata("HIGH")
    frame:SetBackdrop(FLAT_BG)
    frame:SetBackdropColor(0.06, 0.06, 0.08, 0.97)
    frame:SetBackdropBorderColor(0.18, 0.18, 0.22, 1)

    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

    -- Shadow
    local shadow = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    shadow:SetPoint("TOPLEFT", -2, 2)
    shadow:SetPoint("BOTTOMRIGHT", 2, -2)
    shadow:SetFrameLevel(frame:GetFrameLevel() - 1)
    shadow:SetBackdrop({
        bgFile   = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 2,
    })
    shadow:SetBackdropColor(0, 0, 0, 0.5)
    shadow:SetBackdropBorderColor(0, 0, 0, 0.35)

    ---------------------------------------------------------------------------
    -- Header bar
    ---------------------------------------------------------------------------
    local hdr = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    hdr:SetHeight(24)
    hdr:SetPoint("TOPLEFT", 1, -1)
    hdr:SetPoint("TOPRIGHT", -1, -1)
    hdr:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8" })
    hdr:SetBackdropColor(0.08, 0.08, 0.11, 1)

    local titleText = hdr:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    titleText:SetPoint("LEFT", 8, 0)
    titleText:SetText("|cffffd700Farm Tracker|r")

    -- Close button (text-based, flat)
    local closeBtn = CreateFrame("Button", nil, hdr)
    closeBtn:SetSize(20, 20)
    closeBtn:SetPoint("RIGHT", -2, 0)
    local closeLbl = closeBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    closeLbl:SetPoint("CENTER", 0, 1)
    closeLbl:SetText("|cff888888x|r")
    local closeHL = closeBtn:CreateTexture(nil, "HIGHLIGHT")
    closeHL:SetAllPoints()
    closeHL:SetColorTexture(0.9, 0.25, 0.25, 0.25)
    closeBtn:SetScript("OnClick", function() frame:Hide() end)

    -- Stop/Start toggle button (flat)
    local toggleBtn = CreateFrame("Button", nil, hdr, "BackdropTemplate")
    toggleBtn:SetSize(50, 18)
    toggleBtn:SetPoint("RIGHT", closeBtn, "LEFT", -4, 0)
    toggleBtn:SetBackdrop(FLAT_BG)
    toggleBtn:SetBackdropColor(0.9, 0.25, 0.25, 0.15)
    toggleBtn:SetBackdropBorderColor(0.9, 0.25, 0.25, 0.4)
    local toggleLabel = toggleBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    toggleLabel:SetPoint("CENTER")
    toggleLabel:SetText("|cffffffff" .. PH.L["FARM_BTN_STOP"] .. "|r")
    local toggleHL = toggleBtn:CreateTexture(nil, "HIGHLIGHT")
    toggleHL:SetAllPoints()
    toggleHL:SetColorTexture(0.9, 0.25, 0.25, 0.12)
    frame.toggleBtn = toggleBtn
    frame.toggleLabel = toggleLabel

    toggleBtn:SetScript("OnClick", function()
        FT:Toggle()
        PH:UpdateFarmTrackerUI()
    end)

    -- Reset button (flat)
    local resetBtn = CreateFrame("Button", nil, hdr, "BackdropTemplate")
    resetBtn:SetSize(46, 18)
    resetBtn:SetPoint("RIGHT", toggleBtn, "LEFT", -4, 0)
    resetBtn:SetBackdrop(FLAT_BG)
    resetBtn:SetBackdropColor(1.0, 0.6, 0.2, 0.12)
    resetBtn:SetBackdropBorderColor(1.0, 0.6, 0.2, 0.3)
    local resetLabel = resetBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    resetLabel:SetPoint("CENTER")
    resetLabel:SetText("|cffffffffReset|r")
    local resetHL = resetBtn:CreateTexture(nil, "HIGHLIGHT")
    resetHL:SetAllPoints()
    resetHL:SetColorTexture(1.0, 0.6, 0.2, 0.12)

    resetBtn:SetScript("OnClick", function()
        FT:Reset()
        PH:UpdateFarmTrackerUI()
    end)

    ---------------------------------------------------------------------------
    -- Content area
    ---------------------------------------------------------------------------
    local content = CreateFrame("Frame", nil, frame)
    content:SetPoint("TOPLEFT", 10, -30)
    content:SetPoint("BOTTOMRIGHT", -10, 8)
    frame.content = content

    -- Gold Per Hour (hero stat)
    local gphLabel = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    gphLabel:SetPoint("TOPLEFT", 0, 0)
    gphLabel:SetText("|cff8e8e93" .. PH.L["FARM_GPH_LABEL"] .. "|r")

    local gphValue = content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    gphValue:SetPoint("TOPLEFT", 0, -12)
    gphValue:SetText("|cffffd7000g 0s 0c|r")
    frame.gphValue = gphValue

    -- Separator
    local sep1 = content:CreateTexture(nil, "ARTWORK")
    sep1:SetHeight(1)
    sep1:SetPoint("TOPLEFT", 0, -32)
    sep1:SetPoint("TOPRIGHT", 0, -32)
    sep1:SetColorTexture(0.18, 0.18, 0.22, 0.6)

    -- Stats rows (anchored chain)
    local statsY = -38

    -- Duration
    local durLabel = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    durLabel:SetPoint("TOPLEFT", 0, statsY)
    durLabel:SetText("|cff8e8e93" .. PH.L["FARM_DURATION_LABEL"] .. "|r")

    local durValue = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    durValue:SetPoint("TOPRIGHT", 0, statsY)
    durValue:SetJustifyH("RIGHT")
    durValue:SetText("0s")
    frame.durValue = durValue

    -- Total Gold (wallet)
    local totalLabel = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    totalLabel:SetPoint("TOPLEFT", 0, statsY - 15)
    totalLabel:SetText("|cffffd700" .. PH.L["FARM_TOTAL_GOLD_LABEL"] .. "|r")

    local totalValue = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    totalValue:SetPoint("TOPRIGHT", 0, statsY - 15)
    totalValue:SetJustifyH("RIGHT")
    totalValue:SetText("0g")
    frame.totalValue = totalValue

    -- Raw Gold (from mob drops)
    local rawLabel = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    rawLabel:SetPoint("TOPLEFT", 0, statsY - 30)
    rawLabel:SetText("|cff8e8e93" .. PH.L["FARM_MOB_GOLD_LABEL"] .. "|r")

    local rawValue = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    rawValue:SetPoint("TOPRIGHT", 0, statsY - 30)
    rawValue:SetJustifyH("RIGHT")
    rawValue:SetText("0g")
    frame.rawValue = rawValue

    -- Estimated Loot Value (TSM)
    local estLabel = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    estLabel:SetPoint("TOPLEFT", 0, statsY - 45)
    estLabel:SetText("|cff4dda5d" .. PH.L["FARM_EST_VALUE_LABEL"] .. "|r")

    local estValue = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    estValue:SetPoint("TOPRIGHT", 0, statsY - 45)
    estValue:SetJustifyH("RIGHT")
    estValue:SetText("0g")
    frame.estValue = estValue

    -- Separator
    local sep2 = content:CreateTexture(nil, "ARTWORK")
    sep2:SetHeight(1)
    sep2:SetPoint("TOPLEFT", 0, statsY - 59)
    sep2:SetPoint("TOPRIGHT", 0, statsY - 59)
    sep2:SetColorTexture(0.18, 0.18, 0.22, 0.6)

    -- Items header
    local itemsLabel = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    itemsLabel:SetPoint("TOPLEFT", 0, statsY - 65)
    itemsLabel:SetText("|cff4da6ff" .. PH.L["FARM_ITEMS_FARMED_LABEL"] .. "|r")
    frame.itemsLabel = itemsLabel

    -- Item rows (pool of 8)
    frame.itemRows = {}
    for i = 1, 8 do
        local rowY = statsY - 65 - (i * 15)

        local rowFrame = CreateFrame("Frame", nil, content)
        rowFrame:SetHeight(14)
        rowFrame:SetPoint("TOPLEFT", 2, rowY)
        rowFrame:SetPoint("RIGHT", -2, 0)

        local itemIcon = rowFrame:CreateTexture(nil, "ARTWORK")
        itemIcon:SetSize(12, 12)
        itemIcon:SetPoint("LEFT", 0, 0)
        itemIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        rowFrame.icon = itemIcon

        local itemName = rowFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        itemName:SetPoint("LEFT", itemIcon, "RIGHT", 4, 0)
        itemName:SetWidth(140)
        itemName:SetJustifyH("LEFT")
        rowFrame.name = itemName

        local itemCount = rowFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        itemCount:SetPoint("RIGHT", 0, 0)
        itemCount:SetJustifyH("RIGHT")
        rowFrame.count = itemCount

        rowFrame:Hide()
        frame.itemRows[i] = rowFrame
    end

    -- Trend indicator (bottom-left)
    local trendLabel = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    trendLabel:SetPoint("BOTTOMLEFT", 0, 0)
    trendLabel:SetText("")
    frame.trendLabel = trendLabel

    -- Status indicator (bottom-right)
    local statusDot = content:CreateTexture(nil, "OVERLAY")
    statusDot:SetSize(8, 8)
    statusDot:SetPoint("BOTTOMRIGHT", 0, 2)
    statusDot:SetColorTexture(0.3, 0.85, 0.45, 1)
    frame.statusDot = statusDot

    local statusText = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    statusText:SetPoint("RIGHT", statusDot, "LEFT", -4, 0)
    statusText:SetText("|cff4dda5d" .. PH.L["FARM_STATUS_ACTIVE"] .. "|r")
    frame.statusText = statusText

    self.FarmTrackerFrame = frame

    -- Start update ticker
    self:StartFarmTrackerTicker()

    -- Resize to fit content
    self:UpdateFarmTrackerUI()
end

-------------------------------------------------------------------------------
-- Update the tracker display
-------------------------------------------------------------------------------

function PH:UpdateFarmTrackerUI()
    local frame = self.FarmTrackerFrame
    if not frame then return end

    local isActive = FT.active

    -- Toggle button state
    if isActive then
        frame.toggleBtn:SetBackdropColor(0.9, 0.25, 0.25, 0.15)
        frame.toggleBtn:SetBackdropBorderColor(0.9, 0.25, 0.25, 0.4)
        frame.toggleLabel:SetText("|cffffffff" .. PH.L["FARM_BTN_STOP"] .. "|r")
        frame.statusDot:SetColorTexture(0.3, 0.85, 0.45, 1)
        frame.statusText:SetText("|cff4dda5d" .. PH.L["FARM_STATUS_ACTIVE"] .. "|r")
    else
        frame.toggleBtn:SetBackdropColor(0.3, 0.85, 0.45, 0.12)
        frame.toggleBtn:SetBackdropBorderColor(0.3, 0.85, 0.45, 0.3)
        frame.toggleLabel:SetText("|cffffffff" .. PH.L["FARM_BTN_START"] .. "|r")
        frame.statusDot:SetColorTexture(0.55, 0.55, 0.60, 1)
        frame.statusText:SetText("|cff8e8e93" .. PH.L["FARM_STATUS_STOPPED"] .. "|r")
    end

    -- Gold per hour
    local gph = FT:CalculateGoldPerHour()
    frame.gphValue:SetText(PH.TSM:FormatMoney(gph))

    -- Duration
    local elapsed = FT:GetElapsedTime()
    frame.durValue:SetText(FT:FormatDuration(elapsed))

    -- Total gold earned (wallet)
    local earned = FT:GetGoldEarned()
    frame.totalValue:SetText(PH.TSM:FormatMoney(earned))

    -- Raw gold from mobs
    frame.rawValue:SetText(PH.TSM:FormatMoney(FT.rawGoldLooted))

    -- Estimated loot value (TSM prices)
    local estLoot = FT:GetEstimatedLootValue()
    frame.estValue:SetText(PH.TSM:FormatMoney(estLoot))

    -- Trend
    local trendText = self:CalculateTrend()
    frame.trendLabel:SetText(trendText)

    -- Items list
    local topItems = FT:GetTopItems(8)
    for i, row in ipairs(frame.itemRows) do
        local item = topItems[i]
        if item then
            if item.icon then
                row.icon:SetTexture(item.icon)
                row.icon:Show()
            else
                row.icon:Hide()
            end

            local qualityColor = "|cffffffff"
            if item.quality == 2 then qualityColor = "|cff1eff00"
            elseif item.quality == 3 then qualityColor = "|cff0070dd"
            elseif item.quality == 4 then qualityColor = "|cffa335ee"
            elseif item.quality == 5 then qualityColor = "|cffff8000"
            end

            row.name:SetText(qualityColor .. item.name .. "|r")
            local valueStr = "|cffffffff" .. item.count .. "|r"
            if item.unitPrice and item.unitPrice > 0 then
                local totalItemGold = math.floor((item.unitPrice * item.count) / 10000)
                if totalItemGold > 0 then
                    valueStr = valueStr .. "  |cffffd700" .. totalItemGold .. "g|r"
                end
            end
            row.count:SetText(valueStr)
            row:Show()
        else
            row:Hide()
        end
    end

    -- Resize frame based on visible item rows
    local visibleItems = math.min(#topItems, 8)
    local baseHeight = 148
    local itemsHeight = visibleItems > 0 and (18 + visibleItems * 15) or 0
    local totalHeight = baseHeight + itemsHeight + 20
    frame:SetHeight(math.max(totalHeight, 168))
end

-------------------------------------------------------------------------------
-- Trend calculation (comparing recent vs older gold rate)
-------------------------------------------------------------------------------

function PH:CalculateTrend()
    local snapshots = FT.goldSnapshots
    if #snapshots < 3 then return "" end

    local midIdx = math.floor(#snapshots / 2)
    if midIdx < 1 then return "" end

    local firstHalf = snapshots[1]
    local midPoint = snapshots[midIdx]
    local lastPoint = snapshots[#snapshots]

    if not firstHalf or not midPoint or not lastPoint then return "" end

    local firstDuration = midPoint.time - firstHalf.time
    local secondDuration = lastPoint.time - midPoint.time

    if firstDuration < 30 or secondDuration < 30 then return "" end

    local firstRate = (midPoint.gold - firstHalf.gold) / firstDuration
    local secondRate = (lastPoint.gold - midPoint.gold) / secondDuration

    if firstRate <= 0 then return "" end

    local change = ((secondRate - firstRate) / math.abs(firstRate)) * 100

    if change > 10 then
        return string.format("|cff4dda5d\226\150\178 +%.0f%%|r", change)
    elseif change < -10 then
        return string.format("|cffe64d4d\226\150\188 %.0f%%|r", change)
    else
        return "|cffffd700~ 0%|r"
    end
end

-------------------------------------------------------------------------------
-- Periodic update ticker (1s while active)
-------------------------------------------------------------------------------

function PH:StartFarmTrackerTicker()
    if self.farmTickerFrame then return end

    local ticker = CreateFrame("Frame")
    local elapsed = 0
    ticker:SetScript("OnUpdate", function(self, dt)
        elapsed = elapsed + dt
        if elapsed >= 1 then
            elapsed = 0
            if FT.active and PH.FarmTrackerFrame and PH.FarmTrackerFrame:IsShown() then
                PH:UpdateFarmTrackerUI()
            end
        end
    end)

    self.farmTickerFrame = ticker
end
