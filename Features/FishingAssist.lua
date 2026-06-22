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

-- Fishing lures are TEMPORARY WEAPON ENCHANTS on the pole (not player buffs),
-- so they are detected via GetWeaponEnchantInfo's enchant id, not UnitBuff.
-- enchant id -> display name. (IDs verified from the Angleur addon.)
local LURE_ENCHANT_IDS = {
    [263]  = "Shiny Bauble",
    [264]  = "Nightcrawlers",
    [265]  = "Bright Baubles",
    [266]  = "Aquadynamic Fish Attractor",
    [3868] = "Flesh-Eating Worm",
    [4225] = "Glow Worm",
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

-- Secure macro button used to apply a fishing lure (using an item is protected,
-- so it must run from the player's keypress through this secure button).
local lureButton

-- Lures the assistant will auto-apply, best fishing bonus first. Matched by
-- item ID (locale-independent); the macro then uses the item's localized name.
local LURE_ITEM_IDS = {
    34861,  -- Sharpened Fish Hook        (+100, TBC daily reward)
    6533,   -- Aquadynamic Fish Attractor (+100, Engineering)
    46006,  -- Glow Worm                  (+100, WotLK)
    6532,   -- Bright Baubles             (+75,  vendor)
    6811,   -- Flesh-Eating Worm          (+75,  WotLK)
    6530,   -- Nightcrawlers              (+50,  vendor)
    6529,   -- Shiny Bauble               (+25,  vendor)
}

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

-- True if a GUID is a fishing bobber GameObject. GUID format varies by client
-- (GameObject-0-<server>-<instance>-<zoneuid>-<objectid>-<spawnuid>), so match
-- loosely: a GameObject GUID containing the bobber object id field.
local function IsBobberGUID(guid)
    if type(guid) ~= "string" then return false end
    if guid:find("^GameObject%-") == nil then return false end
    return guid:find("%-" .. BOBBER_OBJECT_ID .. "%-") ~= nil
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
    -- Applied whenever the feature is on; SetCVar is a no-op on clients that
    -- lack the soft-target CVars, so we don't gate on HasSoftInteract.
    return PH.Config:Get("fa_softTarget") ~= false
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

-- Optional "focus audio" while fishing so the bobber splash (an SFX) is easy to
-- hear. There is no fishing-bite event in Classic to play a one-off alert on, so
-- the trick -- copied from Angleur's "Ultra Focus" -- is to MUTE the competing
-- channels (music/ambience/dialog -> 0) and MAX the master + SFX so the game's
-- own splash cuts through. Just raising SFX does nothing: it is usually already
-- maxed and the music/ambience drown the splash. The channels are force-enabled
-- so the volume values actually take effect. Every value is cached and restored
-- when fishing ends, so the player's normal audio always comes back.
-- (Angleur/init.lua:597-632 + AngleurAudio defaults init.lua:172-185.)
local SOUND_BOOST_CVARS = {
    Sound_EnableAllSound          = "1",
    Sound_EnableSFX               = "1",
    Sound_EnableMusic             = "1",
    Sound_EnableAmbience          = "1",
    Sound_EnableDialog            = "1",
    Sound_EnableSoundWhenGameIsInBG = "1",  -- still hear the splash while tabbed out
    Sound_MasterVolume            = "1",
    Sound_SFXVolume               = "1",
    Sound_MusicVolume             = "0",
    Sound_AmbienceVolume          = "0",
    Sound_DialogVolume            = "0",
}
-- The original values are cached in SavedVariables (PH.DB), NOT just in memory:
-- CVars persist across sessions, so if the client crashes or disconnects between
-- the cast and the reel the player's music would stay muted forever. Persisting
-- the cache lets RestoreSoundBoost() recover it on the next login (see Initialize).
local SOUND_CACHE_KEY = "faSoundCache"

local function ApplySoundBoost()
    if PH.Config:Get("fa_soundBoost") ~= true then return end
    -- Cache the originals exactly once. The guard also stops us from re-caching
    -- the already-boosted values as if they were the originals.
    if not PH.DB:Get(SOUND_CACHE_KEY) then
        local cache = {}
        for name in pairs(SOUND_BOOST_CVARS) do
            cache[name] = PH.Compat.GetCVar(name) or false  -- false marks "unset"
        end
        PH.DB:Set(SOUND_CACHE_KEY, cache)
    end
    -- Master + SFX follow the user-tunable focus volume (Options panel); the rest
    -- (mute the other channels, enable the channels) use the fixed recipe values.
    local vol = tostring(PH.Config:Get("fa_focusVolume") or 1.0)
    for name, val in pairs(SOUND_BOOST_CVARS) do
        if name == "Sound_MasterVolume" or name == "Sound_SFXVolume" then
            PH.Compat.SetCVar(name, vol)
        else
            PH.Compat.SetCVar(name, val)
        end
    end
end

local function RestoreSoundBoost()
    local cache = PH.DB and PH.DB:Get(SOUND_CACHE_KEY)
    if not cache then return end
    for name in pairs(SOUND_BOOST_CVARS) do
        local prev = cache[name]
        if prev ~= nil then
            -- prev == false marks "was unset when cached" -> restore the CVar's
            -- real Blizzard default (e.g. "0" for Sound_EnableSoundWhenGameIsInBG),
            -- NOT a blanket "1" which would max volumes / force background audio on.
            if prev == false then
                prev = PH.Compat.GetCVarDefault(name)
            end
            if prev ~= nil then PH.Compat.SetCVar(name, prev) end
        end
    end
    PH.DB:Set(SOUND_CACHE_KEY, nil)
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

local function ClearBind()
    if InCombatLockdown() or not bindOwner then return end
    ClearOverrideBindings(bindOwner)
end

-- Decide what the one key should do right now:
--   "reel" — fishing in progress: interact/loot the bobber (INTERACTMOUSEOVER
--            loots it via the soft-target, or the bobber under the cursor)
--   "lure" — idle, no active lure, and a lure is in the bag: apply the best one
--   "cast" — otherwise: cast Fishing
-- Returns (action, lureName?).
-- During the whole channel the key reels — pressing before the bite simply does
-- nothing (no interactable yet), so the player never accidentally re-casts.
local function DecideAction()
    if M.state == "waiting" then
        return "reel"
    end
    if PH.Config:Get("fa_autoLure") ~= false and not M.lureName then
        local lure = M:GetBestBagLure()
        if lure then return "lure", lure end
    end
    return "cast"
end

-- Apply the override binding for the current action. force=true skips the
-- held-key guard, needed for explicit user actions (assigning the key, opening
-- the panel): the assign key is still physically held during capture, so the
-- guarded path would skip the bind and the key would revert to e.g. jump.
local function ApplyAction(force)
    if not M.oneKey or not bindOwner or InCombatLockdown() then return end
    if not force and KeyHeld() then return end
    local action, lure = DecideAction()
    ClearOverrideBindings(bindOwner)
    if action == "reel" then
        SetOverrideBinding(bindOwner, true, M.oneKey, "INTERACTMOUSEOVER")
    elseif action == "lure" and lureButton and lure then
        lureButton:SetAttribute("macrotext", "/use " .. lure .. "\n/use 16")
        SetOverrideBindingClick(bindOwner, true, M.oneKey, "PHFishingLureButton")
    else
        SetOverrideBindingSpell(bindOwner, true, M.oneKey, FISHING_SPELL_NAME)
    end
    PH.Logger.Debug("FA bind -> " .. action .. " (state=" .. M.state
        .. ", bobber=" .. tostring(M.bobberWithinRange) .. ")")
end
M._ApplyAction = ApplyAction

function M:SetOneKey(key)
    -- key is a binding string ("F", "BUTTON4", "ALT-E", ...) or nil to clear
    self.oneKey = (key ~= "" and key) or nil
    PH.Config:Set("fa_oneKey", self.oneKey)
    if bindOwner and not InCombatLockdown() then
        if self.oneKey then
            ApplyAction(true)
        else
            ClearOverrideBindings(bindOwner)
        end
    end
    if self.oneKey then
        PH.Logger.Info("|cff30a5ff" .. string.format(PH.L["FA_KEY_SET"], self.oneKey) .. "|r")
    end
    PH.Event:Fire("PH_FA_UPDATED")
end

function M:GetOneKey()
    return self.oneKey
end

-- Re-arm the override binding (called by the UI when the panel opens) so a
-- previously-assigned key is active even if it was cleared (combat, reload).
function M:RearmBinding()
    ApplyAction(true)
end

-------------------------------------------------------------------------------
-- Camera bobber scanner (opt-in fallback)
-- Rotates the CAMERA (not the character) in a serpentine sweep so the bobber
-- slides under a cursor parked in a fixed on-screen box. When the cursor turns
-- into the interact cursor over the bobber, CURSOR_CHANGED fires and
-- SetCursor(nil) returns true, so the scan stops with the cursor on the bobber.
-------------------------------------------------------------------------------

-- V_OFFSET shifts the scan band's START downward from the cursor; the sweep then
-- climbs V_DIST upward. So the band covers (cursor - V_OFFSET) .. (cursor -
-- V_OFFSET + V_DIST). With V_DIST == V_OFFSET it only covers BELOW the cursor and
-- misses bobbers above it, so V_DIST must exceed V_OFFSET to scan above too.
local SCAN = {
    H_SPEED = 0.4, V_SPEED = 0.3, H_DIST = 0.25, V_DIST = 0.6,
    V_OFFSET = 0.05, WAIT_TIME = 1, V_LINES = 22, ZFACTOR_STR = 1.3,
    TIMEOUT = 22,
}

-- The whole scan geometry assumes the camera is fully zoomed OUT to ~2x the base
-- max distance. We temporarily raise cameraDistanceMaxZoomFactor to this value,
-- then MoveViewOutStart(16) drives the camera to that new, larger max. The same
-- angular sweep then covers a much wider patch of world. Restored on stop.
-- (Mirrors Angleur's tempMaxZoom default of 2; bobberScanner.lua:212/337/342.)
local SCAN_MAX_ZOOM = "2"

local scanFrame, timeOutFrame
local scanBox
local _scanActive     = false
local _scanMouseInside = false
local _camZoomCache

-- Forward declarations (the sweep/nextLine pair is mutually recursive).
local SingleDelayer, Scan_Setup, Scan_Sweep, Scan_NextLine, Scan_CheckCursor

-- Faithful port of Angleur_SingleDelayer (init.lua:345): run endFunc after
-- `delay` seconds, driven by `frame`'s OnUpdate (which it OWNS for the step).
SingleDelayer = function(delay, frame, threshold, endFunc)
    local elapsed = 0
    frame:SetScript("OnUpdate", function(self, dt)
        elapsed = elapsed + dt
        if elapsed > threshold then
            delay   = delay - elapsed
            elapsed = 0
        end
        if delay <= 0 then
            self:SetScript("OnUpdate", nil)
            if endFunc then endFunc() end
        end
    end)
end

-- Restore the raised max-zoom factor (idempotent). Kept SEPARATE from StopScan:
-- when the scan FINDS the bobber we must NOT restore the zoom, because zooming
-- back in slides the bobber out from under the parked cursor and INTERACTMOUSEOVER
-- then misses. The zoom is restored only when fishing ends or the scan fails.
local function RestoreScanZoom()
    if _camZoomCache ~= nil then
        PH.Compat.SetCVar("cameraDistanceMaxZoomFactor", _camZoomCache)
        _camZoomCache = nil
    end
end

-- Stop the camera sweep, leaving the camera and zoom exactly where they are
-- (so a found bobber stays under the cursor).
local function StopScan()
    if not _scanActive then return end
    _scanActive = false
    MoveViewRightStop(); MoveViewLeftStop()
    MoveViewUpStop();    MoveViewDownStop()
    MoveViewOutStop()
    if scanFrame then
        scanFrame:SetScript("OnUpdate", nil)
        scanFrame:SetScript("OnEvent", nil)
    end
    if timeOutFrame then timeOutFrame:SetScript("OnUpdate", nil) end
end
M._StopScan = StopScan

-- Stop the scan AND restore the zoom (scan failed, or fishing ended). Only
-- recenters if the scan had actually raised the zoom.
local function EndScan(recenter)
    local hadZoom = _camZoomCache ~= nil
    StopScan()
    RestoreScanZoom()
    if recenter and hadZoom then CenterCamera() end
end
M._EndScan = EndScan

-- The cursor (parked in the box) turned into the interact cursor over the bobber.
Scan_CheckCursor = function()
    if SetCursor(nil) == true then
        StopScan()  -- keep the camera/zoom; the bobber stays under the cursor
        M.bobberWithinRange = true
        PH.Event:Fire("PH_FA_UPDATED")
    end
end

-- Pitch up one row, then sweep it (Angleur bobberScanner.lua:429).
Scan_NextLine = function(lines, lineChangeTime, columnSweepTime, moveLeft)
    if lines == 0 then
        EndScan(true)  -- scan failed: restore zoom + recenter
        PH.Logger.Info("|cffffcc00" .. PH.L["FA_SCAN_FAIL"] .. "|r")
        return
    end
    MoveViewUpStart(SCAN.V_SPEED)
    SingleDelayer(lineChangeTime, scanFrame, lineChangeTime, function()
        MoveViewUpStart(0)
        Scan_Sweep(lines - 1, lineChangeTime, columnSweepTime, moveLeft)
    end)
end

-- Sweep one row horizontally, then advance to the next (Angleur:450).
Scan_Sweep = function(lines, lineChangeTime, columnSweepTime, moveLeft)
    if moveLeft then
        MoveViewLeftStart(SCAN.H_SPEED)
        SingleDelayer(columnSweepTime, scanFrame, columnSweepTime, function()
            MoveViewLeftStart(0)
            Scan_NextLine(lines, lineChangeTime, columnSweepTime, not moveLeft)
        end)
    else
        MoveViewRightStart(SCAN.H_SPEED)
        SingleDelayer(columnSweepTime, scanFrame, columnSweepTime, function()
            MoveViewRightStart(0)
            Scan_NextLine(lines, lineChangeTime, columnSweepTime, not moveLeft)
        end)
    end
end

-- Zoom out, move to the start corner, then begin the serpentine (Angleur:471).
Scan_Setup = function(lines, verticalTime, horizontalTime, moveLeft, zoomFactor_vOffset)
    local setup_hSpeed = SCAN.H_SPEED
    local vOffset_time = SCAN.V_OFFSET / SCAN.V_SPEED
    local setup_vSpeed = SCAN.V_SPEED * (vOffset_time / horizontalTime) * zoomFactor_vOffset
    -- Hard timeout on a SEPARATE frame (the main sequence owns scanFrame).
    SingleDelayer(SCAN.TIMEOUT, timeOutFrame, 1, function() EndScan(true) end)
    MoveViewOutStart(16)
    SingleDelayer(SCAN.WAIT_TIME, scanFrame, SCAN.WAIT_TIME, function()
        MoveViewOutStop()
        MoveViewUpStart(setup_vSpeed)
        MoveViewRightStart(setup_hSpeed)
        SingleDelayer(horizontalTime / 2, scanFrame, 0.1, function()
            MoveViewRightStart(0)
            MoveViewUpStart(0)
            local lineswap_time = verticalTime / lines
            scanFrame:SetScript("OnEvent", Scan_CheckCursor)
            Scan_Sweep(lines, lineswap_time, horizontalTime, not moveLeft)
        end)
    end)
end

local function EnsureScanFrames()
    if scanFrame then return end
    scanFrame = CreateFrame("Frame")
    scanFrame:RegisterEvent("CURSOR_CHANGED")  -- OnEvent set during the sweep
    timeOutFrame = CreateFrame("Frame")
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
        if _scanActive then EndScan(true) end
    end)
    scanBox:Hide()
end

function M:ShowScanBox(show)
    EnsureScanBox()
    if show then scanBox:Show() else scanBox:Hide() end
end

-- = Angleur_BobberScanner (bobberScanner.lua:526). Sets up the zoom and kicks
-- off the setup -> serpentine sweep chain.
local function StartScan()
    if _scanActive then return end
    if not PH.Config:Get("fa_cameraScan") then return end
    EnsureScanFrames()
    EnsureScanBox()
    scanBox:Show()
    if not _scanMouseInside then
        PH.Logger.Info("|cffffcc00" .. PH.L["FA_SCAN_NEEDMOUSE"] .. "|r")
        return
    end

    CenterCamera()

    -- Raise the max-zoom factor so MoveViewOutStart(16) can drive the camera to
    -- a much larger max distance; the angular sweep is tuned for that far-out
    -- view. Restored on stop. (Angleur bobberScanner.lua:545-552.) We do NOT
    -- touch any camera turn-speed CVar -- the rate is purely the MoveView args.
    _camZoomCache = PH.Compat.GetCVar("cameraDistanceMaxZoomFactor")
    if _camZoomCache ~= tostring(SCAN_MAX_ZOOM) then
        PH.Compat.SetCVar("cameraDistanceMaxZoomFactor", SCAN_MAX_ZOOM)
    end
    local maxZoom = tonumber(PH.Compat.GetCVar("cameraDistanceMaxZoomFactor")) or 2
    local zoomFactor          = (maxZoom + SCAN.ZFACTOR_STR) / (SCAN.ZFACTOR_STR + 1)
    local zoomFactor_vOffset  = zoomFactor
    local zoomFactor_Horizontal = zoomFactor * 0.8
    local vTime = (SCAN.V_DIST / SCAN.V_SPEED)
    local hTime = (SCAN.H_DIST / SCAN.H_SPEED) / zoomFactor_Horizontal
    local lines = SCAN.V_LINES

    _scanActive = true
    MoveViewRightStart(0); MoveViewUpStart(0); MoveViewLeftStart(0)
    MoveViewDownStart(0);  MoveViewOutStart(0)
    Scan_Setup(lines, vTime, hTime, false, zoomFactor_vOffset)
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

-- True if a known fishing pole is equipped in the main hand.
local function PoleEquipped()
    local name = GetInventorySlotName(16)
    if not name then return false end
    for _, p in ipairs(FISHING_POLES) do
        if name == p.name then return true end
    end
    return false
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

    -- Recover a sound cache orphaned by a crash/disconnect mid-cast last session,
    -- so the player's audio is never left stuck on the focus-mode values.
    RestoreSoundBoost()

    -- Always-on driver for M:Tick (lure scan + bobber-timeout/audio safety net).
    -- The Fishing panel's OnUpdate only fires while the panel is shown, so it can
    -- NOT be relied on to tear down the focus-audio CVars -- a closed panel would
    -- leave the player muted. This hidden frame runs regardless of UI visibility.
    local tickFrame = CreateFrame("Frame")
    local _tickAccum = 0
    tickFrame:SetScript("OnUpdate", function(_, dt)
        _tickAccum = _tickAccum + dt
        if _tickAccum < 0.1 then return end
        _tickAccum = 0
        self:Tick()
        -- Last-resort safety: if we are idle but a sound cache lingers, a teardown
        -- was missed somewhere -> restore the player's audio immediately.
        if self.state == "idle" and PH.DB:Get(SOUND_CACHE_KEY) then
            RestoreSoundBoost()
        end
    end)

    bindOwner = CreateFrame("Frame", "PHFishingBindOwner", UIParent)

    -- Secure macro button for applying lures (using an item is protected).
    lureButton = CreateFrame("Button", "PHFishingLureButton", UIParent,
                             "SecureActionButtonTemplate")
    lureButton:SetAttribute("type", "macro")
    -- A key-bound override click fires a single virtual click on key-down, so
    -- the button must accept down clicks (matches Angleur's toy/bait button).
    lureButton:RegisterForClicks("AnyDown", "AnyUp")

    -- Restore the saved one-key binding.
    self.oneKey = PH.Config:Get("fa_oneKey")

    PH.Event:On("PLAYER_ENTERING_WORLD", function()
        InitFishingNames()
        if self.oneKey and not InCombatLockdown() then ApplyAction(true) end
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

    -- Tear down whenever WE were fishing. The STOP/FAILED spellID often drifts
    -- (or is 0/nil) for a channeled spell on Anniversary, so we must NOT gate the
    -- teardown on a spell-ID match: if our state machine started a fishing channel
    -- (state ~= "idle"), always restore -- otherwise the focus-audio CVars (and
    -- soft-target CVars) stay applied and the player is left stuck muted.
    local function onChannelEnd(_, unit, _castGUID, spellID)
        if unit ~= "player" then return end
        if self.state == "idle" and not IsFishingCast(tonumber(spellID)) then return end
        self:_OnChannelStop()
    end
    PH.Event:On("UNIT_SPELLCAST_CHANNEL_STOP", onChannelEnd, "FishingAssist")
    PH.Event:On("UNIT_SPELLCAST_FAILED",       onChannelEnd, "FishingAssist")

    -- Soft-interact target change — tells us when the bobber is catchable.
    -- Registered unconditionally; on clients without soft-target it just never
    -- fires. Used only for the "Bite ready!" UI hint (the key reels regardless).
    PH.Event:On("PLAYER_SOFT_INTERACT_CHANGED", function(_, a1, a2)
        local guid = a2 or a1  -- current soft-interact target GUID
        self.bobberWithinRange = IsBobberGUID(guid)
        PH.Logger.Debug("FA soft-interact: " .. tostring(guid)
            .. " bobber=" .. tostring(self.bobberWithinRange))
        -- The soft-target follows the mouse cursor, so the bobber is detected
        -- only once the camera scan slides it under the parked cursor. Stop the
        -- scan the instant that happens, leaving the bobber under the cursor.
        if self.bobberWithinRange then M._StopScan() end
        if self.state == "waiting" then ApplyAction() end
    end, "FishingAssist")

    -- Combat safety: release bindings in combat, restore them after.
    PH.Event:On("PLAYER_REGEN_DISABLED", function() ClearBind() end, "FishingAssist")
    PH.Event:On("PLAYER_REGEN_ENABLED",  function() ApplyAction() end, "FishingAssist")

    -- Never leave the soft-target/auto-loot CVars changed on logout.
    PH.Event:On("PLAYER_LOGOUT", function() RestoreFishingCVars(); RestoreSoundBoost() end, "FishingAssist")

    -- Loot window (for stats only — the keypress does the looting).
    PH.Event:On("LOOT_OPENED", function() self:_OnLootOpened() end, "FishingAssist")
    PH.Event:On("LOOT_CLOSED", function() self:_OnLootClosed() end, "FishingAssist")

    -- Lures are a temporary weapon enchant — UNIT_INVENTORY_CHANGED fires when
    -- one is applied/removed. ScanLureBuff re-evaluates the key action on change.
    PH.Event:On("UNIT_INVENTORY_CHANGED", function(_, unit)
        if unit == "player" then self:ScanLureBuff() end
    end, "FishingAssist")

    -- A lure used up / restocked changes whether one is available to apply.
    PH.Event:On("BAG_UPDATE_DELAYED", function()
        if self.state == "idle" then ApplyAction() end
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
    ApplySoundBoost()
    ApplyAction()  -- no bobber yet; a press recasts until the bobber is detected

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
    RestoreSoundBoost()
    EndScan(true)  -- restore the raised zoom now that fishing is over
    self.bobberWithinRange = false
    -- Stamp the moment the fishing channel ended. On a catch the loot window
    -- can open a hair AFTER this fires (and after we reset state to "idle"), so
    -- _OnLootOpened uses this timestamp to still count the fish.
    self._channelStopTime = GetTime()
    if self.state ~= "looting" then
        self.state = "idle"
    end
    ApplyAction()
    PH.Event:Fire("PH_FA_UPDATED")
    if self.state == "idle" and PH.Config:Get("fa_autoRecast") then
        After(0.4, AutoRecast)
    end
end

function M:_OnLootOpened()
    -- Count the catch whether LOOT_OPENED fires while still "waiting" or just
    -- after the channel stopped (the two events race on a successful reel).
    local justFished = self.state == "waiting"
        or (self._channelStopTime and (GetTime() - self._channelStopTime) < 2)
    if justFished then
        self.state            = "looting"
        self.fishCaught       = self.fishCaught + 1
        self._channelStopTime = nil  -- consume so we never double-count
        PH.Event:Fire("PH_FA_UPDATED")
    end
end

function M:_OnLootClosed()
    if self.state == "looting" then
        self.state = "idle"
        ApplyAction()
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
    -- Re-scan the lure (weapon enchant) periodically — there is no change event
    -- for its countdown, and this also catches a lure that was just applied.
    local now = GetTime()
    if not self._lastLureScan or now - self._lastLureScan > 0.5 then
        self._lastLureScan = now
        self:ScanLureBuff()
    end

    if self.state == "waiting" and self.bobberCastTime > 0 then
        if GetTime() - self.bobberCastTime > BOBBER_DURATION + 5 then
            EndScan(true)
            RestoreFishingCVars()
            RestoreSoundBoost()
            self.state = "idle"
            self.bobberWithinRange = false
            ApplyAction()
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
    local prevActive = self.lureName ~= nil

    -- Lures are a temporary main-hand weapon enchant. A fishing pole can ONLY
    -- carry a lure enchant, so any main-hand temp enchant while a pole is
    -- equipped counts as a lure (covers unmapped enchant ids).
    local hasEnchant, expirationMs, _, enchantID = GetWeaponEnchantInfo()
    local lureName
    if hasEnchant then
        lureName = enchantID and LURE_ENCHANT_IDS[enchantID]
        if not lureName and PoleEquipped() then
            lureName = PH.L["FA_LURE_GENERIC"]
        end
    end

    if lureName then
        self.lureName   = lureName
        self.lureExpiry = GetTime() + ((tonumber(expirationMs) or 0) / 1000)
    else
        self.lureName   = nil
        self.lureExpiry = 0
    end

    -- If the lure appeared/disappeared while idle, switch the key action
    -- (cast <-> apply lure) immediately.
    if (self.lureName ~= nil) ~= prevActive and self.state == "idle" and M._ApplyAction then
        M._ApplyAction()
    end
end

function M:GetLureRemaining()
    if not self.lureExpiry or self.lureExpiry == 0 then return 0 end
    return math.max(0, self.lureExpiry - GetTime())
end

-- True if the next idle keypress would apply a lure (no active lure + one in
-- the bag + the feature is on). Used by the UI to label the action.
function M:NextActionIsLure()
    if self.state ~= "idle" then return false end
    if PH.Config:Get("fa_autoLure") == false then return false end
    if self.lureName then return false end
    return self:GetBestBagLure() ~= nil
end

-- Returns the localized name of the best lure currently in the bags (best bonus
-- first, matched by item ID), or nil if none. Used to auto-apply a lure.
function M:GetBestBagLure()
    for _, wantID in ipairs(LURE_ITEM_IDS) do
        for bag = 0, 4 do
            local numSlots = PH.Compat.GetContainerNumSlots(bag)
            if numSlots and numSlots > 0 then
                for slot = 1, numSlots do
                    local link = PH.Compat.GetContainerItemLink(bag, slot)
                    if link then
                        local id = tonumber(link:match("item:(%d+)"))
                        if id == wantID then
                            local name = GetItemInfo(link)
                            if name and name ~= "" then return name end
                        end
                    end
                end
            end
        end
    end
    return nil
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
