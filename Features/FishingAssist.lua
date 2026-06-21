-- ProfessionHelper - Fishing Assistant (Features/FishingAssist.lua)
-- TRUE one-button fishing for TBC Classic Anniversary.
--
-- How it works:
--   1. Player clicks cast button (SecureActionButtonTemplate UIParent child)
--      → Blizzard secure system casts the Fishing spell (PROFESSIONS_FISHING)
--   2. UNIT_SPELLCAST_CHANNEL_START detected (Fishing is channeled in TBC)
--      → state = "waiting", bobber polling starts
--   3. Addon polls TargetUnit("Fishing Bobber") every 0.4s from OnUpdate
--   4. When bobber is found: InteractUnit("target") → LOOT_OPENED → looting
--   5. LOOT_CLOSED → idle → (optional) auto-recast via SecureActionButton:Click()
--
-- Key TBC Classic Anniversary facts (verified from Angleur addon source):
--   • Fishing is a CHANNELED spell. Events: UNIT_SPELLCAST_CHANNEL_START/_STOP.
--     NOT UNIT_SPELLCAST_START/SUCCEEDED (those are for regular casts only).
--   • TargetUnit() and InteractUnit() do NOT need hardware-event in TBC.
--   • SecureActionButtonTemplate:Click() works OOC when button is UIParent child.
--   • PROFESSIONS_FISHING is the Blizzard global for the localized spell name.

local PH = _G.ProfessionHelper

PH.FishingAssist = {}
local M = PH.FishingAssist

-------------------------------------------------------------------------------
-- Constants
-------------------------------------------------------------------------------

local BOBBER_DURATION = 30  -- TBC Classic: bobber lasts ~30s before sinking

-- Fishing spell IDs — used ONLY for UNIT_SPELLCAST_CHANNEL_START/_STOP matching.
-- Copied from Angleur's AngleurVanilla_FishingSpellTable, which is the verified
-- working set for TBC Classic Anniversary (Angleur is the reference fishing addon).
-- NOT used for casting; casting uses the PROFESSIONS_FISHING Blizzard global.
local FISHING_SPELL_IDS = {
    7620,   -- Fishing
    7731,   -- Fishing (rank variant — Angleur verified)
    7732,   -- Fishing (rank variant — Angleur verified)
    18248,  -- Fishing
    33095,  -- Fishing
    51294,  -- Fishing (present in Anniversary build)
    88868,  -- Fishing (present in Anniversary build)
}

-- Fishing bobber unit names per locale.
-- TBC Anniversary uses English; we include PT/ES for safety.
local BOBBER_NAMES = {
    "Fishing Bobber",
    "Bóia de Pesca",
    "Flotador de Pesca",
    "Schwimmer",
    "Flotteur de pêche",
}
-- Lookup set for bobber unit name matching in TryAutoInteract.
local _bobberSet = {}
for _, n in ipairs(BOBBER_NAMES) do _bobberSet[n] = true end

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

M.state          = "idle"    -- "idle" | "casting" | "waiting" | "looting"
M.bobberCastTime = 0         -- GetTime() when bobber entered water
M.sessionStart   = 0
M.sessionActive  = false
M.fishCaught     = 0
M.totalCasts     = 0
M.lureName       = nil
M.lureExpiry     = 0         -- GetTime() + remaining seconds

local _initialized = false

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

-- PROFESSIONS_FISHING is a Blizzard FrameXML global containing the correct
-- localized fishing spell name for the current client locale.
-- Using this global (rather than a hardcoded string) ensures correct behavior
-- on all server languages. Angleur uses the same global for SetOverrideBindingSpell.
local FISHING_SPELL_NAME = PROFESSIONS_FISHING or "Fishing"

-- Name lookup set for UNIT_SPELLCAST_CHANNEL_START/_STOP event matching.
local _fishingNames = { [FISHING_SPELL_NAME] = true }
local function InitFishingNames()
    for _, sid in ipairs(FISHING_SPELL_IDS) do
        local name = GetSpellInfo(sid)
        if name and name ~= "" then
            _fishingNames[name] = true
        end
    end
end

-- C_Timer.After polyfill for Classic/TBC (no C_Timer on those clients).
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

-- Scan all bags for the first item matching a name list (best-first order).
-- Container reads go through PH.Compat so this works on Cata clients too,
-- where the bare GetContainer* globals were moved into C_Container.
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

-- Returns the name of the item in a specific inventory slot (nil = empty).
local function GetInventorySlotName(invSlot)
    local link = GetInventoryItemLink("player", invSlot)
    if not link then return nil end
    local name = GetItemInfo(link)
    return name
end

-- PHFishingAssistCastBtn is a SecureActionButtonTemplate UIParent child.
-- btn:Click() from Lua works out-of-combat (fishing is always OOC).
-- The spell attribute is set at button creation and never needs updating here.
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

    -- Build fishing name lookup set on login (spell data fully loaded then).
    PH.Event:On("PLAYER_ENTERING_WORLD", function()
        InitFishingNames()
    end, "FishingAssist")

    -- ── UNIT_SPELLCAST_CHANNEL_START ──────────────────────────────────────────────
    -- In TBC Classic, Fishing is a CHANNELED spell (not a regular cast).
    -- CHANNEL_START fires when the bobber enters water — state → "waiting".
    -- TBC BCC Anniversary signature: (unit, castGUID, spellID)
    -- Verified by Angleur (AngleurTBC.lua checks arg5=spellID for this event).
    PH.Event:On("UNIT_SPELLCAST_CHANNEL_START", function(event, unit, castGUID, spellID)
        if unit ~= "player" then return end
        if M.state ~= "idle" then return end
        if IsFishingID(tonumber(spellID)) then
            M:_OnChannelStart()
        end
    end, "FishingAssist")

    -- ── UNIT_SPELLCAST_CHANNEL_STOP ───────────────────────────────────────────────
    -- Fires when the channel ends. Two cases:
    --   (a) Fish reeled in — LOOT_CLOSED already set state "idle". No-op.
    --   (b) Bobber sank without bite — state still "waiting"; reset to idle.
    PH.Event:On("UNIT_SPELLCAST_CHANNEL_STOP", function(event, unit, castGUID, spellID)
        if unit ~= "player" then return end
        if not IsFishingID(tonumber(spellID)) then return end
        if M.state == "waiting" then
            M.state = "idle"
            PH.Event:Fire("PH_FA_UPDATED")
            if PH.Config:Get("fa_autoRecast") then
                After(0.4, AutoRecast)
            end
        end
    end, "FishingAssist")

    -- ── UNIT_SPELLCAST_FAILED ─────────────────────────────────────────────────────
    -- Fires if the cast was rejected before the channel could start
    -- (no fishing rod equipped, not near water, already casting, etc.)
    -- TBC BCC Anniversary signature: (unit, castGUID, spellID)
    PH.Event:On("UNIT_SPELLCAST_FAILED", function(event, unit, castGUID, spellID)
        if unit ~= "player" then return end
        if not IsFishingID(tonumber(spellID)) then return end
        M.state = "idle"
        PH.Event:Fire("PH_FA_UPDATED")
    end, "FishingAssist")

    -- Loot window opened → fish bit and player (or auto-interact) clicked bobber
    PH.Event:On("LOOT_OPENED", function()
        M:_OnLootOpened()
    end, "FishingAssist")

    -- Loot window closed → ready to cast again
    PH.Event:On("LOOT_CLOSED", function()
        M:_OnLootClosed()
    end, "FishingAssist")

    -- Track lure buff changes
    PH.Event:On("UNIT_AURA", function(event, unit)
        if unit == "player" then M:ScanLureBuff() end
    end, "FishingAssist")

    -- Initial lure scan
    self:ScanLureBuff()
end

-------------------------------------------------------------------------------
-- Event handlers
-------------------------------------------------------------------------------

function M:_OnChannelStart()
    self.state          = "waiting"
    self.bobberCastTime = GetTime()
    self._castStartTime = nil
    self._lastInteractTry = nil  -- allow immediate first attempt
    self.totalCasts     = self.totalCasts + 1
    if not self.sessionActive then
        self.sessionActive = true
        self.sessionStart  = GetTime()
    end
    PH.Event:Fire("PH_FA_UPDATED")
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
        PH.Event:Fire("PH_FA_UPDATED")
        if PH.Config:Get("fa_autoRecast") then
            -- SecureActionButton:Click() from a delayed timer works in TBC
            -- Classic out-of-combat. AutoRecast() checks state + lockdown.
            After(0.4, AutoRecast)
        end
    end
end

-------------------------------------------------------------------------------
-- Tick  (called every ~0.1s by the UI OnUpdate)
-------------------------------------------------------------------------------

function M:Tick()
    local now = GetTime()

    -- ── Auto-interact with bobber ────────────────────────────────────────
    -- In TBC Classic, TargetUnit() and InteractUnit() do NOT require a
    -- hardware-event context (that restriction was added in Cata+).
    -- We can safely poll for the bobber unit from OnUpdate.
    if self.state == "waiting" then
        self:TryAutoInteract()
    end

    -- ── Bobber timeout (safety net) ──────────────────────────────────────
    if self.state == "waiting" and self.bobberCastTime > 0 then
        if now - self.bobberCastTime > BOBBER_DURATION + 5 then
            self.state = "idle"
            PH.Logger.Info("|cffffcc00" .. PH.L["FA_BOBBER_TIMEOUT"] .. "|r")
            PH.Event:Fire("PH_FA_UPDATED")
            if PH.Config:Get("fa_autoRecast") then
                After(0.5, AutoRecast)
            end
        end
    end

    -- ── Stuck-cast safety ────────────────────────────────────────────────
    -- In TBC Classic, Fishing is channeled — CHANNEL_STOP is the authoritative
    -- reset event. The bobber timeout above covers the edge case where CHANNEL_STOP
    -- never fires (e.g. server disconnect, client bug).
end

-------------------------------------------------------------------------------
-- Auto-Interact  (polls from Tick while state == "waiting")
-------------------------------------------------------------------------------

function M:TryAutoInteract()
    -- Rate-limit: attempt every 0.4 seconds
    local now = GetTime()
    if self._lastInteractTry and (now - self._lastInteractTry) < 0.4 then return end
    self._lastInteractTry = now

    -- ── Primary: target the bobber by its unit name ──────────────────────
    -- Fishing bobbers in TBC Classic are critter-type units (like totems),
    -- so TargetUnit(name) works from any non-combat Lua context.
    for _, bn in ipairs(BOBBER_NAMES) do
        TargetUnit(bn)
        if UnitExists("target") then
            local tName = UnitName("target") or ""
            if _bobberSet[tName] then
                InteractUnit("target")
                -- Give the loot window time to open before retrying
                self._lastInteractTry = now + 1.5
                return
            end
        end
    end

    -- ── Fallback: if player is hovering the bobber with their mouse ──────
    if UnitExists("mouseover") then
        local mName = UnitName("mouseover") or ""
        if _bobberSet[mName] then
            InteractUnit("mouseover")
            self._lastInteractTry = now + 1.5
        end
    end
end

-------------------------------------------------------------------------------
-- Lure tracking
-------------------------------------------------------------------------------

function M:ScanLureBuff()
    for i = 1, 40 do
        -- UnitBuff signature: (unit, index[, filter])
        -- Returns: name, icon, count, debuffType, duration, expirationTime, ...
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

    -- Both UseContainerItem calls must be direct (no After() delay) because
    -- in TBC Classic, equipping items via UseContainerItem requires a hardware-
    -- event context. Any timer callback (After/OnUpdate) breaks that chain.

    -- Equip best fishing pole (main hand = inv slot 16)
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

    -- Equip best fishing hat (head = inv slot 1)
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

-- Full bobber lifetime in seconds (used by the UI timer bar to scale fill).
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
