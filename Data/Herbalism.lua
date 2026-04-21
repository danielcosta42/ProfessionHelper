-- Profession Helper - Herbalism Data (Gathering Profession)
ProfessionHelper = ProfessionHelper or {}
ProfessionHelper.Herbalism = {
    name = "Herbalism",
    type = "gathering",
    
    trainer = {
        ["Alliance"] = {
            "Alma Jainrose (Elwynn Forest)",
            "Tannysa (Stormwind)",
            "Firodren Mooncaller (Darnassus)",
            "Rorelien (Shattrath)",
        },
        ["Horde"] = {
            "Komin Winterhoof (Thunder Bluff)",
            "Jandi (Orgrimmar)",
            "Martha Alliestar (Undercity)",
            "Rorelien (Shattrath)",
        },
    },
    
    skillRanges = {
        { herb = "Peacebloom", skillRequired = 1, skillYellow = 25, skillGreen = 50, skillGrey = 100 },
        { herb = "Silverleaf", skillRequired = 1, skillYellow = 25, skillGreen = 50, skillGrey = 100 },
        { herb = "Earthroot", skillRequired = 15, skillYellow = 40, skillGreen = 65, skillGrey = 115 },
        { herb = "Mageroyal", skillRequired = 50, skillYellow = 75, skillGreen = 100, skillGrey = 150 },
        { herb = "Briarthorn", skillRequired = 70, skillYellow = 95, skillGreen = 120, skillGrey = 170 },
        { herb = "Stranglekelp", skillRequired = 85, skillYellow = 110, skillGreen = 135, skillGrey = 185 },
        { herb = "Bruiseweed", skillRequired = 100, skillYellow = 125, skillGreen = 150, skillGrey = 200 },
        { herb = "Wild Steelbloom", skillRequired = 115, skillYellow = 140, skillGreen = 165, skillGrey = 215 },
        { herb = "Grave Moss", skillRequired = 120, skillYellow = 145, skillGreen = 170, skillGrey = 220 },
        { herb = "Kingsblood", skillRequired = 125, skillYellow = 150, skillGreen = 175, skillGrey = 225 },
        { herb = "Liferoot", skillRequired = 150, skillYellow = 175, skillGreen = 200, skillGrey = 250 },
        { herb = "Fadeleaf", skillRequired = 160, skillYellow = 185, skillGreen = 210, skillGrey = 260 },
        { herb = "Goldthorn", skillRequired = 170, skillYellow = 195, skillGreen = 220, skillGrey = 270 },
        { herb = "Khadgar's Whisker", skillRequired = 185, skillYellow = 210, skillGreen = 235, skillGrey = 285 },
        { herb = "Firebloom", skillRequired = 205, skillYellow = 230, skillGreen = 255, skillGrey = 305 },
        { herb = "Purple Lotus", skillRequired = 210, skillYellow = 235, skillGreen = 260, skillGrey = 310 },
        { herb = "Arthas' Tears", skillRequired = 220, skillYellow = 245, skillGreen = 270, skillGrey = 320 },
        { herb = "Sungrass", skillRequired = 230, skillYellow = 255, skillGreen = 280, skillGrey = 330 },
        { herb = "Blindweed", skillRequired = 235, skillYellow = 260, skillGreen = 285, skillGrey = 335 },
        { herb = "Ghost Mushroom", skillRequired = 245, skillYellow = 270, skillGreen = 295, skillGrey = 345 },
        { herb = "Gromsblood", skillRequired = 250, skillYellow = 275, skillGreen = 300, skillGrey = 350 },
        { herb = "Golden Sansam", skillRequired = 260, skillYellow = 285, skillGreen = 310, skillGrey = 360 },
        { herb = "Dreamfoil", skillRequired = 270, skillYellow = 295, skillGreen = 320, skillGrey = 370 },
        { herb = "Mountain Silversage", skillRequired = 280, skillYellow = 305, skillGreen = 330, skillGrey = 380 },
        { herb = "Plaguebloom", skillRequired = 285, skillYellow = 310, skillGreen = 335, skillGrey = 385 },
        { herb = "Icecap", skillRequired = 290, skillYellow = 315, skillGreen = 340, skillGrey = 390 },
        { herb = "Black Lotus", skillRequired = 300, skillYellow = 300, skillGreen = 300, skillGrey = 300 },
        -- TBC Herbs
        { herb = "Felweed", skillRequired = 300, skillYellow = 325, skillGreen = 350, skillGrey = 400 },
        { herb = "Dreaming Glory", skillRequired = 315, skillYellow = 340, skillGreen = 365, skillGrey = 415 },
        { herb = "Ragveil", skillRequired = 325, skillYellow = 350, skillGreen = 375, skillGrey = 425 },
        { herb = "Flame Cap", skillRequired = 335, skillYellow = 360, skillGreen = 385, skillGrey = 435 },
        { herb = "Terocone", skillRequired = 325, skillYellow = 350, skillGreen = 375, skillGrey = 425 },
        { herb = "Ancient Lichen", skillRequired = 340, skillYellow = 365, skillGreen = 390, skillGrey = 440 },
        { herb = "Netherbloom", skillRequired = 350, skillYellow = 375, skillGreen = 400, skillGrey = 450 },
        { herb = "Nightmare Vine", skillRequired = 365, skillYellow = 390, skillGreen = 415, skillGrey = 465 },
        { herb = "Mana Thistle", skillRequired = 375, skillYellow = 400, skillGreen = 425, skillGrey = 475 },
    },
    
    farmingLocations = {
        -- ==================== PEACEBLOOM/SILVERLEAF/EARTHROOT (1-70) ====================
        {
            skillRange = {1, 70},
            herb = "Peacebloom, Silverleaf, Earthroot",
            locations = {
                {
                    zone = "Tirisfal Glades",
                    faction = "Horde",
                    route = "Circule ao redor de Brill e siga para Deathknell. Muitas herbs perto dos campos e estradas.",
                    tips = "Excelente zona inicial para Horde. Peacebloom abundante.",
                    levelRange = "1-10",
                },
                {
                    zone = "Elwynn Forest",
                    faction = "Alliance",
                    route = "Grande círculo ao redor de Goldshire, passando por Northshire Valley e Stone Cairn Lake.",
                    tips = "Alta densidade perto dos lagos e na floresta.",
                    levelRange = "1-10",
                },
                {
                    zone = "Durotar",
                    faction = "Horde",
                    route = "Circule de Razor Hill até Sen'jin Village e de volta para Orgrimmar.",
                    tips = "Earthroot abundante nas montanhas. Silverleaf perto da água.",
                    levelRange = "1-10",
                },
                {
                    zone = "Mulgore",
                    faction = "Horde",
                    route = "Grande círculo ao redor de Bloodhoof Village e Thunder Bluff.",
                    tips = "Zona pacífica com bom spawn de todas as três herbs.",
                    levelRange = "1-10",
                },
                {
                    zone = "Teldrassil",
                    faction = "Alliance",
                    route = "Circule ao redor de Dolanaar e Shadowglen.",
                    tips = "Peacebloom muito comum. Boa zona para começar.",
                    levelRange = "1-10",
                },
            },
        },
        
        -- ==================== MAGEROYAL/BRIARTHORN (50-100) ====================
        {
            skillRange = {50, 100},
            herb = "Mageroyal, Briarthorn",
            locations = {
                {
                    zone = "The Barrens",
                    faction = "Horde",
                    route = "Grande círculo de Crossroads para o sul até Camp Taurajo, depois para Ratchet.",
                    tips = "MELHOR zona para Briarthorn! Mageroyal abundante também.",
                    levelRange = "10-25",
                },
                {
                    zone = "Westfall",
                    faction = "Alliance",
                    route = "Circule a zona inteira, focando nos campos e perto das fazendas.",
                    tips = "Bom para Mageroyal. Briarthorn nas bordas rochosas.",
                    levelRange = "10-20",
                },
                {
                    zone = "Silverpine Forest",
                    faction = "Horde",
                    route = "Siga a estrada de Undercity para o sul até Pyrewood Village.",
                    tips = "Briarthorn abundante. Menos competição que Barrens.",
                    levelRange = "10-20",
                },
                {
                    zone = "Darkshore",
                    faction = "Alliance",
                    route = "Siga a costa de Auberdine para o norte e sul, depois volte pela floresta.",
                    tips = "Mageroyal comum na floresta. Stranglekelp na costa.",
                    levelRange = "10-20",
                },
                {
                    zone = "Loch Modan",
                    faction = "Alliance",
                    route = "Circule o lago e as áreas montanhosas ao redor.",
                    tips = "Boa densidade de Briarthorn nas montanhas.",
                    levelRange = "10-20",
                },
            },
        },
        
        -- ==================== BRUISEWEED/WILD STEELBLOOM/KINGSBLOOD (100-150) ====================
        {
            skillRange = {100, 150},
            herb = "Bruiseweed, Wild Steelbloom, Kingsblood",
            locations = {
                {
                    zone = "Hillsbrad Foothills",
                    faction = "Both",
                    route = "Grande círculo passando por Tarren Mill/Southshore e as montanhas ao redor.",
                    tips = "EXCELENTE para Bruiseweed e Wild Steelbloom. Kingsblood começa a aparecer.",
                    levelRange = "20-30",
                },
                {
                    zone = "Stonetalon Mountains",
                    faction = "Both",
                    route = "Circule as montanhas ao redor de Stonetalon Peak e Sun Rock Retreat.",
                    tips = "Bom para Wild Steelbloom nas áreas rochosas.",
                    levelRange = "15-27",
                },
                {
                    zone = "Wetlands",
                    faction = "Alliance",
                    route = "Siga a costa e depois passe pelas áreas pantanosas ao redor de Menethil.",
                    tips = "Bruiseweed comum. Stranglekelp abundante na costa.",
                    levelRange = "20-30",
                },
                {
                    zone = "Ashenvale",
                    faction = "Both",
                    route = "Grande círculo passando por Astranaar/Splintertree Post e a floresta ao redor.",
                    tips = "Boa variedade de herbs. Prepare-se para PvP.",
                    levelRange = "18-30",
                },
            },
        },
        
        -- ==================== LIFEROOT/FADELEAF/GOLDTHORN (150-200) ====================
        {
            skillRange = {150, 200},
            herb = "Liferoot, Fadeleaf, Goldthorn, Khadgar's Whisker",
            locations = {
                {
                    zone = "Stranglethorn Vale",
                    faction = "Both",
                    route = "Grande círculo passando por toda a zona, focando nas áreas de selva.",
                    tips = "MELHOR zona para Fadeleaf e Goldthorn! Alta variedade de herbs.",
                    levelRange = "30-45",
                },
                {
                    zone = "Arathi Highlands",
                    faction = "Both",
                    route = "Circule as montanhas e passem pelos campos ao redor de Stromgarde.",
                    tips = "Liferoot perto da água. Fadeleaf nas ruínas.",
                    levelRange = "30-40",
                },
                {
                    zone = "Swamp of Sorrows",
                    faction = "Both",
                    route = "Circule o pântano, especialmente perto de Stonard e Pool of Tears.",
                    tips = "EXCELENTE para Liferoot! Goldthorn também comum.",
                    levelRange = "35-45",
                },
                {
                    zone = "The Hinterlands",
                    faction = "Both",
                    route = "Grande círculo passando por Aerie Peak/Revantusk Village e a floresta.",
                    tips = "Boa para Khadgar's Whisker e Goldthorn.",
                    levelRange = "40-50",
                },
                {
                    zone = "Feralas",
                    faction = "Both",
                    route = "Circule as bordas da floresta e passe pelo Camp Mojache/Feathermoon.",
                    tips = "Alta variedade. Goldthorn muito comum.",
                    levelRange = "40-50",
                },
            },
        },
        
        -- ==================== FIREBLOOM/PURPLE LOTUS/SUNGRASS (200-260) ====================
        {
            skillRange = {200, 260},
            herb = "Firebloom, Purple Lotus, Sungrass, Arthas' Tears",
            locations = {
                {
                    zone = "Tanaris",
                    faction = "Both",
                    route = "Grande círculo ao redor de Gadgetzan, passando pelo deserto.",
                    tips = "MELHOR zona para Firebloom! Sungrass também comum.",
                    levelRange = "40-50",
                },
                {
                    zone = "Felwood",
                    faction = "Both",
                    route = "Siga a estrada do sul ao norte da zona.",
                    tips = "EXCELENTE para Arthas' Tears e Sungrass! Purple Lotus também.",
                    levelRange = "48-55",
                },
                {
                    zone = "Searing Gorge",
                    faction = "Both",
                    route = "Circule as bordas da zona e passe pelas cavernas.",
                    tips = "Firebloom muito comum. Zona pequena mas eficiente.",
                    levelRange = "43-50",
                },
                {
                    zone = "Blasted Lands",
                    faction = "Both",
                    route = "Circule toda a zona, especialmente perto do Dark Portal.",
                    tips = "Sungrass abundante. Bom para preparar para Outland.",
                    levelRange = "45-55",
                },
                {
                    zone = "Un'Goro Crater",
                    faction = "Both",
                    route = "Grande círculo dentro da cratera, passando por todos os ambientes.",
                    tips = "Alta variedade de herbs! Sungrass muito comum.",
                    levelRange = "48-55",
                },
            },
        },
        
        -- ==================== GOLDEN SANSAM/DREAMFOIL/MOUNTAIN SILVERSAGE (260-300) ====================
        {
            skillRange = {260, 300},
            herb = "Golden Sansam, Dreamfoil, Mountain Silversage, Plaguebloom, Icecap",
            locations = {
                {
                    zone = "Eastern Plaguelands",
                    faction = "Both",
                    route = "Grande círculo passando por Light's Hope Chapel e as ruínas ao redor.",
                    tips = "MELHOR para Plaguebloom! Golden Sansam e Dreamfoil também.",
                    levelRange = "53-60",
                },
                {
                    zone = "Winterspring",
                    faction = "Both",
                    route = "Grande círculo ao redor de Everlook e pelas montanhas de gelo.",
                    tips = "ÚNICA zona para Icecap! Mountain Silversage comum.",
                    levelRange = "55-60",
                },
                {
                    zone = "Silithus",
                    faction = "Both",
                    route = "Circule ao redor de Cenarion Hold e as ruínas Qiraji.",
                    tips = "Excelente para Dreamfoil e Mountain Silversage.",
                    levelRange = "55-60",
                },
                {
                    zone = "Azshara",
                    faction = "Both",
                    route = "Circule a costa e as ruínas élficas.",
                    tips = "Menos disputado. Dreamfoil e Golden Sansam comuns.",
                    levelRange = "45-55",
                },
                {
                    zone = "Burning Steppes",
                    faction = "Both",
                    route = "Circule as montanhas ao redor de Morgan's Vigil/Flame Crest.",
                    tips = "Mountain Silversage abundante nas montanhas.",
                    levelRange = "50-58",
                },
            },
        },
        
        -- ==================== FELWEED/DREAMING GLORY (300-340) ====================
        {
            skillRange = {300, 340},
            herb = "Felweed, Dreaming Glory, Ragveil",
            locations = {
                {
                    zone = "Hellfire Peninsula",
                    faction = "Both",
                    route = "Grande círculo partindo de Honor Hold/Thrallmar passando por toda a zona.",
                    tips = "MELHOR para começar TBC! Felweed muito abundante.",
                    levelRange = "58-63",
                },
                {
                    zone = "Zangarmarsh",
                    faction = "Both",
                    route = "Circule os lagos e cogumelos ao redor de Cenarion Refuge.",
                    tips = "ÚNICA zona para Ragveil! Dreaming Glory também comum.",
                    levelRange = "60-64",
                },
                {
                    zone = "Terokkar Forest",
                    faction = "Both",
                    route = "Circule a floresta ao redor de Shattrath e Allerian/Stonebreaker.",
                    tips = "Boa variedade. Terocone começa a aparecer.",
                    levelRange = "62-65",
                },
            },
        },
        
        -- ==================== TEROCONE/ANCIENT LICHEN/NETHERBLOOM (340-375) ====================
        {
            skillRange = {340, 375},
            herb = "Terocone, Ancient Lichen, Netherbloom, Nightmare Vine, Mana Thistle",
            locations = {
                {
                    zone = "Terokkar Forest",
                    faction = "Both",
                    route = "Foco na floresta densa e perto de Auchindoun.",
                    tips = "MELHOR para Terocone! Bone Wastes tem Dreaming Glory.",
                    levelRange = "62-65",
                },
                {
                    zone = "Dungeons (Coilfang/Auchindoun)",
                    faction = "Both",
                    route = "Dentro das dungeons de Coilfang Reservoir e Auchindoun.",
                    tips = "ÚNICA fonte de Ancient Lichen! Farme em grupos.",
                    levelRange = "62-70",
                },
                {
                    zone = "Netherstorm",
                    faction = "Both",
                    route = "Circule as bordas das ilhas e os eco-domes.",
                    tips = "MELHOR para Netherbloom! Mana Thistle nas bordas.",
                    levelRange = "67-70",
                },
                {
                    zone = "Shadowmoon Valley",
                    faction = "Both",
                    route = "Circule ao redor do Black Temple e pelas montanhas.",
                    tips = "MELHOR para Nightmare Vine! Cuidado com mobs perigosos.",
                    levelRange = "67-70",
                },
                {
                    zone = "Blade's Edge Mountains",
                    faction = "Both",
                    route = "Foco nas bordas rochosas e planaltos.",
                    tips = "Mana Thistle nas bordas de precipícios. Felweed ainda comum.",
                    levelRange = "65-68",
                },
            },
        },
    },
    
    -- Leveling guide
    levelingGuide = {
        {
            range = {1, 70},
            tip = "Colete Peacebloom, Silverleaf e Earthroot em qualquer zona inicial. Todas as raças têm boas zonas.",
        },
        {
            range = {70, 115},
            tip = "Colete Mageroyal e Briarthorn. Barrens (Horde) ou Westfall/Darkshore (Alliance) são ideais.",
        },
        {
            range = {115, 150},
            tip = "Colete Bruiseweed, Wild Steelbloom e Kingsblood em Hillsbrad Foothills ou Wetlands.",
        },
        {
            range = {150, 205},
            tip = "Colete Liferoot, Fadeleaf, Goldthorn e Khadgar's Whisker em Stranglethorn Vale ou Feralas.",
        },
        {
            range = {205, 260},
            tip = "Colete Firebloom, Sungrass e Arthas' Tears em Tanaris, Felwood ou Un'Goro Crater.",
        },
        {
            range = {260, 300},
            tip = "Colete Golden Sansam, Dreamfoil, Mountain Silversage em EPL, Winterspring ou Silithus.",
        },
        {
            range = {300, 340},
            tip = "Colete Felweed e Dreaming Glory em Hellfire Peninsula ou Zangarmarsh (para Ragveil).",
        },
        {
            range = {340, 375},
            tip = "Colete Netherbloom em Netherstorm e Nightmare Vine em Shadowmoon Valley.",
        },
    },
}
