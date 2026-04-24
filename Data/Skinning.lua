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
                    route = "Kill Scorpids and Boars around Razor Hill and along the coast.",
                    mobs = "Scorpid Workers, Durotar Tigers, Boars",
                    tips = ProfessionHelper.L["SKINNING_LOC_1_TIP"],
                    levelRange = "1-10",
                },
                {
                    zone = "Elwynn Forest",
                    faction = "Alliance",
                    route = "Kill Wolves and Boars around Goldshire and Eastvale Logging Camp.",
                    mobs = "Prowlers, Young Forest Bears, Boars",
                    tips = ProfessionHelper.L["SKINNING_LOC_2_TIP"],
                    levelRange = "1-10",
                },
                {
                    zone = "The Barrens",
                    faction = "Horde",
                    route = "Large area around Crossroads. Focus on Zhevras and Raptors.",
                    mobs = "Zhevras, Raptors, Lions, Hyenas",
                    tips = ProfessionHelper.L["SKINNING_LOC_3_TIP"],
                    levelRange = "10-25",
                },
                {
                    zone = "Loch Modan",
                    faction = "Alliance",
                    route = "Kill Bears around the lake and Boars in the southern area.",
                    mobs = "Elder Black Bears, Mountain Boars",
                    tips = ProfessionHelper.L["SKINNING_LOC_4_TIP"],
                    levelRange = "10-20",
                },
                {
                    zone = "Westfall",
                    faction = "Alliance",
                    route = "Kill the Coyotes and Boars scattered across the zone.",
                    mobs = "Coyotes, Goretusks, Fleshrippers",
                    tips = ProfessionHelper.L["SKINNING_LOC_5_TIP"],
                    levelRange = "10-20",
                },
            },
        },
        
        -- ==================== MEDIUM LEATHER (75-150) ====================
        {
            skillRange = {75, 150},
            leather = "Medium Leather, Medium Hide",
            locations = {
                {
                    zone = "Hillsbrad Foothills",
                    faction = "Both",
                    route = "Kill Bears and Lions around Hillsbrad Fields and the mountains.",
                    mobs = "Giant Yetis, Mountain Lions, Bears",
                    tips = ProfessionHelper.L["SKINNING_LOC_6_TIP"],
                    levelRange = "20-30",
                },
                {
                    zone = "Wetlands",
                    faction = "Alliance",
                    route = "Kill Crocolisks around the swamps and Raptors in the south.",
                    mobs = "Wetlands Crocolisks, Mottled Raptors",
                    tips = ProfessionHelper.L["SKINNING_LOC_7_TIP"],
                    levelRange = "20-30",
                },
                {
                    zone = "Stonetalon Mountains",
                    faction = "Both",
                    route = "Kill Cougars and Bears in the mountains.",
                    mobs = "Stonetalon Cougars, Deepmoss Lurkers",
                    tips = ProfessionHelper.L["SKINNING_LOC_8_TIP"],
                    levelRange = "15-27",
                },
                {
                    zone = "Ashenvale",
                    faction = "Both",
                    route = "Kill Bears and Wolves in the forest.",
                    mobs = "Ashenvale Bears, Ghostpaw Runners",
                    tips = ProfessionHelper.L["SKINNING_LOC_9_TIP"],
                    levelRange = "18-30",
                },
                {
                    zone = "Thousand Needles",
                    faction = "Both",
                    route = "Kill the Kodos to the south and Cougars in the mountains.",
                    mobs = "Salt Flats Vultures, Cougars, Kodos",
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
                    route = "Kill Tigers, Panthers, and Raptors throughout the zone.",
                    mobs = "Stranglethorn Tigers, Panthers, Raptors, Gorillas",
                    tips = ProfessionHelper.L["SKINNING_LOC_11_TIP"],
                    levelRange = "30-45",
                },
                {
                    zone = "Badlands",
                    faction = "Both",
                    route = "Kill Coyotes and Rock Elementals (some have scales).",
                    mobs = "Feral Coyotes, Ridge Stalkers",
                    tips = ProfessionHelper.L["SKINNING_LOC_12_TIP"],
                    levelRange = "35-45",
                },
                {
                    zone = "Dustwallow Marsh",
                    faction = "Both",
                    route = "Kill Crocolisks and Raptors in the swamps.",
                    mobs = "Darkfang Creepers, Mirefin Murlocs Raptors",
                    tips = ProfessionHelper.L["SKINNING_LOC_13_TIP"],
                    levelRange = "35-45",
                },
                {
                    zone = "Desolace",
                    faction = "Both",
                    route = "Kill Kodos and Scorpids in the central area.",
                    mobs = "Aged Kodos, Scorpashi",
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
                    route = "Kill Dinosaurs throughout the crater. Focus on Devilsaurs if possible.",
                    mobs = "Ravasaurs, Pterrordax, Devilsaurs, Diemetradons",
                    tips = ProfessionHelper.L["SKINNING_LOC_15_TIP"],
                    levelRange = "48-55",
                },
                {
                    zone = "Feralas",
                    faction = "Both",
                    route = "Kill Wolves and Bears in the forest, Yetis in the mountains.",
                    mobs = "Feral Scar Yetis, Longtooth Runners",
                    tips = ProfessionHelper.L["SKINNING_LOC_16_TIP"],
                    levelRange = "40-50",
                },
                {
                    zone = "The Hinterlands",
                    faction = "Both",
                    route = "Kill Wolves and Owlbeasts in the forest.",
                    mobs = "Silvermane Wolves, Owlbeasts",
                    tips = ProfessionHelper.L["SKINNING_LOC_17_TIP"],
                    levelRange = "40-50",
                },
                {
                    zone = "Tanaris",
                    faction = "Both",
                    route = "Kill Hyenas and Basilisks in the desert.",
                    mobs = "Dunemaul Ogres (some), Wastewander (no)",
                    tips = ProfessionHelper.L["SKINNING_LOC_18_TIP"],
                    levelRange = "40-50",
                },
                {
                    zone = "Azshara",
                    faction = "Both",
                    route = "Kill Bears and Chimeras in the mountains.",
                    mobs = "Timbermaw Furbolgs (no), Bears, Chimera",
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
                    route = "Kill Bears and Chimeras around Everlook.",
                    mobs = "Shardtooth Bears, Ice Thistle Yetis, Chimeras",
                    tips = ProfessionHelper.L["SKINNING_LOC_20_TIP"],
                    levelRange = "55-60",
                },
                {
                    zone = "Silithus",
                    faction = "Both",
                    route = "Kill Worms and Scorpids in the sand.",
                    mobs = "Rock Stalkers, Dredge Strikers, Scorpids",
                    tips = ProfessionHelper.L["SKINNING_LOC_21_TIP"],
                    levelRange = "55-60",
                },
                {
                    zone = "Western Plaguelands",
                    faction = "Both",
                    route = "Kill Bears and Wolves in the area around Chillwind Camp.",
                    mobs = "Diseased Wolves, Plague Bears",
                    tips = ProfessionHelper.L["SKINNING_LOC_22_TIP"],
                    levelRange = "50-58",
                },
                {
                    zone = "Eastern Plaguelands",
                    faction = "Both",
                    route = "Kill Plaguehounds and Bats in the area.",
                    mobs = "Plaguehounds, Monstrous Plaguebats",
                    tips = ProfessionHelper.L["SKINNING_LOC_23_TIP"],
                    levelRange = "53-60",
                },
                {
                    zone = "Burning Steppes",
                    faction = "Both",
                    route = "Kill Worgs and Dragonkin in the mountains.",
                    mobs = "Firegut Ogres (no), Worgs, Black Dragonkin",
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
                    route = "Kill Talbuks and Clefthoofs throughout the zone.",
                    mobs = "Talbuks, Clefthoofs, Elekk",
                    tips = ProfessionHelper.L["SKINNING_LOC_25_TIP"],
                    levelRange = "64-67",
                },
                {
                    zone = "Hellfire Peninsula",
                    faction = "Both",
                    route = "Kill Ravagers and Helboars around Honor Hold/Thrallmar.",
                    mobs = "Ravagers, Helboars, Quillfang",
                    tips = ProfessionHelper.L["SKINNING_LOC_26_TIP"],
                    levelRange = "58-63",
                },
                {
                    zone = "Terokkar Forest",
                    faction = "Both",
                    route = "Kill Warp Stalkers and Wolves in the forest.",
                    mobs = "Warp Stalkers, Timber Worg",
                    tips = ProfessionHelper.L["SKINNING_LOC_27_TIP"],
                    levelRange = "62-65",
                },
                {
                    zone = "Blade's Edge Mountains",
                    faction = "Both",
                    route = "Kill Raptors and Boars in the lower areas.",
                    mobs = "Bloodmaul Dire Wolves, Raptors",
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
                    route = "Keep killing Clefthoofs. Each Knothide becomes Heavy with crafting.",
                    mobs = "Elite Clefthoofs, Bulls",
                    tips = ProfessionHelper.L["SKINNING_LOC_29_TIP"],
                    levelRange = "64-67",
                },
                {
                    zone = "Shadowmoon Valley",
                    faction = "Both",
                    route = "Kill Nether Drakes and Demons for special leather.",
                    mobs = "Netherwing Dragons, Eclipsion Dragonhawks",
                    tips = ProfessionHelper.L["SKINNING_LOC_30_TIP"],
                    levelRange = "67-70",
                },
                {
                    zone = "Coilfang Reservoir (Dungeons)",
                    faction = "Both",
                    route = "Kill Cobras in the Coilfang dungeons.",
                    mobs = "Coilfang Serpents",
                    tips = ProfessionHelper.L["SKINNING_LOC_31_TIP"],
                    levelRange = "62-70 (Dungeon)",
                },
                {
                    zone = "Netherstorm",
                    faction = "Both",
                    route = "Kill Nether Rays and other skinnable mobs.",
                    mobs = "Nether Rays, Warp Hunters",
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
