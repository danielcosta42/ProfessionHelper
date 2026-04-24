-- Profession Helper - Cooldown Tracker
-- Tracks TBC Classic profession daily/weekly cooldowns:
--   Alchemy: all Transmute spells share a single 24h slot
--   Tailoring: Shadowcloth / Spellcloth / Primal Mooncloth each have an 84h (3.5 day) slot

ProfessionHelper = ProfessionHelper or {}
local PH = ProfessionHelper

PH.CooldownTracker = {}
local CD = PH.CooldownTracker

-------------------------------------------------------------------------------
-- Cooldown database
-- key        : unique key stored in SavedVariables
-- patterns   : Lua patterns matched against the cast spell name
-- label      : display name
-- category   : profession name (for grouping in UI)
-- cdHours    : cooldown length in hours
-- icon       : Interface path for the icon texture
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

-- Build reverse-lookup: pattern → def (avoids re-scanning on every spell event)
local patternToDef = {}
for _, def in ipairs(CD.DATABASE) do
    for _, pat in ipairs(def.patterns) do
        patternToDef[pat] = def
    end
end

local function FindDef(spellName)
    for pat, def in pairs(patternToDef) do
        if string.match(spellName, pat) then return def end
    end
    return nil
end

-------------------------------------------------------------------------------
-- Helpers
-------------------------------------------------------------------------------

function CD:GetCharKey()
    local name  = UnitName("player") or "Unknown"
    local realm = GetRealmName()     or "Unknown"
    return name .. "-" .. realm
end

-- Ensure per-character cooldown table exists
local function EnsureCharTable(charKey)
    if not ProfessionHelperDB.cooldowns[charKey] then
        ProfessionHelperDB.cooldowns[charKey] = {}
    end
end

-------------------------------------------------------------------------------
-- Core API
-------------------------------------------------------------------------------

function CD:Initialize()
    if not ProfessionHelperDB.cooldowns then
        ProfessionHelperDB.cooldowns = {}
    end
    self:RegisterEvents()
end

-- Called when a spell cast succeeds for "player"
function CD:RecordCast(spellName)
    local def = FindDef(spellName)
    if not def then return end

    local charKey = self:GetCharKey()
    EnsureCharTable(charKey)

    ProfessionHelperDB.cooldowns[charKey][def.key] = {
        spellName = spellName,
        ts        = time(),
        cdHours   = def.cdHours,
    }

    PH:Print(string.format("|cffffd700[CD]|r %s → ready in %s", def.label, self:FormatRemaining(def.cdHours * 3600)))
end

-- Returns seconds remaining on a cooldown (0 = ready / no data)
function CD:GetRemainingSeconds(charKey, key)
    local db = ProfessionHelperDB.cooldowns
    if not db or not db[charKey] or not db[charKey][key] then return 0 end
    local entry = db[charKey][key]
    if not entry.ts then return 0 end
    local elapsed = time() - entry.ts
    return math.max(0, (entry.cdHours * 3600) - elapsed)
end

-- Returns formatted remaining string (coloured)
function CD:FormatRemaining(seconds)
    if seconds <= 0 then return "|cff00ff00Ready|r" end
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

-- Returns all cooldown entries for the current character
function CD:GetAllForCurrentChar()
    local charKey = self:GetCharKey()
    local result = {}
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
-- Event handling
-------------------------------------------------------------------------------

function CD:RegisterEvents()
    if self.eventFrame then return end
    self.eventFrame = CreateFrame("Frame")
    self.eventFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    self.eventFrame:SetScript("OnEvent", function(_, event, ...)
        if event ~= "UNIT_SPELLCAST_SUCCEEDED" then return end
        local unit = ...
        if unit ~= "player" then return end

        -- TBC Classic: older builds send (unit, spellName, rank, lineID, spellID)
        --              newer builds send  (unit, castGUID, spellID)
        local arg2 = select(2, ...)
        local spellName
        if type(arg2) == "string" then
            spellName = arg2
        else
            local spellID = select(3, ...)
            if spellID then spellName = GetSpellInfo(spellID) end
        end

        if spellName then CD:RecordCast(spellName) end
    end)
end
