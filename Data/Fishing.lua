-- Profession Helper - Fishing Data (Gathering/Secondary Profession)
ProfessionHelper = ProfessionHelper or {}
ProfessionHelper.Fishing = {
    name = "Fishing",
    type = "gathering",
    secondary = true,
    
    trainer = {
        ["Alliance"] = {
            "Arnold Leland (Stormwind)",
            "Grimnur Stonebrand (Ironforge)",
            "Astaia (Darnassus)",
            "Juno Dufrain (Shattrath)",
        },
        ["Horde"] = {
            "Lumak (Orgrimmar)",
            "Armand Cromwell (Undercity)",
            "Kah Mistrunner (Thunder Bluff)",
            "Juno Dufrain (Shattrath)",
        },
    },
    
    -- Fishing skill requirements by zone
    zoneRequirements = {
        { zone = "Starting Zones", minSkill = 1, noGetaway = 25, recommended = 50 },
        { zone = "Level 10-20 Zones", minSkill = 1, noGetaway = 75, recommended = 100 },
        { zone = "Level 20-30 Zones", minSkill = 50, noGetaway = 150, recommended = 175 },
        { zone = "Level 30-40 Zones", minSkill = 130, noGetaway = 225, recommended = 250 },
        { zone = "Level 40-50 Zones", minSkill = 205, noGetaway = 300, recommended = 330 },
        { zone = "Level 50-60 Zones", minSkill = 280, noGetaway = 330, recommended = 380 },
        -- TBC
        { zone = "Outland Zones", minSkill = 305, noGetaway = 395, recommended = 430 },
        { zone = "Highland Mixed School", minSkill = 355, noGetaway = 450, recommended = 480 },
    },
    
    farmingLocations = {
        -- ==================== 1-75 APPRENTICE ====================
        {
            skillRange = {1, 75},
            fishTypes = "Raw Brilliant Smallfish, Raw Longjaw Mud Snapper",
            locations = {
                {
                    zone = "Any Starting Zone",
                    faction = "Both",
                    spot = "Qualquer corpo de água na zona inicial",
                    tips = "Não importa onde você pesca em skill baixo. Foque em subir o mais rápido possível.",
                    recommended = "Lago perto de treinador para convenience",
                },
                {
                    zone = "Orgrimmar/Stormwind",
                    faction = "Respective",
                    spot = "Lagos dentro da cidade capital",
                    tips = "Pode pescar AFK em segurança. Bom para upar enquanto faz outras coisas.",
                    recommended = "Valley of Honor (Org) ou Canals (SW)",
                },
            },
        },
        
        -- ==================== 75-150 JOURNEYMAN ====================
        {
            skillRange = {75, 150},
            fishTypes = "Raw Bristle Whisker Catfish, Raw Rockscale Cod",
            locations = {
                {
                    zone = "The Barrens",
                    faction = "Horde",
                    spot = "Oases (Forgotten Pools, Lushwater Oasis, Stagnant Oasis)",
                    tips = "Os oasis têm peixes únicos. Bom para skill e cooking materials.",
                    recommended = "Forgotten Pools perto de Crossroads",
                },
                {
                    zone = "Wetlands",
                    faction = "Alliance",
                    spot = "Costa perto de Menethil Harbor",
                    tips = "Pode pegar Oil Blackmouth aqui também (valioso).",
                    recommended = "Pesca na costa para variety",
                },
                {
                    zone = "Hillsbrad Foothills",
                    faction = "Both",
                    spot = "Rio que corta a zona ou costa de Southshore",
                    tips = "Oily Blackmouth e Firefin Snapper na costa.",
                    recommended = "Costa para peixes de Alchemy",
                },
                {
                    zone = "Stranglethorn Vale",
                    faction = "Both",
                    spot = "Costa ou rios internos",
                    tips = "Firefin Snapper abundante. Cuidado com PvP.",
                    recommended = "Comece aqui para skill 100+",
                },
            },
        },
        
        -- ==================== 150-225 EXPERT ====================
        {
            skillRange = {150, 225},
            fishTypes = "Raw Bristle Whisker Catfish, Raw Mithril Head Trout, Firefin Snapper",
            locations = {
                {
                    zone = "Dustwallow Marsh",
                    faction = "Both",
                    spot = "Rios e costa perto de Theramore/Brackenwall",
                    tips = "RECOMENDADO: a quest de Artisan Fishing (Nat Pagle) começa aqui! Pesque até 225 para já estar no lugar certo.",
                    recommended = "Melhor zona — fique aqui para a quest de Artisan",
                },
                {
                    zone = "Stranglethorn Vale",
                    faction = "Both",
                    spot = "Rios internos e costa de Booty Bay",
                    tips = "Compre Expert Fishing - The Bass and You de Old Man Heming em Booty Bay. Também compre Bright Baubles dele.",
                    recommended = "Passe por Booty Bay para livro + lures",
                },
                {
                    zone = "Arathi Highlands",
                    faction = "Both",
                    spot = "Lagos e rios",
                    tips = "Zona tranquila para pescar. Boa alternativa.",
                    recommended = "Alternativa se não quiser ir a Dustwallow",
                },
                {
                    zone = "Desolace",
                    faction = "Both",
                    spot = "Costa e rios internos",
                    tips = "Uma das zonas da quest Nat Pagle (Sar'theris Striker).",
                    recommended = "Combine com quest de Artisan",
                },
                {
                    zone = "Alterac Mountains / Swamp of Sorrows",
                    faction = "Both",
                    spot = "Lagos e rios",
                    tips = "Outras alternativas válidas para esta faixa de skill.",
                    recommended = "Zonas secundárias",
                },
            },
        },
        
        -- ==================== 225-300 ARTISAN ====================
        {
            skillRange = {225, 300},
            fishTypes = "Raw Nightfin Snapper, Raw Sunscale Salmon, Large Raw Mightfish, Raw Whitescale Salmon",
            locations = {
                {
                    zone = "Felwood",
                    faction = "Both",
                    spot = "Qualquer corpo de água",
                    tips = "Raw Nightfin Snapper só pesca à NOITE (18:00-06:00). Use Bright Baubles!",
                    recommended = "Nightfin para Nightfin Soup (restore mana)",
                },
                {
                    zone = "Feralas",
                    faction = "Both",
                    spot = "Costa e lagos (exceto Jademir Lake)",
                    tips = "Raw Redgill e Stonescale Eel. Evite Jademir Lake (requer skill mais alto). Sar'theris Striker para quest de Artisan.",
                    recommended = "Costa para peixes valiosos",
                },
                {
                    zone = "The Hinterlands",
                    faction = "Both",
                    spot = "Lagos internos",
                    tips = "Mithril Head Trout para cooking. Zona tranquila e segura.",
                    recommended = "Boa para farm pacífico",
                },
                {
                    zone = "Tanaris",
                    faction = "Both",
                    spot = "Costa leste",
                    tips = "Steamvault Pools aparecem aleatoriamente. Stonescale Eel valioso! Use Bright Baubles.",
                    recommended = "Costa para consistent fishing",
                },
                {
                    zone = "Un'Goro Crater",
                    faction = "Both",
                    spot = "Rio central",
                    tips = "Raw Nightfin Snapper à noite, Raw Sunscale Salmon de dia.",
                    recommended = "Alternativa se Felwood estiver cheio",
                },
                {
                    zone = "Western Plaguelands",
                    faction = "Both",
                    spot = "Lagos ao redor de Caer Darrow",
                    tips = "Raw Sunscale Salmon só pesca de DIA (06:00-18:00). Use Bright Baubles!",
                    recommended = "Sunscale para Poached Sunscale Salmon (restore health)",
                },
            },
        },
        
        -- ==================== 300-350 MASTER (TBC) ====================
        {
            skillRange = {300, 350},
            fishTypes = "Spotted Feltail, Zangarian Sporefish, Barbed Gill Trout",
            locations = {
                {
                    zone = "Zangarmarsh",
                    faction = "Both",
                    spot = "Lagos ao redor de Coilfang Reservoir e Cenarion Refuge",
                    tips = "MELHOR zona para começar TBC fishing! Precisa ~400 effective fishing (com pole + lure) para não perder peixes.",
                    recommended = "Foque em Sporefish pools para skill rápido",
                    fish = {
                        "Zangarian Sporefish - cozinha em Blackened Sporefish (stamina)",
                        "Spotted Feltail - comum, bom para skill",
                        "Barbed Gill Trout - cozinha em várias receitas",
                    },
                },
            },
        },
        
        -- ==================== 350-375 MASTER (TBC) ====================
        {
            skillRange = {350, 375},
            fishTypes = "Golden Darter, Figluster's Mudfish, Furious Crawdad, Spotted Feltail",
            locations = {
                {
                    zone = "Terokkar Forest",
                    faction = "Both",
                    spot = "Lagos e rios nas áreas marcadas (evite áreas de voo restrito e lago perto de Shattrath)",
                    tips = "Peixes mais valiosos que Zangarmarsh. Evite lagos perto de Shattrath (requer skill muito alto)!",
                    recommended = "Troque para Terokkar a partir de 350 para peixes melhores",
                    fish = {
                        "Golden Darter - Golden Fish Sticks (+44 healing)",
                        "Spotted Feltail - comum",
                    },
                },
                {
                    zone = "Nagrand",
                    faction = "Both",
                    spot = "Lagos ao redor de toda a zona",
                    tips = "Figluster's Mudfish aqui - cozinha em Grilled Mudfish (+20 agi).",
                    recommended = "Lagos no centro da zona",
                    fish = {
                        "Figluster's Mudfish - Grilled Mudfish (+20 agility)",
                        "Icefin Bluefish - pescável em lagos puros",
                    },
                },
                {
                    zone = "Terokkar Forest - Highland Mixed Schools",
                    faction = "Both",
                    spot = "Lagos elevados no norte de Terokkar, perto de Allerian Stronghold",
                    tips = "Highland Mixed Schools contêm TODOS os peixes raros de TBC incluindo Furious Crawdad!",
                    recommended = "Única fonte de Furious Crawdad (Spicy Crawdad = +30 Stam)",
                    fish = {
                        "Furious Crawdad - Spicy Crawdad (+30 stamina) - MUITO VALIOSO",
                        "Golden Darter",
                        "Huge Spotted Feltail",
                    },
                },
            },
        },
    },
    
    -- Special fishing items and events
    specialItems = {
        {
            name = "Stranglethorn Fishing Extravaganza",
            location = "Stranglethorn Vale",
            time = "Domingos às 14:00 server time",
            rewards = "Arcanite Fishing Pole, Hook of the Master Angler, +35 Fishing skill boots",
            tips = "Evento semanal de pesca! Primeiro a pegar 40 Speckled Tastyfish ganha prêmio especial.",
        },
        {
            name = "Mr. Pinchy",
            location = "Highland Mixed Schools (Terokkar Forest)",
            tips = "Chance de pescar Mr. Pinchy que dá 3 wishes! Pode dropar epic Magical Crawdad pet!",
        },
        {
            name = "Weather-Beaten Journal",
            location = "Pode ser encontrado em qualquer crate pescado",
            tips = "Ensina Find Fish - tracking para pools de peixes no minimap!",
        },
    },
    
    -- Fishing gear
    equipment = {
        { name = "Strong Fishing Pole", bonus = "+5 Fishing", source = "Vendor" },
        { name = "Big Iron Fishing Pole", bonus = "+20 Fishing", source = "Shellfish Trap (Desolace)" },
        { name = "Seth's Graphite Fishing Pole", bonus = "+20 Fishing", source = "Quest: Rather Be Fishin' (Terokkar)" },
        { name = "Nat Pagle's Extreme Angler FC-5000", bonus = "+25 Fishing", source = "Quest: Nat Pagle, Angler Extreme" },
        { name = "Arcanite Fishing Pole", bonus = "+35 Fishing", source = "Stranglethorn Fishing Extravaganza" },
        { name = "Aquadynamic Fish Attractor", bonus = "+100 Fishing (lure)", source = "Crafted (Engineering)" },
        { name = "Sharpened Fish Hook", bonus = "+100 Fishing (lure)", source = "Quest reward (TBC)" },
        { name = "Bright Baubles", bonus = "+75 Fishing (lure)", source = "Vendor/Crafted" },
        { name = "Nightcrawlers", bonus = "+50 Fishing (lure)", source = "Vendor" },
        { name = "Lucky Fishing Hat", bonus = "+5 Fishing", source = "Rare Fish Extravaganza reward" },
        { name = "Nat Pagle's Extreme Anglin' Boots", bonus = "+5 Fishing", source = "Rare Fish Extravaganza reward" },
    },
    
    -- Leveling guide
    levelingGuide = {
        {
            range = {1, 75},
            tip = "Pesque em qualquer zona inicial ou cidade capital. Compre Fishing Pole + Shiny Baubles de um vendor de pesca.",
        },
        {
            range = {75, 150},
            tip = "Aprenda Journeyman Fishing no treinador. Pesque em cidades capitais (Darnassus, SW, Org, UC, TB) ou zonas como Barrens, Darkshore, Westfall, Loch Modan.",
        },
        {
            range = {150, 225},
            tip = "Compre Expert Fishing (livro) de Old Man Heming em Booty Bay + Bright Baubles. Pesque em Dustwallow Marsh (recomendado — quest de Artisan começa lá!).",
        },
        {
            range = {225, 300},
            tip = "Complete Nat Pagle, Angler Extreme em Dustwallow Marsh (requer lvl 35 + Fishing 225). Depois pesque em Felwood, Feralas, Hinterlands, Tanaris, Un'Goro ou WPL. Use Bright Baubles!",
        },
        {
            range = {300, 350},
            tip = "Compre Master Fishing de Juno Dufrain em Zangarmarsh. Pesque em Zangarmarsh. Precisa ~400 effective fishing (pole+lure). Use Seth's Graphite Pole (+20) ou Nat Pagle's (+25).",
        },
        {
            range = {350, 375},
            tip = "Troque para Terokkar Forest para peixes mais valiosos. Evite áreas de voo restrito e o lago perto de Shattrath (skill muito alto). Pode ficar em Zangarmarsh se preferir.",
        },
    },
    
    -- Tips
    tips = {
        "SINERGIA COM COOKING: peixes pescados servem como materiais de Cooking! Upe as duas juntas para máxima eficiência.",
        "Sempre use a melhor isca disponível - aumenta muito a chance de pegar peixes em vez de lixo.",
        "Schools (pools de peixes específicos) garantem um tipo de peixe e são muito mais eficientes.",
        "Aprenda Find Fish do Weather-Beaten Journal para ver pools no minimap!",
        "Compre o livro Expert Fishing de Old Man Heming em Booty Bay (+ Bright Baubles).",
        "Quest de Artisan Fishing (Nat Pagle, Angler Extreme) requer lvl 35 e Fishing 225 — começa em Dustwallow Marsh.",
        "Para TBC, compre Master Fishing de Juno Dufrain em Zangarmarsh. Precisa de pole com +20 fishing ou mais.",
        "Participe do Stranglethorn Fishing Extravaganza aos domingos às 14:00 server time.",
        "Alguns peixes só aparecem de dia (Sunscale) ou de noite (Nightfin) - verifique o horário!",
        "Mr. Pinchy em Highland Mixed Schools (Terokkar) pode dropar um pet épico - vale a pena farmar!",
    },
}
