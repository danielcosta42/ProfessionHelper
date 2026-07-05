-- Profession Helper - GatherData
--
-- Crowd-sourced gathering-node database. Every time YOU gather a herb or mine an
-- ore, the node's map position is recorded; nodes are shared over the shared mesh
-- (LibChehulMesh) so that simply USING the addon improves everyone's data. The
-- gathering guide then builds ACCURATE routes from real node positions instead of
-- generic hand-drawn loops. (Same idea as GatherMate2's shared database.)
--
-- Storage: ProfessionHelperDB.gatherNodes[mapKey][type][packed] = true
--   type   = "herb" | "ore"
--   packed = floor(x*1000)*1000 + floor(y*1000)  (0.001 map-fraction cell = dedup)

local PH = _G.ProfessionHelper

PH.GatherData = {}
local GD = PH.GatherData

GD.PREFIX = "PHGather"

-- Gather-action spellIDs -> node type (localisation-independent: matched by id).
local GATHER_SPELLS = {
    [2366] = "herb", -- Herb Gathering
    [2383] = "herb", -- Find Herbs is passive; keep the gather action(s)
    [2575] = "ore",  -- Mining
    [2580] = "ore",
}

local function Pack(x, y)
    return math.floor(x * 1000) * 1000 + math.floor(y * 1000)
end

local function Unpack(p)
    return (math.floor(p / 1000)) / 1000, (p % 1000) / 1000
end

-- Record a node (deduped by 0.001 map cell). Broadcasts unless share == false.
function GD:Record(mapID, ntype, x, y, share)
    if not mapID or not ntype or not x or not y or x <= 0 or y <= 0 then return end
    PH.DB:Ensure("gatherNodes")
    local root = PH.DB:Get("gatherNodes")
    if type(root) ~= "table" then return end
    local mk = tostring(mapID)
    root[mk] = root[mk] or {}
    root[mk][ntype] = root[mk][ntype] or {}
    local p = Pack(x, y)
    if root[mk][ntype][p] then return end -- already known
    root[mk][ntype][p] = true
    if share ~= false then
        self:Broadcast(mapID, ntype, x, y)
    end
    PH.Event:Fire("PH_GATHER_NODE", mapID, ntype)
end

-- Baked-in seed payload (Data/GatherSeed.lua): PH.GatherSeed[ntype][mapID] is a
-- string of space-separated packed 0.001 cells. Parsed lazily + cached per zone.
local seedCache = {}
local function SeedNodes(mapID, ntype)
    local seed = PH.GatherSeed
    if type(seed) ~= "table" then return nil end
    local byType = seed[ntype]
    if type(byType) ~= "table" then return nil end
    seedCache[ntype] = seedCache[ntype] or {}
    local cached = seedCache[ntype][mapID]
    if cached ~= nil then return cached or nil end
    local str = byType[mapID]
    if type(str) ~= "string" then seedCache[ntype][mapID] = false; return nil end
    local arr = {}
    for tok in string.gmatch(str, "%d+") do
        local p = tonumber(tok)
        if p then
            local x, y = Unpack(p)
            arr[#arr + 1] = { x, y, p }
        end
    end
    seedCache[ntype][mapID] = arr
    return arr
end

-- All known nodes of a type in a map: array of { x, y } fractions. Merges the
-- live crowd-sourced DB with the baked-in seed, deduped by 0.001 cell.
function GD:GetNodes(mapID, ntype)
    local seen, out = {}, {}
    local root = PH.DB:Get("gatherNodes")
    local set = type(root) == "table" and root[tostring(mapID)] and root[tostring(mapID)][ntype]
    if type(set) == "table" then
        for p in pairs(set) do
            if not seen[p] then
                seen[p] = true
                local x, y = Unpack(p)
                out[#out + 1] = { x, y }
            end
        end
    end
    local seed = SeedNodes(mapID, ntype)
    if seed then
        for _, n in ipairs(seed) do
            if not seen[n[3]] then
                seen[n[3]] = true
                out[#out + 1] = { n[1], n[2] }
            end
        end
    end
    return out
end

function GD:Count(mapID, ntype)
    return #self:GetNodes(mapID, ntype)
end

-- Broadcast a node to mesh peers (guild + nearby). Off via gather_share = false.
function GD:Broadcast(mapID, ntype, x, y)
    if PH.Config:Get("gather_share") == false then return end
    local mesh = _G.ChehulMesh
    if not mesh then return end
    local payload = table.concat({
        "GN1", mapID, ntype, math.floor(x * 10000), math.floor(y * 10000),
    }, "|")
    mesh:Guild(GD.PREFIX, payload)
    mesh:Proximity(GD.PREFIX, payload)
end

-- A peer's node arrives over the mesh: store it (never re-broadcast).
function GD:OnNet(payload)
    if type(payload) ~= "string" then return end
    local proto, mapID, ntype, xi, yi = strsplit("|", payload)
    if proto ~= "GN1" then return end
    mapID, xi, yi = tonumber(mapID), tonumber(xi), tonumber(yi)
    if mapID and ntype and xi and yi then
        self:Record(mapID, ntype, xi / 10000, yi / 10000, false)
    end
end

function GD:Initialize()
    PH.DB:Ensure("gatherNodes")

    -- Collect: record the player's position whenever a gather action succeeds.
    PH.Event:On("UNIT_SPELLCAST_SUCCEEDED", function(_, unit, _castGUID, spellID)
        if unit ~= "player" then return end
        local ntype = GATHER_SPELLS[spellID]
        if not ntype then return end
        local mapID = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
        if not mapID then return end
        local pos = C_Map.GetPlayerMapPosition and C_Map.GetPlayerMapPosition(mapID, "player")
        if not pos then return end
        local x, y = pos:GetXY()
        if x and y then
            self:Record(mapID, ntype, x, y, true)
        end
    end, "GatherData")

    -- Receive peer nodes over the shared mesh.
    if _G.ChehulMesh then
        _G.ChehulMesh:Register(GD.PREFIX, function(payload) self:OnNet(payload) end)
    end
end
