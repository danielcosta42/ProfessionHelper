-- Profession Helper - Skinning Data (Gathering Profession)
ProfessionHelper = ProfessionHelper or {}
ProfessionHelper.Skinning = {
    name = "Skinning",
    type = "gathering",
    
    trainer = {
        ["Alliance"] = {
            "Helene Peltskinner (Elwynn Forest)",
            "Balthus Stoneflayer (Stormwind)",
            "Radnaal Maneweaver (Darnassus)",
            "Seymour (Shattrath)",
        },
        ["Horde"] = {
            "Yonn Deepcut (Orgrimmar)",
            "Rand Rhoads (Undercity)",
            "Mooranta (Thunder Bluff)",
            "Seymour (Shattrath)",
        },
    },
    
    -- Skinning follows a simple formula: you need skill = mob level * 5
    skillFormula = "Skill necessário = Nível do Mob × 5 (ex: mob nível 60 requer skill 300)",
    
    leatherTypes = {
        { leather = "Ruined Leather Scraps", mobLevel = "1-16", skillRequired = "1-80" },
        { leather = "Light Leather", mobLevel = "1-27", skillRequired = "1-135" },
        { leather = "Light Hide", mobLevel = "10-27", skillRequired = "50-135" },
        { leather = "Medium Leather", mobLevel = "15-36", skillRequired = "75-180" },
        { leather = "Medium Hide", mobLevel = "15-36", skillRequired = "75-180" },
        { leather = "Heavy Leather", mobLevel = "25-46", skillRequired = "125-230" },
        { leather = "Heavy Hide", mobLevel = "25-46", skillRequired = "125-230" },
        { leather = "Thick Leather", mobLevel = "35-63", skillRequired = "175-315" },
        { leather = "Thick Hide", mobLevel = "40-59", skillRequired = "200-295" },
        { leather = "Rugged Leather", mobLevel = "43-63", skillRequired = "215-315" },
        { leather = "Rugged Hide", mobLevel = "47-63", skillRequired = "235-315" },
        -- TBC
        { leather = "Knothide Leather Scraps", mobLevel = "58-63", skillRequired = "290-315" },
        { leather = "Knothide Leather", mobLevel = "62-70", skillRequired = "310-350" },
        { leather = "Fel Hide", mobLevel = "Demons", skillRequired = "310+" },
        { leather = "Fel Scales", mobLevel = "Demons/Dragonkin", skillRequired = "310+" },
        { leather = "Cobra Scales", mobLevel = "Coilfang Snakes", skillRequired = "340+" },
        { leather = "Wind Scales", mobLevel = "Wind Serpents", skillRequired = "340+" },
        { leather = "Nether Dragonscales", mobLevel = "Netherwing", skillRequired = "350+" },
    },
    
    farmingLocations = {
        -- ==================== LIGHT LEATHER (1-75) ====================
        {
            skillRange = {1, 75},
            leather = "Ruined Leather Scraps, Light Leather",
            locations = {
                {
                    zone = "Durotar",
                    faction = "Horde",
                    route = "Mate Scorpids e Boars ao redor de Razor Hill e ao longo da costa.",
                    mobs = "Scorpid Workers, Durotar Tigers, Boars",
                    tips = "Muitos mobs skinnable. Combina bem com quests.",
                    levelRange = "1-10",
                },
                {
                    zone = "Elwynn Forest",
                    faction = "Alliance",
                    route = "Mate Wolves e Boars ao redor de Goldshire e Eastvale Logging Camp.",
                    mobs = "Prowlers, Young Forest Bears, Boars",
                    tips = "Alta densidade de mobs skinnable perto das quests.",
                    levelRange = "1-10",
                },
                {
                    zone = "The Barrens",
                    faction = "Horde",
                    route = "Grande área ao redor de Crossroads. Foque em Zhevras e Raptors.",
                    mobs = "Zhevras, Raptors, Lions, Hyenas",
                    tips = "MELHOR zona para Light Leather! Enorme quantidade de mobs.",
                    levelRange = "10-25",
                },
                {
                    zone = "Loch Modan",
                    faction = "Alliance",
                    route = "Mate Bears ao redor do lago e Boars na área sul.",
                    mobs = "Elder Black Bears, Mountain Boars",
                    tips = "Boa densidade. Combina com quests de dwarf.",
                    levelRange = "10-20",
                },
                {
                    zone = "Westfall",
                    faction = "Alliance",
                    route = "Mate os Coyotes e Boars espalhados pela zona.",
                    mobs = "Coyotes, Goretusks, Fleshrippers",
                    tips = "Muitos mobs mas espalhados. Bom para quests também.",
                    levelRange = "10-20",
                },
            },
        },
        
        -- ==================== MEDIUM LEATHER (75-150) ====================
        {
            skillRange = {75, 150},
            leather = "Medium Leather, Medium Hide",
            locations = {
                {
                    zone = "Hillsbrad Foothills",
                    faction = "Both",
                    route = "Mate Bears e Lions ao redor de Hillsbrad Fields e as montanhas.",
                    mobs = "Giant Yetis, Mountain Lions, Bears",
                    tips = "EXCELENTE zona! Alta densidade de mobs nível 20-30.",
                    levelRange = "20-30",
                },
                {
                    zone = "Wetlands",
                    faction = "Alliance",
                    route = "Mate Crocolisks ao redor dos pântanos e Raptors no sul.",
                    mobs = "Wetlands Crocolisks, Mottled Raptors",
                    tips = "Crocolisks são ótimos. Também dá Light Leather ainda.",
                    levelRange = "20-30",
                },
                {
                    zone = "Stonetalon Mountains",
                    faction = "Both",
                    route = "Mate Cougars e Bears nas montanhas.",
                    mobs = "Stonetalon Cougars, Deepmoss Lurkers",
                    tips = "Bom para Horde que está upando na área.",
                    levelRange = "15-27",
                },
                {
                    zone = "Ashenvale",
                    faction = "Both",
                    route = "Mate Bears e Wolves na floresta.",
                    mobs = "Ashenvale Bears, Ghostpaw Runners",
                    tips = "Grande zona com muitos mobs. Prepare-se para PvP.",
                    levelRange = "18-30",
                },
                {
                    zone = "Thousand Needles",
                    faction = "Both",
                    route = "Mate os Kodo ao sul e Cougars nas montanhas.",
                    mobs = "Salt Flats Vultures, Cougars, Kodos",
                    tips = "Transição para Heavy Leather no final.",
                    levelRange = "25-35",
                },
            },
        },
        
        -- ==================== HEAVY LEATHER (150-205) ====================
        {
            skillRange = {150, 205},
            leather = "Heavy Leather, Heavy Hide",
            locations = {
                {
                    zone = "Stranglethorn Vale",
                    faction = "Both",
                    route = "Mate Tigers, Panthers e Raptors em toda a zona.",
                    mobs = "Stranglethorn Tigers, Panthers, Raptors, Gorillas",
                    tips = "MELHOR zona para Heavy Leather! Densidade incrível de mobs.",
                    levelRange = "30-45",
                },
                {
                    zone = "Badlands",
                    faction = "Both",
                    route = "Mate Coyotes e Rock Elementals (alguns têm scales).",
                    mobs = "Feral Coyotes, Ridge Stalkers",
                    tips = "Menos disputado que STV. Bom para farm tranquilo.",
                    levelRange = "35-45",
                },
                {
                    zone = "Dustwallow Marsh",
                    faction = "Both",
                    route = "Mate Crocolisks e Raptors nos pântanos.",
                    mobs = "Darkfang Creepers, Mirefin Murlocs Raptors",
                    tips = "Crocolisks dão muito leather. Boa zona.",
                    levelRange = "35-45",
                },
                {
                    zone = "Desolace",
                    faction = "Both",
                    route = "Mate Kodos e Scorpids na área central.",
                    mobs = "Aged Kodos, Scorpashi",
                    tips = "Kodos são excelentes para Heavy Leather.",
                    levelRange = "30-40",
                },
            },
        },
        
        -- ==================== THICK LEATHER (205-260) ====================
        {
            skillRange = {205, 260},
            leather = "Thick Leather, Thick Hide",
            locations = {
                {
                    zone = "Un'Goro Crater",
                    faction = "Both",
                    route = "Mate Dinosaurs em toda a cratera. Foque nos Devilsaurs se possível.",
                    mobs = "Ravasaurs, Pterrordax, Devilsaurs, Diemetradons",
                    tips = "MELHOR zona para Thick Leather! Dinosaurs dão muito leather.",
                    levelRange = "48-55",
                },
                {
                    zone = "Feralas",
                    faction = "Both",
                    route = "Mate Wolves e Bears na floresta, Yetis nas montanhas.",
                    mobs = "Feral Scar Yetis, Longtooth Runners",
                    tips = "Yetis são excelentes. Muitos mobs skinnable.",
                    levelRange = "40-50",
                },
                {
                    zone = "The Hinterlands",
                    faction = "Both",
                    route = "Mate Wolves e Owlbeasts na floresta.",
                    mobs = "Silvermane Wolves, Owlbeasts",
                    tips = "Boa transição entre Heavy e Thick leather.",
                    levelRange = "40-50",
                },
                {
                    zone = "Tanaris",
                    faction = "Both",
                    route = "Mate Hyenas e Basilisks no deserto.",
                    mobs = "Dunemaul Ogres (some), Wastewander (no)",
                    tips = "Menos mobs skinnable que outras zonas.",
                    levelRange = "40-50",
                },
                {
                    zone = "Azshara",
                    faction = "Both",
                    route = "Mate Bears e Chimeras nas montanhas.",
                    mobs = "Timbermaw Furbolgs (no), Bears, Chimera",
                    tips = "Chimeras dão scales além de leather.",
                    levelRange = "45-55",
                },
            },
        },
        
        -- ==================== RUGGED LEATHER (260-300) ====================
        {
            skillRange = {260, 300},
            leather = "Rugged Leather, Rugged Hide",
            locations = {
                {
                    zone = "Winterspring",
                    faction = "Both",
                    route = "Mate Bears e Chimeras ao redor de Everlook.",
                    mobs = "Shardtooth Bears, Ice Thistle Yetis, Chimeras",
                    tips = "EXCELENTE para Rugged Leather! Também dá Thick ocasionalmente.",
                    levelRange = "55-60",
                },
                {
                    zone = "Silithus",
                    faction = "Both",
                    route = "Mate Worms e Scorpids na areia.",
                    mobs = "Rock Stalkers, Dredge Strikers, Scorpids",
                    tips = "Worms são fáceis de farmar em grupo.",
                    levelRange = "55-60",
                },
                {
                    zone = "Western Plaguelands",
                    faction = "Both",
                    route = "Mate Bears e Wolves na área ao redor de Chillwind Camp.",
                    mobs = "Diseased Wolves, Plague Bears",
                    tips = "Mobs dão menos leather por ser undead zone.",
                    levelRange = "50-58",
                },
                {
                    zone = "Eastern Plaguelands",
                    faction = "Both",
                    route = "Mate Plaguehounds e Bats na área.",
                    mobs = "Plaguehounds, Monstrous Plaguebats",
                    tips = "Alternativa se Winterspring estiver cheio.",
                    levelRange = "53-60",
                },
                {
                    zone = "Burning Steppes",
                    faction = "Both",
                    route = "Mate Worgs e Dragonkin nas montanhas.",
                    mobs = "Firegut Ogres (no), Worgs, Black Dragonkin",
                    tips = "Dragonkin dão scales. Bom para variety.",
                    levelRange = "50-58",
                },
            },
        },
        
        -- ==================== KNOTHIDE LEATHER (300-350) ====================
        {
            skillRange = {300, 350},
            leather = "Knothide Leather Scraps, Knothide Leather",
            locations = {
                {
                    zone = "Nagrand",
                    faction = "Both",
                    route = "Mate Talbuks e Clefthoofs por toda a zona.",
                    mobs = "Talbuks, Clefthoofs, Elekk",
                    tips = "MELHOR zona para Knothide! Clefthoofs dão muito leather.",
                    levelRange = "64-67",
                },
                {
                    zone = "Hellfire Peninsula",
                    faction = "Both",
                    route = "Mate Ravagers e Helboars ao redor de Honor Hold/Thrallmar.",
                    mobs = "Ravagers, Helboars, Quillfang",
                    tips = "Primeira zona de TBC. Bom para começar.",
                    levelRange = "58-63",
                },
                {
                    zone = "Terokkar Forest",
                    faction = "Both",
                    route = "Mate Warp Stalkers e Wolves na floresta.",
                    mobs = "Warp Stalkers, Timber Worg",
                    tips = "Boa densidade de mobs skinnable.",
                    levelRange = "62-65",
                },
                {
                    zone = "Blade's Edge Mountains",
                    faction = "Both",
                    route = "Mate Raptors e Boars nas áreas baixas.",
                    mobs = "Bloodmaul Dire Wolves, Raptors",
                    tips = "Alternativa a Nagrand. Menos competição.",
                    levelRange = "65-68",
                },
            },
        },
        
        -- ==================== HEAVY KNOTHIDE / SPECIAL LEATHER (350-375) ====================
        {
            skillRange = {350, 375},
            leather = "Heavy Knothide Leather, Nether Dragonscales, Cobra Scales",
            locations = {
                {
                    zone = "Nagrand",
                    faction = "Both",
                    route = "Continue matando Clefthoofs. Cada Knothide vira Heavy com craft.",
                    mobs = "Elite Clefthoofs, Bulls",
                    tips = "Os mobs elite dão mais leather por kill.",
                    levelRange = "64-67",
                },
                {
                    zone = "Shadowmoon Valley",
                    faction = "Both",
                    route = "Mate Nether Drakes e Demons para special leather.",
                    mobs = "Netherwing Dragons, Eclipsion Dragonhawks",
                    tips = "ÚNICA fonte de Nether Dragonscales! Necessário 350+ skill.",
                    levelRange = "67-70",
                },
                {
                    zone = "Coilfang Reservoir (Dungeons)",
                    faction = "Both",
                    route = "Mate Cobras nas dungeons de Coilfang.",
                    mobs = "Coilfang Serpents",
                    tips = "ÚNICA fonte de Cobra Scales! Farme em grupo.",
                    levelRange = "62-70 (Dungeon)",
                },
                {
                    zone = "Netherstorm",
                    faction = "Both",
                    route = "Mate Nether Rays e mobs skinnable.",
                    mobs = "Nether Rays, Warp Hunters",
                    tips = "Alternativa para farm high-level.",
                    levelRange = "67-70",
                },
            },
        },
    },
    
    -- Leveling guide
    levelingGuide = {
        {
            range = {1, 75},
            tip = "Mate mobs de nível 1-15. Barrens (Horde) ou Westfall/Loch Modan (Alliance) são ideais para Light Leather.",
        },
        {
            range = {75, 150},
            tip = "Mate mobs de nível 15-30. Hillsbrad Foothills é excelente para Medium Leather.",
        },
        {
            range = {150, 205},
            tip = "Mate mobs de nível 30-40. Stranglethorn Vale é a MELHOR zona para Heavy Leather.",
        },
        {
            range = {205, 260},
            tip = "Mate mobs de nível 40-52. Un'Goro Crater (dinosaurs) é incrível para Thick Leather.",
        },
        {
            range = {260, 300},
            tip = "Mate mobs de nível 52-60. Winterspring é a melhor zona para Rugged Leather.",
        },
        {
            range = {300, 350},
            tip = "Mate mobs em Outland. Nagrand (Talbuks/Clefthoofs) é a MELHOR zona para Knothide Leather.",
        },
        {
            range = {350, 375},
            tip = "Continue em Nagrand ou vá para Shadowmoon Valley para Nether Dragonscales.",
        },
    },
}
