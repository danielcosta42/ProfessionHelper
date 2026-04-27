-- Profession Helper - Leatherworking Data (TBC Classic - Verified)
ProfessionHelper = ProfessionHelper or {}
ProfessionHelper.Leatherworking = {
    name = "Leatherworking",
    type = "crafting",
    requiresProfession = "Skinning",

    trainer = {
        ["Alliance"] = {
            "Simon Tanner (Stormwind)",
            "Darianna (Ironforge)",
            "Brumman (Honor Hold, Hellfire)",
        },
        ["Horde"] = {
            "Karolek (Orgrimmar)",
            "Arthur Moore (Undercity)",
            "Barim Spilner (Thrallmar, Hellfire)",
        },
    },

    recipes = {
        { name = "Light Armor Kit", creates = 1, materials = { { name = "Light Leather", count = 1 } }, orange = 1, yellow = 30, green = 40, grey = 55, source = "Trainer" },
        { name = "Handstitched Leather Cloak", creates = 1, materials = { { name = "Light Leather", count = 2 }, { name = "Coarse Thread", count = 1 } }, orange = 1, yellow = 40, green = 55, grey = 70, source = "Trainer" },
        { name = "Embossed Leather Gloves", creates = 1, materials = { { name = "Light Leather", count = 3 }, { name = "Coarse Thread", count = 2 } }, orange = 55, yellow = 80, green = 95, grey = 110, source = "Trainer" },
        { name = "Fine Leather Belt", creates = 1, materials = { { name = "Light Leather", count = 6 }, { name = "Coarse Thread", count = 2 } }, orange = 80, yellow = 105, green = 120, grey = 135, source = "Trainer" },
        { name = "Dark Leather Boots", creates = 1, materials = { { name = "Medium Leather", count = 4 }, { name = "Fine Thread", count = 2 }, { name = "Gray Dye", count = 1 } }, orange = 100, yellow = 130, green = 147, grey = 165, source = "Trainer" },
        { name = "Dark Leather Pants", creates = 1, materials = { { name = "Medium Leather", count = 12 }, { name = "Fine Thread", count = 2 }, { name = "Gray Dye", count = 1 } }, orange = 115, yellow = 140, green = 155, grey = 170, source = "Trainer" },
        { name = "Heavy Leather", creates = 1, materials = { { name = "Medium Leather", count = 5 } }, orange = 150, yellow = 150, green = 155, grey = 170, source = "Trainer" },
        { name = "Cured Heavy Hide", creates = 1, materials = { { name = "Heavy Hide", count = 1 }, { name = "Salt", count = 1 } }, orange = 150, yellow = 150, green = 160, grey = 170, source = "Trainer" },
        { name = "Heavy Armor Kit", creates = 1, materials = { { name = "Heavy Leather", count = 5 }, { name = "Fine Thread", count = 1 } }, orange = 150, yellow = 170, green = 185, grey = 200, source = "Trainer" },
        { name = "Barbaric Shoulders", creates = 1, materials = { { name = "Heavy Leather", count = 8 }, { name = "Cured Heavy Hide", count = 1 }, { name = "Fine Thread", count = 2 } }, orange = 175, yellow = 195, green = 210, grey = 225, source = "Trainer" },
        { name = "Guardian Gloves", creates = 1, materials = { { name = "Heavy Leather", count = 4 }, { name = "Silken Thread", count = 1 } }, orange = 190, yellow = 210, green = 225, grey = 240, source = "Trainer" },
        { name = "Thick Armor Kit", creates = 1, materials = { { name = "Thick Leather", count = 5 }, { name = "Silken Thread", count = 1 } }, orange = 200, yellow = 220, green = 230, grey = 240, source = "Trainer" },
        { name = "Nightscape Headband", creates = 1, materials = { { name = "Thick Leather", count = 5 }, { name = "Silken Thread", count = 2 } }, orange = 205, yellow = 220, green = 240, grey = 260, source = "Trainer" },
        { name = "Nightscape Pants", creates = 1, materials = { { name = "Thick Leather", count = 14 }, { name = "Silken Thread", count = 4 } }, orange = 230, yellow = 250, green = 260, grey = 270, source = "Trainer" },
        { name = "Rugged Armor Kit", creates = 1, materials = { { name = "Rugged Leather", count = 5 } }, orange = 250, yellow = 255, green = 265, grey = 275, source = "Trainer" },
        { name = "Wicked Leather Bracers", creates = 1, materials = { { name = "Rugged Leather", count = 8 }, { name = "Black Dye", count = 1 }, { name = "Rune Thread", count = 1 } }, orange = 265, yellow = 280, green = 295, grey = 310, source = "Trainer" },
        { name = "Wicked Leather Headband", creates = 1, materials = { { name = "Rugged Leather", count = 12 }, { name = "Black Dye", count = 1 }, { name = "Rune Thread", count = 1 } }, orange = 280, yellow = 295, green = 310, grey = 325, source = "Trainer" },
        { name = "Knothide Armor Kit", creates = 1, materials = { { name = "Knothide Leather", count = 4 } }, orange = 300, yellow = 310, green = 320, grey = 330, source = "Trainer (Outland)" },
        { name = "Wild Draenish Boots", creates = 1, materials = { { name = "Knothide Leather", count = 8 }, { name = "Rune Thread", count = 2 } }, orange = 310, yellow = 320, green = 330, grey = 340, source = "Trainer (Outland)" },
        { name = "Heavy Knothide Leather", creates = 1, materials = { { name = "Knothide Leather", count = 5 } }, orange = 325, yellow = 325, green = 330, grey = 335, source = "Vendor: Cro Threadstrong (Shattrath)" },
        { name = "Thick Draenic Vest", creates = 1, materials = { { name = "Knothide Leather", count = 16 }, { name = "Rune Thread", count = 2 } }, orange = 330, yellow = 340, green = 350, grey = 360, source = "Trainer (Outland)" },
        { name = "Heavy Knothide Armor Kit", creates = 1, materials = { { name = "Heavy Knothide Leather", count = 3 } }, orange = 350, yellow = 355, green = 365, grey = 375, source = "Trainer (Outland)" },
        { name = "Drums of Battle", creates = 1, materials = { { name = "Heavy Knothide Leather", count = 6 }, { name = "Primal Fire", count = 4 } }, orange = 365, yellow = 375, green = 375, grey = 375, source = "Vendor: Almaador (Shattrath) — Sha'tar Honored" },
    },

    levelingGuide = {
        -- ==================== APPRENTICE (1-75) ====================
        {
            range = {1, 20},
            recipe = "Light Armor Kit",
            count = 22,
            materials = { { name = "Light Leather", count = 22 } },
            source = "Trainer",
        },
        {
            range = {20, 55},
            recipe = "Handstitched Leather Cloak",
            count = 35,
            materials = { { name = "Light Leather", count = 70 }, { name = "Coarse Thread", count = 35 } },
            source = "Trainer",
        },
        {
            range = {55, 75},
            recipe = "Embossed Leather Gloves",
            count = 25,
            materials = { { name = "Light Leather", count = 75 }, { name = "Coarse Thread", count = 50 } },
            source = "Trainer",
        },
        -- ==================== JOURNEYMAN (75-150) ====================
        {
            range = {75, 100},
            recipe = "Fine Leather Belt",
            count = 28,
            materials = { { name = "Light Leather", count = 168 }, { name = "Coarse Thread", count = 56 } },
            source = "Trainer",
        },
        {
            range = {100, 115},
            recipe = "Dark Leather Boots",
            count = 20,
            materials = { { name = "Medium Leather", count = 80 }, { name = "Fine Thread", count = 40 }, { name = "Gray Dye", count = 20 } },
            source = "Trainer",
        },
        {
            range = {115, 137},
            recipe = "Dark Leather Pants",
            count = 25,
            materials = { { name = "Medium Leather", count = 300 }, { name = "Fine Thread", count = 50 }, { name = "Gray Dye", count = 25 } },
            source = "Trainer",
        },
        {
            range = {137, 150},
            recipe = "Heavy Leather",
            count = 20,
            materials = { { name = "Medium Leather", count = 100 } },
            source = "Trainer",
            tip = ProfessionHelper.L["LEATHERWORKING_TIP_137_150"],
        },
        -- ==================== EXPERT (150-225) ====================
        {
            range = {150, 160},
            recipe = "Cured Heavy Hide",
            count = 12,
            materials = { { name = "Heavy Hide", count = 12 }, { name = "Salt", count = 12 } },
            source = "Trainer",
            tip = ProfessionHelper.L["LEATHERWORKING_TIP_150_160"],
        },
        {
            range = {160, 175},
            recipe = "Heavy Armor Kit",
            count = 15,
            materials = { { name = "Heavy Leather", count = 75 }, { name = "Fine Thread", count = 15 } },
            source = "Trainer",
        },
        {
            range = {175, 195},
            recipe = "Barbaric Shoulders",
            count = 20,
            materials = { { name = "Heavy Leather", count = 160 }, { name = "Cured Heavy Hide", count = 20 }, { name = "Fine Thread", count = 40 } },
            source = "Trainer",
        },
        {
            range = {195, 205},
            recipe = "Guardian Gloves",
            count = 10,
            materials = { { name = "Heavy Leather", count = 40 }, { name = "Silken Thread", count = 10 } },
            source = "Trainer",
        },
        {
            range = {205, 225},
            recipe = "Nightscape Headband",
            count = 20,
            materials = { { name = "Thick Leather", count = 100 }, { name = "Silken Thread", count = 40 } },
            source = "Trainer",
        },
        -- ==================== ARTISAN (225-300) ====================
        {
            range = {225, 250},
            recipe = "Nightscape Pants",
            count = 25,
            materials = { { name = "Thick Leather", count = 350 }, { name = "Silken Thread", count = 100 } },
            source = "Trainer",
        },
        {
            range = {250, 265},
            recipe = "Rugged Armor Kit",
            count = 20,
            materials = { { name = "Rugged Leather", count = 100 } },
            source = "Trainer",
        },
        {
            range = {265, 280},
            recipe = "Wicked Leather Bracers",
            count = 15,
            materials = { { name = "Rugged Leather", count = 120 }, { name = "Black Dye", count = 15 }, { name = "Rune Thread", count = 15 } },
            source = "Trainer",
        },
        {
            range = {280, 300},
            recipe = "Wicked Leather Headband",
            count = 20,
            materials = { { name = "Rugged Leather", count = 240 }, { name = "Black Dye", count = 20 }, { name = "Rune Thread", count = 20 } },
            source = "Trainer",
        },
        -- ==================== MASTER / TBC (300-375) ====================
        {
            range = {300, 310},
            recipe = "Knothide Armor Kit",
            count = 12,
            materials = { { name = "Knothide Leather", count = 48 } },
            source = "Trainer (Outland)",
        },
        {
            range = {310, 325},
            recipe = "Wild Draenish Boots",
            count = 15,
            materials = { { name = "Knothide Leather", count = 120 }, { name = "Rune Thread", count = 30 } },
            source = "Trainer (Outland)",
            tip = ProfessionHelper.L["LEATHERWORKING_TIP_310_325"],
        },
        {
            range = {325, 335},
            recipe = "Heavy Knothide Leather",
            count = 35,
            materials = { { name = "Knothide Leather", count = 175 } },
            source = "Vendor: Cro Threadstrong (Shattrath)",
            tip = ProfessionHelper.L["LEATHERWORKING_TIP_325_335"],
        },
        {
            range = {335, 350},
            recipe = "Thick Draenic Vest",
            count = 18,
            materials = { { name = "Knothide Leather", count = 288 }, { name = "Rune Thread", count = 36 } },
            source = "Trainer (Outland)",
        },
        {
            range = {350, 365},
            recipe = "Heavy Knothide Armor Kit",
            count = 20,
            materials = { { name = "Heavy Knothide Leather", count = 60 } },
            source = "Trainer (Outland)",
            tip = ProfessionHelper.L["LEATHERWORKING_TIP_350_365"],
        },
        {
            range = {365, 375},
            recipe = "Drums of Battle",
            count = 10,
            materials = { { name = "Heavy Knothide Leather", count = 60 }, { name = "Primal Fire", count = 40 } },
            source = "Vendor: Almaador (Shattrath) — Sha'tar Honored",
            tip = ProfessionHelper.L["LEATHERWORKING_TIP_365_375"],
        },
        -- ==================== GRAND MASTER / WRATH (375-450) ====================
        {
            range = {375, 400},
            recipe = "Heavy Borean Armor Kit",
            count = 30,
            materials = { { name = "Heavy Borean Leather", count = 150 } },
            source = "Grand Master Trainer (Northrend — Dalaran / Howling Fjord / Borean Tundra)",
        },
        {
            range = {400, 420},
            recipe = "Nerubian Leg Armor",
            count = 25,
            materials = {
                { name = "Heavy Borean Leather", count = 100 },
                { name = "Crystallized Shadow", count = 50 },
            },
            source = "Grand Master Trainer (Northrend)",
        },
        {
            range = {420, 440},
            recipe = "Overcast Headguard",
            count = 25,
            materials = { { name = "Borean Leather", count = 500 } },
            source = "Grand Master Trainer (Northrend)",
        },
        {
            range = {440, 450},
            recipe = "Frosthide Leg Armor",
            count = 15,
            materials = {
                { name = "Arctic Fur", count = 60 },
                { name = "Crystallized Fire", count = 30 },
            },
            source = "Grand Master Trainer (Northrend)",
        },
        -- ==================== ILLUSTRIOUS / CATA (450-525) ====================
        {
            range = {450, 475},
            recipe = "Savage Leather Gloves",
            count = 30,
            materials = { { name = "Savage Leather", count = 600 } },
            source = "Illustrious Trainer (Cataclysm — Stormwind / Orgrimmar)",
        },
        {
            range = {475, 500},
            recipe = "Deathscale Belt",
            count = 30,
            materials = {
                { name = "Heavy Savage Leather", count = 360 },
                { name = "Volatile Water", count = 60 },
            },
            source = "Trainer (Cataclysm)",
        },
        {
            range = {500, 515},
            recipe = "Twilight Scale Chestguard",
            count = 20,
            materials = {
                { name = "Twilight Scale", count = 160 },
                { name = "Volatile Air", count = 80 },
            },
            source = "Trainer (Cataclysm)",
        },
        {
            range = {515, 525},
            recipe = "Dragonscale Leg Armor",
            count = 12,
            materials = {
                { name = "Pristine Hide", count = 48 },
                { name = "Volatile Fire", count = 48 },
            },
            source = "Trainer (Cataclysm)",
        },
    },

    -- ===================================================================
    -- SINERGIAS
    -- ===================================================================
    synergies = {
        {
            profession = "Skinning",
            type       = "primary",
            benefit    = "Sinergia clássica: Skinner fornece leather diretamente para LW. Zero custo de materials, leveling completo.",
            tip        = "Nagrand (Talbuks, Clefthoofs) é a melhor zona para Knothide Leather. WotLK: Dragonblight/Howling Fjord para Arctic Fur.",
        },
        {
            profession = "Enchanting",
            type       = "gold",
            benefit    = "Craft itens de couro descartáveis e desencante para materials de Enchanting. Cadeia de valor total.",
        },
    },
}
