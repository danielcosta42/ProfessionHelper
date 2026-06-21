-- ProfessionHelper - Storage Service (PH.DB)
-- Centralised read/write interface for ProfessionHelperDB (SavedVariables).
-- Modules MUST use PH.DB:Get / PH.DB:Set / PH.DB:Ensure.
-- Never access ProfessionHelperDB directly from feature or UI layers.

local PH = _G.ProfessionHelper
local DB = PH.DB

-------------------------------------------------------------------------------
-- Schema version
-- Bump this number whenever the SavedVariables structure changes in a
-- breaking way. Add the corresponding migration function below.
-------------------------------------------------------------------------------

DB.SCHEMA_VERSION = 1

-- Root-level defaults (keys with primitive defaults only; sub-tables handled
-- explicitly in Initialize() to avoid shallow-copy issues)
local ROOT_DEFAULTS = {
    _schemaVersion        = 1,
    minimapButtonPosition = 45,
    windowScale           = 1.0,
    selectedProfession    = nil,
    autoTrackMaterials    = true,
    showFarmingTips       = true,
    debug                 = false,
}

-------------------------------------------------------------------------------
-- Lifecycle
-------------------------------------------------------------------------------

function DB:Initialize()
    if not ProfessionHelperDB then
        ProfessionHelperDB = {}
    end

    -- Apply primitive defaults (non-table values only)
    for k, v in pairs(ROOT_DEFAULTS) do
        if ProfessionHelperDB[k] == nil then
            ProfessionHelperDB[k] = v
        end
    end

    -- Ensure sub-table roots exist
    if not ProfessionHelperDB.ahPriceCache  then ProfessionHelperDB.ahPriceCache  = {} end
    if not ProfessionHelperDB.inventory     then ProfessionHelperDB.inventory     = {} end
    if not ProfessionHelperDB.cooldowns     then ProfessionHelperDB.cooldowns     = {} end
    if not ProfessionHelperDB.knownRecipes  then ProfessionHelperDB.knownRecipes  = {} end
    if not ProfessionHelperDB.characters    then ProfessionHelperDB.characters    = {} end

    self:Migrate()
end

-------------------------------------------------------------------------------
-- Schema migrations
-------------------------------------------------------------------------------

-- Registry: version number → migration function
DB._migrations = {}

-- v1: initial schema — nothing to migrate
DB._migrations[1] = function() end

function DB:Migrate()
    local current = ProfessionHelperDB._schemaVersion or 0
    local target  = self.SCHEMA_VERSION
    if current >= target then return end

    for v = current + 1, target do
        local fn = self._migrations[v]
        if fn then
            local ok, err = pcall(fn)
            if not ok then
                PH.Logger.Error("DB migration v" .. v .. " failed: " .. tostring(err))
            end
        end
        ProfessionHelperDB._schemaVersion = v
    end
end

-------------------------------------------------------------------------------
-- Core API
-------------------------------------------------------------------------------

-- Get a value by dot-path notation.
-- Example: PH.DB:Get("cooldowns.CharName-Realm.transmute")
-- Returns nil safely if any segment along the path is missing.
function DB:Get(path)
    local node = ProfessionHelperDB
    for segment in path:gmatch("[^%.]+") do
        if type(node) ~= "table" then return nil end
        node = node[segment]
    end
    return node
end

-- Set a value by dot-path, creating intermediate tables as needed.
-- Example: PH.DB:Set("cooldowns.CharName-Realm.transmute", entry)
function DB:Set(path, value)
    local node     = ProfessionHelperDB
    local segments = {}
    for s in path:gmatch("[^%.]+") do
        table.insert(segments, s)
    end
    for i = 1, #segments - 1 do
        local s = segments[i]
        if type(node[s]) ~= "table" then
            node[s] = {}
        end
        node = node[s]
    end
    node[segments[#segments]] = value
end

-- Ensure a table exists at path; does not overwrite existing data.
-- Example: PH.DB:Ensure("inventory.CharName-Realm")
function DB:Ensure(path)
    local node = ProfessionHelperDB
    for segment in path:gmatch("[^%.]+") do
        if type(node[segment]) ~= "table" then
            node[segment] = {}
        end
        node = node[segment]
    end
end
