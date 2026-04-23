-- Profession Helper - Recipe Tracker UI
-- Floating panel that shows missing recipes for a profession

ProfessionHelper = ProfessionHelper or {}
local PH = ProfessionHelper

local FLAT_BG = {
    bgFile   = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\Buttons\\WHITE8X8",
    edgeSize = 1,
}

-- Source colour coding
local SOURCE_COLORS = {
    ["Trainer"]     = "|cff8e8e93",   -- grey  (easy)
    ["Drop"]        = "|cffff8800",   -- orange
    ["World Drop"]  = "|cffff4500",   -- red-orange
    ["Vendor"]      = "|cffffff00",   -- yellow
    ["Quest"]       = "|cff00ccff",   -- blue
    ["Reputation"]  = "|cff00ff7f",   -- green
    ["Crafted"]     = "|cffcc88ff",   -- purple
}
local function SourceColor(src)
    return SOURCE_COLORS[src] or "|cffcccccc"
end

-------------------------------------------------------------------------------
-- Toggle / open
-------------------------------------------------------------------------------

function PH:ShowRecipeTrackerUI(profName)
    profName = profName or (PH.RecipeTracker and PH.RecipeTracker.lastScannedProf) or PH.selectedProfession

    if self.RecipeTrackerFrame then
        -- If called with same profession, toggle; otherwise switch to new prof
        if self.RecipeTrackerFrame:IsShown() and self._recipeTrackerCurrentProf == profName then
            self.RecipeTrackerFrame:Hide()
            return
        end
        self._recipeTrackerCurrentProf = profName
        self.RecipeTrackerFrame:Show()
        self:UpdateRecipeTrackerUI(profName)
        return
    end

    -----------------------------------------------------------------------
    -- Build frame (first call only)
    -----------------------------------------------------------------------
    local frame = CreateFrame("Frame", "PHRecipeTrackerFrame", UIParent, "BackdropTemplate")
    frame:SetSize(300, 400)
    frame:SetPoint("CENTER", UIParent, "CENTER", 260, 0)
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
    titleLbl:SetText("|cffffd700Missing Recipes|r")
    frame.titleLbl = titleLbl

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

    -- Progress bar background
    local progBg = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    progBg:SetHeight(8)
    progBg:SetPoint("TOPLEFT",  8, -28)
    progBg:SetPoint("TOPRIGHT", -8, -28)
    progBg:SetBackdrop(FLAT_BG)
    progBg:SetBackdropColor(0.12, 0.12, 0.15, 1)
    progBg:SetBackdropBorderColor(0.18, 0.18, 0.22, 1)

    local progFill = progBg:CreateTexture(nil, "ARTWORK")
    progFill:SetPoint("TOPLEFT", 1, -1)
    progFill:SetPoint("BOTTOMLEFT", 1, 1)
    progFill:SetColorTexture(0.30, 0.65, 1.0, 0.9)
    progFill:SetWidth(1)
    frame.progFill = progFill
    frame.progBg   = progBg

    local progLbl = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    progLbl:SetPoint("TOPLEFT", 8, -40)
    frame.progLbl = progLbl

    -- Scroll area
    local sf = CreateFrame("ScrollFrame", "PHRecipeTrackerScroll", frame, "UIPanelScrollFrameTemplate")
    sf:SetPoint("TOPLEFT",     8, -54)
    sf:SetPoint("BOTTOMRIGHT", -26, 6)
    local child = CreateFrame("Frame", "PHRecipeTrackerScrollChild", sf)
    child:SetWidth(sf:GetWidth())
    child:SetHeight(1)
    sf:SetScrollChild(child)
    frame.scrollChild = child

    frame.rowPool = {}

    self.RecipeTrackerFrame         = frame
    self._recipeTrackerCurrentProf  = profName
    self:UpdateRecipeTrackerUI(profName)
end

-------------------------------------------------------------------------------
-- Refresh
-------------------------------------------------------------------------------

function PH:UpdateRecipeTrackerUI(profName)
    local frame = self.RecipeTrackerFrame
    if not frame or not frame:IsShown() then return end
    if not PH.RecipeTracker then return end

    profName = profName or self._recipeTrackerCurrentProf
    if not profName then
        frame.progLbl:SetText("|cff8e8e93Open your trade skill window first.|r")
        return
    end

    -- Title
    frame.titleLbl:SetText("|cffffd700Missing: " .. profName .. "|r")

    -- Progress
    local learned, total = PH.RecipeTracker:GetProgress(profName)
    local pct = (total > 0) and (learned / total) or 0
    frame.progLbl:SetText(string.format("|cff8e8e93Learned:|r %d / %d  (%.0f%%)", learned, total, pct * 100))

    -- Fill progress bar
    local barW = math.max(1, frame.progBg:GetWidth() - 2)
    frame.progFill:SetWidth(math.max(1, barW * pct))

    -- Hide old rows
    for _, row in ipairs(frame.rowPool) do row:Hide() end

    -- Get missing recipes (non-trainer first by default)
    local missing = PH.RecipeTracker:GetMissingRecipes(profName, false)

    local child = frame.scrollChild
    local rowH  = 18
    local yOff  = 0
    local shown = 0

    if #missing == 0 then
        local noRow = frame.rowPool[1]
        if not noRow then
            noRow = child:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            frame.rowPool[1] = noRow
        end
        noRow:ClearAllPoints()
        noRow:SetPoint("TOPLEFT", 0, yOff)
        noRow:SetText("|cff00ff00All tracked recipes learned!|r")
        noRow:Show()
        child:SetHeight(rowH)
        return
    end

    for i, recipe in ipairs(missing) do
        local row = frame.rowPool[i]
        if not row then
            row = child:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            frame.rowPool[i] = row
        end
        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", 0, yOff)
        row:SetJustifyH("LEFT")
        local srcCol = SourceColor(recipe.source)
        row:SetText(string.format("|cffcccccc%s|r  %s[%s]|r", recipe.name, srcCol, recipe.source))
        row:Show()

        yOff  = yOff - (rowH + 2)
        shown = shown + 1
    end

    child:SetHeight(math.max(1, shown * (rowH + 2)))
end
