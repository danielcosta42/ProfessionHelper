-- Profession Helper - Recipe Tracker
-- Scans the trade skill window when opened and records which recipes the
-- player has learned.  Cross-references with the addon's Data/*.lua tables to
-- highlight missing recipes and their sources.
--
-- SavedVariables layout (managed exclusively through PH.DB):
--   ProfessionHelperDB.knownRecipes[charKey][profName][recipeName] = true
--
-- Architecture:
--   - Uses PH.Identity for character key lookups
--   - Uses PH.DB      for all SavedVariables access
--   - Uses PH.Event   for TRADE_SKILL_SHOW/UPDATE subscription
--   - Uses PH.Compat  for GetTradeSkillLine (cross-version)

local PH = _G.ProfessionHelper

PH.RecipeTracker = {}
local RT = PH.RecipeTracker

-- Source labels treated as "trainer" (low-priority to show in UI)
local TRAINER_SOURCES = { ["Trainer"] = true, ["trainer"] = true }

-- Map from WoW trade skill window title → internal profession name
local TRADE_SKILL_NAME_MAP = {
    ["Alchemy"]        = "Alchemy",
    ["Blacksmithing"]  = "Blacksmithing",
    ["Enchanting"]     = "Enchanting",
    ["Engineering"]    = "Engineering",
    ["Jewelcrafting"]  = "Jewelcrafting",
    ["Leatherworking"] = "Leatherworking",
    ["Tailoring"]      = "Tailoring",
    ["Cooking"]        = "Cooking",
    ["First Aid"]      = "First Aid",
    -- Inscription (WotLK+)
    ["Inscription"]    = "Inscription",
}

-------------------------------------------------------------------------------
-- Core scanning
-- Called when the trade skill window opens.  Reads every non-header entry.
-------------------------------------------------------------------------------

function RT:ScanOpenTradeSkill()
    local windowTitle = PH.Compat.GetTradeSkillLine()
    if not windowTitle then return end

    -- Strip "(375)" skill-level suffix when present
    local profName     = windowTitle:match("^(.-)%s*%(") or windowTitle
    local internalName = TRADE_SKILL_NAME_MAP[profName]
    if not internalName then return end

    local charKey   = PH.Identity:GetCharKey()
    local basePath  = "knownRecipes." .. charKey .. "." .. internalName
    PH.DB:Ensure(basePath)

    local count = 0
    for i = 1, GetNumTradeSkills() do
        local skillName, skillType = GetTradeSkillInfo(i)
        if skillName and skillType ~= "header" then
            PH.DB:Set(basePath .. "." .. skillName, true)
            -- Capture the crafted item's id (for marketplace icons + exact matching).
            local link = GetTradeSkillItemLink and GetTradeSkillItemLink(i)
            local itemID = link and tonumber(link:match("item:(%d+)"))
            if itemID then
                PH.DB:Set("craftOutputs." .. skillName, itemID)
            end
            count = count + 1
        end
    end

    self.lastScannedProf = internalName
    PH.Event:Fire("PH_RECIPE_SCANNED", internalName)
end

-------------------------------------------------------------------------------
-- Query API
-------------------------------------------------------------------------------

-- Returns true if the current character has learned recipeName in profName.
function RT:IsKnown(profName, recipeName)
    local charKey = PH.Identity:GetCharKey()
    return PH.DB:Get("knownRecipes." .. charKey .. "." .. profName .. "." .. recipeName) == true
end

-- Returns a list of unlearned recipes for profName.
-- includeTrainer = true  → also include trainer-source recipes
-- Each result entry: { name, source, orange, yellow, green, grey }
function RT:GetMissingRecipes(profName, includeTrainer)
    local profData = PH:GetProfessionData(profName)
    if not profData or not profData.recipes then return {} end

    local charKey   = PH.Identity:GetCharKey()
    local known     = PH.DB:Get("knownRecipes." .. charKey .. "." .. profName) or {}
    local missing   = {}
    local seen      = {}

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

    -- Non-trainer entries first, then alphabetical
    table.sort(missing, function(a, b)
        local aT = TRAINER_SOURCES[a.source] and 1 or 0
        local bT = TRAINER_SOURCES[b.source] and 1 or 0
        if aT ~= bT then return aT < bT end
        return a.name < b.name
    end)

    return missing
end

-- Returns (learned, total) recipe counts for profName.
function RT:GetProgress(profName)
    local profData = PH:GetProfessionData(profName)
    if not profData or not profData.recipes then return 0, 0 end

    local charKey  = PH.Identity:GetCharKey()
    local known    = PH.DB:Get("knownRecipes." .. charKey .. "." .. profName) or {}
    local total, learned, seen = 0, 0, {}

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
-- Initialization
-- Called from Core/Init.lua after PH.DB and PH.Event are ready.
-------------------------------------------------------------------------------

function RT:Initialize()
    PH.DB:Ensure("knownRecipes")

    -- Subscribe through the central event bus — no local eventFrame
    PH.Event:On("TRADE_SKILL_SHOW",   function() RT:ScanOpenTradeSkill() end, "RecipeTracker")
    PH.Event:On("TRADE_SKILL_UPDATE", function() RT:ScanOpenTradeSkill() end, "RecipeTracker")
end
