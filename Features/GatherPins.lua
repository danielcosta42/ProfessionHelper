-- Profession Helper - Live Gather Node Pins
--
-- Shows the crowd-sourced herb/ore/skin/fish nodes (baked-in Wowhead seed + nodes
-- collected by you and the mesh) as coloured pins on whatever zone the world map is
-- showing — a built-in live node map, like GatherMate2 but fed by PH's own shared
-- data. Display-only (no per-pin tooltip: hundreds of pins, colour = the node type).
-- Toggle with /ph pins.

local PH = _G.ProfessionHelper
PH.GatherPins = {}
local GP = PH.GatherPins

local DOT_TEX = "Interface\\AddOns\\ProfessionHelper\\Media\\route-dot.tga"
local MAX_PINS = 600 -- safety cap so a dense multi-type zone can't spam frames

-- Node type -> colour (matches the /ph pins legend text).
local NODE = {
    herb = { 0.36, 0.86, 0.40 },
    ore  = { 0.95, 0.58, 0.22 },
    skin = { 0.80, 0.58, 0.36 },
    fish = { 0.34, 0.72, 1.00 },
}
local ORDER = { "herb", "ore", "skin", "fish" }
local REF = "PHGatherPins"

local HBD, HBDPins
local function GetHBD()
    if HBD then return HBD, HBDPins end
    if LibStub then
        local ok1, l1 = pcall(LibStub, "HereBeDragons-2.0")
        if ok1 and l1 then HBD = l1 end
        local ok2, l2 = pcall(LibStub, "HereBeDragons-Pins-2.0")
        if ok2 and l2 then HBDPins = l2 end
    end
    return HBD, HBDPins
end

local pool, active = {}, {}
local function AcquirePin(ntype)
    local f = table.remove(pool)
    if not f then
        f = CreateFrame("Frame", nil, UIParent)
        f:SetFrameStrata("HIGH") -- same strata the route trail uses (renders on the map canvas)
        f:SetFrameLevel(90)      -- just under the route (trail 100 / waypoints 200)
        f:SetSize(9, 9)

        local shadow = f:CreateTexture(nil, "BACKGROUND")
        shadow:SetPoint("TOPLEFT", -1.5, 1.5)
        shadow:SetPoint("BOTTOMRIGHT", 1.5, -1.5)
        shadow:SetTexture(DOT_TEX)
        shadow:SetVertexColor(0, 0, 0, 0.55)

        local tex = f:CreateTexture(nil, "ARTWORK")
        tex:SetAllPoints()
        tex:SetTexture(DOT_TEX)
        f.tex = tex
    end
    local c = NODE[ntype]
    f.tex:SetVertexColor(c[1], c[2], c[3], 1)
    f:Show()
    return f
end

function GP:Clear()
    local _, pins = GetHBD()
    if pins then pins:RemoveAllWorldMapIcons(REF) end
    for _, f in ipairs(active) do
        f:Hide()
        pool[#pool + 1] = f
    end
    wipe(active)
end

-- Plot every known node of every type for one zone map. showFlag 0 keeps them on
-- this exact map (we re-plot on navigation), so continent view stays uncluttered.
function GP:Plot(mapID)
    self:Clear()
    if not mapID or not PH.GatherData then return end
    local _, pins = GetHBD()
    if not pins then return end

    local n = 0
    for _, ntype in ipairs(ORDER) do
        local nodes = PH.GatherData:GetNodes(mapID, ntype)
        for _, node in ipairs(nodes) do
            if n >= MAX_PINS then return end
            local f = AcquirePin(ntype)
            pins:AddWorldMapIconMap(REF, f, mapID, node[1], node[2], 0)
            active[#active + 1] = f
            n = n + 1
        end
    end
end

-- Re-plot for whatever the world map is currently showing (if enabled + open).
function GP:Refresh()
    if PH.Config:Get("nodePins") ~= true then
        self:Clear()
        return
    end
    if not (WorldMapFrame and WorldMapFrame.IsShown and WorldMapFrame:IsShown()) then
        self:Clear()
        return
    end
    local mapID = WorldMapFrame.GetMapID and WorldMapFrame:GetMapID()
    if mapID then self:Plot(mapID) end
end

function GP:SetEnabled(on)
    PH.Config:Set("nodePins", on and true or false)
    self:Refresh()
end

function GP:Toggle()
    self:SetEnabled(PH.Config:Get("nodePins") ~= true)
    return PH.Config:Get("nodePins") == true
end

function GP:Initialize()
    if not WorldMapFrame then return end
    -- Re-plot whenever the map navigates to another zone, and when it opens.
    if WorldMapFrame.SetMapID and hooksecurefunc and not self._hookedNav then
        self._hookedNav = true
        hooksecurefunc(WorldMapFrame, "SetMapID", function() GP:Refresh() end)
    end
    if WorldMapFrame.HookScript and not self._hookedShow then
        self._hookedShow = true
        WorldMapFrame:HookScript("OnShow", function() GP:Refresh() end)
    end
end
