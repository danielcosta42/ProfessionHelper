-- Profession Helper - Skinning Data (Gathering Profession)
ProfessionHelper = ProfessionHelper or {}
ProfessionHelper.Skinning = {
    name = "Skinning",
    type = "gathering",
    
    trainer = {
        ["Alliance"] = {
            "Helene Peltskinner (Elwynn Forest)",
            "Balthus Stoneflayer (Stormwind)",
            "Radnaal Maneweaver (Darnassus)",
            "Seymour (Shattrath)",
        },
        ["Horde"] = {
            "Yonn Deepcut (Orgrimmar)",
            "Rand Rhoads (Undercity)",
            "Mooranta (Thunder Bluff)",
            "Thuwd (Camp Taurajo - The Barrens)",
            "Seymour (Shattrath)",
        },
    },
    
    -- Skinning follows a simple formula: you need skill = mob level * 5
    skillFormula = ProfessionHelper.L["SKINNING_SKILL_FORMULA"],
    
    leatherTypes = {
        { leather = "Ruined Leather Scraps", mobLevel = "1-16", skillRequired = "1-80" },
        { leather = "Light Leather", mobLevel = "1-27", skillRequired = "1-135" },
        { leather = "Light Hide", mobLevel = "10-27", skillRequired = "50-135" },
        { leather = "Medium Leather", mobLevel = "15-36", skillRequired = "75-180" },
        { leather = "Medium Hide", mobLevel = "15-36", skillRequired = "75-180" },
        { leather = "Heavy Leather", mobLevel = "25-46", skillRequired = "125-230" },
        { leather = "Heavy Hide", mobLevel = "25-46", skillRequired = "125-230" },
        { leather = "Thick Leather", mobLevel = "35-63", skillRequired = "175-315" },
        { leather = "Thick Hide", mobLevel = "40-59", skillRequired = "200-295" },
        { leather = "Rugged Leather", mobLevel = "43-63", skillRequired = "215-315" },
        { leather = "Rugged Hide", mobLevel = "47-63", skillRequired = "235-315" },
        -- TBC
        { leather = "Knothide Leather Scraps", mobLevel = "58-63", skillRequired = "290-315" },
        { leather = "Knothide Leather", mobLevel = "62-70", skillRequired = "310-350" },
        { leather = "Fel Hide", mobLevel = "Demons", skillRequired = "310+" },
        { leather = "Fel Scales", mobLevel = "Demons/Dragonkin", skillRequired = "310+" },
        { leather = "Cobra Scales", mobLevel = "Coilfang Snakes", skillRequired = "340+" },
        { leather = "Wind Scales", mobLevel = "Wind Serpents", skillRequired = "340+" },
        { leather = "Nether Dragonscales", mobLevel = "Netherwing", skillRequired = "350+" },
    },
    
    farmingLocations = {
        -- ==================== LIGHT LEATHER (1-75) ====================
        {
            skillRange = {1, 75},
            leather = "Ruined Leather Scraps, Light Leather",
            locations = {
                {
                    zone = "Durotar",
                    faction = "Horde",
                    route = ProfessionHelper.L["SKINNING_LOC_1_ROUTE"],
                    mobs = ProfessionHelper.L["SKINNING_LOC_1_MOBS"],
                    tips = ProfessionHelper.L["SKINNING_LOC_1_TIP"],
                    levelRange = "1-10",
                },
                {
                    zone = "Elwynn Forest",
                    faction = "Alliance",
                    route = ProfessionHelper.L["SKINNING_LOC_2_ROUTE"],
                    mobs = ProfessionHelper.L["SKINNING_LOC_2_MOBS"],
                    tips = ProfessionHelper.L["SKINNING_LOC_2_TIP"],
                    levelRange = "1-10",
                },
                {
                    zone = "The Barrens",
                    faction = "Horde",
                    route = ProfessionHelper.L["SKINNING_LOC_3_ROUTE"],
                    mobs = ProfessionHelper.L["SKINNING_LOC_3_MOBS"],
                    tips = ProfessionHelper.L["SKINNING_LOC_3_TIP"],
                    levelRange = "10-25",
                },
                {
                    zone = "Loch Modan",
                    faction = "Alliance",
                    route = ProfessionHelper.L["SKINNING_LOC_4_ROUTE"],
                    mobs = ProfessionHelper.L["SKINNING_LOC_4_MOBS"],
                    tips = ProfessionHelper.L["SKINNING_LOC_4_TIP"],
                    levelRange = "10-20",
                },
                {
                    zone = "Westfall",
                    faction = "Alliance",
                    route = ProfessionHelper.L["SKINNING_LOC_5_ROUTE"],
                    mobs = ProfessionHelper.L["SKINNING_LOC_5_MOBS"],
                    tips = ProfessionHelper.L["SKINNING_LOC_5_TIP"],
                    levelRange = "10-20",
                },
            },
        },
        
        -- ==================== MEDIUM LEATHER early (75-110) ====================
        {
            skillRange = {75, 110},
            leather = "Medium Leather, Medium Hide",
            locations = {
                {
                    zone = "The Barrens",
                    faction = "Horde",
                    route = ProfessionHelper.L["SKINNING_LOC_33_ROUTE"],
                    mobs = ProfessionHelper.L["SKINNING_LOC_33_MOBS"],
                    tips = ProfessionHelper.L["SKINNING_LOC_33_TIP"],
                    levelRange = "22-32",
                },
                {
                    zone = "Thousand Needles",
                    faction = "Both",
                    route = ProfessionHelper.L["SKINNING_LOC_34_ROUTE"],
                    mobs = ProfessionHelper.L["SKINNING_LOC_34_MOBS"],
                    tips = ProfessionHelper.L["SKINNING_LOC_34_TIP"],
                    levelRange = "25-35",
                },
                {
                    zone = "Stonetalon Mountains",
                    faction = "Both",
                    route = ProfessionHelper.L["SKINNING_LOC_8_ROUTE"],
                    mobs = ProfessionHelper.L["SKINNING_LOC_8_MOBS"],
                    tips = ProfessionHelper.L["SKINNING_LOC_8_TIP"],
                    levelRange = "15-27",
                },
                {
                    zone = "Hillsbrad Foothills",
                    faction = "Both",
                    route = ProfessionHelper.L["SKINNING_LOC_6_ROUTE"],
                    mobs = ProfessionHelper.L["SKINNING_LOC_6_MOBS"],
                    tips = ProfessionHelper.L["SKINNING_LOC_6_TIP"],
                    levelRange = "20-26",
                },
                {
                    zone = "Wetlands",
                    faction = "Alliance",
                    route = ProfessionHelper.L["SKINNING_LOC_7_ROUTE"],
                    mobs = ProfessionHelper.L["SKINNING_LOC_7_MOBS"],
                    tips = ProfessionHelper.L["SKINNING_LOC_7_TIP"],
                    levelRange = "20-30",
                },
            },
        },

        -- ==================== MEDIUM LEATHER late (110-150) ====================
        {
            skillRange = {110, 150},
            leather = "Medium Leather, Medium Hide",
            locations = {
                {
                    zone = "Hillsbrad Foothills",
                    faction = "Both",
                    route = ProfessionHelper.L["SKINNING_LOC_35_ROUTE"],
                    mobs = ProfessionHelper.L["SKINNING_LOC_35_MOBS"],
                    tips = ProfessionHelper.L["SKINNING_LOC_6_TIP"],
                    levelRange = "25-30",
                },
                {
                    zone = "Ashenvale",
                    faction = "Both",
                    route = ProfessionHelper.L["SKINNING_LOC_9_ROUTE"],
                    mobs = ProfessionHelper.L["SKINNING_LOC_9_MOBS"],
                    tips = ProfessionHelper.L["SKINNING_LOC_9_TIP"],
                    levelRange = "18-30",
                },
                {
                    zone = "Thousand Needles",
                    faction = "Both",
                    route = ProfessionHelper.L["SKINNING_LOC_10_ROUTE"],
                    mobs = ProfessionHelper.L["SKINNING_LOC_10_MOBS"],
                    tips = ProfessionHelper.L["SKINNING_LOC_10_TIP"],
                    levelRange = "25-35",
                },
            },
        },
        
        -- ==================== HEAVY LEATHER (150-205) ====================
        {
            skillRange = {150, 205},
            leather = "Heavy Leather, Heavy Hide",
            locations = {
                {
                    zone = "Stranglethorn Vale",
                    faction = "Both",
                    route = ProfessionHelper.L["SKINNING_LOC_11_ROUTE"],
                    mobs = ProfessionHelper.L["SKINNING_LOC_11_MOBS"],
                    tips = ProfessionHelper.L["SKINNING_LOC_11_TIP"],
                    levelRange = "30-45",
                },
                {
                    zone = "Badlands",
                    faction = "Both",
                    route = ProfessionHelper.L["SKINNING_LOC_12_ROUTE"],
                    mobs = ProfessionHelper.L["SKINNING_LOC_12_MOBS"],
                    tips = ProfessionHelper.L["SKINNING_LOC_12_TIP"],
                    levelRange = "35-45",
                },
                {
                    zone = "Dustwallow Marsh",
                    faction = "Both",
                    route = ProfessionHelper.L["SKINNING_LOC_13_ROUTE"],
                    mobs = ProfessionHelper.L["SKINNING_LOC_13_MOBS"],
                    tips = ProfessionHelper.L["SKINNING_LOC_13_TIP"],
                    levelRange = "35-45",
                },
                {
                    zone = "Desolace",
                    faction = "Both",
                    route = ProfessionHelper.L["SKINNING_LOC_14_ROUTE"],
                    mobs = ProfessionHelper.L["SKINNING_LOC_14_MOBS"],
                    tips = ProfessionHelper.L["SKINNING_LOC_14_TIP"],
                    levelRange = "30-40",
                },
            },
        },
        
        -- ==================== THICK LEATHER (205-260) ====================
        {
            skillRange = {205, 260},
            leather = "Thick Leather, Thick Hide",
            locations = {
                {
                    zone = "Un'Goro Crater",
                    faction = "Both",
                    route = ProfessionHelper.L["SKINNING_LOC_15_ROUTE"],
                    mobs = ProfessionHelper.L["SKINNING_LOC_15_MOBS"],
                    tips = ProfessionHelper.L["SKINNING_LOC_15_TIP"],
                    levelRange = "48-55",
                },
                {
                    zone = "Feralas",
                    faction = "Both",
                    route = ProfessionHelper.L["SKINNING_LOC_16_ROUTE"],
                    mobs = ProfessionHelper.L["SKINNING_LOC_16_MOBS"],
                    tips = ProfessionHelper.L["SKINNING_LOC_16_TIP"],
                    levelRange = "40-50",
                },
                {
                    zone = "The Hinterlands",
                    faction = "Both",
                    route = ProfessionHelper.L["SKINNING_LOC_17_ROUTE"],
                    mobs = ProfessionHelper.L["SKINNING_LOC_17_MOBS"],
                    tips = ProfessionHelper.L["SKINNING_LOC_17_TIP"],
                    levelRange = "40-50",
                },
                {
                    zone = "Tanaris",
                    faction = "Both",
                    route = ProfessionHelper.L["SKINNING_LOC_18_ROUTE"],
                    mobs = ProfessionHelper.L["SKINNING_LOC_18_MOBS"],
                    tips = ProfessionHelper.L["SKINNING_LOC_18_TIP"],
                    levelRange = "40-50",
                },
                {
                    zone = "Azshara",
                    faction = "Both",
                    route = ProfessionHelper.L["SKINNING_LOC_19_ROUTE"],
                    mobs = ProfessionHelper.L["SKINNING_LOC_19_MOBS"],
                    tips = ProfessionHelper.L["SKINNING_LOC_19_TIP"],
                    levelRange = "45-55",
                },
            },
        },
        
        -- ==================== RUGGED LEATHER (260-300) ====================
        {
            skillRange = {260, 300},
            leather = "Rugged Leather, Rugged Hide",
            locations = {
                {
                    zone = "Winterspring",
                    faction = "Both",
                    route = ProfessionHelper.L["SKINNING_LOC_20_ROUTE"],
                    mobs = ProfessionHelper.L["SKINNING_LOC_20_MOBS"],
                    tips = ProfessionHelper.L["SKINNING_LOC_20_TIP"],
                    levelRange = "55-60",
                },
                {
                    zone = "Silithus",
                    faction = "Both",
                    route = ProfessionHelper.L["SKINNING_LOC_21_ROUTE"],
                    mobs = ProfessionHelper.L["SKINNING_LOC_21_MOBS"],
                    tips = ProfessionHelper.L["SKINNING_LOC_21_TIP"],
                    levelRange = "55-60",
                },
                {
                    zone = "Western Plaguelands",
                    faction = "Both",
                    route = ProfessionHelper.L["SKINNING_LOC_22_ROUTE"],
                    mobs = ProfessionHelper.L["SKINNING_LOC_22_MOBS"],
                    tips = ProfessionHelper.L["SKINNING_LOC_22_TIP"],
                    levelRange = "50-58",
                },
                {
                    zone = "Eastern Plaguelands",
                    faction = "Both",
                    route = ProfessionHelper.L["SKINNING_LOC_23_ROUTE"],
                    mobs = ProfessionHelper.L["SKINNING_LOC_23_MOBS"],
                    tips = ProfessionHelper.L["SKINNING_LOC_23_TIP"],
                    levelRange = "53-60",
                },
                {
                    zone = "Burning Steppes",
                    faction = "Both",
                    route = ProfessionHelper.L["SKINNING_LOC_24_ROUTE"],
                    mobs = ProfessionHelper.L["SKINNING_LOC_24_MOBS"],
                    tips = ProfessionHelper.L["SKINNING_LOC_24_TIP"],
                    levelRange = "50-58",
                },
            },
        },
        
        -- ==================== KNOTHIDE LEATHER (300-350) ====================
        {
            skillRange = {300, 350},
            leather = "Knothide Leather Scraps, Knothide Leather",
            locations = {
                {
                    zone = "Nagrand",
                    faction = "Both",
                    route = ProfessionHelper.L["SKINNING_LOC_25_ROUTE"],
                    mobs = ProfessionHelper.L["SKINNING_LOC_25_MOBS"],
                    tips = ProfessionHelper.L["SKINNING_LOC_25_TIP"],
                    levelRange = "64-67",
                },
                {
                    zone = "Hellfire Peninsula",
                    faction = "Both",
                    route = ProfessionHelper.L["SKINNING_LOC_26_ROUTE"],
                    mobs = ProfessionHelper.L["SKINNING_LOC_26_MOBS"],
                    tips = ProfessionHelper.L["SKINNING_LOC_26_TIP"],
                    levelRange = "58-63",
                },
                {
                    zone = "Terokkar Forest",
                    faction = "Both",
                    route = ProfessionHelper.L["SKINNING_LOC_27_ROUTE"],
                    mobs = ProfessionHelper.L["SKINNING_LOC_27_MOBS"],
                    tips = ProfessionHelper.L["SKINNING_LOC_27_TIP"],
                    levelRange = "62-65",
                },
                {
                    zone = "Blade's Edge Mountains",
                    faction = "Both",
                    route = ProfessionHelper.L["SKINNING_LOC_28_ROUTE"],
                    mobs = ProfessionHelper.L["SKINNING_LOC_28_MOBS"],
                    tips = ProfessionHelper.L["SKINNING_LOC_28_TIP"],
                    levelRange = "65-68",
                },
            },
        },
        
        -- ==================== HEAVY KNOTHIDE / SPECIAL LEATHER (350-375) ====================
        {
            skillRange = {350, 375},
            leather = "Heavy Knothide Leather, Nether Dragonscales, Cobra Scales",
            locations = {
                {
                    zone = "Nagrand",
                    faction = "Both",
                    route = ProfessionHelper.L["SKINNING_LOC_29_ROUTE"],
                    mobs = ProfessionHelper.L["SKINNING_LOC_29_MOBS"],
                    tips = ProfessionHelper.L["SKINNING_LOC_29_TIP"],
                    levelRange = "64-67",
                },
                {
                    zone = "Shadowmoon Valley",
                    faction = "Both",
                    route = ProfessionHelper.L["SKINNING_LOC_30_ROUTE"],
                    mobs = ProfessionHelper.L["SKINNING_LOC_30_MOBS"],
                    tips = ProfessionHelper.L["SKINNING_LOC_30_TIP"],
                    levelRange = "67-70",
                },
                {
                    zone = "Coilfang Reservoir (Dungeons)",
                    faction = "Both",
                    route = ProfessionHelper.L["SKINNING_LOC_31_ROUTE"],
                    mobs = ProfessionHelper.L["SKINNING_LOC_31_MOBS"],
                    tips = ProfessionHelper.L["SKINNING_LOC_31_TIP"],
                    levelRange = "62-70 (Dungeon)",
                },
                {
                    zone = "Netherstorm",
                    faction = "Both",
                    route = ProfessionHelper.L["SKINNING_LOC_32_ROUTE"],
                    mobs = ProfessionHelper.L["SKINNING_LOC_32_MOBS"],
                    tips = ProfessionHelper.L["SKINNING_LOC_32_TIP"],
                    levelRange = "67-70",
                },
            },
        },
    },
    
    -- Leveling guide
    levelingGuide = {
        {
            range = {1, 75},
            tip = ProfessionHelper.L["SKINNING_TIP_1_75"],
        },
        {
            range = {75, 150},
            tip = ProfessionHelper.L["SKINNING_TIP_75_150"],
        },
        {
            range = {150, 205},
            tip = ProfessionHelper.L["SKINNING_TIP_150_205"],
        },
        {
            range = {205, 260},
            tip = ProfessionHelper.L["SKINNING_TIP_205_260"],
        },
        {
            range = {260, 300},
            tip = ProfessionHelper.L["SKINNING_TIP_260_300"],
        },
        {
            range = {300, 350},
            tip = ProfessionHelper.L["SKINNING_TIP_300_350"],
        },
        {
            range = {350, 375},
            tip = ProfessionHelper.L["SKINNING_TIP_350_375"],
        },
    },
}
