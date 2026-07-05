-- Profession Helper - Marketplace panel (in-window, full-width, interactive)
--
-- Built INTO the main window's content area (sidebar button just below Home).
-- Live stat tiles, full-width tabs, a profession filter, and interactive cards
-- (item icon + hover tooltip + one-click whisper). Data from PH.Marketplace.

local PH = _G.ProfessionHelper

local C = {
    bgTile   = { 0.11, 0.11, 0.15, 1 },
    bgRow    = { 0.10, 0.10, 0.13, 0.6 },
    bgRowHi  = { 0.18, 0.20, 0.26, 0.9 },
    bgTabOn  = { 0.20, 0.32, 0.46, 1 },
    bgTabOff = { 0.12, 0.12, 0.16, 1 },
    bgChipOn = { 0.24, 0.36, 0.20, 1 },
    bgChipOff = { 0.12, 0.12, 0.16, 1 },
    border   = { 0.18, 0.18, 0.22, 1 },
    gold  = "|cffffd700",
    green = "|cff3ad17a",
    grey  = "|cff8e8e93",
    faint = "|cff6e6e73",
    white = "|cffe6e6e6",
}

local FLAT = {
    bgFile = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\Buttons\\WHITE8X8",
    edgeSize = 1,
}

local TABS = {
    { key = "opps",     labelKey = "MP_TAB_OPPS" },
    { key = "orders",   labelKey = "MP_TAB_ORDERS" },
    { key = "offers",   labelKey = "MP_TAB_OFFERS" },
    { key = "crafters", labelKey = "MP_TAB_CRAFTERS" },
}

-- Crafting professions offered as filter chips.
local CRAFTING_PROFS = {
    "Alchemy", "Blacksmithing", "Enchanting", "Engineering",
    "Jewelcrafting", "Leatherworking", "Tailoring",
}

local ROW_H = 28
local PAD = 12

local function Flat(frame, color)
    frame:SetBackdrop(FLAT)
    frame:SetBackdropColor(color[1], color[2], color[3], color[4] or 1)
    frame:SetBackdropBorderColor(C.border[1], C.border[2], C.border[3], 1)
end

local function ProfIconPath(profName)
    for _, p in ipairs(PH.Professions or {}) do
        if p.name == profName and p.icon then
            return "Interface\\Icons\\" .. p.icon
        end
    end
    return "Interface\\Icons\\INV_Misc_QuestionMark"
end

-- Resolve an item's icon + a tooltip-able link from an itemID (preferred) or name.
local function ItemIconFor(itemID, name)
    local ic = GetItemIcon and GetItemIcon(itemID or name)
    return ic or "Interface\\Icons\\INV_Misc_QuestionMark"
end

local function ItemLinkFor(itemID, name)
    if itemID then
        return "item:" .. itemID
    end
    if name and GetItemInfo then
        local _, link = GetItemInfo(name)
        return link
    end
    return nil
end

-------------------------------------------------------------------------------
-- Widgets
-------------------------------------------------------------------------------

local function MakeTile(parent)
    local tile = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    tile:SetHeight(34)
    Flat(tile, C.bgTile)
    local num = tile:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    num:SetPoint("TOPLEFT", 8, -3)
    num:SetText(C.gold .. "0|r")
    local lbl = tile:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    lbl:SetPoint("BOTTOMLEFT", 8, 4)
    lbl:SetPoint("RIGHT", -4, 0)
    lbl:SetJustifyH("LEFT")
    tile.num, tile.lbl = num, lbl
    return tile
end

local function MakeChip(parent, prof, onClick)
    local chip = CreateFrame("Button", nil, parent, "BackdropTemplate")
    chip:SetSize(24, 22)
    Flat(chip, C.bgChipOff)
    chip:SetBackdropBorderColor(0, 0, 0, 0)
    chip.prof = prof
    if prof then
        local ico = chip:CreateTexture(nil, "ARTWORK")
        ico:SetPoint("CENTER")
        ico:SetSize(16, 16)
        ico:SetTexture(ProfIconPath(prof))
        ico:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    else
        local lbl = chip:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        lbl:SetPoint("CENTER")
        lbl:SetText(C.white .. (PH.L["MP_FILTER_ALL"] or "All") .. "|r")
        chip:SetWidth(40)
    end
    local hl = chip:CreateTexture(nil, "HIGHLIGHT")
    hl:SetAllPoints()
    hl:SetColorTexture(1, 1, 1, 0.12)
    chip:SetScript("OnEnter", function(self)
        if prof then
            GameTooltip:SetOwner(self, "ANCHOR_TOP")
            GameTooltip:SetText(PH:GetLocalizedProfessionName(prof))
            GameTooltip:Show()
        end
    end)
    chip:SetScript("OnLeave", function() GameTooltip:Hide() end)
    chip:SetScript("OnClick", function() onClick(prof) end)
    return chip
end

local function GetRow(panel, n)
    if not panel.rows[n] then
        local child = panel.scrollChild
        local row = CreateFrame("Button", nil, child)
        row:SetHeight(ROW_H)
        row:EnableMouse(true)

        local bg = row:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints()
        bg:SetColorTexture(C.bgRow[1], C.bgRow[2], C.bgRow[3], C.bgRow[4])
        row.bg = bg

        local icon = row:CreateTexture(nil, "ARTWORK")
        icon:SetSize(20, 20)
        icon:SetPoint("LEFT", 4, 0)
        icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        row.icon = icon

        local text = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        text:SetPoint("LEFT", icon, "RIGHT", 6, 0)
        text:SetPoint("RIGHT", -56, 0)
        text:SetJustifyH("LEFT")
        text:SetWordWrap(false)
        row.text = text

        local wbtn = CreateFrame("Button", nil, row, "BackdropTemplate")
        wbtn:SetSize(46, 16)
        wbtn:SetPoint("RIGHT", -4, 0)
        wbtn:SetBackdrop(FLAT)
        wbtn:SetBackdropColor(0.16, 0.42, 0.30, 1)
        wbtn:SetBackdropBorderColor(0, 0, 0, 0)
        local wl = wbtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        wl:SetPoint("CENTER")
        wl:SetText(C.white .. "/w|r")
        local whl = wbtn:CreateTexture(nil, "HIGHLIGHT")
        whl:SetAllPoints()
        whl:SetColorTexture(1, 1, 1, 0.18)
        row.wbtn = wbtn

        row:SetScript("OnEnter", function(self)
            self.bg:SetColorTexture(C.bgRowHi[1], C.bgRowHi[2], C.bgRowHi[3], C.bgRowHi[4])
            if self.link then
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetHyperlink(self.link)
                GameTooltip:Show()
            end
        end)
        row:SetScript("OnLeave", function(self)
            self.bg:SetColorTexture(C.bgRow[1], C.bgRow[2], C.bgRow[3], C.bgRow[4])
            GameTooltip:Hide()
        end)

        panel.rows[n] = row
    end
    return panel.rows[n]
end

-------------------------------------------------------------------------------
-- Build (called once from Main.lua with the market panel frame)
-------------------------------------------------------------------------------

function PH:BuildMarketPanel(panel)
    PH.marketPanel = panel
    panel.mode = "opps"
    panel.profFilter = nil
    panel.rows = {}

    local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", PAD, -10)
    title:SetText(C.gold .. (PH.L["MP_TITLE"] or "Marketplace") .. "|r")
    local sub = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    sub:SetPoint("LEFT", title, "RIGHT", 8, 0)
    sub:SetText(C.faint .. (PH.L["MP_SUBTITLE"] or "") .. "|r")

    -- Stat tiles (laid out full-width in UpdateMarketPanel; fixed fallback here)
    panel.tiles = {}
    for i = 1, 4 do
        local tile = MakeTile(panel)
        tile:SetWidth(112)
        tile:SetPoint("TOPLEFT", PAD + (i - 1) * 116, -34)
        panel.tiles[i] = tile
    end
    panel.tiles[1].lbl:SetText(C.grey .. (PH.L["MP_TAB_OPPS"] or "Opportunities") .. "|r")
    panel.tiles[2].lbl:SetText(C.grey .. (PH.L["MP_TAB_ORDERS"] or "Orders") .. "|r")
    panel.tiles[3].lbl:SetText(C.grey .. (PH.L["MP_TAB_OFFERS"] or "Offers") .. "|r")
    panel.tiles[4].lbl:SetText(C.grey .. (PH.L["MP_STAT_PEERS"] or "Crafters online") .. "|r")

    -- Tabs (full-width in UpdateMarketPanel)
    panel.tabButtons = {}
    for _, tab in ipairs(TABS) do
        local btn = CreateFrame("Button", nil, panel, "BackdropTemplate")
        btn:SetHeight(22)
        Flat(btn, C.bgTabOff)
        btn:SetBackdropBorderColor(0, 0, 0, 0)
        local lbl = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        lbl:SetPoint("CENTER")
        lbl:SetText(PH.L[tab.labelKey] or tab.key)
        btn.tabKey = tab.key
        btn:SetWidth(120)
        btn:SetPoint("TOPLEFT", PAD + #panel.tabButtons * 124, -78)
        btn:SetScript("OnClick", function()
            panel.mode = tab.key
            PH:UpdateMarketPanel()
        end)
        panel.tabButtons[#panel.tabButtons + 1] = btn
    end

    -- Profession filter chips
    local function SetFilter(prof)
        panel.profFilter = prof
        PH:UpdateMarketPanel()
    end
    panel.chips = {}
    local cx = PAD
    local allChip = MakeChip(panel, nil, SetFilter)
    allChip:SetPoint("TOPLEFT", cx, -104)
    panel.chips[#panel.chips + 1] = allChip
    cx = cx + allChip:GetWidth() + 4
    for _, prof in ipairs(CRAFTING_PROFS) do
        local chip = MakeChip(panel, prof, SetFilter)
        chip:SetPoint("TOPLEFT", cx, -104)
        panel.chips[#panel.chips + 1] = chip
        cx = cx + chip:GetWidth() + 4
    end

    -- Scroll list (thin, art-stripped scrollbar; near full width)
    local sf = CreateFrame("ScrollFrame", "PHMarketScroll", panel, "UIPanelScrollFrameTemplate")
    sf:SetPoint("TOPLEFT", PAD, -132)
    sf:SetPoint("BOTTOMRIGHT", -10, 26)
    local child = CreateFrame("Frame", "PHMarketScrollChild", sf)
    child:SetWidth(sf:GetWidth())
    child:SetHeight(1)
    sf:SetScrollChild(child)
    panel.scroll = sf
    panel.scrollChild = child

    local sbName = sf:GetName()
    local sb = sbName and _G[sbName .. "ScrollBar"]
    if sb then
        for _, region in pairs({ sb:GetRegions() }) do region:SetAlpha(0) end
        local up = _G[sbName .. "ScrollBarScrollUpButton"]
        local dn = _G[sbName .. "ScrollBarScrollDownButton"]
        if up then up:SetAlpha(0); up:SetSize(1, 1) end
        if dn then dn:SetAlpha(0); dn:SetSize(1, 1) end
        local thumb = sb:GetThumbTexture()
        if thumb then thumb:SetColorTexture(0.35, 0.35, 0.4, 0.35); thumb:SetSize(4, 40) end
    end

    local footer = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    footer:SetPoint("BOTTOMLEFT", PAD, 8)
    footer:SetPoint("BOTTOMRIGHT", -PAD, 8)
    footer:SetJustifyH("LEFT")
    panel.footer = footer

    PH.Event:On("PH_MARKET_UPDATED", function()
        if PH.marketPanel and PH.marketPanel:IsShown() then PH:UpdateMarketPanel() end
    end, "MarketPanel")
end

-------------------------------------------------------------------------------
-- Layout (full-width) + refresh
-------------------------------------------------------------------------------

local function LayoutFullWidth(panel)
    local W = panel:GetWidth()
    if not W or W < 60 then return end
    local gap = 6
    local tw = math.floor((W - 2 * PAD - 3 * gap) / 4)
    for i, tile in ipairs(panel.tiles) do
        tile:SetWidth(tw)
        tile:ClearAllPoints()
        tile:SetPoint("TOPLEFT", PAD + (i - 1) * (tw + gap), -34)
    end
    local nTabs = #panel.tabButtons
    local tabw = math.floor((W - 2 * PAD - (nTabs - 1) * gap) / nTabs)
    for i, btn in ipairs(panel.tabButtons) do
        btn:SetWidth(tabw)
        btn:ClearAllPoints()
        btn:SetPoint("TOPLEFT", PAD + (i - 1) * (tabw + gap), -78)
    end
end

local function FormatPrice(price)
    if price and PH.TSM and PH.TSM.FormatMoney then
        return "  " .. PH.TSM:FormatMoney(price)
    end
    return ""
end

local function CountKeys(t)
    local n = 0
    for _ in pairs(t or {}) do n = n + 1 end
    return n
end

-- Does an entry belong to the active profession filter?
local function ProfMatches(e, filter)
    if not filter then return true end
    if e.isCrafter then return e.profs ~= nil and e.profs:find(filter, 1, true) ~= nil end
    if e.prof then return e.prof == filter end
    if e.canCraft then
        for _, m in ipairs(e.canCraft) do
            if m.prof == filter then return true end
        end
    end
    return false
end

function PH:UpdateMarketPanel()
    local panel = PH.marketPanel
    if not panel or not panel:IsShown() then return end
    local MP = PH.Marketplace
    if not MP then return end

    LayoutFullWidth(panel)

    local opps   = MP:GetOpportunities()
    local orders = MP:GetOrders()
    local offers = MP:GetMyOffers()

    panel.tiles[1].num:SetText(C.green .. #opps .. "|r")
    panel.tiles[2].num:SetText(C.gold .. #orders .. "|r")
    panel.tiles[3].num:SetText(C.gold .. #offers .. "|r")
    local peers = (_G.ChehulNet and _G.ChehulNet.Count) and _G.ChehulNet:Count("ph") or 0
    panel.tiles[4].num:SetText(C.gold .. peers .. "|r")

    for _, btn in ipairs(panel.tabButtons) do
        local col = (btn.tabKey == panel.mode) and C.bgTabOn or C.bgTabOff
        btn:SetBackdropColor(col[1], col[2], col[3], 1)
    end
    for _, chip in ipairs(panel.chips) do
        local col = (chip.prof == panel.profFilter) and C.bgChipOn or C.bgChipOff
        chip:SetBackdropColor(col[1], col[2], col[3], 1)
    end

    for _, row in pairs(panel.rows) do row:Hide() end

    local source, showWhisper, emptyKey
    if panel.mode == "orders" then
        source, showWhisper, emptyKey = orders, true, "MP_EMPTY_ORDERS"
    elseif panel.mode == "offers" then
        source, showWhisper, emptyKey = offers, false, "MP_EMPTY_OFFERS"
    elseif panel.mode == "crafters" then
        source, showWhisper, emptyKey = MP:GetCrafters(), true, "MP_EMPTY_CRAFTERS"
    else
        source, showWhisper, emptyKey = opps, true, "MP_EMPTY_OPPS"
    end

    -- Apply the profession filter.
    local entries = {}
    for _, e in ipairs(source) do
        if ProfMatches(e, panel.profFilter) then
            entries[#entries + 1] = e
        end
    end

    local child = panel.scrollChild
    child:SetWidth(math.max(1, panel.scroll:GetWidth()))
    local yOff = 0

    if #entries == 0 then
        local row = GetRow(panel, 1)
        row.wbtn:Hide()
        row.icon:SetTexture(nil)
        row.link = nil
        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", 0, 0)
        row:SetPoint("RIGHT", child, "RIGHT", 0, 0)
        row.text:SetText(C.faint .. (PH.L[emptyKey] or "Nothing yet.") .. "|r")
        row.bg:SetColorTexture(0, 0, 0, 0)
        row:Show()
        child:SetHeight(ROW_H)
    else
        for i, e in ipairs(entries) do
            local row = GetRow(panel, i)
            row:ClearAllPoints()
            row:SetPoint("TOPLEFT", 0, yOff)
            row:SetPoint("RIGHT", child, "RIGHT", 0, 0)
            row.bg:SetColorTexture(C.bgRow[1], C.bgRow[2], C.bgRow[3], C.bgRow[4])

            local line
            if panel.mode == "crafters" then
                row.icon:SetTexture("Interface\\Icons\\INV_Misc_GroupLooking")
                row.link = nil
                local cc = (PH.AltManager and PH.AltManager.CLASS_COLORS
                    and PH.AltManager.CLASS_COLORS[e.class]) or "cccccc"
                local lvl = e.level and ("  " .. C.grey .. "Lv" .. e.level .. "|r") or ""
                line = string.format("|cff%s%s|r%s  %s%s|r",
                    cc, e.name, lvl, C.faint, e.profs or "")
            elseif panel.mode == "offers" then
                row.icon:SetTexture(ItemIconFor(e.itemID, e.name))
                row.link = ItemLinkFor(e.itemID, e.name)
                line = string.format("%s%s|r  %s%s|r%s%s|r",
                    C.green, e.name, C.grey, table.concat(e.chars, ", "),
                    C.faint, FormatPrice(e.price))
            else
                row.icon:SetTexture(ItemIconFor(e.itemID, e.name))
                row.link = ItemLinkFor(e.itemID, e.name)
                local nameCol = e.canCraft and C.green or C.white
                local tag = e.canCraft and (" " .. C.green .. "\226\153\166|r") or ""
                local netMark = (e.source == "net") and ("|cff35a5ff\226\128\162|r ") or ""
                line = string.format("%s%s%s|r%s  %s%s|r%s%s|r",
                    netMark, nameCol, e.name or "?", tag, C.grey, e.who or "?",
                    C.faint, FormatPrice(e.price))
            end
            row.text:SetText(line)

            if showWhisper then
                row.wbtn:Show()
                row.wbtn:SetScript("OnClick", function() MP:WhisperFor(e) end)
            else
                row.wbtn:Hide()
            end
            row:Show()
            yOff = yOff - ROW_H
        end
        child:SetHeight(math.max(ROW_H, math.abs(yOff)))
    end

    local listings = CountKeys(MP.listings)
    panel.footer:SetText(string.format("%s%s  \194\183  %s%d %s|r",
        C.grey, PH.L["MP_FOOTER_SCAN"] or "Scanning Trade / LFG chat",
        C.faint, listings, PH.L["MP_FOOTER_LIVE"] or "live listings"))
end
