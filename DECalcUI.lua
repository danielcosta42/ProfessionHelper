-- Profession Helper - Disenchant & Prospecting Calculator UI
-- Floating panel with tab selection for DE vs Prospect mode

ProfessionHelper = ProfessionHelper or {}
local PH = ProfessionHelper

local FLAT_BG = {
    bgFile   = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\Buttons\\WHITE8X8",
    edgeSize = 1,
}

-- Quality localised labels (TBC)
local QUALITY_LABELS = {
    { key="uncommon", label="Uncommon (Green)",  color="|cff1eff00" },
    { key="rare",     label="Rare (Blue)",        color="|cff0070dd" },
    { key="epic",     label="Epic (Purple)",      color="|cffa335ee" },
}

-- ilvl brackets available per quality (mid-points for display)
local DE_ILVL_OPTIONS = {
    uncommon = { "1-15", "16-20", "21-25", "26-30", "31-35", "36-45", "46-56", "57-60", "61-70" },
    rare     = { "1-20", "21-30", "31-45", "46-60", "61-70" },
    epic     = { "1-60", "61-70" },
}

-- Map bracket label → ilvl value to pass to CalcDisenchant (use midpoint)
local function IlvlFromLabel(label)
    local lo, hi = label:match("(%d+)-(%d+)")
    if lo and hi then return math.floor((tonumber(lo) + tonumber(hi)) / 2) end
    return tonumber(label) or 60
end

-------------------------------------------------------------------------------
-- Toggle / open
-------------------------------------------------------------------------------

function PH:ShowDECalcUI()
    if self.DECalcFrame then
        if self.DECalcFrame:IsShown() then
            self.DECalcFrame:Hide()
        else
            self.DECalcFrame:Show()
            self:UpdateDECalcUI()
        end
        return
    end

    -----------------------------------------------------------------------
    -- Build frame
    -----------------------------------------------------------------------
    local frame = CreateFrame("Frame", "PHDECalcFrame", UIParent, "BackdropTemplate")
    frame:SetSize(310, 480)
    frame:SetPoint("CENTER", UIParent, "CENTER", 240, 0)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:SetClampedToScreen(true)
    frame:SetFrameStrata("HIGH")
    frame:SetBackdrop(FLAT_BG)
    frame:SetBackdropColor(0.06, 0.06, 0.08, 0.97)
    frame:SetBackdropBorderColor(0.18, 0.18, 0.22, 1)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop",  frame.StopMovingOrSizing)

    -- Header
    local hdr = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    hdr:SetHeight(24)
    hdr:SetPoint("TOPLEFT",  1, -1)
    hdr:SetPoint("TOPRIGHT", -1, -1)
    hdr:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8" })
    hdr:SetBackdropColor(0.08, 0.08, 0.11, 1)

    local titleLbl = hdr:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    titleLbl:SetPoint("LEFT", 8, 0)
    titleLbl:SetText("|cffffd700DE / Prospect Calculator|r")

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

    -----------------------------------------------------------------------
    -- Mode tabs: Disenchant / Prospect
    -----------------------------------------------------------------------
    local modeDE   = "de"
    local modeProsp = "prospect"
    frame._mode = modeDE

    local function MakeTabBtn(parent, label, yPos, mode)
        local btn = CreateFrame("Button", nil, parent, "BackdropTemplate")
        btn:SetSize(90, 20)
        btn:SetPoint("TOPLEFT", yPos, -28)
        btn:SetBackdrop(FLAT_BG)
        btn:SetBackdropColor(0.08, 0.08, 0.11, 1)
        btn:SetBackdropBorderColor(0.25, 0.25, 0.30, 1)
        local lbl = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        lbl:SetPoint("CENTER")
        lbl:SetText(label)
        btn._mode = mode
        btn._lbl  = lbl
        return btn
    end

    local tabDE    = MakeTabBtn(frame, "Disenchant", 8,  modeDE)
    local tabProsp = MakeTabBtn(frame, "Prospecting", 102, modeProsp)

    local function ActivateTab(mode)
        frame._mode = mode
        -- Visual: highlight active tab
        if mode == modeDE then
            tabDE:SetBackdropBorderColor(0.30, 0.65, 1.0, 1)
            tabProsp:SetBackdropBorderColor(0.25, 0.25, 0.30, 1)
        else
            tabProsp:SetBackdropBorderColor(0.30, 0.65, 1.0, 1)
            tabDE:SetBackdropBorderColor(0.25, 0.25, 0.30, 1)
        end
        PH:UpdateDECalcUI()
    end

    tabDE:SetScript("OnClick",    function() ActivateTab(modeDE)    end)
    tabProsp:SetScript("OnClick", function() ActivateTab(modeProsp) end)
    frame.tabDE    = tabDE
    frame.tabProsp = tabProsp

    -----------------------------------------------------------------------
    -- Controls area (dropdowns simulated as cycle buttons)
    -----------------------------------------------------------------------
    local ctrlY = -56

    -- Row 1: Quality selector (DE only)
    local qualLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    qualLabel:SetPoint("TOPLEFT", 10, ctrlY)
    qualLabel:SetText("|cff8e8e93Quality:|r")
    frame.qualLabel = qualLabel

    local qualBtn = CreateFrame("Button", nil, frame, "BackdropTemplate")
    qualBtn:SetSize(160, 20)
    qualBtn:SetPoint("TOPLEFT", 80, ctrlY)
    qualBtn:SetBackdrop(FLAT_BG)
    qualBtn:SetBackdropColor(0.10, 0.10, 0.13, 1)
    qualBtn:SetBackdropBorderColor(0.25, 0.25, 0.30, 1)
    local qualBtnLbl = qualBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    qualBtnLbl:SetPoint("LEFT", 6, 0)
    frame.qualBtnLbl = qualBtnLbl
    frame._qualIdx = 1  -- index into QUALITY_LABELS

    qualBtn:SetScript("OnClick", function()
        frame._qualIdx = (frame._qualIdx % #QUALITY_LABELS) + 1
        frame._ilvlIdx = 1  -- reset ilvl when quality changes
        PH:UpdateDECalcUI()
    end)
    frame.qualBtn = qualBtn

    -- Row 2: ILvl bracket selector (DE) / Ore selector (Prospect)
    ctrlY = ctrlY - 26
    local bracketLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    bracketLabel:SetPoint("TOPLEFT", 10, ctrlY)
    bracketLabel:SetText("|cff8e8e93iLvl:|r")
    frame.bracketLabel = bracketLabel

    local bracketBtn = CreateFrame("Button", nil, frame, "BackdropTemplate")
    bracketBtn:SetSize(160, 20)
    bracketBtn:SetPoint("TOPLEFT", 80, ctrlY)
    bracketBtn:SetBackdrop(FLAT_BG)
    bracketBtn:SetBackdropColor(0.10, 0.10, 0.13, 1)
    bracketBtn:SetBackdropBorderColor(0.25, 0.25, 0.30, 1)
    local bracketBtnLbl = bracketBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    bracketBtnLbl:SetPoint("LEFT", 6, 0)
    frame.bracketBtnLbl = bracketBtnLbl
    frame._ilvlIdx = 1
    frame._oreIdx  = 1

    bracketBtn:SetScript("OnClick", function()
        if frame._mode == modeDE then
            local q = QUALITY_LABELS[frame._qualIdx].key
            local opts = DE_ILVL_OPTIONS[q] or {}
            frame._ilvlIdx = (frame._ilvlIdx % #opts) + 1
        else
            local ores = PH.DECalc:GetProspectableOres()
            frame._oreIdx = (frame._oreIdx % #ores) + 1
        end
        PH:UpdateDECalcUI()
    end)
    frame.bracketBtn = bracketBtn

    -- Row 3: Count input
    ctrlY = ctrlY - 26
    local countLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    countLabel:SetPoint("TOPLEFT", 10, ctrlY)
    countLabel:SetText("|cff8e8e93Count:|r")
    frame.countLabel = countLabel

    local countEB = CreateFrame("EditBox", "PHDECalcCountEB", frame, "InputBoxTemplate")
    countEB:SetSize(60, 20)
    countEB:SetPoint("TOPLEFT", 80, ctrlY + 2)
    countEB:SetAutoFocus(false)
    countEB:SetMaxLetters(4)
    countEB:SetNumeric(true)
    countEB:SetText("20")
    countEB:SetScript("OnEnterPressed", function(self) self:ClearFocus(); PH:UpdateDECalcUI() end)
    countEB:SetScript("OnTabPressed",   function(self) self:ClearFocus(); PH:UpdateDECalcUI() end)
    frame.countEB = countEB

    local calcBtn = CreateFrame("Button", nil, frame, "BackdropTemplate")
    calcBtn:SetSize(60, 20)
    calcBtn:SetPoint("LEFT", countEB, "RIGHT", 8, 0)
    calcBtn:SetBackdrop(FLAT_BG)
    calcBtn:SetBackdropColor(0.10, 0.30, 0.10, 1)
    calcBtn:SetBackdropBorderColor(0.20, 0.65, 0.20, 1)
    local calcLbl = calcBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    calcLbl:SetPoint("CENTER")
    calcLbl:SetText("|cff00ff00Calc|r")
    calcBtn:SetScript("OnClick", function() PH:UpdateDECalcUI() end)

    -- Separator
    ctrlY = ctrlY - 30
    local sep = frame:CreateTexture(nil, "ARTWORK")
    sep:SetHeight(1)
    sep:SetPoint("TOPLEFT",  8, ctrlY)
    sep:SetPoint("TOPRIGHT", -8, ctrlY)
    sep:SetColorTexture(0.18, 0.18, 0.22, 1)

    -- Results scroll
    local sf = CreateFrame("ScrollFrame", "PHDECalcScroll", frame, "UIPanelScrollFrameTemplate")
    sf:SetPoint("TOPLEFT",     8,  ctrlY - 6)
    sf:SetPoint("BOTTOMRIGHT", -26, 6)
    local child = CreateFrame("Frame", "PHDECalcScrollChild", sf)
    child:SetWidth(sf:GetWidth())
    child:SetHeight(1)
    sf:SetScrollChild(child)
    frame.resultChild = child
    frame.resultPool  = {}

    -- Activate DE tab visually
    ActivateTab(modeDE)

    self.DECalcFrame = frame
    self:UpdateDECalcUI()
end

-------------------------------------------------------------------------------
-- Refresh
-------------------------------------------------------------------------------

function PH:UpdateDECalcUI()
    local frame = self.DECalcFrame
    if not frame or not frame:IsShown() then return end
    if not PH.DECalc then return end

    local mode   = frame._mode
    local count  = tonumber(frame.countEB:GetText()) or 20
    if count < 1 then count = 1 end

    -- Hide old result rows
    for _, t in ipairs(frame.resultPool) do t:Hide() end

    local child = frame.resultChild
    local yOff  = 0
    local idx   = 0
    local function GetRow(n)
        if not frame.resultPool[n] then
            frame.resultPool[n] = child:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        end
        return frame.resultPool[n]
    end

    if mode == "de" then
        -- Update quality button label
        local qual = QUALITY_LABELS[frame._qualIdx]
        frame.qualBtnLbl:SetText(qual.color .. qual.label .. "|r")
        frame.qualLabel:Show()
        frame.qualBtn:Show()
        frame.bracketLabel:SetText("|cff8e8e93iLvl:|r")

        -- Update bracket button label
        local opts = DE_ILVL_OPTIONS[qual.key] or {}
        if frame._ilvlIdx > #opts then frame._ilvlIdx = 1 end
        local bracketStr = opts[frame._ilvlIdx] or "61-70"
        frame.bracketBtnLbl:SetText(bracketStr)

        local ilvl = IlvlFromLabel(bracketStr)
        local results = PH.DECalc:CalcDisenchant(qual.key, ilvl, count)

        -- Header
        idx = idx + 1
        local hRow = GetRow(idx)
        hRow:ClearAllPoints()
        hRow:SetPoint("TOPLEFT", 0, yOff)
        hRow:SetText(string.format(
            "|cff8e8e93Expected output from %dx %s ilvl %s:|r",
            count, qual.label, bracketStr))
        hRow:Show()
        yOff = yOff - 22

        if #results == 0 then
            idx = idx + 1
            local noRow = GetRow(idx)
            noRow:ClearAllPoints()
            noRow:SetPoint("TOPLEFT", 0, yOff)
            noRow:SetText("|cffff4444No data for this combination.|r")
            noRow:Show()
            child:SetHeight(50)
            return
        end

        for _, r in ipairs(results) do
            idx = idx + 1
            local row = GetRow(idx)
            row:ClearAllPoints()
            row:SetPoint("TOPLEFT", 8, yOff)
            row:SetJustifyH("LEFT")
            local priceNote = ""
            if PH.TSM then
                local p = PH.TSM:GetItemPrice(r.name) or 0
                if p > 0 then
                    local totalVal = math.floor(p * r.expectedQty)
                    priceNote = "  |cffffd700" .. PH.TSM:FormatMoney(totalVal) .. "|r"
                end
            end
            row:SetText(string.format("|cffcccccc%s|r  ×%.1f  |cff8e8e93(%.0f%%)|r%s",
                r.name, r.expectedQty, r.chance * 100, priceNote))
            row:Show()
            yOff = yOff - 18
        end

    else
        -- Prospect mode
        frame.qualLabel:Hide()
        frame.qualBtn:Hide()
        frame.bracketLabel:SetText("|cff8e8e93Ore:|r")

        local ores = PH.DECalc:GetProspectableOres()
        if frame._oreIdx > #ores then frame._oreIdx = 1 end
        local oreName = ores[frame._oreIdx]
        frame.bracketBtnLbl:SetText(oreName)

        -- count here = number of stacks (5 ore each)
        local results = PH.DECalc:CalcProspect(oreName, count)

        idx = idx + 1
        local hRow = GetRow(idx)
        hRow:ClearAllPoints()
        hRow:SetPoint("TOPLEFT", 0, yOff)
        hRow:SetText(string.format("|cff8e8e93Expected from %dx %s (5-ore each):|r", count, oreName))
        hRow:Show()
        yOff = yOff - 22

        for _, r in ipairs(results) do
            idx = idx + 1
            local row = GetRow(idx)
            row:ClearAllPoints()
            row:SetPoint("TOPLEFT", 8, yOff)
            row:SetJustifyH("LEFT")
            local priceNote = ""
            if PH.TSM then
                local p = PH.TSM:GetItemPrice(r.name) or 0
                if p > 0 then
                    local totalVal = math.floor(p * r.expectedQty)
                    priceNote = "  |cffffd700" .. PH.TSM:FormatMoney(totalVal) .. "|r"
                end
            end
            row:SetText(string.format("|cffcccccc%s|r  ×%.2f  |cff8e8e93(%.0f%% ea)|r%s",
                r.name, r.expectedQty, r.rate * 100, priceNote))
            row:Show()
            yOff = yOff - 18
        end
    end

    child:SetHeight(math.abs(yOff) + 8)
end
