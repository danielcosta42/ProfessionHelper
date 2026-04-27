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
            "Hurnak Grimmord (Shattrath — Master)",
            "Fendrig Redbeard (Howling Fjord — Valgarde — Grand Master)",
            "Tansy Puddlefizz (Borean Tundra — Valiance Keep — Grand Master)",
        },
        ["Horde"] = {
            "Makaru (Orgrimmar)",
            "Brom Killian (Undercity)",
            "Brek Stonehoof (Thunder Bluff)",
            "Hurnak Grimmord (Shattrath — Master)",
            "Brunna Ironaxe (Howling Fjord — Vengeance Landing — Grand Master)",
            "Crog Steelspine (Borean Tundra — Warsong Hold — Grand Master)",
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
        -- WotLK Ores
        {
            ore = "Cobalt Ore",
            skillRequired = 350,
            skillYellow = 375,
            skillGreen = 400,
            skillGrey = 450,
        },
        {
            ore = "Saronite Ore",
            skillRequired = 400,
            skillYellow = 425,
            skillGreen = 450,
            skillGrey = 500,
        },
        {
            ore = "Titanium Ore",
            skillRequired = 450,
            skillYellow = 475,
            skillGreen = 500,
            skillGrey = 550,
        },
        -- Cataclysm Ores
        {
            ore = "Obsidium Ore",
            skillRequired = 425,
            skillYellow = 450,
            skillGreen = 475,
            skillGrey = 525,
        },
        {
            ore = "Elementium Ore",
            skillRequired = 475,
            skillYellow = 500,
            skillGreen = 525,
            skillGrey = 575,
        },
        {
            ore = "Pyrite Ore",
            skillRequired = 500,
            skillYellow = 525,
            skillGreen = 550,
            skillGrey = 600,
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
        -- ==================== COBALT / WRATH (375-425) ====================
        {
            skillRange = {375, 425},
            ore = "Cobalt Ore",
            locations = {
                {
                    zone = "Howling Fjord",
                    faction = "Both",
                    route = "Fly the eastern and southern coastline, then loop through the interior hillsides.",
                    tips  = "Best starter Northrend zone for Cobalt. Very dense node spawns along cliffs and coast.",
                    levelRange = "68-72",
                },
                {
                    zone = "Borean Tundra",
                    faction = "Both",
                    route = "Fly the northern and eastern ridges. Cobalt nodes cluster around rocky outcroppings.",
                    tips  = "Good alternative to Howling Fjord. Also drops Crystallized Earth alongside ore.",
                    levelRange = "68-72",
                },
                {
                    zone = "Dragonblight",
                    faction = "Both",
                    route = "Figure-8 around the central frozen plains and the Star's Rest / Wyrmrest area.",
                    tips  = "Mix of Cobalt and early Saronite. Good for transitioning at skill 400+.",
                    levelRange = "72-75",
                },
            },
        },
        -- ==================== SARONITE / TITANIUM (425-450) ====================
        {
            skillRange = {425, 450},
            ore = "Saronite Ore, Titanium Ore",
            locations = {
                {
                    zone = "Icecrown",
                    faction = "Both",
                    route = "Outer ring of Icecrown, following the cliff edges. Some interior loops around Argent Tournament.",
                    tips  = "Best overall Saronite zone. Titanium nodes also appear here \u2014 very valuable. Bring epic flying!",
                    levelRange = "77-80",
                },
                {
                    zone = "Storm Peaks",
                    faction = "Both",
                    route = "Follow the valley floor between Ulduar and K3. The eastern finger south of Dun Niffelem is excellent.",
                    tips  = "High Titanium density alongside Saronite. Best zone for Titanium farming specifically.",
                    levelRange = "77-80",
                },
                {
                    zone = "Zul'Drak",
                    faction = "Both",
                    route = "Outer ring of the zone, hugging the cliffs.",
                    tips  = "Dense Saronite spawns. Lower Titanium count than Storm Peaks but faster Saronite route.",
                    levelRange = "74-77",
                },
            },
        },
        -- ==================== OBSIDIUM / CATA (450-500) ====================
        {
            skillRange = {450, 500},
            ore = "Obsidium Ore",
            locations = {
                {
                    zone = "Mount Hyjal",
                    faction = "Both",
                    route = "Lower and mid zones of Hyjal, especially near the Ashen Fields and Firelands Invasion area.",
                    tips  = "Best Obsidium zone. Very compact with high node density. Also drops Volatile Earth.",
                    levelRange = "80-82",
                },
                {
                    zone = "Deepholm",
                    faction = "Both",
                    route = "The Ring of Earths outer perimeter and Temple of Earth area.",
                    tips  = "Good Obsidium density. Also has some Elementium nodes appearing at higher levels.",
                    levelRange = "82-83",
                },
                {
                    zone = "Vashj'ir",
                    faction = "Both",
                    route = "Shimmering Expanse and Abyssal Depths ocean floor.",
                    tips  = "Underwater but very high node count. Requires Abyssal Seahorse mount for efficient farming.",
                    levelRange = "80-82",
                },
            },
        },
        -- ==================== ELEMENTIUM / PYRITE (500-525) ====================
        {
            skillRange = {500, 525},
            ore = "Elementium Ore, Pyrite Ore",
            locations = {
                {
                    zone = "Twilight Highlands",
                    faction = "Both",
                    route = "Loop through Bloodgulch and the Verrall Delta. Eastern highlands have the best density.",
                    tips  = "Best Elementium zone. Pyrite appears alongside Elementium \u2014 can contain uncommon/rare Cata gems!",
                    levelRange = "84-85",
                },
                {
                    zone = "Uldum",
                    faction = "Both",
                    route = "Northern and eastern Uldum around Ramkahen and the Oasis area.",
                    tips  = "Excellent combined Elementium + Pyrite zone. Good to pair with Archaeology dig sites here.",
                    levelRange = "83-85",
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
        { name = "Smelt Khorium", skill = 375, materials = {{ name = "Khorium Ore", count = 1 }} },        -- Wrath
        { name = "Smelt Cobalt",       skill = 350, materials = {{ name = "Cobalt Ore",     count = 1 }} },
        { name = "Smelt Saronite",     skill = 400, materials = {{ name = "Saronite Ore",   count = 2 }} },
        { name = "Smelt Titanium",     skill = 450, materials = {{ name = "Titanium Ore",   count = 2 }} },
        { name = "Smelt Titansteel",   skill = 450, materials = {{ name = "Titanium Bar", count = 3 }, { name = "Crystallized Fire", count = 1 }, { name = "Crystallized Water", count = 1 }, { name = "Crystallized Shadow", count = 1 }} },
        -- Cata
        { name = "Smelt Obsidium",     skill = 475, materials = {{ name = "Obsidium Ore",   count = 2 }} },
        { name = "Smelt Elementium",   skill = 515, materials = {{ name = "Elementium Ore", count = 2 }} },
        { name = "Smelt Pyrite",       skill = 525, materials = {{ name = "Pyrite Ore",     count = 2 }} },    },
    
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
        -- ==================== GRAND MASTER / WRATH (375-450) ====================
        {
            range = {375, 425},
            tip = ProfessionHelper.L["MINING_TIP_375_425"],
        },
        {
            range = {425, 450},
            tip = ProfessionHelper.L["MINING_TIP_425_450"],
        },
        -- ==================== ILLUSTRIOUS / CATA (450-525) ====================
        {
            range = {450, 500},
            tip = "Mine Obsidium Ore in Mount Hyjal, Vashj'ir, and Deepholm (skill 475+). Obsidium is the Cata starter ore. Smelt Obsidium at 475.",
        },
        {
            range = {500, 525},
            tip = "Mine Elementium Ore in Twilight Highlands and Uldum (skill 515+). Pyrite Ore appears alongside Elementium — smelt into Pyrium Bars (skill 525). Pyrite can contain uncommon/rare gems!",
        },
    },

    -- ===================================================================
    -- SINERGIAS
    -- ===================================================================
    synergies = {
        {
            profession = "Blacksmithing",
            type       = "primary",
            benefit    = "Blacksmiths consomem grandes volumes de ore/bar. Mine e smelt seus próprios materiais economizando 50-70% de custo.",
            tip        = "Saronite Bar e Cobalt Bar são essenciais para Blacksmithing 350-450.",
        },
        {
            profession = "Engineering",
            type       = "primary",
            benefit    = "Engineering usa quase todos os ores/bars existentes. Mining permite leveling grátis dos dois.",
            tip        = "Titansteel Bar (CD diário) vale muito no AH — essencial para Engineers e Blacksmiths de alto nível.",
        },
        {
            profession = "Jewelcrafting",
            type       = "primary",
            benefit    = "JC prospeta ores para gemas raras. Mine + prospecte Saronite/Titanium para gemas de raid.",
            tip        = "Prospectar Saronite Ore em grandes volumes é uma das maiores fontes de gemas de raid WotLK.",
        },
        {
            profession = "Herbalism",
            type       = "economy",
            benefit    = "Gathering duplo no mesmo percurso de voo. Maximiza renda por hora de farm.",
        },
    },
}
