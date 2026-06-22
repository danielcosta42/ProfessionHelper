-- Profession Helper - Options panel
-- Central settings window: UI scale, fishing focus volume, behaviour toggles,
-- and a "reset window positions" action. Opened via /ph options.

local PH = _G.ProfessionHelper

local FLAT_BG = {
    bgFile   = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\Buttons\\WHITE8X8",
    edgeSize = 1,
}

local GREEN = { 0.30, 0.85, 0.40 }
local MUTED = { 0.55, 0.55, 0.60 }

local function hex(c) return string.format("|cff%02x%02x%02x", c[1] * 255, c[2] * 255, c[3] * 255) end

-------------------------------------------------------------------------------
-- Build / toggle
-------------------------------------------------------------------------------

function PH:ShowOptionsUI()
    if self.OptionsFrame then
        if self.OptionsFrame:IsShown() then
            self.OptionsFrame:Hide()
        else
            self.OptionsFrame:Show()
            if self.OptionsFrame.Refresh then self.OptionsFrame:Refresh() end
        end
        return
    end

    local frame = CreateFrame("Frame", "PHOptionsFrame", UIParent, "BackdropTemplate")
    frame:SetSize(300, 200)
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 60)
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
    PH:PersistFrameLayout(frame, "options")

    -- Header
    local hdr = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    hdr:SetHeight(24)
    hdr:SetPoint("TOPLEFT",  1, -1)
    hdr:SetPoint("TOPRIGHT", -1, -1)
    hdr:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8" })
    hdr:SetBackdropColor(0.08, 0.08, 0.11, 1)
    local title = hdr:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    title:SetPoint("LEFT", 8, 0)
    title:SetText("|cffffd700" .. PH.L["OPT_TITLE"] .. "|r")
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

    local refreshers = {}

    -- A small flat button helper.
    local function flatBtn(parent, w, h)
        local b = CreateFrame("Button", nil, parent, "BackdropTemplate")
        b:SetSize(w, h)
        b:SetBackdrop(FLAT_BG)
        b:SetBackdropColor(0.12, 0.12, 0.14, 1)
        b:SetBackdropBorderColor(0.30, 0.30, 0.35, 0.8)
        local hl = b:CreateTexture(nil, "HIGHLIGHT")
        hl:SetAllPoints()
        hl:SetColorTexture(1, 1, 1, 0.08)
        b.text = b:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        b.text:SetPoint("CENTER")
        return b
    end

    -- Stepper row: label on the left, [-] value [+] on the right.
    local function makeStepper(y, label, getFn, setFn, minV, maxV, step, fmt)
        local lbl = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        lbl:SetPoint("TOPLEFT", 12, y)
        lbl:SetText(label)

        local plus = flatBtn(frame, 22, 20)
        plus:SetPoint("TOPRIGHT", -12, y + 3)
        plus.text:SetText("+")

        local valFS = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        valFS:SetPoint("RIGHT", plus, "LEFT", -6, 0)
        valFS:SetWidth(46)
        valFS:SetJustifyH("CENTER")

        local minus = flatBtn(frame, 22, 20)
        minus:SetPoint("RIGHT", valFS, "LEFT", -6, 0)
        minus.text:SetText("-")

        local function paint() valFS:SetText(fmt(getFn())) end
        local function bump(d)
            local v = getFn() + d * step
            v = math.max(minV, math.min(maxV, v))
            setFn(v)
            paint()
        end
        plus:SetScript("OnClick",  function() bump(1)  end)
        minus:SetScript("OnClick", function() bump(-1) end)
        refreshers[#refreshers + 1] = paint
        paint()
    end

    -- Toggle row: full-width ON/OFF button.
    local function makeToggle(y, label, key)
        local b = flatBtn(frame, 276, 20)
        b:SetPoint("TOPLEFT", 12, y)
        local function paint()
            local on = PH.Config:Get(key) == true
            if on then
                b:SetBackdropColor(GREEN[1], GREEN[2], GREEN[3], 0.15)
                b.text:SetText(hex(GREEN) .. label .. ": ON|r")
            else
                b:SetBackdropColor(0.12, 0.12, 0.14, 1)
                b.text:SetText(hex(MUTED) .. label .. ": OFF|r")
            end
        end
        b:SetScript("OnClick", function()
            PH.Config:Set(key, PH.Config:Get(key) ~= true)
            paint()
        end)
        refreshers[#refreshers + 1] = paint
        paint()
    end

    makeStepper(-34, PH.L["OPT_UI_SCALE"],
        function() return PH.Config:Get("windowScale") or 1.0 end,
        function(v) PH:ApplyWindowScale(v) end,
        0.5, 2.0, 0.05, function(v) return string.format("%.2f", v) end)

    makeStepper(-62, PH.L["OPT_FOCUS_VOL"],
        function() return PH.Config:Get("fa_focusVolume") or 1.0 end,
        function(v) PH.Config:Set("fa_focusVolume", v) end,
        0.2, 1.0, 0.1, function(v) return string.format("%d%%", math.floor(v * 100 + 0.5)) end)

    makeToggle(-94, PH.L["OPT_DEBUG"], "debug")

    -- Reset window positions
    local reset = flatBtn(frame, 276, 22)
    reset:SetPoint("TOPLEFT", 12, -122)
    reset:SetBackdropColor(0.30, 0.12, 0.12, 0.9)
    reset:SetBackdropBorderColor(0.6, 0.25, 0.25, 0.8)
    reset.text:SetText("|cffff6666" .. PH.L["OPT_RESET_POS"] .. "|r")
    reset:SetScript("OnClick", function()
        PH:ResetFrameLayouts()
        PH.Logger.Info(PH.L["OPT_RESET_DONE"])
    end)

    -- Footer hint
    local hint = frame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    hint:SetPoint("BOTTOMLEFT", 12, 8)
    hint:SetPoint("BOTTOMRIGHT", -12, 8)
    hint:SetJustifyH("LEFT")
    hint:SetText(hex(MUTED) .. PH.L["OPT_HINT"] .. "|r")

    frame.Refresh = function()
        for _, fn in ipairs(refreshers) do fn() end
    end

    self.OptionsFrame = frame
end
