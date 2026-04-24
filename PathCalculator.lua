-- Profession Helper - Optimized Path Calculator
-- Builds the cheapest crafting path considering intermediate items and TSM prices

ProfessionHelper = ProfessionHelper or {}
local PH = ProfessionHelper

PH.PathCalculator = {}

-- Skill gain probability by color
-- Orange = 100%, Yellow ~75%, Green ~37%, Grey = 0%
local GAIN_CHANCE = {
    orange = 1.00,
    yellow = 0.75,
    green  = 0.37,
    grey   = 0.00,
}

-- Determine the color bracket of a recipe at a given skill
local function GetRecipeColor(skill, recipe)
    if skill < (recipe.orange or 0) then return "unavailable" end
    if skill < (recipe.yellow or 999) then return "orange" end
    if skill < (recipe.green or 999)  then return "yellow" end
    if skill < (recipe.grey or 999)   then return "grey_still" end
    return "grey"
end

-- Expected crafts needed to gain 1 skill point at given color
local function ExpectedCraftsPerPoint(color)
    local chance = GAIN_CHANCE[color]
    if not chance or chance <= 0 then return 999999 end
    return 1.0 / chance
end

-------------------------------------------------------------------------------
-- Build a map of which recipes produce which items (for intermediate tracking)
-------------------------------------------------------------------------------
local function BuildProductionMap(recipes)
    local map = {} -- map[itemName] = recipe
    for _, recipe in ipairs(recipes) do
        if recipe.creates and recipe.creates >= 1 and recipe.name then
            map[recipe.name] = recipe
        end
    end
    return map
end

-------------------------------------------------------------------------------
-- Check if an item is used as material in later leveling steps
-------------------------------------------------------------------------------
local function FindIntermediateUsage(levelingGuide, recipeName, startIdx)
    local usage = {}
    for i = startIdx + 1, #levelingGuide do
        local step = levelingGuide[i]
        if step.materials then
            for _, mat in ipairs(step.materials) do
                if mat.name == recipeName then
                    table.insert(usage, {
                        stepIndex = i,
                        recipe = step.recipe,
                        count = mat.count,
                        range = step.range,
                    })
                end
            end
        end
    end
    return usage
end

-------------------------------------------------------------------------------
-- Core: Calculate the optimal leveling path
-- Returns a list of steps with all info needed by the UI
-------------------------------------------------------------------------------
function PH.PathCalculator:Calculate(profData, startSkill, targetSkill, comboSkills)
    if not profData or not profData.levelingGuide then return nil end
    if startSkill >= targetSkill and not comboSkills then return nil end

    -- For combo professions, comboSkills = { Fishing = 120, Cooking = 50 }
    local isCombo = (comboSkills ~= nil)

    local steps = {}
    local shoppingList = {}   -- raw materials to BUY (not intermediates produced in-path)
    local intermediateBank = {} -- items produced that are used later: name -> count available
    local totalCost = 0
    local hasTSM = PH.TSM:IsAvailable()

    -- Pre-scan: find which crafted items in the guide are used as materials later
    local usedAsIntermediate = {}
    for i, guide in ipairs(profData.levelingGuide) do
        if guide.materials then
            for _, mat in ipairs(guide.materials) do
                -- Check if any earlier step crafts this item
                for j = 1, i - 1 do
                    if profData.levelingGuide[j].recipe == mat.name then
                        usedAsIntermediate[mat.name] = true
                    end
                end
            end
        end
    end

    for idx, guide in ipairs(profData.levelingGuide) do
        local guideStart, guideEnd = guide.range[1], guide.range[2]

        -- For combo professions, use the skill level matching this step's skill
        local stepStartSkill = startSkill
        if isCombo and guide.skill and comboSkills[guide.skill] then
            stepStartSkill = comboSkills[guide.skill]
        end

        -- Skip steps entirely below current skill
        if guideEnd <= stepStartSkill then
            -- Still, if this step produces intermediates used later, we need to note
            -- they won't be produced -> we'll have to buy them
        end

        if guideEnd > stepStartSkill and guideStart < targetSkill then
            local effectiveStart = math.max(guideStart, stepStartSkill)
            local effectiveEnd   = math.min(guideEnd, targetSkill)

            -- How many crafts do we need?
            local rangeSize = guideEnd - guideStart
            local neededSize = effectiveEnd - effectiveStart
            local craftRatio = neededSize / rangeSize
            local craftsNeeded = math.ceil((guide.count or 0) * craftRatio)
            if craftsNeeded < 1 then craftsNeeded = 1 end

            -- Check if the output of this recipe is used later (intermediate)
            local isIntermediate = usedAsIntermediate[guide.recipe] or false
            local laterUsage = FindIntermediateUsage(profData.levelingGuide, guide.recipe, idx)

            -- Track produced intermediates
            local produced = craftsNeeded
            if guide.recipe and isIntermediate then
                intermediateBank[guide.recipe] = (intermediateBank[guide.recipe] or 0) + produced
            end

            -- Calculate materials needed for this step
            local stepMaterials = {}
            local stepCost = 0
            if guide.materials then
                for _, mat in ipairs(guide.materials) do
                    local needed = math.ceil(mat.count * craftRatio)
                    if needed < 1 then needed = 1 end

                    -- Subtract from intermediate bank if available
                    local fromBank = 0
                    if intermediateBank[mat.name] and intermediateBank[mat.name] > 0 then
                        fromBank = math.min(intermediateBank[mat.name], needed)
                        intermediateBank[mat.name] = intermediateBank[mat.name] - fromBank
                    end

                    local toBuy = needed - fromBank

                    table.insert(stepMaterials, {
                        name = mat.name,
                        totalNeeded = needed,
                        originalNeeded = mat.count,
                        fromBank = fromBank,
                        toBuy = toBuy,
                    })

                    -- Add to global shopping list (only if we need to buy)
                    if toBuy > 0 then
                        shoppingList[mat.name] = (shoppingList[mat.name] or 0) + toBuy
                    end

                    -- Cost: GetItemPrice handles addon → cache → vendorPrice chain
                    if toBuy > 0 then
                        local unitPrice = PH.TSM:GetItemPrice(mat.name) or 0
                        stepCost = stepCost + (unitPrice * toBuy)
                    end
                end
            end

            totalCost = totalCost + stepCost

            -- Get recipe color info for display
            local recipeData = nil
            if profData.recipes then
                for _, r in ipairs(profData.recipes) do
                    if r.name == guide.recipe then
                        recipeData = r
                        break
                    end
                end
            end

            -- Build step info
            table.insert(steps, {
                index = #steps + 1,
                skillRange = {effectiveStart, effectiveEnd},
                originalRange = {guideStart, guideEnd},
                recipe = guide.recipe or guide.tip or "Unknown",
                crafts = craftsNeeded,
                originalCrafts = guide.count or 0,
                materials = stepMaterials,
                cost = stepCost,
                isIntermediate = isIntermediate,
                laterUsage = laterUsage,
                recipeData = recipeData,
                tier = PH:GetSkillTier(effectiveStart),
                source = guide.source,
                tip = guide.tip,
                skill = guide.skill,  -- for combo: "Fishing" or "Cooking"
                -- For progress tracking
                isCurrent = (effectiveStart <= stepStartSkill and effectiveEnd > stepStartSkill),
                isComplete = (effectiveEnd <= stepStartSkill),
            })
        end
    end

    -- Build final shopping list as sorted array
    local sortedShopping = {}
    for name, count in pairs(shoppingList) do
        local matData = PH.Materials and PH.Materials[name]
        local isVendor = matData and matData.vendor or false
        -- GetItemPrice handles the full chain: addon → cache → vendorPrice
        local unitPrice = PH.TSM:GetItemPrice(name) or 0

        -- Discount items already in bags/bank.
        -- GetItemCount includes bank only when bank frame is open.
        -- BagScanner supplements with the last-known bank scan (persists across sessions).
        local inInventory = 0
        if matData and matData.id then
            inInventory = GetItemCount(matData.id, true) or 0
        end
        if PH.BagScanner then
            local scanned = PH.BagScanner:GetCount(name)
            if scanned > inInventory then inInventory = scanned end
        end
        local toBuy = math.max(0, count - inInventory)

        table.insert(sortedShopping, {
            name = name,
            count = toBuy,
            needed = count,
            inInventory = math.min(inInventory, count),
            isVendor = isVendor,
            unitPrice = unitPrice,
            totalPrice = unitPrice * toBuy,
            icon = matData and matData.icon or nil,
            id = matData and matData.id or nil,
        })
    end

    -- Sort: vendor items last, then by total price descending
    table.sort(sortedShopping, function(a, b)
        if a.isVendor ~= b.isVendor then
            return not a.isVendor -- non-vendor first
        end
        return a.totalPrice > b.totalPrice
    end)

    -- Recalculate total cost after inventory discount
    local adjustedCost = 0
    for _, item in ipairs(sortedShopping) do
        adjustedCost = adjustedCost + item.totalPrice
    end

    return {
        steps = steps,
        shoppingList = sortedShopping,
        totalCost = adjustedCost,
        hasPricing = adjustedCost > 0,
        startSkill = startSkill,
        targetSkill = targetSkill,
        professionName = profData.name,
    }
end
