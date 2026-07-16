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

-- Gather-action spells -> node type. Matched by spellID (fast path) OR by localized
-- spell NAME (rank/locale-independent — Fishing has many ranks). IDs verified against
-- GatherMate2's Collector (herb 2366, mining 2575); Skinning 8613 and Fishing 7620
-- are added here because GatherMate2 doesn't track them (mob-/water-based, no map seed).
local GATHER_IDS = {
    [2366] = "herb", -- Herb Gathering
    [2575] = "ore",  -- Mining
    [8613] = "skin", -- Skinning
    [7620] = "fish", -- Fishing (all ranks share the name "Fishing")
}
local gatherByName -- { [localizedSpellName] = ntype }, built once at init

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

-- Broadcast a freshly-collected node to mesh peers over the SILENT addon buses only:
-- Guild + group + nearby (SAY). Realm-wide reach deliberately does NOT ride here.
-- :Realm is a zone-wide YELL, and YELL is PUBLIC chat — governed by the client's strict
-- chat-message rate limit, which ChatThrottleLib does NOT model (it only paces the addon
-- byte-throttle). Gathering fires many distinct nodes fast, and each used the payload as
-- its own realm-queue key, so the queue piled up and flushed as a YELL burst -> a flood
-- of "The number of messages that can be sent is limited". Seedless (skin/fish) nodes get
-- their realm propagation from AmbientSync instead (bounded + coalesced); herb/ore already
-- ship in the baked seed, so they need no realm gossip at all. Off via gather_share = false.
function GD:Broadcast(mapID, ntype, x, y)
    if PH.Config:Get("gather_share") == false then return end
    local mesh = _G.ChehulMesh
    if not mesh then return end
    local payload = table.concat({
        "GN1", mapID, ntype, math.floor(x * 10000), math.floor(y * 10000),
    }, "|")
    mesh:Guild(GD.PREFIX, payload)
    mesh:Group(GD.PREFIX, payload)
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

-- Seedless node types (skin/fish have no baked-in Wowhead data) rely entirely on
-- crowd-sourcing, so periodically radiate a small rotating window of the CURRENT
-- zone's collected ones over the realm bus — the accumulated DB converges for
-- everyone actually there. Herb/ore are skipped: everyone already ships the seed,
-- so re-broadcasting them would be pure redundant traffic.
local AMBIENT_TYPES = { skin = true, fish = true }
local AMBIENT_BATCH = 2 -- YELLs per 30s cycle; kept small because YELL is public-chat-throttled
GD._ambientCursor = 0

function GD:AmbientSync()
    if PH.Config:Get("gather_share") == false then return end
    local mesh = _G.ChehulMesh
    if not mesh or not (C_Map and C_Map.GetBestMapForUnit) then return end
    local mapID = C_Map.GetBestMapForUnit("player")
    if not mapID then return end
    local root = PH.DB:Get("gatherNodes")
    local byType = type(root) == "table" and root[tostring(mapID)]
    if type(byType) ~= "table" then return end

    -- Flatten this zone's seedless nodes into a stable, ordered list.
    local list = {}
    for t in pairs(AMBIENT_TYPES) do
        local set = byType[t]
        if type(set) == "table" then
            for p in pairs(set) do list[#list + 1] = { t, p } end
        end
    end
    if #list == 0 then return end
    table.sort(list, function(a, b)
        if a[1] ~= b[1] then return a[1] < b[1] end
        return a[2] < b[2]
    end)

    -- Radiate a small rotating window realm-wide. CRUCIAL: pass a STABLE per-slot coalesce
    -- key so these occupy at most AMBIENT_BATCH slots in the shared realm queue (each cycle
    -- overwrites the same slots) instead of one-slot-per-distinct-node. Without a key the
    -- queue key defaults to the payload, so every node piled up and FlushRealm dumped the
    -- whole heap as a YELL burst — the chat-rate flood this addon used to cause.
    for i = 1, math.min(AMBIENT_BATCH, #list) do
        GD._ambientCursor = (GD._ambientCursor % #list) + 1
        local item = list[GD._ambientCursor]
        local x, y = Unpack(item[2])
        mesh:Realm(GD.PREFIX, table.concat({
            "GN1", mapID, item[1], math.floor(x * 10000), math.floor(y * 10000),
        }, "|"), GD.PREFIX .. ":amb" .. i)
    end
end

function GD:Initialize()
    PH.DB:Ensure("gatherNodes")

    -- Localized-name lookup so ranked/localized casts (esp. Fishing) still match.
    gatherByName = {}
    for id, t in pairs(GATHER_IDS) do
        local n = GetSpellInfo(id)
        if n then gatherByName[n] = t end
    end

    -- Collect: record the player's position whenever a gather action succeeds.
    PH.Event:On("UNIT_SPELLCAST_SUCCEEDED", function(_, unit, _castGUID, spellID)
        if unit ~= "player" then return end
        local ntype = GATHER_IDS[spellID]
        if not ntype and spellID then
            local n = GetSpellInfo(spellID)
            if n then ntype = gatherByName[n] end
        end
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

    -- Ambient realm-wide sync of seedless nodes for wherever the player is (bounded).
    if C_Timer and C_Timer.NewTicker and not self._ambientTicker then
        self._ambientTicker = C_Timer.NewTicker(30, function() self:AmbientSync() end)
    end
end
