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
                category = "Transmutação",
                icon = "INV_Elemental_Primal_Nether",
                methods = {
                    {
                        name = "Transmute: Primal Might",
                        description = "Transmutar 1x Primal Fire + 1x Primal Water + 1x Primal Earth + 1x Primal Air + 1x Primal Mana em 1x Primal Might. Cooldown de 20h. Altíssima demanda para crafts épicos.",
                        goldPerDay = "15-30g",
                        cooldown = "20h",
                        priority = 1,
                    },
                    {
                        name = "Transmute: Earthstorm Diamond",
                        description = "Transmutar 3x Deeprock Salt + 1x Primal Earth em 1x Earthstorm Diamond. Meta gem essencial para tanks e DPS melee.",
                        goldPerDay = "10-20g",
                        cooldown = "20h",
                        priority = 2,
                    },
                    {
                        name = "Transmute: Skyfire Diamond",
                        description = "Transmutar 2x Primal Fire + 1x Primal Air em 1x Skyfire Diamond. Meta gem popular para casters e healers.",
                        goldPerDay = "10-20g",
                        cooldown = "20h",
                        priority = 2,
                    },
                },
            },
            {
                category = "Flasks e Elixirs",
                icon = "INV_Potion_117",
                methods = {
                    {
                        name = "Flask of Relentless Assault",
                        description = "+120 Attack Power por 2h. Flask mais popular entre melee DPS. Ingredientes: 10x Fel Lotus, 7x Ragveil, 3x Ancient Lichen.",
                        goldPerDay = "Variável",
                        priority = 1,
                    },
                    {
                        name = "Flask of Pure Death",
                        description = "+80 Shadow/Fire/Frost Spell Damage por 2h. Muito usada por Warlocks e Shadow Priests.",
                        goldPerDay = "Variável",
                        priority = 2,
                    },
                    {
                        name = "Flask of Mighty Restoration",
                        description = "+25 MP5 por 2h. Flask principal de healers. Sempre em demanda em dias de raid.",
                        goldPerDay = "Variável",
                        priority = 2,
                    },
                    {
                        name = "Elixir of Major Agility",
                        description = "+35 Agility e +20 Crit. Battle Elixir mais popular. Ingredientes baratos com boa margem.",
                        goldPerDay = "Variável",
                        priority = 3,
                    },
                },
            },
            {
                category = "Poções",
                icon = "INV_Potion_131",
                methods = {
                    {
                        name = "Super Mana Potion",
                        description = "Restaura 1800-3000 mana. Consumível mais usado em raids. Volume altíssimo de vendas.",
                        goldPerDay = "Variável",
                        priority = 1,
                    },
                    {
                        name = "Haste Potion",
                        description = "+400 Haste Rating por 15s. Usada por DPS para burst em bosses. Boa margem de lucro.",
                        goldPerDay = "Variável",
                        priority = 2,
                    },
                    {
                        name = "Ironshield Potion",
                        description = "+2500 Armor por 2min. Poção de tank para encounters difíceis.",
                        goldPerDay = "Variável",
                        priority = 3,
                    },
                },
            },
            {
                category = "Especialização",
                icon = "Trade_Alchemy",
                methods = {
                    {
                        name = "Transmutation Master",
                        description = "Chance de procar itens extras em transmutações. Melhor especialização para gold. Procs de Primal Might = lucro puro.",
                        goldPerDay = "Bônus passivo",
                        priority = 1,
                    },
                    {
                        name = "Elixir Master",
                        description = "Chance de procar flasks e elixirs extras. Ótimo para quem vende consumíveis de raid em volume.",
                        goldPerDay = "Bônus passivo",
                        priority = 2,
                    },
                    {
                        name = "Potion Master",
                        description = "Chance de procar poções extras. Bom volume mas menor margem por item comparado com Transmute.",
                        goldPerDay = "Bônus passivo",
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
                category = "Armas Épicas",
                icon = "INV_Sword_101",
                methods = {
                    {
                        name = "Felsteel Longblade",
                        description = "Espada 1H épica vendável. Boa para Warriors e Rogues recém-70. Requer: Felsteel Bars + Primal Fire.",
                        goldPerDay = "Variável",
                        priority = 2,
                    },
                    {
                        name = "Khorium Champion",
                        description = "Espada 2H épica. Popular entre Warriors Arms. Requer Khorium Bars + Primal Might.",
                        goldPerDay = "Variável",
                        priority = 2,
                    },
                },
            },
            {
                category = "Armaduras Vendáveis",
                icon = "INV_Chest_Plate16",
                methods = {
                    {
                        name = "Enchanted Adamantite Armor Set",
                        description = "Set de plate craftável para tanks fresh 70. Enchanted Adamantite Breastplate, Leggings e Belt sempre vendem.",
                        goldPerDay = "Variável",
                        priority = 1,
                    },
                    {
                        name = "Ragesteel Set",
                        description = "Set ofensivo para DPS plate. Ragesteel Helm, Breastplate e Gloves. Muito popular entre Warriors leveling.",
                        goldPerDay = "Variável",
                        priority = 2,
                    },
                },
            },
            {
                category = "Materiais e Conversões",
                icon = "INV_Ingot_FelSteel",
                methods = {
                    {
                        name = "Felsteel Bars",
                        description = "Smeltar Fel Iron Bar + Eternium Bar em Felsteel. Sempre em demanda para crafts de Engineering e BS.",
                        goldPerDay = "Variável",
                        priority = 1,
                    },
                    {
                        name = "Adamantite Sharpening Stones",
                        description = "Consumível de melee DPS. Vende bem antes de dias de raid. Craft simples com boa margem.",
                        goldPerDay = "5-10g",
                        priority = 3,
                    },
                },
            },
            {
                category = "Especialização",
                icon = "Trade_BlackSmithing",
                methods = {
                    {
                        name = "Weaponsmith → Swordsmith",
                        description = "Acesso a Blazefury (épica BoE) e outras armas vendáveis. Swords são as mais populares.",
                        goldPerDay = "Variável",
                        priority = 1,
                    },
                    {
                        name = "Armorsmith",
                        description = "Acesso a crafts de plate épicos. Menos popular que Weaponsmith, mas tem nicho de tanks.",
                        goldPerDay = "Variável",
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
                category = "Enchants de Alta Demanda",
                icon = "Spell_Holy_GreaterHeal",
                methods = {
                    {
                        name = "Mongoose (Weapon)",
                        description = "+120 Agility proc + Minor Haste. O enchant mais caro e procurado do TBC. Cobra tip generosa.",
                        goldPerDay = "15-40g por enchant",
                        priority = 1,
                    },
                    {
                        name = "Savagery (2H Weapon)",
                        description = "+70 Attack Power. Muito popular para Warriors Arms e Hunters. Materiais relativamente baratos.",
                        goldPerDay = "5-15g por enchant",
                        priority = 2,
                    },
                    {
                        name = "Major Spellpower (Weapon)",
                        description = "+40 Spell Damage. Enchant padrão de casters. Sempre em demanda.",
                        goldPerDay = "8-20g por enchant",
                        priority = 1,
                    },
                    {
                        name = "Soulfrost / Sunfire (Weapon)",
                        description = "+54 Shadow/Frost ou +50 Arcane/Fire Spell Damage. Enchants premium de Sunwell recipes.",
                        goldPerDay = "20-50g por enchant",
                        priority = 1,
                    },
                },
            },
            {
                category = "Enchants de Armadura",
                icon = "INV_Enchant_FormulaSuperior_01",
                methods = {
                    {
                        name = "Enchant Cloak: Subtlety / Greater Agility",
                        description = "Subtlety (-2% threat) para tanks e healers. Greater Agi para rogues e hunters. Baratos de fazer.",
                        goldPerDay = "3-8g por enchant",
                        priority = 2,
                    },
                    {
                        name = "Enchant Chest: Exceptional Stats",
                        description = "+6 All Stats. Enchant universal muito popular. Bom volume de vendas.",
                        goldPerDay = "5-12g por enchant",
                        priority = 2,
                    },
                    {
                        name = "Enchant Boots: Boar's Speed / Cat's Swiftness",
                        description = "Minor Speed + Stats. Enchants premium de boot. Recipes raros = menos competição.",
                        goldPerDay = "10-25g por enchant",
                        priority = 1,
                    },
                },
            },
            {
                category = "Disenchant para Lucro",
                icon = "INV_Enchant_EssenceArcaneSmall",
                methods = {
                    {
                        name = "Void Shatter",
                        description = "Converter 1x Void Crystal em 2x Large Prismatic Shard. Void Crystals são baratos de epics de badge. LPS valem mais.",
                        goldPerDay = "10-20g",
                        priority = 1,
                    },
                    {
                        name = "Disenchant Greens da AH",
                        description = "Comprar greens baratos (Outland ilvl 81+) e DE para Arcane Dust ou Greater Planar Essence. Calcule antes!",
                        goldPerDay = "5-15g",
                        priority = 2,
                    },
                },
            },
            {
                category = "Ring Enchants (Exclusivo)",
                icon = "INV_Jewelry_Ring_36",
                methods = {
                    {
                        name = "Enchant Ring: Spellpower / Stats / Striking",
                        description = "+12 Spell Damage, +4 All Stats, ou +2 Weapon Damage nos anéis. Apenas enchanters podem usar. Economia pessoal.",
                        goldPerDay = "Economia pessoal",
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
                category = "Extração de Primals",
                icon = "INV_Gizmo_ManaPotion",
                methods = {
                    {
                        name = "Zapthrottle Mote Extractor",
                        description = "Extrair Motes de nuvens de gás em Outland. Farm: Nagrand (Mote of Air = 1-3g cada), Zangarmarsh (Mote of Water). Exclusivo de Engineer.",
                        goldPerDay = "20-40g/hora",
                        priority = 1,
                    },
                },
            },
            {
                category = "Consumíveis",
                icon = "INV_Ammo_Bullet_05",
                methods = {
                    {
                        name = "Adamantite Shells / Bullets",
                        description = "Munição de Outland para Hunters. Vende em stacks grandes. Margem baixa mas volume alto.",
                        goldPerDay = "5-10g",
                        priority = 2,
                    },
                    {
                        name = "Khorium Scope",
                        description = "+12 Damage scope para armas ranged. Cada Hunter fresh 70 precisa de um.",
                        goldPerDay = "Variável",
                        priority = 2,
                    },
                },
            },
            {
                category = "Itens Utilitários",
                icon = "INV_Misc_Enggizmos_07",
                methods = {
                    {
                        name = "Field Repair Bot 110G",
                        description = "Repair bot portátil para raids. Guilds compram regularmente. Venda os bots prontos ou materiais.",
                        goldPerDay = "Variável",
                        priority = 2,
                    },
                    {
                        name = "Seaforium Charges",
                        description = "Abrir lock boxes e portas. Útil em dungeons. Venda como serviço para quem não tem Rogue.",
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
                        name = "Engineering Goggles (Tier Equivalente)",
                        description = "Tankatronic Goggles, Surestrike Goggles, etc. Economize gold não comprando helm de outros crafters. BoP = economia pessoal.",
                        goldPerDay = "Economia pessoal",
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
                        description = "Prospectar stacks de Adamantite Ore para obter rare gems (Living Ruby, Noble Topaz, Dawnstone, Star of Elune, Nightseye, Talasite). Lucro alto se ore barato.",
                        goldPerDay = "15-40g/hora",
                        priority = 1,
                    },
                    {
                        name = "Prospect Fel Iron Ore",
                        description = "Prospectar Fel Iron Ore para uncommon gems. Menor lucro mas ore mais barato. Bom para iniciantes.",
                        goldPerDay = "5-15g/hora",
                        priority = 3,
                    },
                },
            },
            {
                category = "Cortar Gems Raras",
                icon = "INV_Misc_Gem_FlameSpessarite_02",
                methods = {
                    {
                        name = "Delicate Living Ruby (+8 Agi)",
                        description = "Red gem mais popular para Rogues, Hunters e Ferals. Living Ruby crua → gem cortada = 5-15g lucro.",
                        goldPerDay = "Variável",
                        priority = 1,
                    },
                    {
                        name = "Runed Living Ruby (+9 Spell Damage)",
                        description = "Red gem para casters. Altíssima demanda. Design de JC Daily. Sempre vende.",
                        goldPerDay = "Variável",
                        priority = 1,
                    },
                    {
                        name = "Solid Star of Elune (+12 Stamina)",
                        description = "Blue gem universal. Tanks e qualquer um preenchendo blue socket. Volume muito alto.",
                        goldPerDay = "Variável",
                        priority = 1,
                    },
                    {
                        name = "Inscribed Noble Topaz (+4 Crit/+5 Spell)",
                        description = "Orange gem para casters. Boa margem. Muitas variantes vendáveis.",
                        goldPerDay = "Variável",
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
                        description = "+12 Agi e +3% Crit Damage. Meta gem mais popular para melee. Sempre em demanda.",
                        goldPerDay = "5-15g por gem",
                        priority = 1,
                    },
                    {
                        name = "Chaotic Skyfire Diamond",
                        description = "+12 Crit e +3% Crit Damage. Popular entre Hunters e alguns casters.",
                        goldPerDay = "5-15g por gem",
                        priority = 2,
                    },
                },
            },
            {
                category = "JC Dailies",
                icon = "INV_Misc_Note_02",
                methods = {
                    {
                        name = "Daily Quest em Shattrath",
                        description = "Faça a daily JC quest todo dia para ganhar tokens. Use tokens para comprar designs raros que outros JC não têm = monopólio!",
                        goldPerDay = "Investimento",
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
                category = "Drums (Raid Consumíveis)",
                icon = "INV_Misc_Drum_05",
                methods = {
                    {
                        name = "Drums of Battle",
                        description = "+80 Haste para o grupo por 30s. Obrigatório em raids competitivas. Cada raider LW precisa. Volume altíssimo.",
                        goldPerDay = "10-25g",
                        priority = 1,
                    },
                    {
                        name = "Drums of Restoration",
                        description = "Restaura 600 HP/mana ao grupo. Usado por healers e em progressão. Ingredientes baratos.",
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
                        description = "+8 Defense Rating. Armor kit para tanks. Vende junto com Heavy Knothide Armor Kit (+10 Stam).",
                        goldPerDay = "5-10g",
                        priority = 2,
                    },
                    {
                        name = "Nethercobra Leg Armor / Nethercleft Leg Armor",
                        description = "+50 AP/+12 Crit ou +40 Stam/+12 Agi. Leg enchants de Outland. Alta demanda constante.",
                        goldPerDay = "10-25g",
                        priority = 1,
                    },
                    {
                        name = "Clefthide Leg Armor / Cobrahide Leg Armor",
                        description = "Versão mais barata dos leg armors. Para alts e leveling. Volume alto, margem menor.",
                        goldPerDay = "5-10g",
                        priority = 2,
                    },
                },
            },
            {
                category = "Gear Craftável",
                icon = "INV_Pants_Leather_27",
                methods = {
                    {
                        name = "Heavy Clefthoof Set (Tank)",
                        description = "Set de leather para Feral Druids. Vest, Leggings, Boots. Sempre em demanda para fresh 70 druids.",
                        goldPerDay = "Variável",
                        priority = 1,
                    },
                    {
                        name = "Riding Crop",
                        description = "+10% mount speed. Todo jogador quer. Craft relativamente barato, boa margem de lucro.",
                        goldPerDay = "Variável",
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
                category = "Cooldowns Diários",
                icon = "INV_Fabric_Moonrag_Primal",
                methods = {
                    {
                        name = "Primal Mooncloth",
                        description = "Craftar em qualquer Moonwell. CD 3.8 dias (92h). Requer: 1x Bolt of Imbued Netherweave + 1x Primal Life + 1x Primal Water. Vende 20-40g cada.",
                        goldPerDay = "5-10g (média/dia)",
                        cooldown = "92h",
                        priority = 1,
                    },
                    {
                        name = "Shadowcloth",
                        description = "Craftar no Altar of Shadows em Shadowmoon Valley. CD 92h. Requer: 1x Bolt of Imbued Netherweave + 1x Primal Shadow + 1x Primal Fire.",
                        goldPerDay = "5-10g (média/dia)",
                        cooldown = "92h",
                        priority = 1,
                    },
                    {
                        name = "Spellcloth",
                        description = "Craftar no Netherstorm (altar). CD 92h. Requer: 1x Bolt of Imbued Netherweave + 1x Primal Mana + 1x Primal Fire.",
                        goldPerDay = "5-10g (média/dia)",
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
                        description = "Bag mais vendida do jogo. Todo alt precisa de 4. Craft simples: 1x Bolt of Netherweave (4x Netherweave Cloth). Volume enorme.",
                        goldPerDay = "5-15g",
                        priority = 1,
                    },
                    {
                        name = "Imbued Netherweave Bag (18 slots)",
                        description = "Upgrade para mains. Mais cara de fazer mas boa margem. 4x Bolt of Imbued Netherweave + 2x Netherweb Spider Silk.",
                        goldPerDay = "Variável",
                        priority = 2,
                    },
                    {
                        name = "Primal Mooncloth Bag (20 slots)",
                        description = "Bag maior craftável. Requer Primal Mooncloth. Margem excelente se você é Mooncloth spec.",
                        goldPerDay = "Variável",
                        priority = 2,
                    },
                },
            },
            {
                category = "Especialização",
                icon = "Trade_Tailoring",
                methods = {
                    {
                        name = "Shadoweave Tailoring",
                        description = "Produz 2x Shadowcloth por cooldown. Shadoweave set (BoP) é BiS para Warlocks. Venda Shadowcloth extras.",
                        goldPerDay = "Bônus passivo",
                        priority = 1,
                    },
                    {
                        name = "Spellfire Tailoring",
                        description = "Produz 2x Spellcloth por cooldown. Spellfire set (BoP) é BiS para Mages. Venda Spellcloth extras.",
                        goldPerDay = "Bônus passivo",
                        priority = 1,
                    },
                    {
                        name = "Mooncloth Tailoring",
                        description = "Produz 2x Primal Mooncloth por cooldown. PMC set (BoP) é BiS para Holy Priests. Venda PMC extras.",
                        goldPerDay = "Bônus passivo",
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
                category = "Herbs de Alta Demanda",
                icon = "INV_Misc_Herb_FelLotus",
                methods = {
                    {
                        name = "Fel Lotus (qualquer zona Outland)",
                        description = "Drop raro de qualquer herb de Outland. Usado em todos os Flasks. Preço alto (8-15g cada). Farme qualquer herb e ganhe Fel Lotus como bônus.",
                        goldPerDay = "Bônus aleatório",
                        priority = 1,
                    },
                    {
                        name = "Mana Thistle (Netherstorm / Blade's Edge)",
                        description = "Herb de 375 skill. Usada em Super Mana Potions e varios elixirs. Uma das herbs mais caras. Rota: Netherstorm norte e sul.",
                        goldPerDay = "30-50g/hora",
                        priority = 1,
                    },
                    {
                        name = "Nightmare Vine (Shadowmoon Valley)",
                        description = "Herb de 365 skill. Usada em Elixir of Major Shadow Power e outros. Shadowmoon Valley rota circular.",
                        goldPerDay = "25-40g/hora",
                        priority = 1,
                    },
                },
            },
            {
                category = "Rotas de Farm",
                icon = "Trade_Herbalism",
                methods = {
                    {
                        name = "Rota: Terokkar Forest (Terocone)",
                        description = "Terocone é usada em Flask of Relentless Assault e vários elixirs. Rota circular pelo centro do mapa. Menos competição que Nagrand.",
                        goldPerDay = "20-35g/hora",
                        priority = 2,
                    },
                    {
                        name = "Rota: Nagrand (Dreaming Glory)",
                        description = "Dreaming Glory + chance de Fel Lotus. Rota pelo lado oeste e norte. Combine com Mining se tiver.",
                        goldPerDay = "20-30g/hora",
                        priority = 2,
                    },
                    {
                        name = "Rota: Zangarmarsh (Ragveil + Ancient Lichen)",
                        description = "Ragveil para Flasks, Ancient Lichen dentro de dungeons (Slave Pens/Underbog). Farm de dungeon = sem competição.",
                        goldPerDay = "25-40g/hora",
                        priority = 2,
                    },
                    {
                        name = "Rota: Netherstorm (Netherbloom + Mana Thistle)",
                        description = "Duas herbs valiosas na mesma zona. Rota pelo circuito das eco-domes. Boa para voar com epic mount.",
                        goldPerDay = "30-50g/hora",
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
                category = "Minérios de Alta Demanda",
                icon = "INV_Ore_Adamantium",
                methods = {
                    {
                        name = "Adamantite Ore (Nagrand / Netherstorm)",
                        description = "Minério principal de Outland. JCs prospectam em massa. Sempre vende rápido. Nagrand tem a melhor densidade.",
                        goldPerDay = "25-45g/hora",
                        priority = 1,
                    },
                    {
                        name = "Khorium Ore (todas zonas Outland)",
                        description = "Minério raro, spawn em veios de Adamantite. Preço altíssimo (5-10g cada ore). Pegue sempre que encontrar.",
                        goldPerDay = "Bônus aleatório",
                        priority = 1,
                    },
                    {
                        name = "Fel Iron Ore (Hellfire / Zangarmarsh)",
                        description = "Minério básico de Outland. Volume alto de vendas para BS e Engineering. Hellfire rota circular rápida.",
                        goldPerDay = "15-25g/hora",
                        priority = 2,
                    },
                },
            },
            {
                category = "Rotas de Farm",
                icon = "Trade_Mining",
                methods = {
                    {
                        name = "Rota: Nagrand (Adamantite + Khorium)",
                        description = "Melhor zona para Mining. Circuito pelas montanhas e platôs. Epic flying mount recomendado. Combine com Herbalism.",
                        goldPerDay = "30-50g/hora",
                        priority = 1,
                    },
                    {
                        name = "Rota: Netherstorm (Adamantite + Khorium)",
                        description = "Segunda melhor zona. Menos competição que Nagrand. Rota circular pelas eco-domes e ruínas.",
                        goldPerDay = "25-40g/hora",
                        priority = 1,
                    },
                    {
                        name = "Rota: Shadowmoon Valley",
                        description = "Adamantite em abundância nas montanhas. Mobs high level podem ser incômodo. Boa se Nagrand e Netherstorm estão cheios.",
                        goldPerDay = "20-35g/hora",
                        priority = 2,
                    },
                },
            },
            {
                category = "Smelting para Lucro",
                icon = "Spell_Fire_FlameBlades",
                methods = {
                    {
                        name = "Smelt Felsteel (Fel Iron + Eternium)",
                        description = "Felsteel bars valem mais que os ores separados. Sempre verifique preços na AH antes de smeltar.",
                        goldPerDay = "Variável",
                        priority = 2,
                    },
                    {
                        name = "Smelt Hardened Adamantite",
                        description = "Requer Mining 375. 10x Adamantite Bar = 1x Hardened Adamantite. Usado em BS recipes épicas.",
                        goldPerDay = "Variável",
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
                category = "Couro de Alta Demanda",
                icon = "INV_Misc_Leatherscrap_11",
                methods = {
                    {
                        name = "Knothide Leather (qualquer mob Outland)",
                        description = "Couro principal de Outland. LW precisa em massa para Drums, Armor Kits e crafts. Sempre vende.",
                        goldPerDay = "15-30g/hora",
                        priority = 1,
                    },
                    {
                        name = "Thick Clefthoof Leather (Nagrand)",
                        description = "Drop dos Clefthoof em Nagrand. Usado no Heavy Clefthoof set (tank BiS). Preço premium, 2-5g cada.",
                        goldPerDay = "25-45g/hora",
                        priority = 1,
                    },
                },
            },
            {
                category = "Scales Especiais",
                icon = "INV_Misc_MonsterScales_15",
                methods = {
                    {
                        name = "Cobra Scales (Shadowmoon / Nagrand)",
                        description = "Drop de cobras em Shadowmoon Valley e Nagrand. Usadas em Nethercobra Leg Armor. Preço alto.",
                        goldPerDay = "15-30g/hora",
                        priority = 1,
                    },
                    {
                        name = "Wind Scales (Blade's Edge Mountains)",
                        description = "Drop dos Wind Serpents em Blade's Edge. Usadas em vários crafts de LW. Nicho mas consistente.",
                        goldPerDay = "10-20g/hora",
                        priority = 2,
                    },
                    {
                        name = "Nether Dragonscales (Blade's Edge / Netherstorm)",
                        description = "Drop dos Netherwing drakes e Netherdrakes. Usadas em mail gear de LW. Escassas = preço alto.",
                        goldPerDay = "10-25g/hora",
                        priority = 2,
                    },
                },
            },
            {
                category = "Rotas de Farm",
                icon = "INV_Misc_Pelt_Wolf_01",
                methods = {
                    {
                        name = "Rota: Nagrand - Clefthoof Bulls",
                        description = "Melhor farm de Skinning. Mate Clefthoof Bulls/Clefthooves perto do Nesingwary Camp. Thick Clefthoof Leather + Knothide + Primal Shadow drops.",
                        goldPerDay = "30-50g/hora",
                        priority = 1,
                    },
                    {
                        name = "Rota: Shadowmoon Valley - Cobras",
                        description = "Eclipse Point e arredores. Mate Shadow Serpents para Cobra Scales + Knothide Leather.",
                        goldPerDay = "20-35g/hora",
                        priority = 2,
                    },
                    {
                        name = "Rota: Blade's Edge - Wind Serpents",
                        description = "Bash'ir Landing e Vortex Summit. Wind Scales + Knothide. Menos competição.",
                        goldPerDay = "15-25g/hora",
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
                category = "Comidas de Raid (Alta Demanda)",
                icon = "INV_Misc_Food_CokedClam",
                methods = {
                    {
                        name = "Golden Fish Sticks (+44 Healing)",
                        description = "Buff food #1 para healers. Ingrediente: Golden Darter (pesca em Terokkar). Vende 1-3g cada. Margem excelente.",
                        goldPerDay = "10-25g/hora",
                        priority = 1,
                    },
                    {
                        name = "Spicy Crawdad (+30 Stamina)",
                        description = "Buff food #1 para tanks. Ingrediente: Furious Crawdad (pesca em Terokkar Highland). Premium price!",
                        goldPerDay = "15-35g/hora",
                        priority = 1,
                    },
                    {
                        name = "Blackened Basilisk (+23 Spell Dmg / +20 Spirit)",
                        description = "Buff food popular para casters. Ingrediente: Blackened Basilisk Meat (drop em Terokkar). Fácil de farmar.",
                        goldPerDay = "10-20g/hora",
                        priority = 1,
                    },
                },
            },
            {
                category = "Comidas de Agility/AP",
                icon = "INV_Misc_Food_99",
                methods = {
                    {
                        name = "Warp Burger (+20 Agility / +20 Spirit)",
                        description = "Buff food popular para Rogues, Hunters e Ferals. Ingrediente: Warped Flesh (drop de Warp Stalkers em Terokkar).",
                        goldPerDay = "8-15g/hora",
                        priority = 2,
                    },
                    {
                        name = "Grilled Mudfish (+20 Agility / +20 Spirit)",
                        description = "Alternativa ao Warp Burger. Ingrediente: Figluster's Mudfish (pesca em Nagrand). Menos farmar = mais pescar.",
                        goldPerDay = "8-15g/hora",
                        priority = 2,
                    },
                    {
                        name = "Ravager Dogs (+40 AP / +20 Spirit)",
                        description = "Buff food para melee DPS. Ingrediente: Ravager Flesh (drop em Hellfire Peninsula). Zone de baixo nível = fácil.",
                        goldPerDay = "5-12g/hora",
                        priority = 3,
                    },
                },
            },
            {
                category = "Dica Extra",
                icon = "INV_Misc_Food_15",
                methods = {
                    {
                        name = "Venda em dias de Raid",
                        description = "Terça e Quarta (reset de raid) são os melhores dias para vender buff food. Preços sobem 50-100%. Stocke antes!",
                        goldPerDay = "Dica",
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
                category = "Peixes de Alta Demanda",
                icon = "INV_Misc_Fish_30",
                methods = {
                    {
                        name = "Furious Crawdad (Terokkar Highland Pools)",
                        description = "Pesque em Highland Mixed Schools em Terokkar Forest (requer flying). Usado em Spicy Crawdad (+30 Stam). 3-8g por stack.",
                        goldPerDay = "20-40g/hora",
                        priority = 1,
                    },
                    {
                        name = "Golden Darter (Terokkar Forest)",
                        description = "Pesque nos rios de Terokkar. Usado em Golden Fish Sticks (+44 Healing). Vende bem e é fácil de pescar.",
                        goldPerDay = "15-25g/hora",
                        priority = 1,
                    },
                    {
                        name = "Enormous Barbed Gill Trout",
                        description = "Pesque em Outland open water. Usado em vários consumíveis. Bom complemento enquanto procura pools.",
                        goldPerDay = "10-15g/hora",
                        priority = 3,
                    },
                },
            },
            {
                category = "Farm de Primals",
                icon = "INV_Elemental_Primal_Water",
                methods = {
                    {
                        name = "Mote of Water (Nagrand Fishing Pools)",
                        description = "Pesque em Pure Water pools em Nagrand. 10 Motes = 1 Primal Water (12-20g). Excelente gold/hora com voar.",
                        goldPerDay = "20-35g/hora",
                        priority = 1,
                    },
                    {
                        name = "Steam Pump Flotsam (Zangarmarsh)",
                        description = "Pesque nos pools de Steam Pump em Zangarmarsh. Chance de peixes valiosos + motes.",
                        goldPerDay = "10-20g/hora",
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
                        description = "Chance rara de pescar em Highland Mixed Schools em Terokkar. 3 wishes: pet, potions, ou 5x Furious Crawdad. Pet = centenas de gold!",
                        goldPerDay = "Sorte!",
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
                category = "Uso Prático",
                icon = "Spell_Holy_SealOfSacrifice",
                methods = {
                    {
                        name = "Heavy Netherweave Bandage",
                        description = "Cura 3400 HP em 8s. Essencial para classes sem heal (Warriors, Rogues). Economize gold em potions de heal usando bandages em quests e farming.",
                        goldPerDay = "Economia pessoal",
                        priority = 1,
                    },
                    {
                        name = "Vender Serviço de Craft",
                        description = "Muitos jogadores não upam First Aid. Ofereça bandages craftadas para guildmates em troca de tip.",
                        goldPerDay = "1-3g",
                        priority = 3,
                    },
                },
            },
        },
    },
}
