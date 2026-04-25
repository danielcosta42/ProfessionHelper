-- Profession Helper - Premium Minimalist UI
-- Clean, icon-driven interface with modern feel

local PH = ProfessionHelper

-------------------------------------------------------------------------------
-- Theme constants
-------------------------------------------------------------------------------
local T = {
    -- Base palette
    bg          = { 0.06, 0.06, 0.08, 0.97 },
    bgSidebar   = { 0.04, 0.04, 0.06, 1 },
    bgContent   = { 0.08, 0.08, 0.10, 1 },
    bgCard      = { 0.10, 0.10, 0.13, 0.95 },
    bgInput     = { 0.05, 0.05, 0.07, 1 },
    border      = { 0.18, 0.18, 0.22, 1 },

    -- Accent colors
    accent      = { 0.30, 0.65, 1.0 },
    accentDim   = { 0.20, 0.45, 0.75 },
    gold        = { 1.0, 0.80, 0.30 },
    green       = { 0.30, 0.85, 0.45 },
    greenDim    = { 0.15, 0.40, 0.22 },
    orange      = { 1.0, 0.60, 0.20 },
    red         = { 0.90, 0.25, 0.25 },
    white       = { 1, 1, 1 },
    textPrimary = { 0.92, 0.92, 0.95 },
    textSecondary = { 0.55, 0.55, 0.60 },
    textMuted   = { 0.35, 0.35, 0.40 },

    -- Sizes
    sidebarW    = 52,
    headerH     = 44,
    tabH        = 32,
}

-- Color helpers
local function rgb(t) return t[1], t[2], t[3] end
local function rgba(t, a) return t[1], t[2], t[3], a or t[4] or 1 end
local function hexc(t) return string.format("|cff%02x%02x%02x", t[1]*255, t[2]*255, t[3]*255) end

-------------------------------------------------------------------------------
-- Filters a source string (e.g. "Vendor: X (Zone, Horde) / Y (Zone, Alliance)")
-- to only show entries relevant to the player's faction.
-- Entries that mention neither faction are always kept (neutral vendors).
-------------------------------------------------------------------------------
local function FilterSourceByFaction(source)
    if not source or source == "" then return source end

    local playerFaction = UnitFactionGroup("player") or "Alliance"
    local oppFaction    = (playerFaction == "Alliance") and "Horde" or "Alliance"

    -- If the string mentions no faction at all, return it unchanged
    if not source:find(playerFaction, 1, true) and not source:find(oppFaction, 1, true) then
        return source
    end

    -- Preserve the prefix ("Vendor: ", "Quest: ", etc.)
    local prefix  = source:match("^[^:]+:%s*") or ""
    local content = source:sub(#prefix + 1)

    -- Split on " / " separators
    local parts = {}
    local rest  = content
    while true do
        local i = rest:find(" / ", 1, true)
        if i then
            table.insert(parts, rest:sub(1, i - 1))
            rest = rest:sub(i + 3)
        else
            if rest ~= "" then table.insert(parts, rest) end
            break
        end
    end

    -- Keep entries that do NOT mention the opposite faction
    local kept = {}
    for _, part in ipairs(parts) do
        if not part:find(oppFaction, 1, true) then
            table.insert(kept, part)
        end
    end

    -- Safety: if nothing survived keep the original
    if #kept == 0 then return source end
    return prefix .. table.concat(kept, " / ")
end

-- State
PH.craftingTab = "steps"
PH.viewedStepIndex = nil
PH.gatherViewStep = nil

-------------------------------------------------------------------------------
-- Flat frame builder (no classic borders)
-------------------------------------------------------------------------------
local function MakeFlat(frame, bg, borderColor)
    frame:SetBackdrop({
        bgFile   = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 1,
    })
    frame:SetBackdropColor(rgba(bg or T.bgCard))
    if borderColor then
        frame:SetBackdropBorderColor(rgba(borderColor))
    else
        frame:SetBackdropBorderColor(0, 0, 0, 0)
    end
end

local function MakePanel(frame, bg)
    frame:SetBackdrop({
        bgFile   = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 1,
    })
    frame:SetBackdropColor(rgba(bg or T.bgCard))
    frame:SetBackdropBorderColor(rgba(T.border))
end

-- Minimal scroll frame
local function CreateScrollFrame(parent, name)
    local sf = CreateFrame("ScrollFrame", name, parent, "UIPanelScrollFrameTemplate")
    local child = CreateFrame("Frame", name .. "Child", sf)
    sf:SetScrollChild(child)
    child:SetWidth(sf:GetWidth() - 12)
    child:SetHeight(1)

    -- Restyle the scrollbar
    local sbName = sf:GetName()
    if sbName then
        local sb = _G[sbName .. "ScrollBar"]
        if sb then
            -- Hide all default art regions on the scrollbar
            for _, region in pairs({sb:GetRegions()}) do
                region:SetAlpha(0)
            end
            local up = _G[sbName .. "ScrollBarScrollUpButton"]
            local dn = _G[sbName .. "ScrollBarScrollDownButton"]
            if up then up:SetAlpha(0); up:SetSize(1,1) end
            if dn then dn:SetAlpha(0); dn:SetSize(1,1) end
            local thumb = sb:GetThumbTexture()
            if thumb then
                thumb:SetColorTexture(rgba(T.textMuted, 0.35))
                thumb:SetSize(4, 40)
            end
        end
    end
    return sf, child
end

-- Icon lookup
local function ProfIcon(profName)
    for _, p in ipairs(PH.Professions) do
        if p.name == profName then return "Interface\\Icons\\" .. p.icon end
    end
    return "Interface\\Icons\\INV_Misc_QuestionMark"
end

-- Icon2 lookup (for combo professions)
local function ProfIcon2(profName)
    local profD = PH:GetProfessionData(profName)
    if profD and profD.icon2 then
        return "Interface\\Icons\\" .. profD.icon2
    end
    return nil
end

-------------------------------------------------------------------------------
-- Home panel (banner + credits)
-------------------------------------------------------------------------------
function PH:BuildHomePanel(parent)
    local y = -30

    y = y - 10

    -- Gold separator
    local sep1 = parent:CreateTexture(nil, "ARTWORK")
    sep1:SetHeight(1)
    sep1:SetPoint("TOPLEFT", 14, y)
    sep1:SetPoint("TOPRIGHT", -14, y)
    sep1:SetColorTexture(T.gold[1], T.gold[2], T.gold[3], 0.4)
    y = y - 20

    -- Addon name
    local nameText = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
    nameText:SetPoint("TOP", 0, y)
    nameText:SetText(hexc(T.gold) .. "Profession Helper|r")
    y = y - 30

    -- Version + Author
    local verText = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    verText:SetPoint("TOP", 0, y)
    verText:SetText(
        hexc(T.accent) .. "v" .. PH.version .. "|r  " ..
        hexc(T.textMuted) .. "by |r" ..
        hexc(T.textPrimary) .. PH.author .. "|r"
    )
    y = y - 22

    -- License
    local licText = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    licText:SetPoint("TOP", 0, y)
    licText:SetText(hexc(T.textMuted) .. PH.license .. "|r")
    y = y - 26

    -- Separator
    local sep2 = parent:CreateTexture(nil, "ARTWORK")
    sep2:SetHeight(1)
    sep2:SetPoint("TOPLEFT", 80, y)
    sep2:SetPoint("TOPRIGHT", -80, y)
    sep2:SetColorTexture(rgba(T.border))
    y = y - 22

    -- Features title
    local featTitle = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    featTitle:SetPoint("TOPLEFT", 80, y)
    featTitle:SetText(hexc(T.gold) .. PH.L["FEATURES"] .. "|r")
    y = y - 22

    -- Feature lines
    local lines = {
        PH.L["WELCOME_LINE1"],
        PH.L["WELCOME_LINE2"],
        PH.L["WELCOME_LINE3"],
        PH.L["WELCOME_LINE4"],
    }
    for _, line in ipairs(lines) do
        local ft = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        ft:SetPoint("TOPLEFT", 80, y)
        ft:SetText(hexc(T.accent) .. "»  |r" .. hexc(T.textPrimary) .. line .. "|r")
        y = y - 19
    end

    y = y - 16

    -- Bottom separator
    local sep3 = parent:CreateTexture(nil, "ARTWORK")
    sep3:SetHeight(1)
    sep3:SetPoint("TOPLEFT", 80, y)
    sep3:SetPoint("TOPRIGHT", -80, y)
    sep3:SetColorTexture(rgba(T.border))
    y = y - 16

    -- GitHub
    local ghText = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    ghText:SetPoint("TOP", 0, y)
    ghText:SetText(hexc(T.textMuted) .. "GitHub: |r" .. hexc(T.accent) .. PH.github .. "|r")
    y = y - 18

    -- WoW badge
    local tbcText = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    tbcText:SetPoint("TOP", 0, y)
    tbcText:SetText(hexc(T.textMuted) .. "World of Warcraft: The Burning Crusade Classic|r")
end

-------------------------------------------------------------------------------
-- Create the main window
-------------------------------------------------------------------------------
function PH:CreateMainWindow()
    if self.MainFrame then return end

    local frame = CreateFrame("Frame", "ProfessionHelperMainFrame", UIParent, "BackdropTemplate")
    frame:SetSize(680, 560)
    frame:SetPoint("CENTER")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:SetClampedToScreen(true)
    frame:SetFrameStrata("HIGH")
    MakeFlat(frame, T.bg, T.border)

    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

    -- Shadow
    local shadow = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    shadow:SetPoint("TOPLEFT", -3, 3)
    shadow:SetPoint("BOTTOMRIGHT", 3, -3)
    shadow:SetFrameLevel(frame:GetFrameLevel() - 1)
    shadow:SetBackdrop({
        bgFile   = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 3,
    })
    shadow:SetBackdropColor(0, 0, 0, 0.65)
    shadow:SetBackdropBorderColor(0, 0, 0, 0.50)

    -- Header bar
    local header = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    header:SetHeight(T.headerH)
    header:SetPoint("TOPLEFT", 1, -1)
    header:SetPoint("TOPRIGHT", -1, -1)
    MakeFlat(header, { 0.08, 0.08, 0.11, 1 })

    local titleIcon = header:CreateTexture(nil, "ARTWORK")
    titleIcon:SetSize(22, 22)
    titleIcon:SetPoint("LEFT", 14, 0)
    titleIcon:SetTexture("Interface\\Icons\\INV_Misc_Book_09")
    titleIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

    local title = header:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("LEFT", titleIcon, "RIGHT", 8, 0)
    title:SetText(hexc(T.gold) .. "Profession Helper|r")

    local verBadge = header:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    verBadge:SetPoint("LEFT", title, "RIGHT", 6, -1)
    verBadge:SetText(hexc(T.textMuted) .. "TBC|r")

    -- About/Info button
    local infoBtn = CreateFrame("Button", nil, header)
    infoBtn:SetSize(T.headerH - 8, T.headerH - 8)
    infoBtn:SetPoint("RIGHT", -40, 0)
    local infoTex = infoBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    infoTex:SetPoint("CENTER", 0, 0)
    infoTex:SetText(hexc(T.accent) .. "?|r")
    local infoHL = infoBtn:CreateTexture(nil, "HIGHLIGHT")
    infoHL:SetAllPoints()
    infoHL:SetColorTexture(rgba(T.accent, 0.20))
    infoBtn:SetScript("OnClick", function() PH:ShowCreditsPopup() end)
    infoBtn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
        GameTooltip:AddLine(PH.L["ABOUT"])
        GameTooltip:AddLine(PH.L["CREDITS"], 1, 1, 1)
        GameTooltip:Show()
    end)
    infoBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)

    -- Close X
    local closeBtn = CreateFrame("Button", nil, header)
    closeBtn:SetSize(T.headerH - 8, T.headerH - 8)
    closeBtn:SetPoint("RIGHT", -6, 0)
    local closeTex = closeBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    closeTex:SetPoint("CENTER", 0, 1)
    closeTex:SetText(hexc(T.textSecondary) .. "x|r")
    local closeHL = closeBtn:CreateTexture(nil, "HIGHLIGHT")
    closeHL:SetAllPoints()
    closeHL:SetColorTexture(rgba(T.red, 0.25))
    closeBtn:SetScript("OnClick", function() frame:Hide() end)

    -- Sidebar
    local sidebar = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    sidebar:SetWidth(T.sidebarW)
    sidebar:SetPoint("TOPLEFT", 1, -(T.headerH + 1))
    sidebar:SetPoint("BOTTOMLEFT", 1, 1)
    MakeFlat(sidebar, T.bgSidebar)

    -- Content area
    local contentArea = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    contentArea:SetPoint("TOPLEFT", sidebar, "TOPRIGHT", 0, 0)
    contentArea:SetPoint("BOTTOMRIGHT", -1, 1)
    MakeFlat(contentArea, T.bgContent)

    -- Tab bar
    local tabBar = CreateFrame("Frame", nil, contentArea)
    tabBar:SetHeight(T.tabH)
    tabBar:SetPoint("TOPLEFT", 12, -8)
    tabBar:SetPoint("TOPRIGHT", -12, -8)
    tabBar:Hide()
    frame.tabBar = tabBar

    local function MakeTab(parent, text, key, anchorLeft, offsetX)
        local tab = CreateFrame("Button", nil, parent, "BackdropTemplate")
        tab:SetHeight(26)
        if anchorLeft then
            tab:SetPoint("LEFT", anchorLeft, "RIGHT", 6, 0)
        else
            tab:SetPoint("LEFT", offsetX or 0, 0)
        end
        tab.tabKey = key
        tab.rawText = text

        local label = tab:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        label:SetPoint("LEFT", 12, 0)
        label:SetPoint("RIGHT", -12, 0)
        label:SetText(text)
        tab.label = label
        tab:SetWidth(label:GetStringWidth() + 28)

        tab:SetScript("OnClick", function(self)
            PH.craftingTab = self.tabKey
            PH:UpdateTabVisuals()
            PH:UpdateContentPanel()
        end)
        return tab
    end

    local tabSteps    = MakeTab(tabBar, PH.L["TAB_LEVELING"],  "steps",    nil, 0)
    local tabShopping = MakeTab(tabBar, PH.L["TAB_SHOPPING"],   "shopping", tabSteps)
    frame.tabSteps    = tabSteps
    frame.tabShopping = tabShopping

    -- Scroll area
    local scrollFrame, scrollChild = CreateScrollFrame(contentArea, "PHContentScroll")
    scrollFrame:SetPoint("TOPLEFT", 8, -(T.tabH + 12))
    scrollFrame:SetPoint("BOTTOMRIGHT", -20, 6)
    scrollChild:SetWidth(scrollFrame:GetWidth() - 8)

    frame.contentScroll = scrollFrame
    frame.contentChild  = scrollChild
    frame.contentArea   = contentArea

    -- Home panel (banner + credits)
    local homePanel = CreateFrame("Frame", nil, contentArea, "BackdropTemplate")
    homePanel:SetPoint("TOPLEFT", 1, -1)
    homePanel:SetPoint("BOTTOMRIGHT", -1, 1)
    MakeFlat(homePanel, T.bgContent)
    frame.homePanel = homePanel
    PH:BuildHomePanel(homePanel)

    -- Sidebar scroll (mousewheel only, no scrollbar)
    local sideScroll = CreateFrame("ScrollFrame", nil, sidebar)
    sideScroll:SetAllPoints()
    sideScroll:EnableMouseWheel(true)
    sideScroll:SetScript("OnMouseWheel", function(self, delta)
        local cur = self:GetVerticalScroll()
        local mx = self:GetVerticalScrollRange()
        local nv = cur - (delta * 34)
        if nv < 0 then nv = 0 end
        if nv > mx then nv = mx end
        self:SetVerticalScroll(nv)
    end)
    local sideChild = CreateFrame("Frame", nil, sideScroll)
    sideChild:SetWidth(T.sidebarW)
    sideChild:SetHeight(1)
    sideScroll:SetScrollChild(sideChild)

    -- Profession icon buttons
    local profButtons = {}
    local iconSize = 32
    local iconPad = 2
    local yOff = -8

    -- Home button (top of sidebar)
    local homeBtn = CreateFrame("Button", nil, sideChild)
    homeBtn:SetSize(iconSize + 4, iconSize + 4)
    homeBtn:SetPoint("TOP", 0, yOff)

    local homeIco = homeBtn:CreateTexture(nil, "ARTWORK")
    homeIco:SetSize(iconSize, iconSize)
    homeIco:SetPoint("CENTER")
    homeIco:SetTexture("Interface\\Icons\\INV_Misc_Book_09")
    homeIco:SetTexCoord(0.08, 0.92, 0.08, 0.92)

    local homeHL = homeBtn:CreateTexture(nil, "HIGHLIGHT")
    homeHL:SetAllPoints()
    homeHL:SetColorTexture(T.gold[1], T.gold[2], T.gold[3], 0.20)

    local homeSel = homeBtn:CreateTexture(nil, "OVERLAY")
    homeSel:SetSize(3, iconSize)
    homeSel:SetPoint("LEFT", homeBtn, "LEFT", -2, 0)
    homeSel:SetColorTexture(T.gold[1], T.gold[2], T.gold[3])
    homeSel:Show()  -- starts selected (no profession on first open)
    frame.homeSel = homeSel

    homeBtn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine(hexc(T.gold) .. "Profession Helper|r")
        GameTooltip:AddLine("Home / Credits", T.textSecondary[1], T.textSecondary[2], T.textSecondary[3])
        GameTooltip:Show()
    end)
    homeBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    homeBtn:SetScript("OnClick", function()
        for _, b in ipairs(profButtons) do b.selectedBar:Hide() end
        homeSel:Show()
        PH.selectedProfession = nil
        PH.viewedStepIndex = nil
        PH.gatherViewStep = nil
        PH:UpdateContentPanel()
    end)

    yOff = yOff - (iconSize + iconPad + 8)

    local homeSepLine = sideChild:CreateTexture(nil, "ARTWORK")
    homeSepLine:SetSize(iconSize, 1)
    homeSepLine:SetPoint("TOP", 0, yOff)
    homeSepLine:SetColorTexture(rgba(T.border))
    yOff = yOff - 8

    local categories = {
        { profs = {"Alchemy","Blacksmithing","Enchanting","Engineering","Jewelcrafting","Leatherworking","Tailoring"} },
        { profs = {"Herbalism","Mining","Skinning"} },
        { profs = {"Cooking","First Aid","Fishing"} },
        { profs = {"Herbalism & Alchemy", "Skinning & Leatherworking", "Fishing & Cooking"} },
    }

    for ci, cat in ipairs(categories) do
        if ci > 1 then
            local sep = sideChild:CreateTexture(nil, "ARTWORK")
            sep:SetSize(iconSize, 1)
            sep:SetPoint("TOP", 0, yOff)
            sep:SetColorTexture(rgba(T.border))
            yOff = yOff - 6
        end
        for _, profName in ipairs(cat.profs) do
            local btn = CreateFrame("Button", nil, sideChild)
            btn:SetSize(iconSize + 4, iconSize + 4)
            btn:SetPoint("TOP", 0, yOff)
            btn.professionName = profName

            -- Check if this is a combo profession
            local isCombo = false
            for _, p in ipairs(PH.Professions) do
                if p.name == profName and p.type == "combo" then isCombo = true; break end
            end

            local ico, ico2
            if isCombo then
                -- Combo: two overlapping mini-icons
                local miniSize = 22
                ico = btn:CreateTexture(nil, "ARTWORK")
                ico:SetSize(miniSize, miniSize)
                ico:SetPoint("TOPLEFT", btn, "TOPLEFT", 2, -2)
                ico:SetTexture(ProfIcon(profName))
                ico:SetTexCoord(0.08, 0.92, 0.08, 0.92)

                local icon2Path = ProfIcon2(profName)
                if icon2Path then
                    ico2 = btn:CreateTexture(nil, "ARTWORK", nil, 1)
                    ico2:SetSize(miniSize, miniSize)
                    ico2:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", -2, 2)
                    ico2:SetTexture(icon2Path)
                    ico2:SetTexCoord(0.08, 0.92, 0.08, 0.92)
                end
            else
                -- Normal: single centered icon
                ico = btn:CreateTexture(nil, "ARTWORK")
                ico:SetSize(iconSize, iconSize)
                ico:SetPoint("CENTER")
                ico:SetTexture(ProfIcon(profName))
                ico:SetTexCoord(0.08, 0.92, 0.08, 0.92)
            end
            btn.icon = ico
            btn.icon2 = ico2

            local hl = btn:CreateTexture(nil, "HIGHLIGHT")
            hl:SetPoint("TOPLEFT", btn, "TOPLEFT", 0, 0)
            hl:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", 0, 0)
            hl:SetColorTexture(rgba(T.accent, 0.20))

            local sel = btn:CreateTexture(nil, "OVERLAY")
            sel:SetSize(3, iconSize)
            sel:SetPoint("LEFT", btn, "LEFT", -2, 0)
            sel:SetColorTexture(rgb(T.accent))
            sel:Hide()
            btn.selectedBar = sel

            local skill = PH:GetPlayerProfessionLevel(profName)
            if isCombo then
                local profD = PH:GetProfessionData(profName)
                local anyLearned = false
                if profD and profD.skills then
                    for _, sk in ipairs(profD.skills) do
                        if PH:GetPlayerProfessionLevel(sk) > 0 then anyLearned = true; break end
                    end
                end
                if not anyLearned then
                    ico:SetDesaturated(true)
                    ico:SetAlpha(0.45)
                    if ico2 then ico2:SetDesaturated(true); ico2:SetAlpha(0.45) end
                end
            elseif skill == 0 then
                ico:SetDesaturated(true)
                ico:SetAlpha(0.45)
            end

            btn:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                local profD = PH:GetProfessionData(self.professionName)
                GameTooltip:AddLine(PH:GetLocalizedProfessionName(self.professionName))
                if profD and profD.type == "combo" and profD.skills then
                    for _, sk in ipairs(profD.skills) do
                        local skVal, skMax = PH:GetPlayerProfessionLevel(sk)
                        if skVal > 0 then
                            GameTooltip:AddLine(sk .. ": " .. skVal .. " / " .. skMax, rgb(T.green))
                        else
                            GameTooltip:AddLine(sk .. ": " .. PH.L["NOT_LEARNED"], rgb(T.textMuted))
                        end
                    end
                else
                    local sk, mx = PH:GetPlayerProfessionLevel(self.professionName)
                    if sk > 0 then
                        GameTooltip:AddLine(sk .. " / " .. mx, rgb(T.green))
                    else
                        GameTooltip:AddLine(PH.L["NOT_LEARNED"], rgb(T.textMuted))
                    end
                end
                GameTooltip:Show()
            end)
            btn:SetScript("OnLeave", function() GameTooltip:Hide() end)

            btn:SetScript("OnClick", function(self)
                for _, b in ipairs(profButtons) do b.selectedBar:Hide() end
                frame.homeSel:Hide()
                self.selectedBar:Show()
                PH.selectedProfession = self.professionName
                PH.viewedStepIndex = nil
                PH.gatherViewStep = nil
                PH:UpdateContentPanel()
                frame.contentScroll:SetVerticalScroll(0)
            end)

            table.insert(profButtons, btn)
            yOff = yOff - (iconSize + iconPad)
        end
    end
    sideChild:SetHeight(math.abs(yOff) + 8)
    frame.profButtons = profButtons

    frame.UpdateContent = function() PH:UpdateContentPanel() end
    self.MainFrame = frame
    frame:Hide()
end

-------------------------------------------------------------------------------
-- Tab visuals
-------------------------------------------------------------------------------
function PH:UpdateTabVisuals()
    local frame = self.MainFrame
    if not frame then return end
    local active = self.craftingTab or "steps"

    for _, tab in ipairs({ frame.tabSteps, frame.tabShopping }) do
        if tab.tabKey == active then
            MakeFlat(tab, { T.accent[1], T.accent[2], T.accent[3], 0.18 }, { T.accent[1], T.accent[2], T.accent[3], 0.5 })
            tab.label:SetText(hexc(T.accent) .. tab.rawText .. "|r")
        else
            MakeFlat(tab, { 0.12, 0.12, 0.15, 0.8 })
            tab:SetBackdropBorderColor(0, 0, 0, 0)
            tab.label:SetText(hexc(T.textSecondary) .. tab.rawText .. "|r")
        end
    end
end

-------------------------------------------------------------------------------
-- Update content panel
-------------------------------------------------------------------------------
function PH:UpdateContentPanel()
    local frame = self.MainFrame
    if not frame then return end

    local scrollChild = frame.contentChild
    for _, child in pairs({ scrollChild:GetChildren() }) do child:Hide() end
    for _, region in pairs({ scrollChild:GetRegions() }) do region:Hide() end

    if not self.selectedProfession then
        frame.homePanel:Show()
        frame.contentScroll:Hide()
        frame.tabBar:Hide()
        return
    end
    frame.homePanel:Hide()
    frame.contentScroll:Show()

    local profData = self:GetProfessionData(self.selectedProfession)
    if not profData then
        self:Print(string.format(PH.L["DATA_NOT_FOUND"], self.selectedProfession))
        return
    end

    local isCrafting = (profData.type ~= "gathering")
    local isCombo = (profData.type == "combo")
    if isCrafting then
        frame.tabBar:Show()
        frame.contentScroll:SetPoint("TOPLEFT", 8, -(T.tabH + 12))
        self:UpdateTabVisuals()
    else
        frame.tabBar:Hide()
        frame.contentScroll:SetPoint("TOPLEFT", 8, -8)
    end

    local y = -6

    -- Combo skills lookup
    local comboSkills = nil
    if isCombo and profData.skills then
        comboSkills = {}
        for _, sk in ipairs(profData.skills) do
            comboSkills[sk] = self:GetPlayerProfessionLevel(sk)
        end
    end

    -- Profession header card
    local hdrCard = CreateFrame("Frame", nil, scrollChild, "BackdropTemplate")
    hdrCard:SetPoint("TOPLEFT", 0, y)
    hdrCard:SetPoint("RIGHT", scrollChild, "RIGHT", 0, 0)
    MakePanel(hdrCard, T.bgCard)

    if isCombo and profData.skills then
        -- Combo: show dual icons stacked + name + both skill lines
        hdrCard:SetHeight(76)

        -- Stacked icons
        local hdrIcon = hdrCard:CreateTexture(nil, "ARTWORK")
        hdrIcon:SetSize(26, 26)
        hdrIcon:SetPoint("TOPLEFT", 10, -10)
        hdrIcon:SetTexture("Interface\\Icons\\" .. (profData.icon or "INV_Misc_QuestionMark"))
        hdrIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

        local hdrIcon2 = hdrCard:CreateTexture(nil, "ARTWORK")
        hdrIcon2:SetSize(26, 26)
        hdrIcon2:SetPoint("TOPLEFT", hdrIcon, "BOTTOMLEFT", 0, -4)
        hdrIcon2:SetTexture("Interface\\Icons\\" .. (profData.icon2 or "INV_Misc_QuestionMark"))
        hdrIcon2:SetTexCoord(0.08, 0.92, 0.08, 0.92)

        -- Title
        local hdrName = hdrCard:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        hdrName:SetPoint("TOPLEFT", hdrIcon, "TOPRIGHT", 10, 0)
        hdrName:SetText(hexc(T.white) .. PH:GetLocalizedProfessionName(profData.name) .. "|r")

        -- Skill lines - compact, one per row
        local skillY = -3
        for i, sk in ipairs(profData.skills) do
            local skVal, skMax = self:GetPlayerProfessionLevel(sk)
            local tierName = self:GetSkillTier(skVal)
            local skLabel = hdrCard:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            skLabel:SetPoint("TOPLEFT", hdrName, "BOTTOMLEFT", 0, skillY)
            if skVal > 0 then
                skLabel:SetText(hexc(T.accent) .. sk .. ":|r " .. hexc(T.green) .. skVal .. "|r" .. hexc(T.textMuted) .. "/" .. skMax .. " " .. tierName .. "|r")
            else
                skLabel:SetText(hexc(T.accent) .. sk .. ":|r " .. hexc(T.textMuted) .. PH.L["NOT_LEARNED"] .. "|r")
            end
            skillY = skillY - 14
        end

        y = y - 84
    else
        -- Normal single-profession header
        hdrCard:SetHeight(56)

        local hdrIcon = hdrCard:CreateTexture(nil, "ARTWORK")
        hdrIcon:SetSize(36, 36)
        hdrIcon:SetPoint("LEFT", 10, 0)
        hdrIcon:SetTexture(ProfIcon(self.selectedProfession))
        hdrIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

        local hdrName = hdrCard:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        hdrName:SetPoint("TOPLEFT", hdrIcon, "TOPRIGHT", 10, -2)
        hdrName:SetText(hexc(T.white) .. PH:GetLocalizedProfessionName(profData.name) .. "|r")

        local currentSkillH, maxSkillH = self:GetPlayerProfessionLevel(self.selectedProfession)
        local tierName = self:GetSkillTier(currentSkillH)
        local hdrSkill = hdrCard:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        hdrSkill:SetPoint("TOPLEFT", hdrName, "BOTTOMLEFT", 0, -3)
        if currentSkillH > 0 then
            hdrSkill:SetText(hexc(T.green) .. currentSkillH .. "|r" .. hexc(T.textMuted) .. " / " .. maxSkillH .. "  " .. tierName .. "|r")
        else
            hdrSkill:SetText(hexc(T.textMuted) .. PH.L["NOT_LEARNED"] .. "|r")
        end

        if isCrafting then
            local tsmBadge = hdrCard:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            tsmBadge:SetPoint("RIGHT", -10, 0)
            local priceSrc = PH.TSM:GetDisplayName()
            if priceSrc then
                tsmBadge:SetText(hexc(T.green) .. priceSrc .. " ●|r")
            else
                tsmBadge:SetText(hexc(T.textMuted) .. "— ○|r")
            end
        end

        y = y - 64
    end

    local currentSkill, maxSkill = self:GetPlayerProfessionLevel(self.selectedProfession)

    -- Dispatch
    if profData.type == "gathering" then
        y = self:CreateGatheringContent(scrollChild, profData, currentSkill, y)
    elseif isCombo then
        -- Combo uses crafting content with combo skill awareness
        local minSkill = 0
        if comboSkills then
            minSkill = 375
            for _, v in pairs(comboSkills) do
                if v < minSkill then minSkill = v end
            end
        end
        if minSkill < 1 then minSkill = 1 end
        if self.craftingTab == "shopping" then
            y = self:CreateShoppingContent(scrollChild, profData, minSkill, y, comboSkills)
        else
            y = self:CreateCraftingContent(scrollChild, profData, minSkill, y, comboSkills)
        end
    elseif self.craftingTab == "shopping" then
        y = self:CreateShoppingContent(scrollChild, profData, currentSkill, y)
    else
        y = self:CreateCraftingContent(scrollChild, profData, currentSkill, y)
    end

    scrollChild:SetHeight(math.abs(y) + 40)
end

-------------------------------------------------------------------------------
-- UI Helpers
-------------------------------------------------------------------------------

-- Flat progress bar
local function FlatBar(parent, y, pct, h, fgColor, bgColor)
    local track = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    track:SetHeight(h or 6)
    track:SetPoint("TOPLEFT", 0, y)
    track:SetPoint("RIGHT", parent, "RIGHT", 0, 0)
    MakeFlat(track, bgColor or T.bgInput)

    local fill = track:CreateTexture(nil, "ARTWORK")
    fill:SetPoint("TOPLEFT", 1, -1)
    fill:SetHeight((h or 6) - 2)
    fill:SetColorTexture(rgb(fgColor or T.accent))

    local p = math.min(1, math.max(0, pct))
    local function updateFill(self)
        local w = self:GetWidth()
        if w > 2 then
            fill:SetWidth(math.max(1, (w - 2) * p))
        end
    end
    track:SetScript("OnSizeChanged", updateFill)
    -- Fallback: ensure fill is set on next frame in case OnSizeChanged doesn't fire
    track:SetScript("OnUpdate", function(self)
        self:SetScript("OnUpdate", nil)
        updateFill(self)
    end)
    return track
end

-- Section label
local function SectionLabel(parent, y, text, color)
    local lbl = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    lbl:SetPoint("TOPLEFT", 0, y)
    lbl:SetText((color or hexc(T.textSecondary)) .. text .. "|r")
    return lbl, y - 16
end

-- Pill button
local function PillButton(parent, width, height, text, color)
    local btn = CreateFrame("Button", nil, parent, "BackdropTemplate")
    btn:SetSize(width, height)
    MakeFlat(btn, { color[1], color[2], color[3], 0.15 }, { color[1], color[2], color[3], 0.4 })
    local lbl = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    lbl:SetPoint("CENTER")
    lbl:SetText(hexc(color) .. text .. "|r")
    local hl = btn:CreateTexture(nil, "HIGHLIGHT")
    hl:SetAllPoints()
    hl:SetColorTexture(color[1], color[2], color[3], 0.12)
    return btn
end

-------------------------------------------------------------------------------
-- Crafting content (progress-focused)
-------------------------------------------------------------------------------
function PH:CreateCraftingContent(parent, profData, currentSkill, yOffset, comboSkills)
    local targetSkill = 375
    if currentSkill < 1 then currentSkill = 1 end

    -- Store current skill and step index for tracker
    if self.selectedProfession then
        self.liveTracker.previousSkill[self.selectedProfession] = self.liveTracker.previousSkill[self.selectedProfession] or currentSkill
    end

    local pathData = PH.PathCalculator:Calculate(profData, currentSkill, targetSkill, comboSkills)
    if not pathData or not pathData.steps or #pathData.steps == 0 then
        local allDone = true
        if comboSkills then
            for _, v in pairs(comboSkills) do
                if v < 375 then allDone = false; break end
            end
        else
            allDone = (currentSkill >= 375)
        end
        if allDone then
            local y = yOffset
            y = self:RenderGoldFarmingGuide(parent, y, profData.name, comboSkills)
            return y
        else
            local msg = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            msg:SetPoint("TOP", 0, yOffset - 20)
            msg:SetJustifyH("CENTER")
            msg:SetText(hexc(T.textMuted) .. PH.L["GUIDE_NOT_AVAILABLE"] .. "|r")
            return yOffset - 60
        end
    end

    local totalSteps = #pathData.steps
    local pct
    if comboSkills then
        -- Average progress across both skills
        local sum, cnt = 0, 0
        for _, v in pairs(comboSkills) do sum = sum + v; cnt = cnt + 1 end
        pct = math.min(1, (sum / cnt) / targetSkill)
    else
        pct = math.min(1, currentSkill / targetSkill)
    end

    local currentStepIdx = 1
    for i, step in ipairs(pathData.steps) do
        local rEnd = (step.originalRange and step.originalRange[2]) or step.skillRange[2]
        local stepSkillLvl = currentSkill
        if comboSkills and step.skill and comboSkills[step.skill] then
            stepSkillLvl = comboSkills[step.skill]
        end
        if rEnd > stepSkillLvl then currentStepIdx = i; break end
    end
    -- Initialize step index for auto-advance detection
    if not self.liveTracker.previousStepIdx then
        self.liveTracker.previousStepIdx = currentStepIdx
    end
    local viewIdx = self.viewedStepIndex
    if not viewIdx or viewIdx < 1 or viewIdx > totalSteps then viewIdx = currentStepIdx end
    local vs = pathData.steps[viewIdx]

    -- Progress
    local progressLabel
    if comboSkills then
        local parts = {}
        for _, sk in ipairs(profData.skills) do
            local v = comboSkills[sk] or 0
            table.insert(parts, sk .. " " .. v)
        end
        progressLabel = string.format("PROGRESSO  (%.0f%%)", pct * 100)
    else
        progressLabel = string.format("PROGRESSO  %d / %d  (%.0f%%)", currentSkill, targetSkill, pct * 100)
    end
    local _, y = SectionLabel(parent, yOffset, progressLabel)

    -- For combo, show dual skill mini-bars under the main progress
    if comboSkills then
        FlatBar(parent, y, pct, 6, pct < 0.5 and T.orange or T.green)
        y = y - 12
        for _, sk in ipairs(profData.skills) do
            local v = comboSkills[sk] or 0
            local skPct = math.min(1, v / targetSkill)
            local skColor = (sk == "Fishing") and T.accent or T.gold
            local skLbl = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            skLbl:SetPoint("TOPLEFT", 0, y)
            skLbl:SetText(hexc(skColor) .. sk .. " " .. v .. "/" .. targetSkill .. "|r")
            y = y - 12
            FlatBar(parent, y, skPct, 4, skColor)
            y = y - 8
        end
    else
        FlatBar(parent, y, pct, 8, pct < 0.5 and T.orange or T.green)
        y = y - 18
    end

    -- Timeline dots
    local tlFrame = CreateFrame("Frame", nil, parent)
    tlFrame:SetHeight(14)
    tlFrame:SetPoint("TOPLEFT", 0, y)
    tlFrame:SetPoint("RIGHT", parent, "RIGHT", 0, 0)
    tlFrame.dots = {}
    local function drawCraftDots(self)
        for _, d in ipairs(self.dots) do d:Hide() end
        self.dots = {}
        local w = self:GetWidth()
        if w < 10 or totalSteps < 1 then return end
        local dotW = math.min(10, math.max(3, (w - 4) / totalSteps - 1))
        local spacing = (w - 4) / totalSteps
        for i, step in ipairs(pathData.steps) do
            local dot = self:CreateTexture(nil, "ARTWORK")
            dot:SetSize(dotW, 4)
            dot:SetPoint("LEFT", 2 + (i-1) * spacing, 0)
            local oStart = (step.originalRange and step.originalRange[1]) or step.skillRange[1]
            local oEnd   = (step.originalRange and step.originalRange[2]) or step.skillRange[2]
            local dotSkill = currentSkill
            if comboSkills and step.skill and comboSkills[step.skill] then
                dotSkill = comboSkills[step.skill]
            end
            local comp = oEnd <= dotSkill
            local cur  = oStart <= dotSkill and oEnd > dotSkill
            if comp then
                dot:SetColorTexture(rgb(T.green)); dot:SetAlpha(0.7)
            elseif cur then
                dot:SetColorTexture(rgb(T.green)); dot:SetAlpha(1)
            else
                dot:SetColorTexture(rgba(T.textMuted, 0.3))
            end
            if i == viewIdx then
                local ring = self:CreateTexture(nil, "OVERLAY")
                ring:SetSize(dotW + 4, 8)
                ring:SetPoint("CENTER", dot, "CENTER")
                ring:SetColorTexture(rgba(T.accent, 0.35))
                table.insert(self.dots, ring)
            end
            table.insert(self.dots, dot)
        end
    end
    tlFrame:SetScript("OnSizeChanged", drawCraftDots)
    tlFrame:SetScript("OnUpdate", function(self)
        self:SetScript("OnUpdate", nil)
        drawCraftDots(self)
    end)
    y = y - 22

    -- Navigation
    local navFrame = CreateFrame("Frame", nil, parent)
    navFrame:SetHeight(26)
    navFrame:SetPoint("TOPLEFT", 0, y)
    navFrame:SetPoint("RIGHT", parent, "RIGHT", 0, 0)

    local prevBtn = PillButton(navFrame, 70, 22, "< Anterior", T.accent)
    prevBtn:SetPoint("LEFT", 0, 0)
    if viewIdx <= 1 then prevBtn:SetAlpha(0.3); prevBtn:Disable() end
    prevBtn:SetScript("OnClick", function()
        if viewIdx > 1 then PH.viewedStepIndex = viewIdx - 1; PH:UpdateContentPanel() end
    end)

    local navLabel = navFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    navLabel:SetPoint("CENTER")
    local tierN = PH:GetSkillTier(vs.skillRange[1])
    -- Use absolute step position (covers the full 1-375 guide) so the counter
    -- doesn't reset to 1 when the player is already partway through the journey.
    local displayIdx   = vs.absoluteIndex or viewIdx
    local displayTotal = vs.totalAbsolute or totalSteps
    navLabel:SetText(hexc(T.gold) .. string.format(PH.L["STEP"], displayIdx) .. "|r" .. hexc(T.textMuted) .. " / " .. displayTotal .. "  " .. tierN .. "|r")

    if viewIdx ~= currentStepIdx then
        local goBtn = PillButton(navFrame, 60, 20, PH.L["CURRENT"], T.green)
        goBtn:SetPoint("LEFT", navLabel, "RIGHT", 8, 0)
        goBtn:SetScript("OnClick", function() PH.viewedStepIndex = nil; PH:UpdateContentPanel() end)
    end

    local nextBtn = PillButton(navFrame, 70, 22, PH.L["NEXT"] .. " >", T.accent)
    nextBtn:SetPoint("RIGHT", 0, 0)
    if viewIdx >= totalSteps then nextBtn:SetAlpha(0.3); nextBtn:Disable() end
    nextBtn:SetScript("OnClick", function()
        if viewIdx < totalSteps then PH.viewedStepIndex = viewIdx + 1; PH:UpdateContentPanel() end
    end)
    y = y - 36

    -- Focused card
    y = self:CreateFocusedCard(parent, y, vs, totalSteps, currentSkill, comboSkills)

    -- Next preview
    if viewIdx < totalSteps then
        y = self:CreateNextPreview(parent, y, pathData.steps[viewIdx + 1])
    end

    -- Summary footer
    y = y - 6
    local remaining = 0
    for _, s in ipairs(pathData.steps) do
        local sEnd = (s.originalRange and s.originalRange[2]) or s.skillRange[2]
        local sSkill = currentSkill
        if comboSkills and s.skill and comboSkills[s.skill] then
            sSkill = comboSkills[s.skill]
        end
        if sEnd > sSkill then remaining = remaining + 1 end
    end
    local footerCard = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    footerCard:SetHeight(24)
    footerCard:SetPoint("TOPLEFT", 0, y)
    footerCard:SetPoint("RIGHT", parent, "RIGHT", 0, 0)
    MakeFlat(footerCard, T.bgInput)
    local ft = footerCard:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    ft:SetPoint("LEFT", 8, 0)
    local costStr = ""
    if pathData.hasPricing and pathData.totalCost > 0 then
        costStr = "   " .. hexc(T.textMuted) .. PH.L["STEP_INLINE_COST"] .. "|r " .. PH.TSM:FormatMoney(pathData.totalCost)
    end
    ft:SetText(hexc(T.textSecondary) .. string.format(PH.L["STEPS_REMAINING"], remaining) .. "|r" .. costStr)
    y = y - 30

    y = self:RenderTrainers(parent, y, profData)
    return y
end

-------------------------------------------------------------------------------
-- Focused step card
-------------------------------------------------------------------------------
function PH:CreateFocusedCard(parent, y, step, totalSteps, currentSkill, comboSkills)
    -- Use original guide range for status detection
    local origStart = (step.originalRange and step.originalRange[1]) or step.skillRange[1]
    local origEnd   = (step.originalRange and step.originalRange[2]) or step.skillRange[2]
    -- For combo: use the skill level matching this step's skill
    local stepSkill = currentSkill
    if comboSkills and step.skill and comboSkills[step.skill] then
        stepSkill = comboSkills[step.skill]
    end
    local isCurrent  = origStart <= stepSkill and origEnd > stepSkill
    local isComplete = origEnd <= stepSkill

    -- Calculate remaining crafts for this step
    local remaining, total = self:GetRemainingCrafts(step, stepSkill)
    local craftsDone = total - remaining

    local card = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    card:SetPoint("TOPLEFT", 0, y)
    card:SetPoint("RIGHT", parent, "RIGHT", 0, 0)

    if isCurrent then
        MakeFlat(card, T.greenDim, { T.green[1], T.green[2], T.green[3], 0.35 })
    elseif isComplete then
        MakeFlat(card, { 0.07, 0.07, 0.08, 0.8 })
        card:SetBackdropBorderColor(rgba(T.border, 0.3))
    else
        MakePanel(card, T.bgCard)
    end

    local iy = -10

    -- Badge + counter
    local badge = card:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    badge:SetPoint("TOPLEFT", 12, iy)
    if isComplete then
        badge:SetText(hexc(T.green) .. PH.L["BADGE_DONE"] .. "|r")
    elseif isCurrent then
        badge:SetText(hexc(T.green) .. PH.L["BADGE_CURRENT"] .. "|r")
    else
        badge:SetText(hexc(T.accent) .. PH.L["BADGE_NEXT"] .. "|r")
    end

    local cnt = card:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    cnt:SetPoint("TOPRIGHT", -12, iy)
    cnt:SetText(hexc(T.textMuted) .. step.index .. " / " .. totalSteps .. "|r")
    iy = iy - 20

    -- Skill range + live progress (use original range for full context)
    local range = card:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    range:SetPoint("TOPLEFT", 12, iy)
    local origStart = (step.originalRange and step.originalRange[1]) or step.skillRange[1]
    local origEnd   = (step.originalRange and step.originalRange[2]) or step.skillRange[2]
    local extra = ""
    local skillLabel = (step.skill and comboSkills) and (hexc(T.accent) .. step.skill .. "|r  ") or ""
    if isCurrent then
        local done  = stepSkill - origStart
        local rangeTotal = origEnd - origStart
        extra = "  " .. hexc(T.green) .. stepSkill .. "|r" .. hexc(T.textMuted) .. "/" .. origEnd .. "|r" ..
            "  " .. hexc(T.green) .. math.floor(done / rangeTotal * 100) .. "%|r"
    end
    range:SetText(skillLabel .. hexc(T.textSecondary) .. string.format(PH.L["SKILL_RANGE"], origStart, origEnd) .. "|r" .. extra)
    iy = iy - 16

    -- Mini progress bar for current step (based on original range)
    if isCurrent then
        local done  = stepSkill - origStart
        local rangeTotal = origEnd - origStart
        local pct   = math.min(1, math.max(0, done / rangeTotal))
        local miniBar = CreateFrame("Frame", nil, card, "BackdropTemplate")
        miniBar:SetHeight(4)
        miniBar:SetPoint("TOPLEFT", 12, iy)
        miniBar:SetPoint("RIGHT", card, "RIGHT", -12, 0)
        MakeFlat(miniBar, T.bgInput)
        miniBar:SetBackdropBorderColor(0,0,0,0)
        local mFill = miniBar:CreateTexture(nil, "ARTWORK")
        mFill:SetPoint("TOPLEFT", 1, -1)
        mFill:SetHeight(2)
        mFill:SetColorTexture(rgb(T.green))
        local function updateMiniFill(self)
            local w = self:GetWidth()
            if w > 2 then
                mFill:SetWidth(math.max(1, (w - 2) * pct))
            end
        end
        miniBar:SetScript("OnSizeChanged", updateMiniFill)
        -- Fallback: ensure fill is set on next frame
        miniBar:SetScript("OnUpdate", function(self)
            self:SetScript("OnUpdate", nil)
            updateMiniFill(self)
        end)
        iy = iy - 12
    else
        iy = iy - 6
    end

    -- Separator
    local sep = card:CreateTexture(nil, "ARTWORK")
    sep:SetHeight(1)
    sep:SetPoint("TOPLEFT", 12, iy)
    sep:SetPoint("RIGHT", card, "RIGHT", -12, 0)
    sep:SetColorTexture(rgba(T.border, 0.5))
    iy = iy - 12

    -- Recipe name
    local rn = card:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    rn:SetPoint("TOPLEFT", 12, iy)
    rn:SetPoint("RIGHT", card, "RIGHT", -12, 0)
    rn:SetJustifyH("LEFT")
    rn:SetText((isComplete and hexc(T.textMuted) or hexc(T.white)) .. step.recipe .. "|r")
    iy = iy - math.max(18, rn:GetStringHeight() + 6)

    -- Craft count with remaining
    local cl = card:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    cl:SetPoint("TOPLEFT", 12, iy)
    local interTag = step.isIntermediate and ("  " .. hexc(T.orange) .. PH.L["KEEP_TAG"] .. "|r") or ""
    if isComplete then
        cl:SetText(hexc(T.textMuted) .. string.format(PH.L["CRAFT_X_DONE"], total) .. "|r")
    elseif isCurrent then
        cl:SetText(hexc(T.gold) .. PH.L["CRAFTS_REMAINING_LABEL"] .. "|r " .. hexc(T.white) .. remaining .. "|r" ..
            hexc(T.textMuted) .. " / " .. total .. "|r" ..
            "  " .. hexc(T.green) .. string.format(PH.L["CRAFTS_DONE_COUNT"], craftsDone) .. "|r" .. interTag)
    else
        cl:SetText(hexc(T.gold) .. string.format(PH.L["CRAFT_X"], total) .. "|r" .. interTag)
    end
    iy = iy - 22

    -- Source (where to get the recipe)
    if step.source and step.source ~= "" and not isComplete then
        local filteredSource = FilterSourceByFaction(step.source)
        local sl = card:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        sl:SetPoint("TOPLEFT", 12, iy)
        sl:SetPoint("RIGHT", card, "RIGHT", -12, 0)
        sl:SetJustifyH("LEFT")
        sl:SetText(hexc(T.textMuted) .. PH.L["RECIPE"] .. ":|r " .. hexc(T.accent) .. filteredSource .. "|r")
        iy = iy - math.max(14, sl:GetStringHeight() + 4)

        -- Map pin button (shown when NPC coordinates are known)
        if PH.MapPins and PH.MapPins:HasPinsForSource(filteredSource) then
            local mapBtn = PillButton(card, 110, 18, PH.L["BTN_SHOW_ON_MAP"], T.gold)
            mapBtn:SetPoint("TOPLEFT", 12, iy)
            mapBtn:SetScript("OnClick", function()
                PH.MapPins:ShowSourcePins(filteredSource)
            end)
            mapBtn:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:AddLine(PH.L["BTN_SHOW_ON_MAP_TT"], 1, 1, 1, true)
                GameTooltip:Show()
            end)
            mapBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
            iy = iy - 24
        end
    end

    -- Tip
    if step.tip and step.tip ~= "" and not isComplete then
        local tl = card:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        tl:SetPoint("TOPLEFT", 12, iy)
        tl:SetPoint("RIGHT", card, "RIGHT", -12, 0)
        tl:SetJustifyH("LEFT")
        tl:SetText(hexc(T.orange) .. PH.L["TIP"] .. ":|r " .. hexc(T.textSecondary) .. step.tip .. "|r")
        iy = iy - math.max(14, tl:GetStringHeight() + 4)
    end

    -- Materials header
    local mh = card:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    mh:SetPoint("TOPLEFT", 12, iy)
    if isComplete then
        mh:SetText(hexc(T.textMuted) .. PH.L["MATERIALS"] .. "|r")
    elseif isCurrent then
        mh:SetText(hexc(T.accent) .. PH.L["MATERIALS_REMAINING"] .. "|r")
    else
        mh:SetText(hexc(T.accent) .. PH.L["MATERIALS"] .. "|r")
    end
    iy = iy - 18

    -- Material rows
    if step.materials then
        -- For current step: use original guide counts + skill progress to show accurate remaining
        local origRangeSize = origEnd - origStart
        local skillDone = isCurrent and math.max(0, stepSkill - origStart) or 0
        local skillPct = (origRangeSize > 0) and (skillDone / origRangeSize) or 0

        for mi, mat in ipairs(step.materials) do
            local row = CreateFrame("Frame", nil, card, "BackdropTemplate")
            row:SetHeight(20)
            row:SetPoint("TOPLEFT", 12, iy)
            row:SetPoint("RIGHT", card, "RIGHT", -12, 0)
            if mi % 2 == 0 then
                MakeFlat(row, { 0.09, 0.09, 0.12, 0.5 })
            else
                MakeFlat(row, { 0.07, 0.07, 0.09, 0.3 })
            end
            row:SetBackdropBorderColor(0,0,0,0)

            local matData, sourceTag = PH:GetMaterialInfo(mat.name)

            local src = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            src:SetPoint("LEFT", 6, 0)
            src:SetText(isComplete and hexc(T.textMuted) .. "-|r" or (sourceTag or ""))

            local nm = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            nm:SetPoint("LEFT", src, "RIGHT", 4, 0)
            nm:SetPoint("RIGHT", row, "CENTER", 20, 0)
            nm:SetJustifyH("LEFT")
            nm:SetText((isComplete and hexc(T.textMuted) or hexc(T.textPrimary)) .. mat.name .. "|r")

            local qtyStr
            if isComplete then
                qtyStr = hexc(T.textMuted) .. "x" .. (mat.originalNeeded or mat.totalNeeded) .. "|r"
            elseif isCurrent then
                -- Use original guide material count + skill progress for accurate tracking
                local origCount = mat.originalNeeded or mat.totalNeeded
                local matUsed = math.floor(origCount * skillPct)
                local matRemaining = origCount - matUsed

                -- Check bags for this material
                local inBag = 0
                if matData and matData.id then
                    inBag = GetItemCount(matData.id) or 0
                end

                if inBag > 0 then
                    local bagColor = (inBag >= matRemaining) and T.green or T.gold
                    qtyStr = hexc(T.white) .. matRemaining .. "|r" ..
                        hexc(T.textMuted) .. " " .. PH.L["MAT_REMAINING"] .. " " ..
                        hexc(bagColor) .. string.format(PH.L["MAT_IN_BAG"], inBag) .. "|r"
                else
                    qtyStr = hexc(T.white) .. matRemaining .. "|r" ..
                        hexc(T.textMuted) .. " " .. PH.L["MAT_REMAINING"] .. "|r" ..
                        hexc(T.textMuted) .. " " .. string.format(PH.L["MAT_USED"], matUsed, origCount) .. "|r"
                end
            elseif mat.fromBank and mat.fromBank > 0 then
                if mat.toBuy and mat.toBuy > 0 then
                    qtyStr = hexc(T.white) .. mat.totalNeeded .. "|r " .. hexc(T.textMuted) .. "(" .. mat.fromBank .. " " .. PH.L["MAT_IN_STOCK"] .. " + " .. hexc(T.gold) .. PH.L["MAT_BUY"] .. " " .. mat.toBuy .. "|r" .. hexc(T.textMuted) .. ")|r"
                else
                    qtyStr = hexc(T.green) .. mat.totalNeeded .. " (" .. PH.L["MAT_IN_STOCK"] .. ")|r"
                end
            else
                qtyStr = hexc(T.white) .. "x" .. mat.totalNeeded .. "|r"
            end
            local qty = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            qty:SetPoint("RIGHT", -6, 0)
            qty:SetJustifyH("RIGHT")
            qty:SetText(qtyStr)

            iy = iy - 22
        end
    end

    -- Intermediate usage
    if step.isIntermediate and step.laterUsage and #step.laterUsage > 0 and not isComplete then
        iy = iy - 4
        local ut = card:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        ut:SetPoint("TOPLEFT", 12, iy)
        ut:SetPoint("RIGHT", card, "RIGHT", -12, 0)
        ut:SetJustifyH("LEFT")
        local names = {}
        for _, u in ipairs(step.laterUsage) do table.insert(names, u.recipe or "?") end
        ut:SetText(hexc(T.orange) .. PH.L["DONT_SELL"] .. "|r " .. hexc(T.textSecondary) .. PH.L["USED_FOR"] .. " " .. table.concat(names, ", ") .. "|r")
        iy = iy - 16
    end

    -- Cost
    if step.cost and step.cost > 0 and not isComplete then
        iy = iy - 2
        local ct = card:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        ct:SetPoint("TOPLEFT", 12, iy)
        ct:SetText(hexc(T.textMuted) .. PH.L["STEP_COST_LABEL"] .. "|r " .. PH.TSM:FormatMoney(step.cost))
        iy = iy - 14
    end

    card:SetHeight(math.abs(iy) + 10)
    return y - math.abs(iy) - 16
end

-------------------------------------------------------------------------------
-- Next step preview
-------------------------------------------------------------------------------
function PH:CreateNextPreview(parent, y, step)
    local pv = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    pv:SetHeight(36)
    pv:SetPoint("TOPLEFT", 0, y)
    pv:SetPoint("RIGHT", parent, "RIGHT", 0, 0)
    MakeFlat(pv, T.bgInput)
    pv:SetBackdropBorderColor(0,0,0,0)

    local lbl = pv:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    lbl:SetPoint("TOPLEFT", 10, -5)
    lbl:SetText(hexc(T.textMuted) .. PH.L["NEXT_PREVIEW_LABEL"] .. "|r")

    local info = pv:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    info:SetPoint("TOPLEFT", 10, -18)
    info:SetPoint("RIGHT", pv, "RIGHT", -10, 0)
    info:SetJustifyH("LEFT")
    local tag = step.isIntermediate and (" " .. hexc(T.orange) .. PH.L["INTERMEDIATE_TAG"] .. "|r") or ""
    info:SetText(hexc(T.textPrimary) .. step.recipe .. "|r x" .. step.crafts ..
        "  " .. hexc(T.textMuted) .. "[" .. step.skillRange[1] .. "-" .. step.skillRange[2] .. "]|r" .. tag)

    return y - 42
end

-------------------------------------------------------------------------------
-- Trainers (shared)
-------------------------------------------------------------------------------
function PH:RenderTrainers(parent, y, profData)
    if not profData.trainer then return y end

    y = y - 4
    local sep = parent:CreateTexture(nil, "ARTWORK")
    sep:SetHeight(1)
    sep:SetPoint("TOPLEFT", 0, y)
    sep:SetPoint("RIGHT", parent, "RIGHT", 0, 0)
    sep:SetColorTexture(rgba(T.border, 0.4))
    y = y - 10

    local _, newY = SectionLabel(parent, y, PH.L["TRAINERS"], hexc(T.textMuted))
    y = newY

    local faction = UnitFactionGroup("player") or "Alliance"
    local trainers = profData.trainer[faction]
    if trainers then
        for _, trainer in ipairs(trainers) do
            local tt = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            tt:SetPoint("TOPLEFT", 8, y)
            tt:SetText(hexc(T.textSecondary) .. trainer .. "|r")
            y = y - 14
        end
    end
    return y
end

-------------------------------------------------------------------------------
-- Shopping content
-------------------------------------------------------------------------------
function PH:CreateShoppingContent(parent, profData, currentSkill, yOffset, comboSkills)
    local targetSkill = 375
    if currentSkill < 1 then currentSkill = 1 end

    local pathData = PH.PathCalculator:Calculate(profData, currentSkill, targetSkill, comboSkills)
    if not pathData or not pathData.shoppingList or #pathData.shoppingList == 0 then
        local msg = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        msg:SetPoint("TOPLEFT", 10, yOffset)
        msg:SetText(hexc(T.textMuted) .. PH.L["NO_MATERIALS_NEEDED"] .. "|r")
        return yOffset - 20
    end

    local y = yOffset

    -- Cost header
    local costCard = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    costCard:SetHeight(32)
    costCard:SetPoint("TOPLEFT", 0, y)
    costCard:SetPoint("RIGHT", parent, "RIGHT", 0, 0)
    MakePanel(costCard, T.bgCard)
    local costText = costCard:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    costText:SetPoint("LEFT", 10, 0)
    if pathData.hasPricing and pathData.totalCost > 0 then
        costText:SetText(hexc(T.gold) .. PH.L["TOTAL_COST"] .. ":|r " .. PH.TSM:FormatMoney(pathData.totalCost))
    else
        costText:SetText(hexc(T.gold) .. PH.L["SHOPPING_LIST"] .. "|r  " .. hexc(T.textMuted) .. PH.L["INSTALL_TSM"] .. "|r")
    end
    y = y - 38

    local ahItems, vendorItems = {}, {}
    for _, item in ipairs(pathData.shoppingList) do
        if item.isVendor then table.insert(vendorItems, item) else table.insert(ahItems, item) end
    end

    -- AH section
    if #ahItems > 0 then
        local _, ny = SectionLabel(parent, y, "AUCTION HOUSE", hexc(T.accent))
        y = ny

        -- Columns
        local colFrame = CreateFrame("Frame", nil, parent)
        colFrame:SetHeight(14)
        colFrame:SetPoint("TOPLEFT", 0, y)
        colFrame:SetPoint("RIGHT", parent, "RIGHT", 0, 0)
        local c1 = colFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        c1:SetPoint("LEFT", 8, 0); c1:SetText(hexc(T.textMuted) .. PH.L["COL_ITEM"] .. "|r")
        local c2 = colFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        c2:SetPoint("LEFT", colFrame, "RIGHT", -170, 0); c2:SetText(hexc(T.textMuted) .. PH.L["COL_QTY"] .. "|r")
        local c3 = colFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        c3:SetPoint("LEFT", colFrame, "RIGHT", -80, 0); c3:SetText(hexc(T.textMuted) .. PH.L["COL_PRICE"] .. "|r")
        y = y - 15

        local sep = parent:CreateTexture(nil, "ARTWORK")
        sep:SetHeight(1)
        sep:SetPoint("TOPLEFT", 0, y)
        sep:SetPoint("RIGHT", parent, "RIGHT", 0, 0)
        sep:SetColorTexture(rgba(T.border, 0.4))
        y = y - 3

        for i, item in ipairs(ahItems) do
            local row = CreateFrame("Frame", nil, parent, "BackdropTemplate")
            row:SetHeight(18)
            row:SetPoint("TOPLEFT", 0, y)
            row:SetPoint("RIGHT", parent, "RIGHT", 0, 0)
            if i % 2 == 0 then
                MakeFlat(row, { 0.09, 0.09, 0.12, 0.4 })
            else
                MakeFlat(row, { 0.07, 0.07, 0.09, 0.2 })
            end
            row:SetBackdropBorderColor(0,0,0,0)

            local _, srcTag = PH:GetMaterialInfo(item.name)
            local n = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            n:SetPoint("LEFT", 8, 0)
            n:SetPoint("RIGHT", row, "RIGHT", -172, 0)
            n:SetJustifyH("LEFT")
            n:SetText((srcTag or "") .. " " .. hexc(T.textPrimary) .. item.name .. "|r")

            local q = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            q:SetPoint("LEFT", row, "RIGHT", -170, 0)
            if item.inInventory and item.inInventory > 0 then
                if item.count > 0 then
                    q:SetText(hexc(T.white) .. item.count .. "|r" .. hexc(T.textMuted) .. " (" .. item.inInventory .. " inv)|r")
                else
                    q:SetText(hexc(T.green) .. "0|r" .. hexc(T.textMuted) .. " (" .. item.inInventory .. " inv)|r")
                end
            else
                q:SetText(hexc(T.white) .. item.count .. "|r")
            end

            if item.unitPrice and item.unitPrice > 0 then
                local p = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                p:SetPoint("LEFT", row, "RIGHT", -80, 0)
                p:SetText(PH.TSM:FormatMoney(item.unitPrice))
            end
            y = y - 19
        end

        y = y - 6
        local tsmBtn = PillButton(parent, 180, 24, "Gerar busca TSM", T.green)
        tsmBtn:SetPoint("TOPLEFT", 0, y)
        tsmBtn:SetScript("OnClick", function()
            local ml = {}
            for _, item in ipairs(ahItems) do
                if item.count > 0 then
                    table.insert(ml, { name = item.name, count = item.count })
                end
            end
            PH.TSM:OpenShoppingScan(PH.TSM:BuildShoppingString(ml))
        end)
        tsmBtn:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:AddLine("TSM Shopping")
            GameTooltip:AddLine(PH.L["TSM_BTN_TOOLTIP"], 1,1,1,true)
            GameTooltip:Show()
        end)
        tsmBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
        y = y - 30
    end

    -- Vendor section
    if #vendorItems > 0 then
        local _, ny = SectionLabel(parent, y, "VENDOR", hexc(T.green))
        y = ny
        for _, item in ipairs(vendorItems) do
            local it = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            it:SetPoint("TOPLEFT", 8, y)
            it:SetPoint("RIGHT", parent, "RIGHT", -8, 0)
            it:SetJustifyH("LEFT")
            local pr = (item.unitPrice and item.unitPrice > 0) and ("  " .. PH.TSM:FormatMoney(item.unitPrice) .. " " .. PH.L["MAT_EACH"]) or ""
            local invNote = (item.inInventory and item.inInventory > 0) and (hexc(T.textMuted) .. " (" .. item.inInventory .. " inv)|r") or ""
            it:SetText(hexc(T.green) .. "[V]|r " .. hexc(T.textPrimary) .. item.name .. "|r x" .. item.count .. invNote .. pr)
            y = y - 16
        end
    end

    y = self:RenderTrainers(parent, y, profData)
    return y
end

-------------------------------------------------------------------------------
-- Gold Farming Guide (shown when profession is at max skill 375)
-------------------------------------------------------------------------------
function PH:RenderGoldFarmingGuide(parent, yOffset, profName, comboSkills)
    local y = yOffset

    -- Resolve which professions to show tips for
    local profNames = {}
    if comboSkills then
        -- Combo: show tips for each sub-profession
        local profData = self:GetProfessionData(profName)
        if profData and profData.skills then
            for _, sk in ipairs(profData.skills) do
                table.insert(profNames, sk)
            end
        end
    else
        table.insert(profNames, profName)
    end

    -- Header card
    local headerCard = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    headerCard:SetHeight(52)
    headerCard:SetPoint("TOPLEFT", 0, y)
    headerCard:SetPoint("RIGHT", parent, "RIGHT", 0, 0)
    MakeFlat(headerCard, { 0.08, 0.14, 0.08, 0.95 }, { T.green[1], T.green[2], T.green[3], 0.4 })

    local checkIcon = headerCard:CreateTexture(nil, "ARTWORK")
    checkIcon:SetSize(20, 20)
    checkIcon:SetPoint("LEFT", 10, 0)
    checkIcon:SetTexture("Interface\\RAIDFRAME\\ReadyCheck-Ready")

    local headerTitle = headerCard:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    headerTitle:SetPoint("LEFT", 30, 6)
    headerTitle:SetText(hexc(T.green) .. PH.L["MAX_LEVEL_REACHED"] .. "|r")

    local headerSub = headerCard:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    headerSub:SetPoint("LEFT", 30, -8)
    headerSub:SetText(hexc(T.gold) .. PH.L["GOLD_FARM_GUIDE_TITLE"] .. "|r")

    y = y - 58

    -- Gather all gold data for the professions
    local goldData = PH.GoldFarming
    if not goldData then
        local msg = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        msg:SetPoint("TOPLEFT", 0, y)
        msg:SetText(hexc(T.textMuted) .. PH.L["GOLD_DATA_UNAVAILABLE"] .. "|r")
        return y - 20
    end

    for pi, pn in ipairs(profNames) do
        local data = goldData[pn]
        if not data or not data.tips then
            -- skip
        else
            -- Profession subtitle for combos
            if #profNames > 1 then
                local profLabel = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                profLabel:SetPoint("TOPLEFT", 0, y)
                profLabel:SetText(hexc(T.accent) .. "── " .. (PH.L[pn] or pn) .. " ──|r")
                y = y - 22
            end

            for ci, category in ipairs(data.tips) do
                -- Category header
                local catCard = CreateFrame("Frame", nil, parent, "BackdropTemplate")
                catCard:SetHeight(26)
                catCard:SetPoint("TOPLEFT", 0, y)
                catCard:SetPoint("RIGHT", parent, "RIGHT", 0, 0)
                MakeFlat(catCard, { 0.12, 0.12, 0.15, 0.8 })

                local catIcon = catCard:CreateTexture(nil, "ARTWORK")
                catIcon:SetSize(18, 18)
                catIcon:SetPoint("LEFT", 8, 0)
                if category.icon then
                    catIcon:SetTexture("Interface\\Icons\\" .. category.icon)
                end

                local catText = catCard:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                catText:SetPoint("LEFT", 30, 0)
                catText:SetText(hexc(T.gold) .. category.category .. "|r")

                y = y - 30

                -- Methods
                for mi, method in ipairs(category.methods) do
                    local row = CreateFrame("Frame", nil, parent, "BackdropTemplate")
                    row:SetPoint("TOPLEFT", 0, y)
                    row:SetPoint("RIGHT", parent, "RIGHT", 0, 0)

                    if mi % 2 == 0 then
                        MakeFlat(row, { 0.09, 0.09, 0.12, 0.4 })
                    else
                        MakeFlat(row, { 0.07, 0.07, 0.09, 0.2 })
                    end
                    row:SetBackdropBorderColor(0, 0, 0, 0)

                    -- Priority indicator
                    local prioColor = T.green
                    if method.priority == 2 then prioColor = T.gold
                    elseif method.priority >= 3 then prioColor = T.textMuted end

                    local prioBar = row:CreateTexture(nil, "ARTWORK")
                    prioBar:SetSize(3, 14)
                    prioBar:SetPoint("LEFT", 4, 0)
                    prioBar:SetColorTexture(prioColor[1], prioColor[2], prioColor[3], 0.9)

                    -- Name
                    local nm = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                    nm:SetPoint("LEFT", 12, 0)
                    nm:SetPoint("RIGHT", row, "RIGHT", -90, 0)
                    nm:SetJustifyH("LEFT")
                    nm:SetText(hexc(T.textPrimary) .. method.name .. "|r")

                    -- Gold per day
                    local gp = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                    gp:SetPoint("RIGHT", row, "RIGHT", -8, 0)
                    gp:SetJustifyH("RIGHT")
                    gp:SetText(hexc(T.gold) .. (method.goldPerDay or "") .. "|r")

                    -- Calculate row height based on name width (single line = 18)
                    row:SetHeight(20)
                    y = y - 21

                    -- Description (below the row)
                    local desc = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                    desc:SetPoint("TOPLEFT", 12, y)
                    desc:SetPoint("RIGHT", parent, "RIGHT", -8, 0)
                    desc:SetJustifyH("LEFT")
                    desc:SetSpacing(2)
                    desc:SetText(hexc(T.textSecondary) .. method.description .. "|r")

                    -- Estimate description height
                    local descHeight = desc:GetStringHeight() or 14
                    y = y - descHeight - 6

                    -- Cooldown tag if present
                    if method.cooldown then
                        local cdTag = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                        cdTag:SetPoint("TOPLEFT", 12, y)
                        cdTag:SetText(hexc(T.orange) .. "CD: " .. method.cooldown .. "|r")
                        y = y - 14
                    end

                    y = y - 2
                end -- methods

                y = y - 6
            end -- categories

            y = y - 4
        end -- if data
    end -- profNames

    return y
end

-------------------------------------------------------------------------------
-- Gathering content (step-based, mirrors crafting pattern)
-------------------------------------------------------------------------------
function PH:CreateGatheringContent(parent, profData, currentSkill, yOffset)
    local y = yOffset
    local GG = PH.GatherGuide

    -- Build steps from data
    GG:BuildSteps(profData, currentSkill)
    local steps = GG.steps
    local totalSteps = #steps

    if totalSteps == 0 then
        local msg = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        msg:SetPoint("TOP", 0, y - 20)
        msg:SetJustifyH("CENTER")
        msg:SetText(hexc(T.textMuted) .. PH.L["NO_FARM_DATA"] .. "|r")
        return y - 60
    end

    local targetSkill = 375
    local pct = math.min(1, currentSkill / targetSkill)
    local currentStepIdx = GG:GetCurrentStepIndex(currentSkill)

    -- Use viewedStepIndex for gathering (share state with GatherGuide.currentStep)
    local viewIdx = self.gatherViewStep
    if not viewIdx or viewIdx < 1 or viewIdx > totalSteps then viewIdx = currentStepIdx end

    -- Auto-advance: if the viewed step is now complete, jump to the current step.
    -- This handles the case where gatherViewStep was manually set to an earlier step
    -- during a session and the player's skill has since passed that step's cap.
    if steps[viewIdx] and steps[viewIdx].skillRange[2] <= currentSkill and viewIdx < currentStepIdx then
        viewIdx = currentStepIdx
        self.gatherViewStep = nil  -- follow current step going forward
    end

    local vs = steps[viewIdx]

    -- "Start Guide" button
    local guideBtn = PillButton(parent, 160, 24, GG.active and PH.L["GUIDE_STOP_BTN"] or PH.L["GUIDE_START_BTN"], GG.active and T.red or T.green)
    guideBtn:SetPoint("TOPLEFT", 0, y)
    guideBtn:SetScript("OnClick", function()
        PH:ToggleGatheringGuide(profData.name)
        PH:UpdateContentPanel()
    end)
    guideBtn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine(PH.L["GUIDE_TOOLTIP_TITLE"])
        if GG.active then
            GameTooltip:AddLine(PH.L["GUIDE_TOOLTIP_STOP"], 1,1,1,true)
        else
            GameTooltip:AddLine(PH.L["GUIDE_TOOLTIP_START"], 1,1,1,true)
        end
        GameTooltip:Show()
    end)
    guideBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    y = y - 32

    -- Progress bar
    local _, progY = SectionLabel(parent, y, string.format(PH.L["PROGRESS_LABEL"], currentSkill, targetSkill, pct * 100))
    FlatBar(parent, progY, pct, 8, pct < 0.5 and T.orange or T.green)
    y = progY - 18

    -- Timeline dots
    local tlFrame = CreateFrame("Frame", nil, parent)
    tlFrame:SetHeight(14)
    tlFrame:SetPoint("TOPLEFT", 0, y)
    tlFrame:SetPoint("RIGHT", parent, "RIGHT", 0, 0)
    tlFrame.dots = {}
    local function drawGatherDots(self)
        for _, d in ipairs(self.dots) do d:Hide() end
        self.dots = {}
        local w = self:GetWidth()
        if w < 10 or totalSteps < 1 then return end
        local dotW = math.min(12, math.max(4, (w - 4) / totalSteps - 1))
        local spacing = (w - 4) / totalSteps
        for i, step in ipairs(steps) do
            local dot = self:CreateTexture(nil, "ARTWORK")
            dot:SetSize(dotW, 4)
            dot:SetPoint("LEFT", 2 + (i-1) * spacing, 0)
            local comp = step.skillRange[2] <= currentSkill
            local cur  = step.skillRange[1] <= currentSkill and step.skillRange[2] > currentSkill
            if comp then
                dot:SetColorTexture(rgb(T.green)); dot:SetAlpha(0.7)
            elseif cur then
                dot:SetColorTexture(rgb(T.green)); dot:SetAlpha(1)
            else
                dot:SetColorTexture(rgba(T.textMuted, 0.3))
            end
            if i == viewIdx then
                local ring = self:CreateTexture(nil, "OVERLAY")
                ring:SetSize(dotW + 4, 8)
                ring:SetPoint("CENTER", dot, "CENTER")
                ring:SetColorTexture(rgba(T.accent, 0.35))
                table.insert(self.dots, ring)
            end
            table.insert(self.dots, dot)
        end
    end
    tlFrame:SetScript("OnSizeChanged", drawGatherDots)
    tlFrame:SetScript("OnUpdate", function(self)
        self:SetScript("OnUpdate", nil)
        drawGatherDots(self)
    end)
    y = y - 22

    -- Navigation
    local navFrame = CreateFrame("Frame", nil, parent)
    navFrame:SetHeight(26)
    navFrame:SetPoint("TOPLEFT", 0, y)
    navFrame:SetPoint("RIGHT", parent, "RIGHT", 0, 0)

    local prevBtn = PillButton(navFrame, 70, 22, "< Anterior", T.accent)
    prevBtn:SetPoint("LEFT", 0, 0)
    if viewIdx <= 1 then prevBtn:SetAlpha(0.3); prevBtn:Disable() end
    prevBtn:SetScript("OnClick", function()
        if viewIdx > 1 then PH.gatherViewStep = viewIdx - 1; PH:UpdateContentPanel() end
    end)

    local tierN = PH:GetSkillTier(vs.skillRange[1])
    local navLabel = navFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    navLabel:SetPoint("CENTER")
    navLabel:SetText(hexc(T.gold) .. string.format(PH.L["STEP"], viewIdx) .. "|r" .. hexc(T.textMuted) .. " / " .. totalSteps .. "  " .. tierN .. "|r")

    if viewIdx ~= currentStepIdx then
        local goBtn = PillButton(navFrame, 60, 20, PH.L["CURRENT"], T.green)
        goBtn:SetPoint("LEFT", navLabel, "RIGHT", 8, 0)
        goBtn:SetScript("OnClick", function() PH.gatherViewStep = nil; PH:UpdateContentPanel() end)
    end

    local nextBtn = PillButton(navFrame, 70, 22, PH.L["NEXT"] .. " >", T.accent)
    nextBtn:SetPoint("RIGHT", 0, 0)
    if viewIdx >= totalSteps then nextBtn:SetAlpha(0.3); nextBtn:Disable() end
    nextBtn:SetScript("OnClick", function()
        if viewIdx < totalSteps then PH.gatherViewStep = viewIdx + 1; PH:UpdateContentPanel() end
    end)
    y = y - 36

    -- Focused step card
    y = self:CreateGatheringStepCard(parent, y, vs, totalSteps, currentSkill, profData.name)

    -- Next step preview
    if viewIdx < totalSteps then
        local ns = steps[viewIdx + 1]
        local pvCard = CreateFrame("Frame", nil, parent, "BackdropTemplate")
        pvCard:SetHeight(30)
        pvCard:SetPoint("TOPLEFT", 0, y)
        pvCard:SetPoint("RIGHT", parent, "RIGHT", 0, 0)
        MakeFlat(pvCard, T.bgInput)
        pvCard:SetBackdropBorderColor(0,0,0,0)

        local pvLbl = pvCard:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        pvLbl:SetPoint("TOPLEFT", 10, -4)
        pvLbl:SetText(hexc(T.textMuted) .. "A seguir:|r")

        local pvInfo = pvCard:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        pvInfo:SetPoint("TOPLEFT", 10, -16)
        pvInfo:SetPoint("RIGHT", pvCard, "RIGHT", -10, 0)
        pvInfo:SetJustifyH("LEFT")
        pvInfo:SetText(hexc(T.textPrimary) .. ns.resource .. "|r  " ..
            hexc(T.textMuted) .. "[" .. ns.skillRange[1] .. "-" .. ns.skillRange[2] .. "]|r")
        y = y - 36
    end

    -- Summary footer
    y = y - 4
    local remaining = 0
    for _, s in ipairs(steps) do
        if s.skillRange[2] > currentSkill then remaining = remaining + 1 end
    end
    local footerCard = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    footerCard:SetHeight(24)
    footerCard:SetPoint("TOPLEFT", 0, y)
    footerCard:SetPoint("RIGHT", parent, "RIGHT", 0, 0)
    MakeFlat(footerCard, T.bgInput)
    local ft = footerCard:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    ft:SetPoint("LEFT", 8, 0)
    ft:SetText(hexc(T.textSecondary) .. remaining .. " passos restantes|r")
    y = y - 30

    -- Smelting section (Mining)
    if profData.smelting then
        local _, ny = SectionLabel(parent, y, ProfessionHelper.L["UI_SMELTING"], hexc(T.accent))
        y = ny
        for _, s in ipairs(profData.smelting) do
            if s.skill <= currentSkill + 50 then
                local st = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                st:SetPoint("TOPLEFT", 8, y)
                st:SetText(hexc(T.textMuted) .. "[" .. s.skill .. "]|r " .. hexc(T.textPrimary) .. s.name .. "|r")
                y = y - 16
            end
        end
        y = y - 6
    end

    -- Equipment (Fishing)
    if profData.equipment then
        local _, ny = SectionLabel(parent, y, ProfessionHelper.L["UI_EQUIPMENT"], hexc(T.accent))
        y = ny
        for _, eq in ipairs(profData.equipment) do
            local et = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            et:SetPoint("TOPLEFT", 8, y)
            et:SetText(hexc(T.accent) .. eq.name .. "|r " .. hexc(T.textSecondary) .. "- " .. eq.bonus .. "|r")
            y = y - 16
            local es = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            es:SetPoint("TOPLEFT", 16, y)
            es:SetText(hexc(T.textMuted) .. eq.source .. "|r")
            y = y - 16
        end
        y = y - 6
    end

    y = self:RenderTrainers(parent, y, profData)

    -- Tips
    if profData.tips then
        local _, ny = SectionLabel(parent, y - 6, ProfessionHelper.L["UI_TIPS"], hexc(T.gold))
        y = ny
        for _, tip in ipairs(profData.tips) do
            local tt = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            tt:SetPoint("TOPLEFT", 8, y)
            tt:SetPoint("RIGHT", parent, "RIGHT", -8, 0)
            tt:SetJustifyH("LEFT")
            tt:SetText(hexc(T.textSecondary) .. "• " .. tip .. "|r")
            local ttH = tt:GetStringHeight() or 14
            y = y - ttH - 4
        end
    end

    -- Gold farming guide at max skill
    if currentSkill >= 375 then
        y = y - 10
        y = self:RenderGoldFarmingGuide(parent, y, profData.name)
    end

    return y
end

-------------------------------------------------------------------------------
-- Gathering focused step card
-------------------------------------------------------------------------------
function PH:CreateGatheringStepCard(parent, y, step, totalSteps, currentSkill, profName)
    local isCurrent  = step.skillRange[1] <= currentSkill and step.skillRange[2] > currentSkill
    local isComplete = step.skillRange[2] <= currentSkill

    local card = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    card:SetPoint("TOPLEFT", 0, y)
    card:SetPoint("RIGHT", parent, "RIGHT", 0, 0)

    if isCurrent then
        MakeFlat(card, T.greenDim, { T.green[1], T.green[2], T.green[3], 0.35 })
    elseif isComplete then
        MakeFlat(card, { 0.07, 0.07, 0.08, 0.8 })
        card:SetBackdropBorderColor(rgba(T.border, 0.3))
    else
        MakePanel(card, T.bgCard)
    end

    local iy = -10

    -- Badge + counter
    local badge = card:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    badge:SetPoint("TOPLEFT", 12, iy)
    if isComplete then
        badge:SetText(hexc(T.green) .. ProfessionHelper.L["UI_STEP_COMPLETED"] .. "|r")
    elseif isCurrent then
        badge:SetText(hexc(T.green) .. ProfessionHelper.L["UI_STEP_CURRENT"] .. "|r")
    else
        badge:SetText(hexc(T.accent) .. ProfessionHelper.L["UI_STEP_NEXT"] .. "|r")
    end

    local cnt = card:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    cnt:SetPoint("TOPRIGHT", -12, iy)
    cnt:SetText(hexc(T.textMuted) .. step.index .. " / " .. totalSteps .. "|r")
    iy = iy - 20

    -- Skill range
    local range = card:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    range:SetPoint("TOPLEFT", 12, iy)
    local extra = ""
    if isCurrent and step.skillRange[2] > step.skillRange[1] then
        local done  = currentSkill - step.skillRange[1]
        local total = step.skillRange[2] - step.skillRange[1]
        extra = "  " .. hexc(T.green) .. math.floor(done / total * 100) .. "%|r"
    end
    range:SetText(hexc(T.textSecondary) .. string.format(PH.L["SKILL_RANGE"], step.skillRange[1], step.skillRange[2]) .. "|r" .. extra)
    iy = iy - 16

    -- Mini progress bar for current step
    if isCurrent and step.skillRange[2] > step.skillRange[1] then
        local done  = currentSkill - step.skillRange[1]
        local total = step.skillRange[2] - step.skillRange[1]
        local pct   = math.min(1, math.max(0, done / total))
        local miniBar = CreateFrame("Frame", nil, card, "BackdropTemplate")
        miniBar:SetHeight(4)
        miniBar:SetPoint("TOPLEFT", 12, iy)
        miniBar:SetPoint("RIGHT", card, "RIGHT", -12, 0)
        MakeFlat(miniBar, T.bgInput)
        miniBar:SetBackdropBorderColor(0,0,0,0)
        local mFill = miniBar:CreateTexture(nil, "ARTWORK")
        mFill:SetPoint("TOPLEFT", 1, -1)
        mFill:SetHeight(2)
        mFill:SetColorTexture(rgb(T.green))
        local function updateGatherFill(self)
            local w = self:GetWidth()
            if w > 2 then
                mFill:SetWidth(math.max(1, (w - 2) * pct))
            end
        end
        miniBar:SetScript("OnSizeChanged", updateGatherFill)
        miniBar:SetScript("OnUpdate", function(self)
            self:SetScript("OnUpdate", nil)
            updateGatherFill(self)
        end)
        iy = iy - 12
    else
        iy = iy - 6
    end

    -- Separator
    local sep = card:CreateTexture(nil, "ARTWORK")
    sep:SetHeight(1)
    sep:SetPoint("TOPLEFT", 12, iy)
    sep:SetPoint("RIGHT", card, "RIGHT", -12, 0)
    sep:SetColorTexture(rgba(T.border, 0.5))
    iy = iy - 12

    -- Resource name (large)
    local rn = card:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    rn:SetPoint("TOPLEFT", 12, iy)
    rn:SetPoint("RIGHT", card, "RIGHT", -12, 0)
    rn:SetJustifyH("LEFT")
    rn:SetText((isComplete and hexc(T.textMuted) or hexc(T.white)) .. step.resource .. "|r")
    iy = iy - math.max(18, rn:GetStringHeight() + 6)

    -- Leveling tip
    if step.tip then
        local tip = card:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        tip:SetPoint("TOPLEFT", 12, iy)
        tip:SetPoint("RIGHT", card, "RIGHT", -12, 0)
        tip:SetJustifyH("LEFT")
        tip:SetText(hexc(T.gold) .. "Dica:|r " .. hexc(T.textSecondary) .. step.tip .. "|r")
        local tipH = tip:GetStringHeight() or 14
        iy = iy - math.max(16, tipH + 4)
    end

    -- Locations header
    if step.locations and #step.locations > 0 then
        local lh = card:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        lh:SetPoint("TOPLEFT", 12, iy)
        lh:SetText(isComplete and hexc(T.textMuted) .. PH.L["LOCATIONS"] .. "|r" or hexc(T.accent) .. PH.L["LOCATIONS"] .. "|r")
        iy = iy - 18

        for li, loc in ipairs(step.locations) do
            local row = CreateFrame("Frame", nil, card, "BackdropTemplate")
            row:SetPoint("TOPLEFT", 12, iy)
            row:SetPoint("RIGHT", card, "RIGHT", -12, 0)
            if li % 2 == 0 then
                MakeFlat(row, { 0.09, 0.09, 0.12, 0.5 })
            else
                MakeFlat(row, { 0.07, 0.07, 0.09, 0.3 })
            end
            row:SetBackdropBorderColor(0,0,0,0)

            local rowIy = -4
            -- Zone name
            local fc = loc.faction == "Alliance" and "|cff5599ff" or (loc.faction == "Horde" and "|cffff4444" or hexc(T.gold))
            local zn = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            zn:SetPoint("TOPLEFT", 6, rowIy)
            zn:SetText(fc .. loc.zone .. "|r" ..
                (loc.levelRange and ("  " .. hexc(T.textMuted) .. "Lv " .. loc.levelRange .. "|r") or ""))
            rowIy = rowIy - 14

            -- Route
            local routeStr = loc.route or loc.spot or nil
            if routeStr and not isComplete then
                local rt = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                rt:SetPoint("TOPLEFT", 6, rowIy)
                rt:SetPoint("RIGHT", row, "RIGHT", -6, 0)
                rt:SetJustifyH("LEFT")
                rt:SetText(hexc(T.textSecondary) .. routeStr .. "|r")
                local rtH = rt:GetStringHeight() or 12
                rowIy = rowIy - math.max(14, rtH + 2)
            end

            -- Mobs (Skinning)
            if loc.mobs and not isComplete then
                local mb = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                mb:SetPoint("TOPLEFT", 6, rowIy)
                mb:SetPoint("RIGHT", row, "RIGHT", -6, 0)
                mb:SetJustifyH("LEFT")
                mb:SetText(hexc(T.orange) .. "Mobs:|r " .. hexc(T.textPrimary) .. loc.mobs .. "|r")
                rowIy = rowIy - 16
            end

            -- Tips
            if loc.tips and not isComplete then
                local tp = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                tp:SetPoint("TOPLEFT", 6, rowIy)
                tp:SetPoint("RIGHT", row, "RIGHT", -6, 0)
                tp:SetJustifyH("LEFT")
                tp:SetText(hexc(T.green) .. "> " .. loc.tips .. "|r")
                local tpH = tp:GetStringHeight() or 12
                rowIy = rowIy - math.max(14, tpH + 2)
            end

            -- Fishing spot map pin button
            if profName == "Fishing" and PH.MapPins and PH.MapPins:HasFishingSpot(loc.zone) and not isComplete then
                local pinBtn = PillButton(row, 100, 16, PH.L["BTN_SHOW_ON_MAP"], T.gold)
                pinBtn:SetPoint("TOPLEFT", 6, rowIy)
                pinBtn:SetScript("OnClick", function()
                    PH.MapPins:ShowFishingSpot(loc.zone)
                end)
                pinBtn:SetScript("OnEnter", function(self)
                    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                    GameTooltip:AddLine(PH.L["BTN_SHOW_ON_MAP_TT"], 1, 1, 1, true)
                    GameTooltip:Show()
                end)
                pinBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
                rowIy = rowIy - 22
            end

            row:SetHeight(math.abs(rowIy) + 6)
            iy = iy - (math.abs(rowIy) + 8)
        end
    end

    card:SetHeight(math.abs(iy) + 10)
    return y - math.abs(iy) - 16
end

-------------------------------------------------------------------------------
-- Credits & About Popup
-------------------------------------------------------------------------------
function PH:ShowCreditsPopup()
    if self.CreditsFrame then
        self.CreditsFrame:Show()
        return
    end

    local popup = CreateFrame("Frame", "PHCreditsPopup", UIParent, "BackdropTemplate")
    popup:SetSize(480, 520)
    popup:SetPoint("CENTER")
    popup:SetFrameStrata("DIALOG")
    popup:SetFrameLevel(100)
    MakeFlat(popup, T.bg, T.border)
    
    -- Shadow
    local shadow = CreateFrame("Frame", nil, popup, "BackdropTemplate")
    shadow:SetPoint("TOPLEFT", -4, 4)
    shadow:SetPoint("BOTTOMRIGHT", 4, -4)
    shadow:SetFrameLevel(popup:GetFrameLevel() - 1)
    shadow:SetBackdrop({
        bgFile   = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 4,
    })
    shadow:SetBackdropColor(0, 0, 0, 0.8)
    shadow:SetBackdropBorderColor(0, 0, 0, 0.6)
    
    -- Header
    local header = CreateFrame("Frame", nil, popup, "BackdropTemplate")
    header:SetHeight(44)
    header:SetPoint("TOPLEFT", 1, -1)
    header:SetPoint("TOPRIGHT", -1, -1)
    MakeFlat(header, { 0.08, 0.08, 0.11, 1 })
    
    local headerIcon = header:CreateTexture(nil, "ARTWORK")
    headerIcon:SetSize(24, 24)
    headerIcon:SetPoint("LEFT", 14, 0)
    headerIcon:SetTexture("Interface\\Icons\\INV_Misc_Book_09")
    headerIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    
    local headerTitle = header:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    headerTitle:SetPoint("LEFT", headerIcon, "RIGHT", 10, 0)
    headerTitle:SetText(hexc(T.gold) .. PH.L["ABOUT"] .. "|r")
    
    -- Close button
    local closeBtn = CreateFrame("Button", nil, header)
    closeBtn:SetSize(36, 36)
    closeBtn:SetPoint("RIGHT", -4, 0)
    local closeTex = closeBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    closeTex:SetPoint("CENTER", 0, 1)
    closeTex:SetText(hexc(T.textSecondary) .. "�|r")
    local closeHL = closeBtn:CreateTexture(nil, "HIGHLIGHT")
    closeHL:SetAllPoints()
    closeHL:SetColorTexture(rgba(T.red, 0.25))
    closeBtn:SetScript("OnClick", function() popup:Hide() end)
    
    -- Content scroll
    local scrollFrame, scrollChild = CreateScrollFrame(popup, "PHCreditsScroll")
    scrollFrame:SetPoint("TOPLEFT", 8, -52)
    scrollFrame:SetPoint("BOTTOMRIGHT", -20, 8)
    scrollChild:SetWidth(scrollFrame:GetWidth() - 8)
    
    local y = -12
    
    -- Main icon & title
    local mainIcon = scrollChild:CreateTexture(nil, "ARTWORK")
    mainIcon:SetSize(48, 48)
    mainIcon:SetPoint("TOP", 0, y)
    mainIcon:SetTexture("Interface\\Icons\\INV_Misc_Book_09")
    mainIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    y = y - 56
    
    local addonName = scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
    addonName:SetPoint("TOP", 0, y)
    addonName:SetText(hexc(T.gold) .. "Profession Helper|r")
    y = y - 26
    
    local version = scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    version:SetPoint("TOP", 0, y)
    version:SetText(hexc(T.textMuted) .. PH.L["VERSION"] .. " 1.0.0 - TBC Classic|r")
    y = y - 24
    
    -- Description
    local desc = scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    desc:SetPoint("TOP", 0, y)
    desc:SetWidth(400)
    desc:SetJustifyH("CENTER")
    desc:SetSpacing(2)
    desc:SetText(hexc(T.textPrimary) .. PH.L["DESCRIPTION_LINE1"] .. "|r\\n" ..
        hexc(T.textSecondary) .. PH.L["DESCRIPTION_LINE2"] .. "|r")
    y = y - 40
    
    -- Separator
    local sep1 = scrollChild:CreateTexture(nil, "ARTWORK")
    sep1:SetHeight(1)
    sep1:SetPoint("TOP", 0, y)
    sep1:SetWidth(380)
    sep1:SetColorTexture(rgba(T.border, 0.5))
    y = y - 16
    
    -- Author section
    local authorLabel = scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    authorLabel:SetPoint("TOP", 0, y)
    authorLabel:SetText(hexc(T.accent) .. PH.L["DEVELOPED_BY"] .. "|r")
    y = y - 22
    
    local authorName = scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    authorName:SetPoint("TOP", 0, y)
    authorName:SetText(hexc(T.white) .. "Chehul @ DreamScyther-US|r")
    y = y - 20
    
    -- GitHub link with icon
    local githubIcon = scrollChild:CreateTexture(nil, "ARTWORK")
    githubIcon:SetSize(16, 16)
    githubIcon:SetPoint("TOP", -90, y)
    githubIcon:SetTexture("Interface\\FriendsFrame\\UI-Toast-FriendOnlineIcon")
    githubIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    
    local githubLink = scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    githubLink:SetPoint("LEFT", githubIcon, "RIGHT", 6, 0)
    githubLink:SetText(hexc(T.green) .. "github.com/danielcosta42|r")
    y = y - 26
    
    -- Separator
    local sep2 = scrollChild:CreateTexture(nil, "ARTWORK")
    sep2:SetHeight(1)
    sep2:SetPoint("TOP", 0, y)
    sep2:SetWidth(380)
    sep2:SetColorTexture(rgba(T.border, 0.5))
    y = y - 16
    
    -- Features section
    local featLabel = scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    featLabel:SetPoint("TOP", 0, y)
    featLabel:SetText(hexc(T.accent) .. PH.L["FEATURES"] .. "|r")
    y = y - 22
    
    local features = {
        PH.L["FEATURE_1"],
        PH.L["FEATURE_2"],
        PH.L["FEATURE_3"],
        PH.L["FEATURE_4"],
        PH.L["FEATURE_5"],
        PH.L["FEATURE_6"],
    }
    
    for i, feat in ipairs(features) do
        local bullet = scrollChild:CreateTexture(nil, "ARTWORK")
        bullet:SetSize(4, 4)
        bullet:SetPoint("TOP", -160, y - 4)
        bullet:SetColorTexture(rgb(T.accent))
        
        local featText = scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        featText:SetPoint("LEFT", bullet, "RIGHT", 8, 0)
        featText:SetText(hexc(T.textPrimary) .. feat .. "|r")
        y = y - 16
    end
    
    y = y - 8
    
    -- Separator
    local sep3 = scrollChild:CreateTexture(nil, "ARTWORK")
    sep3:SetHeight(1)
    sep3:SetPoint("TOP", 0, y)
    sep3:SetWidth(380)
    sep3:SetColorTexture(rgba(T.border, 0.5))
    y = y - 16
    
    -- License
    local licLabel = scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    licLabel:SetPoint("TOP", 0, y)
    licLabel:SetText(hexc(T.orange) .. PH.L["LICENSE"] .. "|r")
    y = y - 18
    
    local licText = scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    licText:SetPoint("TOP", 0, y)
    licText:SetWidth(380)
    licText:SetJustifyH("CENTER")
    licText:SetText(hexc(T.textSecondary) .. PH.L["LICENSE_TEXT"] .. "|r")
    y = y - 30
    
    -- Thank you message
    local thanks = scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    thanks:SetPoint("TOP", 0, y)
    thanks:SetText(hexc(T.green) .. PH.L["THANK_YOU"] .. "|r")
    y = y - 20
    
    scrollChild:SetHeight(math.abs(y) + 20)
    
    self.CreditsFrame = popup
    popup:Show()
end
