-- Profession Helper - Engineering Data (TBC Classic - Verified)
ProfessionHelper = ProfessionHelper or {}
ProfessionHelper.Engineering = {
    name = "Engineering",
    type = "crafting",
    requiresProfession = "Mining",

    trainer = {
        ["Alliance"] = {
            "Lilliam Sparkspindle (Stormwind)",
            "Springspindle Fizzlegear (Ironforge)",
            "Ockil (The Exodar)",
            "Lebowski (Honor Hold, Hellfire Peninsula)",
            "K. Lee Smallfry (Telredor, Zangarmarsh)",
            "Xyrol (Area 52, Netherstorm)",
        },
        ["Horde"] = {
            "Nogg (Orgrimmar)",
            "Franklin Lloyd (Undercity)",
            "Danwe (Silvermoon City)",
            "Zebig (Thrallmar, Hellfire Peninsula)",
            "Mack Diver (Zabra'jin, Zangarmarsh)",
            "Xyrol (Area 52, Netherstorm)",
        },
    },

    recipes = {
        -- ==================== 1-75 APPRENTICE ====================
        {
            name = "Rough Blasting Powder",
            creates = 1,
            materials = { { name = "Rough Stone", count = 1 } },
            orange = 1, yellow = 20, green = 35, grey = 50,
            source = "Trainer",
        },
        {
            name = "Rough Dynamite",
            creates = 2,
            materials = { { name = "Rough Blasting Powder", count = 2 }, { name = "Linen Cloth", count = 1 } },
            orange = 1, yellow = 30, green = 45, grey = 60,
            source = "Trainer",
        },
        {
            name = "Arclight Spanner",
            creates = 1,
            materials = { { name = "Copper Bar", count = 6 } },
            orange = 50, yellow = 70, green = 80, grey = 90,
            source = "Trainer",
        },
        {
            name = "Copper Tube",
            creates = 1,
            materials = { { name = "Copper Bar", count = 2 }, { name = "Weak Flux", count = 1 } },
            orange = 50, yellow = 70, green = 80, grey = 90,
            source = "Trainer",
        },

        -- ==================== 75-150 JOURNEYMAN ====================
        {
            name = "Coarse Blasting Powder",
            creates = 1,
            materials = { { name = "Coarse Stone", count = 1 } },
            orange = 65, yellow = 85, green = 90, grey = 95,
            source = "Trainer",
        },
        {
            name = "Coarse Dynamite",
            creates = 2,
            materials = { { name = "Coarse Blasting Powder", count = 1 }, { name = "Linen Cloth", count = 1 } },
            orange = 68, yellow = 95, green = 100, grey = 105,
            source = "Trainer",
        },
        {
            name = "Silver Contact",
            creates = 1,
            materials = { { name = "Silver Bar", count = 1 } },
            orange = 90, yellow = 110, green = 125, grey = 140,
            source = "Trainer",
        },
        {
            name = "Bronze Tube",
            creates = 1,
            materials = { { name = "Bronze Bar", count = 2 }, { name = "Weak Flux", count = 1 } },
            orange = 105, yellow = 125, green = 140, grey = 155,
            source = "Trainer",
        },
        {
            name = "Standard Scope",
            creates = 1,
            materials = { { name = "Bronze Tube", count = 1 }, { name = "Moss Agate", count = 1 } },
            orange = 110, yellow = 135, green = 148, grey = 160,
            source = "Trainer",
        },

        -- ==================== 150-225 EXPERT ====================
        {
            name = "Heavy Blasting Powder",
            creates = 1,
            materials = { { name = "Heavy Stone", count = 1 } },
            orange = 125, yellow = 135, green = 145, grey = 155,
            source = "Trainer",
        },
        {
            name = "Explosive Sheep",
            creates = 1,
            materials = {
                { name = "Bronze Framework", count = 1 },
                { name = "Whirring Bronze Gizmo", count = 1 },
                { name = "Heavy Blasting Powder", count = 2 },
                { name = "Wool Cloth", count = 2 },
            },
            orange = 150, yellow = 175, green = 188, grey = 200,
            source = "Trainer",
        },
        {
            name = "Gyromatic Micro-Adjustor",
            creates = 1,
            materials = { { name = "Steel Bar", count = 4 } },
            orange = 175, yellow = 175, green = 195, grey = 215,
            source = "Trainer",
        },
        {
            name = "Accurate Scope",
            creates = 1,
            materials = { { name = "Bronze Tube", count = 1 }, { name = "Citrine", count = 1 }, { name = "Jade", count = 1 } },
            orange = 180, yellow = 200, green = 210, grey = 220,
            source = "Trainer",
        },

        -- ==================== 225-300 ARTISAN ====================
        {
            name = "Mithril Casing",
            creates = 1,
            materials = { { name = "Mithril Bar", count = 3 } },
            orange = 215, yellow = 215, green = 235, grey = 255,
            source = "Trainer",
        },
        {
            name = "Dense Blasting Powder",
            creates = 2,
            materials = { { name = "Dense Stone", count = 2 } },
            orange = 250, yellow = 250, green = 255, grey = 260,
            source = "Trainer",
        },
        {
            name = "Truesilver Transformer",
            creates = 1,
            materials = {
                { name = "Truesilver Bar", count = 2 },
                { name = "Elemental Earth", count = 2 },
                { name = "Elemental Air", count = 1 },
            },
            orange = 260, yellow = 270, green = 275, grey = 280,
            source = "Trainer",
        },
        {
            name = "Fused Wiring",
            creates = 1,
            materials = { { name = "Delicate Copper Wire", count = 3 }, { name = "Essence of Fire", count = 2 } },
            orange = 275, yellow = 275, green = 280, grey = 285,
            source = "Vendor: Viggz Shinesparked (Shattrath) / Xizzer Fizzbolt (Winterspring)",
        },
        {
            name = "Masterwork Target Dummy",
            creates = 1,
            materials = {
                { name = "Truesilver Bar", count = 1 },
                { name = "Mithril Casing", count = 1 },
                { name = "Thorium Tube", count = 1 },
                { name = "Thorium Widget", count = 2 },
                { name = "Rugged Leather", count = 2 },
                { name = "Runecloth", count = 4 },
            },
            orange = 275, yellow = 295, green = 305, grey = 315,
            source = "Vendor: Xizzer Fizzbolt (Winterspring)",
        },

        -- ==================== 300-375 MASTER (TBC) ====================
        {
            name = "Handful of Fel Iron Bolts",
            creates = 3,
            materials = { { name = "Fel Iron Bar", count = 1 } },
            orange = 300, yellow = 300, green = 305, grey = 310,
            source = "Trainer (Outland)",
        },
        {
            name = "Elemental Blasting Powder",
            creates = 2,
            materials = { { name = "Mote of Earth", count = 2 }, { name = "Mote of Fire", count = 1 } },
            orange = 300, yellow = 300, green = 310, grey = 320,
            source = "Trainer (Outland)",
        },
        {
            name = "Fel Iron Casing",
            creates = 1,
            materials = { { name = "Fel Iron Bar", count = 3 } },
            orange = 300, yellow = 300, green = 310, grey = 320,
            source = "Trainer (Outland)",
        },
        {
            name = "Fel Iron Shells",
            creates = 3,
            materials = { { name = "Fel Iron Bar", count = 2 }, { name = "Elemental Blasting Powder", count = 1 } },
            orange = 310, yellow = 310, green = 320, grey = 330,
            source = "Trainer (Outland)",
        },
        {
            name = "Fel Iron Bomb",
            creates = 3,
            materials = {
                { name = "Fel Iron Casing", count = 1 },
                { name = "Handful of Fel Iron Bolts", count = 2 },
                { name = "Elemental Blasting Powder", count = 1 },
            },
            orange = 300, yellow = 320, green = 330, grey = 340,
            source = "Trainer (Outland)",
        },
        {
            name = "Adamantite Grenade",
            creates = 4,
            materials = {
                { name = "Adamantite Bar", count = 4 },
                { name = "Handful of Fel Iron Bolts", count = 2 },
                { name = "Elemental Blasting Powder", count = 1 },
            },
            orange = 325, yellow = 335, green = 345, grey = 355,
            source = "Trainer (Outland)",
        },
        {
            name = "White Smoke Flare",
            creates = 3,
            materials = { { name = "Netherweave Cloth", count = 1 }, { name = "Elemental Blasting Powder", count = 1 } },
            orange = 335, yellow = 335, green = 345, grey = 355,
            source = "Vendor: Wind Trader Lathrai (Shattrath) / Feera (Exodar) / Yatheon (Silvermoon)",
        },
        {
            name = "Adamantite Frame",
            creates = 1,
            materials = { { name = "Adamantite Bar", count = 4 }, { name = "Primal Earth", count = 1 } },
            orange = 325, yellow = 325, green = 330, grey = 335,
            source = "Trainer (Outland)",
        },
        {
            name = "Khorium Power Core",
            creates = 1,
            materials = { { name = "Khorium Bar", count = 3 }, { name = "Primal Fire", count = 2 } },
            orange = 340, yellow = 350, green = 360, grey = 370,
            source = "Trainer (Outland)",
        },
        {
            name = "Power Amplification Goggles",
            creates = 1,
            materials = {
                { name = "Heavy Knothide Leather", count = 4 },
                { name = "Flame Spessarite", count = 2 },
                { name = "Arcane Dust", count = 8 },
            },
            orange = 340, yellow = 350, green = 360, grey = 370,
            source = "Drop: World Drop (Outland) / AH",
        },
        {
            name = "Ultra-Spectropic Detection Goggles",
            creates = 1,
            materials = {
                { name = "Heavy Knothide Leather", count = 4 },
                { name = "Khorium Bar", count = 2 },
                { name = "Deep Peridot", count = 2 },
                { name = "Small Prismatic Shard", count = 2 },
            },
            orange = 350, yellow = 360, green = 370, grey = 380,
            source = "Vendor: Lebowski (Honor Hold, Alliance) / Captured Gnome (Zabra'jin, Horde)",
        },
    },

    -- Recommended leveling guide (verified TBC Classic)
    levelingGuide = {
        -- ==================== APPRENTICE (1-75) ====================
        {
            range = {1, 50},
            recipe = "Rough Dynamite",
            count = 61,
            materials = {
                { name = "Rough Blasting Powder", count = 122 },
                { name = "Linen Cloth", count = 61 },
            },
            source = "Trainer",
        },
        {
            range = {50, 51},
            recipe = "Arclight Spanner",
            count = 1,
            materials = {
                { name = "Copper Bar", count = 6 },
            },
            source = "Trainer",
            tip = ProfessionHelper.L["ENGINEERING_TIP_50_51"],
        },
        {
            range = {51, 75},
            recipe = "Copper Tube",
            count = 25,
            materials = {
                { name = "Copper Bar", count = 50 },
                { name = "Weak Flux", count = 25 },
            },
            source = "Trainer",
        },
        -- ==================== JOURNEYMAN (75-150) ====================
        {
            range = {75, 90},
            recipe = "Coarse Blasting Powder",
            count = 17,
            materials = {
                { name = "Coarse Stone", count = 17 },
            },
            source = "Trainer",
        },
        {
            range = {90, 100},
            recipe = "Coarse Dynamite",
            count = 16,
            materials = {
                { name = "Coarse Blasting Powder", count = 16 },
                { name = "Linen Cloth", count = 16 },
            },
            source = "Trainer",
        },
        {
            range = {100, 110},
            recipe = "EZ-Thro Dynamite",
            count = 10,
            materials = {
                { name = "Wool Cloth", count = 10 },
                { name = "Coarse Blasting Powder", count = 40 },
            },
            source = "Recipe: World Drop",
            tip = ProfessionHelper.L["ENGINEERING_TIP_100_110"],
        },
        {
            range = {110, 150},
            recipe = "Standard Scope",
            count = 48,
            materials = {
                { name = "Bronze Tube", count = 48 },
                { name = "Moss Agate", count = 48 },
            },
            source = "Trainer",
        },
        -- ==================== EXPERT (150-225) ====================
        {
            range = {150, 170},
            recipe = "Red Firework",
            count = 39,
            materials = {
                { name = "Heavy Leather", count = 39 },
                { name = "Heavy Blasting Powder", count = 39 },
            },
            source = "Vendor: Crazk Sparks (Stranglethorn Vale)",
            tip = ProfessionHelper.L["ENGINEERING_TIP_150_170"],
        },
        {
            range = {170, 175},
            recipe = "Explosive Sheep",
            count = 5,
            materials = {
                { name = "Bronze Framework", count = 5 },
                { name = "Whirring Bronze Gizmo", count = 5 },
                { name = "Heavy Blasting Powder", count = 10 },
                { name = "Wool Cloth", count = 10 },
            },
            source = "Trainer",
        },
        {
            range = {175, 176},
            recipe = "Gyromatic Micro-Adjustor",
            count = 1,
            materials = {
                { name = "Steel Bar", count = 4 },
            },
            source = "Trainer",
            tip = ProfessionHelper.L["ENGINEERING_TIP_175_176"],
        },
        {
            range = {176, 215},
            recipe = "Accurate Scope",
            count = 47,
            materials = {
                { name = "Bronze Tube", count = 47 },
                { name = "Citrine", count = 47 },
                { name = "Jade", count = 47 },
            },
            source = "Trainer",
        },
        {
            range = {215, 225},
            recipe = "Mithril Casing",
            count = 12,
            materials = {
                { name = "Mithril Bar", count = 36 },
            },
            source = "Trainer",
        },
        -- ==================== ARTISAN (225-300) ====================
        {
            range = {225, 250},
            recipe = "Spellpower Goggles Xtreme",
            count = 26,
            materials = {
                { name = "Thick Leather", count = 104 },
                { name = "Star Ruby", count = 52 },
            },
            source = "Trainer",
        },
        {
            range = {250, 260},
            recipe = "Dense Blasting Powder",
            count = 30,
            materials = {
                { name = "Dense Stone", count = 60 },
            },
            source = "Trainer",
        },
        {
            range = {260, 265},
            recipe = "Snake Burst Firework",
            count = 13,
            materials = {
                { name = "Deeprock Salt", count = 13 },
                { name = "Runecloth", count = 26 },
                { name = "Dense Blasting Powder", count = 26 },
            },
            source = "Vendor: Crazk Sparks (Stranglethorn Vale)",
        },
        {
            range = {265, 275},
            recipe = "Truesilver Transformer",
            count = 12,
            materials = {
                { name = "Truesilver Bar", count = 24 },
                { name = "Elemental Earth", count = 24 },
                { name = "Elemental Air", count = 12 },
            },
            source = "Trainer",
        },
        {
            range = {275, 280},
            recipe = "Fused Wiring",
            count = 7,
            materials = {
                { name = "Delicate Copper Wire", count = 21 },
                { name = "Essence of Fire", count = 14 },
            },
            source = "Vendor: Viggz Shinesparked (Shattrath) / Xizzer Fizzbolt (Winterspring)",
        },
        {
            range = {280, 300},
            recipe = "Masterwork Target Dummy",
            count = 21,
            materials = {
                { name = "Truesilver Bar", count = 21 },
                { name = "Mithril Casing", count = 21 },
                { name = "Thorium Tube", count = 21 },
                { name = "Thorium Widget", count = 42 },
                { name = "Rugged Leather", count = 42 },
                { name = "Runecloth", count = 84 },
            },
            source = "Vendor: Xizzer Fizzbolt (Winterspring)",
        },
        -- ==================== MASTER / TBC (300-375) ====================
        {
            range = {300, 305},
            recipe = "Handful of Fel Iron Bolts",
            count = 7,
            materials = {
                { name = "Fel Iron Bar", count = 7 },
            },
            source = "Trainer (Outland)",
        },
        {
            range = {305, 310},
            recipe = "Elemental Blasting Powder",
            count = 8,
            materials = {
                { name = "Mote of Earth", count = 16 },
                { name = "Mote of Fire", count = 8 },
            },
            source = "Trainer (Outland)",
        },
        {
            range = {310, 325},
            recipe = "Fel Iron Shells",
            count = 27,
            materials = {
                { name = "Fel Iron Bar", count = 54 },
                { name = "Elemental Blasting Powder", count = 27 },
            },
            source = "Trainer (Outland)",
        },
        {
            range = {325, 330},
            recipe = "Fel Iron Bomb",
            count = 8,
            materials = {
                { name = "Fel Iron Casing", count = 8 },
                { name = "Handful of Fel Iron Bolts", count = 16 },
                { name = "Elemental Blasting Powder", count = 8 },
            },
            source = "Trainer (Outland)",
        },
        {
            range = {330, 335},
            recipe = "Adamantite Grenade",
            count = 5,
            materials = {
                { name = "Adamantite Bar", count = 20 },
                { name = "Handful of Fel Iron Bolts", count = 10 },
                { name = "Elemental Blasting Powder", count = 5 },
            },
            source = "Trainer (Outland)",
        },
        {
            range = {335, 355},
            recipe = "White Smoke Flare",
            count = 72,
            materials = {
                { name = "Netherweave Cloth", count = 72 },
                { name = "Elemental Blasting Powder", count = 72 },
            },
            source = "Vendor: Wind Trader Lathrai (Shattrath) / Feera (Exodar) / Yatheon (Silvermoon)",
        },
        {
            range = {355, 360},
            recipe = "Power Amplification Goggles",
            count = 8,
            materials = {
                { name = "Heavy Knothide Leather", count = 32 },
                { name = "Flame Spessarite", count = 16 },
                { name = "Arcane Dust", count = 64 },
            },
            source = "Drop: World Drop (Outland) / AH",
        },
        {
            range = {360, 375},
            recipe = "Ultra-Spectropic Detection Goggles",
            count = 27,
            materials = {
                { name = "Heavy Knothide Leather", count = 108 },
                { name = "Khorium Bar", count = 54 },
                { name = "Deep Peridot", count = 54 },
                { name = "Small Prismatic Shard", count = 54 },
            },
            source = "Vendor: Lebowski (Honor Hold, Alliance) / Captured Gnome (Zabra'jin, Horde)",
        },
        -- ==================== GRAND MASTER / WRATH (375-450) ====================
        {
            range = {375, 400},
            recipe = "Handful of Cobalt Bolts",
            count = 30,
            materials = { { name = "Cobalt Bar", count = 90 } },
            source = "Grand Master Trainer (Northrend — Dalaran / Howling Fjord / Borean Tundra)",
        },
        {
            range = {400, 420},
            recipe = "Overcharged Capacitor",
            count = 25,
            materials = {
                { name = "Cobalt Bar", count = 100 },
                { name = "Crystallized Earth", count = 25 },
            },
            source = "Grand Master Trainer (Northrend)",
        },
        {
            range = {420, 440},
            recipe = "Froststeel Tube",
            count = 25,
            materials = {
                { name = "Cobalt Bar", count = 150 },
                { name = "Crystallized Water", count = 25 },
            },
            source = "Grand Master Trainer (Northrend)",
        },
        {
            range = {440, 450},
            recipe = "Explosive Decoy",
            count = 15,
            materials = {
                { name = "Cobalt Bar", count = 30 },
                { name = "Frostweave Cloth", count = 15 },
            },
            source = "Grand Master Trainer (Northrend)",
        },
        -- ==================== ILLUSTRIOUS / CATA (450-525) ====================
        {
            range = {450, 485},
            recipe = "Obsidium Bolts",
            count = 40,
            materials = { { name = "Obsidium Bar", count = 120 } },
            source = "Illustrious Trainer (Cataclysm — Stormwind / Orgrimmar)",
        },
        {
            range = {485, 510},
            recipe = "Tightening Straps",
            count = 30,
            materials = {
                { name = "Embersilk Cloth", count = 150 },
                { name = "Obsidium Bar", count = 90 },
            },
            source = "Trainer (Cataclysm)",
        },
        {
            range = {510, 525},
            recipe = "Electrostatic Condenser",
            count = 20,
            materials = {
                { name = "Elementium Bar", count = 240 },
                { name = "Volatile Air", count = 80 },
            },
            source = "Trainer (Cataclysm)",
        },
    },

    -- ===================================================================
    -- SINERGIAS
    -- ===================================================================
    synergies = {
        {
            profession = "Mining",
            type       = "primary",
            benefit    = "Engineering consome TODOS os tipos de ore/bar. Mining fornece materiais de forma gratuita e permite leveling sem custo.",
            tip        = "Cobalt, Saronite e Titanium são essenciais para Engineering 350-450. Mine e smelt tudo.",
        },
        {
            profession = "Blacksmithing",
            type       = "economy",
            benefit    = "Compartilham os mesmos materiais de Mining. Em raides, ambas têm forte demanda de bars e kits.",
        },
        {
            profession = "Alchemy",
            type       = "gold",
            benefit    = "Engineers com Alchemy podem criar e usar goggles + flasks/elixirs para máximo de performance. Forte combo PvE.",
        },
    },
}
