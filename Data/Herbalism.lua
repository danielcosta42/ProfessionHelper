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
                    route = ProfessionHelper.L["HERBALISM_LOC_1_ROUTE"],
                    tips = ProfessionHelper.L["HERBALISM_LOC_1_TIP"],
                    levelRange = "1-10",
                },
                {
                    zone = "Elwynn Forest",
                    faction = "Alliance",
                    route = ProfessionHelper.L["HERBALISM_LOC_2_ROUTE"],
                    tips = ProfessionHelper.L["HERBALISM_LOC_2_TIP"],
                    levelRange = "1-10",
                },
                {
                    zone = "Durotar",
                    faction = "Horde",
                    route = ProfessionHelper.L["HERBALISM_LOC_3_ROUTE"],
                    tips = ProfessionHelper.L["HERBALISM_LOC_3_TIP"],
                    levelRange = "1-10",
                },
                {
                    zone = "Mulgore",
                    faction = "Horde",
                    route = ProfessionHelper.L["HERBALISM_LOC_4_ROUTE"],
                    tips = ProfessionHelper.L["HERBALISM_LOC_4_TIP"],
                    levelRange = "1-10",
                },
                {
                    zone = "Teldrassil",
                    faction = "Alliance",
                    route = ProfessionHelper.L["HERBALISM_LOC_5_ROUTE"],
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
                    route = ProfessionHelper.L["HERBALISM_LOC_6_ROUTE"],
                    tips = ProfessionHelper.L["HERBALISM_LOC_6_TIP"],
                    levelRange = "10-25",
                },
                {
                    zone = "Westfall",
                    faction = "Alliance",
                    route = ProfessionHelper.L["HERBALISM_LOC_7_ROUTE"],
                    tips = ProfessionHelper.L["HERBALISM_LOC_7_TIP"],
                    levelRange = "10-20",
                },
                {
                    zone = "Silverpine Forest",
                    faction = "Horde",
                    route = ProfessionHelper.L["HERBALISM_LOC_8_ROUTE"],
                    tips = ProfessionHelper.L["HERBALISM_LOC_8_TIP"],
                    levelRange = "10-20",
                },
                {
                    zone = "Darkshore",
                    faction = "Alliance",
                    route = ProfessionHelper.L["HERBALISM_LOC_9_ROUTE"],
                    tips = ProfessionHelper.L["HERBALISM_LOC_9_TIP"],
                    levelRange = "10-20",
                },
                {
                    zone = "Loch Modan",
                    faction = "Alliance",
                    route = ProfessionHelper.L["HERBALISM_LOC_10_ROUTE"],
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
                    route = ProfessionHelper.L["HERBALISM_LOC_11_ROUTE"],
                    tips = ProfessionHelper.L["HERBALISM_LOC_11_TIP"],
                    levelRange = "20-30",
                },
                {
                    zone = "Stonetalon Mountains",
                    faction = "Both",
                    route = ProfessionHelper.L["HERBALISM_LOC_12_ROUTE"],
                    tips = ProfessionHelper.L["HERBALISM_LOC_12_TIP"],
                    levelRange = "15-27",
                },
                {
                    zone = "Wetlands",
                    faction = "Alliance",
                    route = ProfessionHelper.L["HERBALISM_LOC_13_ROUTE"],
                    tips = ProfessionHelper.L["HERBALISM_LOC_13_TIP"],
                    levelRange = "20-30",
                },
                {
                    zone = "Ashenvale",
                    faction = "Both",
                    route = ProfessionHelper.L["HERBALISM_LOC_14_ROUTE"],
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
                    route = ProfessionHelper.L["HERBALISM_LOC_15_ROUTE"],
                    tips = ProfessionHelper.L["HERBALISM_LOC_15_TIP"],
                    levelRange = "30-45",
                },
                {
                    zone = "Arathi Highlands",
                    faction = "Both",
                    route = ProfessionHelper.L["HERBALISM_LOC_16_ROUTE"],
                    tips = ProfessionHelper.L["HERBALISM_LOC_16_TIP"],
                    levelRange = "30-40",
                },
                {
                    zone = "Swamp of Sorrows",
                    faction = "Both",
                    route = ProfessionHelper.L["HERBALISM_LOC_17_ROUTE"],
                    tips = ProfessionHelper.L["HERBALISM_LOC_17_TIP"],
                    levelRange = "35-45",
                },
                {
                    zone = "The Hinterlands",
                    faction = "Both",
                    route = ProfessionHelper.L["HERBALISM_LOC_18_ROUTE"],
                    tips = ProfessionHelper.L["HERBALISM_LOC_18_TIP"],
                    levelRange = "40-50",
                },
                {
                    zone = "Alterac Mountains",
                    faction = "Both",
                    route = ProfessionHelper.L["HERBALISM_LOC_38_ROUTE"],
                    tips = ProfessionHelper.L["HERBALISM_LOC_38_TIP"],
                    levelRange = "35-45",
                },
                {
                    zone = "Feralas",
                    faction = "Both",
                    route = ProfessionHelper.L["HERBALISM_LOC_19_ROUTE"],
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
                    route = ProfessionHelper.L["HERBALISM_LOC_20_ROUTE"],
                    tips = ProfessionHelper.L["HERBALISM_LOC_20_TIP"],
                    levelRange = "40-50",
                },
                {
                    zone = "Felwood",
                    faction = "Both",
                    route = ProfessionHelper.L["HERBALISM_LOC_21_ROUTE"],
                    tips = ProfessionHelper.L["HERBALISM_LOC_21_TIP"],
                    levelRange = "48-55",
                },
                {
                    zone = "Searing Gorge",
                    faction = "Both",
                    route = ProfessionHelper.L["HERBALISM_LOC_22_ROUTE"],
                    tips = ProfessionHelper.L["HERBALISM_LOC_22_TIP"],
                    levelRange = "43-50",
                },
                {
                    zone = "Blasted Lands",
                    faction = "Both",
                    route = ProfessionHelper.L["HERBALISM_LOC_23_ROUTE"],
                    tips = ProfessionHelper.L["HERBALISM_LOC_23_TIP"],
                    levelRange = "45-55",
                },
                {
                    zone = "Un'Goro Crater",
                    faction = "Both",
                    route = ProfessionHelper.L["HERBALISM_LOC_24_ROUTE"],
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
                    route = ProfessionHelper.L["HERBALISM_LOC_25_ROUTE"],
                    tips = ProfessionHelper.L["HERBALISM_LOC_25_TIP"],
                    levelRange = "53-60",
                },
                {
                    zone = "Winterspring",
                    faction = "Both",
                    route = ProfessionHelper.L["HERBALISM_LOC_26_ROUTE"],
                    tips = ProfessionHelper.L["HERBALISM_LOC_26_TIP"],
                    levelRange = "55-60",
                },
                {
                    zone = "Silithus",
                    faction = "Both",
                    route = ProfessionHelper.L["HERBALISM_LOC_27_ROUTE"],
                    tips = ProfessionHelper.L["HERBALISM_LOC_27_TIP"],
                    levelRange = "55-60",
                },
                {
                    zone = "Azshara",
                    faction = "Both",
                    route = ProfessionHelper.L["HERBALISM_LOC_28_ROUTE"],
                    tips = ProfessionHelper.L["HERBALISM_LOC_28_TIP"],
                    levelRange = "45-55",
                },
                {
                    zone = "Burning Steppes",
                    faction = "Both",
                    route = ProfessionHelper.L["HERBALISM_LOC_29_ROUTE"],
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
                    route = ProfessionHelper.L["HERBALISM_LOC_30_ROUTE"],
                    tips = ProfessionHelper.L["HERBALISM_LOC_30_TIP"],
                    levelRange = "58-63",
                },
                {
                    zone = "Zangarmarsh",
                    faction = "Both",
                    route = ProfessionHelper.L["HERBALISM_LOC_31_ROUTE"],
                    tips = ProfessionHelper.L["HERBALISM_LOC_31_TIP"],
                    levelRange = "60-64",
                },
                {
                    zone = "Terokkar Forest",
                    faction = "Both",
                    route = ProfessionHelper.L["HERBALISM_LOC_32_ROUTE"],
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
                    route = ProfessionHelper.L["HERBALISM_LOC_33_ROUTE"],
                    tips = ProfessionHelper.L["HERBALISM_LOC_33_TIP"],
                    levelRange = "62-65",
                },
                {
                    zone = "Dungeons (Coilfang/Auchindoun)",
                    faction = "Both",
                    route = ProfessionHelper.L["HERBALISM_LOC_34_ROUTE"],
                    tips = ProfessionHelper.L["HERBALISM_LOC_34_TIP"],
                    levelRange = "62-70",
                },
                {
                    zone = "Netherstorm",
                    faction = "Both",
                    route = ProfessionHelper.L["HERBALISM_LOC_35_ROUTE"],
                    tips = ProfessionHelper.L["HERBALISM_LOC_35_TIP"],
                    levelRange = "67-70",
                },
                {
                    zone = "Shadowmoon Valley",
                    faction = "Both",
                    route = ProfessionHelper.L["HERBALISM_LOC_36_ROUTE"],
                    tips = ProfessionHelper.L["HERBALISM_LOC_36_TIP"],
                    levelRange = "67-70",
                },
                {
                    zone = "Blade's Edge Mountains",
                    faction = "Both",
                    route = ProfessionHelper.L["HERBALISM_LOC_37_ROUTE"],
                    tips = ProfessionHelper.L["HERBALISM_LOC_37_TIP"],
                    levelRange = "65-68",
                },
            },
        },
        -- ==================== NORTHREND HERBS (375-450) ====================
        {
            skillRange = {375, 425},
            herb = "Goldclover, Tiger Lily, Talandra's Rose, Deadnettle",
            locations = {
                {
                    zone = "Howling Fjord",
                    faction = "Both",
                    route = "Coastal loops around the southern peninsula and eastern cliffs. Inland river valleys.",
                    tips  = "Best starter Northrend herb zone. Goldclover (350) and Tiger Lily (375) very abundant. Good for Inscription milling.",
                    levelRange = "68-72",
                },
                {
                    zone = "Grizzly Hills",
                    faction = "Both",
                    route = "Follow river banks and forest clearings. The Grizzlemaw area is especially dense.",
                    tips  = "Talandra's Rose (375) appears in Grizzly Hills. Dense spawns make this very efficient.",
                    levelRange = "73-75",
                },
                {
                    zone = "Borean Tundra",
                    faction = "Both",
                    route = "Southern and eastern areas near D.E.H.T.A. and Coldrock Quarry.",
                    tips  = "Goldclover is very abundant here. Deadnettle also appears as a secondary herb.",
                    levelRange = "68-72",
                },
            },
        },
        {
            skillRange = {425, 450},
            herb = "Adder's Tongue, Icethorn, Lichbloom, Frost Lotus",
            locations = {
                {
                    zone = "Sholazar Basin",
                    faction = "Both",
                    route = "Full perimeter loop of the basin, then cross through the center. Extremely dense.",
                    tips  = "BEST NORTHREND HERB ZONE. Adder's Tongue (400) is abundant everywhere. Great for Inscription milling — Azure Pigment → Ink of the Sea.",
                    levelRange = "76-78",
                },
                {
                    zone = "Storm Peaks",
                    faction = "Both",
                    route = "Valley floor between Ulduar and K3 (south), then eastern Storm Peaks.",
                    tips  = "Icethorn (435) + Lichbloom (435) give Icy Pigment → Snowfall Ink. Sell Snowfall Ink for big gold!",
                    levelRange = "77-80",
                },
                {
                    zone = "Icecrown",
                    faction = "Both",
                    route = "Outer ring of Icecrown, following cliff edges south and east of the Citadel.",
                    tips  = "Mix of Icethorn and Lichbloom. Frost Lotus spawns rarely alongside other herbs \u2014 very valuable!",
                    levelRange = "77-80",
                },
            },
        },
        -- ==================== CATACLYSM HERBS (450-525) ====================
        {
            skillRange = {450, 500},
            herb = "Cinderbloom, Stormvine, Heartblossom, Azshara's Veil",
            locations = {
                {
                    zone = "Mount Hyjal",
                    faction = "Both",
                    route = "Lower Hyjal near Nordrassil, then spiral upward through the Ashen Fields.",
                    tips  = "Cinderbloom (425) is extremely abundant. Best zone for Alchemy Elixir of the Cobra mats.",
                    levelRange = "80-82",
                },
                {
                    zone = "Deepholm",
                    faction = "Both",
                    route = "Outer ring of the zone, particularly around the Temple of Earth.",
                    tips  = "Heartblossom (475) only spawns in Deepholm — required for Alchemy Elixir of Deep Earth and Potion of Deepholm.",
                    levelRange = "82-83",
                },
                {
                    zone = "Vashj'ir — Shimmering Expanse",
                    faction = "Both",
                    route = "Mid-depth areas of Shimmering Expanse, sweeping around the kelp forests.",
                    tips  = "Azshara's Veil (475) only in Vashj'ir. Requires underwater breathing or Vashj'ir seahorse. Good value herb.",
                    levelRange = "80-82",
                },
            },
        },
        {
            skillRange = {500, 525},
            herb = "Twilight Jasmine, Whiptail",
            locations = {
                {
                    zone = "Twilight Highlands",
                    faction = "Both",
                    route = "Northern and eastern Highlands near the Vermillion Redoubt. Loop through Bloodgulch.",
                    tips  = "Twilight Jasmine (500) only in Twilight Highlands. Required for high-end Alchemy flasks. Pairs with Inscription milling.",
                    levelRange = "84-85",
                },
                {
                    zone = "Uldum",
                    faction = "Both",
                    route = "Northern Uldum near Ramkahen. Whiptail spawns densely along the Nile-like river.",
                    tips  = "Whiptail (500) in Uldum is incredibly dense. Best zone for Whiptail. Pair with Archaeology dig sites here!",
                    levelRange = "83-85",
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
        -- ==================== GRAND MASTER / WRATH (375-450) ====================
        {
            range = {375, 420},
            tip = "Pick Goldclover (skill 350), Tiger Lily (375), and Talandra's Rose (375) in Howling Fjord and Grizzly Hills. Excellent for Inscription milling.",
        },
        {
            range = {420, 450},
            tip = "Pick Adder's Tongue (skill 400) in Sholazar Basin — best single zone for Inscription inks. Pick Icethorn (435) and Lichbloom (435) in Storm Peaks and Icecrown for Snowfall Ink. Frost Lotus (450) spawns as rare bonus near high-level herbs.",
        },
        -- ==================== ILLUSTRIOUS / CATA (450-525) ====================
        {
            range = {450, 500},
            tip = "Pick Cinderbloom (skill 425) in Mount Hyjal and Deepholm. Pick Stormvine (425) in Vashj'ir. Pick Heartblossom (475) in Deepholm — high value for Alchemy.",
        },
        {
            range = {500, 525},
            tip = "Pick Twilight Jasmine (500) in Twilight Highlands — highest skill requirement herb. Pick Whiptail (500) in Uldum alongside Tol'vir dig sites. Pick Azshara's Veil (475) in Vashj'ir for Alchemy Potion of the Tol'vir.",
        },
    },

    -- ===================================================================
    -- SINERGIAS
    -- ===================================================================
    synergies = {
        {
            profession = "Alchemy",
            type       = "primary",
            benefit    = "A sinergia número 1 do jogo: herbs direto para flasks, elixires e poções. Mil% de retorno sobre custo zero.",
            tip        = "Northrend: Adder's Tongue (Sholazar Basin) e Goldclover (Grizzly Hills) são as herbs mais versáteis.",
        },
        {
            profession = "Inscription",
            type       = "primary",
            benefit    = "Herbs são moaías para Pigments → Inks → Glyphs. Use o Ink Trader em Dalaran para simplificar.",
            tip        = "Colheita de herbs baratas (Goldclover, Adder's Tongue) cobre TODO o nivelamento de Inscription.",
        },
        {
            profession = "Mining",
            type       = "economy",
            benefit    = "Gathering duplo: herb+ore em uma única volta do mapa. Ideal para acumular materiais para craftings.",
        },
    },
}
