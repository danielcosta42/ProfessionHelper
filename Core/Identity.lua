-- ProfessionHelper - Character Identity Service (PH.Identity)
-- Single source of truth for all character/realm lookups.
-- Modules MUST use PH.Identity:* — never call UnitName/GetRealmName/UnitClass
-- directly from feature or UI layers.

local PH = _G.ProfessionHelper
local ID = PH.Identity

-- Cached identity values (populated on PLAYER_LOGIN)
local _charName, _realmKey, _charKey, _class, _faction, _level

-------------------------------------------------------------------------------
-- Lifecycle
-------------------------------------------------------------------------------

function ID:Initialize()
    _charName = UnitName("player")          or "Unknown"
    _realmKey = GetRealmName()              or "Unknown"
    _charKey  = _charName .. "-" .. _realmKey

    local _, classFile = UnitClass("player")
    _class   = classFile                    or "WARRIOR"
    _faction = UnitFactionGroup("player")   or "Neutral"
    _level   = UnitLevel("player")          or 0

    -- Subscribe to level-up event to keep _level current
    PH.Event:On("PLAYER_LEVEL_UP", function(_, newLevel)
        _level = newLevel or UnitLevel("player") or _level
    end, "Identity")
end

-------------------------------------------------------------------------------
-- Public API
-------------------------------------------------------------------------------

-- Returns "CharName-RealmName" — the canonical key used in SavedVariables
function ID:GetCharKey()
    return _charKey or "Unknown-Unknown"
end

function ID:GetCharName()
    return _charName or "Unknown"
end

function ID:GetRealmKey()
    return _realmKey or "Unknown"
end

-- Returns "Alliance" or "Horde" (or "Neutral")
function ID:GetFaction()
    return _faction or "Neutral"
end

-- Returns the class file name: "WARRIOR", "MAGE", etc.
function ID:GetClass()
    return _class or "WARRIOR"
end

-- Returns current character level (kept up to date via PLAYER_LEVEL_UP)
function ID:GetLevel()
    return _level or 0
end
