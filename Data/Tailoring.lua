-- Profession Helper - Tailoring Data (TBC Classic - Verified)
ProfessionHelper = ProfessionHelper or {}
ProfessionHelper.Tailoring = {
    name = "Tailoring",
    type = "crafting",

    trainer = {
        ["Alliance"] = {
            "Georgio Bolero (Stormwind)",
            "Jormund Stonebrow (Ironforge)",
            "Dalinna (Honor Hold, Hellfire)",
        },
        ["Horde"] = {
            "Josef Gregorian (Undercity)",
            "Magar (Orgrimmar)",
            "Dalinna (Thrallmar, Hellfire)",
        },
    },

    recipes = {
        { name = "Bolt of Linen Cloth", creates = 1, materials = { { name = "Linen Cloth", count = 2 } }, orange = 1, yellow = 25, green = 30, grey = 50, source = "Trainer" },
        { name = "Linen Belt", creates = 1, materials = { { name = "Bolt of Linen Cloth", count = 1 }, { name = "Coarse Thread", count = 1 } }, orange = 10, yellow = 45, green = 57, grey = 70, source = "Trainer" },
        { name = "Reinforced Linen Cape", creates = 1, materials = { { name = "Bolt of Linen Cloth", count = 2 }, { name = "Coarse Thread", count = 3 } }, orange = 60, yellow = 80, green = 92, grey = 105, source = "Trainer" },
        { name = "Bolt of Woolen Cloth", creates = 1, materials = { { name = "Wool Cloth", count = 3 } }, orange = 75, yellow = 90, green = 95, grey = 110, source = "Trainer" },
        { name = "Simple Kilt", creates = 1, materials = { { name = "Bolt of Woolen Cloth", count = 4 }, { name = "Fine Thread", count = 1 } }, orange = 75, yellow = 100, green = 117, grey = 135, source = "Trainer" },
        { name = "Double-stitched Woolen Shoulders", creates = 1, materials = { { name = "Bolt of Woolen Cloth", count = 3 }, { name = "Fine Thread", count = 2 } }, orange = 110, yellow = 130, green = 142, grey = 155, source = "Trainer" },
        { name = "Bolt of Silk Cloth", creates = 1, materials = { { name = "Silk Cloth", count = 4 } }, orange = 125, yellow = 140, green = 145, grey = 160, source = "Trainer" },
        { name = "Azure Silk Hood", creates = 1, materials = { { name = "Bolt of Silk Cloth", count = 2 }, { name = "Blue Dye", count = 1 }, { name = "Fine Thread", count = 1 } }, orange = 145, yellow = 160, green = 172, grey = 185, source = "Trainer" },
        { name = "Silk Headband", creates = 1, materials = { { name = "Bolt of Silk Cloth", count = 3 }, { name = "Fine Thread", count = 2 } }, orange = 160, yellow = 175, green = 187, grey = 200, source = "Trainer" },
        { name = "Formal White Shirt", creates = 1, materials = { { name = "Bolt of Silk Cloth", count = 3 }, { name = "Bleach", count = 2 }, { name = "Fine Thread", count = 1 } }, orange = 170, yellow = 180, green = 190, grey = 200, source = "Trainer" },
        { name = "Bolt of Mageweave", creates = 1, materials = { { name = "Mageweave Cloth", count = 5 } }, orange = 175, yellow = 190, green = 195, grey = 210, source = "Trainer" },
        { name = "Crimson Silk Vest", creates = 1, materials = { { name = "Bolt of Silk Cloth", count = 4 }, { name = "Red Dye", count = 2 }, { name = "Fine Thread", count = 2 } }, orange = 185, yellow = 200, green = 212, grey = 225, source = "Trainer" },
        { name = "Crimson Silk Pantaloons", creates = 1, materials = { { name = "Bolt of Silk Cloth", count = 4 }, { name = "Red Dye", count = 2 }, { name = "Silken Thread", count = 2 } }, orange = 195, yellow = 210, green = 222, grey = 235, source = "Trainer" },
        { name = "Black Mageweave Gloves", creates = 1, materials = { { name = "Bolt of Mageweave", count = 2 }, { name = "Silken Thread", count = 2 } }, orange = 215, yellow = 230, green = 242, grey = 255, source = "Trainer" },
        { name = "Black Mageweave Headband", creates = 1, materials = { { name = "Bolt of Mageweave", count = 3 }, { name = "Silken Thread", count = 2 } }, orange = 230, yellow = 245, green = 257, grey = 270, source = "Trainer" },
        { name = "Bolt of Runecloth", creates = 1, materials = { { name = "Runecloth", count = 5 } }, orange = 250, yellow = 260, green = 265, grey = 280, source = "Trainer" },
        { name = "Runecloth Belt", creates = 1, materials = { { name = "Bolt of Runecloth", count = 3 }, { name = "Rune Thread", count = 1 } }, orange = 255, yellow = 270, green = 282, grey = 295, source = "Trainer" },
        { name = "Runecloth Gloves", creates = 1, materials = { { name = "Bolt of Runecloth", count = 4 }, { name = "Rugged Leather", count = 2 }, { name = "Rune Thread", count = 1 } }, orange = 275, yellow = 290, green = 302, grey = 315, source = "Trainer" },
        { name = "Bolt of Netherweave", creates = 1, materials = { { name = "Netherweave Cloth", count = 6 } }, orange = 300, yellow = 315, green = 320, grey = 330, source = "Trainer (Outland)" },
        { name = "Bolt of Imbued Netherweave", creates = 1, materials = { { name = "Bolt of Netherweave", count = 3 }, { name = "Arcane Dust", count = 2 } }, orange = 325, yellow = 340, green = 345, grey = 355, source = "Vendor: Eiin (Shattrath)" },
        { name = "Netherweave Boots", creates = 1, materials = { { name = "Bolt of Netherweave", count = 6 }, { name = "Knothide Leather", count = 2 }, { name = "Rune Thread", count = 1 } }, orange = 320, yellow = 330, green = 340, grey = 350, source = "Trainer (Outland)" },
        { name = "Netherweave Tunic", creates = 1, materials = { { name = "Bolt of Netherweave", count = 8 }, { name = "Rune Thread", count = 2 } }, orange = 335, yellow = 345, green = 355, grey = 365, source = "Vendor: Eiin (Shattrath)" },
        { name = "Imbued Netherweave Tunic", creates = 1, materials = { { name = "Bolt of Imbued Netherweave", count = 5 }, { name = "Netherweb Spider Silk", count = 2 }, { name = "Rune Thread", count = 2 } }, orange = 360, yellow = 370, green = 375, grey = 380, source = "Vendor: Arrond (Shadowmoon Valley)" },
    },

    levelingGuide = {
        -- ==================== APPRENTICE (1-75) ====================
        {
            range = {1, 50},
            recipe = "Bolt of Linen Cloth",
            count = 50,
            materials = { { name = "Linen Cloth", count = 100 } },
            source = "Trainer",
            tip = ProfessionHelper.L["TAILORING_TIP_1_50"],
        },
        {
            range = {50, 70},
            recipe = "Linen Bag",
            count = 20,
            materials = { { name = "Bolt of Linen Cloth", count = 60 }, { name = "Coarse Thread", count = 60 } },
            source = "Trainer",
        },
        {
            range = {70, 75},
            recipe = "Reinforced Linen Cape",
            count = 5,
            materials = { { name = "Bolt of Linen Cloth", count = 10 }, { name = "Coarse Thread", count = 15 } },
            source = "Trainer",
        },
        -- ==================== JOURNEYMAN (75-150) ====================
        {
            range = {75, 105},
            recipe = "Bolt of Woolen Cloth",
            count = 40,
            materials = { { name = "Wool Cloth", count = 120 } },
            source = "Trainer",
            tip = ProfessionHelper.L["TAILORING_TIP_75_105"],
        },
        {
            range = {105, 110},
            recipe = "Gray Woolen Shirt",
            count = 5,
            materials = { { name = "Bolt of Woolen Cloth", count = 10 }, { name = "Fine Thread", count = 5 }, { name = "Gray Dye", count = 5 } },
            source = "Trainer",
        },
        {
            range = {110, 125},
            recipe = "Double-stitched Woolen Shoulders",
            count = 15,
            materials = { { name = "Bolt of Woolen Cloth", count = 45 }, { name = "Fine Thread", count = 30 } },
            source = "Trainer",
        },
        {
            range = {125, 145},
            recipe = "Bolt of Silk Cloth",
            count = 65,
            materials = { { name = "Silk Cloth", count = 260 } },
            source = "Trainer",
            tip = ProfessionHelper.L["TAILORING_TIP_125_145"],
        },
        {
            range = {145, 160},
            recipe = "Azure Silk Hood",
            count = 15,
            materials = { { name = "Bolt of Silk Cloth", count = 30 }, { name = "Blue Dye", count = 15 }, { name = "Fine Thread", count = 15 } },
            source = "Trainer",
        },
        -- ==================== EXPERT (150-225) ====================
        {
            range = {160, 170},
            recipe = "Silk Headband",
            count = 10,
            materials = { { name = "Bolt of Silk Cloth", count = 30 }, { name = "Fine Thread", count = 20 } },
            source = "Trainer",
        },
        {
            range = {170, 175},
            recipe = "Formal White Shirt",
            count = 5,
            materials = { { name = "Bolt of Silk Cloth", count = 15 }, { name = "Bleach", count = 10 }, { name = "Fine Thread", count = 5 } },
            source = "Trainer",
        },
        {
            range = {175, 185},
            recipe = "Bolt of Mageweave",
            count = 50,
            materials = { { name = "Mageweave Cloth", count = 250 } },
            source = "Trainer",
            tip = ProfessionHelper.L["TAILORING_TIP_175_185"],
        },
        {
            range = {185, 200},
            recipe = "Crimson Silk Vest",
            count = 15,
            materials = { { name = "Bolt of Silk Cloth", count = 60 }, { name = "Red Dye", count = 30 }, { name = "Fine Thread", count = 30 } },
            source = "Trainer",
        },
        {
            range = {200, 215},
            recipe = "Crimson Silk Pantaloons",
            count = 15,
            materials = { { name = "Bolt of Silk Cloth", count = 60 }, { name = "Red Dye", count = 30 }, { name = "Silken Thread", count = 30 } },
            source = "Trainer",
        },
        {
            range = {215, 230},
            recipe = "Black Mageweave Gloves",
            count = 15,
            materials = { { name = "Bolt of Mageweave", count = 30 }, { name = "Silken Thread", count = 30 } },
            source = "Trainer",
        },
        -- ==================== ARTISAN (225-300) ====================
        {
            range = {230, 250},
            recipe = "Black Mageweave Headband",
            count = 20,
            materials = { { name = "Bolt of Mageweave", count = 60 }, { name = "Silken Thread", count = 40 } },
            source = "Trainer",
        },
        {
            range = {250, 260},
            recipe = "Bolt of Runecloth",
            count = 40,
            materials = { { name = "Runecloth", count = 200 } },
            source = "Trainer",
            tip = ProfessionHelper.L["TAILORING_TIP_250_260"],
        },
        {
            range = {260, 275},
            recipe = "Runecloth Belt",
            count = 15,
            materials = { { name = "Bolt of Runecloth", count = 45 }, { name = "Rune Thread", count = 15 } },
            source = "Trainer",
        },
        {
            range = {275, 280},
            recipe = "Runecloth Bag",
            count = 5,
            materials = { { name = "Bolt of Runecloth", count = 25 }, { name = "Rugged Leather", count = 10 }, { name = "Rune Thread", count = 5 } },
            source = "Trainer",
            tip = ProfessionHelper.L["TAILORING_TIP_275_280"],
        },
        {
            range = {280, 300},
            recipe = "Runecloth Gloves",
            count = 20,
            materials = { { name = "Bolt of Runecloth", count = 80 }, { name = "Rugged Leather", count = 40 }, { name = "Rune Thread", count = 20 } },
            source = "Trainer",
        },
        -- ==================== MASTER / TBC (300-375) ====================
        {
            range = {300, 325},
            recipe = "Bolt of Netherweave",
            count = 60,
            materials = { { name = "Netherweave Cloth", count = 360 } },
            source = "Trainer (Outland)",
            tip = ProfessionHelper.L["TAILORING_TIP_300_325"],
        },
        {
            range = {325, 340},
            recipe = "Bolt of Imbued Netherweave",
            count = 20,
            materials = { { name = "Bolt of Netherweave", count = 60 }, { name = "Arcane Dust", count = 40 } },
            source = "Vendor: Eiin (Shattrath)",
            tip = ProfessionHelper.L["TAILORING_TIP_325_340"],
        },
        {
            range = {340, 350},
            recipe = "Netherweave Boots",
            count = 10,
            materials = { { name = "Bolt of Netherweave", count = 60 }, { name = "Knothide Leather", count = 20 }, { name = "Rune Thread", count = 10 } },
            source = "Trainer (Outland)",
        },
        {
            range = {350, 360},
            recipe = "Netherweave Tunic",
            count = 10,
            materials = { { name = "Bolt of Netherweave", count = 80 }, { name = "Rune Thread", count = 20 } },
            source = "Vendor: Eiin (Shattrath)",
        },
        {
            range = {360, 375},
            recipe = "Imbued Netherweave Tunic",
            count = 18,
            materials = { { name = "Bolt of Imbued Netherweave", count = 90 }, { name = "Netherweb Spider Silk", count = 36 }, { name = "Rune Thread", count = 36 } },
            source = "Vendor: Arrond (Shadowmoon Valley)",
            tip = ProfessionHelper.L["TAILORING_TIP_360_375"],
        },
        -- ==================== GRAND MASTER / WRATH (375-450) ====================
        {
            range = {375, 395},
            recipe = "Bolt of Frostweave",
            count = 25,
            materials = { { name = "Frostweave Cloth", count = 125 } },
            source = "Grand Master Trainer (Northrend — Dalaran / Howling Fjord / Borean Tundra)",
        },
        {
            range = {395, 420},
            recipe = "Bolt of Imbued Frostweave",
            count = 30,
            materials = {
                { name = "Bolt of Frostweave", count = 60 },
                { name = "Infinite Dust", count = 60 },
            },
            source = "Vendor: Sifting through Frostweave (trainer or Eiin equivalent Dalaran)",
        },
        {
            range = {420, 440},
            recipe = "Frostweave Bag",
            count = 25,
            materials = {
                { name = "Bolt of Frostweave", count = 400 },
                { name = "Eternium Thread", count = 25 },
            },
            source = "Grand Master Trainer (Northrend) — bags sell well on AH!",
        },
        {
            range = {440, 450},
            recipe = "Duskweave Belt",
            count = 15,
            materials = {
                { name = "Bolt of Imbued Frostweave", count = 45 },
                { name = "Infinite Dust", count = 30 },
            },
            source = "Grand Master Trainer (Northrend)",
        },
        -- ==================== ILLUSTRIOUS / CATA (450-525) ====================
        {
            range = {450, 460},
            recipe = "Bolt of Embersilk Cloth",
            count = 12,
            materials = { { name = "Embersilk Cloth", count = 60 } },
            source = "Illustrious Trainer (Cataclysm — Stormwind / Orgrimmar)",
        },
        {
            range = {460, 490},
            recipe = "Embersilk Robe",
            count = 35,
            materials = {
                { name = "Bolt of Embersilk Cloth", count = 210 },
                { name = "Eternium Thread", count = 35 },
            },
            source = "Illustrious Trainer (Cataclysm)",
        },
        {
            range = {490, 510},
            recipe = "Deathsilk Bracers",
            count = 25,
            materials = {
                { name = "Bolt of Embersilk Cloth", count = 100 },
                { name = "Volatile Air", count = 50 },
            },
            source = "Trainer (Cataclysm)",
        },
        {
            range = {510, 525},
            recipe = "Bloodthirsty Embersilk Robe",
            count = 20,
            materials = {
                { name = "Bolt of Embersilk Cloth", count = 160 },
                { name = "Volatile Fire", count = 40 },
                { name = "Eternium Thread", count = 20 },
            },
            source = "Trainer (Cataclysm)",
        },
    },

    -- ===================================================================
    -- SINERGIAS
    -- ===================================================================
    synergies = {
        {
            profession = "Enchanting",
            type       = "primary",
            benefit    = "Melhor combinação para casters sem gathering. Craft itens de pano baratos e desencante para materials. Perfeito para leveling.",
            tip        = "Craft Netherweave Bags — se der lucro no AH, venda. Se não, desencante para Arcane Dust.",
        },
        {
            profession = "Inscription",
            type       = "gold",
            benefit    = "Tailors usam Enchanting Vellums (feitos por Scribes) para armazenar encantamentos no AH.",
        },
    },
}
