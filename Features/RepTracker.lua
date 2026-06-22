-- Profession Helper - Reputation Tracker
-- Provides inline rep-gate status for recipes that require a specific faction standing.
-- Called from CreateFocusedCard() to inject a standing badge below the source line.

local PH = _G.ProfessionHelper

PH.RepTracker = {}
local RT = PH.RepTracker

-- Faction name → WoW faction ID (used with GetFactionInfoByID)
-- Covers all TBC recipe-gating factions.
local FACTION_IDS = {
    -- Shattrath factions
    ["The Aldor"]                  = 932,
    ["The Scryers"]                = 934,
    ["Lower City"]                 = 1033,
    ["The Sha'tar"]                = 935,
    -- TBC dungeon / raid factions
    ["Cenarion Expedition"]        = 942,
    ["Honor Hold"]                 = 946,
    ["Thrallmar"]                  = 947,
    ["Keepers of Time"]            = 989,
    ["The Violet Eye"]             = 967,
    ["The Scale of the Sands"]     = 1119,
    ["The Consortium"]             = 933,
    ["Ashtongue Deathsworn"]       = 1120,
    -- World / rep factions
    ["Sporeggar"]                  = 970,
    ["Ogri'la"]                    = 1038,
    ["Sha'tari Skyguard"]          = 1031,
    ["Kurenai"]                    = 978,
    ["The Mag'har"]                = 941,
    ["Netherwing"]                 = 1015,
    ["Cenarion Circle"]            = 609,
    ["Argent Dawn"]                = 529,
    -- Classic-era factions still relevant for TBC recipes
    ["Thorium Brotherhood"]        = 59,
    ["Timbermaw Hold"]             = 576,
    ["Zandalar Tribe"]             = 270,
    ["Hydraxian Waterlords"]       = 749,
    ["Shen'dralar"]                = 809,
}

-- Standing level names → numeric rank (matches WoW's internal standing 1-8)
local STANDING_RANK = {
    ["Hated"]      = 1,
    ["Hostile"]    = 2,
    ["Unfriendly"] = 3,
    ["Neutral"]    = 4,
    ["Friendly"]   = 5,
    ["Honored"]    = 6,
    ["Revered"]    = 7,
    ["Exalted"]    = 8,
}

-- Cache: faction name → current standing rank (built at PLAYER_LOGIN, refreshed on demand)
RT._index = {}

function RT:BuildIndex()
    self._index = {}
    for name, fid in pairs(FACTION_IDS) do
        local _, _, standing = GetFactionInfoByID(fid)
        if standing then
            self._index[name] = standing
        end
    end
end

-- Returns the player's current standing rank (1-8) for a faction name, or nil if unknown.
function RT:GetFactionStanding(factionName)
    if not factionName then return nil end
    local rank = self._index[factionName]
    if rank then return rank end
    -- Lazy-load if BuildIndex hasn't run yet
    local fid = FACTION_IDS[factionName]
    if not fid then return nil end
    local _, _, standing = GetFactionInfoByID(fid)
    if standing then
        self._index[factionName] = standing
        return standing
    end
    return nil
end

-- Parses a source string for reputation requirements.
-- Returns: factionName (string), requiredRank (number), or nil, nil if none found.
-- Recognises patterns like:
--   "Reputation: Cenarion Expedition (Honored)"
--   "Vendor: ... (The Aldor, Revered)"
--   "... Requires: The Consortium - Revered"
local REP_PATTERNS = {
    -- "Reputation: FactionName (Standing)"
    "Reputation:%s*(.-)%s*%(([^%)]+)%)",
    -- "Requires?:?%s*FactionName%s*[%-–]%s*Standing"
    "[Rr]equires?:?%s*(.-)%s*[%-%-]%s*([%a]+)%s*$",
    -- Vendor line with trailing "(FactionName, Standing)"
    "%(([^,%)]+),%s*([%a]+)%)%s*$",
}

function RT:ParseRepRequirement(sourceString)
    if not sourceString or sourceString == "" then return nil, nil end

    for _, pat in ipairs(REP_PATTERNS) do
        local faction, standing = sourceString:match(pat)
        if faction and standing then
            faction  = faction:match("^%s*(.-)%s*$")
            standing = standing:match("^%s*(.-)%s*$")
            local reqRank = STANDING_RANK[standing]
            if reqRank and FACTION_IDS[faction] then
                return faction, reqRank
            end
        end
    end
    return nil, nil
end

-- Converts a numeric standing rank to a localised display name.
-- WoW's GetText("FACTION_STANDING_LABEL" .. rank) works client-side but isn't available here.
local STANDING_NAMES = { "Hated", "Hostile", "Unfriendly", "Neutral", "Friendly", "Honored", "Revered", "Exalted" }
function RT:StandingName(rank)
    return STANDING_NAMES[rank] or "?"
end
