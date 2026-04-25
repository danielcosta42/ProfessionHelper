-- Profession Helper - Cooking Data (TBC Classic - Verified)
ProfessionHelper = ProfessionHelper or {}
ProfessionHelper.Cooking = {
    name = "Cooking",
    type = "secondary",

    trainer = {
        ["Alliance"] = {
            "Daryl Riknussun (Ironforge)",
            "Stephen Ryback (Stormwind)",
            "Gaeston (Hellfire Peninsula, Honor Hold)",
        },
        ["Horde"] = {
            "Zamja (Orgrimmar)",
            "Eunice Burch (Undercity)",
            "Baxter (Hellfire Peninsula, Thrallmar)",
        },
    },

    recipes = {
        { name = "Spice Bread", creates = 1, materials = { { name = "Simple Flour", count = 1 }, { name = "Mild Spices", count = 1 } }, orange = 1, yellow = 35, green = 45, grey = 55, source = "Trainer" },
        { name = "Herb Baked Egg", creates = 1, materials = { { name = "Small Egg", count = 1 }, { name = "Mild Spices", count = 1 } }, orange = 1, yellow = 35, green = 45, grey = 55, source = "Trainer" },
        { name = "Roasted Boar Meat", creates = 1, materials = { { name = "Chunk of Boar Meat", count = 1 } }, orange = 1, yellow = 35, green = 45, grey = 55, source = "Trainer" },
        { name = "Smoked Bear Meat", creates = 1, materials = { { name = "Bear Meat", count = 1 } }, orange = 40, yellow = 65, green = 80, grey = 100, source = "Vendor: Andrew Hilbert (Silverpine) / Drac Roughcut (Loch Modan)" },
        { name = "Boiled Clams", creates = 1, materials = { { name = "Clam Meat", count = 1 }, { name = "Refreshing Spring Water", count = 1 } }, orange = 50, yellow = 90, green = 110, grey = 130, source = "Trainer" },
        { name = "Coyote Steak", creates = 1, materials = { { name = "Coyote Meat", count = 1 } }, orange = 50, yellow = 90, green = 110, grey = 130, source = "Trainer" },
        { name = "Crab Cake", creates = 1, materials = { { name = "Crawler Meat", count = 1 }, { name = "Mild Spices", count = 1 } }, orange = 75, yellow = 100, green = 120, grey = 140, source = "Trainer" },
        { name = "Curiously Tasty Omelet", creates = 1, materials = { { name = "Raptor Egg", count = 1 }, { name = "Hot Spices", count = 1 } }, orange = 130, yellow = 175, green = 195, grey = 215, source = "Vendor: Kendor Kabonka (Stormwind) / Keena (Arathi Highlands)" },
        { name = "Roast Raptor", creates = 1, materials = { { name = "Raptor Flesh", count = 1 }, { name = "Hot Spices", count = 1 } }, orange = 175, yellow = 200, green = 215, grey = 230, source = "Vendor: Hammon Karwn (Stranglethorn Vale) / Keena (Arathi Highlands)" },
        { name = "Monster Omelet", creates = 1, materials = { { name = "Giant Egg", count = 1 }, { name = "Soothing Spices", count = 2 } }, orange = 225, yellow = 250, green = 265, grey = 280, source = "Vendor: Himmik (Winterspring) / Bale (Felwood, Horde) / Malygen (Felwood, Alliance)" },
        { name = "Spotted Yellowtail", creates = 1, materials = { { name = "Raw Spotted Yellowtail", count = 1 } }, orange = 225, yellow = 250, green = 265, grey = 280, source = "Vendor: Gikkix (Tanaris)" },
        { name = "Juicy Bear Burger", creates = 1, materials = { { name = "Bear Flank", count = 1 } }, orange = 250, yellow = 265, green = 275, grey = 285, source = "Vendor: Bale (Felwood, Horde) / Malygen (Felwood, Alliance)" },
        { name = "Smoked Desert Dumplings", creates = 1, materials = { { name = "Sandworm Meat", count = 1 }, { name = "Soothing Spices", count = 1 } }, orange = 285, yellow = 310, green = 325, grey = 340, source = "Quest: Desert Recipe (Silithus — Calandrath)" },
        { name = "Ravager Dog", creates = 1, materials = { { name = "Ravager Flesh", count = 1 } }, orange = 300, yellow = 320, green = 335, grey = 350, source = "Vendor: Cookie One-Eye (Thrallmar, Horde) / Sid Limbardi (Honor Hold, Alliance)" },
        { name = "Buzzard Bites", creates = 1, materials = { { name = "Buzzard Meat", count = 1 } }, orange = 300, yellow = 320, green = 335, grey = 350, source = "Quest chain: Ravager Egg Roundup (Hellfire Peninsula)" },
        { name = "Talbuk Steak", creates = 1, materials = { { name = "Talbuk Venison", count = 1 } }, orange = 325, yellow = 340, green = 350, grey = 360, source = "Vendor: Nula the Butcher (Nagrand, Horde) / Uriku (Nagrand, Alliance)" },
        { name = "Roasted Clefthoof", creates = 1, materials = { { name = "Clefthoof Meat", count = 1 } }, orange = 325, yellow = 340, green = 350, grey = 360, source = "Vendor: Nula the Butcher (Nagrand, Horde) / Uriku (Nagrand, Alliance)" },
        { name = "Warp Burger", creates = 1, materials = { { name = "Warped Flesh", count = 1 } }, orange = 325, yellow = 340, green = 350, grey = 360, source = "Vendor: Innkeeper Grilka (Garadar, Horde) / Supply Officer Mills (Allerian, Alliance)" },
        { name = "Crunchy Serpent", creates = 1, materials = { { name = "Serpent Flesh", count = 1 } }, orange = 335, yellow = 345, green = 365, grey = 375, source = "Vendor: Xerintha Ravenoak (Blade's Edge, Alliance) / Sassa Weldwell (Blade's Edge, Horde)" },
        { name = "Mok'Nathal Shortribs", creates = 1, materials = { { name = "Raptor Ribs", count = 1 } }, orange = 335, yellow = 345, green = 365, grey = 375, source = "Vendor: Xerintha Ravenoak (Blade's Edge, Alliance) / Sassa Weldwell (Blade's Edge, Horde)" },
    },

    levelingGuide = {
        -- ==================== APPRENTICE (1-75) ====================
        {
            range = {1, 40},
            recipe = "Spice Bread",
            count = 60,
            materials = { { name = "Simple Flour", count = 60 }, { name = "Mild Spices", count = 60 } },
            source = "Trainer",
            tip = ProfessionHelper.L["COOKING_TIP_1_40"],
        },
        {
            range = {40, 65},
            recipe = "Smoked Bear Meat",
            count = 35,
            materials = { { name = "Bear Meat", count = 35 } },
            source = "Vendor: Andrew Hilbert (Silverpine) / Drac Roughcut (Loch Modan)",
            tip = ProfessionHelper.L["COOKING_TIP_40_65"],
        },
        -- ==================== JOURNEYMAN (65-130) ====================
        {
            range = {65, 110},
            recipe = "Boiled Clams",
            count = 65,
            materials = { { name = "Clam Meat", count = 65 }, { name = "Refreshing Spring Water", count = 65 } },
            source = "Trainer",
            tip = ProfessionHelper.L["COOKING_TIP_65_110"],
        },
        {
            range = {110, 130},
            recipe = "Crab Cake",
            count = 30,
            materials = { { name = "Crawler Meat", count = 30 }, { name = "Mild Spices", count = 30 } },
            source = "Trainer",
            tip = ProfessionHelper.L["COOKING_TIP_110_130"],
        },
        -- ==================== EXPERT (130-225) ====================
        {
            range = {130, 175},
            recipe = "Curiously Tasty Omelet",
            count = 50,
            materials = { { name = "Raptor Egg", count = 50 }, { name = "Hot Spices", count = 50 } },
            source = "Vendor: Kendor Kabonka (Stormwind) / Keena (Arathi Highlands)",
            tip = ProfessionHelper.L["COOKING_TIP_130_175"],
        },
        {
            range = {175, 225},
            recipe = "Roast Raptor",
            count = 50,
            materials = { { name = "Raptor Flesh", count = 50 }, { name = "Hot Spices", count = 50 } },
            source = "Vendor: Hammon Karwn (Stranglethorn Vale) / Keena (Arathi Highlands)",
            tip = ProfessionHelper.L["COOKING_TIP_175_225"],
        },
        -- ==================== ARTISAN (225-300) ====================
        {
            range = {225, 250},
            recipe = "Monster Omelet",
            count = 25,
            materials = { { name = "Giant Egg", count = 25 }, { name = "Soothing Spices", count = 50 } },
            source = "Vendor: Himmik (Winterspring) / Bale (Felwood, Horde) / Malygen (Felwood, Alliance)",
            tip = ProfessionHelper.L["COOKING_TIP_225_250"],
        },
        {
            range = {250, 285},
            recipe = "Juicy Bear Burger",
            count = 40,
            materials = { { name = "Bear Flank", count = 40 } },
            source = "Vendor: Bale (Felwood, Horde) / Malygen (Felwood, Alliance)",
            tip = ProfessionHelper.L["COOKING_TIP_250_285"],
        },
        {
            range = {285, 300},
            recipe = "Smoked Desert Dumplings",
            count = 15,
            materials = { { name = "Sandworm Meat", count = 15 }, { name = "Soothing Spices", count = 15 } },
            source = "Quest: Desert Recipe → Sharing the Knowledge (Silithus)",
            tip = ProfessionHelper.L["COOKING_TIP_285_300"],
        },
        -- ==================== MASTER / TBC (300-375) ====================
        {
            range = {300, 325},
            recipe = "Ravager Dog",
            count = 30,
            materials = { { name = "Ravager Flesh", count = 30 } },
            source = "Vendor: Cookie One-Eye (Thrallmar, Horde) / Sid Limbardi (Honor Hold, Alliance)",
            tip = ProfessionHelper.L["COOKING_TIP_300_325"],
        },
        {
            range = {325, 355},
            recipe = "Talbuk Steak",
            count = 40,
            materials = { { name = "Talbuk Venison", count = 40 } },
            source = "Vendor: Nula the Butcher (Garadar, Horde) / Uriku (Telaar, Alliance)",
            tip = ProfessionHelper.L["COOKING_TIP_325_355"],
        },
        {
            range = {355, 375},
            recipe = "Crunchy Serpent",
            count = 60,
            materials = { { name = "Serpent Flesh", count = 60 } },
            source = "Vendor: Xerintha Ravenoak (Sylvanaar, Blade's Edge, Alliance) / Sassa Weldwell (Thunderlord Stronghold, Blade's Edge, Horde)",
            tip = ProfessionHelper.L["COOKING_TIP_355_375"],
        },
    },

    tips = {
        ProfessionHelper.L["COOKING_TIPS_1"],
        ProfessionHelper.L["COOKING_TIPS_2"],
        ProfessionHelper.L["COOKING_TIPS_3"],
        ProfessionHelper.L["COOKING_TIPS_4"],
        ProfessionHelper.L["COOKING_TIPS_5"],
    },
}
