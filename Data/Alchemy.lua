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
            range = {110, 150},
            recipe = "Minor Magic Resistance Potion",
            count = 44,
            materials = {
                { name = "Mageroyal", count = 132 },
                { name = "Wild Steelbloom", count = 44 },
                { name = "Empty Vial", count = 44 },
            },
            source = "World Drop Recipe",
            tip = "Se nao tiver a receita, use Healing Potion (Trainer) como alternativa.",
        },
        -- ==================== EXPERT (150-225) ====================
        {
            range = {150, 180},
            recipe = "Elixir of Ogre's Strength",
            count = 31,
            materials = {
                { name = "Earthroot", count = 31 },
                { name = "Kingsblood", count = 31 },
                { name = "Leaded Vial", count = 31 },
            },
            source = "World Drop Recipe",
            tip = "Se nao tiver a receita, use Mana Potion (Trainer) como alternativa.",
        },
        {
            range = {180, 210},
            recipe = "Mighty Troll's Blood Potion",
            count = 32,
            materials = {
                { name = "Bruiseweed", count = 32 },
                { name = "Liferoot", count = 32 },
                { name = "Leaded Vial", count = 32 },
            },
            source = "World Drop Recipe",
            tip = "Se nao tiver a receita, use Elixir of Agility (Trainer) como alternativa.",
        },
        -- ==================== ARTISAN (210-300) ====================
        {
            range = {210, 240},
            recipe = "Elixir of Detect Lesser Invisibility",
            count = 44,
            materials = {
                { name = "Khadgar's Whisker", count = 44 },
                { name = "Fadeleaf", count = 44 },
                { name = "Leaded Vial", count = 44 },
            },
            source = "World Drop Recipe",
            tip = "Se nao tiver a receita, use Greater Mana Potion (Trainer) como alternativa.",
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
            range = {250, 255},
            recipe = "Stonescale Oil",
            count = 7,
            materials = {
                { name = "Stonescale Eel", count = 7 },
                { name = "Leaded Vial", count = 7 },
            },
            source = "Trainer",
        },
        {
            range = {255, 285},
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
            range = {285, 290},
            recipe = "Purification Potion",
            count = 5,
            materials = {
                { name = "Icecap", count = 10 },
                { name = "Plaguebloom", count = 10 },
                { name = "Crystal Vial", count = 5 },
            },
            source = "Trainer",
        },
        {
            range = {290, 300},
            recipe = "Greater Arcane Protection Potion",
            count = 10,
            materials = {
                { name = "Dream Dust", count = 10 },
                { name = "Dreamfoil", count = 10 },
                { name = "Crystal Vial", count = 10 },
            },
            source = "Drop: Cobalt Mageweaver (Winterspring)",
            tip = "Receita dropa com alta chance dos Cobalt Mageweavers.",
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
            tip = "Receita comprada com 2 Halaa Research Tokens em Nagrand.",
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
            tip = "Receita dropa do Captain Skarloc na instancia Old Hillsbrad Foothills.",
        },
    },
}
