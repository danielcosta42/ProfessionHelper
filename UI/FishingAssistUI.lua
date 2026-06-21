-- ProfessionHelper - Fishing Assistant UI (UI/FishingAssistUI.lua)
-- Floating widget with: smart cast button, bobber timer bar,
-- session stats (fish/casts/time/fish-per-hour), lure tracker,
-- auto-recast toggle, and best-gear equip button.

local PH = _G.ProfessionHelper
-- FA upvalue removed — all callbacks access PH.FishingAssist directly so
-- there is no risk of a stale nil reference if the module loads after this file.

local FLAT_BG = {
    bgFile   = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\Buttons\\WHITE8X8",
    edgeSize = 1,
}

-- Colour palette (self-contained, no dependency on Main.lua's T table)
local C = {
    bg       = { 0.06, 0.06, 0.08, 0.97 },
    header   = { 0.08, 0.08, 0.11, 1    },
    divider  = { 0.20, 0.20, 0.24, 1    },
    castIdle = { 0.15, 0.75, 0.30 },  -- green
    castWait = { 0.20, 0.60, 1.00 },  -- blue
    castDis  = { 0.35, 0.35, 0.40 },  -- grey
    timerFg  = { 0.20, 0.80, 0.40 },  -- bright green
    timerWrn = { 1.00, 0.55, 0.10 },  -- orange (< 10 s)
    lureFg   = { 0.90, 0.75, 0.15 },  -- gold
    gold     = { 1.00, 0.82, 0.00 },
    white    = { 1.00, 1.00, 1.00 },
    muted    = { 0.55, 0.55, 0.60 },
    red      = { 0.90, 0.25, 0.25 },
    green    = { 0.25, 0.90, 0.35 },
    teal     = { 0.25, 0.85, 0.85 },
}

local function hex(r, g, b) return string.format("|cff%02x%02x%02x", r*255, g*255, b*255) end
local function hx(t)        return hex(t[1], t[2], t[3]) end

-------------------------------------------------------------------------------
-- Widget creation
-------------------------------------------------------------------------------

function PH:ShowFishingAssistUI()
    if self.FishingAssistFrame then
        self.FishingAssistFrame:Show()
        self:UpdateFishingAssistUI()
        return
    end

    local frame = CreateFrame("Frame", "ProfessionHelperFishingAssist", UIParent, "BackdropTemplate")
    frame:SetSize(280, 300)
    frame:SetPoint("CENTER", -200, 100)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:SetClampedToScreen(true)
    frame:SetFrameStrata("HIGH")
    frame:SetBackdrop(FLAT_BG)
    frame:SetBackdropColor(C.bg[1], C.bg[2], C.bg[3], C.bg[4])
    frame:SetBackdropBorderColor(0.18, 0.18, 0.22, 1)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop",  frame.StopMovingOrSizing)

    -- Drop shadow
    local shadow = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    shadow:SetPoint("TOPLEFT",     -2,  2)
    shadow:SetPoint("BOTTOMRIGHT",  2, -2)
    shadow:SetFrameLevel(frame:GetFrameLevel() - 1)
    shadow:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8",
                         edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 2 })
    shadow:SetBackdropColor(0, 0, 0, 0.5)
    shadow:SetBackdropBorderColor(0, 0, 0, 0.35)

    -------------------------------------------------------------------------
    -- Header bar
    -------------------------------------------------------------------------
    local hdr = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    hdr:SetHeight(24)
    hdr:SetPoint("TOPLEFT",  1, -1)
    hdr:SetPoint("TOPRIGHT", -1, -1)
    hdr:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8" })
    hdr:SetBackdropColor(C.header[1], C.header[2], C.header[3], C.header[4])

    local title = hdr:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    title:SetPoint("LEFT", 8, 0)
    title:SetText(hx(C.gold) .. "🎣 " .. PH.L["FA_TITLE"] .. "|r")

    -- Close button
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

    -------------------------------------------------------------------------
    -- Body layout  (y starts at -28, stepping downward)
    -------------------------------------------------------------------------
    local BODY_X   = 8
    local BODY_W   = 264   -- 280 - 2×8
    local y        = -28

    -- ── Cast button (SecureActionButtonTemplate, UIParent child) ─────────
    -- SecureActionButtonTemplate requires the button to be a DIRECT UIParent
    -- child to work from Lua (btn:Click() for auto-recast) AND from player
    -- click in TBC Classic Anniversary.  CastSpellByName does NOT work from
    -- addon code in TBC Anniversary even with a hardware event.
    --
    -- Key WoW fact: SetPoint anchors are independent of the parent hierarchy.
    -- Anchoring to `frame` via SetPoint makes this button follow frame when
    -- it is dragged, without the button needing to be a child of frame.
    --
    -- This single button serves both purposes:
    --   (a) Player click  → Blizzard secure system casts Fishing
    --   (b) AutoRecast()  → btn:Click() from Lua, works OOC on UIParent child
    local castBtn
    if not _G["PHFishingAssistCastBtn"] then
        castBtn = CreateFrame("Button", "PHFishingAssistCastBtn", UIParent,
                              "SecureActionButtonTemplate,BackdropTemplate")
        castBtn:SetAttribute("type",  "spell")
        castBtn:SetAttribute("spell", PROFESSIONS_FISHING or "Fishing")
        castBtn:SetBackdrop(FLAT_BG)
        castBtn:SetBackdropColor(C.castIdle[1], C.castIdle[2], C.castIdle[3], 0.18)
        castBtn:SetBackdropBorderColor(C.castIdle[1], C.castIdle[2], C.castIdle[3], 0.55)
        castBtn:RegisterForClicks("LeftButtonUp")
        -- Highlight texture
        local castHL = castBtn:CreateTexture(nil, "HIGHLIGHT")
        castHL:SetAllPoints()
        castHL:SetColorTexture(1, 1, 1, 0.07)
        -- Label
        local castLbl = castBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        castLbl:SetPoint("CENTER")
        castLbl:SetText(hx(C.white) .. PH.L["FA_BTN_CAST"] .. "|r")
        frame.castLbl = castLbl
    else
        castBtn = _G["PHFishingAssistCastBtn"]
    end
    castBtn:SetSize(BODY_W, 34)
    castBtn:SetFrameStrata(frame:GetFrameStrata())
    castBtn:SetFrameLevel(frame:GetFrameLevel() + 2)
    castBtn:ClearAllPoints()
    castBtn:SetPoint("TOPLEFT", frame, "TOPLEFT", BODY_X, y)
    frame.castBtn = castBtn
    y = y - 42
    -- Sync visibility with the FA frame.
    frame:HookScript("OnShow", function() castBtn:Show() end)
    frame:HookScript("OnHide", function() castBtn:Hide() end)

    -- ── One-key assignment row ───────────────────────────────────────────
    local keyLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    keyLabel:SetPoint("TOPLEFT", BODY_X, y)
    keyLabel:SetText(hx(C.muted) .. PH.L["FA_KEY_LABEL"] .. "|r")

    local keyBtn = CreateFrame("Button", nil, frame, "BackdropTemplate")
    keyBtn:SetSize(160, 18)
    keyBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -BODY_X, y + 1)
    keyBtn:SetBackdrop(FLAT_BG)
    keyBtn:SetBackdropColor(0.12, 0.12, 0.14, 1)
    keyBtn:SetBackdropBorderColor(0.30, 0.30, 0.35, 0.8)
    local keyBtnLbl = keyBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    keyBtnLbl:SetPoint("CENTER")
    frame.keyBtnLbl = keyBtnLbl
    local keyHL = keyBtn:CreateTexture(nil, "HIGHLIGHT")
    keyHL:SetAllPoints()
    keyHL:SetColorTexture(1, 1, 1, 0.06)
    y = y - 22

    local function SetKeyLabel()
        local m = PH.FishingAssist
        local k = m and m:GetOneKey()
        keyBtnLbl:SetText(hx(k and C.green or C.muted) .. (k or PH.L["FA_KEY_NONE"]) .. "|r")
    end
    frame.SetKeyLabel = SetKeyLabel

    -- Modal key-capture overlay
    local captureFrame = CreateFrame("Frame", nil, UIParent)
    captureFrame:SetFrameStrata("FULLSCREEN_DIALOG")
    captureFrame:Hide()
    local function StopCapture()
        captureFrame:EnableKeyboard(false)
        captureFrame:EnableMouse(false)
        captureFrame:Hide()
        SetKeyLabel()
    end
    local function ApplyKey(key)
        if key == "ESCAPE" then StopCapture(); return end
        local prefix = ""
        if IsShiftKeyDown()   then prefix = "SHIFT-" .. prefix end
        if IsControlKeyDown() then prefix = "CTRL-"  .. prefix end
        if IsAltKeyDown()     then prefix = "ALT-"   .. prefix end
        local m = PH.FishingAssist
        if m then m:SetOneKey(prefix .. key) end
        StopCapture()
    end
    captureFrame:SetScript("OnKeyDown", function(_, key)
        if key == "LALT" or key == "RALT" or key == "LCTRL" or key == "RCTRL"
            or key == "LSHIFT" or key == "RSHIFT" or key == "UNKNOWN" then return end
        ApplyKey(key)
    end)
    captureFrame:SetScript("OnMouseDown", function(_, button)
        -- Only the extra mouse buttons are safe to bind; left/right/middle cancel.
        local map = { Button4 = "BUTTON4", Button5 = "BUTTON5" }
        local b = map[button]
        if b then ApplyKey(b) else StopCapture() end
    end)
    keyBtn:SetScript("OnClick", function()
        keyBtnLbl:SetText(hx(C.gold) .. PH.L["FA_PRESS_KEY"] .. "|r")
        captureFrame:SetAllPoints(UIParent)
        captureFrame:EnableKeyboard(true)
        captureFrame:EnableMouse(true)
        captureFrame:SetPropagateKeyboardInput(false)
        captureFrame:Show()
    end)
    SetKeyLabel()

    -- ── Bobber timer bar ──────────────────────────────────────────────────
    local timerLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    timerLabel:SetPoint("TOPLEFT", BODY_X, y)
    timerLabel:SetText(hx(C.muted) .. PH.L["FA_BOBBER_TIMER"] .. "|r")

    local timerTime = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    timerTime:SetPoint("RIGHT", frame, "RIGHT", -BODY_X, y + 7)
    timerTime:SetText("")
    frame.timerTime = timerTime

    y = y - 13
    -- Bar track
    local timerTrack = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    timerTrack:SetHeight(7)
    timerTrack:SetPoint("TOPLEFT",  BODY_X, y)
    timerTrack:SetPoint("TOPRIGHT", -BODY_X, y)
    timerTrack:SetBackdrop(FLAT_BG)
    timerTrack:SetBackdropColor(0.12, 0.12, 0.14, 1)
    timerTrack:SetBackdropBorderColor(0.18, 0.18, 0.22, 1)

    local timerFill = timerTrack:CreateTexture(nil, "ARTWORK")
    timerFill:SetPoint("TOPLEFT", 1, -1)
    timerFill:SetHeight(5)
    timerFill:SetColorTexture(C.timerFg[1], C.timerFg[2], C.timerFg[3], 1)
    timerFill:SetWidth(1)
    frame.timerTrack = timerTrack
    frame.timerFill  = timerFill
    y = y - 12

    -- Status text
    local statusTxt = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    statusTxt:SetPoint("TOPLEFT", BODY_X, y)
    statusTxt:SetText(hx(C.muted) .. PH.L["FA_STATUS_IDLE"] .. "|r")
    frame.statusTxt = statusTxt
    y = y - 14

    -- ── Divider ───────────────────────────────────────────────────────────
    local div1 = frame:CreateTexture(nil, "ARTWORK")
    div1:SetHeight(1)
    div1:SetPoint("TOPLEFT",  BODY_X, y)
    div1:SetPoint("TOPRIGHT", -BODY_X, y)
    div1:SetColorTexture(C.divider[1], C.divider[2], C.divider[3], C.divider[4])
    y = y - 8

    -- ── Session stats (2×2 grid) ──────────────────────────────────────────
    local SESSION_COL2 = BODY_X + 140

    local lFish  = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    lFish:SetPoint("TOPLEFT", BODY_X, y)
    lFish:SetText(hx(C.muted) .. PH.L["FA_FISH_COUNT"] .. "|r")

    local vFish  = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    vFish:SetPoint("TOPLEFT", BODY_X + 72, y)
    vFish:SetText(hx(C.white) .. "0|r")
    frame.vFish = vFish

    local lCasts = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    lCasts:SetPoint("TOPLEFT", SESSION_COL2, y)
    lCasts:SetText(hx(C.muted) .. PH.L["FA_CAST_COUNT"] .. "|r")

    local vCasts = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    vCasts:SetPoint("TOPLEFT", SESSION_COL2 + 88, y)
    vCasts:SetText(hx(C.white) .. "0|r")
    frame.vCasts = vCasts

    y = y - 14

    local lTime  = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    lTime:SetPoint("TOPLEFT", BODY_X, y)
    lTime:SetText(hx(C.muted) .. PH.L["FA_SESSION_TIME"] .. "|r")

    local vTime  = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    vTime:SetPoint("TOPLEFT", BODY_X + 72, y)
    vTime:SetText(hx(C.white) .. "0:00|r")
    frame.vTime = vTime

    local lFPH   = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    lFPH:SetPoint("TOPLEFT", SESSION_COL2, y)
    lFPH:SetText(hx(C.muted) .. PH.L["FA_FISH_PER_HOUR"] .. "|r")

    local vFPH   = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    vFPH:SetPoint("TOPLEFT", SESSION_COL2 + 88, y)
    vFPH:SetText(hx(C.white) .. "0|r")
    frame.vFPH = vFPH

    y = y - 14

    -- ── Divider ───────────────────────────────────────────────────────────
    local div2 = frame:CreateTexture(nil, "ARTWORK")
    div2:SetHeight(1)
    div2:SetPoint("TOPLEFT",  BODY_X, y)
    div2:SetPoint("TOPRIGHT", -BODY_X, y)
    div2:SetColorTexture(C.divider[1], C.divider[2], C.divider[3], C.divider[4])
    y = y - 8

    -- ── Lure row ──────────────────────────────────────────────────────────
    local lLure  = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    lLure:SetPoint("TOPLEFT", BODY_X, y)
    lLure:SetText(hx(C.muted) .. PH.L["FA_LURE_LABEL"] .. "|r")

    local vLure  = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    vLure:SetPoint("TOPLEFT", BODY_X + 48, y)
    vLure:SetPoint("RIGHT", frame, "RIGHT", -BODY_X, 0)
    vLure:SetJustifyH("LEFT")
    vLure:SetText(hx(C.muted) .. PH.L["FA_LURE_NONE"] .. "|r")
    frame.vLure = vLure

    -- Lure timer bar
    y = y - 13
    local lureTrack = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    lureTrack:SetHeight(4)
    lureTrack:SetPoint("TOPLEFT",  BODY_X, y)
    lureTrack:SetPoint("TOPRIGHT", -BODY_X, y)
    lureTrack:SetBackdrop(FLAT_BG)
    lureTrack:SetBackdropColor(0.12, 0.12, 0.14, 1)
    lureTrack:SetBackdropBorderColor(0.18, 0.18, 0.22, 1)

    local lureFill = lureTrack:CreateTexture(nil, "ARTWORK")
    lureFill:SetPoint("TOPLEFT", 1, -1)
    lureFill:SetHeight(2)
    lureFill:SetColorTexture(C.lureFg[1], C.lureFg[2], C.lureFg[3], 1)
    lureFill:SetWidth(1)
    frame.lureTrack = lureTrack
    frame.lureFill  = lureFill
    y = y - 10

    -- ── Divider ───────────────────────────────────────────────────────────
    local div3 = frame:CreateTexture(nil, "ARTWORK")
    div3:SetHeight(1)
    div3:SetPoint("TOPLEFT",  BODY_X, y)
    div3:SetPoint("TOPRIGHT", -BODY_X, y)
    div3:SetColorTexture(C.divider[1], C.divider[2], C.divider[3], C.divider[4])
    y = y - 8

    -- ── Footer controls ──────────────────────────────────────────────────
    -- Auto-recast toggle
    local recastBtn = CreateFrame("Button", nil, frame, "BackdropTemplate")
    recastBtn:SetSize(110, 20)
    recastBtn:SetPoint("TOPLEFT", BODY_X, y)
    recastBtn:SetBackdrop(FLAT_BG)
    recastBtn:SetBackdropBorderColor(0.30, 0.30, 0.35, 0.8)
    local recastLbl = recastBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    recastLbl:SetPoint("CENTER")
    frame.recastBtn = recastBtn
    frame.recastLbl = recastLbl

    local function UpdateRecastBtn()
        local m = PH.FishingAssist
        local on = m and m:GetAutoRecast() or false
        if on then
            recastBtn:SetBackdropColor(C.green[1], C.green[2], C.green[3], 0.15)
            recastLbl:SetText(hx(C.green) .. PH.L["FA_AUTO_RECAST"] .. ": ON|r")
        else
            recastBtn:SetBackdropColor(0.12, 0.12, 0.14, 1)
            recastLbl:SetText(hx(C.muted) .. PH.L["FA_AUTO_RECAST"] .. ": OFF|r")
        end
    end
    UpdateRecastBtn()
    recastBtn:SetScript("OnClick", function()
        local m = PH.FishingAssist
        if m then
            m:SetAutoRecast(not m:GetAutoRecast())
            UpdateRecastBtn()
        end
    end)
    frame.UpdateRecastBtn = UpdateRecastBtn

    -- Equip best gear button
    local equipBtn = CreateFrame("Button", nil, frame, "BackdropTemplate")
    equipBtn:SetSize(88, 20)
    equipBtn:SetPoint("LEFT", recastBtn, "RIGHT", 6, 0)
    equipBtn:SetBackdrop(FLAT_BG)
    equipBtn:SetBackdropColor(C.teal[1], C.teal[2], C.teal[3], 0.12)
    equipBtn:SetBackdropBorderColor(C.teal[1], C.teal[2], C.teal[3], 0.45)
    local equipHL = equipBtn:CreateTexture(nil, "HIGHLIGHT")
    equipHL:SetAllPoints()
    equipHL:SetColorTexture(1, 1, 1, 0.06)
    local equipLbl = equipBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    equipLbl:SetPoint("CENTER")
    equipLbl:SetText(hx(C.teal) .. PH.L["FA_EQUIP_GEAR_BTN"] .. "|r")
    equipBtn:SetScript("OnClick", function()
        local m = PH.FishingAssist
        if m then m:EquipBestGear() end
    end)

    -- Reset session button
    local resetBtn = CreateFrame("Button", nil, frame, "BackdropTemplate")
    resetBtn:SetSize(52, 20)
    resetBtn:SetPoint("LEFT", equipBtn, "RIGHT", 6, 0)
    resetBtn:SetBackdrop(FLAT_BG)
    resetBtn:SetBackdropColor(C.red[1], C.red[2], C.red[3], 0.10)
    resetBtn:SetBackdropBorderColor(C.red[1], C.red[2], C.red[3], 0.35)
    local resetHL = resetBtn:CreateTexture(nil, "HIGHLIGHT")
    resetHL:SetAllPoints()
    resetHL:SetColorTexture(1, 1, 1, 0.06)
    local resetLbl = resetBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    resetLbl:SetPoint("CENTER")
    resetLbl:SetText(hx(C.red) .. PH.L["FA_RESET_BTN"] .. "|r")
    resetBtn:SetScript("OnClick", function()
        local m = PH.FishingAssist
        if m then m:ResetSession() end
        PH:UpdateFishingAssistUI()
    end)

    -- ── Camera-scan toggle (opt-in fallback that rotates the camera) ──────
    local scanBtn = CreateFrame("Button", nil, frame, "BackdropTemplate")
    scanBtn:SetSize(160, 20)
    scanBtn:SetPoint("TOPLEFT", recastBtn, "BOTTOMLEFT", 0, -6)
    scanBtn:SetBackdrop(FLAT_BG)
    scanBtn:SetBackdropBorderColor(0.30, 0.30, 0.35, 0.8)
    local scanHL = scanBtn:CreateTexture(nil, "HIGHLIGHT")
    scanHL:SetAllPoints()
    scanHL:SetColorTexture(1, 1, 1, 0.06)
    local scanLbl = scanBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    scanLbl:SetPoint("CENTER")
    frame.scanLbl = scanLbl
    local function UpdateScanBtn()
        local on = PH.Config:Get("fa_cameraScan") == true
        if on then
            scanBtn:SetBackdropColor(C.green[1], C.green[2], C.green[3], 0.15)
            scanLbl:SetText(hx(C.green) .. PH.L["FA_CAMERA_SCAN"] .. ": ON|r")
        else
            scanBtn:SetBackdropColor(0.12, 0.12, 0.14, 1)
            scanLbl:SetText(hx(C.muted) .. PH.L["FA_CAMERA_SCAN"] .. ": OFF|r")
        end
        local m = PH.FishingAssist
        if m then m:ShowScanBox(on and frame:IsShown()) end
    end
    frame.UpdateScanBtn = UpdateScanBtn
    UpdateScanBtn()
    scanBtn:SetScript("OnClick", function()
        PH.Config:Set("fa_cameraScan", PH.Config:Get("fa_cameraScan") ~= true)
        UpdateScanBtn()
    end)

    -- Keep the scan box in sync with the panel + toggle state.
    frame:HookScript("OnShow", function() if frame.UpdateScanBtn then frame.UpdateScanBtn() end end)
    frame:HookScript("OnHide", function()
        local m = PH.FishingAssist
        if m then m:ShowScanBox(false) end
    end)

    -------------------------------------------------------------------------
    -- OnUpdate — refreshes timer bar, stats, and bobber timeout every frame
    -------------------------------------------------------------------------
    local UPDATE_INTERVAL = 0.1  -- seconds between refreshes
    local updateAccum     = 0

    frame:SetScript("OnUpdate", function(self, dt)
        updateAccum = updateAccum + dt
        if updateAccum < UPDATE_INTERVAL then return end
        updateAccum = 0

        local m = PH.FishingAssist
        if m then
            m:Tick()  -- checks bobber timeout
            PH:_FA_UpdateDynamic()
        end
    end)

    -------------------------------------------------------------------------
    -- Subscribe to state-change events for immediate full refreshes
    -------------------------------------------------------------------------
    PH.Event:On("PH_FA_UPDATED", function()
        PH:UpdateFishingAssistUI()
    end, "FishingAssistUI")

    self.FishingAssistFrame = frame
    self:UpdateFishingAssistUI()
end

-------------------------------------------------------------------------------
-- Full UI refresh  (called on state change + on show)
-------------------------------------------------------------------------------

function PH:UpdateFishingAssistUI()
    local frame = self.FishingAssistFrame
    if not frame or not frame:IsShown() then return end
    local FA = PH.FishingAssist
    if not FA then return end

    local state = FA.state

    -- Cast button appearance
    local castBtn = frame.castBtn
    local castLbl = frame.castLbl
    local oneKey = FA:GetOneKey()
    if state == "idle" then
        -- Ready: green — press the key (or click) to cast
        castBtn:SetBackdropColor(C.castIdle[1], C.castIdle[2], C.castIdle[3], 0.18)
        castBtn:SetBackdropBorderColor(C.castIdle[1], C.castIdle[2], C.castIdle[3], 0.55)
        castBtn:Enable()
        castLbl:SetText(hx(C.white) .. PH.L["FA_BTN_CAST"] .. "|r")

    elseif state == "waiting" then
        -- Bobber in water — the same key reels/loots it. The cast button itself
        -- can't loot (INTERACTMOUSEOVER is a key binding), so guide the player.
        castBtn:SetBackdropColor(C.castWait[1], C.castWait[2], C.castWait[3], 0.14)
        castBtn:SetBackdropBorderColor(C.castWait[1], C.castWait[2], C.castWait[3], 0.40)
        castBtn:Disable()
        if oneKey then
            castLbl:SetText(hx(C.castWait) .. string.format(PH.L["FA_BTN_REEL"], oneKey) .. "|r")
        else
            castLbl:SetText(hx(C.castWait) .. PH.L["FA_BTN_REEL_NOKEY"] .. "|r")
        end

    else
        -- looting — disabled
        castBtn:SetBackdropColor(C.castDis[1], C.castDis[2], C.castDis[3], 0.12)
        castBtn:SetBackdropBorderColor(C.castDis[1], C.castDis[2], C.castDis[3], 0.30)
        castBtn:Disable()
        castLbl:SetText(hx(C.muted) .. PH.L["FA_BTN_LOOTING"] .. "|r")
    end

    if frame.SetKeyLabel then frame.SetKeyLabel() end

    -- Status text
    local statusMap = {
        idle    = PH.L["FA_STATUS_IDLE"],
        casting = PH.L["FA_STATUS_CASTING"],
        waiting = PH.L["FA_STATUS_WAITING"],
        looting = PH.L["FA_STATUS_LOOTING"],
    }
    frame.statusTxt:SetText(hx(C.muted) .. (statusMap[state] or state) .. "|r")

    -- Dynamic refresh (stats + bars)
    self:_FA_UpdateDynamic()

    -- Lure
    self:_FA_UpdateLure()

    -- Recast button
    if frame.UpdateRecastBtn then frame.UpdateRecastBtn() end
end

-------------------------------------------------------------------------------
-- Dynamic elements (called every UPDATE_INTERVAL seconds)
-------------------------------------------------------------------------------

function PH:_FA_UpdateDynamic()
    local frame = self.FishingAssistFrame
    if not frame then return end
    local FA = PH.FishingAssist
    if not FA then return end

    -- Bobber timer bar
    local remaining = FA:GetBobberRemaining()
    local pct       = remaining / FA:GetBobberDuration()
    local trackW    = frame.timerTrack:GetWidth()
    if trackW and trackW > 2 then
        local fillW = math.max(1, (trackW - 2) * math.min(1, pct))
        frame.timerFill:SetWidth(fillW)
        -- Colour shifts to orange when < 10 s
        if remaining < 10 and FA.state == "waiting" then
            frame.timerFill:SetColorTexture(C.timerWrn[1], C.timerWrn[2], C.timerWrn[3], 1)
        else
            frame.timerFill:SetColorTexture(C.timerFg[1],  C.timerFg[2],  C.timerFg[3],  1)
        end
    end

    if FA.state == "waiting" then
        frame.timerTime:SetText(hx(remaining < 10 and C.timerWrn or C.muted)
            .. string.format("%.0fs", remaining) .. "|r")
    else
        frame.timerFill:SetWidth(1)
        frame.timerTime:SetText("")
    end

    -- Session stats
    frame.vFish:SetText( hx(C.white) .. tostring(FA.fishCaught)  .. "|r")
    frame.vCasts:SetText(hx(C.white) .. tostring(FA.totalCasts)  .. "|r")
    frame.vTime:SetText( hx(C.white) .. FA:FormatTime(FA:GetElapsedTime()) .. "|r")

    local fph = FA:GetFishPerHour()
    frame.vFPH:SetText(hx(C.white) .. string.format("%.1f", fph) .. "|r")
end

-------------------------------------------------------------------------------
-- Lure bar refresh
-------------------------------------------------------------------------------

function PH:_FA_UpdateLure()
    local frame = self.FishingAssistFrame
    if not frame then return end
    local FA = PH.FishingAssist
    if not FA then return end

    local lureName   = FA.lureName
    local lureRemain = FA:GetLureRemaining()
    local lureDur    = 600  -- most lures are 10 minutes; used for bar scale

    if lureName and lureRemain > 0 then
        frame.vLure:SetText(hx(C.gold)
            .. lureName .. " " .. hx(C.muted)
            .. string.format("(%.0fs)|r", lureRemain))
        local pct    = math.min(1, lureRemain / lureDur)
        local trackW = frame.lureTrack:GetWidth()
        if trackW and trackW > 2 then
            frame.lureFill:SetWidth(math.max(1, (trackW - 2) * pct))
        end
    else
        frame.vLure:SetText(hx(C.muted) .. PH.L["FA_LURE_NONE"] .. "|r")
        frame.lureFill:SetWidth(1)
    end
end
