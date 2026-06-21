-- ProfessionHelper - Localization Init
-- Selects the active locale from the loaded language tables.
-- Load order (TOC): ptBR.lua -> enUS.lua -> esES.lua -> Locales.lua
ProfessionHelper = ProfessionHelper or {}
ProfessionHelper._Locales = ProfessionHelper._Locales or {}

-- Alias esMX to esES
ProfessionHelper._Locales["esMX"] = ProfessionHelper._Locales["esES"]

local function GetSupportedLocale()
    local locale = GetLocale()
    if locale == "ptBR" then
        return "ptBR"
    elseif locale == "esES" or locale == "esMX" then
        return "esES"
    else
        return "enUS"
    end
end

local activeLocale = GetSupportedLocale()
local PH = ProfessionHelper
PH.L          = PH._Locales[activeLocale] or PH._Locales["enUS"]
PH.Locale     = activeLocale
PH.AllLocales = PH._Locales
