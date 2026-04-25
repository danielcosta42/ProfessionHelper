-- Profession Helper - Gathering Route System
-- Draws full farming routes on World Map + minimap arrow to next waypoint
local PH = ProfessionHelper

-------------------------------------------------------------------------------
-- Zone uiMapID lookup — built at runtime from HereBeDragons / C_Map
-------------------------------------------------------------------------------
local ZONE_MAP_IDS = {}
local zoneMapIDsBuilt = false

local function BuildZoneMapIDs()
    if zoneMapIDsBuilt then return end
    zoneMapIDsBuilt = true

    local hbd
    if LibStub then
        local ok, lib = pcall(LibStub, "HereBeDragons-2.0")
        if ok and lib then hbd = lib end
    end

    if hbd then
        local allMaps = hbd:GetAllMapIDs()
        if allMaps then
            for _, mapID in ipairs(allMaps) do
                local name = hbd:GetLocalizedMap(mapID)
                if name and name ~= "" then
                    local w, h = hbd:GetZoneSize(mapID)
                    if w and w > 0 and h and h > 0 then
                        ZONE_MAP_IDS[name] = mapID
                    end
                end
            end
        end
    end

    -- Fallback: C_Map brute force
    if not next(ZONE_MAP_IDS) and C_Map and C_Map.GetMapInfo then
        for id = 1, 2000 do
            local info = C_Map.GetMapInfo(id)
            if info and info.name and info.name ~= "" then
                ZONE_MAP_IDS[info.name] = id
            end
        end
    end
end

-------------------------------------------------------------------------------
-- Farming route waypoints per zone
-- Each route is a circular loop of {x, y} coords (0-1 zone map fractions)
-- Player follows waypoints in order, then loops back to [1]
-------------------------------------------------------------------------------
local ZONE_ROUTES = {
    -- ===================== STARTER ZONES =====================
    ["Durotar"] = {
        {0.47, 0.29}, {0.53, 0.22}, {0.60, 0.30}, {0.58, 0.42},
        {0.52, 0.50}, {0.44, 0.57}, {0.40, 0.47}, {0.43, 0.35},
    },
    ["Mulgore"] = {
        {0.36, 0.38}, {0.42, 0.30}, {0.53, 0.32}, {0.60, 0.40},
        {0.57, 0.55}, {0.48, 0.65}, {0.36, 0.60}, {0.32, 0.48},
    },
    ["Elwynn Forest"] = {
        {0.30, 0.60}, {0.38, 0.50}, {0.50, 0.45}, {0.60, 0.50},
        {0.65, 0.60}, {0.55, 0.72}, {0.42, 0.78}, {0.32, 0.70},
    },
    ["Tirisfal Glades"] = {
        {0.53, 0.50}, {0.60, 0.42}, {0.70, 0.45}, {0.72, 0.55},
        {0.65, 0.62}, {0.55, 0.65}, {0.48, 0.58}, {0.50, 0.52},
    },
    ["Dun Morogh"] = {
        {0.38, 0.42}, {0.45, 0.35}, {0.55, 0.38}, {0.60, 0.48},
        {0.55, 0.58}, {0.45, 0.62}, {0.38, 0.55}, {0.35, 0.48},
    },
    ["Teldrassil"] = {
        {0.48, 0.42}, {0.55, 0.38}, {0.62, 0.45}, {0.60, 0.55},
        {0.55, 0.62}, {0.48, 0.60}, {0.42, 0.55}, {0.44, 0.47},
    },
    -- ===================== LOW ZONES (65-150) =====================
    -- The Barrens: North (Crossroads) → South (Camp Taurajo) loop
    ["The Barrens"] = {
        {0.48, 0.25}, {0.55, 0.30}, {0.58, 0.38}, {0.55, 0.48},
        {0.50, 0.55}, {0.45, 0.48}, {0.42, 0.38}, {0.45, 0.30},
        -- South Barrens / Camp Taurajo area
        {0.44, 0.65}, {0.48, 0.72}, {0.52, 0.78}, {0.48, 0.82},
        {0.42, 0.78}, {0.40, 0.72}, {0.42, 0.65},
    },
    ["Thousand Needles"] = {
        {0.40, 0.20}, {0.50, 0.18}, {0.60, 0.22}, {0.65, 0.32},
        {0.62, 0.45}, {0.55, 0.55}, {0.48, 0.60}, {0.40, 0.55},
        {0.35, 0.45}, {0.38, 0.32},
    },
    ["Westfall"] = {
        {0.42, 0.32}, {0.52, 0.28}, {0.62, 0.35}, {0.65, 0.48},
        {0.58, 0.60}, {0.48, 0.65}, {0.38, 0.55}, {0.36, 0.42},
    },
    ["Silverpine Forest"] = {
        {0.42, 0.28}, {0.52, 0.32}, {0.58, 0.42}, {0.55, 0.55},
        {0.48, 0.62}, {0.40, 0.58}, {0.35, 0.45}, {0.38, 0.35},
    },
    ["Redridge Mountains"] = {
        {0.22, 0.48}, {0.30, 0.40}, {0.40, 0.38}, {0.48, 0.45},
        {0.45, 0.58}, {0.35, 0.65}, {0.25, 0.62}, {0.20, 0.55},
    },
    ["Darkshore"] = {
        {0.38, 0.28}, {0.42, 0.35}, {0.45, 0.45}, {0.42, 0.55},
        {0.38, 0.62}, {0.35, 0.55}, {0.33, 0.42}, {0.35, 0.32},
    },
    ["Loch Modan"] = {
        {0.28, 0.32}, {0.38, 0.28}, {0.48, 0.35}, {0.45, 0.48},
        {0.38, 0.55}, {0.30, 0.52}, {0.25, 0.45}, {0.26, 0.38},
    },
    -- ===================== MID ZONES (125-200) =====================
    ["Hillsbrad Foothills"] = {
        {0.38, 0.38}, {0.48, 0.32}, {0.58, 0.38}, {0.62, 0.48},
        {0.55, 0.58}, {0.45, 0.62}, {0.38, 0.55}, {0.35, 0.45},
    },
    ["Stonetalon Mountains"] = {
        {0.42, 0.35}, {0.52, 0.30}, {0.60, 0.38}, {0.58, 0.50},
        {0.52, 0.58}, {0.44, 0.60}, {0.38, 0.50}, {0.38, 0.42},
    },
    ["Dustwallow Marsh"] = {
        {0.35, 0.32}, {0.45, 0.28}, {0.58, 0.32}, {0.65, 0.42},
        {0.62, 0.55}, {0.55, 0.65}, {0.45, 0.68}, {0.35, 0.62},
        {0.30, 0.50}, {0.32, 0.40},
    },
    ["Wetlands"] = {
        {0.42, 0.28}, {0.52, 0.30}, {0.60, 0.38}, {0.62, 0.50},
        {0.55, 0.58}, {0.45, 0.55}, {0.38, 0.48}, {0.38, 0.35},
    },
    ["Ashenvale"] = {
        {0.38, 0.38}, {0.48, 0.32}, {0.58, 0.38}, {0.62, 0.48},
        {0.55, 0.58}, {0.45, 0.55}, {0.38, 0.50}, {0.35, 0.42},
    },
    ["Arathi Highlands"] = {
        {0.32, 0.42}, {0.42, 0.35}, {0.55, 0.38}, {0.62, 0.48},
        {0.58, 0.58}, {0.48, 0.65}, {0.38, 0.60}, {0.30, 0.52},
    },
    ["Desolace"] = {
        {0.38, 0.35}, {0.50, 0.28}, {0.60, 0.35}, {0.62, 0.48},
        {0.55, 0.60}, {0.45, 0.62}, {0.35, 0.55}, {0.33, 0.42},
    },
    -- ===================== MID-HIGH ZONES (150-250) =====================
    ["Stranglethorn Vale"] = {
        {0.28, 0.28}, {0.38, 0.22}, {0.48, 0.28}, {0.45, 0.40},
        {0.40, 0.52}, {0.35, 0.62}, {0.28, 0.55}, {0.25, 0.40},
    },
    ["Badlands"] = {
        {0.38, 0.38}, {0.48, 0.30}, {0.58, 0.35}, {0.62, 0.48},
        {0.55, 0.60}, {0.45, 0.65}, {0.35, 0.58}, {0.33, 0.48},
    },
    ["Swamp of Sorrows"] = {
        {0.40, 0.40}, {0.52, 0.35}, {0.62, 0.42}, {0.65, 0.55},
        {0.58, 0.62}, {0.48, 0.65}, {0.38, 0.58}, {0.36, 0.48},
    },
    ["The Hinterlands"] = {
        {0.38, 0.38}, {0.48, 0.30}, {0.60, 0.35}, {0.65, 0.48},
        {0.58, 0.58}, {0.48, 0.62}, {0.38, 0.58}, {0.35, 0.48},
    },
    ["Feralas"] = {
        {0.42, 0.38}, {0.52, 0.32}, {0.62, 0.38}, {0.65, 0.50},
        {0.58, 0.62}, {0.48, 0.65}, {0.38, 0.58}, {0.38, 0.48},
    },
    ["Alterac Mountains"] = {
        {0.38, 0.38}, {0.48, 0.32}, {0.58, 0.38}, {0.60, 0.50},
        {0.55, 0.60}, {0.45, 0.62}, {0.38, 0.55}, {0.35, 0.45},
    },
    -- ===================== HIGH ZONES (200-300) =====================
    ["Tanaris"] = {
        {0.40, 0.32}, {0.52, 0.28}, {0.62, 0.35}, {0.68, 0.48},
        {0.62, 0.60}, {0.50, 0.65}, {0.40, 0.58}, {0.35, 0.45},
    },
    ["Searing Gorge"] = {
        {0.35, 0.35}, {0.48, 0.28}, {0.58, 0.35}, {0.60, 0.48},
        {0.55, 0.60}, {0.45, 0.62}, {0.35, 0.55}, {0.32, 0.45},
    },
    ["Felwood"] = {
        {0.42, 0.22}, {0.48, 0.30}, {0.52, 0.40}, {0.50, 0.52},
        {0.48, 0.62}, {0.44, 0.72}, {0.40, 0.60}, {0.38, 0.45},
        {0.40, 0.32},
    },
    ["Blasted Lands"] = {
        {0.42, 0.35}, {0.52, 0.30}, {0.62, 0.38}, {0.65, 0.52},
        {0.58, 0.65}, {0.48, 0.68}, {0.38, 0.60}, {0.35, 0.48},
    },
    ["Un'Goro Crater"] = {
        {0.38, 0.20}, {0.50, 0.15}, {0.62, 0.22}, {0.70, 0.35},
        {0.68, 0.52}, {0.62, 0.65}, {0.50, 0.72}, {0.38, 0.68},
        {0.28, 0.55}, {0.25, 0.38}, {0.30, 0.25},
    },
    ["Winterspring"] = {
        {0.42, 0.25}, {0.52, 0.28}, {0.60, 0.35}, {0.62, 0.48},
        {0.58, 0.58}, {0.50, 0.65}, {0.42, 0.60}, {0.38, 0.48},
        {0.38, 0.35},
    },
    ["Eastern Plaguelands"] = {
        {0.35, 0.38}, {0.48, 0.30}, {0.58, 0.28}, {0.68, 0.35},
        {0.72, 0.48}, {0.65, 0.60}, {0.52, 0.62}, {0.40, 0.58},
        {0.32, 0.48},
    },
    ["Silithus"] = {
        {0.35, 0.35}, {0.48, 0.28}, {0.60, 0.32}, {0.68, 0.42},
        {0.65, 0.55}, {0.55, 0.65}, {0.42, 0.68}, {0.32, 0.58},
        {0.30, 0.45},
    },
    ["Burning Steppes"] = {
        {0.32, 0.38}, {0.45, 0.30}, {0.58, 0.32}, {0.68, 0.42},
        {0.65, 0.55}, {0.55, 0.62}, {0.42, 0.60}, {0.32, 0.50},
    },
    ["Azshara"] = {
        {0.38, 0.35}, {0.50, 0.28}, {0.62, 0.32}, {0.70, 0.42},
        {0.68, 0.55}, {0.58, 0.62}, {0.48, 0.58}, {0.38, 0.48},
    },
    -- ===================== OUTLAND (300-375) =====================
    ["Hellfire Peninsula"] = {
        {0.48, 0.28}, {0.58, 0.25}, {0.68, 0.32}, {0.72, 0.45},
        {0.65, 0.58}, {0.55, 0.62}, {0.45, 0.58}, {0.38, 0.48},
        {0.40, 0.35},
    },
    ["Zangarmarsh"] = {
        {0.35, 0.38}, {0.45, 0.30}, {0.58, 0.32}, {0.68, 0.42},
        {0.65, 0.55}, {0.55, 0.62}, {0.42, 0.60}, {0.32, 0.50},
    },
    ["Terokkar Forest"] = {
        {0.38, 0.32}, {0.48, 0.28}, {0.60, 0.32}, {0.68, 0.42},
        {0.65, 0.55}, {0.55, 0.62}, {0.42, 0.58}, {0.35, 0.45},
    },
    ["Nagrand"] = {
        {0.35, 0.40}, {0.45, 0.30}, {0.58, 0.32}, {0.68, 0.42},
        {0.72, 0.55}, {0.62, 0.65}, {0.48, 0.68}, {0.38, 0.60},
        {0.30, 0.50},
    },
    ["Blade's Edge Mountains"] = {
        {0.38, 0.35}, {0.48, 0.28}, {0.60, 0.30}, {0.70, 0.38},
        {0.68, 0.50}, {0.58, 0.58}, {0.48, 0.55}, {0.38, 0.48},
    },
    ["Netherstorm"] = {
        {0.35, 0.42}, {0.45, 0.32}, {0.58, 0.30}, {0.68, 0.38},
        {0.72, 0.50}, {0.65, 0.62}, {0.52, 0.58}, {0.40, 0.52},
    },
    ["Shadowmoon Valley"] = {
        {0.32, 0.40}, {0.42, 0.30}, {0.55, 0.28}, {0.65, 0.35},
        {0.70, 0.48}, {0.62, 0.60}, {0.50, 0.62}, {0.38, 0.55},
    },
}

-------------------------------------------------------------------------------
-- Gathering Guide state
-------------------------------------------------------------------------------
PH.GatherGuide = {
    active        = false,
    profName      = nil,
    steps         = {},
    currentStep   = 1,
    -- Route tracking
    currentRoute  = nil,   -- route table for current zone
    currentWP     = 1,     -- index into route
    routeMapID    = nil,   -- mapID the route is plotted for
    routeZone     = nil,   -- zone name
}

local GG = PH.GatherGuide

-------------------------------------------------------------------------------
-- HBD / HBDPins access
-------------------------------------------------------------------------------
local HBD, HBDPins
local function GetHBD()
    if HBD then return HBD, HBDPins end
    if LibStub then
        local ok1, lib1 = pcall(LibStub, "HereBeDragons-2.0")
        if ok1 and lib1 then HBD = lib1 end
        local ok2, lib2 = pcall(LibStub, "HereBeDragons-Pins-2.0")
        if ok2 and lib2 then HBDPins = lib2 end
    end
    return HBD, HBDPins
end

-------------------------------------------------------------------------------
-- Build steps from profession data (same as before)
-------------------------------------------------------------------------------
function GG:BuildSteps(profData, currentSkill)
    self.steps = {}
    if not profData or not profData.farmingLocations then return end

    local faction = UnitFactionGroup("player") or "Alliance"
    local idx = 0

    for _, tier in ipairs(profData.farmingLocations) do
        idx = idx + 1
        local resource = tier.ore or tier.herb or tier.leather or tier.fishTypes or "Resources"
        local filteredLocs = {}

        if tier.locations then
            for _, loc in ipairs(tier.locations) do
                if loc.faction == "Both" or loc.faction == faction then
                    table.insert(filteredLocs, loc)
                end
            end
        end

        local tip = nil
        if profData.levelingGuide then
            for _, g in ipairs(profData.levelingGuide) do
                if g.range[1] == tier.skillRange[1] or
                   (g.range[1] >= tier.skillRange[1] and g.range[1] < tier.skillRange[2]) then
                    tip = g.tip
                    break
                end
            end
        end

        table.insert(self.steps, {
            index      = idx,
            skillRange = { tier.skillRange[1], tier.skillRange[2] },
            resource   = resource,
            locations  = filteredLocs,
            tip        = tip,
        })
    end
end

function GG:GetCurrentStepIndex(currentSkill)
    for i, step in ipairs(self.steps) do
        if step.skillRange[2] > currentSkill then return i end
    end
    return #self.steps
end

function GG:GetBestLocation(step)
    if step and step.locations and #step.locations > 0 then
        return step.locations[1]
    end
    return nil
end

function GG:GetPlayerZone()
    return GetRealZoneText() or ""
end

function GG:IsPlayerInStepZone(step)
    local pZone = self:GetPlayerZone()
    if not step or not step.locations then return false end
    for _, loc in ipairs(step.locations) do
        if loc.zone == pZone then return true end
    end
    return false
end

function GG:GetMatchingLocation(step)
    local pZone = self:GetPlayerZone()
    if not step or not step.locations then return nil end
    for _, loc in ipairs(step.locations) do
        if loc.zone == pZone then return loc end
    end
    return nil
end

-------------------------------------------------------------------------------
-- ROUTE SYSTEM — World Map + Minimap
-------------------------------------------------------------------------------

-- Frame pools
local wpDotPool = {}     -- waypoint numbered dots
local trailPool = {}     -- trail dot frames
local routeFrames = {}   -- all currently active world map frames
local REF_KEY = "PHGatherRoute"

-- Advance threshold in yards
local WP_ADVANCE_DIST = 60

-- Create a waypoint numbered dot for the world map
local function CreateWPDot(index, isCurrent)
    local dot = table.remove(wpDotPool)
    if not dot then
        dot = CreateFrame("Frame", nil, UIParent)
        dot:SetFrameStrata("TOOLTIP")
        dot:SetFrameLevel(200)

        local border = dot:CreateTexture(nil, "BORDER")
        border:SetPoint("TOPLEFT", -2, 2)
        border:SetPoint("BOTTOMRIGHT", 2, -2)
        border:SetTexture("Interface\\Buttons\\WHITE8X8")
        border:SetVertexColor(0, 0, 0, 0.9)
        dot.border = border

        local tex = dot:CreateTexture(nil, "ARTWORK")
        tex:SetAllPoints()
        tex:SetTexture("Interface\\Buttons\\WHITE8X8")
        dot.tex = tex

        local num = dot:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        num:SetPoint("CENTER", 0, 0)
        dot.num = num

        dot.isDot = true
    end

    if isCurrent then
        dot.tex:SetVertexColor(0.15, 1.0, 0.4, 1)
        dot:SetSize(18, 18)
    else
        dot.tex:SetVertexColor(1, 1, 1, 0.95)
        dot:SetSize(14, 14)
    end
    dot.num:SetText("|cff000000" .. index .. "|r")
    dot:Show()
    return dot
end

-- Create a small trail dot (forms the "line" between waypoints)
local function CreateTrailDot()
    local f = table.remove(trailPool)
    if not f then
        f = CreateFrame("Frame", nil, UIParent)
        f:SetFrameStrata("HIGH")
        f:SetFrameLevel(100)

        local tex = f:CreateTexture(nil, "ARTWORK")
        tex:SetAllPoints()
        tex:SetTexture("Interface\\Buttons\\WHITE8X8")
        tex:SetVertexColor(1, 1, 1, 0.9)
        f.tex = tex

        f.isDot = false
    end

    f:SetSize(3, 3)
    f:Show()
    return f
end

-- Remove all route visuals from world map
function GG:ClearRouteDisplay()
    local _, pins = GetHBD()
    if pins then
        pins:RemoveAllWorldMapIcons(REF_KEY)
    end

    for _, f in ipairs(routeFrames) do
        f:Hide()
        if f.isDot then
            table.insert(wpDotPool, f)
        else
            table.insert(trailPool, f)
        end
    end
    wipe(routeFrames)
end

-- Draw full route on the world map using HBDPins
function GG:PlotRouteOnWorldMap(zoneName, mapID, route)
    self:ClearRouteDisplay()

    local hbd, pins = GetHBD()
    if not hbd or not pins then return end
    if not route or #route < 2 then return end

    -- Use SHOW_PARENT (1) — defined in all HBD versions — so route appears
    -- when the world map is on this zone or its continent parent.
    -- SHOW_CURRENT (-1) only exists in Questie's patched HBD and is not
    -- handled by GatherMate2's version, making routes invisible.
    local showFlag = HBD_PINS_WORLDMAP_SHOW_PARENT or 1

    -- First: draw trail dots between all waypoints (line effect)
    for i = 1, #route do
        local next_i = (i % #route) + 1
        local x1, y1 = route[i][1], route[i][2]
        local x2, y2 = route[next_i][1], route[next_i][2]

        local dx, dy = x2 - x1, y2 - y1
        local dist = math.sqrt(dx * dx + dy * dy)
        local count = math.max(15, math.floor(dist * 300))

        for t = 0, count do
            local frac = t / count
            local mx = x1 + dx * frac
            local my = y1 + dy * frac

            local trail = CreateTrailDot()
            pins:AddWorldMapIconMap(REF_KEY, trail, mapID, mx, my, showFlag)
            table.insert(routeFrames, trail)
        end
    end

    -- Then: place numbered waypoint dots on top
    for i, wp in ipairs(route) do
        local isCurrent = (i == self.currentWP)
        local dot = CreateWPDot(i, isCurrent)
        pins:AddWorldMapIconMap(REF_KEY, dot, mapID, wp[1], wp[2], showFlag)
        table.insert(routeFrames, dot)
    end

    self.routeMapID = mapID
    self.routeZone = zoneName
end

-- No complex hooks needed — HBDPins handles map display
local function HookWorldMap() end

-- Refresh dot styles (highlight current waypoint)
function GG:RefreshRouteDots()
    local dotIndex = 0
    for _, f in ipairs(routeFrames) do
        if f.isDot then
            dotIndex = dotIndex + 1
            if dotIndex == self.currentWP then
                f.tex:SetVertexColor(0.15, 1.0, 0.4, 1)
                f:SetSize(18, 18)
            else
                f.tex:SetVertexColor(1, 1, 1, 0.95)
                f:SetSize(14, 14)
            end
        end
    end
end

-------------------------------------------------------------------------------
-- Minimap icons — uses HBDPins for reliable placement
-------------------------------------------------------------------------------
local MINIMAP_REF = "PHGatherMinimap"
local minimapDots = {}   -- pool of minimap WP dots
local minimapTrailPool = {} -- pool of minimap trail dots
local activeMinimapDots = {} -- currently placed minimap frames

-- Create a minimap waypoint numbered dot
local function CreateMinimapWPDot(index, isNext)
    local dot = table.remove(minimapDots)
    if not dot then
        dot = CreateFrame("Frame", nil, UIParent)
        dot:SetFrameStrata("TOOLTIP")
        dot:SetFrameLevel(200)

        local bg = dot:CreateTexture(nil, "BORDER")
        bg:SetPoint("TOPLEFT", -2, 2)
        bg:SetPoint("BOTTOMRIGHT", 2, -2)
        bg:SetTexture("Interface\\Buttons\\WHITE8X8")
        bg:SetVertexColor(0, 0, 0, 0.9)
        dot.bg = bg

        local tex = dot:CreateTexture(nil, "ARTWORK")
        tex:SetAllPoints()
        tex:SetTexture("Interface\\Buttons\\WHITE8X8")
        dot.tex = tex

        local num = dot:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        num:SetPoint("CENTER", 0, 0)
        dot.num = num

        dot.isWP = true
    end

    if isNext then
        dot:SetSize(14, 14)
        dot.tex:SetVertexColor(0.15, 1.0, 0.4, 1)
    else
        dot:SetSize(10, 10)
        dot.tex:SetVertexColor(1, 1, 1, 0.95)
    end
    dot.num:SetText("|cff000000" .. index .. "|r")
    dot.num:Show()
    dot:Show()
    return dot
end

-- Create a minimap trail dot (no border, small, white)
local function CreateMinimapTrailDot()
    local f = table.remove(minimapTrailPool)
    if not f then
        f = CreateFrame("Frame", nil, UIParent)
        f:SetFrameStrata("HIGH")
        f:SetFrameLevel(100)

        local tex = f:CreateTexture(nil, "ARTWORK")
        tex:SetAllPoints()
        tex:SetTexture("Interface\\Buttons\\WHITE8X8")
        tex:SetVertexColor(1, 1, 1, 0.9)
        f.tex = tex

        f.isWP = false
    end

    f:SetSize(2, 2)
    f:Show()
    return f
end

-- Place all route waypoints + trail on minimap via HBDPins
function GG:PlotMinimapRoute()
    local _, pins = GetHBD()
    if not pins then return end

    -- Clear old minimap icons
    pins:RemoveAllMinimapIcons(MINIMAP_REF)
    for _, f in ipairs(activeMinimapDots) do
        f:Hide()
        if f.isWP then
            table.insert(minimapDots, f)
        else
            table.insert(minimapTrailPool, f)
        end
    end
    wipe(activeMinimapDots)

    local route = self.currentRoute
    local mapID = self.routeMapID
    if not route or not mapID or #route < 2 then return end

    -- First: trail dots between waypoints (line effect)
    for i = 1, #route do
        local next_i = (i % #route) + 1
        local x1, y1 = route[i][1], route[i][2]
        local x2, y2 = route[next_i][1], route[next_i][2]
        local dx, dy = x2 - x1, y2 - y1
        local dist = math.sqrt(dx * dx + dy * dy)
        local count = math.max(8, math.floor(dist * 300))

        for t = 0, count do
            local frac = t / count
            local mx = x1 + dx * frac
            local my = y1 + dy * frac
            local trail = CreateMinimapTrailDot()
            pins:AddMinimapIconMap(MINIMAP_REF, trail, mapID, mx, my, false, false)
            table.insert(activeMinimapDots, trail)
        end
    end

    -- Then: numbered waypoint dots on top
    for i, wp in ipairs(route) do
        local isNext = (i == self.currentWP)
        local dot = CreateMinimapWPDot(i, isNext)
        pins:AddMinimapIconMap(MINIMAP_REF, dot, mapID, wp[1], wp[2], true, true)
        table.insert(activeMinimapDots, dot)
    end
end

-- Clear minimap
function GG:ClearMinimapArrow()
    local _, pins = GetHBD()
    if pins then
        pins:RemoveAllMinimapIcons(MINIMAP_REF)
    end
    for _, f in ipairs(activeMinimapDots) do
        f:Hide()
        if f.isWP then
            table.insert(minimapDots, f)
        else
            table.insert(minimapTrailPool, f)
        end
    end
    wipe(activeMinimapDots)
end

-- Find closest waypoint to player and set it as current
function GG:SetClosestWaypoint()
    local route = self.currentRoute
    local mapID = self.routeMapID
    if not route or not mapID then return end

    local hbd = GetHBD()
    if not hbd then return end

    local px, py = hbd:GetPlayerWorldPosition()
    if not px or not py then return end

    local bestIdx, bestDist = 1, math.huge
    for i, wp in ipairs(route) do
        local wx, wy = hbd:GetWorldCoordinatesFromZone(wp[1], wp[2], mapID)
        if wx and wy then
            local d = (px - wx)^2 + (py - wy)^2
            if d < bestDist then
                bestDist = d
                bestIdx = i
            end
        end
    end

    self.currentWP = bestIdx
    self:RefreshRouteDots()
    self:PlotMinimapRoute()
end

-- Auto-advance: check player distance to current waypoint
local function CheckWaypointAdvance()
    if not GG.active or not GG.currentRoute or not GG.routeMapID then return end

    local hbd = GetHBD()
    if not hbd then return end

    local px, py, pInst = hbd:GetPlayerWorldPosition()
    if not px or not py then return end

    local wp = GG.currentRoute[GG.currentWP]
    if not wp then return end

    local wx, wy = hbd:GetWorldCoordinatesFromZone(wp[1], wp[2], GG.routeMapID)
    if not wx or not wy then return end

    local dist = math.sqrt((px - wx)^2 + (py - wy)^2)
    if dist < WP_ADVANCE_DIST then
        GG:AdvanceWaypoint()
    end
end

-- Advance to next waypoint in the route loop
function GG:AdvanceWaypoint()
    if not self.currentRoute then return end
    self.currentWP = (self.currentWP % #self.currentRoute) + 1
    self:RefreshRouteDots()
    self:PlotMinimapRoute()  -- re-plot minimap to highlight new current WP
end

-------------------------------------------------------------------------------
-- Route management — called when step/zone changes
-------------------------------------------------------------------------------
function GG:UpdateRouteForStep(step)
    if not step then
        self:ClearRouteDisplay()
        self:ClearMinimapArrow()
        return
    end

    BuildZoneMapIDs()

    -- Find zone: prefer one matching player zone, else best location
    local zone = nil
    local pZone = self:GetPlayerZone()
    if step.locations then
        for _, loc in ipairs(step.locations) do
            if loc.zone == pZone and ZONE_ROUTES[loc.zone] then
                zone = loc.zone
                break
            end
        end
        if not zone then
            for _, loc in ipairs(step.locations) do
                if ZONE_ROUTES[loc.zone] then
                    zone = loc.zone
                    break
                end
            end
        end
    end

    if not zone then
        self:ClearRouteDisplay()
        self:ClearMinimapArrow()
        return
    end

    local mapID = ZONE_MAP_IDS[zone]
    local route = ZONE_ROUTES[zone]

    if not mapID or not route then
        self:ClearRouteDisplay()
        self:ClearMinimapArrow()
        return
    end

    -- Only re-plot if zone changed
    if self.routeZone ~= zone then
        self.currentRoute = route
        self.currentWP = 1
        self:PlotRouteOnWorldMap(zone, mapID, route)
        self:SetClosestWaypoint()  -- set nearest WP as current
        print("|cff4dda5d[PH Route]|r " .. zone .. " — " .. #route .. " waypoints plotted")
    end
end

-------------------------------------------------------------------------------
-- OnUpdate for auto-advance check
-------------------------------------------------------------------------------
local minimapUpdater = nil

local function StartMinimapUpdater()
    if minimapUpdater then return end
    minimapUpdater = CreateFrame("Frame")
    minimapUpdater:SetScript("OnUpdate", function(self, elapsed)
        self.elapsed = (self.elapsed or 0) + elapsed
        if self.elapsed < 0.5 then return end  -- check every 0.5s
        self.elapsed = 0
        if GG.active then
            CheckWaypointAdvance()
        end
    end)
end

local function StopMinimapUpdater()
    if minimapUpdater then
        minimapUpdater:SetScript("OnUpdate", nil)
        minimapUpdater = nil
    end
end

-------------------------------------------------------------------------------
-- Floating guide widget (same premium flat design)
-------------------------------------------------------------------------------
local W_WIDTH = 270

function PH:CreateGatheringWidget()
    if self.GatherWidget then return self.GatherWidget end

    local w = CreateFrame("Frame", "PHGatherWidget", UIParent, "BackdropTemplate")
    w:SetSize(W_WIDTH, 10)
    w:SetPoint("TOP", UIParent, "TOP", 0, -100)
    w:SetMovable(true)
    w:EnableMouse(true)
    w:SetClampedToScreen(true)
    w:RegisterForDrag("LeftButton")
    w:SetScript("OnDragStart", w.StartMoving)
    w:SetScript("OnDragStop", w.StopMovingOrSizing)
    w:SetFrameStrata("MEDIUM")
    w:SetFrameLevel(50)

    w:SetBackdrop({
        bgFile   = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 1,
    })
    w:SetBackdropColor(0.06, 0.06, 0.08, 0.95)
    w:SetBackdropBorderColor(0.18, 0.18, 0.22, 1)

    local shadow = CreateFrame("Frame", nil, w, "BackdropTemplate")
    shadow:SetPoint("TOPLEFT", -2, 2)
    shadow:SetPoint("BOTTOMRIGHT", 2, -2)
    shadow:SetFrameLevel(w:GetFrameLevel() - 1)
    shadow:SetBackdrop({
        bgFile   = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 2,
    })
    shadow:SetBackdropColor(0, 0, 0, 0.5)
    shadow:SetBackdropBorderColor(0, 0, 0, 0.35)

    -- Header
    local hdr = CreateFrame("Frame", nil, w, "BackdropTemplate")
    hdr:SetHeight(24)
    hdr:SetPoint("TOPLEFT", 1, -1)
    hdr:SetPoint("TOPRIGHT", -1, -1)
    hdr:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8" })
    hdr:SetBackdropColor(0.08, 0.08, 0.11, 1)

    local icon = hdr:CreateTexture(nil, "ARTWORK")
    icon:SetSize(16, 16)
    icon:SetPoint("LEFT", 6, 0)
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    w.profIcon = icon

    local title = hdr:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    title:SetPoint("LEFT", icon, "RIGHT", 5, 0)
    w.titleText = title

    local stepBadge = hdr:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    stepBadge:SetPoint("RIGHT", -24, 0)
    w.stepBadge = stepBadge

    local closeBtn = CreateFrame("Button", nil, hdr)
    closeBtn:SetSize(20, 20)
    closeBtn:SetPoint("RIGHT", -2, 0)
    local closeTex = closeBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    closeTex:SetPoint("CENTER", 0, 1)
    closeTex:SetText("|cff888888x|r")
    local closeHL = closeBtn:CreateTexture(nil, "HIGHLIGHT")
    closeHL:SetAllPoints()
    closeHL:SetColorTexture(0.9, 0.25, 0.25, 0.25)
    closeBtn:SetScript("OnClick", function() PH:StopGatheringGuide() end)

    -- Body
    local resText = w:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    resText:SetPoint("TOPLEFT", w, "TOPLEFT", 10, -30)
    resText:SetPoint("RIGHT", w, "RIGHT", -10, 0)
    resText:SetJustifyH("LEFT")
    resText:SetWordWrap(true)
    w.resourceText = resText

    local skillText = w:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    skillText:SetPoint("TOPLEFT", resText, "BOTTOMLEFT", 0, -4)
    w.skillRangeText = skillText

    local trackBg = CreateFrame("Frame", nil, w, "BackdropTemplate")
    trackBg:SetHeight(5)
    trackBg:SetPoint("TOPLEFT", skillText, "BOTTOMLEFT", 0, -5)
    trackBg:SetPoint("RIGHT", w, "RIGHT", -10, 0)
    trackBg:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8" })
    trackBg:SetBackdropColor(0.05, 0.05, 0.07, 1)
    w.progressTrack = trackBg

    local trackFill = trackBg:CreateTexture(nil, "ARTWORK")
    trackFill:SetPoint("TOPLEFT", 0, 0)
    trackFill:SetPoint("BOTTOMLEFT", 0, 0)
    trackFill:SetColorTexture(0.3, 0.85, 0.45, 1)
    w.progressFill = trackFill

    local sep1 = w:CreateTexture(nil, "ARTWORK")
    sep1:SetHeight(1)
    sep1:SetPoint("TOPLEFT", trackBg, "BOTTOMLEFT", 0, -6)
    sep1:SetPoint("RIGHT", w, "RIGHT", -10, 0)
    sep1:SetColorTexture(0.18, 0.18, 0.22, 0.6)

    local zoneText = w:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    zoneText:SetPoint("TOPLEFT", sep1, "BOTTOMLEFT", 0, -5)
    zoneText:SetPoint("RIGHT", w, "RIGHT", -10, 0)
    zoneText:SetJustifyH("LEFT")
    zoneText:SetWordWrap(true)
    w.zoneLabel = zoneText

    local routeText = w:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    routeText:SetPoint("TOPLEFT", zoneText, "BOTTOMLEFT", 0, -3)
    routeText:SetPoint("RIGHT", w, "RIGHT", -10, 0)
    routeText:SetJustifyH("LEFT")
    routeText:SetWordWrap(true)
    routeText:SetSpacing(2)
    w.routeText = routeText

    local tipText = w:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    tipText:SetPoint("TOPLEFT", routeText, "BOTTOMLEFT", 0, -2)
    tipText:SetPoint("RIGHT", w, "RIGHT", -10, 0)
    tipText:SetJustifyH("LEFT")
    tipText:SetWordWrap(true)
    w.tipText = tipText

    -- Nav bar
    local navBar = CreateFrame("Frame", nil, w)
    navBar:SetHeight(24)
    navBar:SetPoint("TOPLEFT", tipText, "BOTTOMLEFT", -2, -6)
    navBar:SetPoint("RIGHT", w, "RIGHT", -8, 0)
    w.navBar = navBar

    local prevBtn = CreateFrame("Button", nil, navBar, "BackdropTemplate")
    prevBtn:SetSize(28, 20)
    prevBtn:SetPoint("LEFT")
    prevBtn:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
    prevBtn:SetBackdropColor(0.3, 0.65, 1.0, 0.12)
    prevBtn:SetBackdropBorderColor(0.3, 0.65, 1.0, 0.3)
    local prevL = prevBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    prevL:SetPoint("CENTER"); prevL:SetText("|cff4da6ff<|r")
    local prevHL = prevBtn:CreateTexture(nil, "HIGHLIGHT")
    prevHL:SetAllPoints(); prevHL:SetColorTexture(0.3, 0.65, 1.0, 0.12)
    prevBtn:SetScript("OnClick", function()
        if GG.currentStep > 1 then GG.currentStep = GG.currentStep - 1; PH:UpdateGatheringWidget() end
    end)
    w.prevBtn = prevBtn

    local statusDot = navBar:CreateTexture(nil, "ARTWORK")
    statusDot:SetSize(8, 8)
    statusDot:SetPoint("CENTER", navBar, "CENTER", -20, 0)
    w.statusDot = statusDot

    local statusText = navBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    statusText:SetPoint("LEFT", statusDot, "RIGHT", 4, 0)
    w.statusText = statusText

    local nextBtn = CreateFrame("Button", nil, navBar, "BackdropTemplate")
    nextBtn:SetSize(28, 20)
    nextBtn:SetPoint("RIGHT")
    nextBtn:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
    nextBtn:SetBackdropColor(0.3, 0.65, 1.0, 0.12)
    nextBtn:SetBackdropBorderColor(0.3, 0.65, 1.0, 0.3)
    local nextL = nextBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    nextL:SetPoint("CENTER"); nextL:SetText("|cff4da6ff>|r")
    local nextHL = nextBtn:CreateTexture(nil, "HIGHLIGHT")
    nextHL:SetAllPoints(); nextHL:SetColorTexture(0.3, 0.65, 1.0, 0.12)
    nextBtn:SetScript("OnClick", function()
        if GG.currentStep < #GG.steps then GG.currentStep = GG.currentStep + 1; PH:UpdateGatheringWidget() end
    end)
    w.nextBtn = nextBtn

    w:Hide()
    self.GatherWidget = w
    return w
end

-------------------------------------------------------------------------------
-- Update the floating widget
-------------------------------------------------------------------------------
function PH:UpdateGatheringWidget()
    local w = self.GatherWidget
    if not w or not GG.active then return end

    local step = GG.steps[GG.currentStep]
    if not step then return end

    local currentSkill = self:GetPlayerProfessionLevel(GG.profName)
    local isCurrent  = step.skillRange[1] <= currentSkill and step.skillRange[2] > currentSkill
    local isComplete = step.skillRange[2] <= currentSkill

    w.stepBadge:SetText("|cff888888" .. GG.currentStep .. "/" .. #GG.steps .. "|r")

    if isComplete then
        w.resourceText:SetText("|cff4dda5d\226\156\147|r |cff888888" .. step.resource .. "|r")
    elseif isCurrent then
        w.resourceText:SetText("|cff4dda5d\226\151\143 |r|cffffffff" .. step.resource .. "|r")
    else
        w.resourceText:SetText("|cff4da6ff\226\150\184 |r|cffeeeeee" .. step.resource .. "|r")
    end

    local pct = 0
    if step.skillRange[2] > step.skillRange[1] then
        pct = math.max(0, math.min(1, (currentSkill - step.skillRange[1]) / (step.skillRange[2] - step.skillRange[1])))
    end
    if isComplete then pct = 1 end

    w.skillRangeText:SetText("|cff888888Skill|r " .. step.skillRange[1] .. " |cff888888\226\134\146|r " .. step.skillRange[2] ..
        "  |cff4dda5d" .. math.floor(pct * 100) .. "%|r")

    local tw = w.progressTrack:GetWidth()
    if tw and tw > 0 then
        w.progressFill:SetWidth(math.max(1, tw * pct))
    end
    w.progressTrack:SetScript("OnSizeChanged", function(self)
        local trackW = self:GetWidth()
        if trackW > 0 then
            w.progressFill:SetWidth(math.max(1, trackW * pct))
        end
    end)

    if isComplete then
        w.progressFill:SetColorTexture(0.55, 0.55, 0.60, 1)
    elseif isCurrent then
        w.progressFill:SetColorTexture(0.3, 0.85, 0.45, 1)
    else
        w.progressFill:SetColorTexture(0.3, 0.65, 1.0, 1)
    end

    local inZone = GG:IsPlayerInStepZone(step)
    local matchLoc = GG:GetMatchingLocation(step)
    local bestLoc = GG:GetBestLocation(step)

    if inZone and matchLoc then
        local playerZone = GG:GetPlayerZone()
        w.zoneLabel:SetText("|cff4dda5d\226\150\184 " .. playerZone .. "|r  |cff888888" .. PH.L["GATHERING_HERE"] .. "|r")

        -- Show route info
        local routeInfo = ""
        if GG.currentRoute then
            routeInfo = "|cff4dda5d" .. PH.L["GATHERING_ROUTE_LABEL"] .. "|r " .. string.format(PH.L["GATHERING_ROUTE_INFO"], GG.currentWP, #GG.currentRoute)
        end
        w.routeText:SetText(routeInfo)

        if matchLoc.tips then
            w.tipText:SetText("|cff4dda5d\226\156\166 " .. matchLoc.tips .. "|r")
        else
            w.tipText:SetText("")
        end
    elseif bestLoc then
        w.zoneLabel:SetText("|cffffd700" .. PH.L["GATHERING_GO_TO"] .. "|r |cffffffff" .. bestLoc.zone .. "|r")
        local altZones = {}
        for _, loc in ipairs(step.locations) do
            if loc.zone ~= bestLoc.zone then
                table.insert(altZones, loc.zone)
            end
        end
        if #altZones > 0 then
            w.routeText:SetText("|cff8e8e93" .. PH.L["GATHERING_ALTERNATIVES"] .. " " .. table.concat(altZones, ", ") .. "|r")
        else
            w.routeText:SetText("")
        end
        w.tipText:SetText("")
    else
        w.zoneLabel:SetText("|cff888888" .. PH.L["GATHERING_NO_LOCATIONS"] .. "|r")
        w.routeText:SetText("")
        w.tipText:SetText("")
    end

    w.statusDot:SetColorTexture(inZone and 0.3 or 1.0, inZone and 0.85 or 0.6, inZone and 0.45 or 0.2, 1)
    w.statusText:SetText(inZone and ("|cff4dda5d" .. PH.L["GATHERING_STATUS_ACTIVE"] .. "|r") or ("|cffffa033" .. PH.L["GATHERING_STATUS_TRAVELING"] .. "|r"))

    w.prevBtn:SetAlpha(GG.currentStep > 1 and 1 or 0.3)
    w.nextBtn:SetAlpha(GG.currentStep < #GG.steps and 1 or 0.3)
    if GG.currentStep <= 1 then w.prevBtn:Disable() else w.prevBtn:Enable() end
    if GG.currentStep >= #GG.steps then w.nextBtn:Disable() else w.nextBtn:Enable() end

    C_Timer.After(0, function()
        if not w or not w:IsShown() then return end
        local topY = w:GetTop() or 0
        local navBottom = w.navBar:GetBottom() or 0
        if topY > 0 and navBottom > 0 then
            local contentH = topY - navBottom + 8
            w:SetHeight(math.max(90, contentH))
        end
    end)

    -- Update route + minimap
    GG:UpdateRouteForStep(step)
    w:Show()
end

-------------------------------------------------------------------------------
-- Start / Stop / Toggle
-------------------------------------------------------------------------------
function PH:StartGatheringGuide(profName)
    local profData = self:GetProfessionData(profName)
    if not profData or not profData.farmingLocations then
        print("|cffff6b6b[PH]|r No farming data for " .. (profName or "nil"))
        return
    end

    local currentSkill = self:GetPlayerProfessionLevel(profName)
    GG:BuildSteps(profData, currentSkill)
    if #GG.steps == 0 then
        print("|cffff6b6b[PH]|r No gathering steps found for " .. profName)
        return
    end

    GG.active   = true
    GG.profName = profName
    GG.currentStep = GG:GetCurrentStepIndex(currentSkill)

    local w = self:CreateGatheringWidget()

    local icons = {
        Mining    = "Interface\\Icons\\Trade_Mining",
        Herbalism = "Interface\\Icons\\Trade_Herbalism",
        Skinning  = "Interface\\Icons\\INV_Misc_Pelt_Wolf_01",
        Fishing   = "Interface\\Icons\\Trade_Fishing",
    }
    w.profIcon:SetTexture(icons[profName] or "Interface\\Icons\\INV_Misc_QuestionMark")
    w.titleText:SetText("|cffffffff" .. profName .. " Guide|r")

    StartMinimapUpdater()
    HookWorldMap()
    self:UpdateGatheringWidget()
    w:Show()

    if not self.gatherEventFrame then
        self.gatherEventFrame = CreateFrame("Frame")
    end
    self.gatherEventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    self.gatherEventFrame:RegisterEvent("ZONE_CHANGED")
    self.gatherEventFrame:RegisterEvent("CHAT_MSG_SKILL")
    self.gatherEventFrame:SetScript("OnEvent", function(_, event)
        if not GG.active then return end
        if event == "CHAT_MSG_SKILL" then
            local newSkill = PH:GetPlayerProfessionLevel(GG.profName)
            local newIdx   = GG:GetCurrentStepIndex(newSkill)
            if newIdx ~= GG.currentStep then
                GG.currentStep = newIdx
            end
        end
        PH:UpdateGatheringWidget()
    end)

    if self.gatherTicker then self.gatherTicker:Cancel() end
    self.gatherTicker = C_Timer.NewTicker(3, function()
        if GG.active then
            PH:UpdateGatheringWidget()
        end
    end)

    print("|cff4dda5d[PH]|r Gathering guide started: " .. profName .. " — abra o World Map para ver a rota!")
end

function PH:StopGatheringGuide()
    GG.active = false
    GG:ClearRouteDisplay()
    GG:ClearMinimapArrow()
    StopMinimapUpdater()
    if self.GatherWidget then self.GatherWidget:Hide() end
    if self.gatherEventFrame then self.gatherEventFrame:UnregisterAllEvents() end
    if self.gatherTicker then self.gatherTicker:Cancel(); self.gatherTicker = nil end
    print("|cff888888[PH]|r Gathering guide stopped.")
end

function PH:ToggleGatheringGuide(profName)
    if GG.active and GG.profName == profName then
        self:StopGatheringGuide()
    else
        if GG.active then self:StopGatheringGuide() end
        self:StartGatheringGuide(profName)
    end
end
