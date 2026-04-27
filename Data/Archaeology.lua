-- Profession Helper - Archaeology Data (Cataclysm 4.x+)
-- Requires Cataclysm (minVersion = 40000). Archaeology was added in Patch 4.0.
-- NOTE: Archaeology is a survey-based profession — no crafting recipes.
-- Players use the "Survey" ability at dig sites to collect fragments, then
-- solve artifacts for skill-ups and rare rewards.
ProfessionHelper = ProfessionHelper or {}
ProfessionHelper.Archaeology = {
    name = "Archaeology",
    type = "secondary",
    minVersion = 40000,

    trainer = {
        ["Alliance"] = {
            "Harrison Jones (Stormwind — Dwarven District — starts quest chain)",
            "Doktor Professor Ironpants (Ironforge — Hall of Explorers)",
            "Any Archaeology trainer in major cities",
        },
        ["Horde"] = {
            "Belloc Brightblade (Orgrimmar — The Drag — starts quest chain)",
            "Any Archaeology trainer in major cities",
        },
    },

    -- How the profession works
    howItWorks = {
        "1. Learn Archaeology from any trainer in a capital city.",
        "2. Open your world map — dig sites appear as shovel icons (3 per continent).",
        "3. Fly to a dig site and use 'Survey' (ability from your spellbook).",
        "4. A theodolite appears pointing toward fragments. Colored light: Red=far, Yellow=medium, Green=close.",
        "5. Each dig site allows 3 surveys (3 fragment loots). Then it despawns and a new site opens.",
        "6. Collect enough fragments to solve an artifact (Solve button in Archaeology tab).",
        "7. Solving artifacts gives skill-ups and occasionally gives rare epic items or mounts!",
        "8. Keystones can be used to add +12 fragments to speed up solving (but save Tol'vir keystones for rare artifacts!).",
    },

    -- Artifacts worth hunting
    notableArtifacts = {
        { name = "Vial of the Sands",          race = "Tol'vir",       rarity = "Rare", fragments = 150, description = "Teaches Sandstone Drake mount — player transforms into a drake and can carry another player. Sell recipe for 30,000-60,000g!" },
        { name = "Zin'rokh, Destroyer of Worlds", race = "Troll",      rarity = "Rare", fragments = 100, description = "Powerful two-handed sword — BIS for many melee specs in early Cata." },
        { name = "Fossilized Raptor",           race = "Fossil",        rarity = "Rare", fragments = 100, description = "Unique skeletal raptor mount. Fossil race is the easiest to complete." },
        { name = "Pterrordax Hatchling",        race = "Fossil",        rarity = "Rare", fragments = 85,  description = "Flying battle pet from fossil fragments. Account-wide collectible." },
        { name = "Nifflevar Bearded Axe",       race = "Vrykul",        rarity = "Rare", fragments = 130, description = "Cosmetic two-handed axe with a unique model." },
        { name = "The Innkeeper's Daughter",    race = "Dwarf",         rarity = "Rare", fragments = 100, description = "Toy: teleports you to a random inn (1-hr CD)." },
        { name = "Scepter of Nekhet",           race = "Tol'vir",       rarity = "Rare", fragments = 130, description = "Caster off-hand, powerful for healers/casters in early Cata." },
        { name = "Ring of the Boy Emperor",     race = "Tol'vir",       rarity = "Rare", fragments = 150, description = "Powerful ring for tank/DPS — high item level." },
        { name = "Pendant of the Scarab Storm", race = "Tol'vir",       rarity = "Rare", fragments = 150, description = "Powerful caster necklace." },
    },

    levelingGuide = {
        {
            range = {1, 50},
            tip = "Learn Archaeology from a trainer in a capital city. Open your world map to find dig sites (shovel icons). Start with Eastern Kingdoms or Kalimdor. Each survey gives 5-9 fragments. Dig until the site is exhausted (3 loot spots), then move to the next.",
        },
        {
            range = {50, 150},
            tip = "Continue Eastern Kingdoms + Kalimdor dig sites. Rotate all 3 active sites per continent. Flying mount is strongly recommended. Focus Dwarf (Loch Modan, Dun Morogh, Badlands) and Night Elf (Kalimdor) sites — both have frequent artifact completions.",
        },
        {
            range = {150, 300},
            tip = "Still leveling on classic continents. Solve artifacts frequently for skill-ups. Common artifacts give +3-5 skill each solve. Avoid spending Keystones until you are hunting rare artifacts. Tip: Fossil race is the fastest to complete — always solve Fossil artifacts first.",
        },
        {
            range = {300, 375},
            tip = "Outland dig sites unlock at Archaeology 300. Fly to Outland (Hellfire, Zangarmarsh, Nagrand, Blade's Edge, Netherstorm, Shadowmoon). Draenei and Orc artifacts become available. Outland gives larger fragment counts per dig — faster leveling than Classic.",
        },
        {
            range = {375, 450},
            tip = "Northrend dig sites unlock at Archaeology 375. Fly to Howling Fjord, Dragonblight, Grizzly Hills, Storm Peaks, Icecrown. Vrykul artifacts give powerful cosmetic items. Nerubian artifacts are rarer but have no notable rewards.",
        },
        {
            range = {450, 525},
            tip = "Cataclysm dig sites unlock at Archaeology 450. PRIORITY: Farm Uldum (Tol'vir) dig sites — Vial of the Sands recipe drops from rare Tol'vir artifacts! Also visit Twilight Highlands (Dragonmaw), Deepholm, Vashj'ir. Tol'vir rare artifacts require 150 fragments + keystones.",
        },
    },

    farmingLocations = {
        -- ==================== CLASSIC (1-300) ====================
        {
            skillRange = {1, 100},
            locations = {
                {
                    zone = "Eastern Kingdoms — Dun Morogh / Loch Modan / Arathi",
                    faction = "Both",
                    route = "Rotate all 3 active dig sites. Dun Morogh and Loch Modan are compact — fast travel between surveys.",
                    tips  = "Dwarf artifacts complete quickly (45-55 fragments each). Use Keystones to skip common artifacts.",
                    levelRange = "Any",
                },
                {
                    zone = "Kalimdor — Ashenvale / Darkshore / Thousand Needles",
                    faction = "Both",
                    route = "Night Elf sites are abundant in Kalimdor. Troll sites appear in Northern Barrens and Stranglethorn area.",
                    tips  = "Night Elf artifacts complete quickly and have some interesting items. Focus these over Troll early on.",
                    levelRange = "Any",
                },
            },
        },
        {
            skillRange = {100, 300},
            locations = {
                {
                    zone = "Both classic continents — all zones",
                    faction = "Both",
                    route = "Work through all available dig sites efficiently. Use a flying mount and plan routes to minimize travel time between the 3 active sites.",
                    tips  = "Fossil sites appear everywhere in classic zones. Always complete Fossil artifacts first — fast completion, 60-85 fragments each.",
                    levelRange = "Any",
                },
            },
        },
        -- ==================== OUTLAND (300-375) ====================
        {
            skillRange = {300, 375},
            locations = {
                {
                    zone = "Outland — All Zones",
                    faction = "Both",
                    route = "Hellfire Peninsula → Terokkar Forest → Nagrand → Blade's Edge → Netherstorm → Shadowmoon Valley. Rotate 3 active sites.",
                    tips  = "Draenei artifacts are the most common Outland race. Fragment counts are higher than Classic (6-12 per survey) — faster leveling.",
                    levelRange = "58+",
                },
            },
        },
        -- ==================== NORTHREND (375-450) ====================
        {
            skillRange = {375, 450},
            locations = {
                {
                    zone = "Northrend — Howling Fjord / Dragonblight / Storm Peaks",
                    faction = "Both",
                    route = "Howling Fjord: Vrykul sites near the coast. Dragonblight: Nerubian sites in eastern area. Storm Peaks: mix of Vrykul and Nerubian.",
                    tips  = "Vrykul race: most common in Northrend, gives Nifflevar Bearded Axe (rare). Nerubian: rarer, fragments harder to find.",
                    levelRange = "68+",
                },
                {
                    zone = "Icecrown",
                    faction = "Both",
                    route = "Icecrown dig sites appear near Argent Tournament and Icecrown Citadel zones.",
                    tips  = "High-level zone but dig sites are relatively compact.",
                    levelRange = "77+",
                },
            },
        },
        -- ==================== CATACLYSM (450-525) ====================
        {
            skillRange = {450, 525},
            locations = {
                {
                    zone = "Uldum — PRIORITY ZONE",
                    faction = "Both",
                    route = "Northern Uldum around Ramkahen. Survey the broad sandy areas north and east of the city.",
                    tips  = "BEST ZONE: Tol'vir artifacts — includes Vial of the Sands (Sandstone Drake mount recipe, worth 30,000-60,000g!) and powerful gear items. Spend maximum time here.",
                    levelRange = "83-85",
                },
                {
                    zone = "Twilight Highlands",
                    faction = "Both",
                    route = "Central and northern Twilight Highlands. Dragonmaw sites cluster near Bloodgulch and Wyrmscar.",
                    tips  = "Dragonmaw artifacts are less notable but complete quickly. Good for skill-ups when Uldum sites are on cooldown.",
                    levelRange = "84-85",
                },
                {
                    zone = "Deepholm",
                    faction = "Both",
                    route = "Survey throughout Deepholm — relatively compact zone, good for quick rotations.",
                    tips  = "Earthen Ring and Nerubians in Deepholm. Requires portal access from Dalaran or Stormwind/Orgrimmar.",
                    levelRange = "82-83",
                },
                {
                    zone = "Vashj'ir",
                    faction = "Both",
                    route = "Shimmering Expanse and Abyssal Depths zones. Naga dig sites.",
                    tips  = "Underwater movement can be slow without Sea Legs buff or Abyssal Seahorse mount. Lower priority than Uldum.",
                    levelRange = "80-82",
                },
            },
        },
    },
}
