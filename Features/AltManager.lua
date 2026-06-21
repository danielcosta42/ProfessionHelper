-- Profession Helper - Alt Manager
-- Saves profession data for every character that loads the addon on this account.
-- Provides a query API to list all known characters with their profession levels.
--
-- SavedVariables layout (managed exclusively through PH.DB):
--   ProfessionHelperDB.characters[realmKey][charName] = {
--     class, level, faction, lastSeen,
--     professions = { { name, skill, maxSkill }, ... }
--   }
--
-- Architecture:
--   - Uses PH.Identity  for all character/realm lookups
--   - Uses PH.DB        for all SavedVariables access
--   - Uses PH.Event     for WoW event subscriptions

local PH = _G.ProfessionHelper

PH.AltManager = {}
local AM = PH.AltManager

-- Class colour map (WoW class colour constants)
AM.CLASS_COLORS = {
    WARRIOR      = "C79C6E",
    PALADIN      = "F58CBA",
    HUNTER       = "ABD473",
    ROGUE        = "FFF569",
    PRIEST       = "FFFFFF",
    SHAMAN       = "0070DE",
    MAGE         = "40C7EB",
    WARLOCK      = "8787ED",
    DRUID        = "FF7D0A",
    DEATHKNIGHT  = "C41F3B",
}

-- Profession name filter (skills tracked by this module)
local TRACKED_PROFESSIONS = {
    ["Alchemy"]        = true, ["Blacksmithing"] = true, ["Cooking"]       = true,
    ["Enchanting"]     = true, ["Engineering"]   = true, ["First Aid"]     = true,
    ["Fishing"]        = true, ["Herbalism"]     = true, ["Inscription"]   = true,
    ["Jewelcrafting"]  = true, ["Leatherworking"]= true, ["Mining"]        = true,
    ["Skinning"]       = true, ["Tailoring"]     = true, ["Archaeology"]   = true,
}

-------------------------------------------------------------------------------
-- Public API — delegates to PH.Identity (no direct UnitName calls)
-------------------------------------------------------------------------------

function AM:GetRealmKey()
    return PH.Identity:GetRealmKey()
end

function AM:GetCharName()
    return PH.Identity:GetCharName()
end

-------------------------------------------------------------------------------
-- Snapshot: save this character's current state into SavedVariables
-------------------------------------------------------------------------------

function AM:SaveCurrentChar()
    local realmKey = PH.Identity:GetRealmKey()
    local charName = PH.Identity:GetCharName()
    local charPath = "characters." .. realmKey .. "." .. charName

    PH.DB:Ensure(charPath)

    local entry = {
        class     = PH.Identity:GetClass(),
        level     = PH.Identity:GetLevel(),
        faction   = PH.Identity:GetFaction(),
        lastSeen  = time(),
        professions = {},
    }

    -- Scan skill lines to collect profession data (works on all supported clients)
    local numSkillLines = GetNumSkillLines()
    for i = 1, numSkillLines do
        local skillName, isHeader, _, skillRank, numTemp, skillMod, skillMaxRank =
            GetSkillLineInfo(i)
        if not isHeader and skillName and TRACKED_PROFESSIONS[skillName] then
            table.insert(entry.professions, {
                name     = skillName,
                skill    = skillRank + (numTemp or 0) + (skillMod or 0),
                maxSkill = skillMaxRank,
            })
        end
    end

    PH.DB:Set(charPath, entry)
    PH.Event:Fire("PH_CHAR_UPDATED", charName)
end

-------------------------------------------------------------------------------
-- Query API
-------------------------------------------------------------------------------

-- Returns all known characters on the current realm, sorted by name.
-- Each entry: { name, class, level, faction, lastSeen, professions }
function AM:GetAllCharsOnRealm()
    local realmKey  = PH.Identity:GetRealmKey()
    local realmData = PH.DB:Get("characters." .. realmKey)
    if not realmData then return {} end

    local result = {}
    for charName, data in pairs(realmData) do
        table.insert(result, {
            name        = charName,
            class       = data.class      or "WARRIOR",
            level       = data.level      or 0,
            faction     = data.faction    or "Neutral",
            lastSeen    = data.lastSeen   or 0,
            professions = data.professions or {},
        })
    end
    table.sort(result, function(a, b) return a.name < b.name end)
    return result
end

-- Returns profession list for a named character, or nil if unknown.
function AM:GetCharProfessions(charName)
    local realmKey = PH.Identity:GetRealmKey()
    local entry    = PH.DB:Get("characters." .. realmKey .. "." .. charName)
    if not entry then return nil end
    return entry.professions or {}
end

-- Human-readable "X ago" string for a Unix timestamp.
function AM:FormatLastSeen(ts)
    if not ts or ts == 0 then return "never" end
    local diff = time() - ts
    if diff < 3600   then return string.format("%dm ago",  math.floor(diff / 60))   end
    if diff < 86400  then return string.format("%dh ago",  math.floor(diff / 3600)) end
    return string.format("%dd ago", math.floor(diff / 86400))
end

-------------------------------------------------------------------------------
-- Initialization
-- Called from Core/Init.lua after PH.DB and PH.Event are ready.
-------------------------------------------------------------------------------

function AM:Initialize()
    PH.DB:Ensure("characters")

    -- Subscribe through the central event bus — no local eventFrame
    PH.Event:On("SKILL_LINES_CHANGED", function()
        -- Small delay to let WoW populate updated skill data
        C_Timer.After(2, function() AM:SaveCurrentChar() end)
    end, "AltManager")
end
