-- Profession Helper - Daily & Repeatable Quests
-- TBC Classic (Anniversary) daily quests for Cooking and Fishing

ProfessionHelper = ProfessionHelper or {}

local L = ProfessionHelper.L

ProfessionHelper.Dailies = {

    -------------------------------------------------------------------------------
    -- COOKING DAILIES
    -- Quest giver: The Rokk — Shattrath City, Lower City
    -------------------------------------------------------------------------------
    Cooking = {
        npc         = "The Rokk",
        npcZone     = "Shattrath City",
        npcLocation = "Lower City",
        npcCoords   = { x = 0.626, y = 0.681 },  -- Lower City, near cooking fire
        reward      = "Barrel of Fish / Crate of Meat",
        rewardTip   = L["DAILY_COOKING_REWARD_TIP"],
        quests = {
            {
                name    = "Revenge is Served",
                summary = L["DAILY_RVNG_SUMMARY"],
                steps = {
                    { text = L["DAILY_RVNG_STEP1"] },
                    { text = L["DAILY_RVNG_STEP2"] },
                    { text = L["DAILY_RVNG_STEP3"] },
                },
                items = {
                    { name = "Clefthoof Meat", count = 4, source = "Drop (Dying Clefthoof, Nagrand)" },
                },
                zone      = "Nagrand",
                coords    = { x = 0.280, y = 0.560 },  -- southwest Nagrand, Dying Clefthoof area
                mapTip    = L["DAILY_RVNG_MAP"],
            },
            {
                name    = "Super Hot Stew",
                summary = L["DAILY_SHS_SUMMARY"],
                steps = {
                    { text = L["DAILY_SHS_STEP1"] },
                    { text = L["DAILY_SHS_STEP2"] },
                    { text = L["DAILY_SHS_STEP3"] },
                },
                items = {
                    { name = "Magma Crab Meat", count = 4, source = "Drop (Magma Crabs, Blade's Edge — Scalewing Shelf)" },
                },
                zone   = "Blade's Edge Mountains",
                coords = { x = 0.874, y = 0.566 },  -- Scalewing Shelf, far east
                mapTip = L["DAILY_SHS_MAP"],
            },
            {
                name    = "Soup for the Soul",
                summary = L["DAILY_SFTS_SUMMARY"],
                steps = {
                    { text = L["DAILY_SFTS_STEP1"] },
                    { text = L["DAILY_SFTS_STEP2"] },
                    { text = L["DAILY_SFTS_STEP3"] },
                },
                items = {
                    { name = "Mok'Nathal Shortribs", count = 4, source = "Vendor: Xerintha Ravenoak (Sylvanaar, Alliance) / Sassa Weldwell (Thunderlord, Horde)" },
                    { name = "Shimmer Stout",         count = 6, source = "Vendor: Keegan Ironbreaker (Wildhammer Stronghold) or any Shattrath inn" },
                },
                zone   = "Blade's Edge Mountains",
                coords = { x = 0.418, y = 0.670 },  -- Sylvanaar (Alliance vendor Xerintha)
                mapTip = L["DAILY_SFTS_MAP"],
            },
            {
                name    = "Fishy Feast",
                summary = L["DAILY_FF_SUMMARY"],
                steps = {
                    { text = L["DAILY_FF_STEP1"] },
                    { text = L["DAILY_FF_STEP2"] },
                    { text = L["DAILY_FF_STEP3"] },
                },
                items = {
                    { name = L["DAILY_FF_ITEM_NAME"], count = 4, source = "Fishing — Terokkar Forest Lakes" },
                },
                zone   = "Terokkar Forest",
                coords = { x = 0.490, y = 0.580 },  -- central lake area Terokkar
                mapTip = L["DAILY_FF_MAP"],
            },
        },
    },

    -------------------------------------------------------------------------------
    -- FISHING DAILIES
    -- Quest giver: Old Man Barlo — Terokkar Forest (Silmyr Lake)
    -------------------------------------------------------------------------------
    Fishing = {
        npc         = "Old Man Barlo",
        npcZone     = "Terokkar Forest",
        npcLocation = "Silmyr Lake",
        npcCoords   = { x = 0.490, y = 0.692 },
        reward      = "Bag of Fishing Treasures",
        rewardTip   = L["DAILY_FISHING_REWARD_TIP"],
        quests = {
            {
                name    = "Shrimpin' Ain't Easy",
                summary = L["DAILY_SAE_SUMMARY"],
                steps = {
                    { text = L["DAILY_SAE_STEP1"] },
                    { text = L["DAILY_SAE_STEP2"] },
                    { text = L["DAILY_SAE_STEP3"] },
                    { text = L["DAILY_SAE_STEP4"] },
                },
                items = {
                    { name = "Bloated Barbed Gill Trout", count = 1, source = "Fishing — Terokkar Forest (rivers/lakes)" },
                },
                zone   = "Terokkar Forest",
                coords = { x = 0.490, y = 0.692 },  -- Silmyr Lake area
                mapTip = L["DAILY_SAE_MAP"],
            },
            {
                name    = "Bait Bandits",
                summary = L["DAILY_BB_SUMMARY"],
                steps = {
                    { text = L["DAILY_BB_STEP1"] },
                    { text = L["DAILY_BB_STEP2"] },
                    { text = L["DAILY_BB_STEP3"] },
                    { text = L["DAILY_BB_STEP4"] },
                },
                items = {
                    { name = "Enormous Barbed Gill Trout", count = 1, source = "Fishing — Terokkar Forest (rivers/lakes)" },
                },
                zone   = "Terokkar Forest",
                coords = { x = 0.490, y = 0.692 },
                mapTip = L["DAILY_BB_MAP"],
            },
            {
                name    = "Rock Lobster",
                summary = L["DAILY_RL_SUMMARY"],
                steps = {
                    { text = L["DAILY_RL_STEP1"] },
                    { text = L["DAILY_RL_STEP2"] },
                    { text = L["DAILY_RL_STEP3"] },
                    { text = L["DAILY_RL_STEP4"] },
                },
                items = {
                    { name = "Crescent-Tail Skullfish", count = 1, source = "Fishing — Silmyr Lake, Terokkar" },
                },
                zone   = "Terokkar Forest",
                coords = { x = 0.490, y = 0.692 },
                mapTip = L["DAILY_RL_MAP"],
            },
            {
                name    = "Thunder Away!",
                summary = L["DAILY_TA_SUMMARY"],
                steps = {
                    { text = L["DAILY_TA_STEP1"] },
                    { text = L["DAILY_TA_STEP2"] },
                    { text = L["DAILY_TA_STEP3"] },
                    { text = L["DAILY_TA_STEP4"] },
                },
                items = {
                    { name = "Lightning Eel", count = 1, source = "Fishing — Nagrand Lakes" },
                },
                zone   = "Nagrand",
                coords = { x = 0.500, y = 0.720 },  -- Skysong Lake, southern Nagrand
                mapTip = L["DAILY_TA_MAP"],
            },
            {
                name    = "The One That Got Away",
                summary = L["DAILY_TOTGA_SUMMARY"],
                steps = {
                    { text = L["DAILY_TOTGA_STEP1"] },
                    { text = L["DAILY_TOTGA_STEP2"] },
                    { text = L["DAILY_TOTGA_STEP3"] },
                    { text = L["DAILY_TOTGA_STEP4"] },
                },
                items = {
                    { name = "Blackfin Darter", count = 1, source = "Fishing — Skettis, Terokkar" },
                },
                zone   = "Terokkar Forest",
                coords = { x = 0.760, y = 0.810 },  -- Skettis
                mapTip = L["DAILY_TOTGA_MAP"],
            },
        },
    },
}
