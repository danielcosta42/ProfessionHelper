-- ProfessionHelper - Configuration Service (PH.Config)
-- Centralised settings access with declared defaults.
-- Modules MUST use PH.Config:Get / PH.Config:Set.
-- Never read ProfessionHelperDB settings keys directly from feature/UI code.

local PH     = _G.ProfessionHelper
local Config = PH.Config

-------------------------------------------------------------------------------
-- Defaults (authoritative list of all settings)
-------------------------------------------------------------------------------

Config.DEFAULTS = {
    minimapButtonPosition = 45,
    windowScale           = 1.0,
    selectedProfession    = nil,
    showFarmingTips       = true,
    debug                 = false,
    nodePins              = false, -- live gather-node pins on the world map (/ph pins)
}

-------------------------------------------------------------------------------
-- Public API
-------------------------------------------------------------------------------

-- Read a setting.  Falls back to the declared default if not set.
function Config:Get(key)
    -- PH.DB may not exist yet during very early startup; guard defensively
    if not PH.DB then
        return self.DEFAULTS[key]
    end
    local val = PH.DB:Get(key)
    if val == nil then
        return self.DEFAULTS[key]
    end
    return val
end

-- Write a setting (persisted in SavedVariables).
function Config:Set(key, value)
    PH.DB:Set(key, value)
end
