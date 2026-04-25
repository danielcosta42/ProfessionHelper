-- Profession Helper - Map Pins System
-- Displays POI pins (vendors, quest-givers, fishing spots) on the world map
-- Uses HereBeDragons-Pins-2.0, same library as GatheringGuide.lua

local PH = ProfessionHelper
PH.MapPins = {}
local MP = PH.MapPins

-------------------------------------------------------------------------------
-- HBD / HBDPins access (mirrored from GatheringGuide.lua)
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
-- Zone map ID cache
-------------------------------------------------------------------------------
local ZONE_MAP_IDS = {}
local builtIDs = false

local function BuildZoneMapIDs()
    if builtIDs then return end
    builtIDs = true

    local hbd = GetHBD()
    if hbd then
        local allMaps = hbd:GetAllMapIDs()
        if allMaps then
            for _, mapID in ipairs(allMaps) do
                local name = hbd:GetLocalizedMap(mapID)
                -- No size filter: we need city zones (Stormwind, Shattrath, etc.)
                -- which may report w=0 in HBD but still have valid coords
                if name and name ~= "" then
                    ZONE_MAP_IDS[name] = mapID
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
-- NPC coordinate database
-- [NPC Name] = { zone = "ZoneName", x = 0-1, y = 0-1, type = "vendor"|"quest" }
-- Coordinates are zone-map fractions (0,0 = top-left, 1,1 = bottom-right)
-------------------------------------------------------------------------------
local NPC_COORDS = {
    -- ========== COOKING ==========
    ["Andrew Hilbert"]        = { zone = "Silverpine Forest",       x = 0.459, y = 0.670, type = "vendor" },  -- The Sepulcher
    ["Drac Roughcut"]         = { zone = "Loch Modan",              x = 0.326, y = 0.408, type = "vendor" },  -- Thelsamar inn
    ["Kendor Kabonka"]        = { zone = "Stormwind City",          x = 0.632, y = 0.260, type = "vendor" },  -- Stonefire Tavern, Dwarven District
    ["Keena"]                 = { zone = "Arathi Highlands",        x = 0.744, y = 0.415, type = "vendor" },  -- Hammerfall (Horde)
    ["Hammon Karwn"]          = { zone = "Stranglethorn Vale",      x = 0.420, y = 0.142, type = "vendor" },  -- Nesingwary's Expedition
    ["Himmik"]                = { zone = "Winterspring",            x = 0.602, y = 0.358, type = "vendor" },  -- Everlook
    ["Bale"]                  = { zone = "Felwood",                 x = 0.428, y = 0.566, type = "vendor" },  -- Bloodvenom Post (Horde)
    ["Malygen"]               = { zone = "Felwood",                 x = 0.518, y = 0.724, type = "vendor" },  -- Talonbranch Glade (Alliance)
    ["Gikkix"]                = { zone = "Tanaris",                 x = 0.674, y = 0.224, type = "vendor" },  -- Steamwheedle Port
    ["Cookie One-Eye"]        = { zone = "Hellfire Peninsula",      x = 0.552, y = 0.354, type = "vendor" },  -- Thrallmar (Horde)
    ["Sid Limbardi"]          = { zone = "Hellfire Peninsula",      x = 0.540, y = 0.638, type = "vendor" },  -- Honor Hold (Alliance)
    ["Nula the Butcher"]      = { zone = "Nagrand",                 x = 0.580, y = 0.357, type = "vendor" },  -- Garadar (Horde)
    ["Uriku"]                 = { zone = "Nagrand",                 x = 0.566, y = 0.422, type = "vendor" },  -- Garadar area
    ["Innkeeper Grilka"]      = { zone = "Nagrand",                 x = 0.564, y = 0.420, type = "vendor" },  -- Garadar inn (Horde)
    ["Supply Officer Mills"]  = { zone = "Terokkar Forest",         x = 0.544, y = 0.554, type = "vendor" },  -- Allerian Stronghold (Alliance)
    ["Xerintha Ravenoak"]     = { zone = "Blade's Edge Mountains",  x = 0.418, y = 0.670, type = "vendor" },  -- Sylvanaar (Alliance)
    ["Sassa Weldwell"]        = { zone = "Blade's Edge Mountains",  x = 0.500, y = 0.584, type = "vendor" },  -- Thunderlord Stronghold (Horde)
    ["Sheendra Tallgrass"]    = { zone = "Feralas",                 x = 0.762, y = 0.446, type = "vendor" },  -- Camp Mojache (Horde)
    ["Vivianna"]              = { zone = "Feralas",                 x = 0.310, y = 0.440, type = "vendor" },  -- Feathermoon Stronghold (Alliance)
    ["Kelsey Yance"]          = { zone = "Stranglethorn Vale",      x = 0.272, y = 0.774, type = "vendor" },  -- Booty Bay
    ["Calandrath"]            = { zone = "Silithus",                x = 0.522, y = 0.362, type = "quest"  },  -- Cenarion Hold
    ["Desert Recipe"]         = { zone = "Silithus",                x = 0.522, y = 0.362, type = "quest"  },  -- Cenarion Hold
    ["Zurai"]                 = { zone = "Zangarmarsh",             x = 0.802, y = 0.660, type = "vendor" },  -- Swamprat Post (Horde, NE)
    ["Doba"]                  = { zone = "Zangarmarsh",             x = 0.800, y = 0.658, type = "vendor" },  -- Swamprat Post (Horde, NE)
    ["Juno Dufrain"]          = { zone = "Zangarmarsh",             x = 0.786, y = 0.638, type = "vendor" },  -- Cenarion Refuge (neutral, E)
    ["Innkeeper Biribi"]      = { zone = "Terokkar Forest",         x = 0.534, y = 0.426, type = "vendor" },  -- Stonebreaker Hold (Horde)
    ["Rungor"]                = { zone = "Terokkar Forest",         x = 0.532, y = 0.424, type = "vendor" },  -- Stonebreaker Hold (Horde)

    -- ========== ENGINEERING ==========
    ["Viggz Shinesparked"]    = { zone = "Shattrath City",          x = 0.652, y = 0.699, type = "vendor" },  -- Lower City
    ["Xizzer Fizzbolt"]       = { zone = "Winterspring",            x = 0.592, y = 0.350, type = "vendor" },  -- Everlook
    ["Wind Trader Lathrai"]   = { zone = "Shattrath City",          x = 0.720, y = 0.310, type = "vendor" },  -- Lower City (near World's End Tavern)
    ["Feera"]                 = { zone = "Exodar",                  x = 0.542, y = 0.446, type = "vendor" },  -- Traders' Tier
    ["Yatheon"]               = { zone = "Silvermoon City",         x = 0.710, y = 0.246, type = "vendor" },  -- Royal Exchange
    ["Lebowski"]              = { zone = "Hellfire Peninsula",      x = 0.544, y = 0.640, type = "vendor" },  -- Honor Hold (Alliance)
    ["Captured Gnome"]        = { zone = "Zangarmarsh",             x = 0.196, y = 0.546, type = "vendor" },  -- Sporeggar area (SW)
    ["Crazk Sparks"]          = { zone = "Stranglethorn Vale",      x = 0.274, y = 0.774, type = "vendor" },  -- Booty Bay

    -- ========== ALCHEMY ==========
    ["Haalrun"]               = { zone = "Zangarmarsh",             x = 0.676, y = 0.508, type = "vendor" },  -- Telredor (Alliance)
    ["Daga Ramba"]            = { zone = "Blade's Edge Mountains",  x = 0.500, y = 0.582, type = "vendor" },  -- Thunderlord Stronghold (Horde)
    ["Leeli Longhaggle"]      = { zone = "Terokkar Forest",         x = 0.546, y = 0.552, type = "vendor" },  -- Allerian Stronghold (Alliance)
    ["Nakodu"]                = { zone = "Shattrath City",          x = 0.620, y = 0.688, type = "vendor" },  -- Lower City
    ["Halaa Research Token"]  = { zone = "Nagrand",                 x = 0.408, y = 0.478, type = "vendor" },  -- Halaa (center Nagrand)

    -- ========== BLACKSMITHING ==========
    ["Fedryen Swiftspear"]    = { zone = "Zangarmarsh",             x = 0.790, y = 0.640, type = "vendor" },  -- Cenarion Refuge (E)
    ["Derotain Mudsipper"]    = { zone = "Tanaris",                 x = 0.516, y = 0.280, type = "quest"  },  -- Gadgetzan

    -- ========== FIRST AID ==========
    ["Deneb Walker"]          = { zone = "Arathi Highlands",        x = 0.374, y = 0.462, type = "vendor" },  -- Refuge Pointe (Alliance)
    ["Balai Lok'Wein"]        = { zone = "Dustwallow Marsh",        x = 0.296, y = 0.322, type = "vendor" },  -- Brackenwall Village (Horde)
    ["Burko"]                 = { zone = "Hellfire Peninsula",      x = 0.550, y = 0.356, type = "vendor" },  -- Thrallmar (Horde)
    ["Aresella"]              = { zone = "Hellfire Peninsula",      x = 0.538, y = 0.650, type = "vendor" },  -- Honor Hold (Alliance)

    -- ========== ENCHANTING ==========
    ["Dalria"]                = { zone = "Ashenvale",               x = 0.352, y = 0.486, type = "vendor" },  -- Astranaar (Alliance)
    ["Daniel Bartlett"]       = { zone = "Undercity",               x = 0.626, y = 0.372, type = "vendor" },  -- Magic Quarter
    ["Madame Ruby"]           = { zone = "Shattrath City",          x = 0.648, y = 0.700, type = "vendor" },  -- Lower City
    ["Rina Dulmare"]          = { zone = "Shattrath City",          x = 0.372, y = 0.268, type = "vendor" },  -- Aldor Rise

    -- ========== JEWELCRAFTING ==========
    ["Jandia"]                = { zone = "Thousand Needles",        x = 0.414, y = 0.248, type = "vendor" },  -- Freewind Post (Horde mesa, NW)
    ["Neal Allen"]            = { zone = "Wetlands",                x = 0.086, y = 0.586, type = "vendor" },  -- Menethil Harbor
    ["Kireena"]               = { zone = "Desolace",                x = 0.212, y = 0.744, type = "vendor" },  -- Shadowprey Village (Horde, SW coast)
    ["Micha Yance"]           = { zone = "Hillsbrad Foothills",     x = 0.520, y = 0.586, type = "vendor" },  -- Southshore
    ["Karaaz"]                = { zone = "Netherstorm",             x = 0.324, y = 0.674, type = "vendor" },  -- Area 52 (SW Netherstorm)

    -- ========== LEATHERWORKING ==========
    ["Cro Threadstrong"]      = { zone = "Shattrath City",          x = 0.632, y = 0.710, type = "vendor" },  -- Lower City
    ["Almaador"]              = { zone = "Shattrath City",          x = 0.546, y = 0.378, type = "vendor" },  -- Terrace of Light (Sha'tar)

    -- ========== TAILORING ==========
    ["Eiin"]                  = { zone = "Shattrath City",          x = 0.650, y = 0.680, type = "vendor" },  -- Lower City
    ["Arrond"]                = { zone = "Shadowmoon Valley",       x = 0.336, y = 0.306, type = "vendor" },  -- Shadowmoon Village (Horde)

    -- ========== SKINNING ==========
    ["Thuwd"]                 = { zone = "The Barrens",             x = 0.474, y = 0.594, type = "trainer" }, -- Camp Taurajo

    -- ========== FISHING / FISHINGCOOKING ==========
    ["Nat Pagle"]             = { zone = "Dustwallow Marsh",        x = 0.628, y = 0.530, type = "quest"  },  -- Nat's Landing (island E of Theramore)
    ["Old Man Heming"]        = { zone = "Stranglethorn Vale",      x = 0.270, y = 0.772, type = "quest"  },  -- Booty Bay docks
    ["Dirge Quikcleave"]      = { zone = "Tanaris",                 x = 0.514, y = 0.282, type = "quest"  },  -- Gadgetzan
    ["Clamlette Surprise"]    = { zone = "Tanaris",                 x = 0.514, y = 0.282, type = "quest"  },  -- Gadgetzan
}

-------------------------------------------------------------------------------
-- Fishing spot coordinates by zone name
-- Specific water-body locations within each zone for fishing
-------------------------------------------------------------------------------
local FISHING_SPOTS = {
    ["The Barrens"]                              = { x = 0.48, y = 0.28 },  -- Forgotten Pools
    ["Wetlands"]                                 = { x = 0.18, y = 0.57 },  -- Menethil coast
    ["Hillsbrad Foothills"]                      = { x = 0.48, y = 0.68 },  -- Southshore coast
    ["Stranglethorn Vale"]                       = { x = 0.27, y = 0.77 },  -- Booty Bay coast
    ["Dustwallow Marsh"]                         = { x = 0.55, y = 0.27 },  -- Nat Pagle area
    ["Arathi Highlands"]                         = { x = 0.47, y = 0.32 },  -- Inland lakes
    ["Desolace"]                                 = { x = 0.28, y = 0.74 },  -- Coast
    ["Alterac Mountains / Swamp of Sorrows"]     = { x = 0.43, y = 0.60 },  -- Eastern lake
    ["Felwood"]                                  = { x = 0.43, y = 0.45 },  -- Rivers
    ["Feralas"]                                  = { x = 0.56, y = 0.58 },  -- Lakes
    ["The Hinterlands"]                          = { x = 0.49, y = 0.49 },  -- Inland lakes
    ["Tanaris"]                                  = { x = 0.65, y = 0.24 },  -- Steamwheedle coast
    ["Un'Goro Crater"]                           = { x = 0.50, y = 0.53 },  -- Central river
    ["Western Plaguelands"]                      = { x = 0.58, y = 0.53 },  -- Darrowmere Lake
    ["Zangarmarsh"]                              = { x = 0.50, y = 0.50 },  -- Serpent Lake
    ["Terokkar Forest"]                          = { x = 0.59, y = 0.70 },  -- Blackwind Lake
    ["Nagrand"]                                  = { x = 0.36, y = 0.38 },  -- Skysong Lake
    ["Terokkar Forest - Highland Mixed Schools"] = { x = 0.57, y = 0.57 },  -- Highland pools
}

-------------------------------------------------------------------------------
-- Pin management
-------------------------------------------------------------------------------
local POI_REF_KEY  = "PHPOIPins"
local poiFrames    = {}
local poiFramePool = {}

-- Pin type → vertex color {r, g, b}
local PIN_COLORS = {
    vendor  = { 1.0,  0.82, 0.0  },  -- gold
    quest   = { 1.0,  0.60, 0.10 },  -- orange
    fishing = { 0.20, 0.85, 1.0  },  -- cyan
    trainer = { 0.50, 0.80, 1.0  },  -- light blue
}

-- Create (or recycle) a POI pin frame
local function CreatePOIPin(label, pinType)
    local f = table.remove(poiFramePool)
    if not f then
        f = CreateFrame("Frame", nil, UIParent)
        f:SetFrameStrata("TOOLTIP")
        f:SetFrameLevel(210)
        f:SetSize(18, 18)

        -- Dark border/shadow
        local bg = f:CreateTexture(nil, "BORDER")
        bg:SetPoint("TOPLEFT", -2, 2)
        bg:SetPoint("BOTTOMRIGHT", 2, -2)
        bg:SetTexture("Interface\\Buttons\\WHITE8X8")
        bg:SetVertexColor(0, 0, 0, 0.85)
        f.bg = bg

        -- Colored circle
        local tex = f:CreateTexture(nil, "ARTWORK")
        tex:SetAllPoints()
        tex:SetTexture("Interface\\Buttons\\WHITE8X8")
        f.tex = tex

        -- Inner icon overlay (vendor bag icon hint)
        local icon = f:CreateTexture(nil, "OVERLAY")
        icon:SetSize(10, 10)
        icon:SetPoint("CENTER", 0, 0)
        icon:SetTexture("Interface\\Minimap\\TRACKING\\Mailbox")
        icon:SetVertexColor(0, 0, 0, 0.7)
        f.icon = icon

        f:SetScript("OnEnter", function(self)
            if self.poiLabel then
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:AddLine(self.poiLabel, 1, 1, 1, true)
                GameTooltip:Show()
            end
        end)
        f:SetScript("OnLeave", function() GameTooltip:Hide() end)
    end

    local c = PIN_COLORS[pinType] or PIN_COLORS.vendor
    f.tex:SetVertexColor(c[1], c[2], c[3], 0.95)
    f.poiLabel = label
    f:Show()
    return f
end

-------------------------------------------------------------------------------
-- Source string parser
-- Handles: "Vendor: NPC1 (Zone) / NPC2 (Zone, Faction)"
--          "Quest: QuestName (Zone — NPC)"
--          "Quest: NPCName (Zone)"
-------------------------------------------------------------------------------
function MP:GetPinsForSource(sourceStr)
    if not sourceStr or sourceStr == "" then return {} end

    -- Only handle Vendor: and Quest: prefixes
    local prefix, content = sourceStr:match("^([Vv]endor):%s*(.+)$")
    if not prefix then
        prefix, content = sourceStr:match("^([Qq]uest):%s*(.+)$")
    end
    if not content then return {} end

    local pinType = (prefix:lower() == "vendor") and "vendor" or "quest"
    local pins = {}

    -- Split on " / " to get individual NPC entries
    for entry in (content .. " /"):gmatch("(.-)%s*/%s*") do
        -- Trim whitespace
        entry = entry:match("^%s*(.-)%s*$")
        -- Strip trailing notes like " — 5g" or " — Expert First Aid book"
        entry = entry:match("^(.-)%s+%—.+$") or entry
        entry = entry:match("^(.-)%s+%-.-%s*$") or entry  -- strip " - note" if no em dash

        -- Extract NPC name = everything before the first "("
        local npcName = entry:match("^(.-)%s*%(") or entry
        npcName = npcName:match("^%s*(.-)%s*$")  -- trim

        if npcName and npcName ~= "" then
            local coords = NPC_COORDS[npcName]
            if coords then
                table.insert(pins, {
                    name    = npcName,
                    zone    = coords.zone,
                    x       = coords.x,
                    y       = coords.y,
                    pinType = coords.type or pinType,
                })
            end
        end
    end

    return pins
end

-- Returns true if any pins are known for the given source string
function MP:HasPinsForSource(sourceStr)
    return #self:GetPinsForSource(sourceStr) > 0
end

-- Get fishing spot pin for a zone name
function MP:GetFishingPin(zoneName)
    local spot = FISHING_SPOTS[zoneName]
    if not spot then return nil end
    return {
        name    = zoneName,
        zone    = zoneName,
        x       = spot.x,
        y       = spot.y,
        pinType = "fishing",
    }
end

-- Returns true if a known fishing spot exists for the zone
function MP:HasFishingSpot(zoneName)
    return FISHING_SPOTS[zoneName] ~= nil
end

-------------------------------------------------------------------------------
-- Clear all POI pins from the world map
-------------------------------------------------------------------------------
function MP:ClearPins()
    local _, pins = GetHBD()
    if pins then
        pins:RemoveAllWorldMapIcons(POI_REF_KEY)
    end
    for _, f in ipairs(poiFrames) do
        f:Hide()
        table.insert(poiFramePool, f)
    end
    wipe(poiFrames)
end

-------------------------------------------------------------------------------
-- Show a list of POI pins on the world map and open it
-------------------------------------------------------------------------------
-- NOTE: HBD_PINS_WORLDMAP_SHOW_PARENT (1) is defined in all HBD versions.
-- HBD_PINS_WORLDMAP_SHOW_CURRENT (-1) only exists in Questie's patched HBD
-- and is silently ignored by GatherMate2's HBD, causing pins to never appear.
function MP:ShowPins(pinsList)
    self:ClearPins()
    if not pinsList or #pinsList == 0 then return end

    BuildZoneMapIDs()
    local hbd, pins = GetHBD()
    if not hbd or not pins then return end

    -- Refresh flag now that libs are loaded
    local showFlag = HBD_PINS_WORLDMAP_SHOW_PARENT or 1

    -- Collect map IDs for all pins
    local firstMapID = nil
    local pinData = {}
    for _, poi in ipairs(pinsList) do
        local mapID = ZONE_MAP_IDS[poi.zone]
        if mapID then
            if not firstMapID then firstMapID = mapID end
            table.insert(pinData, { poi = poi, mapID = mapID })
        end
    end

    -- STEP 1: Open the world map first so it's visible before navigating
    if WorldMapFrame and not WorldMapFrame:IsVisible() then
        ToggleWorldMap()
    end

    -- STEP 2: Navigate to the target zone BEFORE adding pins.
    -- HandlePin is called immediately inside AddWorldMapIconMap and checks the
    -- current displayed map ID. Navigating first ensures uiMapID == data.uiMapID
    -- so the pin renders right away without waiting for RefreshAllData.
    if firstMapID and WorldMapFrame then
        if WorldMapFrame.SetMapID then
            WorldMapFrame:SetMapID(firstMapID)
        elseif WorldMapFrame_SetDisplayedMapByID then
            WorldMapFrame_SetDisplayedMapByID(firstMapID)
        end
    end

    -- STEP 3: Now add pins (HandlePin fires with the correct map ID)
    for _, pd in ipairs(pinData) do
        local poi = pd.poi
        local label = poi.name
        if poi.pinType == "fishing" then
            label = poi.zone .. " - Ponto de Pesca"
        end
        local f = CreatePOIPin(label, poi.pinType)
        pins:AddWorldMapIconMap(POI_REF_KEY, f, pd.mapID, poi.x, poi.y, showFlag)
        table.insert(poiFrames, f)
    end
end

-- Convenience: parse source string and display pins on map
function MP:ShowSourcePins(sourceStr)
    local pins = self:GetPinsForSource(sourceStr)
    self:ShowPins(pins)
end

-- Show fishing spot pin for a zone
function MP:ShowFishingSpot(zoneName)
    local pin = self:GetFishingPin(zoneName)
    if pin then
        self:ShowPins({ pin })
    end
end
