-- Profession Helper - Fishing Data (Gathering/Secondary Profession)
ProfessionHelper = ProfessionHelper or {}
ProfessionHelper.Fishing = {
    name = "Fishing",
    type = "gathering",
    secondary = true,
    
    trainer = {
        ["Alliance"] = {
            "Arnold Leland (Stormwind)",
            "Grimnur Stonebrand (Ironforge)",
            "Astaia (Darnassus)",
            "Juno Dufrain (Shattrath)",
        },
        ["Horde"] = {
            "Lumak (Orgrimmar)",
            "Armand Cromwell (Undercity)",
            "Kah Mistrunner (Thunder Bluff)",
            "Juno Dufrain (Shattrath)",
        },
    },
    
    -- Fishing skill requirements by zone
    zoneRequirements = {
        { zone = "Starting Zones", minSkill = 1, noGetaway = 25, recommended = 50 },
        { zone = "Level 10-20 Zones", minSkill = 1, noGetaway = 75, recommended = 100 },
        { zone = "Level 20-30 Zones", minSkill = 50, noGetaway = 150, recommended = 175 },
        { zone = "Level 30-40 Zones", minSkill = 130, noGetaway = 225, recommended = 250 },
        { zone = "Level 40-50 Zones", minSkill = 205, noGetaway = 300, recommended = 330 },
        { zone = "Level 50-60 Zones", minSkill = 280, noGetaway = 330, recommended = 380 },
        -- TBC
        { zone = "Outland Zones", minSkill = 305, noGetaway = 395, recommended = 430 },
        { zone = "Highland Mixed School", minSkill = 355, noGetaway = 450, recommended = 480 },
    },
    
    farmingLocations = {
        -- ==================== 1-75 APPRENTICE ====================
        {
            skillRange = {1, 75},
            fishTypes = "Raw Brilliant Smallfish, Raw Longjaw Mud Snapper",
            locations = {
                {
                    zone = "Any Starting Zone",
                    faction = "Both",
                    spot = ProfessionHelper.L["FISHING_LOC_1_SPOT"],
                    tips = ProfessionHelper.L["FISHING_LOC_1_TIP"],
                    recommended = ProfessionHelper.L["FISHING_LOC_1_REC"],
                },
                {
                    zone = "Orgrimmar/Stormwind",
                    faction = "Respective",
                    spot = ProfessionHelper.L["FISHING_LOC_2_SPOT"],
                    tips = ProfessionHelper.L["FISHING_LOC_2_TIP"],
                    recommended = ProfessionHelper.L["FISHING_LOC_2_REC"],
                },
            },
        },
        
        -- ==================== 75-150 JOURNEYMAN ====================
        {
            skillRange = {75, 150},
            fishTypes = "Raw Bristle Whisker Catfish, Raw Rockscale Cod",
            locations = {
                {
                    zone = "The Barrens",
                    faction = "Horde",
                    spot = ProfessionHelper.L["FISHING_LOC_3_SPOT"],
                    tips = ProfessionHelper.L["FISHING_LOC_3_TIP"],
                    recommended = ProfessionHelper.L["FISHING_LOC_3_REC"],
                },
                {
                    zone = "Wetlands",
                    faction = "Alliance",
                    spot = ProfessionHelper.L["FISHING_LOC_4_SPOT"],
                    tips = ProfessionHelper.L["FISHING_LOC_4_TIP"],
                    recommended = ProfessionHelper.L["FISHING_LOC_4_REC"],
                },
                {
                    zone = "Hillsbrad Foothills",
                    faction = "Both",
                    spot = ProfessionHelper.L["FISHING_LOC_5_SPOT"],
                    tips = ProfessionHelper.L["FISHING_LOC_5_TIP"],
                    recommended = ProfessionHelper.L["FISHING_LOC_5_REC"],
                },
                {
                    zone = "Stranglethorn Vale",
                    faction = "Both",
                    spot = ProfessionHelper.L["FISHING_LOC_6_SPOT"],
                    tips = ProfessionHelper.L["FISHING_LOC_6_TIP"],
                    recommended = ProfessionHelper.L["FISHING_LOC_6_REC"],
                },
            },
        },
        
        -- ==================== 150-225 EXPERT ====================
        {
            skillRange = {150, 225},
            fishTypes = "Raw Bristle Whisker Catfish, Raw Mithril Head Trout, Firefin Snapper",
            locations = {
                {
                    zone = "Dustwallow Marsh",
                    faction = "Both",
                    spot = ProfessionHelper.L["FISHING_LOC_7_SPOT"],
                    tips = ProfessionHelper.L["FISHING_LOC_7_TIP"],
                    recommended = ProfessionHelper.L["FISHING_LOC_7_REC"],
                },
                {
                    zone = "Stranglethorn Vale",
                    faction = "Both",
                    spot = ProfessionHelper.L["FISHING_LOC_8_SPOT"],
                    tips = ProfessionHelper.L["FISHING_LOC_8_TIP"],
                    recommended = ProfessionHelper.L["FISHING_LOC_8_REC"],
                },
                {
                    zone = "Arathi Highlands",
                    faction = "Both",
                    spot = ProfessionHelper.L["FISHING_LOC_9_SPOT"],
                    tips = ProfessionHelper.L["FISHING_LOC_9_TIP"],
                    recommended = ProfessionHelper.L["FISHING_LOC_9_REC"],
                },
                {
                    zone = "Desolace",
                    faction = "Both",
                    spot = ProfessionHelper.L["FISHING_LOC_10_SPOT"],
                    tips = ProfessionHelper.L["FISHING_LOC_10_TIP"],
                    recommended = ProfessionHelper.L["FISHING_LOC_10_REC"],
                },
                {
                    zone = "Alterac Mountains / Swamp of Sorrows",
                    faction = "Both",
                    spot = ProfessionHelper.L["FISHING_LOC_11_SPOT"],
                    tips = ProfessionHelper.L["FISHING_LOC_11_TIP"],
                    recommended = ProfessionHelper.L["FISHING_LOC_11_REC"],
                },
            },
        },
        
        -- ==================== 225-300 ARTISAN ====================
        {
            skillRange = {225, 300},
            fishTypes = "Raw Nightfin Snapper, Raw Sunscale Salmon, Large Raw Mightfish, Raw Whitescale Salmon",
            locations = {
                {
                    zone = "Felwood",
                    faction = "Both",
                    spot = ProfessionHelper.L["FISHING_LOC_12_SPOT"],
                    tips = ProfessionHelper.L["FISHING_LOC_12_TIP"],
                    recommended = ProfessionHelper.L["FISHING_LOC_12_REC"],
                },
                {
                    zone = "Feralas",
                    faction = "Both",
                    spot = ProfessionHelper.L["FISHING_LOC_13_SPOT"],
                    tips = ProfessionHelper.L["FISHING_LOC_13_TIP"],
                    recommended = ProfessionHelper.L["FISHING_LOC_13_REC"],
                },
                {
                    zone = "The Hinterlands",
                    faction = "Both",
                    spot = ProfessionHelper.L["FISHING_LOC_14_SPOT"],
                    tips = ProfessionHelper.L["FISHING_LOC_14_TIP"],
                    recommended = ProfessionHelper.L["FISHING_LOC_14_REC"],
                },
                {
                    zone = "Tanaris",
                    faction = "Both",
                    spot = ProfessionHelper.L["FISHING_LOC_15_SPOT"],
                    tips = ProfessionHelper.L["FISHING_LOC_15_TIP"],
                    recommended = ProfessionHelper.L["FISHING_LOC_15_REC"],
                },
                {
                    zone = "Un'Goro Crater",
                    faction = "Both",
                    spot = ProfessionHelper.L["FISHING_LOC_16_SPOT"],
                    tips = ProfessionHelper.L["FISHING_LOC_16_TIP"],
                    recommended = ProfessionHelper.L["FISHING_LOC_16_REC"],
                },
                {
                    zone = "Western Plaguelands",
                    faction = "Both",
                    spot = ProfessionHelper.L["FISHING_LOC_17_SPOT"],
                    tips = ProfessionHelper.L["FISHING_LOC_17_TIP"],
                    recommended = ProfessionHelper.L["FISHING_LOC_17_REC"],
                },
            },
        },
        
        -- ==================== 300-350 MASTER (TBC) ====================
        {
            skillRange = {300, 350},
            fishTypes = "Spotted Feltail, Zangarian Sporefish, Barbed Gill Trout",
            locations = {
                {
                    zone = "Zangarmarsh",
                    faction = "Both",
                    spot = ProfessionHelper.L["FISHING_LOC_18_SPOT"],
                    tips = ProfessionHelper.L["FISHING_LOC_18_TIP"],
                    recommended = ProfessionHelper.L["FISHING_LOC_18_REC"],
                    fish = {
                        "Zangarian Sporefish - cooks into Blackened Sporefish (stamina)",
                        "Spotted Feltail - common, good for skill",
                        "Barbed Gill Trout - cooks into various recipes",
                    },
                },
            },
        },
        
        -- ==================== 350-375 MASTER (TBC) ====================
        {
            skillRange = {350, 375},
            fishTypes = "Golden Darter, Figluster's Mudfish, Furious Crawdad, Spotted Feltail",
            locations = {
                {
                    zone = "Terokkar Forest",
                    faction = "Both",
                    spot = ProfessionHelper.L["FISHING_LOC_19_SPOT"],
                    tips = ProfessionHelper.L["FISHING_LOC_19_TIP"],
                    recommended = ProfessionHelper.L["FISHING_LOC_19_REC"],
                    fish = {
                        "Golden Darter - Golden Fish Sticks (+44 healing)",
                        "Spotted Feltail - common",
                    },
                },
                {
                    zone = "Nagrand",
                    faction = "Both",
                    spot = ProfessionHelper.L["FISHING_LOC_20_SPOT"],
                    tips = ProfessionHelper.L["FISHING_LOC_20_TIP"],
                    recommended = ProfessionHelper.L["FISHING_LOC_20_REC"],
                    fish = {
                        "Figluster's Mudfish - Grilled Mudfish (+20 agility)",
                        "Icefin Bluefish - catchable in clear lakes",
                    },
                },
                {
                    zone = "Terokkar Forest - Highland Mixed Schools",
                    faction = "Both",
                    spot = ProfessionHelper.L["FISHING_LOC_21_SPOT"],
                    tips = ProfessionHelper.L["FISHING_LOC_21_TIP"],
                    recommended = ProfessionHelper.L["FISHING_LOC_21_REC"],
                    fish = {
                        "Furious Crawdad - Spicy Crawdad (+30 stamina) - VERY VALUABLE",
                        "Golden Darter",
                        "Huge Spotted Feltail",
                    },
                },
            },
        },
    },
    
    -- Special fishing items and events
    specialItems = {
        {
            name = "Stranglethorn Fishing Extravaganza",
            location = "Stranglethorn Vale",
            time = "Sundays at 14:00 server time",
            rewards = "Arcanite Fishing Pole, Hook of the Master Angler, +35 Fishing skill boots",
            tips = ProfessionHelper.L["FISHING_SPEC_1_TIP"],
        },
        {
            name = "Mr. Pinchy",
            location = "Highland Mixed Schools (Terokkar Forest)",
            tips = ProfessionHelper.L["FISHING_SPEC_2_TIP"],
        },
        {
            name = "Weather-Beaten Journal",
            location = "Can be found in any fished crate",
            tips = ProfessionHelper.L["FISHING_SPEC_3_TIP"],
        },
    },
    
    -- Fishing gear
    equipment = {
        { name = "Strong Fishing Pole", bonus = "+5 Fishing", source = "Vendor" },
        { name = "Big Iron Fishing Pole", bonus = "+20 Fishing", source = "Shellfish Trap (Desolace)" },
        { name = "Seth's Graphite Fishing Pole", bonus = "+20 Fishing", source = "Quest: Rather Be Fishin' (Terokkar)" },
        { name = "Nat Pagle's Extreme Angler FC-5000", bonus = "+25 Fishing", source = "Quest: Nat Pagle, Angler Extreme" },
        { name = "Arcanite Fishing Pole", bonus = "+35 Fishing", source = "Stranglethorn Fishing Extravaganza" },
        { name = "Aquadynamic Fish Attractor", bonus = "+100 Fishing (lure)", source = "Crafted (Engineering)" },
        { name = "Sharpened Fish Hook", bonus = "+100 Fishing (lure)", source = "Quest reward (TBC)" },
        { name = "Bright Baubles", bonus = "+75 Fishing (lure)", source = "Vendor/Crafted" },
        { name = "Nightcrawlers", bonus = "+50 Fishing (lure)", source = "Vendor" },
        { name = "Lucky Fishing Hat", bonus = "+5 Fishing", source = "Rare Fish Extravaganza reward" },
        { name = "Nat Pagle's Extreme Anglin' Boots", bonus = "+5 Fishing", source = "Rare Fish Extravaganza reward" },
    },
    
    -- Leveling guide
    levelingGuide = {
        {
            range = {1, 75},
            tip = ProfessionHelper.L["FISHING_TIP_1_75"],
        },
        {
            range = {75, 150},
            tip = ProfessionHelper.L["FISHING_TIP_75_150"],
        },
        {
            range = {150, 225},
            tip = ProfessionHelper.L["FISHING_TIP_150_225"],
        },
        {
            range = {225, 300},
            tip = ProfessionHelper.L["FISHING_TIP_225_300"],
        },
        {
            range = {300, 350},
            tip = ProfessionHelper.L["FISHING_TIP_300_350"],
        },
        {
            range = {350, 375},
            tip = ProfessionHelper.L["FISHING_TIP_350_375"],
        },
    },
    
    -- Tips
    tips = {
        ProfessionHelper.L["FISHING_TIPS_1"],
        ProfessionHelper.L["FISHING_TIPS_2"],
        ProfessionHelper.L["FISHING_TIPS_3"],
        ProfessionHelper.L["FISHING_TIPS_4"],
        ProfessionHelper.L["FISHING_TIPS_5"],
        ProfessionHelper.L["FISHING_TIPS_6"],
        ProfessionHelper.L["FISHING_TIPS_7"],
        ProfessionHelper.L["FISHING_TIPS_8"],
        ProfessionHelper.L["FISHING_TIPS_9"],
        ProfessionHelper.L["FISHING_TIPS_10"],
    },
}
