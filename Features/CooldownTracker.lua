-- Profession Helper - Cooldown Tracker
-- Tracks TBC/WotLK/Cata profession daily/weekly cooldowns:
--   Alchemy: all Transmute spells share a single 24h slot
--   Tailoring: Shadowcloth / Spellcloth / Primal Mooncloth each have an 84h (3.5 day) slot
--
-- Architecture:
--   - Uses PH.Identity for character key lookups
--   - Uses PH.DB      for all SavedVariables access
--   - Uses PH.Event   for UNIT_SPELLCAST_SUCCEEDED subscription
--   - Uses PH.Compat  for GetSpellInfo (cross-version wrapper)

local PH = _G.ProfessionHelper

PH.CooldownTracker = {}
local CD = PH.CooldownTracker

-------------------------------------------------------------------------------
-- Cooldown database
-------------------------------------------------------------------------------
CD.DATABASE = {
    {
        key      = "transmute",
        patterns = { "^Transmute:" },
        label    = "Transmute",
        category = "Alchemy",
        cdHours  = 24,
        icon     = "Interface\\Icons\\inv_potion_59",
    },
    {
        key      = "shadowcloth",
        patterns = { "^Shadowcloth$" },
        label    = "Shadowcloth",
        category = "Tailoring",
        cdHours  = 84,
        icon     = "Interface\\Icons\\inv_fabric_shadowcloth",
    },
    {
        key      = "spellcloth",
        patterns = { "^Spellcloth$" },
        label    = "Spellcloth",
        category = "Tailoring",
        cdHours  = 84,
        icon     = "Interface\\Icons\\inv_fabric_spellcloth",
    },
    {
        key      = "primal_mooncloth",
        patterns = { "^Primal Mooncloth$", "^Mooncloth$" },
        label    = "Primal Mooncloth",
        category = "Tailoring",
        cdHours  = 84,
        icon     = "Interface\\Icons\\inv_fabric_mooncloth_02",
    },
}

-- Reverse-lookup: pattern → def (built once at load time, never rebuilt)
local patternToDef = {}
for _, def in ipairs(CD.DATABASE) do
    for _, pat in ipairs(def.patterns) do
        patternToDef[pat] = def
    end
end

local function FindDef(spellName)
    if not spellName then return nil end
    for pat, def in pairs(patternToDef) do
        if string.match(spellName, pat) then return def end
    end
    return nil
end

-------------------------------------------------------------------------------
-- Core API
-------------------------------------------------------------------------------

-- Called when a relevant spell cast completes for the current player.
function CD:RecordCast(spellName)
    local def = FindDef(spellName)
    if not def then return end

    local charKey = PH.Identity:GetCharKey()
    local cdPath  = "cooldowns." .. charKey
    PH.DB:Ensure(cdPath)
    PH.DB:Set(cdPath .. "." .. def.key, {
        spellName = spellName,
        ts        = time(),
        cdHours   = def.cdHours,
        notified  = false,
    })

    PH.Logger.Info(string.format(
        "|cffffd700[CD]|r %s %s %s",
        def.label, PH.L["CD_READY_IN"], self:FormatRemaining(def.cdHours * 3600)
    ))
end

-- Checks all cooldowns for the current character and fires a chat notification
-- the first time each one is found to have expired.  Safe to call repeatedly.
function CD:CheckAndNotify()
    if not PH.Identity or not PH.Identity:GetCharKey() then return end
    local charKey = PH.Identity:GetCharKey()
    for _, def in ipairs(self.DATABASE) do
        local entry = PH.DB:Get("cooldowns." .. charKey .. "." .. def.key)
        if entry and entry.ts and not entry.notified then
            local remaining = self:GetRemainingSeconds(charKey, def.key)
            if remaining == 0 then
                PH.Logger.Info(string.format(
                    "|cffffd700[CD]|r " .. PH.L["CD_READY_NOTIFY"],
                    "|cff00ff00" .. def.label .. "|r"
                ))
                entry.notified = true
                PH.DB:Set("cooldowns." .. charKey .. "." .. def.key, entry)
                -- Refresh the cooldown panel if it's open
                if PH.UpdateCooldownUI then PH:UpdateCooldownUI() end
            end
        end
    end
end

-- Returns seconds remaining on a cooldown entry (0 = ready / no data).
function CD:GetRemainingSeconds(charKey, key)
    local entry = PH.DB:Get("cooldowns." .. charKey .. "." .. key)
    if not entry or not entry.ts then return 0 end
    local elapsed = time() - entry.ts
    return math.max(0, (entry.cdHours * 3600) - elapsed)
end

-- Returns a colour-coded human-readable remaining-time string.
function CD:FormatRemaining(seconds)
    if seconds <= 0 then return "|cff00ff00" .. PH.L["CD_READY"] .. "|r" end
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    if h >= 24 then
        local d  = math.floor(h / 24)
        local rh = h % 24
        return string.format("|cffff8800%dd %dh|r", d, rh)
    elseif h > 0 then
        return string.format("|cffffcc00%dh %02dm|r", h, m)
    else
        return string.format("|cffffff00%dm|r", m)
    end
end

-- Returns all cooldown entries for the current character (used by UI).
function CD:GetAllForCurrentChar()
    local charKey = PH.Identity:GetCharKey()
    local result  = {}
    for _, def in ipairs(self.DATABASE) do
        local remaining = self:GetRemainingSeconds(charKey, def.key)
        table.insert(result, {
            key       = def.key,
            label     = def.label,
            category  = def.category,
            icon      = def.icon,
            cdHours   = def.cdHours,
            remaining = remaining,
            ready     = remaining == 0,
        })
    end
    return result
end

-------------------------------------------------------------------------------
-- Initialization
-- Called from Core/Init.lua after PH.DB and PH.Event are ready.
-------------------------------------------------------------------------------

function CD:Initialize()
    PH.DB:Ensure("cooldowns")

    -- Subscribe through the central event bus — no local eventFrame.
    -- The bus dispatches WoW events as (event, ...), so the first parameter
    -- is the event name; the real WoW payload starts at `unit`.
    PH.Event:On("UNIT_SPELLCAST_SUCCEEDED", function(_, unit, arg2, arg3)
        if unit ~= "player" then return end

        -- TBC Classic: (unit, spellName, rank, lineID, spellID)
        -- WotLK+:      (unit, castGUID, spellID)
        local spellName
        if type(arg2) == "string" and not arg2:match("^Cast") then
            spellName = arg2
        elseif arg3 then
            -- arg3 is spellID on newer API
            local ok, name = pcall(PH.Compat.GetSpellInfo, arg3)
            if ok then spellName = name end
        end

        if spellName then CD:RecordCast(spellName) end
    end, "CooldownTracker")
end
