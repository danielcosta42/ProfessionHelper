-- Profession Helper - TBC Specialization Data
-- Covers all professions that have specializations in The Burning Crusade Classic.
-- Each spec entry: name, description, uniqueRecipes, howToGet, npc, cost, recommendation, icon

local PH = _G.ProfessionHelper

PH.Specializations = {

    -- =========================================================================
    Alchemy = {
        description = "Alchemy Masters unlock a 15% chance to proc extra output for their chosen category. All three quests require skill 375 and 4x Primal Might.",
        specs = {
            {
                name           = "Transmutation Master",
                description    = "15% chance to receive extra transmuted materials whenever you perform an Alchemy Transmutation.",
                uniqueRecipes  = { "Bonus procs on all Transmutes (Primal Might, Nether Vortex, etc.)" },
                howToGet       = "Quest: Master of Transmutation — Zarevhi (Area 52, Netherstorm)",
                npc            = "Zarevhi (Area 52, Netherstorm)",
                cost           = "4x Primal Might",
                recommendation = "Best for: Daily transmuters farming gold or supplying raid materials. High value if you have consistent transmute materials.",
                icon           = "Interface\\Icons\\inv_potion_59",
            },
            {
                name           = "Elixir Master",
                description    = "15% chance to create extra Elixirs and Flasks when crafting.",
                uniqueRecipes  = { "Bonus procs on all Elixirs and Flasks" },
                howToGet       = "Quest: Master of Elixirs — Lorokeem (Shattrath City, Lower City)",
                npc            = "Lorokeem (Shattrath City, Lower City)",
                cost           = "4x Volatile Healing Potion + 4x Super Mana Potion + 4x Elixir of Major Defense",
                recommendation = "Best for: Raiders who craft their own flasks. Strong sustained value since flasks are always needed.",
                icon           = "Interface\\Icons\\inv_potion_97",
            },
            {
                name           = "Potion Master",
                description    = "15% chance to create extra Potions (including combat potions) when crafting.",
                uniqueRecipes  = { "Bonus procs on all Potions" },
                howToGet       = "Quest: Master of Potions — Lauranna Thar'well (Cenarion Refuge, Zangarmarsh)",
                npc            = "Lauranna Thar'well (Cenarion Refuge, Zangarmarsh)",
                cost           = "4x Super Healing Potion + 4x Super Mana Potion + 4x Major Dreamless Sleep Potion",
                recommendation = "Best for: Players who farm and sell potions in bulk on the AH. Lower personal value than Elixir Master for raiders.",
                icon           = "Interface\\Icons\\inv_potion_54",
            },
        },
    },

    -- =========================================================================
    Blacksmithing = {
        description = "Blacksmiths choose between Armorsmith and Weaponsmith. The choice is permanent (cannot be changed without dropping BS) and each unlocks exclusive BoP items.",
        specs = {
            {
                name           = "Armorsmith",
                description    = "Unlocks unique BoP armor patterns including the Iceguard and Windforged sets. Required to craft Stormherald-tier BoP plate.",
                uniqueRecipes  = {
                    "Iceguard Breastplate (tank)", "Iceguard Helm (tank)", "Iceguard Leggings (tank)",
                    "Windforged Leggings (DPS)", "Windforged Rapier",
                },
                howToGet       = "Quest: The Art of the Armorsmith — Grumnus Steelshaper (Ironforge, Alliance) / Okothos Ironrager (Orgrimmar, Horde)",
                npc            = "Grumnus Steelshaper (Ironforge) / Okothos Ironrager (Orgrimmar)",
                cost           = "8x Arcanite Bar + 4x Enchanted Thorium Bar + 4x Runed Thorium Bar (Classic quest items)",
                recommendation = "Best for: Tanks (Warriors, Paladins). The Iceguard set is strong pre-raid BiS for tanks.",
                icon           = "Interface\\Icons\\inv_chest_plate_14",
            },
            {
                name           = "Weaponsmith",
                description    = "Unlocks unique BoP weapons. Further specialize into Axesmith, Hammersmith, or Swordsmith for specific weapon types.",
                uniqueRecipes  = {
                    "Stormherald (2H Mace — Hammersmith)",
                    "Dragonstrike (1H Mace — Hammersmith)",
                    "Wicked Edge of the Planes (2H Sword — Swordsmith)",
                    "Lunar Crescent (2H Axe — Axesmith)",
                    "The Planar Edge (1H Axe — Axesmith)",
                },
                howToGet       = "Quest: The Way of the Weaponsmith — Ironus Coldsteel (Ironforge, Alliance) / Borgosh Corebender (Orgrimmar, Horde)",
                npc            = "Ironus Coldsteel (Ironforge) / Borgosh Corebender (Orgrimmar)",
                cost           = "4x Arcanite Bar + 4x Ornate Mithril Helm + 4x Ornate Mithril Boots (Classic quest items)",
                recommendation = "Best for: DPS Warriors, Paladins, Shamans. Stormherald and Dragonstrike are raid-level BoP weapons.",
                icon           = "Interface\\Icons\\inv_sword_48",
            },
        },
    },

    -- =========================================================================
    Engineering = {
        description = "Engineers choose between Gnomish and Goblin engineering. Each gives access to unique gadgets. Both specs can ultimately craft most recipes with the right schematics, but some gadgets are spec-exclusive.",
        specs = {
            {
                name           = "Gnomish Engineering",
                description    = "Focuses on utility gadgets: mind control, shrink rays, death rays. Gadgets have randomized effects and sometimes backfire in entertaining ways.",
                uniqueRecipes  = {
                    "Gnomish Mind Control Cap (chance to MC humanoids)",
                    "Gnomish Death Ray (charges up damage — may backfire on you)",
                    "Gnomish Shrink Ray (reduces target's attack power)",
                    "Gnomish Net-o-Matic Projector (roots target)",
                    "Gnomish Battle Chicken (summon combat pet)",
                    "Gnomish Alarm-o-Bot (patrol detector)",
                },
                howToGet       = "Quest: Gnome Engineering — Oglethorpe Obnoticus (Booty Bay, Stranglethorn Vale)",
                npc            = "Oglethorpe Obnoticus (Booty Bay, Stranglethorn Vale)",
                cost           = "No materials — just talk to the NPC at skill 200+",
                recommendation = "Best for: PvP utility and fun gadgets. Mind Control Cap is strong in PvP. Less raw damage than Goblin but more tricks.",
                icon           = "Interface\\Icons\\inv_gizmo_04",
            },
            {
                name           = "Goblin Engineering",
                description    = "Focuses on explosives and raw damage. Goblin Rocket Boots and Rocket Helmet are iconic. Gadgets tend to be more reliable but less varied.",
                uniqueRecipes  = {
                    "Goblin Rocket Boots (speed boost — may malfunction)",
                    "Goblin Rocket Helmet (charges target — may face wrong direction)",
                    "The Big One (massive AoE bomb)",
                    "Goblin Mortar (ranged AoE device)",
                    "Goblin Dragon Gun (fire damage cone)",
                    "Goblin Bomb Dispenser (remote bombs)",
                },
                howToGet       = "Quest: Goblin Engineering — Nixx Sprocketspring (Gadgetzan, Tanaris)",
                npc            = "Nixx Sprocketspring (Gadgetzan, Tanaris)",
                cost           = "No materials — just talk to the NPC at skill 200+",
                recommendation = "Best for: DPS and explosive playstyle. Rocket Boots are very useful for mobility. The Big One hits hard in dungeons.",
                icon           = "Interface\\Icons\\inv_gizmo_01",
            },
        },
    },

    -- =========================================================================
    Leatherworking = {
        description = "Leatherworkers choose between Tribal, Dragonscale, and Elemental. Each unlocks a BoP TBC armor set and requires a Classic-era spec quest first.",
        specs = {
            {
                name           = "Tribal Leatherworking",
                description    = "Specializes in caster leather and mail. Unlocks the BoP Windhawk Set (caster leather — Resto Druid, Balance Druid, Elemental Shaman).",
                uniqueRecipes  = {
                    "Windhawk Hauberk (BoP — caster mail)",
                    "Windhawk Belt (BoP — caster mail)",
                    "Windhawk Bracers (BoP — caster mail)",
                    "Primalstrike Set (craftable for others)",
                },
                howToGet       = "Quest: Tribal Leatherworking — Caryssia Moonhunter (Lower Feralas, Alliance) / Se'Jib (Stranglethorn Vale, Horde)",
                npc            = "Caryssia Moonhunter (Feralas) / Se'Jib (Stranglethorn Vale)",
                cost           = "6x Wild Leather Vest + 6x Wild Leather Helmet + 10x Wildvine",
                recommendation = "Best for: Resto/Balance Druids, Elemental Shamans. Windhawk set is excellent pre-raid BiS for casters wearing mail/leather.",
                icon           = "Interface\\Icons\\inv_misc_leatherscrap_07",
            },
            {
                name           = "Dragonscale Leatherworking",
                description    = "Specializes in physical DPS mail. Unlocks the BoP Dragonstrike Set (enhancement mail — Enhancement Shaman, Hunter).",
                uniqueRecipes  = {
                    "Netherfury Belt (BoP — physical mail)",
                    "Netherfury Leggings (BoP — physical mail)",
                    "Netherfury Boots (BoP — physical mail)",
                    "Dragonstrike Leggings (BoP — physical mail)",
                },
                howToGet       = "Quest: Dragonscale Leatherworking — Peter Galen (Azshara) / Thorkaf Dragoneye (Badlands)",
                npc            = "Peter Galen (Azshara) / Thorkaf Dragoneye (Badlands)",
                cost           = "2x Tough Scorpid Breastplate + 2x Tough Scorpid Gloves + 10x Worn Dragonscale",
                recommendation = "Best for: Enhancement Shamans, Hunters. Netherfury set provides strong pre-raid stats.",
                icon           = "Interface\\Icons\\inv_misc_monsterscales_05",
            },
            {
                name           = "Elemental Leatherworking",
                description    = "Specializes in physical leather (Rogue, Feral Druid). Unlocks the BoP Primalstorm and Shadowprowler's sets.",
                uniqueRecipes  = {
                    "Shadowprowler's Chestguard (BoP — rogue leather)",
                    "Primalstorm Breastplate (BoP — physical leather)",
                    "Primalstorm Belt (BoP — physical leather)",
                    "Primalstorm Bracers (BoP — physical leather)",
                },
                howToGet       = "Quest: Elemental Leatherworking — Brumn Winterhoof (Arathi Highlands) / Hahrana Ironhide (Feralas)",
                npc            = "Brumn Winterhoof (Arathi Highlands) / Hahrana Ironhide (Feralas)",
                cost           = "2x Cured Rugged Hide + 2x Thick Armor Kit + 10x Core of Earth",
                recommendation = "Best for: Rogues, Feral Druids. Shadowprowler's Chestguard is pre-raid BiS for rogues at the start of TBC.",
                icon           = "Interface\\Icons\\inv_misc_monsterscales_12",
            },
        },
    },

    -- =========================================================================
    Tailoring = {
        description = "TBC Tailors choose one of three specializations at skill 350. Each grants a unique BoP pre-raid gear set and a 4-day cooldown cloth. The spec-specific cloth is used to craft both the BoP set and powerful PvE gear.",
        specs = {
            {
                name           = "Mooncloth Tailoring",
                description    = "Craft Primal Mooncloth (4-day CD) at the Altar of Shadows in Shadowmoon Valley. Unlocks the BoP Primal Mooncloth Set — the best pre-raid healing gear for Holy Priests.",
                uniqueRecipes  = {
                    "Primal Mooncloth Robe (BoP — healing cloth)",
                    "Primal Mooncloth Shoulders (BoP — healing cloth)",
                    "Primal Mooncloth Belt (BoP — healing cloth)",
                    "Primal Mooncloth (4-day cooldown)",
                },
                howToGet       = "Quest: Becoming a Mooncloth Tailor — Nasmara Moonsong (Shattrath City)",
                npc            = "Nasmara Moonsong (Shattrath City, Lower City)",
                cost           = "4x Primal Mooncloth (craft it first at the Altar of Shadows, Shadowmoon Valley)",
                recommendation = "Best for: Holy Priests. The Primal Mooncloth set is pre-raid BiS for Holy Priests and is highly sought after.",
                icon           = "Interface\\Icons\\inv_fabric_mooncloth_02",
            },
            {
                name           = "Shadoweave Tailoring",
                description    = "Craft Shadowcloth (4-day CD) at the Altar of Shadows in Shadowmoon Valley. Unlocks the BoP Shadoweave Set — pre-raid BiS for Shadow Priests and Warlocks.",
                uniqueRecipes  = {
                    "Shadoweave Mask (BoP — shadow/warlock cloth)",
                    "Shadoweave Robe (BoP — shadow/warlock cloth)",
                    "Shadoweave Shoulders (BoP — shadow/warlock cloth)",
                    "Shadowcloth (4-day cooldown)",
                },
                howToGet       = "Quest: Becoming a Shadoweave Tailor — Andrion Darkspinner (Shattrath City)",
                npc            = "Andrion Darkspinner (Shattrath City, Lower City)",
                cost           = "4x Shadowcloth (craft it first at the Altar of Shadows, Shadowmoon Valley)",
                recommendation = "Best for: Shadow Priests, Affliction/Destruction Warlocks. Best pre-raid shadow damage set.",
                icon           = "Interface\\Icons\\inv_fabric_shadowcloth",
            },
            {
                name           = "Spellfire Tailoring",
                description    = "Craft Spellcloth (4-day CD) in Netherstorm (a nether vortex forms in the sky when crafting). Unlocks the BoP Spellfire Set — pre-raid BiS for Fire Mages.",
                uniqueRecipes  = {
                    "Spellfire Robe (BoP — spell power cloth)",
                    "Spellfire Gloves (BoP — spell power cloth)",
                    "Spellfire Belt (BoP — spell power cloth)",
                    "Spellcloth (4-day cooldown)",
                },
                howToGet       = "Quest: Becoming a Spellfire Tailor — Gidge Spellweaver (Shattrath City)",
                npc            = "Gidge Spellweaver (Shattrath City, Lower City)",
                cost           = "4x Spellcloth (craft it first in Netherstorm — Forge Base: Alpha or Forge Base: Oblivion)",
                recommendation = "Best for: Fire/Arcane Mages, Fire Warlocks. The highest raw spell damage pre-raid set — transformative for Mage DPS.",
                icon           = "Interface\\Icons\\inv_fabric_spellcloth",
            },
        },
    },
}
