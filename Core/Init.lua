-- ProfessionHelper - Initialization & Utilities (Core/Init.lua)
-- Loaded last among Core/ files, after all modules and Data/ are loaded.
-- Responsibilities:
--   1. Bootstrap: initialize all services and modules in the correct order
--   2. Profession registry and data-lookup utilities used by all layers
--   3. Slash command dispatcher
--   4. Minimap button
--   5. Skill-change detection (event + throttled poll safety net)
--
-- ADDON_LOADED → initialize services → initialize modules → register events
-- PLAYER_LOGIN → initialize Identity (UnitName is reliable here)

local PH = _G.ProfessionHelper

-------------------------------------------------------------------------------
-- Profession registry
-- All profession metadata. Data tables live in Data/*.lua.
-- Entries without minVersion are available on all supported clients.
-------------------------------------------------------------------------------

PH.Professions = {
    -- Crafting
    { name = "Alchemy",        data = "Alchemy",        icon = "Trade_Alchemy",                type = "crafting"  },
    { name = "Blacksmithing",  data = "Blacksmithing",  icon = "Trade_BlackSmithing",          type = "crafting"  },
    { name = "Enchanting",     data = "Enchanting",     icon = "Trade_Engraving",              type = "crafting"  },
    { name = "Engineering",    data = "Engineering",    icon = "Trade_Engineering",            type = "crafting"  },
    { name = "Jewelcrafting",  data = "Jewelcrafting",  icon = "INV_Misc_Gem_02",              type = "crafting",  minVersion = 20000 },
    { name = "Inscription",    data = "Inscription",    icon = "INV_Inscription_Tradeskill01", type = "crafting",  minVersion = 30000 },
    { name = "Leatherworking", data = "Leatherworking", icon = "Trade_LeatherWorking",         type = "crafting"  },
    { name = "Tailoring",      data = "Tailoring",      icon = "Trade_Tailoring",              type = "crafting"  },
    -- Gathering
    { name = "Herbalism",      data = "Herbalism",      icon = "Trade_Herbalism",              type = "gathering" },
    { name = "Mining",         data = "Mining",         icon = "Trade_Mining",                 type = "gathering" },
    { name = "Skinning",       data = "Skinning",       icon = "INV_Misc_Pelt_Wolf_01",        type = "gathering" },
    -- Secondary
    { name = "Cooking",        data = "Cooking",        icon = "INV_Misc_Food_15",             type = "secondary" },
    { name = "First Aid",      data = "FirstAid",       icon = "Spell_Holy_SealOfSacrifice",   type = "secondary" },
    { name = "Fishing",        data = "Fishing",        icon = "Trade_Fishing",                type = "secondary" },
    { name = "Archaeology",    data = "Archaeology",    icon = "Trade_Archaeology",            type = "secondary", minVersion = 40000 },
    -- Combo guides
    { name = "Herbalism & Alchemy",       data = "HerbalismAlchemy",       icon = "Trade_Herbalism",       type = "combo" },
    { name = "Skinning & Leatherworking", data = "SkinningLeatherworking", icon = "INV_Misc_Pelt_Wolf_01", type = "combo" },
    { name = "Fishing & Cooking",         data = "FishingCooking",         icon = "Trade_Fishing",         type = "combo" },
}

-------------------------------------------------------------------------------
-- Profession utility functions
-- These are pure helpers — no SavedVariables access, no UI calls.
-------------------------------------------------------------------------------

function PH:GetProfessionData(professionName)
    for _, prof in ipairs(self.Professions) do
        if prof.name == professionName then
            return self[prof.data]
        end
    end
    return nil
end

function PH:GetLocalizedProfessionName(professionName)
    return self.L[professionName] or professionName
end

function PH:GetPlayerProfessionLevel(professionName)
    local n = GetNumSkillLines()
    for i = 1, n do
        local skillName, isHeader, _, skillRank, numTemp, skillMod, skillMaxRank = GetSkillLineInfo(i)
        if not isHeader and skillName == professionName then
            return skillRank, skillMaxRank
        end
    end
    return 0, 0
end

function PH:CalculateMaterialsForRange(professionData, startSkill, targetSkill)
    if not professionData or not professionData.levelingGuide then return nil end

    local totalMaterials = {}
    local recipes = {}

    for _, guide in ipairs(professionData.levelingGuide) do
        local gs, ge = guide.range[1], guide.range[2]
        if ge > startSkill and gs < targetSkill then
            local es       = math.max(gs, startSkill)
            local ee       = math.min(ge, targetSkill)
            local ratio    = (ee - es) / (ge - gs)
            local crafts   = math.ceil((guide.count or 0) * ratio)
            table.insert(recipes, { name = guide.recipe or guide.tip, count = crafts, skillRange = {es, ee} })
            if guide.materials then
                for _, mat in ipairs(guide.materials) do
                    local adj = math.ceil(mat.count * ratio)
                    totalMaterials[mat.name] = (totalMaterials[mat.name] or 0) + adj
                end
            end
        end
    end

    return totalMaterials, recipes
end

function PH:GetFarmingLocations(professionData, currentSkill)
    if not professionData or not professionData.farmingLocations then return nil end
    local result = {}
    for _, loc in ipairs(professionData.farmingLocations) do
        local rs, re = loc.skillRange[1], loc.skillRange[2]
        if currentSkill >= rs - 20 and currentSkill <= re + 50 then
            table.insert(result, loc)
        end
    end
    return result
end

function PH:GetSkillTier(skill)
    if     skill <  75 then return self.L["Apprentice"],  75
    elseif skill < 150 then return self.L["Journeyman"], 150
    elseif skill < 225 then return self.L["Expert"],     225
    elseif skill < 300 then return self.L["Artisan"],    300
    elseif skill < 375 then return self.L["Master"],     375
    elseif skill < 450 then return self.L["Grand Master"],450
    else                    return self.L["Illustrious"], 525
    end
end

-- Maximum profession skill attainable on the current client.
-- Vanilla 300, TBC 375, WotLK 450, Cata 525. Used as the leveling target so the
-- path/shopping list cover the full range on Wrath/Cata, not just up to 375.
function PH:GetMaxSkillForClient()
    local v = self.interfaceVersion or 0
    if     v >= 40000 then return 525
    elseif v >= 30000 then return 450
    elseif v >= 20000 then return 375
    else                    return 300
    end
end

-- Short client tag for the title badge (e.g. "TBC", "WotLK", "Cata").
function PH:GetClientShortLabel()
    local v = self.interfaceVersion or 0
    if     v >= 40000 then return "Cata"
    elseif v >= 30000 then return "WotLK"
    elseif v >= 20000 then return "TBC"
    else                    return "Classic"
    end
end

-- Full client name for the home/about panels, derived from interfaceVersion.
function PH:GetClientLabel()
    local v = self.interfaceVersion or 0
    if     v >= 40000 then return "Cataclysm Classic"
    elseif v >= 30000 then return "Wrath of the Lich King Classic"
    elseif v >= 20000 then return "The Burning Crusade Classic"
    else                    return "Classic Era"
    end
end

function PH:GetSkillColor(currentSkill, orange, yellow, green, grey)
    if     currentSkill < orange then return "|cff808080"  -- not yet available
    elseif currentSkill < yellow then return "|cffff8040"  -- orange
    elseif currentSkill < green  then return "|cffffff00"  -- yellow
    elseif currentSkill < grey   then return "|cff40c040"  -- green
    else                               return "|cff808080"  -- grey
    end
end

function PH:FormatNumber(num)
    if num >= 1000 then
        return string.format("%.1fk", num / 1000)
    end
    return tostring(num)
end

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

function PH:CreateItemLink(itemName)
    local matData = self.Materials and self.Materials[itemName]
    if matData and matData.id then
        return "|cffffffff|Hitem:" .. matData.id .. "::::::::70:::::|h[" .. itemName .. "]|h|r"
    end
    return itemName
end

function PH:GetRemainingCrafts(step, currentSkill)
    if not step then return 0, 0 end
    local rangeStart  = (step.originalRange and step.originalRange[1]) or step.skillRange[1]
    local rangeEnd    = (step.originalRange and step.originalRange[2]) or step.skillRange[2]
    local totalCrafts = step.originalCrafts or step.crafts or 0
    if currentSkill >= rangeEnd   then return 0, totalCrafts end
    if currentSkill <= rangeStart then return totalCrafts, totalCrafts end
    local done = currentSkill - rangeStart
    local pct  = done / (rangeEnd - rangeStart)
    return math.max(0, totalCrafts - math.floor(totalCrafts * pct)), totalCrafts
end

function PH:FindCurrentStepIndex(pathData, currentSkill)
    if not pathData or not pathData.steps then return 1 end
    for i, step in ipairs(pathData.steps) do
        local re = (step.originalRange and step.originalRange[2]) or step.skillRange[2]
        if re > currentSkill then return i end
    end
    return #pathData.steps
end

-------------------------------------------------------------------------------
-- Skill-change detection state
-------------------------------------------------------------------------------

PH._skillTracker = {
    previousSkill   = {},   -- [profName] = lastKnownSkill
    previousStepIdx = nil,
}

-------------------------------------------------------------------------------
-- Slash command handler
-- All /ph commands are dispatched here — no command logic lives in UI.
-------------------------------------------------------------------------------

function PH:HandleSlashCommand(msg)
    local cmd = string.lower(msg or "")

    if cmd == "" or cmd == "show" then
        self:ToggleMainWindow()

    elseif cmd == "hide" then
        if self.MainFrame then self.MainFrame:Hide() end

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
        if self.FarmTrackerFrame then self.FarmTrackerFrame:Hide() end

    elseif cmd:sub(1, 5) == "guide" then
        local profName = cmd:sub(7)
        if profName and profName ~= "" then
            profName = profName:sub(1,1):upper() .. profName:sub(2):lower()
            self:ToggleGatheringGuide(profName)
        elseif self.selectedProfession then
            self:ToggleGatheringGuide(self.selectedProfession)
        else
            PH.Logger.Info("Use: /ph guide <Herbalism|Mining|Skinning|Fishing>")
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

    elseif cmd == "fish" or cmd == "fishing" then
        self:ShowFishingAssistUI()

    elseif cmd == "debug" then
        local on = PH.Config:Get("debug") ~= true
        PH.Config:Set("debug", on)
        PH.Logger.Info("Debug " .. (on and "|cff00ff00ON|r" or "|cffff0000OFF|r"))

    elseif cmd == "help" then
        PH.Logger.Info(self.L["CMD_HELP_HEADER"])
        PH.Logger.Info(self.L["CMD_HELP_MAIN"])
        PH.Logger.Info(self.L["CMD_HELP_SHOW"])
        PH.Logger.Info(self.L["CMD_HELP_HIDE"])
        PH.Logger.Info(self.L["CMD_HELP_FARM"])
        PH.Logger.Info(self.L["CMD_HELP_FARM_STOP"])
        PH.Logger.Info(self.L["CMD_HELP_FARM_TOGGLE"])
        PH.Logger.Info(self.L["CMD_HELP_FARM_RESET"])
        PH.Logger.Info(self.L["CMD_HELP_FARM_SHOWHIDE"])
        PH.Logger.Info(self.L["CMD_HELP_GUIDE"])
        PH.Logger.Info(self.L["CMD_HELP_CD"])
        PH.Logger.Info(self.L["CMD_HELP_RECIPES"])
        PH.Logger.Info(self.L["CMD_HELP_ALTS"])
        PH.Logger.Info(self.L["CMD_HELP_DE"])
        PH.Logger.Info(self.L["FA_CMD_HELP"])
        PH.Logger.Info(self.L["CMD_HELP_HELP"])
    else
        PH.Logger.Info(self.L["CMD_UNKNOWN"])
    end
end

-------------------------------------------------------------------------------
-- UI helpers (called by slash commands and the minimap button)
-- The actual frame creation lives in the UI layer files.
-------------------------------------------------------------------------------

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

function PH:RefreshMainWindow()
    if self.MainFrame and self.MainFrame.UpdateContent then
        self.MainFrame:UpdateContent()
    end
end

-------------------------------------------------------------------------------
-- Skill-change handler
-- Fires when a profession skill level changes (events or polling).
-- Notifies the player when a guide step advances.
-------------------------------------------------------------------------------

function PH:OnSkillChanged()
    local shouldRefresh = self.MainFrame and self.MainFrame:IsShown()

    if not self.selectedProfession then
        if shouldRefresh then self:RefreshMainWindow() end
        return
    end

    local profName = self.selectedProfession
    local profData = self:GetProfessionData(profName)

    -- Combo professions: check each sub-skill individually
    if profData and profData.type == "combo" and profData.skills then
        local anyChanged = false
        for _, sk in ipairs(profData.skills) do
            local val  = self:GetPlayerProfessionLevel(sk)
            local prev = self._skillTracker.previousSkill[sk] or 0
            if val ~= prev then
                self._skillTracker.previousSkill[sk] = val
                anyChanged = true
            end
        end
        if anyChanged and shouldRefresh then self:RefreshMainWindow() end
        return
    end

    local currentSkill = self:GetPlayerProfessionLevel(profName)
    if not currentSkill or currentSkill == 0 then
        if shouldRefresh then self:RefreshMainWindow() end
        return
    end

    local prevSkill = self._skillTracker.previousSkill[profName] or 0
    self._skillTracker.previousSkill[profName] = currentSkill

    if currentSkill > prevSkill and prevSkill > 0 then
        local ok, err = pcall(function()
            if profData and profData.levelingGuide then
                local pathData = PH.PathCalculator:Calculate(profData, currentSkill, self:GetMaxSkillForClient())
                if not pathData then return end
                local newIdx = self:FindCurrentStepIndex(pathData, currentSkill)
                local oldIdx = self._skillTracker.previousStepIdx
                if oldIdx and newIdx ~= oldIdx then
                    self.viewedStepIndex = nil
                    local step = pathData.steps[newIdx]
                    if step then
                        PH.Logger.Info(string.format(
                            self.L["NEXT_STEP_MSG"], step.recipe, step.skillRange[1], step.skillRange[2]
                        ))
                        PH.Compat.PlaySound(
                            SOUNDKIT and SOUNDKIT.UI_PROFESSION_TRACK_SKILL_RANK_UP,
                            73277
                        )
                    end
                end
                self._skillTracker.previousStepIdx = newIdx
            end
        end)
        if not ok then
            PH.Logger.Debug("OnSkillChanged error: " .. tostring(err))
        end
    end

    if shouldRefresh then self:RefreshMainWindow() end
end

-------------------------------------------------------------------------------
-- Minimap button
-------------------------------------------------------------------------------

function PH:CreateMinimapButton()
    local button = CreateFrame("Button", "ProfessionHelperMinimapButton", Minimap)
    button:SetSize(32, 32)
    button:SetFrameStrata("MEDIUM")
    button:SetFrameLevel(8)

    local angle = math.rad(PH.Config:Get("minimapButtonPosition"))
    button:SetPoint("CENTER", Minimap, "CENTER", math.cos(angle) * 80, math.sin(angle) * 80)

    local icon = button:CreateTexture(nil, "BACKGROUND")
    icon:SetTexture("Interface\\Icons\\INV_Misc_Book_09")
    icon:SetSize(28, 28)
    icon:SetPoint("CENTER")
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

    local border = button:CreateTexture(nil, "OVERLAY")
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    border:SetSize(56, 56)
    border:SetPoint("TOPLEFT")

    local highlight = button:CreateTexture(nil, "HIGHLIGHT")
    highlight:SetTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
    highlight:SetAllPoints()

    button:SetScript("OnClick", function(_, btn)
        if btn == "LeftButton" then
            PH:ToggleMainWindow()
        elseif btn == "RightButton" then
            PH.FarmTracker:Toggle()
        end
    end)
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")

    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:AddLine("Profession Helper")
        GameTooltip:AddLine("|cffffffff" .. PH.L["MINIMAP_LEFT_CLICK"] .. "|r",  1, 1, 1)
        GameTooltip:AddLine("|cffffffff" .. PH.L["MINIMAP_RIGHT_CLICK"] .. "|r", 1, 1, 1)
        if PH.FarmTracker.active then
            local gph     = PH.FarmTracker:CalculateGoldPerHour()
            local elapsed = PH.FarmTracker:GetElapsedTime()
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine(
                "|cff00ff00" .. PH.L["MINIMAP_FARM_ACTIVE"] .. "|r " .. PH.FarmTracker:FormatDuration(elapsed), 1, 1, 1)
            GameTooltip:AddLine(PH.L["MINIMAP_GOLD_PER_HOUR"] .. " " .. PH.TSM:FormatMoney(gph), 1, 1, 1)
        end
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function() GameTooltip:Hide() end)

    button:RegisterForDrag("LeftButton")
    button:SetScript("OnDragStart", function(self)
        self:SetScript("OnUpdate", function(self)
            local mx, my = Minimap:GetCenter()
            local px, py = GetCursorPosition()
            local scale  = Minimap:GetEffectiveScale()
            px, py = px / scale, py / scale
            local a = math.atan2(py - my, px - mx)
            self:ClearAllPoints()
            self:SetPoint("CENTER", Minimap, "CENTER", math.cos(a) * 80, math.sin(a) * 80)
            PH.Config:Set("minimapButtonPosition", math.deg(a))
        end)
    end)
    button:SetScript("OnDragStop", function(self)
        self:SetScript("OnUpdate", nil)
    end)

    self.MinimapButton = button
end

-------------------------------------------------------------------------------
-- Bootstrap (ADDON_LOADED → PLAYER_LOGIN)
-- Two-phase initialisation: services and DB first, then identity on login.
-------------------------------------------------------------------------------

-- Phase 1: ADDON_LOADED — safe to call game APIs but player name may be nil
local function OnAddonLoaded()
    -- 1. Core services (order matters)
    PH.DB:Initialize()
    PH.Event:Initialize()
    -- PH.Config is purely functional, no init needed

    -- 2. Prune professions not available on this client version
    local iVer = PH.interfaceVersion
    for i = #PH.Professions, 1, -1 do
        local p = PH.Professions[i]
        if p.minVersion and iVer < p.minVersion then
            table.remove(PH.Professions, i)
        end
    end

    -- 3. Feature modules (order: dependencies first)
    if PH.BagScanner      then PH.BagScanner:Initialize()      end
    if PH.CooldownTracker then PH.CooldownTracker:Initialize()  end
    if PH.RecipeTracker   then PH.RecipeTracker:Initialize()    end
    if PH.AltManager      then PH.AltManager:Initialize()       end
    if PH.FishingAssist   then PH.FishingAssist:Initialize()    end

    -- 4. Minimap button
    PH:CreateMinimapButton()

    -- 5. Welcome message
    PH.Logger.Info(string.format(
        "|cff30a5ffProfession Helper|r |cff808080v%s|r loaded! Type |cff00ff00/ph|r to open.",
        PH.version
    ))
    PH.Logger.Info("|cff808080Created by " .. PH.author .. "|r")
end

-- Phase 2: PLAYER_LOGIN — UnitName / UnitClass / UnitLevel are reliable here
local function OnPlayerLogin()
    PH.Identity:Initialize()
    if PH.AltManager then PH.AltManager:SaveCurrentChar() end

    -- Restore the last selected profession (if it still exists on this client)
    local saved = PH.Config:Get("selectedProfession")
    if saved and PH:GetProfessionData(saved) then
        PH.selectedProfession = saved
    end
end

-- Subscribe skill-change WoW events through the central bus
local function OnSkillEvent()
    PH:OnSkillChanged()
end

-- Bootstrap frame: this is the ONLY frame not created through PH.Event.
-- It bootstraps the event bus itself, so it must be self-contained.
-- The bootstrap frame handles ONLY ADDON_LOADED/PLAYER_LOGIN. All skill/bag
-- events are routed through PH.Event below (subscribed once the bus exists) so
-- each event is handled exactly once — not twice (one direct + one via the bus).
local bootstrapFrame = CreateFrame("Frame", "ProfessionHelperBootstrap")
bootstrapFrame:RegisterEvent("ADDON_LOADED")
bootstrapFrame:RegisterEvent("PLAYER_LOGIN")
bootstrapFrame:SetScript("OnEvent", function(_, event, arg1)
    if event == "ADDON_LOADED" then
        if arg1 == "ProfessionHelper" then
            OnAddonLoaded()
            -- Wire up skill/bag events through the bus (now that it's initialized)
            PH.Event:On("SKILL_LINES_CHANGED", OnSkillEvent, "Core")
            PH.Event:On("CHAT_MSG_SKILL",      OnSkillEvent, "Core")
            PH.Event:On("TRADE_SKILL_UPDATE",  OnSkillEvent, "Core")
            PH.Event:On("BAG_UPDATE_DELAYED", function()
                if PH.MainFrame and PH.MainFrame:IsShown() then
                    PH:RefreshMainWindow()
                end
            end, "Core")
        end
    elseif event == "PLAYER_LOGIN" then
        OnPlayerLogin()
    end
end)

-- Throttled poll: safety net when skill events don't fire.
-- Only active when the main window is visible. 0.5s interval.
local _pollElapsed = 0
local _pollFrame   = CreateFrame("Frame")
_pollFrame:SetScript("OnUpdate", function(_, elapsed)
    _pollElapsed = _pollElapsed + elapsed
    if _pollElapsed < 0.5 then return end
    _pollElapsed = 0
    if not PH.MainFrame or not PH.MainFrame:IsShown() then return end
    if not PH.selectedProfession then return end

    local profName = PH.selectedProfession
    local profData = PH:GetProfessionData(profName)
    if profData and profData.type == "combo" and profData.skills then
        for _, sk in ipairs(profData.skills) do
            local val  = PH:GetPlayerProfessionLevel(sk)
            local prev = PH._skillTracker.previousSkill[sk]
            if prev and val ~= prev then PH:OnSkillChanged(); return end
        end
        return
    end

    local cur   = PH:GetPlayerProfessionLevel(profName)
    local stored = PH._skillTracker.previousSkill[profName]
    if stored and cur and cur ~= stored then
        PH:OnSkillChanged()
    end
end)

-- Slash commands
SLASH_PROFESSIONHELPER1 = "/ph"
SLASH_PROFESSIONHELPER2 = "/professionhelper"
SlashCmdList["PROFESSIONHELPER"] = function(msg)
    PH:HandleSlashCommand(msg)
end
