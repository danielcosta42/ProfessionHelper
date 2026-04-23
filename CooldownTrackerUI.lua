-- Profession Helper - Cooldown Tracker UI
-- Floating mini-panel listing profession cooldown status

ProfessionHelper = ProfessionHelper or {}
local PH = ProfessionHelper

local FLAT_BG = {
    bgFile   = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\Buttons\\WHITE8X8",
    edgeSize = 1,
}

-------------------------------------------------------------------------------
-- Toggle / refresh
-------------------------------------------------------------------------------

function PH:ShowCooldownUI()
    if self.CooldownFrame then
        if self.CooldownFrame:IsShown() then
            self.CooldownFrame:Hide()
        else
            self.CooldownFrame:Show()
            self:UpdateCooldownUI()
        end
        return
    end

    -----------------------------------------------------------------------
    -- Build frame (first call only)
    -----------------------------------------------------------------------
    local frame = CreateFrame("Frame", "PHCooldownFrame", UIParent, "BackdropTemplate")
    frame:SetSize(240, 30)  -- height adjusted dynamically in UpdateCooldownUI
    frame:SetPoint("CENTER", UIParent, "CENTER", 220, 80)
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

    -- Header bar
    local hdr = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    hdr:SetHeight(24)
    hdr:SetPoint("TOPLEFT",  1, -1)
    hdr:SetPoint("TOPRIGHT", -1, -1)
    hdr:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8" })
    hdr:SetBackdropColor(0.08, 0.08, 0.11, 1)

    local titleLbl = hdr:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    titleLbl:SetPoint("LEFT", 8, 0)
    titleLbl:SetText("|cffffd700Profession Cooldowns|r")

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

    -- Content container
    local content = CreateFrame("Frame", nil, frame)
    content:SetPoint("TOPLEFT",     8, -30)
    content:SetPoint("BOTTOMRIGHT", -8,   6)
    frame.content = content

    -- Row pool (FontStrings, reused on refresh)
    frame.rowPool = {}

    self.CooldownFrame = frame
    self:UpdateCooldownUI()
end

-------------------------------------------------------------------------------
-- Refresh
-------------------------------------------------------------------------------

function PH:UpdateCooldownUI()
    local frame = self.CooldownFrame
    if not frame or not frame:IsShown() then return end
    if not PH.CooldownTracker then return end

    local content = frame.content

    -- Hide old rows
    for _, fs in ipairs(frame.rowPool) do
        fs:Hide()
    end

    local cds   = PH.CooldownTracker:GetAllForCurrentChar()
    local rowH  = 18
    local totalH = 30 + #cds * (rowH + 3) + 8
    frame:SetHeight(totalH)

    -- Group rows by category
    local shown = 0
    local lastCategory = nil
    local yOff = 0

    for _, cd in ipairs(cds) do
        -- Category separator label
        if cd.category ~= lastCategory then
            lastCategory = cd.category
            local catLabel = frame.rowPool[shown + 1]
            if not catLabel then
                catLabel = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                frame.rowPool[#frame.rowPool + 1] = catLabel
            end
            catLabel:ClearAllPoints()
            catLabel:SetPoint("TOPLEFT", 0, yOff)
            catLabel:SetText("|cff4da6ff" .. cd.category .. "|r")
            catLabel:Show()
            shown = shown + 1
            yOff  = yOff - (rowH + 1)
            -- Expand frame height for extra category row
            totalH = totalH + rowH + 1
            frame:SetHeight(totalH)
        end

        -- CD row
        local row = frame.rowPool[shown + 1]
        if not row then
            row = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            frame.rowPool[#frame.rowPool + 1] = row
        end
        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", 8, yOff)
        local status = PH.CooldownTracker:FormatRemaining(cd.remaining)
        row:SetText(string.format("|cff8e8e93%s:|r  %s", cd.label, status))
        row:Show()

        shown = shown + 1
        yOff  = yOff - (rowH + 3)
    end
end
