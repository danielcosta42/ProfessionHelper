-- Profession Helper - Alt Manager UI
-- Floating panel listing all known characters and their profession levels

ProfessionHelper = ProfessionHelper or {}
local PH = ProfessionHelper

local FLAT_BG = {
    bgFile   = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\Buttons\\WHITE8X8",
    edgeSize = 1,
}

-- Skill level tier thresholds for TBC (max 375)
local function SkillColor(skill, maxSkill)
    local pct = skill / (maxSkill or 375)
    if pct >= 1.0        then return "|cff00ff00" end   -- maxed: green
    if pct >= 0.80       then return "|cfffff569" end   -- near max: yellow
    if pct >= 0.50       then return "|cffff8800" end   -- mid: orange
    return "|cffcc4444"                                  -- low: red
end

-------------------------------------------------------------------------------
-- Toggle / open
-------------------------------------------------------------------------------

function PH:ShowAltManagerUI()
    if self.AltManagerFrame then
        if self.AltManagerFrame:IsShown() then
            self.AltManagerFrame:Hide()
        else
            self.AltManagerFrame:Show()
            self:UpdateAltManagerUI()
        end
        return
    end

    -----------------------------------------------------------------------
    -- Build frame
    -----------------------------------------------------------------------
    local frame = CreateFrame("Frame", "PHAltManagerFrame", UIParent, "BackdropTemplate")
    frame:SetSize(320, 420)
    frame:SetPoint("CENTER")
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
    titleLbl:SetText("|cffffd700Alt Professions|r")

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

    -- Realm label
    local realmLbl = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    realmLbl:SetPoint("TOPLEFT", 10, -30)
    frame.realmLbl = realmLbl

    -- Scroll area
    local sf = CreateFrame("ScrollFrame", "PHAltManagerScroll", frame, "UIPanelScrollFrameTemplate")
    sf:SetPoint("TOPLEFT",     8,  -44)
    sf:SetPoint("BOTTOMRIGHT", -26,  6)
    local child = CreateFrame("Frame", "PHAltManagerScrollChild", sf)
    child:SetWidth(sf:GetWidth())
    child:SetHeight(1)
    sf:SetScrollChild(child)
    frame.scrollChild = child

    frame.textPool = {}

    self.AltManagerFrame = frame
    self:UpdateAltManagerUI()
end

-------------------------------------------------------------------------------
-- Refresh
-------------------------------------------------------------------------------

function PH:UpdateAltManagerUI()
    local frame = self.AltManagerFrame
    if not frame or not frame:IsShown() then return end
    if not PH.AltManager then return end

    local realm = GetRealmName() or "?"
    frame.realmLbl:SetText("|cff8e8e93Realm: |r|cff30a5ff" .. realm .. "|r")

    -- Hide old text objects
    for _, t in ipairs(frame.textPool) do t:Hide() end

    local chars = PH.AltManager:GetAllCharsOnRealm()
    local child = frame.scrollChild
    local yOff  = 0
    local idx   = 0

    local function GetText(n)
        if not frame.textPool[n] then
            frame.textPool[n] = child:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        end
        return frame.textPool[n]
    end

    if #chars == 0 then
        idx = idx + 1
        local t = GetText(idx)
        t:ClearAllPoints()
        t:SetPoint("TOPLEFT", 0, yOff)
        t:SetText("|cff8e8e93No characters seen yet. Log into each alt first.|r")
        t:Show()
        child:SetHeight(20)
        return
    end

    for _, char in ipairs(chars) do
        local classColor = PH.AltManager.CLASS_COLORS[char.class] or "CCCCCC"
        local nameText   = string.format("|cff%s%s|r  |cff8e8e93Lv%d  %s|r  |cff555555(%s)|r",
            classColor, char.name, char.level, char.faction,
            PH.AltManager:FormatLastSeen(char.lastSeen))

        -- Character name row
        idx = idx + 1
        local nameRow = GetText(idx)
        nameRow:ClearAllPoints()
        nameRow:SetPoint("TOPLEFT", 0, yOff)
        nameRow:SetJustifyH("LEFT")
        nameRow:SetText(nameText)
        nameRow:Show()
        yOff = yOff - 18

        -- Professions rows
        if char.professions and #char.professions > 0 then
            for _, prof in ipairs(char.professions) do
                idx = idx + 1
                local profRow = GetText(idx)
                profRow:ClearAllPoints()
                profRow:SetPoint("TOPLEFT", 14, yOff)
                profRow:SetJustifyH("LEFT")
                local col = SkillColor(prof.skill, prof.maxSkill)
                profRow:SetText(string.format("|cff8e8e93%s:|r  %s%d/%d|r",
                    prof.name, col, prof.skill, prof.maxSkill))
                profRow:Show()
                yOff = yOff - 16
            end
        else
            idx = idx + 1
            local noProf = GetText(idx)
            noProf:ClearAllPoints()
            noProf:SetPoint("TOPLEFT", 14, yOff)
            noProf:SetText("|cff555555No professions.|r")
            noProf:Show()
            yOff = yOff - 16
        end

        -- Separator
        yOff = yOff - 6
    end

    child:SetHeight(math.abs(yOff) + 8)
end
