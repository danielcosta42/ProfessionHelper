-- Profession Helper - Alchemy Data (TBC Classic - Verified)
ProfessionHelper = ProfessionHelper or {}
ProfessionHelper.Alchemy = {
    name = "Alchemy",
    type = "crafting",

    trainer = {
        ["Alliance"] = {
            "Alchemist Mallory (Elwynn Forest)",
            "Tally Berryfizz (Ironforge)",
            "Ainethil (Darnassus)",
            "Lorokeem (Shattrath)",
        },
        ["Horde"] = {
            "Doctor Herbert Halsey (Undercity)",
            "Yelmak (Orgrimmar)",
            "Bena Winterhoof (Thunder Bluff)",
            "Lorokeem (Shattrath)",
        },
    },

    recipes = {
        { name = "Minor Healing Potion", creates = 1, materials = { { name = "Peacebloom", count = 1 }, { name = "Silverleaf", count = 1 }, { name = "Empty Vial", count = 1 } }, orange = 1, yellow = 55, green = 77, grey = 95, source = "Trainer" },
        { name = "Elixir of Minor Fortitude", creates = 1, materials = { { name = "Earthroot", count = 2 }, { name = "Peacebloom", count = 1 }, { name = "Empty Vial", count = 1 } }, orange = 50, yellow = 80, green = 100, grey = 120, source = "Trainer" },
        { name = "Healing Potion", creates = 1, materials = { { name = "Bruiseweed", count = 1 }, { name = "Briarthorn", count = 1 }, { name = "Leaded Vial", count = 1 } }, orange = 110, yellow = 135, green = 155, grey = 175, source = "Trainer" },
        { name = "Mana Potion", creates = 1, materials = { { name = "Stranglekelp", count = 1 }, { name = "Kingsblood", count = 1 }, { name = "Leaded Vial", count = 1 } }, orange = 160, yellow = 180, green = 205, grey = 220, source = "Trainer" },
        { name = "Elixir of Agility", creates = 1, materials = { { name = "Stranglekelp", count = 1 }, { name = "Goldthorn", count = 1 }, { name = "Leaded Vial", count = 1 } }, orange = 185, yellow = 205, green = 230, grey = 245, source = "Trainer" },
        { name = "Greater Mana Potion", creates = 1, materials = { { name = "Khadgar's Whisker", count = 1 }, { name = "Goldthorn", count = 1 }, { name = "Crystal Vial", count = 1 } }, orange = 205, yellow = 220, green = 245, grey = 260, source = "Trainer" },
        { name = "Superior Healing Potion", creates = 1, materials = { { name = "Sungrass", count = 1 }, { name = "Khadgar's Whisker", count = 1 }, { name = "Crystal Vial", count = 1 } }, orange = 215, yellow = 230, green = 255, grey = 270, source = "Trainer" },
        { name = "Elixir of Greater Agility", creates = 1, materials = { { name = "Sungrass", count = 1 }, { name = "Goldthorn", count = 1 }, { name = "Crystal Vial", count = 1 } }, orange = 240, yellow = 255, green = 275, grey = 295, source = "Trainer" },
        { name = "Purification Potion", creates = 1, materials = { { name = "Icecap", count = 2 }, { name = "Plaguebloom", count = 2 }, { name = "Crystal Vial", count = 1 } }, orange = 285, yellow = 300, green = 325, grey = 340, source = "Trainer" },
        { name = "Volatile Healing Potion", creates = 1, materials = { { name = "Golden Sansam", count = 1 }, { name = "Felweed", count = 1 }, { name = "Imbued Vial", count = 1 } }, orange = 300, yellow = 315, green = 320, grey = 330, source = "Trainer (Outland)" },
        { name = "Elixir of Healing Power", creates = 1, materials = { { name = "Golden Sansam", count = 1 }, { name = "Dreaming Glory", count = 1 }, { name = "Imbued Vial", count = 1 } }, orange = 310, yellow = 325, green = 330, grey = 340, source = "Trainer (Outland)" },
        { name = "Mad Alchemist's Potion", creates = 1, materials = { { name = "Ragveil", count = 2 }, { name = "Crystal Vial", count = 1 } }, orange = 320, yellow = 335, green = 340, grey = 350, source = "Trainer (Outland)" },
        { name = "Super Healing Potion", creates = 1, materials = { { name = "Netherbloom", count = 2 }, { name = "Felweed", count = 1 }, { name = "Imbued Vial", count = 1 } }, orange = 325, yellow = 340, green = 345, grey = 355, source = "Trainer (Outland)" },
        { name = "Super Mana Potion", creates = 1, materials = { { name = "Dreaming Glory", count = 2 }, { name = "Felweed", count = 1 }, { name = "Imbued Vial", count = 1 } }, orange = 340, yellow = 355, green = 360, grey = 370, source = "Vendor: Haalrun (Telredor) / Daga Ramba (Thunderlord Stronghold) — 5g" },
        { name = "Major Dreamless Sleep Potion", creates = 1, materials = { { name = "Dreaming Glory", count = 1 }, { name = "Nightmare Vine", count = 1 }, { name = "Imbued Vial", count = 1 } }, orange = 350, yellow = 365, green = 370, grey = 380, source = "Vendor: Leeli Longhaggle (Allerian Stronghold) / Daga Ramba (Thunderlord Stronghold) — 3g" },
        { name = "Elixir of Major Shadow Power", creates = 1, materials = { { name = "Ancient Lichen", count = 1 }, { name = "Nightmare Vine", count = 1 }, { name = "Imbued Vial", count = 1 } }, orange = 350, yellow = 365, green = 370, grey = 380, source = "Vendor: Nakodu (Shattrath) — Lower City Revered" },
    },

    levelingGuide = {
        -- ==================== APPRENTICE (1-75) ====================
        {
            range = {1, 75},
            recipe = "Minor Healing Potion",
            count = 82,
            materials = {
                { name = "Peacebloom", count = 82 },
                { name = "Silverleaf", count = 82 },
                { name = "Empty Vial", count = 82 },
            },
            source = "Trainer",
        },
        -- ==================== JOURNEYMAN (75-150) ====================
        {
            range = {75, 110},
            recipe = "Elixir of Minor Fortitude",
            count = 59,
            materials = {
                { name = "Peacebloom", count = 59 },
                { name = "Earthroot", count = 118 },
                { name = "Empty Vial", count = 59 },
            },
            source = "Trainer",
        },
        {
            range = {110, 160},
            recipe = "Healing Potion",
            count = 60,
            materials = {
                { name = "Bruiseweed", count = 60 },
                { name = "Briarthorn", count = 60 },
                { name = "Leaded Vial", count = 60 },
            },
            source = "Trainer",
            tip = ProfessionHelper.L["ALCHEMY_TIP_110_150"],
        },
        -- ==================== EXPERT (150-225) ====================
        {
            range = {160, 190},
            recipe = "Mana Potion",
            count = 55,
            materials = {
                { name = "Stranglekelp", count = 55 },
                { name = "Kingsblood", count = 55 },
                { name = "Leaded Vial", count = 55 },
            },
            source = "Trainer",
            tip = ProfessionHelper.L["ALCHEMY_TIP_150_180"],
        },
        {
            range = {190, 215},
            recipe = "Elixir of Agility",
            count = 55,
            materials = {
                { name = "Stranglekelp", count = 55 },
                { name = "Goldthorn", count = 55 },
                { name = "Leaded Vial", count = 55 },
            },
            source = "Trainer",
            tip = ProfessionHelper.L["ALCHEMY_TIP_180_210"],
        },
        -- ==================== ARTISAN (210-300) ====================
        {
            range = {215, 250},
            recipe = "Greater Mana Potion",
            count = 50,
            materials = {
                { name = "Khadgar's Whisker", count = 50 },
                { name = "Goldthorn", count = 50 },
                { name = "Crystal Vial", count = 50 },
            },
            source = "Trainer",
            tip = ProfessionHelper.L["ALCHEMY_TIP_210_240"],
        },
        {
            range = {240, 250},
            recipe = "Superior Healing Potion",
            count = 16,
            materials = {
                { name = "Sungrass", count = 16 },
                { name = "Khadgar's Whisker", count = 16 },
                { name = "Crystal Vial", count = 16 },
            },
            source = "Trainer",
        },
        {
            range = {250, 285},
            recipe = "Elixir of Greater Agility",
            count = 54,
            materials = {
                { name = "Sungrass", count = 54 },
                { name = "Goldthorn", count = 54 },
                { name = "Crystal Vial", count = 54 },
            },
            source = "Trainer",
        },
        {
            range = {285, 300},
            recipe = "Purification Potion",
            count = 20,
            materials = {
                { name = "Icecap", count = 40 },
                { name = "Plaguebloom", count = 40 },
                { name = "Crystal Vial", count = 20 },
            },
            source = "Trainer",
            tip = ProfessionHelper.L["ALCHEMY_TIP_285_290"],
        },
        -- ==================== MASTER / TBC (300-375) ====================
        {
            range = {300, 310},
            recipe = "Volatile Healing Potion",
            count = 10,
            materials = {
                { name = "Golden Sansam", count = 10 },
                { name = "Felweed", count = 10 },
                { name = "Imbued Vial", count = 10 },
            },
            source = "Trainer (Outland)",
        },
        {
            range = {310, 325},
            recipe = "Elixir of Healing Power",
            count = 15,
            materials = {
                { name = "Golden Sansam", count = 15 },
                { name = "Dreaming Glory", count = 15 },
                { name = "Imbued Vial", count = 15 },
            },
            source = "Trainer (Outland)",
        },
        {
            range = {325, 330},
            recipe = "Mad Alchemist's Potion",
            count = 5,
            materials = {
                { name = "Ragveil", count = 10 },
                { name = "Crystal Vial", count = 5 },
            },
            source = "Trainer (Outland)",
        },
        {
            range = {330, 355},
            recipe = "Elixir of Ironskin",
            count = 31,
            materials = {
                { name = "Ragveil", count = 31 },
                { name = "Ancient Lichen", count = 31 },
                { name = "Imbued Vial", count = 31 },
            },
            source = "Vendor: Halaa Research Token (Nagrand)",
            tip = ProfessionHelper.L["ALCHEMY_TIP_330_355"],
        },
        {
            range = {355, 365},
            recipe = "Elixir of Major Shadow Power",
            count = 10,
            materials = {
                { name = "Ancient Lichen", count = 10 },
                { name = "Nightmare Vine", count = 10 },
                { name = "Imbued Vial", count = 10 },
            },
            source = "Vendor: Nakodu (Shattrath) — Lower City Revered",
        },
        {
            range = {365, 375},
            recipe = "Ironshield Potion",
            count = 10,
            materials = {
                { name = "Mote of Earth", count = 30 },
                { name = "Ancient Lichen", count = 20 },
                { name = "Imbued Vial", count = 10 },
            },
            source = "Drop: Captain Skarloc (Old Hillsbrad Foothills)",
            tip = ProfessionHelper.L["ALCHEMY_TIP_365_375"],
        },
    },
}
