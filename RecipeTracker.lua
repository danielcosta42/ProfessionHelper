-- Profession Helper - Recipe Tracker
-- Scans the trade skill window when opened and records which recipes the
-- player has learned.  Cross-references with the addon's Data/*.lua tables to
-- highlight missing recipes and their sources.
--
-- SavedVariables layout:
--   ProfessionHelperDB.knownRecipes[charKey][profName][recipeName] = true

ProfessionHelper = ProfessionHelper or {}
local PH = ProfessionHelper

PH.RecipeTracker = {}
local RT = PH.RecipeTracker

-- Source labels treated as "easily learnable from trainer"
local TRAINER_SOURCES = { ["Trainer"] = true, ["trainer"] = true }

-------------------------------------------------------------------------------
-- Helpers
-------------------------------------------------------------------------------

function RT:GetCharKey()
    local name  = UnitName("player") or "Unknown"
    local realm = GetRealmName()     or "Unknown"
    return name .. "-" .. realm
end

local function EnsureCharTable(charKey, profName)
    if not ProfessionHelperDB.knownRecipes then
        ProfessionHelperDB.knownRecipes = {}
    end
    if not ProfessionHelperDB.knownRecipes[charKey] then
        ProfessionHelperDB.knownRecipes[charKey] = {}
    end
    if not ProfessionHelperDB.knownRecipes[charKey][profName] then
        ProfessionHelperDB.knownRecipes[charKey][profName] = {}
    end
end

-- Map from the current trade skill window name → our internal profession name
local TRADE_SKILL_NAME_MAP = {
    ["Alchemy"]          = "Alchemy",
    ["Blacksmithing"]    = "Blacksmithing",
    ["Enchanting"]       = "Enchanting",
    ["Engineering"]      = "Engineering",
    ["Jewelcrafting"]    = "Jewelcrafting",
    ["Leatherworking"]   = "Leatherworking",
    ["Tailoring"]        = "Tailoring",
    ["Cooking"]          = "Cooking",
    ["First Aid"]        = "First Aid",
    -- Fishing/Gathering have no trade skill window in TBC
}

-------------------------------------------------------------------------------
-- Core scanning
-------------------------------------------------------------------------------

-- Called when the trade skill window opens.  Reads every non-header entry and
-- records the recipe name in SavedVariables.
function RT:ScanOpenTradeSkill()
    local windowTitle = GetTradeSkillLine()  -- e.g. "Alchemy (375)"
    if not windowTitle then return end

    -- Strip skill level "(375)" suffix
    local profName = windowTitle:match("^(.-)%s*%(") or windowTitle

    local internalName = TRADE_SKILL_NAME_MAP[profName]
    if not internalName then return end  -- profession not in our database

    local charKey = self:GetCharKey()
    EnsureCharTable(charKey, internalName)

    local learned = ProfessionHelperDB.knownRecipes[charKey][internalName]
    local count = 0

    for i = 1, GetNumTradeSkills() do
        local skillName, skillType = GetTradeSkillInfo(i)
        if skillName and skillType ~= "header" then
            learned[skillName] = true
            count = count + 1
        end
    end

    -- Remember last scanned profession for UI convenience
    self.lastScannedProf = internalName
end

-------------------------------------------------------------------------------
-- Query API
-------------------------------------------------------------------------------

-- Returns whether the player has learned a specific recipe
function RT:IsKnown(profName, recipeName)
    local charKey = self:GetCharKey()
    local db = ProfessionHelperDB.knownRecipes
    if not db or not db[charKey] or not db[charKey][profName] then return false end
    return db[charKey][profName][recipeName] == true
end

-- Returns a list of recipes from profName that have NOT been learned yet.
-- Each entry: { name, source, orange, yellow, green, grey }
-- If includeTrainer = false (default), skips trainer recipes (easy to fix anytime).
function RT:GetMissingRecipes(profName, includeTrainer)
    local profData = PH[profName]
    if not profData or not profData.recipes then return {} end

    local charKey = self:GetCharKey()
    local db = ProfessionHelperDB.knownRecipes
    local known = db and db[charKey] and db[charKey][profName] or {}

    local missing = {}
    local seen = {}  -- deduplicate by recipe name

    for _, recipe in ipairs(profData.recipes) do
        local rname = recipe.name
        if rname and not seen[rname] then
            seen[rname] = true
            if not known[rname] then
                local src = recipe.source or "Unknown"
                if includeTrainer or not TRAINER_SOURCES[src] then
                    table.insert(missing, {
                        name   = rname,
                        source = src,
                        orange = recipe.orange,
                        yellow = recipe.yellow,
                        green  = recipe.green,
                        grey   = recipe.grey,
                    })
                end
            end
        end
    end

    -- Sort: non-trainer first, then alphabetically
    table.sort(missing, function(a, b)
        local aT = TRAINER_SOURCES[a.source] and 1 or 0
        local bT = TRAINER_SOURCES[b.source] and 1 or 0
        if aT ~= bT then return aT < bT end
        return a.name < b.name
    end)

    return missing
end

-- Returns total recipe count and how many the player has learned
function RT:GetProgress(profName)
    local profData = PH[profName]
    if not profData or not profData.recipes then return 0, 0 end

    local charKey = self:GetCharKey()
    local db = ProfessionHelperDB.knownRecipes
    local known = db and db[charKey] and db[charKey][profName] or {}

    local total = 0
    local learned = 0
    local seen = {}

    for _, recipe in ipairs(profData.recipes) do
        if recipe.name and not seen[recipe.name] then
            seen[recipe.name] = true
            total = total + 1
            if known[recipe.name] then learned = learned + 1 end
        end
    end

    return learned, total
end

-------------------------------------------------------------------------------
-- Initialization & events
-------------------------------------------------------------------------------

function RT:Initialize()
    if not ProfessionHelperDB.knownRecipes then
        ProfessionHelperDB.knownRecipes = {}
    end
    self:RegisterEvents()
end

function RT:RegisterEvents()
    if self.eventFrame then return end
    self.eventFrame = CreateFrame("Frame")
    self.eventFrame:RegisterEvent("TRADE_SKILL_SHOW")
    self.eventFrame:RegisterEvent("TRADE_SKILL_UPDATE")
    self.eventFrame:SetScript("OnEvent", function(_, event)
        if event == "TRADE_SKILL_SHOW" or event == "TRADE_SKILL_UPDATE" then
            RT:ScanOpenTradeSkill()
        end
    end)
end
