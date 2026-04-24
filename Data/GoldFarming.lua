-- Profession Helper - Gold Farming Guide Data
-- Best gold-making methods for each profession at max skill (375)

ProfessionHelper = ProfessionHelper or {}

ProfessionHelper.GoldFarming = {

    --------------------------------------------------------------------------
    -- ALCHEMY
    --------------------------------------------------------------------------
    ["Alchemy"] = {
        tips = {
            {
                category = "Transmutation",
                icon = "INV_Elemental_Primal_Nether",
                methods = {
                    {
                        name = "Transmute: Primal Might",
                        description = "Transmute 1x Primal Fire + 1x Primal Water + 1x Primal Earth + 1x Primal Air + 1x Primal Mana into 1x Primal Might. 20h cooldown. Extremely high demand for epic crafts.",
                        goldPerDay = "15-30g",
                        cooldown = "20h",
                        priority = 1,
                    },
                    {
                        name = "Transmute: Earthstorm Diamond",
                        description = "Transmute 3x Deeprock Salt + 1x Primal Earth into 1x Earthstorm Diamond. Essential meta gem for tanks and melee DPS.",
                        goldPerDay = "10-20g",
                        cooldown = "20h",
                        priority = 2,
                    },
                    {
                        name = "Transmute: Skyfire Diamond",
                        description = "Transmute 2x Primal Fire + 1x Primal Air into 1x Skyfire Diamond. Popular meta gem for casters and healers.",
                        goldPerDay = "10-20g",
                        cooldown = "20h",
                        priority = 2,
                    },
                },
            },
            {
                category = "Flasks and Elixirs",
                icon = "INV_Potion_117",
                methods = {
                    {
                        name = "Flask of Relentless Assault",
                        description = "+120 Attack Power for 2h. Most popular flask among melee DPS. Ingredients: 10x Fel Lotus, 7x Ragveil, 3x Ancient Lichen.",
                        goldPerDay = "Variable",
                        priority = 1,
                    },
                    {
                        name = "Flask of Pure Death",
                        description = "+80 Shadow/Fire/Frost Spell Damage for 2h. Widely used by Warlocks and Shadow Priests.",
                        goldPerDay = "Variable",
                        priority = 2,
                    },
                    {
                        name = "Flask of Mighty Restoration",
                        description = "+25 MP5 for 2h. Main healer flask. Always in demand on raid days.",
                        goldPerDay = "Variable",
                        priority = 2,
                    },
                    {
                        name = "Elixir of Major Agility",
                        description = "+35 Agility and +20 Crit. Most popular Battle Elixir. Cheap ingredients with good margin.",
                        goldPerDay = "Variable",
                        priority = 3,
                    },
                },
            },
            {
                category = "Potions",
                icon = "INV_Potion_131",
                methods = {
                    {
                        name = "Super Mana Potion",
                        description = "Restores 1800-3000 mana. Most used consumable in raids. Extremely high sales volume.",
                        goldPerDay = "Variable",
                        priority = 1,
                    },
                    {
                        name = "Haste Potion",
                        description = "+400 Haste Rating for 15s. Used by DPS for boss bursts. Good profit margin.",
                        goldPerDay = "Variable",
                        priority = 2,
                    },
                    {
                        name = "Ironshield Potion",
                        description = "+2500 Armor for 2min. Tank potion for difficult encounters.",
                        goldPerDay = "Variable",
                        priority = 3,
                    },
                },
            },
            {
                category = "Specialization",
                icon = "Trade_Alchemy",
                methods = {
                    {
                        name = "Transmutation Master",
                        description = "Chance to proc extra items on transmutations. Best specialization for gold. Primal Might procs = pure profit.",
                        goldPerDay = "Passive bonus",
                        priority = 1,
                    },
                    {
                        name = "Elixir Master",
                        description = "Chance to proc extra flasks and elixirs. Great for those selling raid consumables in volume.",
                        goldPerDay = "Passive bonus",
                        priority = 2,
                    },
                    {
                        name = "Potion Master",
                        description = "Chance to proc extra potions. Good volume but lower margin per item compared to Transmute.",
                        goldPerDay = "Passive bonus",
                        priority = 3,
                    },
                },
            },
        },
    },

    --------------------------------------------------------------------------
    -- BLACKSMITHING
    --------------------------------------------------------------------------
    ["Blacksmithing"] = {
        tips = {
            {
                category = "Epic Weapons",
                icon = "INV_Sword_101",
                methods = {
                    {
                        name = "Felsteel Longblade",
                        description = "Sellable epic 1H sword. Good for fresh level 70 Warriors and Rogues. Requires: Felsteel Bars + Primal Fire.",
                        goldPerDay = "Variable",
                        priority = 2,
                    },
                    {
                        name = "Khorium Champion",
                        description = "Epic 2H sword. Popular among Arms Warriors. Requires Khorium Bars + Primal Might.",
                        goldPerDay = "Variable",
                        priority = 2,
                    },
                },
            },
            {
                category = "Sellable Armor",
                icon = "INV_Chest_Plate16",
                methods = {
                    {
                        name = "Enchanted Adamantite Armor Set",
                        description = "Craftable plate set for fresh level 70 tanks. Enchanted Adamantite Breastplate, Leggings and Belt always sell.",
                        goldPerDay = "Variable",
                        priority = 1,
                    },
                    {
                        name = "Ragesteel Set",
                        description = "Offensive set for plate DPS. Ragesteel Helm, Breastplate and Gloves. Very popular among leveling Warriors.",
                        goldPerDay = "Variable",
                        priority = 2,
                    },
                },
            },
            {
                category = "Materials and Conversions",
                icon = "INV_Ingot_FelSteel",
                methods = {
                    {
                        name = "Felsteel Bars",
                        description = "Smelt Fel Iron Bar + Eternium Bar into Felsteel. Always in demand for Engineering and BS crafts.",
                        goldPerDay = "Variable",
                        priority = 1,
                    },
                    {
                        name = "Adamantite Sharpening Stones",
                        description = "Melee DPS consumable. Sells well before raid days. Simple craft with good margin.",
                        goldPerDay = "5-10g",
                        priority = 3,
                    },
                },
            },
            {
                category = "Specialization",
                icon = "Trade_BlackSmithing",
                methods = {
                    {
                        name = "Weaponsmith → Swordsmith",
                        description = "Access to Blazefury (epic BoE) and other sellable weapons. Swords are the most popular.",
                        goldPerDay = "Variable",
                        priority = 1,
                    },
                    {
                        name = "Armorsmith",
                        description = "Access to epic plate crafts. Less popular than Weaponsmith, but has a tank niche.",
                        goldPerDay = "Variable",
                        priority = 2,
                    },
                },
            },
        },
    },

    --------------------------------------------------------------------------
    -- ENCHANTING
    --------------------------------------------------------------------------
    ["Enchanting"] = {
        tips = {
            {
                category = "High-Demand Enchants",
                icon = "Spell_Holy_GreaterHeal",
                methods = {
                    {
                        name = "Mongoose (Weapon)",
                        description = "+120 Agility proc + Minor Haste. The most expensive and sought-after enchant in TBC. Commands a generous tip.",
                        goldPerDay = "15-40g per enchant",
                        priority = 1,
                    },
                    {
                        name = "Savagery (2H Weapon)",
                        description = "+70 Attack Power. Very popular for Arms Warriors and Hunters. Relatively cheap materials.",
                        goldPerDay = "5-15g per enchant",
                        priority = 2,
                    },
                    {
                        name = "Major Spellpower (Weapon)",
                        description = "+40 Spell Damage. Standard caster enchant. Always in demand.",
                        goldPerDay = "8-20g per enchant",
                        priority = 1,
                    },
                    {
                        name = "Soulfrost / Sunfire (Weapon)",
                        description = "+54 Shadow/Frost or +50 Arcane/Fire Spell Damage. Premium enchants from Sunwell recipes.",
                        goldPerDay = "20-50g per enchant",
                        priority = 1,
                    },
                },
            },
            {
                category = "Armor Enchants",
                icon = "INV_Enchant_FormulaSuperior_01",
                methods = {
                    {
                        name = "Enchant Cloak: Subtlety / Greater Agility",
                        description = "Subtlety (-2% threat) for tanks and healers. Greater Agi for rogues and hunters. Cheap to make.",
                        goldPerDay = "3-8g per enchant",
                        priority = 2,
                    },
                    {
                        name = "Enchant Chest: Exceptional Stats",
                        description = "+6 All Stats. Universal and very popular enchant. Good sales volume.",
                        goldPerDay = "5-12g per enchant",
                        priority = 2,
                    },
                    {
                        name = "Enchant Boots: Boar's Speed / Cat's Swiftness",
                        description = "Minor Speed + Stats. Premium boot enchants. Rare recipes = less competition.",
                        goldPerDay = "10-25g per enchant",
                        priority = 1,
                    },
                },
            },
            {
                category = "Disenchant for Profit",
                icon = "INV_Enchant_EssenceArcaneSmall",
                methods = {
                    {
                        name = "Void Shatter",
                        description = "Convert 1x Void Crystal into 2x Large Prismatic Shard. Void Crystals are cheap from badge epics. LPS are worth more.",
                        goldPerDay = "10-20g",
                        priority = 1,
                    },
                    {
                        name = "Disenchant AH Greens",
                        description = "Buy cheap greens (Outland ilvl 81+) and DE them for Arcane Dust or Greater Planar Essence. Always calculate first!",
                        goldPerDay = "5-15g",
                        priority = 2,
                    },
                },
            },
            {
                category = "Ring Enchants (Exclusive)",
                icon = "INV_Jewelry_Ring_36",
                methods = {
                    {
                        name = "Enchant Ring: Spellpower / Stats / Striking",
                        description = "+12 Spell Damage, +4 All Stats, or +2 Weapon Damage on rings. Only enchanters can use these. Personal savings.",
                        goldPerDay = "Personal savings",
                        priority = 3,
                    },
                },
            },
        },
    },

    --------------------------------------------------------------------------
    -- ENGINEERING
    --------------------------------------------------------------------------
    ["Engineering"] = {
        tips = {
            {
                category = "Primal Extraction",
                icon = "INV_Gizmo_ManaPotion",
                methods = {
                    {
                        name = "Zapthrottle Mote Extractor",
                        description = "Extract Motes from gas clouds in Outland. Farm: Nagrand (Mote of Air = 1-3g each), Zangarmarsh (Mote of Water). Engineer exclusive.",
                        goldPerDay = "20-40g/hour",
                        priority = 1,
                    },
                },
            },
            {
                category = "Consumables",
                icon = "INV_Ammo_Bullet_05",
                methods = {
                    {
                        name = "Adamantite Shells / Bullets",
                        description = "Outland ammo for Hunters. Sells in large stacks. Low margin but high volume.",
                        goldPerDay = "5-10g",
                        priority = 2,
                    },
                    {
                        name = "Khorium Scope",
                        description = "+12 Damage scope for ranged weapons. Every fresh level 70 Hunter needs one.",
                        goldPerDay = "Variable",
                        priority = 2,
                    },
                },
            },
            {
                category = "Utility Items",
                icon = "INV_Misc_Enggizmos_07",
                methods = {
                    {
                        name = "Field Repair Bot 110G",
                        description = "Portable repair bot for raids. Guilds buy regularly. Sell the finished bots or the materials.",
                        goldPerDay = "Variable",
                        priority = 2,
                    },
                    {
                        name = "Seaforium Charges",
                        description = "Open lockboxes and doors. Useful in dungeons. Sell as a service to those without a Rogue.",
                        goldPerDay = "2-5g",
                        priority = 3,
                    },
                },
            },
            {
                category = "Goggles (BoP)",
                icon = "INV_Helmet_47",
                methods = {
                    {
                        name = "Engineering Goggles (Tier Equivalent)",
                        description = "Tankatronic Goggles, Surestrike Goggles, etc. Save gold by not buying helms from other crafters. BoP = personal savings.",
                        goldPerDay = "Personal savings",
                        priority = 3,
                    },
                },
            },
        },
    },

    --------------------------------------------------------------------------
    -- JEWELCRAFTING
    --------------------------------------------------------------------------
    ["Jewelcrafting"] = {
        tips = {
            {
                category = "Prospecting",
                icon = "INV_Misc_Gem_Bloodstone_02",
                methods = {
                    {
                        name = "Prospect Adamantite Ore",
                        description = "Prospect stacks of Adamantite Ore to obtain rare gems (Living Ruby, Noble Topaz, Dawnstone, Star of Elune, Nightseye, Talasite). High profit if ore is cheap.",
                        goldPerDay = "15-40g/hour",
                        priority = 1,
                    },
                    {
                        name = "Prospect Fel Iron Ore",
                        description = "Prospect Fel Iron Ore for uncommon gems. Lower profit but cheaper ore. Good for beginners.",
                        goldPerDay = "5-15g/hour",
                        priority = 3,
                    },
                },
            },
            {
                category = "Cut Rare Gems",
                icon = "INV_Misc_Gem_FlameSpessarite_02",
                methods = {
                    {
                        name = "Delicate Living Ruby (+8 Agi)",
                        description = "Most popular red gem for Rogues, Hunters, and Ferals. Raw Living Ruby → cut gem = 5-15g profit.",
                        goldPerDay = "Variable",
                        priority = 1,
                    },
                    {
                        name = "Runed Living Ruby (+9 Spell Damage)",
                        description = "Red gem for casters. Extremely high demand. JC Daily design. Always sells.",
                        goldPerDay = "Variable",
                        priority = 1,
                    },
                    {
                        name = "Solid Star of Elune (+12 Stamina)",
                        description = "Universal blue gem. Tanks and anyone filling a blue socket. Very high volume.",
                        goldPerDay = "Variable",
                        priority = 1,
                    },
                    {
                        name = "Inscribed Noble Topaz (+4 Crit/+5 Spell)",
                        description = "Orange gem for casters. Good margin. Many sellable variants.",
                        goldPerDay = "Variable",
                        priority = 2,
                    },
                },
            },
            {
                category = "Meta Gems",
                icon = "INV_Misc_Gem_Diamond_06",
                methods = {
                    {
                        name = "Relentless Earthstorm Diamond",
                        description = "+12 Agi and +3% Crit Damage. Most popular meta gem for melee. Always in demand.",
                        goldPerDay = "5-15g per gem",
                        priority = 1,
                    },
                    {
                        name = "Chaotic Skyfire Diamond",
                        description = "+12 Crit and +3% Crit Damage. Popular among Hunters and some casters.",
                        goldPerDay = "5-15g per gem",
                        priority = 2,
                    },
                },
            },
            {
                category = "JC Dailies",
                icon = "INV_Misc_Note_02",
                methods = {
                    {
                        name = "Daily Quest in Shattrath",
                        description = "Do the daily JC quest every day to earn tokens. Use tokens to buy rare designs that other JCs don't have = monopoly!",
                        goldPerDay = "Investment",
                        priority = 1,
                    },
                },
            },
        },
    },

    --------------------------------------------------------------------------
    -- LEATHERWORKING
    --------------------------------------------------------------------------
    ["Leatherworking"] = {
        tips = {
            {
                category = "Drums (Raid Consumables)",
                icon = "INV_Misc_Drum_05",
                methods = {
                    {
                        name = "Drums of Battle",
                        description = "+80 Haste for the group for 30s. Required in competitive raids. Every LW raider needs it. Extremely high volume.",
                        goldPerDay = "10-25g",
                        priority = 1,
                    },
                    {
                        name = "Drums of Restoration",
                        description = "Restores 600 HP/mana to the group. Used by healers and in progression. Cheap ingredients.",
                        goldPerDay = "5-10g",
                        priority = 2,
                    },
                },
            },
            {
                category = "Armor Kits",
                icon = "INV_Misc_ArmorKit_24",
                methods = {
                    {
                        name = "Vindicator's Armor Kit",
                        description = "+8 Defense Rating. Armor kit for tanks. Sells alongside Heavy Knothide Armor Kit (+10 Stam).",
                        goldPerDay = "5-10g",
                        priority = 2,
                    },
                    {
                        name = "Nethercobra Leg Armor / Nethercleft Leg Armor",
                        description = "+50 AP/+12 Crit or +40 Stam/+12 Agi. Outland leg enchants. Constant high demand.",
                        goldPerDay = "10-25g",
                        priority = 1,
                    },
                    {
                        name = "Clefthide Leg Armor / Cobrahide Leg Armor",
                        description = "Cheaper version of leg armors. For alts and leveling. High volume, lower margin.",
                        goldPerDay = "5-10g",
                        priority = 2,
                    },
                },
            },
            {
                category = "Craftable Gear",
                icon = "INV_Pants_Leather_27",
                methods = {
                    {
                        name = "Heavy Clefthoof Set (Tank)",
                        description = "Leather set for Feral Druids. Vest, Leggings, Boots. Always in demand for fresh level 70 Druids.",
                        goldPerDay = "Variable",
                        priority = 1,
                    },
                    {
                        name = "Riding Crop",
                        description = "+10% mount speed. Every player wants one. Relatively cheap to craft, good profit margin.",
                        goldPerDay = "Variable",
                        priority = 2,
                    },
                },
            },
        },
    },

    --------------------------------------------------------------------------
    -- TAILORING
    --------------------------------------------------------------------------
    ["Tailoring"] = {
        tips = {
            {
                category = "Daily Cooldowns",
                icon = "INV_Fabric_Moonrag_Primal",
                methods = {
                    {
                        name = "Primal Mooncloth",
                        description = "Craft at any Moonwell. 3.8-day CD (92h). Requires: 1x Bolt of Imbued Netherweave + 1x Primal Life + 1x Primal Water. Sells for 20-40g each.",
                        goldPerDay = "5-10g (avg/day)",
                        cooldown = "92h",
                        priority = 1,
                    },
                    {
                        name = "Shadowcloth",
                        description = "Craft at the Altar of Shadows in Shadowmoon Valley. 92h CD. Requires: 1x Bolt of Imbued Netherweave + 1x Primal Shadow + 1x Primal Fire.",
                        goldPerDay = "5-10g (avg/day)",
                        cooldown = "92h",
                        priority = 1,
                    },
                    {
                        name = "Spellcloth",
                        description = "Craft in Netherstorm (altar). 92h CD. Requires: 1x Bolt of Imbued Netherweave + 1x Primal Mana + 1x Primal Fire.",
                        goldPerDay = "5-10g (avg/day)",
                        cooldown = "92h",
                        priority = 1,
                    },
                },
            },
            {
                category = "Bags",
                icon = "INV_Misc_Bag_EnchantedRunecloth",
                methods = {
                    {
                        name = "Netherweave Bag (16 slots)",
                        description = "Best-selling bag in the game. Every alt needs 4. Simple craft: 1x Bolt of Netherweave (4x Netherweave Cloth). Enormous volume.",
                        goldPerDay = "5-15g",
                        priority = 1,
                    },
                    {
                        name = "Imbued Netherweave Bag (18 slots)",
                        description = "Upgrade for mains. More expensive to make but good margin. 4x Bolt of Imbued Netherweave + 2x Netherweb Spider Silk.",
                        goldPerDay = "Variable",
                        priority = 2,
                    },
                    {
                        name = "Primal Mooncloth Bag (20 slots)",
                        description = "Largest craftable bag. Requires Primal Mooncloth. Excellent margin if you are Mooncloth spec.",
                        goldPerDay = "Variable",
                        priority = 2,
                    },
                },
            },
            {
                category = "Specialization",
                icon = "Trade_Tailoring",
                methods = {
                    {
                        name = "Shadoweave Tailoring",
                        description = "Produces 2x Shadowcloth per cooldown. Shadoweave set (BoP) is BiS for Warlocks. Sell extra Shadowcloth.",
                        goldPerDay = "Passive bonus",
                        priority = 1,
                    },
                    {
                        name = "Spellfire Tailoring",
                        description = "Produces 2x Spellcloth per cooldown. Spellfire set (BoP) is BiS for Mages. Sell extra Spellcloth.",
                        goldPerDay = "Passive bonus",
                        priority = 1,
                    },
                    {
                        name = "Mooncloth Tailoring",
                        description = "Produces 2x Primal Mooncloth per cooldown. PMC set (BoP) is BiS for Holy Priests. Sell extra PMC.",
                        goldPerDay = "Passive bonus",
                        priority = 1,
                    },
                },
            },
        },
    },

    --------------------------------------------------------------------------
    -- HERBALISM
    --------------------------------------------------------------------------
    ["Herbalism"] = {
        tips = {
            {
                category = "High-Demand Herbs",
                icon = "INV_Misc_Herb_FelLotus",
                methods = {
                    {
                        name = "Fel Lotus (any Outland zone)",
                        description = "Rare drop from any Outland herb. Used in all Flasks. High price (8-15g each). Farm any herb and earn Fel Lotus as a bonus.",
                        goldPerDay = "Random bonus",
                        priority = 1,
                    },
                    {
                        name = "Mana Thistle (Netherstorm / Blade's Edge)",
                        description = "375 skill herb. Used in Super Mana Potions and various elixirs. One of the most expensive herbs. Route: north and south Netherstorm.",
                        goldPerDay = "30-50g/hour",
                        priority = 1,
                    },
                    {
                        name = "Nightmare Vine (Shadowmoon Valley)",
                        description = "365 skill herb. Used in Elixir of Major Shadow Power and others. Circular route through Shadowmoon Valley.",
                        goldPerDay = "25-40g/hour",
                        priority = 1,
                    },
                },
            },
            {
                category = "Farm Routes",
                icon = "Trade_Herbalism",
                methods = {
                    {
                        name = "Route: Terokkar Forest (Terocone)",
                        description = "Terocone is used in Flask of Relentless Assault and various elixirs. Circular route through the center of the map. Less competition than Nagrand.",
                        goldPerDay = "20-35g/hour",
                        priority = 2,
                    },
                    {
                        name = "Route: Nagrand (Dreaming Glory)",
                        description = "Dreaming Glory + chance of Fel Lotus. Route along the west and north sides. Combine with Mining if available.",
                        goldPerDay = "20-30g/hour",
                        priority = 2,
                    },
                    {
                        name = "Route: Zangarmarsh (Ragveil + Ancient Lichen)",
                        description = "Ragveil for Flasks, Ancient Lichen inside dungeons (Slave Pens/Underbog). Dungeon farming = no competition.",
                        goldPerDay = "25-40g/hour",
                        priority = 2,
                    },
                    {
                        name = "Route: Netherstorm (Netherbloom + Mana Thistle)",
                        description = "Two valuable herbs in the same zone. Route through the eco-dome circuit. Good for flying with an epic mount.",
                        goldPerDay = "30-50g/hour",
                        priority = 1,
                    },
                },
            },
        },
    },

    --------------------------------------------------------------------------
    -- MINING
    --------------------------------------------------------------------------
    ["Mining"] = {
        tips = {
            {
                category = "High-Demand Ores",
                icon = "INV_Ore_Adamantium",
                methods = {
                    {
                        name = "Adamantite Ore (Nagrand / Netherstorm)",
                        description = "Main Outland ore. JCs prospect in bulk. Always sells fast. Nagrand has the best node density.",
                        goldPerDay = "25-45g/hour",
                        priority = 1,
                    },
                    {
                        name = "Khorium Ore (all Outland zones)",
                        description = "Rare ore, spawns in Adamantite veins. Very high price (5-10g per ore). Always pick up when found.",
                        goldPerDay = "Random bonus",
                        priority = 1,
                    },
                    {
                        name = "Fel Iron Ore (Hellfire / Zangarmarsh)",
                        description = "Basic Outland ore. High sales volume for BS and Engineering. Fast circular route in Hellfire.",
                        goldPerDay = "15-25g/hour",
                        priority = 2,
                    },
                },
            },
            {
                category = "Farm Routes",
                icon = "Trade_Mining",
                methods = {
                    {
                        name = "Route: Nagrand (Adamantite + Khorium)",
                        description = "Best zone for Mining. Circuit through the mountains and plateaus. Epic flying mount recommended. Combine with Herbalism.",
                        goldPerDay = "30-50g/hour",
                        priority = 1,
                    },
                    {
                        name = "Route: Netherstorm (Adamantite + Khorium)",
                        description = "Second best zone. Less competition than Nagrand. Circular route through the eco-domes and ruins.",
                        goldPerDay = "25-40g/hour",
                        priority = 1,
                    },
                    {
                        name = "Route: Shadowmoon Valley",
                        description = "Abundant Adamantite in the mountains. High-level mobs can be a nuisance. Good if Nagrand and Netherstorm are crowded.",
                        goldPerDay = "20-35g/hour",
                        priority = 2,
                    },
                },
            },
            {
                category = "Smelting for Profit",
                icon = "Spell_Fire_FlameBlades",
                methods = {
                    {
                        name = "Smelt Felsteel (Fel Iron + Eternium)",
                        description = "Felsteel bars are worth more than the ores separately. Always check AH prices before smelting.",
                        goldPerDay = "Variable",
                        priority = 2,
                    },
                    {
                        name = "Smelt Hardened Adamantite",
                        description = "Requires Mining 375. 10x Adamantite Bar = 1x Hardened Adamantite. Used in epic BS recipes.",
                        goldPerDay = "Variable",
                        priority = 2,
                    },
                },
            },
        },
    },

    --------------------------------------------------------------------------
    -- SKINNING
    --------------------------------------------------------------------------
    ["Skinning"] = {
        tips = {
            {
                category = "High-Demand Leather",
                icon = "INV_Misc_Leatherscrap_11",
                methods = {
                    {
                        name = "Knothide Leather (any Outland mob)",
                        description = "Main Outland leather. LW needs it in bulk for Drums, Armor Kits, and crafts. Always sells.",
                        goldPerDay = "15-30g/hour",
                        priority = 1,
                    },
                    {
                        name = "Thick Clefthoof Leather (Nagrand)",
                        description = "Drop from Clefthoofs in Nagrand. Used in the Heavy Clefthoof set (tank BiS). Premium price, 2-5g each.",
                        goldPerDay = "25-45g/hour",
                        priority = 1,
                    },
                },
            },
            {
                category = "Special Scales",
                icon = "INV_Misc_MonsterScales_15",
                methods = {
                    {
                        name = "Cobra Scales (Shadowmoon / Nagrand)",
                        description = "Drop from cobras in Shadowmoon Valley and Nagrand. Used in Nethercobra Leg Armor. High price.",
                        goldPerDay = "15-30g/hour",
                        priority = 1,
                    },
                    {
                        name = "Wind Scales (Blade's Edge Mountains)",
                        description = "Drop from Wind Serpents in Blade's Edge. Used in various LW crafts. Niche but consistent.",
                        goldPerDay = "10-20g/hour",
                        priority = 2,
                    },
                    {
                        name = "Nether Dragonscales (Blade's Edge / Netherstorm)",
                        description = "Drop from Netherwing drakes and Netherdrakes. Used in LW mail gear. Scarce = high price.",
                        goldPerDay = "10-25g/hour",
                        priority = 2,
                    },
                },
            },
            {
                category = "Farm Routes",
                icon = "INV_Misc_Pelt_Wolf_01",
                methods = {
                    {
                        name = "Route: Nagrand - Clefthoof Bulls",
                        description = "Best Skinning farm. Kill Clefthoof Bulls/Clefthooves near Nesingwary Camp. Drops: Thick Clefthoof Leather + Knothide + Primal Shadow.",
                        goldPerDay = "30-50g/hour",
                        priority = 1,
                    },
                    {
                        name = "Route: Shadowmoon Valley - Cobras",
                        description = "Eclipse Point and surroundings. Kill Shadow Serpents for Cobra Scales + Knothide Leather.",
                        goldPerDay = "20-35g/hour",
                        priority = 2,
                    },
                    {
                        name = "Route: Blade's Edge - Wind Serpents",
                        description = "Bash'ir Landing and Vortex Summit. Wind Scales + Knothide. Less competition.",
                        goldPerDay = "15-25g/hour",
                        priority = 3,
                    },
                },
            },
        },
    },

    --------------------------------------------------------------------------
    -- COOKING
    --------------------------------------------------------------------------
    ["Cooking"] = {
        tips = {
            {
                category = "Raid Food (High Demand)",
                icon = "INV_Misc_Food_CokedClam",
                methods = {
                    {
                        name = "Golden Fish Sticks (+44 Healing)",
                        description = "Buff food #1 for healers. Ingredient: Golden Darter (fish in Terokkar). Sells for 1-3g each. Excellent margin.",
                        goldPerDay = "10-25g/hour",
                        priority = 1,
                    },
                    {
                        name = "Spicy Crawdad (+30 Stamina)",
                        description = "Buff food #1 for tanks. Ingredient: Furious Crawdad (fish in Terokkar Highland). Premium price!",
                        goldPerDay = "15-35g/hour",
                        priority = 1,
                    },
                    {
                        name = "Blackened Basilisk (+23 Spell Dmg / +20 Spirit)",
                        description = "Popular buff food for casters. Ingredient: Blackened Basilisk Meat (drop in Terokkar). Easy to farm.",
                        goldPerDay = "10-20g/hour",
                        priority = 1,
                    },
                },
            },
            {
                category = "Agility/AP Food",
                icon = "INV_Misc_Food_99",
                methods = {
                    {
                        name = "Warp Burger (+20 Agility / +20 Spirit)",
                        description = "Popular buff food for Rogues, Hunters, and Ferals. Ingredient: Warped Flesh (drop from Warp Stalkers in Terokkar).",
                        goldPerDay = "8-15g/hour",
                        priority = 2,
                    },
                    {
                        name = "Grilled Mudfish (+20 Agility / +20 Spirit)",
                        description = "Alternative to Warp Burger. Ingredient: Figluster's Mudfish (fish in Nagrand). Less farming = more fishing.",
                        goldPerDay = "8-15g/hour",
                        priority = 2,
                    },
                    {
                        name = "Ravager Dogs (+40 AP / +20 Spirit)",
                        description = "Buff food for melee DPS. Ingredient: Ravager Flesh (drop in Hellfire Peninsula). Low-level zone = easy.",
                        goldPerDay = "5-12g/hour",
                        priority = 3,
                    },
                },
            },
            {
                category = "Extra Tip",
                icon = "INV_Misc_Food_15",
                methods = {
                    {
                        name = "Sell on Raid Days",
                        description = "Tuesday and Wednesday (raid reset) are the best days to sell buff food. Prices rise 50-100%. Stock up beforehand!",
                        goldPerDay = "Tip",
                        priority = 1,
                    },
                },
            },
        },
    },

    --------------------------------------------------------------------------
    -- FISHING
    --------------------------------------------------------------------------
    ["Fishing"] = {
        tips = {
            {
                category = "High-Demand Fish",
                icon = "INV_Misc_Fish_30",
                methods = {
                    {
                        name = "Furious Crawdad (Terokkar Highland Pools)",
                        description = "Fish in Highland Mixed Schools in Terokkar Forest (requires flying). Used in Spicy Crawdad (+30 Stam). 3-8g per stack.",
                        goldPerDay = "20-40g/hour",
                        priority = 1,
                    },
                    {
                        name = "Golden Darter (Terokkar Forest)",
                        description = "Fish in Terokkar rivers. Used in Golden Fish Sticks (+44 Healing). Sells well and easy to fish.",
                        goldPerDay = "15-25g/hour",
                        priority = 1,
                    },
                    {
                        name = "Enormous Barbed Gill Trout",
                        description = "Fish in Outland open water. Used in various consumables. Good filler while searching for pools.",
                        goldPerDay = "10-15g/hour",
                        priority = 3,
                    },
                },
            },
            {
                category = "Primal Farming",
                icon = "INV_Elemental_Primal_Water",
                methods = {
                    {
                        name = "Mote of Water (Nagrand Fishing Pools)",
                        description = "Fish in Pure Water pools in Nagrand. 10 Motes = 1 Primal Water (12-20g). Excellent gold/hour with flying.",
                        goldPerDay = "20-35g/hour",
                        priority = 1,
                    },
                    {
                        name = "Steam Pump Flotsam (Zangarmarsh)",
                        description = "Fish in Steam Pump pools in Zangarmarsh. Chance of valuable fish + motes.",
                        goldPerDay = "10-20g/hour",
                        priority = 2,
                    },
                },
            },
            {
                category = "Mr. Pinchy!",
                icon = "INV_Misc_Fish_35",
                methods = {
                    {
                        name = "Mr. Pinchy (Highland Mixed Schools)",
                        description = "Rare chance to fish in Highland Mixed Schools in Terokkar. 3 wishes: pet, potions, or 5x Furious Crawdad. Pet = hundreds of gold!",
                        goldPerDay = "Luck!",
                        priority = 2,
                    },
                },
            },
        },
    },

    --------------------------------------------------------------------------
    -- FIRST AID
    --------------------------------------------------------------------------
    ["First Aid"] = {
        tips = {
            {
                category = "Practical Use",
                icon = "Spell_Holy_SealOfSacrifice",
                methods = {
                    {
                        name = "Heavy Netherweave Bandage",
                        description = "Heals 3400 HP over 8s. Essential for classes without heals (Warriors, Rogues). Save gold on heal potions by using bandages while questing and farming.",
                        goldPerDay = "Personal savings",
                        priority = 1,
                    },
                    {
                        name = "Sell Crafting Service",
                        description = "Many players don't level First Aid. Offer crafted bandages to guildmates in exchange for a tip.",
                        goldPerDay = "1-3g",
                        priority = 3,
                    },
                },
            },
        },
    },
}
