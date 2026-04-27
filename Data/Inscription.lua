-- Profession Helper - Inscription Data (Wrath of the Lich King 3.x+)
-- Requires WotLK (minVersion = 30000). Inscription was added in Patch 3.0.
ProfessionHelper = ProfessionHelper or {}
ProfessionHelper.Inscription = {
    name = "Inscription",
    type = "crafting",
    minVersion = 30000,

    trainer = {
        ["Alliance"] = {
            "Professor Thaddeus Paleo (Stormwind — Old Town)",
            "Thargas Anvilmar (Ironforge — Great Forge)",
            "Feyden Darkin (Darnassus — Temple of the Moon)",
            "Feyden Darkin (Dalaran — Inscription building — Grand Master)",
        },
        ["Horde"] = {
            "Shazdar (Orgrimmar — The Drag)",
            "Margaux Parchley (Undercity — Magic Quarter)",
            "Dawnwatcher Shaedlass (Silvermoon City)",
            "Feyden Darkin (Dalaran — Inscription building — Grand Master)",
        },
    },

    -- ===================================================================
    -- INK TRADER (WotLK) — MECÂNICA ESSENCIAL!
    -- Jessica Sellers em Dalaran (Canalização de Magia / Magic Quarter)
    -- Troca QUALQUER tinta por Ink of the Sea na proporção 1:1 (exceto Snowfall Ink).
    -- ESTRATÉGIA: Moa as herbs mais baratas do AH (Goldclover, Adder's Tongue),
    -- converta todo excedente de Ink of the Sea em tintas de nível baixo via Jessica!
    -- ===================================================================
    inkTrader = {
        name    = "Jessica Sellers",
        zone    = "Dalaran — Magic Quarter (perto do trainador de Inscription)",
        rate    = "1 Ink of the Sea → 1 qualquer tinta (exceto Snowfall Ink)",
        tip     = "Use esta mecânica para nivelar 1-350 comprando apenas herbs Northrend baratas!",
    },

    -- ===================================================================
    -- SINERGIAS — Inscrição funciona melhor combinada com:
    -- ===================================================================
    synergies = {
        {
            profession = "Herbalism",
            type       = "primary",
            benefit    = "Fornece TODAS as herbs para milling gratuitamente. Suba as duas juntas.",
            route      = "Adder's Tongue (Sholazar Basin) é a melhor herb para Inscription 375-450.",
        },
        {
            profession = "Enchanting",
            type       = "gold",
            benefit    = "Vellums de encantamento (craftados pela Inscrição) permitem vender encantamentos no AH.",
        },
        {
            profession = "Alchemy",
            type       = "gold",
            benefit    = "Scribes vendem glyphs de alta demanda para todas as classes — alta rotatividade.",
        },
    },

    -- ===================================================================
    -- MILLING GUIDE — 5 herbs → pigments → inks
    -- This is the core of Inscription: mill herbs to get pigments
    -- ===================================================================
    millingGuide = {
        {
            herbs     = "Peacebloom, Silverleaf, Earthroot",
            pigment   = "Alabaster Pigment",
            ink       = "Ivory Ink",
            skillRange = "1-75",
            yield     = "2 Alabaster Pigment per 5 herbs milled (guaranteed)",
        },
        {
            herbs     = "Briarthorn, Bruiseweed, Mageroyal, Swiftthistle",
            pigment   = "Dusky Pigment",
            ink       = "Midnight Ink",
            skillRange = "75-125",
            yield     = "2 Dusky Pigment per 5 herbs (+ rare Verdant Pigment)",
        },
        {
            herbs     = "Kingsblood, Wild Steelbloom, Goldthorn, Fadeleaf, Liferoot",
            pigment   = "Golden Pigment",
            ink       = "Lion's Ink",
            skillRange = "125-175",
            yield     = "2 Golden Pigment per 5 herbs (+ rare Burnt Pigment)",
        },
        {
            herbs     = "Sungrass, Blindweed, Gromsblood, Ghost Mushroom, Firebloom",
            pigment   = "Emerald Pigment",
            ink       = "Jadefire Ink",
            skillRange = "175-225",
            yield     = "2 Emerald Pigment per 5 herbs (+ rare Indigo Pigment)",
        },
        {
            herbs     = "Dreamfoil, Mountain Silversage, Plaguebloom, Icecap",
            pigment   = "Violet Pigment",
            ink       = "Celestial Ink",
            skillRange = "225-300",
            yield     = "2 Violet Pigment per 5 herbs (+ rare Ruby Pigment)",
        },
        {
            herbs     = "Felweed, Dreaming Glory, Terocone, Ancient Lichen",
            pigment   = "Silvery Pigment",
            ink       = "Shimmering Ink",
            skillRange = "300-325",
            yield     = "2 Silvery Pigment per 5 herbs (+ rare Ebon Pigment)",
        },
        {
            herbs     = "Ancient Lichen, Nightmare Vine, Netherbloom, Mana Thistle",
            pigment   = "Nether Pigment",
            ink       = "Ethereal Ink",
            skillRange = "325-375",
            yield     = "2 Nether Pigment per 5 herbs (+ rare Ebon Pigment)",
        },
        {
            herbs     = "Goldclover, Tiger Lily, Talandra's Rose, Deadnettle, Adder's Tongue",
            pigment   = "Azure Pigment",
            ink       = "Ink of the Sea",
            skillRange = "375-425",
            yield     = "2 Azure Pigment per 5 herbs (+ rare Icy Pigment)",
        },
        {
            herbs     = "Icethorn, Lichbloom, Frost Lotus",
            pigment   = "Icy Pigment",
            ink       = "Snowfall Ink",
            skillRange = "425-450",
            yield     = "2 Icy Pigment per 5 herbs (Snowfall Ink only — very valuable!)",
        },
    },

    recipes = {
        { name = "Scroll of Recall",              creates = 1, materials = {{ name = "Ivory Ink", count = 1 }, { name = "Light Parchment", count = 1 }},   orange = 1,   yellow = 40,  green = 55,  grey = 75,  source = "Trainer" },
        { name = "Enchanting Vellum",             creates = 1, materials = {{ name = "Midnight Ink", count = 1 }},                                          orange = 75,  yellow = 95,  green = 110, grey = 125, source = "Trainer" },
        { name = "Glyph (trainer, Lion's Ink)",   creates = 1, materials = {{ name = "Lion's Ink", count = 2 }, { name = "Light Parchment", count = 1 }},   orange = 115, yellow = 135, green = 155, grey = 175, source = "Trainer" },
        { name = "Glyph (trainer, Jadefire Ink)", creates = 1, materials = {{ name = "Jadefire Ink", count = 2 }, { name = "Light Parchment", count = 1 }}, orange = 155, yellow = 175, green = 195, grey = 215, source = "Trainer" },
        { name = "Glyph (trainer, Celestial Ink)",creates = 1, materials = {{ name = "Celestial Ink", count = 2 }, { name = "Light Parchment", count = 1 }},orange = 200, yellow = 220, green = 240, grey = 260, source = "Trainer" },
        { name = "Glyph (Shimmering Ink)",        creates = 1, materials = {{ name = "Shimmering Ink", count = 2 }, { name = "Light Parchment", count = 1 }},orange = 230, yellow = 255, green = 270, grey = 285, source = "Trainer" },
        { name = "Glyph (Ethereal Ink)",          creates = 1, materials = {{ name = "Ethereal Ink", count = 2 }, { name = "Light Parchment", count = 1 }}, orange = 285, yellow = 310, green = 325, grey = 350, source = "Trainer (Outland)" },
        { name = "Glyph (Ink of the Sea)",        creates = 1, materials = {{ name = "Ink of the Sea", count = 2 }, { name = "Light Parchment", count = 1 }},orange = 350, yellow = 370, green = 395, grey = 420, source = "Grand Master Trainer (Northrend)" },
        { name = "Darkmoon Card: Nobles",         creates = 1, materials = {{ name = "Ink of the Sea", count = 10 }, { name = "Resilient Parchment", count = 1 }}, orange = 385, yellow = 400, green = 420, grey = 440, source = "Grand Master Trainer (Northrend)" },
        { name = "Northrend Inscription Research",creates = 1, materials = {{ name = "Ink of the Sea", count = 3 }, { name = "Snowfall Ink", count = 1 }, { name = "Resilient Parchment", count = 1 }}, orange = 420, yellow = 440, green = 445, grey = 450, source = "Grand Master Trainer — 1/day CD" },
    },

    levelingGuide = {
        -- ==================== APPRENTICE (1-75) ====================
        {
            range = {1, 75},
            recipe = "Scroll of Recall",
            count = 82,
            materials = {
                { name = "Ivory Ink", count = 82 },
                { name = "Light Parchment", count = 82 },
            },
            source = "Trainer",
        },
        -- ==================== JOURNEYMAN (75-150) ====================
        {
            range = {75, 125},
            recipe = "Enchanting Vellum",
            count = 55,
            materials = {
                { name = "Midnight Ink", count = 55 },
            },
            source = "Trainer",
        },
        -- ==================== EXPERT (150-225) ====================
        {
            range = {125, 175},
            recipe = "Glyph (Lion's Ink — any trainer glyph)",
            count = 55,
            materials = {
                { name = "Lion's Ink", count = 110 },
                { name = "Light Parchment", count = 55 },
            },
            source = "Trainer",
        },
        {
            range = {175, 225},
            recipe = "Glyph (Jadefire Ink — any trainer glyph)",
            count = 55,
            materials = {
                { name = "Jadefire Ink", count = 110 },
                { name = "Light Parchment", count = 55 },
            },
            source = "Trainer",
        },
        -- ==================== ARTISAN (225-300) ====================
        -- IMPORTANTE: Celestial Ink fica CINZA em skill 260! Troque ANTES de desperdiçar mats.
        {
            range = {225, 260},
            recipe = "Glyph (Celestial Ink — qualquer glyph do trainer)",
            count = 70,
            materials = {
                { name = "Celestial Ink", count = 140 },
                { name = "Light Parchment", count = 70 },
            },
            source = "Trainer",
            tip = ProfessionHelper.L["INSCRIPTION_TIP_225_260"],
        },
        -- Shimmering Ink é LARANJA a partir de skill 230 — muito mais eficiente que Celestial após 240!
        {
            range = {260, 285},
            recipe = "Glyph (Shimmering Ink — qualquer glyph TBC do trainer)",
            count = 65,
            materials = {
                { name = "Shimmering Ink", count = 130 },
                { name = "Light Parchment", count = 65 },
            },
            source = "Trainer (Outland)",
            tip = ProfessionHelper.L["INSCRIPTION_TIP_260_285"],
        },
        -- ==================== MASTER / TBC (285-375) ====================
        -- Ethereal Ink é LARANJA em 285 — transição ideal!
        {
            range = {285, 350},
            recipe = "Glyph (Ethereal Ink — qualquer glyph TBC do trainer)",
            count = 130,
            materials = {
                { name = "Ethereal Ink", count = 260 },
                { name = "Light Parchment", count = 130 },
            },
            source = "Trainer (Outland)",
            tip = ProfessionHelper.L["INSCRIPTION_TIP_285_350"],
        },
        -- ==================== GRAND MASTER / WRATH (375-450) ====================
        -- DICA DE OURO: Jessica Sellers (Dalaran — Canalização de Magia) troca QUALQUER tinta
        -- por Ink of the Sea na proporção 1:1. Use isso para nivelar com as tintas mais baratas!
        {
            range = {350, 385},
            recipe = "Glyph (Ink of the Sea — qualquer glyph Northrend do trainer)",
            count = 45,
            materials = {
                { name = "Ink of the Sea", count = 90 },
                { name = "Resilient Parchment", count = 45 },
            },
            source = "Grand Master Trainer (Northrend — Dalaran / Howling Fjord / Borean Tundra)",
            tip = ProfessionHelper.L["INSCRIPTION_TIP_350_385"],
        },
        {
            range = {385, 420},
            recipe = "Glyph (Ink of the Sea — qualquer glyph Northrend)",
            count = 90,
            materials = {
                { name = "Ink of the Sea", count = 180 },
                { name = "Resilient Parchment", count = 90 },
            },
            source = "Grand Master Trainer (Northrend)",
            tip = ProfessionHelper.L["INSCRIPTION_TIP_385_420"],
        },
        {
            range = {420, 435},
            recipe = "Northrend Inscription Research (daily CD) + Glyphs",
            count = 20,
            materials = {
                { name = "Ink of the Sea", count = 60 },
                { name = "Snowfall Ink", count = 5 },
                { name = "Resilient Parchment", count = 20 },
            },
            source = "Grand Master Trainer — Pesquisa diária (1/dia), descobre glyphs aleatórios",
            tip = ProfessionHelper.L["INSCRIPTION_TIP_420_435"],
        },
        {
            range = {435, 450},
            recipe = "Darkmoon Card: Nobles + Northrend Inscription Research",
            count = 15,
            materials = {
                { name = "Ink of the Sea", count = 150 },
                { name = "Snowfall Ink", count = 5 },
                { name = "Resilient Parchment", count = 15 },
            },
            source = "Grand Master Trainer + pesquisa diária — Darkmoon Cards são extremamente valiosas!",
            tip = ProfessionHelper.L["INSCRIPTION_TIP_435_450"],
        },
    },

    farmingLocations = {
        {
            skillRange = {1, 75},
            locations = {
                {
                    zone = "Elwynn Forest / Tirisfal Glades / Mulgore",
                    faction = "Both",
                    route = "Any low-level starting zone. Pick Peacebloom, Silverleaf, Earthroot.",
                    tips  = "Need ~250 herbs total. Usually extremely cheap on AH — faster to buy than farm.",
                    levelRange = "Any",
                },
            },
        },
        {
            skillRange = {75, 300},
            locations = {
                {
                    zone = "Classic zones — Arathi Highlands, STV, Feralas, Un'Goro",
                    faction = "Both",
                    route = "Farm herbs matching your current ink tier. See Milling Guide tab for which herbs give which pigments.",
                    tips  = "Classic herbs are usually cheap on AH. Buy over farm. Prioritise Kingsblood (Golden) and Dreamfoil (Violet).",
                    levelRange = "Any",
                },
            },
        },
        {
            skillRange = {300, 375},
            locations = {
                {
                    zone = "Zangarmarsh / Hellfire Peninsula",
                    faction = "Both",
                    route = "Zangarmarsh: fly figure-8 around the lake perimeter for Felweed + Dreaming Glory. Hellfire: linear routes.",
                    tips  = "Felweed is extremely abundant in Zangarmarsh. Best single-zone for 300-350 skill.",
                    levelRange = "58-70",
                },
                {
                    zone = "Shadowmoon Valley / Netherstorm",
                    faction = "Both",
                    route = "Shadowmoon: fly northeast quadrant for Nightmare Vine + Netherbloom.",
                    tips  = "Nightmare Vine gives Nether Pigment — required for Ethereal Ink (350-375).",
                    levelRange = "67-70",
                },
            },
        },
        {
            skillRange = {375, 450},
            locations = {
                {
                    zone = "Sholazar Basin",
                    faction = "Both",
                    route = "Fly the entire perimeter of Sholazar Basin — extremely dense Adder's Tongue spawns.",
                    tips  = "Adder's Tongue is the best herb per hour for Inscription 375-450. Yields Azure Pigment and occasional Icy Pigment.",
                    levelRange = "75-80",
                },
                {
                    zone = "Howling Fjord / Grizzly Hills",
                    faction = "Both",
                    route = "Howling Fjord: coastal loops. Grizzly Hills: riverbanks and forest floor.",
                    tips  = "Goldclover and Tiger Lily — good for early Northrend milling (375-400).",
                    levelRange = "68-75",
                },
                {
                    zone = "Icecrown / Storm Peaks",
                    faction = "Both",
                    route = "Icecrown: outer ring. Storm Peaks: southern valleys between Ulduar and K3.",
                    tips  = "Icethorn + Lichbloom give Icy Pigment → Snowfall Ink. Snowfall Ink sells for high gold — sell extras!",
                    levelRange = "77-80",
                },
            },
        },
    },
}
