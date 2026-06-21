-- ProfessionHelper - Fishing Assistant (Features/FishingAssist.lua)
-- One-key fishing for Classic Anniversary, modelled on the Angleur addon.
--
-- The real mechanism (there is NO programmatic cast or interact — both are
-- produced by the player's hardware keypress firing an override binding that
-- this insecure state machine re-points between two values while out of combat):
--
--   1. The user assigns ONE key. While idle, that key is override-bound to cast
--      Fishing:  SetOverrideBindingSpell(owner, true, key, PROFESSIONS_FISHING)
--   2. On the fishing channel start we enable Blizzard's soft-target interact
--      CVars + auto-loot, so the bobber becomes interactable and loots in one
--      press, and we re-bind the key to the interact command:
--      SetOverrideBinding(owner, true, key, "INTERACTMOUSEOVER")
--   3. The bobber is detected as the soft-interact target via
--      PLAYER_SOFT_INTERACT_CHANGED (GameObject id 35591). If it never becomes
--      the soft target, an optional camera grid-scan rotates the CAMERA (not the
--      character) until the bobber slides under a cursor parked in a fixed box.
--   4. Pressing the same key when the bobber is up fires INTERACTMOUSEOVER and
--      loots it. Channel stop restores the CVars and re-binds the key to cast.
--
-- Honest limit: looting genuinely needs a real keypress (INTERACTMOUSEOVER only
-- fires from hardware input). This is one-button fishing, not a zero-press bot —
-- exactly like Angleur.

local PH = _G.ProfessionHelper

PH.FishingAssist = {}
local M = PH.FishingAssist

-------------------------------------------------------------------------------
-- Constants
-------------------------------------------------------------------------------

local BOBBER_DURATION = 30  -- Classic: bobber lasts ~30s before sinking

-- Fishing bobber GameObject id — used to match the soft-interact target GUID.
local BOBBER_OBJECT_ID = 35591

-- Fishing spell IDs — used ONLY for UNIT_SPELLCAST_CHANNEL_* matching (with a
-- spell-name fallback below). Not used for casting; casting uses the binding.
local FISHING_SPELL_IDS = {
    7620, 7731, 7732, 18248, 33095, 51294, 88868,
}

-- CVars temporarily applied while fishing: Blizzard soft-target interact (so the
-- bobber is interactable with the one key) + auto-loot (so it loots in one press).
-- Values taken verbatim from Angleur. Cached and restored on every channel stop.
local TEMP_CVARS = {
    SoftTargetInteract            = "3",
    SoftTargetInteractRange       = "15",
    SoftTargetInteractRangeIsHard = "0",
    autoLootDefault               = "1",
}
local _cvarCache = {}

-- Fishing poles — sorted best first (used by EquipBestGear)
local FISHING_POLES = {
    { name = "Arcanite Fishing Pole",              slot = 16 },
    { name = "Mastercraft Kalu'ak Fishing Pole",   slot = 16 },
    { name = "Dragon Fishing Pole",                slot = 16 },
    { name = "Nat Pagle's Extreme Angler FC-5000", slot = 16 },
    { name = "Seth's Graphite Fishing Pole",       slot = 16 },
    { name = "Bone Fishing Pole",                  slot = 16 },
    { name = "Big Iron Fishing Pole",              slot = 16 },
    { name = "Strong Fishing Pole",                slot = 16 },
}

-- Fishing hats — sorted best first
local FISHING_HATS = {
    { name = "Weather-Beaten Fishing Hat", slot = 1 },
    { name = "Lucky Fishing Hat",          slot = 1 },
}

-- Lure buffs that appear on the player
local LURE_NAMES = {
    ["Aquadynamic Fish Attractor"] = true,
    ["Sharpened Fish Hook"]        = true,
    ["Bright Baubles"]             = true,
    ["Nightcrawlers"]              = true,
    ["Glow Worm"]                  = true,
    ["Flesh-Eating Worm"]          = true,
}

-------------------------------------------------------------------------------
-- In-memory state  (never persisted — resets on reload)
-------------------------------------------------------------------------------

M.state            = "idle"    -- "idle" | "waiting" | "looting"
M.bobberCastTime   = 0         -- GetTime() when bobber entered water
M.sessionStart     = 0
M.sessionActive    = false
M.fishCaught       = 0
M.totalCasts       = 0
M.lureName         = nil
M.lureExpiry       = 0
M.oneKey           = nil       -- the user-assigned key string (override-bound)
M.bobberWithinRange = false    -- bobber is the current soft-interact target

local _initialized = false

-- Plain (insecure) frame that owns the override bindings. A plain frame is
-- allowed to own bindings; only the Set/ClearOverrideBinding* calls are
-- protected (out-of-combat only).
local bindOwner

-------------------------------------------------------------------------------
-- Private helpers
-------------------------------------------------------------------------------

local function IsFishingID(id)
    local n = tonumber(id)
    if not n then return false end
    for _, sid in ipairs(FISHING_SPELL_IDS) do
        if n == sid then return true end
    end
    return false
end

-- PROFESSIONS_FISHING is the Blizzard global with the localized fishing spell
-- name; used both as the cast binding and for channel-name matching.
local FISHING_SPELL_NAME = PROFESSIONS_FISHING or "Fishing"

local _fishingNames = { [FISHING_SPELL_NAME] = true }
local function InitFishingNames()
    for _, sid in ipairs(FISHING_SPELL_IDS) do
        local name = GetSpellInfo(sid)
        if name and name ~= "" then
            _fishingNames[name] = true
        end
    end
end

-- True if a channeled spell is Fishing — matched by spell ID first, then by the
-- localized spell name as a fallback (covers Anniversary spell-ID drift).
local function IsFishingCast(spellID)
    if IsFishingID(spellID) then return true end
    local name = spellID and GetSpellInfo(spellID)
    return name ~= nil and _fishingNames[name] == true
end

-- True if a GUID is a fishing bobber GameObject. GUID format:
-- GameObject-0-<server>-<instance>-<zoneuid>-<objectid>-<spawnuid>
local function IsBobberGUID(guid)
    if type(guid) ~= "string" then return false end
    local objId = guid:match("^GameObject%-%d+%-%d+%-%d+%-%d+%-(%d+)%-")
    return tonumber(objId) == BOBBER_OBJECT_ID
end

-- C_Timer.After polyfill for Classic clients (no C_Timer on those clients).
local function After(delay, func)
    if C_Timer and C_Timer.After then
        C_Timer.After(delay, func)
        return
    end
    local f   = CreateFrame("Frame")
    local acc = 0
    f:SetScript("OnUpdate", function(self, dt)
        acc = acc + dt
        if acc >= delay then
            self:SetScript("OnUpdate", nil)
            func()
        end
    end)
end

-------------------------------------------------------------------------------
-- Temp CVar manager (soft-target + auto-loot while fishing)
-------------------------------------------------------------------------------

local function SoftTargetEnabled()
    return PH.Compat.HasSoftInteract() and PH.Config:Get("fa_softTarget") ~= false
end

local function ApplyFishingCVars()
    if not SoftTargetEnabled() then return end
    local doAutoLoot = PH.Config:Get("fa_autoLoot") ~= false
    for name, val in pairs(TEMP_CVARS) do
        if name == "autoLootDefault" and not doAutoLoot then
            -- leave the user's auto-loot setting alone
        else
            if _cvarCache[name] == nil then
                -- cache the original once; false marks "was empty/unset"
                _cvarCache[name] = PH.Compat.GetCVar(name) or false
            end
            PH.Compat.SetCVar(name, val)
        end
    end
end

local function RestoreFishingCVars()
    for name in pairs(TEMP_CVARS) do
        local prev = _cvarCache[name]
        if prev ~= nil then
            PH.Compat.SetCVar(name, prev == false and "0" or prev)
            _cvarCache[name] = nil
        end
    end
end

-------------------------------------------------------------------------------
-- Override-binding swap (the one-key cast/reel mechanism)
-------------------------------------------------------------------------------

-- The base key (no modifier prefix) — IsKeyDown wants "E", not "ALT-E".
local function BaseKey(key)
    if not key then return nil end
    return (key:gsub("^.*%-", ""))
end

-- True if the assigned key is currently held — never rebind a held key
-- (rebinding mid-press is the documented Angleur "Raft Jump Bug").
local function KeyHeld()
    local base = BaseKey(M.oneKey)
    if not base then return false end
    local ok, down = pcall(IsKeyDown, base)
    return ok and down or false
end

local function BindCast()
    if not M.oneKey or not bindOwner or InCombatLockdown() then return end
    if KeyHeld() then return end
    ClearOverrideBindings(bindOwner)
    SetOverrideBindingSpell(bindOwner, true, M.oneKey, FISHING_SPELL_NAME)
end

local function BindReel()
    if not M.oneKey or not bindOwner or InCombatLockdown() then return end
    if KeyHeld() then return end
    ClearOverrideBindings(bindOwner)
    SetOverrideBinding(bindOwner, true, M.oneKey, "INTERACTMOUSEOVER")
end

local function ClearBind()
    if InCombatLockdown() or not bindOwner then return end
    ClearOverrideBindings(bindOwner)
end

-- Re-apply the correct binding for the current state.
local function RefreshBind()
    if M.state == "waiting" and M.bobberWithinRange then
        BindReel()
    else
        BindCast()
    end
end

function M:SetOneKey(key)
    -- key is a binding string ("F", "BUTTON4", "ALT-E", ...) or nil to clear
    self.oneKey = (key ~= "" and key) or nil
    PH.Config:Set("fa_oneKey", self.oneKey)
    if bindOwner and not InCombatLockdown() then
        ClearOverrideBindings(bindOwner)
        RefreshBind()
    end
    PH.Event:Fire("PH_FA_UPDATED")
end

function M:GetOneKey()
    return self.oneKey
end

-------------------------------------------------------------------------------
-- Camera bobber scanner (opt-in fallback)
-- Rotates the CAMERA (not the character) in a serpentine sweep so the bobber
-- slides under a cursor parked in a fixed on-screen box. When the cursor turns
-- into the interact cursor over the bobber, CURSOR_CHANGED fires and
-- SetCursor(nil) returns true, so the scan stops with the cursor on the bobber.
-------------------------------------------------------------------------------

local SCAN = {
    H_SPEED = 0.4, V_SPEED = 0.3, H_DIST = 0.25, V_DIST = 0.25,
    V_OFFSET = 0.25, WAIT_TIME = 1, V_LINES = 14, ZFACTOR_STR = 1.3,
    TIMEOUT = 15,
}

local scanFrame
local scanBox
local _scanActive     = false
local _scanMouseInside = false
local _scanLegs, _scanLegIdx, _scanLegElapsed, _scanElapsed
local _camZoomCache

local function ScanStopAllMovement()
    MoveViewRightStop(); MoveViewLeftStop()
    MoveViewUpStop();    MoveViewDownStop()
    MoveViewOutStop()
end

local function StopScan(recenter)
    if not _scanActive then return end
    _scanActive = false
    ScanStopAllMovement()
    if scanFrame then
        scanFrame:SetScript("OnUpdate", nil)
        scanFrame:SetScript("OnEvent", nil)
        scanFrame:UnregisterAllEvents()
    end
    if _camZoomCache ~= nil then
        PH.Compat.SetCVar("cameraDistanceMaxZoomFactor", _camZoomCache)
        _camZoomCache = nil
    end
    if recenter then CenterCamera() end
end
M._StopScan = StopScan

local function StartScanLeg(i)
    _scanLegIdx     = i
    _scanLegElapsed = 0
    local leg = _scanLegs and _scanLegs[i]
    if not leg then StopScan(true); return end
    if leg.start then leg.start() end
end

local function EnsureScanFrame()
    if scanFrame then return end
    scanFrame = CreateFrame("Frame")
    scanFrame:Hide()
end

-- The fixed on-screen box the player parks the cursor in. Created lazily.
local function EnsureScanBox()
    if scanBox then return end
    scanBox = CreateFrame("Frame", "PHFishingScanBox", UIParent)
    scanBox:SetSize(40, 40)
    scanBox:SetPoint("CENTER", UIParent, "CENTER", 0, 150)
    scanBox:SetFrameStrata("FULLSCREEN_DIALOG")
    scanBox:SetPropagateMouseMotion(true)
    scanBox:SetPropagateMouseClicks(true)
    local tex = scanBox:CreateTexture(nil, "OVERLAY")
    tex:SetAllPoints()
    tex:SetColorTexture(0.9, 0.2, 0.2, 0.35)
    scanBox.tex = tex
    local hint = scanBox:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    hint:SetPoint("BOTTOM", scanBox, "TOP", 0, 6)
    hint:SetText(PH.L["FA_SCAN_BOX_HINT"])
    scanBox:SetScript("OnEnter", function()
        _scanMouseInside = true
        tex:SetColorTexture(0.2, 0.9, 0.3, 0.35)
    end)
    scanBox:SetScript("OnLeave", function()
        _scanMouseInside = false
        tex:SetColorTexture(0.9, 0.2, 0.2, 0.35)
        if _scanActive then StopScan(true) end
    end)
    scanBox:Hide()
end

function M:ShowScanBox(show)
    EnsureScanBox()
    if show then scanBox:Show() else scanBox:Hide() end
end

local function StartScan()
    if _scanActive then return end
    if not PH.Config:Get("fa_cameraScan") then return end
    EnsureScanFrame()
    EnsureScanBox()
    scanBox:Show()
    if not _scanMouseInside then
        PH.Logger.Info("|cffffcc00" .. PH.L["FA_SCAN_NEEDMOUSE"] .. "|r")
        return
    end

    CenterCamera()
    _camZoomCache = PH.Compat.GetCVar("cameraDistanceMaxZoomFactor")
    local maxZoom = tonumber(_camZoomCache) or 1.9
    local zoomFactor   = (maxZoom + SCAN.ZFACTOR_STR) / (SCAN.ZFACTOR_STR + 1)
    local zoomFactor_H = zoomFactor * 0.8
    local hTime    = (SCAN.H_DIST / SCAN.H_SPEED) / zoomFactor_H
    local vTime    = (SCAN.V_DIST / SCAN.V_SPEED)
    local lines    = SCAN.V_LINES
    local lineTime = vTime / lines
    local setupVSpeed = SCAN.V_SPEED * ((SCAN.V_OFFSET / SCAN.V_SPEED) / hTime) * zoomFactor

    _scanLegs = {}
    -- 1) zoom out
    table.insert(_scanLegs, {
        start = function() MoveViewOutStart(16) end,
        stop  = function() MoveViewOutStop() end,
        duration = SCAN.WAIT_TIME,
    })
    -- 2) move to the start corner (pitch down a bit + half a row to the right)
    table.insert(_scanLegs, {
        start = function() MoveViewUpStart(setupVSpeed); MoveViewRightStart(SCAN.H_SPEED) end,
        stop  = function() MoveViewUpStop(); MoveViewRightStop() end,
        duration = hTime / 2,
    })
    -- 3) serpentine rows
    local goLeft = true
    for r = 1, lines do
        local left = goLeft
        table.insert(_scanLegs, {
            start = function()
                if left then MoveViewLeftStart(SCAN.H_SPEED) else MoveViewRightStart(SCAN.H_SPEED) end
            end,
            stop = function()
                if left then MoveViewLeftStop() else MoveViewRightStop() end
            end,
            duration = hTime,
        })
        if r < lines then
            table.insert(_scanLegs, {
                start = function() MoveViewUpStart(SCAN.V_SPEED) end,
                stop  = function() MoveViewUpStop() end,
                duration = lineTime,
            })
        end
        goLeft = not goLeft
    end

    _scanActive  = true
    _scanElapsed = 0
    scanFrame:RegisterEvent("CURSOR_CHANGED")
    scanFrame:SetScript("OnEvent", function()
        -- Cursor changed to the interact cursor over the bobber -> stop here,
        -- leaving the cursor on the bobber so the one key can loot it.
        if SetCursor(nil) == true then StopScan(false) end
    end)
    scanFrame:SetScript("OnUpdate", function(_, dt)
        _scanElapsed = _scanElapsed + dt
        if _scanElapsed > SCAN.TIMEOUT then StopScan(true); return end
        if not _scanMouseInside then StopScan(true); return end
        local leg = _scanLegs[_scanLegIdx]
        if not leg then StopScan(true); return end
        _scanLegElapsed = _scanLegElapsed + dt
        if _scanLegElapsed >= leg.duration then
            if leg.stop then leg.stop() end
            StartScanLeg(_scanLegIdx + 1)
        end
    end)
    StartScanLeg(1)
end

-------------------------------------------------------------------------------
-- Gear helpers
-------------------------------------------------------------------------------

-- Scan all bags for the first item matching a name list (best-first order).
-- Container reads go through PH.Compat so this works on Cata clients too.
local function FindInBags(itemList)
    for _, gear in ipairs(itemList) do
        for bag = 0, 4 do
            local numSlots = PH.Compat.GetContainerNumSlots(bag)
            if numSlots and numSlots > 0 then
                for slot = 1, numSlots do
                    local link = PH.Compat.GetContainerItemLink(bag, slot)
                    if link then
                        local itemName = GetItemInfo(link)
                        if itemName == gear.name then
                            return bag, slot
                        end
                    end
                end
            end
        end
    end
    return nil, nil
end

local function GetInventorySlotName(invSlot)
    local link = GetInventoryItemLink("player", invSlot)
    if not link then return nil end
    return (GetItemInfo(link))
end

-- PHFishingAssistCastBtn is a SecureActionButtonTemplate UIParent child;
-- btn:Click() casts from Lua out of combat. Used for the auto-recast option.
local function AutoRecast()
    if M.state ~= "idle" then return end
    if InCombatLockdown() then return end
    local btn = _G["PHFishingAssistCastBtn"]
    if btn then btn:Click() end
end

-------------------------------------------------------------------------------
-- Initialization
-------------------------------------------------------------------------------

function M:Initialize()
    if _initialized then return end
    _initialized = true

    bindOwner = CreateFrame("Frame", "PHFishingBindOwner", UIParent)

    -- Restore the saved one-key binding.
    self.oneKey = PH.Config:Get("fa_oneKey")

    PH.Event:On("PLAYER_ENTERING_WORLD", function()
        InitFishingNames()
        if self.oneKey and not InCombatLockdown() then BindCast() end
    end, "FishingAssist")

    -- Fishing is a CHANNELED spell. CHANNEL_START fires when the bobber lands.
    -- Bus dispatches WoW events as (event, ...); payload is (unit, castGUID, spellID).
    PH.Event:On("UNIT_SPELLCAST_CHANNEL_START", function(_, unit, _castGUID, spellID)
        if unit ~= "player" then return end
        if self.state ~= "idle" then return end
        if IsFishingCast(tonumber(spellID)) then
            self:_OnChannelStart()
        end
    end, "FishingAssist")

    PH.Event:On("UNIT_SPELLCAST_CHANNEL_STOP", function(_, unit, _castGUID, spellID)
        if unit ~= "player" then return end
        if not IsFishingCast(tonumber(spellID)) then return end
        self:_OnChannelStop()
    end, "FishingAssist")

    PH.Event:On("UNIT_SPELLCAST_FAILED", function(_, unit, _castGUID, spellID)
        if unit ~= "player" then return end
        if not IsFishingCast(tonumber(spellID)) then return end
        self:_OnChannelStop()
    end, "FishingAssist")

    -- Soft-interact target change — tells us when the bobber is catchable.
    if PH.Compat.HasSoftInteract() then
        PH.Event:On("PLAYER_SOFT_INTERACT_CHANGED", function(_, a1, a2)
            local guid = a2 or a1  -- current soft-interact target GUID
            self.bobberWithinRange = IsBobberGUID(guid)
            if self.state == "waiting" then
                RefreshBind()
            end
        end, "FishingAssist")
    end

    -- Combat safety: release bindings in combat, restore them after.
    PH.Event:On("PLAYER_REGEN_DISABLED", function() ClearBind() end, "FishingAssist")
    PH.Event:On("PLAYER_REGEN_ENABLED",  function() RefreshBind() end, "FishingAssist")

    -- Never leave the soft-target/auto-loot CVars changed on logout.
    PH.Event:On("PLAYER_LOGOUT", function() RestoreFishingCVars() end, "FishingAssist")

    -- Loot window (for stats only — the keypress does the looting).
    PH.Event:On("LOOT_OPENED", function() self:_OnLootOpened() end, "FishingAssist")
    PH.Event:On("LOOT_CLOSED", function() self:_OnLootClosed() end, "FishingAssist")

    -- Track lure buff changes.
    PH.Event:On("UNIT_AURA", function(_, unit)
        if unit == "player" then self:ScanLureBuff() end
    end, "FishingAssist")

    self:ScanLureBuff()
end

-------------------------------------------------------------------------------
-- Event handlers
-------------------------------------------------------------------------------

function M:_OnChannelStart()
    self.state           = "waiting"
    self.bobberCastTime  = GetTime()
    self.bobberWithinRange = false
    self.totalCasts      = self.totalCasts + 1
    if not self.sessionActive then
        self.sessionActive = true
        self.sessionStart  = GetTime()
    end

    ApplyFishingCVars()
    BindCast()  -- no bobber yet; a press recasts until the bobber is detected

    -- If the bobber doesn't become the soft target shortly, try the camera scan.
    if PH.Config:Get("fa_cameraScan") then
        After(0.25, function()
            if self.state == "waiting" and not self.bobberWithinRange then
                StartScan()
            end
        end)
    end

    PH.Event:Fire("PH_FA_UPDATED")
end

function M:_OnChannelStop()
    RestoreFishingCVars()
    StopScan(true)
    self.bobberWithinRange = false
    if self.state ~= "looting" then
        self.state = "idle"
    end
    BindCast()
    PH.Event:Fire("PH_FA_UPDATED")
    if self.state == "idle" and PH.Config:Get("fa_autoRecast") then
        After(0.4, AutoRecast)
    end
end

function M:_OnLootOpened()
    if self.state == "waiting" then
        self.state      = "looting"
        self.fishCaught = self.fishCaught + 1
        PH.Event:Fire("PH_FA_UPDATED")
    end
end

function M:_OnLootClosed()
    if self.state == "looting" then
        self.state = "idle"
        BindCast()
        PH.Event:Fire("PH_FA_UPDATED")
        if PH.Config:Get("fa_autoRecast") then
            After(0.4, AutoRecast)
        end
    end
end

-------------------------------------------------------------------------------
-- Tick  (called every ~0.1s by the UI OnUpdate) — bobber-timeout safety net
-------------------------------------------------------------------------------

function M:Tick()
    if self.state == "waiting" and self.bobberCastTime > 0 then
        if GetTime() - self.bobberCastTime > BOBBER_DURATION + 5 then
            StopScan(true)
            RestoreFishingCVars()
            self.state = "idle"
            self.bobberWithinRange = false
            BindCast()
            PH.Logger.Info("|cffffcc00" .. PH.L["FA_BOBBER_TIMEOUT"] .. "|r")
            PH.Event:Fire("PH_FA_UPDATED")
            if PH.Config:Get("fa_autoRecast") then
                After(0.5, AutoRecast)
            end
        end
    end
end

-------------------------------------------------------------------------------
-- Lure tracking
-------------------------------------------------------------------------------

function M:ScanLureBuff()
    for i = 1, 40 do
        local name, _, _, _, _, expirationTime = UnitBuff("player", i)
        if not name then break end
        if LURE_NAMES[name] then
            self.lureName   = name
            self.lureExpiry = expirationTime or 0
            return
        end
    end
    self.lureName   = nil
    self.lureExpiry = 0
end

function M:GetLureRemaining()
    if not self.lureExpiry or self.lureExpiry == 0 then return 0 end
    return math.max(0, self.lureExpiry - GetTime())
end

-------------------------------------------------------------------------------
-- Best-gear equip
-------------------------------------------------------------------------------

function M:EquipBestGear()
    if InCombatLockdown() then return end

    local currentPole = GetInventorySlotName(16)
    local hasPole = false
    if currentPole then
        for _, p in ipairs(FISHING_POLES) do
            if currentPole == p.name then hasPole = true; break end
        end
    end
    if not hasPole then
        local bag, slot = FindInBags(FISHING_POLES)
        if bag then
            PH.Compat.UseContainerItem(bag, slot)
            hasPole = true
        end
    end

    local currentHat = GetInventorySlotName(1)
    local hasHat = false
    if currentHat then
        for _, h in ipairs(FISHING_HATS) do
            if currentHat == h.name then hasHat = true; break end
        end
    end
    if not hasHat then
        local bag, slot = FindInBags(FISHING_HATS)
        if bag then
            PH.Compat.UseContainerItem(bag, slot)
            hasHat = true
        end
    end

    if hasPole or hasHat then
        PH.Logger.Info("|cff00ff00" .. PH.L["FA_EQUIP_DONE"] .. "|r")
    else
        PH.Logger.Info("|cff808080" .. PH.L["FA_EQUIP_NONE"] .. "|r")
    end
end

-------------------------------------------------------------------------------
-- Session utilities
-------------------------------------------------------------------------------

function M:GetElapsedTime()
    if not self.sessionActive or self.sessionStart == 0 then return 0 end
    return GetTime() - self.sessionStart
end

function M:GetFishPerHour()
    local elapsed = self:GetElapsedTime()
    if elapsed < 10 then return 0 end
    return (self.fishCaught / elapsed) * 3600
end

function M:GetBobberRemaining()
    if self.state ~= "waiting" or self.bobberCastTime == 0 then return 0 end
    return math.max(0, BOBBER_DURATION - (GetTime() - self.bobberCastTime))
end

function M:GetBobberDuration()
    return BOBBER_DURATION
end

function M:FormatTime(seconds)
    local s = math.floor(seconds)
    local m = math.floor(s / 60)
    return string.format("%d:%02d", m, s % 60)
end

function M:ResetSession()
    self.state          = "idle"
    self.bobberCastTime = 0
    self.sessionStart   = 0
    self.sessionActive  = false
    self.fishCaught     = 0
    self.totalCasts     = 0
    PH.Event:Fire("PH_FA_UPDATED")
end

function M:GetAutoRecast()
    return PH.Config:Get("fa_autoRecast") == true
end

function M:SetAutoRecast(enabled)
    PH.Config:Set("fa_autoRecast", enabled and true or false)
end

-- Returns the spell name used for casting (for external callers).
function M:GetSpellName()
    return FISHING_SPELL_NAME
end
