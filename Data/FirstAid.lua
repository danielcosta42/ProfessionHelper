-- Profession Helper - First Aid Data (TBC Classic - Verified)
ProfessionHelper = ProfessionHelper or {}
ProfessionHelper.FirstAid = {
    name = "First Aid",
    type = "secondary",

    trainer = {
        ["Alliance"] = {
            "Michelle Belle (Elwynn Forest)",
            "Nissa Firestone (Ironforge)",
            "Burko (Temple of Telhamat, Hellfire)",
        },
        ["Horde"] = {
            "Nurse Neela (Undercity)",
            "Arnok (Orgrimmar)",
            "Aresella (Falcon Watch, Hellfire)",
        },
    },

    recipes = {
        { name = "Linen Bandage", creates = 1, materials = { { name = "Linen Cloth", count = 1 } }, orange = 1, yellow = 30, green = 50, grey = 80, source = "Trainer" },
        { name = "Heavy Linen Bandage", creates = 1, materials = { { name = "Linen Cloth", count = 2 } }, orange = 40, yellow = 50, green = 75, grey = 100, source = "Trainer" },
        { name = "Wool Bandage", creates = 1, materials = { { name = "Wool Cloth", count = 1 } }, orange = 80, yellow = 115, green = 130, grey = 150, source = "Trainer" },
        { name = "Heavy Wool Bandage", creates = 1, materials = { { name = "Wool Cloth", count = 2 } }, orange = 115, yellow = 150, green = 162, grey = 175, source = "Trainer" },
        { name = "Silk Bandage", creates = 1, materials = { { name = "Silk Cloth", count = 1 } }, orange = 150, yellow = 180, green = 200, grey = 210, source = "Trainer" },
        { name = "Heavy Silk Bandage", creates = 1, materials = { { name = "Silk Cloth", count = 2 } }, orange = 180, yellow = 210, green = 225, grey = 240, source = "Vendor: Deneb Walker (Arathi, Alliance) / Balai Lok'Wein (Dustwallow, Horde) — Expert First Aid book" },
        { name = "Mageweave Bandage", creates = 1, materials = { { name = "Mageweave Cloth", count = 1 } }, orange = 210, yellow = 240, green = 255, grey = 270, source = "Vendor: Deneb Walker (Arathi, Alliance) / Balai Lok'Wein (Dustwallow, Horde) — Manual" },
        { name = "Heavy Mageweave Bandage", creates = 1, materials = { { name = "Mageweave Cloth", count = 2 } }, orange = 240, yellow = 270, green = 285, grey = 300, source = "Quest: Doctor Gustaf VanHowzen (Theramore, Alliance) / Doctor Gregory Victor (Hammerfall, Horde) — Triage quest" },
        { name = "Runecloth Bandage", creates = 1, materials = { { name = "Runecloth", count = 1 } }, orange = 260, yellow = 290, green = 305, grey = 320, source = "Trainer" },
        { name = "Heavy Runecloth Bandage", creates = 1, materials = { { name = "Runecloth", count = 2 } }, orange = 290, yellow = 320, green = 335, grey = 350, source = "Trainer" },
        { name = "Netherweave Bandage", creates = 1, materials = { { name = "Netherweave Cloth", count = 1 } }, orange = 330, yellow = 340, green = 350, grey = 360, source = "Vendor: Burko (Temple of Telhamat, Alliance) / Aresella (Falcon Watch, Horde) — Manual" },
        { name = "Heavy Netherweave Bandage", creates = 1, materials = { { name = "Netherweave Cloth", count = 2 } }, orange = 360, yellow = 370, green = 375, grey = 380, source = "Vendor: Burko (Temple of Telhamat, Alliance) / Aresella (Falcon Watch, Horde) — Manual" },
    },

    levelingGuide = {
        -- ==================== APPRENTICE (1-80) ====================
        {
            range = {1, 40},
            recipe = "Linen Bandage",
            count = 50,
            materials = { { name = "Linen Cloth", count = 50 } },
            source = "Trainer",
        },
        {
            range = {40, 80},
            recipe = "Heavy Linen Bandage",
            count = 65,
            materials = { { name = "Linen Cloth", count = 130 } },
            source = "Trainer",
            tip = ProfessionHelper.L["FIRSTAID_TIP_40_80"],
        },
        -- ==================== JOURNEYMAN (80-150) ====================
        {
            range = {80, 115},
            recipe = "Wool Bandage",
            count = 60,
            materials = { { name = "Wool Cloth", count = 60 } },
            source = "Trainer",
        },
        {
            range = {115, 150},
            recipe = "Heavy Wool Bandage",
            count = 60,
            materials = { { name = "Wool Cloth", count = 120 } },
            source = "Trainer",
        },
        -- ==================== EXPERT (150-225) ====================
        {
            range = {150, 180},
            recipe = "Silk Bandage",
            count = 50,
            materials = { { name = "Silk Cloth", count = 50 } },
            source = "Trainer",
            tip = ProfessionHelper.L["FIRSTAID_TIP_150_180"],
        },
        {
            range = {180, 210},
            recipe = "Heavy Silk Bandage",
            count = 50,
            materials = { { name = "Silk Cloth", count = 100 } },
            source = "Manual: Heavy Silk Bandage — sold by Deneb Walker (Arathi Highlands, Alliance) / Balai Lok'Wein (Dustwallow Marsh, Horde)",
        },
        {
            range = {210, 225},
            recipe = "Mageweave Bandage",
            count = 30,
            materials = { { name = "Mageweave Cloth", count = 30 } },
            source = "Manual: Mageweave Bandage — sold by Deneb Walker (Arathi Highlands, Alliance) / Balai Lok'Wein (Dustwallow Marsh, Horde)",
        },
        -- ==================== ARTISAN (225-300) ====================
        {
            range = {225, 240},
            recipe = "Mageweave Bandage",
            count = 30,
            materials = { { name = "Mageweave Cloth", count = 30 } },
            source = "Manual: Mageweave Bandage",
            tip = ProfessionHelper.L["FIRSTAID_TIP_225_240"],
        },
        {
            range = {240, 260},
            recipe = "Heavy Mageweave Bandage",
            count = 30,
            materials = { { name = "Mageweave Cloth", count = 60 } },
            source = "Manual: Heavy Mageweave Bandage — sold by Doctor Gustaf VanHowzen (Theramore, Alliance) / Doctor Gregory Victor (Hammerfall, Horde) after Triage quest",
        },
        {
            range = {260, 290},
            recipe = "Runecloth Bandage",
            count = 50,
            materials = { { name = "Runecloth", count = 50 } },
            source = "Trainer (same Doctor who gave the quest)",
        },
        {
            range = {290, 300},
            recipe = "Heavy Runecloth Bandage",
            count = 15,
            materials = { { name = "Runecloth", count = 30 } },
            source = "Trainer (same Doctor, learned at 290)",
        },
        -- ==================== MASTER / TBC (300-375) ====================
        {
            range = {300, 330},
            recipe = "Heavy Runecloth Bandage",
            count = 70,
            materials = { { name = "Runecloth", count = 140 } },
            source = "Trainer",
            tip = ProfessionHelper.L["FIRSTAID_TIP_300_330"],
        },
        {
            range = {330, 360},
            recipe = "Netherweave Bandage",
            count = 45,
            materials = { { name = "Netherweave Cloth", count = 45 } },
            source = "Manual: Netherweave Bandage (same vendor as the Master book)",
        },
        {
            range = {360, 375},
            recipe = "Heavy Netherweave Bandage",
            count = 20,
            materials = { { name = "Netherweave Cloth", count = 40 } },
            source = "Manual: Heavy Netherweave Bandage (same vendor as the Master book)",
        },
    },
}
