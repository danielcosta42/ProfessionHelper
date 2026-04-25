-- Profession Helper - Core Logic
-- Main addon controller and utility functions
--
-- Copyright (c) 2026 Chehul @ DreamScyther-US
-- MIT License - Free for personal use
-- GitHub: https://github.com/danielcosta42

ProfessionHelper = ProfessionHelper or {}
local PH = ProfessionHelper

-- Addon metadata
PH.version = "1.14.0"
PH.author = "Chehul @ DreamScyther-US"
PH.github = "https://github.com/danielcosta42"
PH.license = "MIT License - Free for personal use"

-- Configuration defaults
PH.defaults = {
    minimapButtonPosition = 45,
    windowScale = 1.0,
    selectedProfession = nil,
    autoTrackMaterials = true,
    showFarmingTips = true,
}

-- Initialize saved variables
function PH:InitializeDB()
    if not ProfessionHelperDB then
        ProfessionHelperDB = {}
    end
    for key, value in pairs(self.defaults) do
        if ProfessionHelperDB[key] == nil then
            ProfessionHelperDB[key] = value
        end
    end
    -- Sub-tables that cannot be initialised via defaults loop
    if not ProfessionHelperDB.ahPriceCache then
        ProfessionHelperDB.ahPriceCache = {}
    end
    if not ProfessionHelperDB.inventory then
        ProfessionHelperDB.inventory = {}
    end
    if not ProfessionHelperDB.cooldowns then
        ProfessionHelperDB.cooldowns = {}
    end
    if not ProfessionHelperDB.knownRecipes then
        ProfessionHelperDB.knownRecipes = {}
    end
    if not ProfessionHelperDB.characters then
        ProfessionHelperDB.characters = {}
    end
end

-- All profession data references
PH.Professions = {
    -- Primary Crafting
    { name = "Alchemy", data = "Alchemy", icon = "Trade_Alchemy", type = "crafting" },
    { name = "Blacksmithing", data = "Blacksmithing", icon = "Trade_BlackSmithing", type = "crafting" },
    { name = "Enchanting", data = "Enchanting", icon = "Trade_Engraving", type = "crafting" },
    { name = "Engineering", data = "Engineering", icon = "Trade_Engineering", type = "crafting" },
    { name = "Jewelcrafting", data = "Jewelcrafting", icon = "INV_Misc_Gem_02", type = "crafting" },
    { name = "Leatherworking", data = "Leatherworking", icon = "Trade_LeatherWorking", type = "crafting" },
    { name = "Tailoring", data = "Tailoring", icon = "Trade_Tailoring", type = "crafting" },
    
    -- Primary Gathering
    { name = "Herbalism", data = "Herbalism", icon = "Trade_Herbalism", type = "gathering" },
    { name = "Mining", data = "Mining", icon = "Trade_Mining", type = "gathering" },
    { name = "Skinning", data = "Skinning", icon = "INV_Misc_Pelt_Wolf_01", type = "gathering" },
    
    -- Secondary
    { name = "Cooking", data = "Cooking", icon = "INV_Misc_Food_15", type = "secondary" },
    { name = "First Aid", data = "FirstAid", icon = "Spell_Holy_SealOfSacrifice", type = "secondary" },
    { name = "Fishing", data = "Fishing", icon = "Trade_Fishing", type = "secondary" },

    -- Combo guides
    { name = "Herbalism & Alchemy", data = "HerbalismAlchemy", icon = "Trade_Herbalism", type = "combo" },
    { name = "Skinning & Leatherworking", data = "SkinningLeatherworking", icon = "INV_Misc_Pelt_Wolf_01", type = "combo" },
    { name = "Fishing & Cooking", data = "FishingCooking", icon = "Trade_Fishing", type = "combo" },
}

-- Get profession data by name
function PH:GetProfessionData(professionName)
    for _, prof in ipairs(self.Professions) do
        if prof.name == professionName then
            return self[prof.data]
        end
    end
    return nil
end

-- Get localized profession name
function PH:GetLocalizedProfessionName(professionName)
    return self.L[professionName] or professionName
end

-- Get player's current profession skill level
function PH:GetPlayerProfessionLevel(professionName)
    -- TBC Classic API for profession info
    local numSkills = GetNumSkillLines()
    for i = 1, numSkills do
        local skillName, isHeader, isExpanded, skillRank, numTempPoints, skillModifier, skillMaxRank = GetSkillLineInfo(i)
        if not isHeader and skillName == professionName then
            return skillRank, skillMaxRank
        end
    end
    return 0, 0
end

-- Calculate materials needed for a skill range
function PH:CalculateMaterialsForRange(professionData, startSkill, targetSkill)
    if not professionData or not professionData.levelingGuide then
        return nil
    end
    
    local totalMaterials = {}
    local recipes = {}
    
    for _, guide in ipairs(professionData.levelingGuide) do
        local guideStart, guideEnd = guide.range[1], guide.range[2]
        
        -- Check if this guide range overlaps with our target range
        if guideEnd > startSkill and guideStart < targetSkill then
            -- Calculate how many crafts we need from this range
            local effectiveStart = math.max(guideStart, startSkill)
            local effectiveEnd = math.min(guideEnd, targetSkill)
            
            -- Rough estimate: assume we need proportional crafts
            local rangeSize = guideEnd - guideStart
            local neededSize = effectiveEnd - effectiveStart
            local craftRatio = neededSize / rangeSize
            local craftsNeeded = math.ceil((guide.count or 0) * craftRatio)
            
            -- Add recipe to list
            table.insert(recipes, {
                name = guide.recipe or guide.tip,
                count = craftsNeeded,
                skillRange = {effectiveStart, effectiveEnd},
            })
            
            -- Sum up materials
            if guide.materials then
                for _, mat in ipairs(guide.materials) do
                    local adjustedCount = math.ceil(mat.count * craftRatio)
                    if totalMaterials[mat.name] then
                        totalMaterials[mat.name] = totalMaterials[mat.name] + adjustedCount
                    else
                        totalMaterials[mat.name] = adjustedCount
                    end
                end
            end
        end
    end
    
    return totalMaterials, recipes
end

-- Get farming locations for gathering profession at current skill
function PH:GetFarmingLocations(professionData, currentSkill)
    if not professionData or not professionData.farmingLocations then
        return nil
    end
    
    local relevantLocations = {}
    
    for _, locationData in ipairs(professionData.farmingLocations) do
        local rangeStart, rangeEnd = locationData.skillRange[1], locationData.skillRange[2]
        
        -- Show current and next tier locations
        if currentSkill >= rangeStart - 20 and currentSkill <= rangeEnd + 50 then
            table.insert(relevantLocations, locationData)
        end
    end
    
    return relevantLocations
end

-- Get skill tier name
function PH:GetSkillTier(skill)
    if skill < 75 then
        return self.L["Apprentice"], 75
    elseif skill < 150 then
        return self.L["Journeyman"], 150
    elseif skill < 225 then
        return self.L["Expert"], 225
    elseif skill < 300 then
        return self.L["Artisan"], 300
    else
        return self.L["Master"], 375
    end
end

-- Get color for skill difficulty
function PH:GetSkillColor(currentSkill, orange, yellow, green, grey)
    if currentSkill < orange then
        return "|cff808080" -- Can't craft yet
    elseif currentSkill < yellow then
        return "|cffff8040" -- Orange
    elseif currentSkill < green then
        return "|cffffff00" -- Yellow
    elseif currentSkill < grey then
        return "|cff40c040" -- Green
    else
        return "|cff808080" -- Grey
    end
end

-- Format large numbers
function PH:FormatNumber(num)
    if num >= 1000 then
        return string.format("%.1fk", num / 1000)
    end
    return tostring(num)
end

-- Get material info with source
function PH:GetMaterialInfo(materialName)
    local matData = self.Materials and self.Materials[materialName]
    if matData then
        local source = ""
        if matData.vendor then
            source = "|cff00ff00[Vendor]|r"
            if matData.vendorPrice then
                source = source .. " " .. GetCoinTextureString(matData.vendorPrice)
            end
        elseif matData.farmable then
            source = "|cffffcc00[Farm]|r"
        else
            source = "|cffff8800[Craft]|r"
        end
        return matData, source
    end
    return nil, "|cff808080[Unknown]|r"
end

-- Create item link from name (for tooltip)
function PH:CreateItemLink(itemName)
    -- Try to find item ID from our materials database
    local matData = self.Materials and self.Materials[itemName]
    if matData and matData.id then
        return "|cffffffff|Hitem:" .. matData.id .. "::::::::70:::::|h[" .. itemName .. "]|h|r"
    end
    return itemName
end

-- Print to chat
function PH:Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ccff[ProfessionHelper]|r " .. msg)
end

-- Slash command handler
function PH:HandleSlashCommand(msg)
    local cmd = string.lower(msg or "")
    
    if cmd == "" or cmd == "show" then
        self:ToggleMainWindow()
    elseif cmd == "hide" then
        if self.MainFrame then
            self.MainFrame:Hide()
        end
    elseif cmd == "farm" or cmd == "farm start" then
        self.FarmTracker:Start()
    elseif cmd == "farm stop" then
        self.FarmTracker:Stop()
    elseif cmd == "farm toggle" then
        self.FarmTracker:Toggle()
    elseif cmd == "farm reset" then
        self.FarmTracker:Reset()
    elseif cmd == "farm show" then
        self:ShowFarmTrackerUI()
    elseif cmd == "farm hide" then
        if self.FarmTrackerFrame then
            self.FarmTrackerFrame:Hide()
        end
    elseif cmd:sub(1, 5) == "guide" then
        local profName = cmd:sub(7)
        if profName and profName ~= "" then
            -- Capitalize first letter
            profName = profName:sub(1,1):upper() .. profName:sub(2):lower()
            self:ToggleGatheringGuide(profName)
        elseif self.selectedProfession then
            self:ToggleGatheringGuide(self.selectedProfession)
        else
            self:Print("Use: /ph guide <Herbalism|Mining|Skinning|Fishing>")
        end
    elseif cmd == "cd" or cmd == "cooldowns" then
        self:ShowCooldownUI()
    elseif cmd == "recipes" or cmd:sub(1, 8) == "recipes " then
        local profArg = cmd:len() > 8 and cmd:sub(9) or nil
        if profArg then
            profArg = profArg:sub(1,1):upper() .. profArg:sub(2):lower()
        end
        self:ShowRecipeTrackerUI(profArg)
    elseif cmd == "alts" then
        self:ShowAltManagerUI()
    elseif cmd == "de" or cmd == "prospect" then
        self:ShowDECalcUI()
    elseif cmd == "help" then
        self:Print(self.L["CMD_HELP_HEADER"])
        self:Print(self.L["CMD_HELP_MAIN"])
        self:Print(self.L["CMD_HELP_SHOW"])
        self:Print(self.L["CMD_HELP_HIDE"])
        self:Print(self.L["CMD_HELP_FARM"])
        self:Print(self.L["CMD_HELP_FARM_STOP"])
        self:Print(self.L["CMD_HELP_FARM_TOGGLE"])
        self:Print(self.L["CMD_HELP_FARM_RESET"])
        self:Print(self.L["CMD_HELP_FARM_SHOWHIDE"])
        self:Print(self.L["CMD_HELP_GUIDE"])
        self:Print(self.L["CMD_HELP_HELP"])
    else
        self:Print(self.L["CMD_UNKNOWN"])
    end
end

-- Tracking state for live progress
PH.liveTracker = {
    previousSkill = {},       -- [profName] = lastKnownSkill
    previousStepIdx = nil,    -- last step index we were on
}

-- Calculate remaining crafts for a step given current skill
-- Uses the ORIGINAL guide range/count to avoid double-proportioning
function PH:GetRemainingCrafts(step, currentSkill)
    if not step then return 0, 0 end
    -- Use original guide range for accurate tracking
    local rangeStart = (step.originalRange and step.originalRange[1]) or step.skillRange[1]
    local rangeEnd   = (step.originalRange and step.originalRange[2]) or step.skillRange[2]
    local totalCrafts = step.originalCrafts or step.crafts or 0

    if currentSkill >= rangeEnd then return 0, totalCrafts end
    if currentSkill <= rangeStart then return totalCrafts, totalCrafts end

    -- Proportional: how many crafts remain based on skill progress within original range
    local rangeSize = rangeEnd - rangeStart
    local done = currentSkill - rangeStart
    local pct = done / rangeSize
    local craftsDone = math.floor(totalCrafts * pct)
    local remaining = math.max(0, totalCrafts - craftsDone)
    return remaining, totalCrafts
end

-- Find current step index from pathData
function PH:FindCurrentStepIndex(pathData, currentSkill)
    if not pathData or not pathData.steps then return 1 end
    for i, step in ipairs(pathData.steps) do
        local rangeEnd = (step.originalRange and step.originalRange[2]) or step.skillRange[2]
        if rangeEnd > currentSkill then return i end
    end
    return #pathData.steps
end

-- Event handler
function PH:OnEvent(event, ...)
    if event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == "ProfessionHelper" then
            self:InitializeDB()
            if self.BagScanner then self.BagScanner:Initialize() end
            if self.CooldownTracker then self.CooldownTracker:Initialize() end
            if self.RecipeTracker then self.RecipeTracker:Initialize() end
            if self.AltManager then self.AltManager:Initialize() end
            self:CreateMinimapButton()
            
            -- Welcome message
            local welcomeMsg = string.format(
                "|cff30a5ffProfession Helper|r |cff808080v%s|r loaded! Type |cff00ff00/ph|r to open.",
                self.version
            )
            self:Print(welcomeMsg)
            self:Print("|cff808080Created by " .. self.author .. "|r")
        end
    elseif event == "SKILL_LINES_CHANGED" or event == "CHAT_MSG_SKILL" or event == "TRADE_SKILL_UPDATE" then
        self:OnSkillChanged()
    elseif event == "BAG_UPDATE_DELAYED" then
        if self.MainFrame and self.MainFrame:IsShown() then
            self:RefreshMainWindow()
        end
    end
end

-- Handle skill changes with auto-advance and notifications
function PH:OnSkillChanged()
    local shouldRefresh = self.MainFrame and self.MainFrame:IsShown()

    if not self.selectedProfession then
        if shouldRefresh then self:RefreshMainWindow() end
        return
    end

    local profName = self.selectedProfession

    -- For combo professions, check each sub-skill individually
    local profData = self:GetProfessionData(profName)
    if profData and profData.type == "combo" and profData.skills then
        local anyChanged = false
        for _, sk in ipairs(profData.skills) do
            local skVal = self:GetPlayerProfessionLevel(sk)
            local prev = self.liveTracker.previousSkill[sk] or 0
            if skVal ~= prev then
                self.liveTracker.previousSkill[sk] = skVal
                anyChanged = true
            end
        end
        if anyChanged and shouldRefresh then self:RefreshMainWindow() end
        return
    end

    local currentSkill, maxSkill = self:GetPlayerProfessionLevel(profName)
    if not currentSkill or currentSkill == 0 then
        if shouldRefresh then self:RefreshMainWindow() end
        return
    end

    local prevSkill = self.liveTracker.previousSkill[profName] or 0

    -- Update stored skill FIRST (so it's always fresh)
    self.liveTracker.previousSkill[profName] = currentSkill

    -- Only do step-change detection if skill actually increased
    if currentSkill > prevSkill and prevSkill > 0 then
        -- Protected call so errors here never block the refresh
        local ok, err = pcall(function()
            local profData = self:GetProfessionData(profName)
            if profData and profData.levelingGuide then
                local pathData = PH.PathCalculator:Calculate(profData, currentSkill, 375)
                if not pathData then return end
                local newStepIdx = self:FindCurrentStepIndex(pathData, currentSkill)

                local oldStepIdx = self.liveTracker.previousStepIdx
                if oldStepIdx and newStepIdx ~= oldStepIdx then
                    -- Auto-advance viewedStepIndex to current
                    self.viewedStepIndex = nil
                    -- Notify step change
                    local newStep = pathData.steps[newStepIdx]
                    if newStep then
                        self:Print(string.format(self.L["NEXT_STEP_MSG"], newStep.recipe, newStep.skillRange[1], newStep.skillRange[2]))
                        PlaySound(SOUNDKIT.UI_PROFESSION_TRACK_SKILL_RANK_UP or 73277)
                    end
                end
                self.liveTracker.previousStepIdx = newStepIdx
            end
        end)
        if not ok then
            self:Print("|cffff6666[Debug] OnSkillChanged error:|r " .. tostring(err))
        end
    end

    -- ALWAYS refresh UI at the end
    if shouldRefresh then
        self:RefreshMainWindow()
    end
end

-- Toggle main window
function PH:ToggleMainWindow()
    if not self.MainFrame then
        self:CreateMainWindow()
    end
    
    if self.MainFrame:IsShown() then
        self.MainFrame:Hide()
    else
        self.MainFrame:Show()
        self:RefreshMainWindow()
    end
end

-- Refresh main window data
function PH:RefreshMainWindow()
    if self.MainFrame and self.MainFrame.UpdateContent then
        self.MainFrame:UpdateContent()
    end
end

-- Create minimap button
function PH:CreateMinimapButton()
    local button = CreateFrame("Button", "ProfessionHelperMinimapButton", Minimap)
    button:SetSize(32, 32)
    button:SetFrameStrata("MEDIUM")
    button:SetFrameLevel(8)
    
    -- Position around minimap
    local angle = math.rad(ProfessionHelperDB.minimapButtonPosition or 45)
    local x = math.cos(angle) * 80
    local y = math.sin(angle) * 80
    button:SetPoint("CENTER", Minimap, "CENTER", x, y)
    
    -- Button textures
    local icon = button:CreateTexture(nil, "BACKGROUND")
    icon:SetTexture("Interface\\Icons\\INV_Misc_Book_09")
    icon:SetSize(28, 28)
    icon:SetPoint("CENTER")
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    
    local border = button:CreateTexture(nil, "OVERLAY")
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    border:SetSize(56, 56)
    border:SetPoint("TOPLEFT")
    
    -- Highlight
    local highlight = button:CreateTexture(nil, "HIGHLIGHT")
    highlight:SetTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
    highlight:SetAllPoints()
    
    -- Click handler
    button:SetScript("OnClick", function(self, btn)
        if btn == "LeftButton" then
            PH:ToggleMainWindow()
        elseif btn == "RightButton" then
            PH.FarmTracker:Toggle()
        end
    end)
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    
    -- Tooltip
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:AddLine("Profession Helper")
        GameTooltip:AddLine("|cffffffff" .. PH.L["MINIMAP_LEFT_CLICK"] .. "|r", 1, 1, 1)
        GameTooltip:AddLine("|cffffffff" .. PH.L["MINIMAP_RIGHT_CLICK"] .. "|r", 1, 1, 1)
        if PH.FarmTracker.active then
            local gph = PH.FarmTracker:CalculateGoldPerHour()
            local elapsed = PH.FarmTracker:GetElapsedTime()
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("|cff00ff00" .. PH.L["MINIMAP_FARM_ACTIVE"] .. "|r " .. PH.FarmTracker:FormatDuration(elapsed), 1, 1, 1)
            GameTooltip:AddLine(PH.L["MINIMAP_GOLD_PER_HOUR"] .. " " .. PH.TSM:FormatMoney(gph), 1, 1, 1)
        end
        GameTooltip:Show()
    end)
    
    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    
    -- Draggable around minimap
    button:RegisterForDrag("LeftButton")
    button:SetScript("OnDragStart", function(self)
        self:SetScript("OnUpdate", function(self)
            local mx, my = Minimap:GetCenter()
            local px, py = GetCursorPosition()
            local scale = Minimap:GetEffectiveScale()
            px, py = px / scale, py / scale
            local angle = math.atan2(py - my, px - mx)
            local x = math.cos(angle) * 80
            local y = math.sin(angle) * 80
            self:ClearAllPoints()
            self:SetPoint("CENTER", Minimap, "CENTER", x, y)
            ProfessionHelperDB.minimapButtonPosition = math.deg(angle)
        end)
    end)
    
    button:SetScript("OnDragStop", function(self)
        self:SetScript("OnUpdate", nil)
    end)
    
    self.MinimapButton = button
end

-- Initialize event frame
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("SKILL_LINES_CHANGED")
eventFrame:RegisterEvent("CHAT_MSG_SKILL")
eventFrame:RegisterEvent("TRADE_SKILL_UPDATE")
eventFrame:RegisterEvent("BAG_UPDATE_DELAYED")
eventFrame:SetScript("OnEvent", function(self, event, ...)
    PH:OnEvent(event, ...)
end)

-- Polling fallback: check skill every 0.5s when window is visible
-- This guarantees real-time updates even if events don't fire
local pollElapsed = 0
local pollFrame = CreateFrame("Frame")
pollFrame:SetScript("OnUpdate", function(self, elapsed)
    pollElapsed = pollElapsed + elapsed
    if pollElapsed < 0.5 then return end
    pollElapsed = 0
    if not PH.MainFrame or not PH.MainFrame:IsShown() then return end
    if not PH.selectedProfession then return end
    local profName = PH.selectedProfession
    local profData = PH:GetProfessionData(profName)

    -- For combo professions, check each sub-skill
    if profData and profData.type == "combo" and profData.skills then
        for _, sk in ipairs(profData.skills) do
            local skVal = PH:GetPlayerProfessionLevel(sk)
            local prev = PH.liveTracker.previousSkill[sk]
            if skVal and prev and skVal ~= prev then
                PH:OnSkillChanged()
                return
            end
        end
        return
    end

    local currentSkill = PH:GetPlayerProfessionLevel(profName)
    local storedSkill = PH.liveTracker.previousSkill[profName]
    if currentSkill and storedSkill and currentSkill ~= storedSkill then
        PH:OnSkillChanged()
    end
end)

-- Register slash commands
SLASH_PROFESSIONHELPER1 = "/ph"
SLASH_PROFESSIONHELPER2 = "/professionhelper"
SlashCmdList["PROFESSIONHELPER"] = function(msg)
    PH:HandleSlashCommand(msg)
end
