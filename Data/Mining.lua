-- Profession Helper - Mining Data (Gathering Profession)
ProfessionHelper = ProfessionHelper or {}
ProfessionHelper.Mining = {
    name = "Mining",
    type = "gathering",
    
    trainer = {
        ["Alliance"] = {
            "Gelman Stonehand (Stormwind)",
            "Geofram Bouldertoe (Ironforge)",
            "Matt Johnson (Darnassus)",
            "Hurnak Grimmord (Shattrath)",
        },
        ["Horde"] = {
            "Makaru (Orgrimmar)",
            "Brom Killian (Undercity)",
            "Brek Stonehoof (Thunder Bluff)",
            "Hurnak Grimmord (Shattrath)",
        },
    },
    
    skillRanges = {
        {
            ore = "Copper Ore",
            skillRequired = 1,
            skillYellow = 25,
            skillGreen = 50,
            skillGrey = 100,
        },
        {
            ore = "Tin Ore",
            skillRequired = 65,
            skillYellow = 90,
            skillGreen = 115,
            skillGrey = 165,
        },
        {
            ore = "Silver Ore",
            skillRequired = 75,
            skillYellow = 100,
            skillGreen = 125,
            skillGrey = 175,
        },
        {
            ore = "Iron Ore",
            skillRequired = 125,
            skillYellow = 150,
            skillGreen = 175,
            skillGrey = 225,
        },
        {
            ore = "Gold Ore",
            skillRequired = 155,
            skillYellow = 180,
            skillGreen = 205,
            skillGrey = 255,
        },
        {
            ore = "Mithril Ore",
            skillRequired = 175,
            skillYellow = 200,
            skillGreen = 225,
            skillGrey = 275,
        },
        {
            ore = "Truesilver Ore",
            skillRequired = 230,
            skillYellow = 255,
            skillGreen = 280,
            skillGrey = 330,
        },
        {
            ore = "Thorium Ore",
            skillRequired = 245,
            skillYellow = 270,
            skillGreen = 295,
            skillGrey = 345,
        },
        {
            ore = "Rich Thorium Ore",
            skillRequired = 275,
            skillYellow = 300,
            skillGreen = 325,
            skillGrey = 375,
        },
        -- TBC Ores
        {
            ore = "Fel Iron Ore",
            skillRequired = 300,
            skillYellow = 325,
            skillGreen = 350,
            skillGrey = 400,
        },
        {
            ore = "Adamantite Ore",
            skillRequired = 325,
            skillYellow = 350,
            skillGreen = 375,
            skillGrey = 400,
        },
        {
            ore = "Rich Adamantite Ore",
            skillRequired = 350,
            skillYellow = 375,
            skillGreen = 400,
            skillGrey = 425,
        },
        {
            ore = "Khorium Ore",
            skillRequired = 375,
            skillYellow = 400,
            skillGreen = 425,
            skillGrey = 450,
        },
    },
    
    farmingLocations = {
        -- ==================== COPPER (1-65) ====================
        {
            skillRange = {1, 65},
            ore = "Copper Ore",
            locations = {
                {
                    zone = "Durotar",
                    faction = "Horde",
                    route = "Circle the eastern coast of Durotar, heading south from Orgrimmar to Sen'jin Village, then north along the coast to Skull Rock.",
                    tips = ProfessionHelper.L["MINING_LOC_1_TIP"],
                    levelRange = "1-10",
                },
                {
                    zone = "Elwynn Forest",
                    faction = "Alliance",
                    route = "Loop around Goldshire, passing through Fargodeep Mine and Jasperlode Mine.",
                    tips = ProfessionHelper.L["MINING_LOC_2_TIP"],
                    levelRange = "1-10",
                },
                {
                    zone = "Tirisfal Glades",
                    faction = "Horde",
                    route = "Circle the mountains around Brill and continue toward Scarlet Monastery.",
                    tips = ProfessionHelper.L["MINING_LOC_3_TIP"],
                    levelRange = "1-10",
                },
                {
                    zone = "Dun Morogh",
                    faction = "Alliance",
                    route = "Start in Coldridge Valley, then loop around Anvilmar and head to Kharanos.",
                    tips = ProfessionHelper.L["MINING_LOC_4_TIP"],
                    levelRange = "1-10",
                },
                {
                    zone = "Mulgore",
                    faction = "Horde",
                    route = "Circle the mountains around Thunder Bluff and Bloodhoof Village.",
                    tips = ProfessionHelper.L["MINING_LOC_5_TIP"],
                    levelRange = "1-10",
                },
            },
        },
        
        -- ==================== TIN (65-125) ====================
        {
            skillRange = {65, 125},
            ore = "Tin Ore",
            locations = {
                {
                    zone = "The Barrens",
                    faction = "Horde",
                    route = "Large loop from Crossroads, past Ratchet, up the coast to Camp Taurajo.",
                    tips = ProfessionHelper.L["MINING_LOC_6_TIP"],
                    levelRange = "10-25",
                },
                {
                    zone = "Westfall",
                    faction = "Alliance",
                    route = "Circle the entire zone, focusing on the mountainous areas north near Elwynn and south near Duskwood.",
                    tips = ProfessionHelper.L["MINING_LOC_7_TIP"],
                    levelRange = "10-20",
                },
                {
                    zone = "Redridge Mountains",
                    faction = "Alliance",
                    route = "Start at Lakeshire and circle the mountains around Lake Everstill.",
                    tips = ProfessionHelper.L["MINING_LOC_8_TIP"],
                    levelRange = "15-25",
                },
                {
                    zone = "Silverpine Forest",
                    faction = "Horde",
                    route = "Follow the mountain line from north to south through the zone.",
                    tips = ProfessionHelper.L["MINING_LOC_9_TIP"],
                    levelRange = "10-20",
                },
                {
                    zone = "Darkshore",
                    faction = "Alliance",
                    route = "Follow the coast south from Auberdine, then return via the mountains to the east.",
                    tips = ProfessionHelper.L["MINING_LOC_10_TIP"],
                    levelRange = "10-20",
                },
            },
        },
        
        -- ==================== IRON (125-175) ====================
        {
            skillRange = {125, 175},
            ore = "Iron Ore",
            locations = {
                {
                    zone = "Arathi Highlands",
                    faction = "Both",
                    route = "Large loop from Refuge Pointe/Hammerfall, past the Circle of West/East Binding, then around Stromgarde.",
                    tips = ProfessionHelper.L["MINING_LOC_11_TIP"],
                    levelRange = "30-40",
                },
                {
                    zone = "Desolace",
                    faction = "Both",
                    route = "Circle the mountains around Kodo Graveyard then north into the Magram Vale.",
                    tips = ProfessionHelper.L["MINING_LOC_12_TIP"],
                    levelRange = "30-40",
                },
                {
                    zone = "Stranglethorn Vale",
                    faction = "Both",
                    route = "Focus on caves and mountains in the north (near Nesingwary) and the center of the zone.",
                    tips = ProfessionHelper.L["MINING_LOC_13_TIP"],
                    levelRange = "30-45",
                },
                {
                    zone = "Alterac Mountains",
                    faction = "Both",
                    route = "Circle the ruins of Alterac and the mountains around Strahnbrad.",
                    tips = ProfessionHelper.L["MINING_LOC_14_TIP"],
                    levelRange = "30-40",
                },
                {
                    zone = "Badlands",
                    faction = "Both",
                    route = "Large circuit through all the mountains in the zone.",
                    tips = ProfessionHelper.L["MINING_LOC_15_TIP"],
                    levelRange = "35-45",
                },
            },
        },
        
        -- ==================== MITHRIL (175-245) ====================
        {
            skillRange = {175, 245},
            ore = "Mithril Ore",
            locations = {
                {
                    zone = "Badlands",
                    faction = "Both",
                    route = "Circle the entire zone, especially near Uldaman and Camp Boff/Cagg.",
                    tips = ProfessionHelper.L["MINING_LOC_16_TIP"],
                    levelRange = "35-45",
                },
                {
                    zone = "Tanaris",
                    faction = "Both",
                    route = "Large circuit around Gadgetzan, through the mountains to the south and east.",
                    tips = ProfessionHelper.L["MINING_LOC_17_TIP"],
                    levelRange = "40-50",
                },
                {
                    zone = "The Hinterlands",
                    faction = "Both",
                    route = "Circle the entire zone, focusing on the mountains to the north and east.",
                    tips = ProfessionHelper.L["MINING_LOC_18_TIP"],
                    levelRange = "40-50",
                },
                {
                    zone = "Searing Gorge",
                    faction = "Both",
                    route = "Circle the edges of the zone and pass through the caves.",
                    tips = ProfessionHelper.L["MINING_LOC_19_TIP"],
                    levelRange = "43-50",
                },
                {
                    zone = "Felwood",
                    faction = "Both",
                    route = "Follow the mountains from north to south through the zone.",
                    tips = ProfessionHelper.L["MINING_LOC_20_TIP"],
                    levelRange = "48-55",
                },
                {
                    zone = "Thousand Needles",
                    faction = "Both",
                    route = "Circle the canyon walls and elevated plateaus. Dense Mithril nodes with very low competition. Natural route from The Barrens.",
                    tips = ProfessionHelper.L["MINING_LOC_33_TIP"],
                    levelRange = "25-35",
                },
            },
        },
        
        -- ==================== THORIUM (245-300) ====================
        {
            skillRange = {245, 300},
            ore = "Thorium Ore",
            locations = {
                {
                    zone = "Un'Goro Crater",
                    faction = "Both",
                    route = "Circle the entire crater rim inside the mountains.",
                    tips = ProfessionHelper.L["MINING_LOC_21_TIP"],
                    levelRange = "48-55",
                },
                {
                    zone = "Winterspring",
                    faction = "Both",
                    route = "Large circuit past Everlook, east and south mountains.",
                    tips = ProfessionHelper.L["MINING_LOC_22_TIP"],
                    levelRange = "55-60",
                },
                {
                    zone = "Eastern Plaguelands",
                    faction = "Both",
                    route = "Circle the mountains in the north and east of the zone.",
                    tips = ProfessionHelper.L["MINING_LOC_23_TIP"],
                    levelRange = "53-60",
                },
                {
                    zone = "Silithus",
                    faction = "Both",
                    route = "Circle the mountains around Cenarion Hold.",
                    tips = ProfessionHelper.L["MINING_LOC_24_TIP"],
                    levelRange = "55-60",
                },
                {
                    zone = "Burning Steppes",
                    faction = "Both",
                    route = "Circle the mountains and pass through the caves (many nodes inside).",
                    tips = ProfessionHelper.L["MINING_LOC_25_TIP"],
                    levelRange = "50-58",
                },
            },
        },
        
        -- ==================== FEL IRON (300-325) ====================
        {
            skillRange = {300, 325},
            ore = "Fel Iron Ore",
            locations = {
                {
                    zone = "Hellfire Peninsula",
                    faction = "Both",
                    route = "Large loop from Honor Hold/Thrallmar, through the northern and southern mountains.",
                    tips = ProfessionHelper.L["MINING_LOC_26_TIP"],
                    levelRange = "58-63",
                },
                {
                    zone = "Zangarmarsh",
                    faction = "Both",
                    route = "Circle the edges of the zone, especially near Coilfang Reservoir.",
                    tips = ProfessionHelper.L["MINING_LOC_27_TIP"],
                    levelRange = "60-64",
                },
                {
                    zone = "Terokkar Forest",
                    faction = "Both",
                    route = "Focus on the mountains around Shattrath and Auchindoun.",
                    tips = ProfessionHelper.L["MINING_LOC_28_TIP"],
                    levelRange = "62-65",
                },
            },
        },
        
        -- ==================== ADAMANTITE (325-375) ====================
        {
            skillRange = {325, 375},
            ore = "Adamantite Ore",
            locations = {
                {
                    zone = "Nagrand",
                    faction = "Both",
                    route = "Large circuit around the entire zone, focusing on the mountains.",
                    tips = ProfessionHelper.L["MINING_LOC_29_TIP"],
                    levelRange = "64-67",
                },
                {
                    zone = "Blade's Edge Mountains",
                    faction = "Both",
                    route = "Circle the mountains around Sylvanaar/Thunderlord and head north.",
                    tips = ProfessionHelper.L["MINING_LOC_30_TIP"],
                    levelRange = "65-68",
                },
                {
                    zone = "Netherstorm",
                    faction = "Both",
                    route = "Circle the island edges and pass through the eco-domes.",
                    tips = ProfessionHelper.L["MINING_LOC_31_TIP"],
                    levelRange = "67-70",
                },
                {
                    zone = "Shadowmoon Valley",
                    faction = "Both",
                    route = "Circle the mountains in the north and west of the zone.",
                    tips = ProfessionHelper.L["MINING_LOC_32_TIP"],
                    levelRange = "67-70",
                },
            },
        },
    },
    
    -- Smelting recipes for leveling
    smelting = {
        { name = "Smelt Copper", skill = 1, materials = {{ name = "Copper Ore", count = 1 }} },
        { name = "Smelt Tin", skill = 65, materials = {{ name = "Tin Ore", count = 1 }} },
        { name = "Smelt Bronze", skill = 65, materials = {{ name = "Copper Bar", count = 1 }, { name = "Tin Bar", count = 1 }} },
        { name = "Smelt Silver", skill = 75, materials = {{ name = "Silver Ore", count = 1 }} },
        { name = "Smelt Iron", skill = 125, materials = {{ name = "Iron Ore", count = 1 }} },
        { name = "Smelt Gold", skill = 155, materials = {{ name = "Gold Ore", count = 1 }} },
        { name = "Smelt Steel", skill = 165, materials = {{ name = "Iron Bar", count = 1 }, { name = "Coal", count = 1 }} },
        { name = "Smelt Mithril", skill = 175, materials = {{ name = "Mithril Ore", count = 1 }} },
        { name = "Smelt Truesilver", skill = 230, materials = {{ name = "Truesilver Ore", count = 1 }} },
        { name = "Smelt Thorium", skill = 250, materials = {{ name = "Thorium Ore", count = 1 }} },
        { name = "Smelt Fel Iron", skill = 300, materials = {{ name = "Fel Iron Ore", count = 1 }} },
        { name = "Smelt Adamantite", skill = 325, materials = {{ name = "Adamantite Ore", count = 1 }} },
        { name = "Smelt Eternium", skill = 350, materials = {{ name = "Eternium Ore", count = 1 }} },
        { name = "Smelt Felsteel", skill = 355, materials = {{ name = "Fel Iron Bar", count = 3 }, { name = "Eternium Bar", count = 2 }} },
        { name = "Smelt Khorium", skill = 375, materials = {{ name = "Khorium Ore", count = 1 }} },
    },
    
    -- Leveling guide
    levelingGuide = {
        {
            range = {1, 65},
            tip = ProfessionHelper.L["MINING_TIP_1_65"],
        },
        {
            range = {65, 125},
            tip = ProfessionHelper.L["MINING_TIP_65_125"],
        },
        {
            range = {125, 175},
            tip = ProfessionHelper.L["MINING_TIP_125_175"],
        },
        {
            range = {175, 245},
            tip = ProfessionHelper.L["MINING_TIP_175_245"],
        },
        {
            range = {245, 300},
            tip = ProfessionHelper.L["MINING_TIP_245_300"],
        },
        {
            range = {300, 325},
            tip = ProfessionHelper.L["MINING_TIP_300_325"],
        },
        {
            range = {325, 375},
            tip = ProfessionHelper.L["MINING_TIP_325_375"],
        },
    },
}
