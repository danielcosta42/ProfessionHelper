-- Profession Helper - Herbalism Data (Gathering Profession)
ProfessionHelper = ProfessionHelper or {}
ProfessionHelper.Herbalism = {
    name = "Herbalism",
    type = "gathering",
    
    trainer = {
        ["Alliance"] = {
            "Alma Jainrose (Elwynn Forest)",
            "Tannysa (Stormwind)",
            "Firodren Mooncaller (Darnassus)",
            "Rorelien (Shattrath)",
        },
        ["Horde"] = {
            "Komin Winterhoof (Thunder Bluff)",
            "Jandi (Orgrimmar)",
            "Martha Alliestar (Undercity)",
            "Rorelien (Shattrath)",
        },
    },
    
    skillRanges = {
        { herb = "Peacebloom", skillRequired = 1, skillYellow = 25, skillGreen = 50, skillGrey = 100 },
        { herb = "Silverleaf", skillRequired = 1, skillYellow = 25, skillGreen = 50, skillGrey = 100 },
        { herb = "Earthroot", skillRequired = 15, skillYellow = 40, skillGreen = 65, skillGrey = 115 },
        { herb = "Mageroyal", skillRequired = 50, skillYellow = 75, skillGreen = 100, skillGrey = 150 },
        { herb = "Briarthorn", skillRequired = 70, skillYellow = 95, skillGreen = 120, skillGrey = 170 },
        { herb = "Stranglekelp", skillRequired = 85, skillYellow = 110, skillGreen = 135, skillGrey = 185 },
        { herb = "Bruiseweed", skillRequired = 100, skillYellow = 125, skillGreen = 150, skillGrey = 200 },
        { herb = "Wild Steelbloom", skillRequired = 115, skillYellow = 140, skillGreen = 165, skillGrey = 215 },
        { herb = "Grave Moss", skillRequired = 120, skillYellow = 145, skillGreen = 170, skillGrey = 220 },
        { herb = "Kingsblood", skillRequired = 125, skillYellow = 150, skillGreen = 175, skillGrey = 225 },
        { herb = "Liferoot", skillRequired = 150, skillYellow = 175, skillGreen = 200, skillGrey = 250 },
        { herb = "Fadeleaf", skillRequired = 160, skillYellow = 185, skillGreen = 210, skillGrey = 260 },
        { herb = "Goldthorn", skillRequired = 170, skillYellow = 195, skillGreen = 220, skillGrey = 270 },
        { herb = "Khadgar's Whisker", skillRequired = 185, skillYellow = 210, skillGreen = 235, skillGrey = 285 },
        { herb = "Firebloom", skillRequired = 205, skillYellow = 230, skillGreen = 255, skillGrey = 305 },
        { herb = "Purple Lotus", skillRequired = 210, skillYellow = 235, skillGreen = 260, skillGrey = 310 },
        { herb = "Arthas' Tears", skillRequired = 220, skillYellow = 245, skillGreen = 270, skillGrey = 320 },
        { herb = "Sungrass", skillRequired = 230, skillYellow = 255, skillGreen = 280, skillGrey = 330 },
        { herb = "Blindweed", skillRequired = 235, skillYellow = 260, skillGreen = 285, skillGrey = 335 },
        { herb = "Ghost Mushroom", skillRequired = 245, skillYellow = 270, skillGreen = 295, skillGrey = 345 },
        { herb = "Gromsblood", skillRequired = 250, skillYellow = 275, skillGreen = 300, skillGrey = 350 },
        { herb = "Golden Sansam", skillRequired = 260, skillYellow = 285, skillGreen = 310, skillGrey = 360 },
        { herb = "Dreamfoil", skillRequired = 270, skillYellow = 295, skillGreen = 320, skillGrey = 370 },
        { herb = "Mountain Silversage", skillRequired = 280, skillYellow = 305, skillGreen = 330, skillGrey = 380 },
        { herb = "Plaguebloom", skillRequired = 285, skillYellow = 310, skillGreen = 335, skillGrey = 385 },
        { herb = "Icecap", skillRequired = 290, skillYellow = 315, skillGreen = 340, skillGrey = 390 },
        { herb = "Black Lotus", skillRequired = 300, skillYellow = 300, skillGreen = 300, skillGrey = 300 },
        -- TBC Herbs
        { herb = "Felweed", skillRequired = 300, skillYellow = 325, skillGreen = 350, skillGrey = 400 },
        { herb = "Dreaming Glory", skillRequired = 315, skillYellow = 340, skillGreen = 365, skillGrey = 415 },
        { herb = "Ragveil", skillRequired = 325, skillYellow = 350, skillGreen = 375, skillGrey = 425 },
        { herb = "Flame Cap", skillRequired = 335, skillYellow = 360, skillGreen = 385, skillGrey = 435 },
        { herb = "Terocone", skillRequired = 325, skillYellow = 350, skillGreen = 375, skillGrey = 425 },
        { herb = "Ancient Lichen", skillRequired = 340, skillYellow = 365, skillGreen = 390, skillGrey = 440 },
        { herb = "Netherbloom", skillRequired = 350, skillYellow = 375, skillGreen = 400, skillGrey = 450 },
        { herb = "Nightmare Vine", skillRequired = 365, skillYellow = 390, skillGreen = 415, skillGrey = 465 },
        { herb = "Mana Thistle", skillRequired = 375, skillYellow = 400, skillGreen = 425, skillGrey = 475 },
    },
    
    farmingLocations = {
        -- ==================== PEACEBLOOM/SILVERLEAF/EARTHROOT (1-70) ====================
        {
            skillRange = {1, 70},
            herb = "Peacebloom, Silverleaf, Earthroot",
            locations = {
                {
                    zone = "Tirisfal Glades",
                    faction = "Horde",
                    route = "Circle around Brill and head toward Deathknell. Many herbs near the fields and roads.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_1_TIP"],
                    levelRange = "1-10",
                },
                {
                    zone = "Elwynn Forest",
                    faction = "Alliance",
                    route = "Large circle around Goldshire, passing through Northshire Valley and Stone Cairn Lake.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_2_TIP"],
                    levelRange = "1-10",
                },
                {
                    zone = "Durotar",
                    faction = "Horde",
                    route = "Circle from Razor Hill to Sen'jin Village and back to Orgrimmar.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_3_TIP"],
                    levelRange = "1-10",
                },
                {
                    zone = "Mulgore",
                    faction = "Horde",
                    route = "Large circle around Bloodhoof Village and Thunder Bluff.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_4_TIP"],
                    levelRange = "1-10",
                },
                {
                    zone = "Teldrassil",
                    faction = "Alliance",
                    route = "Circle around Dolanaar and Shadowglen.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_5_TIP"],
                    levelRange = "1-10",
                },
            },
        },
        
        -- ==================== MAGEROYAL/BRIARTHORN (50-100) ====================
        {
            skillRange = {50, 100},
            herb = "Mageroyal, Briarthorn",
            locations = {
                {
                    zone = "The Barrens",
                    faction = "Horde",
                    route = "Large circle from Crossroads south to Camp Taurajo, then to Ratchet.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_6_TIP"],
                    levelRange = "10-25",
                },
                {
                    zone = "Westfall",
                    faction = "Alliance",
                    route = "Circle the entire zone, focusing on the fields and near the farms.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_7_TIP"],
                    levelRange = "10-20",
                },
                {
                    zone = "Silverpine Forest",
                    faction = "Horde",
                    route = "Follow the road from Undercity south to Pyrewood Village.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_8_TIP"],
                    levelRange = "10-20",
                },
                {
                    zone = "Darkshore",
                    faction = "Alliance",
                    route = "Follow the coast from Auberdine north and south, then return through the forest.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_9_TIP"],
                    levelRange = "10-20",
                },
                {
                    zone = "Loch Modan",
                    faction = "Alliance",
                    route = "Circle the lake and the mountainous areas around it.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_10_TIP"],
                    levelRange = "10-20",
                },
            },
        },
        
        -- ==================== BRUISEWEED/WILD STEELBLOOM/KINGSBLOOD (100-150) ====================
        {
            skillRange = {100, 150},
            herb = "Bruiseweed, Wild Steelbloom, Kingsblood",
            locations = {
                {
                    zone = "Hillsbrad Foothills",
                    faction = "Both",
                    route = "Large circle through Tarren Mill/Southshore and surrounding mountains.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_11_TIP"],
                    levelRange = "20-30",
                },
                {
                    zone = "Stonetalon Mountains",
                    faction = "Both",
                    route = "Circle the mountains around Stonetalon Peak and Sun Rock Retreat.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_12_TIP"],
                    levelRange = "15-27",
                },
                {
                    zone = "Wetlands",
                    faction = "Alliance",
                    route = "Follow the coast then pass through the swampy areas around Menethil.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_13_TIP"],
                    levelRange = "20-30",
                },
                {
                    zone = "Ashenvale",
                    faction = "Both",
                    route = "Large circle through Astranaar/Splintertree Post and the surrounding forest.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_14_TIP"],
                    levelRange = "18-30",
                },
            },
        },
        
        -- ==================== LIFEROOT/FADELEAF/GOLDTHORN (150-200) ====================
        {
            skillRange = {150, 200},
            herb = "Liferoot, Fadeleaf, Goldthorn, Khadgar's Whisker",
            locations = {
                {
                    zone = "Stranglethorn Vale",
                    faction = "Both",
                    route = "Large circle through the entire zone, focusing on jungle areas.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_15_TIP"],
                    levelRange = "30-45",
                },
                {
                    zone = "Arathi Highlands",
                    faction = "Both",
                    route = "Circle the mountains and pass through the fields around Stromgarde.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_16_TIP"],
                    levelRange = "30-40",
                },
                {
                    zone = "Swamp of Sorrows",
                    faction = "Both",
                    route = "Circle the swamp, especially near Stonard and Pool of Tears.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_17_TIP"],
                    levelRange = "35-45",
                },
                {
                    zone = "The Hinterlands",
                    faction = "Both",
                    route = "Large circle through Aerie Peak/Revantusk Village and the forest.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_18_TIP"],
                    levelRange = "40-50",
                },
                {
                    zone = "Alterac Mountains",
                    faction = "Both",
                    route = "Circle the ruins of Alterac City and Strahnbrad through the mountains. Best zone for Fadeleaf — extremely dense nodes.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_38_TIP"],
                    levelRange = "35-45",
                },
                {
                    zone = "Feralas",
                    faction = "Both",
                    route = "Circle the forest edges and pass through Camp Mojache/Feathermoon.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_19_TIP"],
                    levelRange = "40-50",
                },
            },
        },
        
        -- ==================== FIREBLOOM/PURPLE LOTUS/SUNGRASS (200-260) ====================
        {
            skillRange = {200, 260},
            herb = "Firebloom, Purple Lotus, Sungrass, Arthas' Tears",
            locations = {
                {
                    zone = "Tanaris",
                    faction = "Both",
                    route = "Large circle around Gadgetzan through the desert.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_20_TIP"],
                    levelRange = "40-50",
                },
                {
                    zone = "Felwood",
                    faction = "Both",
                    route = "Follow the road from south to north through the zone.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_21_TIP"],
                    levelRange = "48-55",
                },
                {
                    zone = "Searing Gorge",
                    faction = "Both",
                    route = "Circle the edges of the zone and pass through the caves.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_22_TIP"],
                    levelRange = "43-50",
                },
                {
                    zone = "Blasted Lands",
                    faction = "Both",
                    route = "Circle the entire zone, especially near the Dark Portal.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_23_TIP"],
                    levelRange = "45-55",
                },
                {
                    zone = "Un'Goro Crater",
                    faction = "Both",
                    route = "Large circle inside the crater through all environments.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_24_TIP"],
                    levelRange = "48-55",
                },
            },
        },
        
        -- ==================== GOLDEN SANSAM/DREAMFOIL/MOUNTAIN SILVERSAGE (260-300) ====================
        {
            skillRange = {260, 300},
            herb = "Golden Sansam, Dreamfoil, Mountain Silversage, Plaguebloom, Icecap",
            locations = {
                {
                    zone = "Eastern Plaguelands",
                    faction = "Both",
                    route = "Large circle through Light's Hope Chapel and surrounding ruins.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_25_TIP"],
                    levelRange = "53-60",
                },
                {
                    zone = "Winterspring",
                    faction = "Both",
                    route = "Large circle around Everlook and through the ice mountains.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_26_TIP"],
                    levelRange = "55-60",
                },
                {
                    zone = "Silithus",
                    faction = "Both",
                    route = "Circle around Cenarion Hold and the Qiraji ruins.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_27_TIP"],
                    levelRange = "55-60",
                },
                {
                    zone = "Azshara",
                    faction = "Both",
                    route = "Circle the coast and the elven ruins.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_28_TIP"],
                    levelRange = "45-55",
                },
                {
                    zone = "Burning Steppes",
                    faction = "Both",
                    route = "Circle the mountains around Morgan's Vigil/Flame Crest.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_29_TIP"],
                    levelRange = "50-58",
                },
            },
        },
        
        -- ==================== FELWEED/DREAMING GLORY (300-340) ====================
        {
            skillRange = {300, 340},
            herb = "Felweed, Dreaming Glory, Ragveil",
            locations = {
                {
                    zone = "Hellfire Peninsula",
                    faction = "Both",
                    route = "Large circle from Honor Hold/Thrallmar through the entire zone.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_30_TIP"],
                    levelRange = "58-63",
                },
                {
                    zone = "Zangarmarsh",
                    faction = "Both",
                    route = "Circle the lakes and mushrooms around Cenarion Refuge.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_31_TIP"],
                    levelRange = "60-64",
                },
                {
                    zone = "Terokkar Forest",
                    faction = "Both",
                    route = "Circle the forest around Shattrath and Allerian/Stonebreaker.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_32_TIP"],
                    levelRange = "62-65",
                },
            },
        },
        
        -- ==================== TEROCONE/ANCIENT LICHEN/NETHERBLOOM (340-375) ====================
        {
            skillRange = {340, 375},
            herb = "Terocone, Ancient Lichen, Netherbloom, Nightmare Vine, Mana Thistle",
            locations = {
                {
                    zone = "Terokkar Forest",
                    faction = "Both",
                    route = "Focus on the dense forest and near Auchindoun.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_33_TIP"],
                    levelRange = "62-65",
                },
                {
                    zone = "Dungeons (Coilfang/Auchindoun)",
                    faction = "Both",
                    route = "Inside the Coilfang Reservoir and Auchindoun dungeons.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_34_TIP"],
                    levelRange = "62-70",
                },
                {
                    zone = "Netherstorm",
                    faction = "Both",
                    route = "Circle the island edges and the eco-domes.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_35_TIP"],
                    levelRange = "67-70",
                },
                {
                    zone = "Shadowmoon Valley",
                    faction = "Both",
                    route = "Circle around the Black Temple and through the mountains.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_36_TIP"],
                    levelRange = "67-70",
                },
                {
                    zone = "Blade's Edge Mountains",
                    faction = "Both",
                    route = "Focus on the rocky edges and plateaus.",
                    tips = ProfessionHelper.L["HERBALISM_LOC_37_TIP"],
                    levelRange = "65-68",
                },
            },
        },
    },
    
    -- Leveling guide
    levelingGuide = {
        {
            range = {1, 70},
            tip = ProfessionHelper.L["HERBALISM_TIP_1_70"],
        },
        {
            range = {70, 115},
            tip = ProfessionHelper.L["HERBALISM_TIP_70_115"],
        },
        {
            range = {115, 150},
            tip = ProfessionHelper.L["HERBALISM_TIP_115_150"],
        },
        {
            range = {150, 205},
            tip = ProfessionHelper.L["HERBALISM_TIP_150_205"],
        },
        {
            range = {205, 260},
            tip = ProfessionHelper.L["HERBALISM_TIP_205_260"],
        },
        {
            range = {260, 300},
            tip = ProfessionHelper.L["HERBALISM_TIP_260_300"],
        },
        {
            range = {300, 340},
            tip = ProfessionHelper.L["HERBALISM_TIP_300_340"],
        },
        {
            range = {340, 375},
            tip = ProfessionHelper.L["HERBALISM_TIP_340_375"],
        },
    },
}
