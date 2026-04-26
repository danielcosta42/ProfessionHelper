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
                    route = ProfessionHelper.L["MINING_LOC_1_ROUTE"],
                    tips = ProfessionHelper.L["MINING_LOC_1_TIP"],
                    levelRange = "1-10",
                },
                {
                    zone = "Elwynn Forest",
                    faction = "Alliance",
                    route = ProfessionHelper.L["MINING_LOC_2_ROUTE"],
                    tips = ProfessionHelper.L["MINING_LOC_2_TIP"],
                    levelRange = "1-10",
                },
                {
                    zone = "Tirisfal Glades",
                    faction = "Horde",
                    route = ProfessionHelper.L["MINING_LOC_3_ROUTE"],
                    tips = ProfessionHelper.L["MINING_LOC_3_TIP"],
                    levelRange = "1-10",
                },
                {
                    zone = "Dun Morogh",
                    faction = "Alliance",
                    route = ProfessionHelper.L["MINING_LOC_4_ROUTE"],
                    tips = ProfessionHelper.L["MINING_LOC_4_TIP"],
                    levelRange = "1-10",
                },
                {
                    zone = "Mulgore",
                    faction = "Horde",
                    route = ProfessionHelper.L["MINING_LOC_5_ROUTE"],
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
                    route = ProfessionHelper.L["MINING_LOC_6_ROUTE"],
                    tips = ProfessionHelper.L["MINING_LOC_6_TIP"],
                    levelRange = "10-25",
                },
                {
                    zone = "Westfall",
                    faction = "Alliance",
                    route = ProfessionHelper.L["MINING_LOC_7_ROUTE"],
                    tips = ProfessionHelper.L["MINING_LOC_7_TIP"],
                    levelRange = "10-20",
                },
                {
                    zone = "Redridge Mountains",
                    faction = "Alliance",
                    route = ProfessionHelper.L["MINING_LOC_8_ROUTE"],
                    tips = ProfessionHelper.L["MINING_LOC_8_TIP"],
                    levelRange = "15-25",
                },
                {
                    zone = "Silverpine Forest",
                    faction = "Horde",
                    route = ProfessionHelper.L["MINING_LOC_9_ROUTE"],
                    tips = ProfessionHelper.L["MINING_LOC_9_TIP"],
                    levelRange = "10-20",
                },
                {
                    zone = "Darkshore",
                    faction = "Alliance",
                    route = ProfessionHelper.L["MINING_LOC_10_ROUTE"],
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
                    route = ProfessionHelper.L["MINING_LOC_11_ROUTE"],
                    tips = ProfessionHelper.L["MINING_LOC_11_TIP"],
                    levelRange = "30-40",
                },
                {
                    zone = "Desolace",
                    faction = "Both",
                    route = ProfessionHelper.L["MINING_LOC_12_ROUTE"],
                    tips = ProfessionHelper.L["MINING_LOC_12_TIP"],
                    levelRange = "30-40",
                },
                {
                    zone = "Stranglethorn Vale",
                    faction = "Both",
                    route = ProfessionHelper.L["MINING_LOC_13_ROUTE"],
                    tips = ProfessionHelper.L["MINING_LOC_13_TIP"],
                    levelRange = "30-45",
                },
                {
                    zone = "Alterac Mountains",
                    faction = "Both",
                    route = ProfessionHelper.L["MINING_LOC_14_ROUTE"],
                    tips = ProfessionHelper.L["MINING_LOC_14_TIP"],
                    levelRange = "30-40",
                },
                {
                    zone = "Badlands",
                    faction = "Both",
                    route = ProfessionHelper.L["MINING_LOC_15_ROUTE"],
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
                    route = ProfessionHelper.L["MINING_LOC_16_ROUTE"],
                    tips = ProfessionHelper.L["MINING_LOC_16_TIP"],
                    levelRange = "35-45",
                },
                {
                    zone = "Tanaris",
                    faction = "Both",
                    route = ProfessionHelper.L["MINING_LOC_17_ROUTE"],
                    tips = ProfessionHelper.L["MINING_LOC_17_TIP"],
                    levelRange = "40-50",
                },
                {
                    zone = "The Hinterlands",
                    faction = "Both",
                    route = ProfessionHelper.L["MINING_LOC_18_ROUTE"],
                    tips = ProfessionHelper.L["MINING_LOC_18_TIP"],
                    levelRange = "40-50",
                },
                {
                    zone = "Searing Gorge",
                    faction = "Both",
                    route = ProfessionHelper.L["MINING_LOC_19_ROUTE"],
                    tips = ProfessionHelper.L["MINING_LOC_19_TIP"],
                    levelRange = "43-50",
                },
                {
                    zone = "Felwood",
                    faction = "Both",
                    route = ProfessionHelper.L["MINING_LOC_20_ROUTE"],
                    tips = ProfessionHelper.L["MINING_LOC_20_TIP"],
                    levelRange = "48-55",
                },
                {
                    zone = "Thousand Needles",
                    faction = "Both",
                    route = ProfessionHelper.L["MINING_LOC_33_ROUTE"],
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
                    route = ProfessionHelper.L["MINING_LOC_21_ROUTE"],
                    tips = ProfessionHelper.L["MINING_LOC_21_TIP"],
                    levelRange = "48-55",
                },
                {
                    zone = "Winterspring",
                    faction = "Both",
                    route = ProfessionHelper.L["MINING_LOC_22_ROUTE"],
                    tips = ProfessionHelper.L["MINING_LOC_22_TIP"],
                    levelRange = "55-60",
                },
                {
                    zone = "Eastern Plaguelands",
                    faction = "Both",
                    route = ProfessionHelper.L["MINING_LOC_23_ROUTE"],
                    tips = ProfessionHelper.L["MINING_LOC_23_TIP"],
                    levelRange = "53-60",
                },
                {
                    zone = "Silithus",
                    faction = "Both",
                    route = ProfessionHelper.L["MINING_LOC_24_ROUTE"],
                    tips = ProfessionHelper.L["MINING_LOC_24_TIP"],
                    levelRange = "55-60",
                },
                {
                    zone = "Burning Steppes",
                    faction = "Both",
                    route = ProfessionHelper.L["MINING_LOC_25_ROUTE"],
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
                    route = ProfessionHelper.L["MINING_LOC_26_ROUTE"],
                    tips = ProfessionHelper.L["MINING_LOC_26_TIP"],
                    levelRange = "58-63",
                },
                {
                    zone = "Zangarmarsh",
                    faction = "Both",
                    route = ProfessionHelper.L["MINING_LOC_27_ROUTE"],
                    tips = ProfessionHelper.L["MINING_LOC_27_TIP"],
                    levelRange = "60-64",
                },
                {
                    zone = "Terokkar Forest",
                    faction = "Both",
                    route = ProfessionHelper.L["MINING_LOC_28_ROUTE"],
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
                    route = ProfessionHelper.L["MINING_LOC_29_ROUTE"],
                    tips = ProfessionHelper.L["MINING_LOC_29_TIP"],
                    levelRange = "64-67",
                },
                {
                    zone = "Blade's Edge Mountains",
                    faction = "Both",
                    route = ProfessionHelper.L["MINING_LOC_30_ROUTE"],
                    tips = ProfessionHelper.L["MINING_LOC_30_TIP"],
                    levelRange = "65-68",
                },
                {
                    zone = "Netherstorm",
                    faction = "Both",
                    route = ProfessionHelper.L["MINING_LOC_31_ROUTE"],
                    tips = ProfessionHelper.L["MINING_LOC_31_TIP"],
                    levelRange = "67-70",
                },
                {
                    zone = "Shadowmoon Valley",
                    faction = "Both",
                    route = ProfessionHelper.L["MINING_LOC_32_ROUTE"],
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
