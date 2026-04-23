-- Profession Helper - Alt Manager
-- Saves profession data for every character that loads the addon on this account.
-- Provides an API to list all known characters with their profession levels.
--
-- SavedVariables layout:
--   ProfessionHelperDB.characters[realmKey][charName] = {
--     class, level, faction,
--     professions = { { name, skill, maxSkill }, ... }
--   }

ProfessionHelper = ProfessionHelper or {}
local PH = ProfessionHelper

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
}

-------------------------------------------------------------------------------
-- Helpers
-------------------------------------------------------------------------------

function AM:GetRealmKey()
    return GetRealmName() or "Unknown"
end

function AM:GetCharName()
    return UnitName("player") or "Unknown"
end

local function EnsureTable(realmKey, charName)
    if not ProfessionHelperDB.characters then
        ProfessionHelperDB.characters = {}
    end
    if not ProfessionHelperDB.characters[realmKey] then
        ProfessionHelperDB.characters[realmKey] = {}
    end
    if not ProfessionHelperDB.characters[realmKey][charName] then
        ProfessionHelperDB.characters[realmKey][charName] = {}
    end
end

-------------------------------------------------------------------------------
-- Snapshot: save this character's current state
-------------------------------------------------------------------------------

function AM:SaveCurrentChar()
    local realmKey = self:GetRealmKey()
    local charName = self:GetCharName()
    EnsureTable(realmKey, charName)

    local entry = ProfessionHelperDB.characters[realmKey][charName]

    -- Basic info
    local _, classFile = UnitClass("player")
    entry.class   = classFile or "WARRIOR"
    entry.level   = UnitLevel("player") or 0
    entry.faction = UnitFactionGroup("player") or "Neutral"
    entry.lastSeen = time()

    -- Professions via GetProfessions() (returns up to 6 indices: prof1, prof2, arch, fish, cook, firstaid)
    -- In TBC Classic, GetProfessions is not available — use GetSkillLineInfo scanning instead
    entry.professions = {}
    local numSkillLines = GetNumSkillLines()
    for i = 1, numSkillLines do
        local skillName, _, isExclusive, iconID, skillRank, numTempPoints, skillModifier,
              skillMaxRank, isAbandonable, stepCost, rankCost, minLevel, skillCostType =
              GetSkillLineInfo(i)
        if skillName and skillRank and skillMaxRank then
            -- Filter to only trade/secondary skills (isExclusive = false usually means it's a weapon/misc)
            -- In TBC, trade skills show up with skillCostType = 0 or specific types
            local isProfession = (
                skillName == "Alchemy" or skillName == "Blacksmithing" or
                skillName == "Cooking" or skillName == "Enchanting" or
                skillName == "Engineering" or skillName == "First Aid" or
                skillName == "Fishing" or skillName == "Herbalism" or
                skillName == "Jewelcrafting" or skillName == "Leatherworking" or
                skillName == "Mining" or skillName == "Skinning" or
                skillName == "Tailoring"
            )
            if isProfession then
                table.insert(entry.professions, {
                    name     = skillName,
                    skill    = skillRank + (numTempPoints or 0) + (skillModifier or 0),
                    maxSkill = skillMaxRank,
                })
            end
        end
    end
end

-------------------------------------------------------------------------------
-- Query API
-------------------------------------------------------------------------------

-- Returns list of all known characters on current realm, sorted by name
-- Each entry: { name, class, level, faction, lastSeen, professions }
function AM:GetAllCharsOnRealm()
    local realmKey = self:GetRealmKey()
    local db = ProfessionHelperDB.characters
    if not db or not db[realmKey] then return {} end

    local result = {}
    for charName, data in pairs(db[realmKey]) do
        table.insert(result, {
            name       = charName,
            class      = data.class or "WARRIOR",
            level      = data.level or 0,
            faction    = data.faction or "Neutral",
            lastSeen   = data.lastSeen or 0,
            professions = data.professions or {},
        })
    end
    table.sort(result, function(a, b) return a.name < b.name end)
    return result
end

-- Returns professions for a specific character, or nil if not seen
function AM:GetCharProfessions(charName)
    local realmKey = self:GetRealmKey()
    local db = ProfessionHelperDB.characters
    if not db or not db[realmKey] or not db[realmKey][charName] then return nil end
    return db[realmKey][charName].professions or {}
end

-- Formats a lastSeen timestamp as "X days ago" / "today" / "X hours ago"
function AM:FormatLastSeen(ts)
    if not ts or ts == 0 then return "never" end
    local diff = time() - ts
    if diff < 3600 then
        return string.format("%dm ago", math.floor(diff / 60))
    elseif diff < 86400 then
        return string.format("%dh ago", math.floor(diff / 3600))
    else
        return string.format("%dd ago", math.floor(diff / 86400))
    end
end

-------------------------------------------------------------------------------
-- Initialization
-------------------------------------------------------------------------------

function AM:Initialize()
    if not ProfessionHelperDB.characters then
        ProfessionHelperDB.characters = {}
    end
    self:RegisterEvents()
end

function AM:RegisterEvents()
    if self.eventFrame then return end
    self.eventFrame = CreateFrame("Frame")
    self.eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    self.eventFrame:RegisterEvent("SKILL_LINES_CHANGED")
    self.eventFrame:SetScript("OnEvent", function(_, event)
        -- Small delay so skill data is ready after login
        C_Timer.After(2, function() AM:SaveCurrentChar() end)
    end)
end
