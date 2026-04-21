-- Profession Helper - Mining Data (Gathering Profession)
ProfessionHelper = ProfessionHelper or {}
ProfessionHelper.Mining = {
    name = "Mining",
    type = "gathering",
    
    trainer = {
        ["Alliance"] = {
            "Gelman Stonehand (Stormwind)",
            "Geofram Bouldertoe (Ironforge)",
            "Matt Johnson (Darnassus)",
            "Hurnak Grimmord (Shattrath)",
        },
        ["Horde"] = {
            "Makaru (Orgrimmar)",
            "Brom Killian (Undercity)",
            "Brek Stonehoof (Thunder Bluff)",
            "Hurnak Grimmord (Shattrath)",
        },
    },
    
    skillRanges = {
        {
            ore = "Copper Ore",
            skillRequired = 1,
            skillYellow = 25,
            skillGreen = 50,
            skillGrey = 100,
        },
        {
            ore = "Tin Ore",
            skillRequired = 65,
            skillYellow = 90,
            skillGreen = 115,
            skillGrey = 165,
        },
        {
            ore = "Silver Ore",
            skillRequired = 75,
            skillYellow = 100,
            skillGreen = 125,
            skillGrey = 175,
        },
        {
            ore = "Iron Ore",
            skillRequired = 125,
            skillYellow = 150,
            skillGreen = 175,
            skillGrey = 225,
        },
        {
            ore = "Gold Ore",
            skillRequired = 155,
            skillYellow = 180,
            skillGreen = 205,
            skillGrey = 255,
        },
        {
            ore = "Mithril Ore",
            skillRequired = 175,
            skillYellow = 200,
            skillGreen = 225,
            skillGrey = 275,
        },
        {
            ore = "Truesilver Ore",
            skillRequired = 230,
            skillYellow = 255,
            skillGreen = 280,
            skillGrey = 330,
        },
        {
            ore = "Thorium Ore",
            skillRequired = 245,
            skillYellow = 270,
            skillGreen = 295,
            skillGrey = 345,
        },
        {
            ore = "Rich Thorium Ore",
            skillRequired = 275,
            skillYellow = 300,
            skillGreen = 325,
            skillGrey = 375,
        },
        -- TBC Ores
        {
            ore = "Fel Iron Ore",
            skillRequired = 300,
            skillYellow = 325,
            skillGreen = 350,
            skillGrey = 400,
        },
        {
            ore = "Adamantite Ore",
            skillRequired = 325,
            skillYellow = 350,
            skillGreen = 375,
            skillGrey = 400,
        },
        {
            ore = "Rich Adamantite Ore",
            skillRequired = 350,
            skillYellow = 375,
            skillGreen = 400,
            skillGrey = 425,
        },
        {
            ore = "Khorium Ore",
            skillRequired = 375,
            skillYellow = 400,
            skillGreen = 425,
            skillGrey = 450,
        },
    },
    
    farmingLocations = {
        -- ==================== COPPER (1-65) ====================
        {
            skillRange = {1, 65},
            ore = "Copper Ore",
            locations = {
                {
                    zone = "Durotar",
                    faction = "Horde",
                    route = "Circule a costa leste de Durotar, partindo de Orgrimmar para o sul até Sen'jin Village, depois suba pela costa até Skull Rock.",
                    tips = "Muitos nodos perto das montanhas e cavernas. Cave também nas cavernas para extras.",
                    levelRange = "1-10",
                },
                {
                    zone = "Elwynn Forest",
                    faction = "Alliance",
                    route = "Faça um círculo ao redor de Goldshire, passando pelas minas de Fargodeep e Jasperlode.",
                    tips = "As minas têm muitos nodos concentrados. Bom para farm rápido.",
                    levelRange = "1-10",
                },
                {
                    zone = "Tirisfal Glades",
                    faction = "Horde",
                    route = "Circule as montanhas ao redor de Brill e siga até Scarlet Monastery.",
                    tips = "Menos competição que outras zonas iniciais.",
                    levelRange = "1-10",
                },
                {
                    zone = "Dun Morogh",
                    faction = "Alliance",
                    route = "Comece em Coldridge Valley, depois circule Anvilmar e siga para Kharanos.",
                    tips = "Zona montanhosa com muitos nodos. Aproveite as cavernas dos troggs.",
                    levelRange = "1-10",
                },
                {
                    zone = "Mulgore",
                    faction = "Horde",
                    route = "Circule as montanhas ao redor de Thunder Bluff e Bloodhoof Village.",
                    tips = "Zona tranquila com bons nodos nas bordas do mapa.",
                    levelRange = "1-10",
                },
            },
        },
        
        -- ==================== TIN (65-125) ====================
        {
            skillRange = {65, 125},
            ore = "Tin Ore",
            locations = {
                {
                    zone = "The Barrens",
                    faction = "Horde",
                    route = "Faça um grande círculo partindo de Crossroads, passando por Ratchet, subindo pela costa até Camp Taurajo.",
                    tips = "Zona grande mas com muitos nodos. Também encontrará Silver Ore ocasionalmente.",
                    levelRange = "10-25",
                },
                {
                    zone = "Westfall",
                    faction = "Alliance",
                    route = "Circule a zona inteira, focando nas áreas montanhosas ao norte perto de Elwynn e ao sul perto de Duskwood.",
                    tips = "Os nodos aparecem principalmente nas bordas da zona.",
                    levelRange = "10-20",
                },
                {
                    zone = "Redridge Mountains",
                    faction = "Alliance",
                    route = "Comece em Lakeshire e circule as montanhas ao redor do lago Everstill.",
                    tips = "Zona compacta com alta densidade de nodos. Também bom para Silver.",
                    levelRange = "15-25",
                },
                {
                    zone = "Silverpine Forest",
                    faction = "Horde",
                    route = "Siga a linha das montanhas do norte ao sul da zona.",
                    tips = "Bom para Horde que está upando. Menos disputado.",
                    levelRange = "10-20",
                },
                {
                    zone = "Darkshore",
                    faction = "Alliance",
                    route = "Siga a costa de Auberdine para o sul, depois volte pelas montanhas ao leste.",
                    tips = "Longa zona costeira com nodos esparsos mas consistentes.",
                    levelRange = "10-20",
                },
            },
        },
        
        -- ==================== IRON (125-175) ====================
        {
            skillRange = {125, 175},
            ore = "Iron Ore",
            locations = {
                {
                    zone = "Arathi Highlands",
                    faction = "Both",
                    route = "Grande círculo partindo de Refuge Pointe/Hammerfall, passando por Circle of West/East Binding, depois ao redor de Stromgarde.",
                    tips = "MELHOR zona para Iron! Alta densidade e também Gold ocasional.",
                    levelRange = "30-40",
                },
                {
                    zone = "Desolace",
                    faction = "Both",
                    route = "Circule as montanhas ao redor de Kodo Graveyard e depois suba para o Vale do Magram.",
                    tips = "Menos disputado que Arathi. Bom para Mithril também quando subir skill.",
                    levelRange = "30-40",
                },
                {
                    zone = "Stranglethorn Vale",
                    faction = "Both",
                    route = "Foco nas cavernas e montanhas do norte (perto de Nesingwary) e do centro da zona.",
                    tips = "Cuidado com PvP. Muita competição mas alta densidade.",
                    levelRange = "30-45",
                },
                {
                    zone = "Alterac Mountains",
                    faction = "Both",
                    route = "Circule as ruínas de Alterac e as montanhas ao redor de Strahnbrad.",
                    tips = "Zona menos populada. Bom para farm tranquilo.",
                    levelRange = "30-40",
                },
                {
                    zone = "Badlands",
                    faction = "Both",
                    route = "Grande círculo passando por todas as montanhas da zona.",
                    tips = "Transição para Mithril. Muito Iron com alguns Mithril nodes.",
                    levelRange = "35-45",
                },
            },
        },
        
        -- ==================== MITHRIL (175-245) ====================
        {
            skillRange = {175, 245},
            ore = "Mithril Ore",
            locations = {
                {
                    zone = "Badlands",
                    faction = "Both",
                    route = "Circule toda a zona, especialmente perto de Uldaman e Camp Boff/Cagg.",
                    tips = "Melhor zona para começar Mithril. Também Truesilver ocasional.",
                    levelRange = "35-45",
                },
                {
                    zone = "Tanaris",
                    faction = "Both",
                    route = "Grande círculo ao redor de Gadgetzan, passando pelas montanhas no sul e leste.",
                    tips = "EXCELENTE zona! Muitos nodos e também prepara para Thorium.",
                    levelRange = "40-50",
                },
                {
                    zone = "The Hinterlands",
                    faction = "Both",
                    route = "Circule a zona inteira, focando nas montanhas ao norte e leste.",
                    tips = "Boa densidade de Mithril e Truesilver. Menos disputado.",
                    levelRange = "40-50",
                },
                {
                    zone = "Searing Gorge",
                    faction = "Both",
                    route = "Circule as bordas da zona e passe pelas cavernas.",
                    tips = "Transição para Thorium. Muito Mithril com Thorium começando a aparecer.",
                    levelRange = "43-50",
                },
                {
                    zone = "Felwood",
                    faction = "Both",
                    route = "Siga as montanhas do norte ao sul da zona.",
                    tips = "Bom para combinar com Herbalism (muitas herbs aqui também).",
                    levelRange = "48-55",
                },
            },
        },
        
        -- ==================== THORIUM (245-300) ====================
        {
            skillRange = {245, 300},
            ore = "Thorium Ore",
            locations = {
                {
                    zone = "Un'Goro Crater",
                    faction = "Both",
                    route = "Circule toda a borda da cratera, dentro das montanhas.",
                    tips = "MELHOR zona para Thorium! Nodos respawnam rápido. Faça o círculo completo.",
                    levelRange = "48-55",
                },
                {
                    zone = "Winterspring",
                    faction = "Both",
                    route = "Grande círculo passando por Everlook, montanhas do leste e sul.",
                    tips = "Rich Thorium nodes frequentes. Bom para skill alto.",
                    levelRange = "55-60",
                },
                {
                    zone = "Eastern Plaguelands",
                    faction = "Both",
                    route = "Circule as montanhas do norte e leste da zona.",
                    tips = "Muitos Rich Thorium. Cuidado com mobs elites.",
                    levelRange = "53-60",
                },
                {
                    zone = "Silithus",
                    faction = "Both",
                    route = "Circule as montanhas ao redor de Cenarion Hold.",
                    tips = "Excelente para Rich Thorium. Também bom para Arcane Crystals.",
                    levelRange = "55-60",
                },
                {
                    zone = "Burning Steppes",
                    faction = "Both",
                    route = "Circule as montanhas e passe pelas cavernas (muitos nodos dentro).",
                    tips = "Bom mix de Thorium regular e Rich.",
                    levelRange = "50-58",
                },
            },
        },
        
        -- ==================== FEL IRON (300-325) ====================
        {
            skillRange = {300, 325},
            ore = "Fel Iron Ore",
            locations = {
                {
                    zone = "Hellfire Peninsula",
                    faction = "Both",
                    route = "Grande círculo partindo de Honor Hold/Thrallmar, passando pelas montanhas do norte e sul.",
                    tips = "MELHOR zona para começar TBC mining! Alta densidade de Fel Iron.",
                    levelRange = "58-63",
                },
                {
                    zone = "Zangarmarsh",
                    faction = "Both",
                    route = "Circule as bordas da zona, especialmente perto de Coilfang Reservoir.",
                    tips = "Menos disputado que Hellfire. Bom para combinar com Herbalism.",
                    levelRange = "60-64",
                },
                {
                    zone = "Terokkar Forest",
                    faction = "Both",
                    route = "Foco nas montanhas ao redor de Shattrath e Auchindoun.",
                    tips = "Misto de Fel Iron e Adamantite. Boa zona de transição.",
                    levelRange = "62-65",
                },
            },
        },
        
        -- ==================== ADAMANTITE (325-375) ====================
        {
            skillRange = {325, 375},
            ore = "Adamantite Ore",
            locations = {
                {
                    zone = "Nagrand",
                    faction = "Both",
                    route = "Grande círculo ao redor de toda a zona, focando nas montanhas.",
                    tips = "MELHOR zona para Adamantite! Muitos nodos e área aberta fácil de circular.",
                    levelRange = "64-67",
                },
                {
                    zone = "Blade's Edge Mountains",
                    faction = "Both",
                    route = "Circule as montanhas ao redor de Sylvanaar/Thunderlord e depois para o norte.",
                    tips = "Alta densidade mas terreno difícil. Khorium ocasional.",
                    levelRange = "65-68",
                },
                {
                    zone = "Netherstorm",
                    faction = "Both",
                    route = "Circule as bordas das ilhas e passe pelos eco-domes.",
                    tips = "Excelente para Rich Adamantite e Khorium. Zona de endgame.",
                    levelRange = "67-70",
                },
                {
                    zone = "Shadowmoon Valley",
                    faction = "Both",
                    route = "Circule as montanhas do norte e oeste da zona.",
                    tips = "Muitos nodos mas mobs perigosos. Khorium frequente.",
                    levelRange = "67-70",
                },
            },
        },
    },
    
    -- Smelting recipes for leveling
    smelting = {
        { name = "Smelt Copper", skill = 1, materials = {{ name = "Copper Ore", count = 1 }} },
        { name = "Smelt Tin", skill = 65, materials = {{ name = "Tin Ore", count = 1 }} },
        { name = "Smelt Bronze", skill = 65, materials = {{ name = "Copper Bar", count = 1 }, { name = "Tin Bar", count = 1 }} },
        { name = "Smelt Silver", skill = 75, materials = {{ name = "Silver Ore", count = 1 }} },
        { name = "Smelt Iron", skill = 125, materials = {{ name = "Iron Ore", count = 1 }} },
        { name = "Smelt Gold", skill = 155, materials = {{ name = "Gold Ore", count = 1 }} },
        { name = "Smelt Steel", skill = 165, materials = {{ name = "Iron Bar", count = 1 }, { name = "Coal", count = 1 }} },
        { name = "Smelt Mithril", skill = 175, materials = {{ name = "Mithril Ore", count = 1 }} },
        { name = "Smelt Truesilver", skill = 230, materials = {{ name = "Truesilver Ore", count = 1 }} },
        { name = "Smelt Thorium", skill = 250, materials = {{ name = "Thorium Ore", count = 1 }} },
        { name = "Smelt Fel Iron", skill = 300, materials = {{ name = "Fel Iron Ore", count = 1 }} },
        { name = "Smelt Adamantite", skill = 325, materials = {{ name = "Adamantite Ore", count = 1 }} },
        { name = "Smelt Eternium", skill = 350, materials = {{ name = "Eternium Ore", count = 1 }} },
        { name = "Smelt Felsteel", skill = 355, materials = {{ name = "Fel Iron Bar", count = 3 }, { name = "Eternium Bar", count = 2 }} },
        { name = "Smelt Khorium", skill = 375, materials = {{ name = "Khorium Ore", count = 1 }} },
    },
    
    -- Leveling guide
    levelingGuide = {
        {
            range = {1, 65},
            tip = "Mine Copper Ore em qualquer zona inicial (Durotar, Elwynn Forest, Dun Morogh, Tirisfal Glades, Mulgore, Teldrassil).",
        },
        {
            range = {65, 125},
            tip = "Mine Tin Ore em Barrens, Westfall, Redridge Mountains, ou Silverpine Forest. Smelt Bronze para skill extra.",
        },
        {
            range = {125, 175},
            tip = "Mine Iron Ore em Arathi Highlands (MELHOR), Desolace, ou Stranglethorn Vale.",
        },
        {
            range = {175, 245},
            tip = "Mine Mithril Ore em Tanaris, Badlands, ou The Hinterlands. Smelt Steel e Mithril para skill extra.",
        },
        {
            range = {245, 300},
            tip = "Mine Thorium em Un'Goro Crater (MELHOR), Winterspring, ou Silithus. Rich Thorium dá mais skill.",
        },
        {
            range = {300, 325},
            tip = "Mine Fel Iron em Hellfire Peninsula. Esta zona tem a melhor densidade de Fel Iron em Outland.",
        },
        {
            range = {325, 375},
            tip = "Mine Adamantite em Nagrand (MELHOR) ou Blade's Edge Mountains. Rich Adamantite para skill final.",
        },
    },
}
