-- Profession Helper - Disenchant & Prospecting Calculator
-- Statistical expected output for TBC Classic DE and Prospecting operations.
--
-- Data sources:
--   Disenchant rates: based on community-verified TBC data (wowhead / tbcdb)
--   Prospecting rates: Blizzard stated 20% per gem slot, ~2 rolls per 5 ore

ProfessionHelper = ProfessionHelper or {}
local PH = ProfessionHelper

PH.DECalc = {}
local DE = PH.DECalc

-------------------------------------------------------------------------------
-- Disenchant tables
-- Format per entry:
--   { name, icon, avgQty, chance }
--   avgQty: average copper value per successful roll (use 0 if qty varies)
--   OR use { low, high } for qty ranges
--
-- Grouped by item quality and ilvl bracket.
-------------------------------------------------------------------------------

DE.DISENCHANT = {
    -- ============================================================
    -- UNCOMMON (Green) items
    -- ============================================================
    uncommon = {
        -- ilvl 1-15
        { ilvlMin=1,  ilvlMax=15,  results = {
            { name="Strange Dust",        icon="inv_enchant_dustarcane",     chance=1.00, qtyLow=1, qtyHigh=3  },
        }},
        -- ilvl 16-20
        { ilvlMin=16, ilvlMax=20,  results = {
            { name="Strange Dust",        icon="inv_enchant_dustarcane",     chance=0.75, qtyLow=1, qtyHigh=5  },
            { name="Lesser Magic Essence",icon="inv_enchant_essencemagiclarge", chance=0.25, qtyLow=1, qtyHigh=2 },
        }},
        -- ilvl 21-25
        { ilvlMin=21, ilvlMax=25,  results = {
            { name="Strange Dust",        icon="inv_enchant_dustarcane",     chance=0.75, qtyLow=2, qtyHigh=6  },
            { name="Greater Magic Essence",icon="inv_enchant_essencemagiclarge",chance=0.25, qtyLow=1, qtyHigh=2 },
        }},
        -- ilvl 26-30
        { ilvlMin=26, ilvlMax=30,  results = {
            { name="Soul Dust",           icon="inv_enchant_dustsoul",       chance=0.75, qtyLow=2, qtyHigh=6  },
            { name="Lesser Astral Essence",icon="inv_enchant_essenceastralsmall",chance=0.25, qtyLow=1, qtyHigh=2},
        }},
        -- ilvl 31-35
        { ilvlMin=31, ilvlMax=35,  results = {
            { name="Soul Dust",           icon="inv_enchant_dustsoul",       chance=0.75, qtyLow=3, qtyHigh=8  },
            { name="Greater Astral Essence",icon="inv_enchant_essenceastralsmall",chance=0.25,qtyLow=1,qtyHigh=2},
        }},
        -- ilvl 36-45
        { ilvlMin=36, ilvlMax=45,  results = {
            { name="Vision Dust",         icon="inv_enchant_dustvision",     chance=0.75, qtyLow=3, qtyHigh=8  },
            { name="Lesser Mystic Essence",icon="inv_enchant_essencemysticsmall",chance=0.25,qtyLow=1,qtyHigh=2},
        }},
        -- ilvl 46-56
        { ilvlMin=46, ilvlMax=56,  results = {
            { name="Dream Dust",          icon="inv_enchant_dustdream",      chance=0.75, qtyLow=3, qtyHigh=9  },
            { name="Lesser Nether Essence",icon="inv_enchant_essencenethersmall",chance=0.25,qtyLow=1,qtyHigh=2},
        }},
        -- ilvl 57-60
        { ilvlMin=57, ilvlMax=60,  results = {
            { name="Illusion Dust",       icon="inv_enchant_dustillusion",   chance=0.75, qtyLow=2, qtyHigh=8  },
            { name="Lesser Eternal Essence",icon="inv_enchant_essenceeternalsmall",chance=0.25,qtyLow=1,qtyHigh=2},
        }},
        -- ilvl 61-70 (TBC greens)
        { ilvlMin=61, ilvlMax=70,  results = {
            { name="Arcane Dust",         icon="inv_enchant_dustarcane_02",  chance=0.75, qtyLow=1, qtyHigh=4  },
            { name="Lesser Planar Essence",icon="inv_enchant_essenceplanarsmall",chance=0.25,qtyLow=1,qtyHigh=2},
        }},
    },

    -- ============================================================
    -- RARE (Blue) items
    -- ============================================================
    rare = {
        -- ilvl 1-20
        { ilvlMin=1,  ilvlMax=20,  results = {
            { name="Small Glimmering Shard", icon="inv_enchant_shardglimmeringsmall", chance=0.75, qtyLow=1, qtyHigh=2 },
            { name="Large Glimmering Shard", icon="inv_enchant_shardglimmeringlarge", chance=0.25, qtyLow=1, qtyHigh=1 },
        }},
        -- ilvl 21-30
        { ilvlMin=21, ilvlMax=30,  results = {
            { name="Small Glowing Shard",    icon="inv_enchant_shardglowingsmall",   chance=0.75, qtyLow=1, qtyHigh=2 },
            { name="Large Glowing Shard",    icon="inv_enchant_shardglowinglarge",   chance=0.25, qtyLow=1, qtyHigh=1 },
        }},
        -- ilvl 31-45
        { ilvlMin=31, ilvlMax=45,  results = {
            { name="Small Radiant Shard",    icon="inv_enchant_shardradiantsmall",   chance=0.75, qtyLow=1, qtyHigh=2 },
            { name="Large Radiant Shard",    icon="inv_enchant_shardradiantlarge",   chance=0.25, qtyLow=1, qtyHigh=1 },
        }},
        -- ilvl 46-60
        { ilvlMin=46, ilvlMax=60,  results = {
            { name="Small Brilliant Shard",  icon="inv_enchant_shardbrilliantsmall", chance=0.75, qtyLow=1, qtyHigh=2 },
            { name="Large Brilliant Shard",  icon="inv_enchant_shardbrilliantlarge", chance=0.25, qtyLow=1, qtyHigh=1 },
        }},
        -- ilvl 61-70 (TBC blues)
        { ilvlMin=61, ilvlMax=70,  results = {
            { name="Small Prismatic Shard",  icon="inv_enchant_shardprismaticsmall", chance=0.50, qtyLow=1, qtyHigh=2 },
            { name="Large Prismatic Shard",  icon="inv_enchant_shardprismaticsmall", chance=0.30, qtyLow=1, qtyHigh=1 },
            { name="Void Crystal",           icon="inv_enchant_voidcrystal",         chance=0.20, qtyLow=1, qtyHigh=1 },
        }},
    },

    -- ============================================================
    -- EPIC (Purple) items
    -- ============================================================
    epic = {
        -- ilvl 1-60
        { ilvlMin=1,  ilvlMax=60,  results = {
            { name="Large Brilliant Shard",  icon="inv_enchant_shardbrilliantlarge", chance=1.00, qtyLow=1, qtyHigh=1 },
        }},
        -- ilvl 61-70 (TBC epics)
        { ilvlMin=61, ilvlMax=70,  results = {
            { name="Void Crystal",           icon="inv_enchant_voidcrystal",         chance=1.00, qtyLow=1, qtyHigh=1 },
        }},
    },
}

-------------------------------------------------------------------------------
-- Prospecting tables (TBC Classic)
-- Each prospect of 5 ore does ~2 independent gem rolls.
-- Each roll has ~20% chance to produce a gem of the applicable type.
-- Rates below represent expected gems per 5 ore (i.e. per prospect).
-------------------------------------------------------------------------------

DE.PROSPECT = {
    ["Copper Ore"] = {
        { name="Malachite",       icon="inv_misc_gem_stone_01", rate=0.30 },
        { name="Tigerseye",       icon="inv_misc_gem_stone_02", rate=0.30 },
        { name="Rough Stone",     icon="inv_stone_01",          rate=0.30 },
    },
    ["Tin Ore"] = {
        { name="Shadowgem",       icon="inv_misc_gem_stone_03", rate=0.25 },
        { name="Moss Agate",      icon="inv_misc_gem_variety_01",rate=0.20 },
        { name="Lesser Moonstone",icon="inv_misc_gem_variety_01",rate=0.15 },
    },
    ["Iron Ore"] = {
        { name="Citrine",         icon="inv_misc_gem_variety_03",rate=0.25 },
        { name="Aquamarine",      icon="inv_misc_gem_aquamarine_01",rate=0.15 },
    },
    ["Mithril Ore"] = {
        { name="Aquamarine",      icon="inv_misc_gem_aquamarine_01",rate=0.20 },
        { name="Citrine",         icon="inv_misc_gem_variety_03",rate=0.20 },
        { name="Star Ruby",       icon="inv_misc_gem_ruby_02",  rate=0.15 },
    },
    ["Thorium Ore"] = {
        { name="Azerothian Diamond", icon="inv_misc_gem_diamond_01",rate=0.18 },
        { name="Blue Sapphire",    icon="inv_misc_gem_sapphire_02",rate=0.18 },
        { name="Large Opal",       icon="inv_misc_gem_opal_01",  rate=0.18 },
        { name="Huge Emerald",     icon="inv_misc_gem_emerald_01",rate=0.18 },
        { name="Arcane Crystal",   icon="inv_misc_gem_variety_01",rate=0.04 },
    },
    ["Fel Iron Ore"] = {
        { name="Flame Spessarite", icon="inv_misc_gem_flamespessarite_01",rate=0.20 },
        { name="Deep Peridot",     icon="inv_misc_gem_deepperidot_01",    rate=0.20 },
        { name="Azure Moonstone",  icon="inv_misc_gem_azuremoonstone_01", rate=0.20 },
        { name="Shadow Draenite",  icon="inv_misc_gem_shadowdraenite_01", rate=0.20 },
        { name="Golden Draenite",  icon="inv_misc_gem_goldendraenite_01", rate=0.20 },
        { name="Blood Garnet",     icon="inv_misc_gem_bloodgarnet_01",    rate=0.20 },
    },
    ["Adamantite Ore"] = {
        { name="Talasite",         icon="inv_misc_gem_talasite_01",   rate=0.20 },
        { name="Nightseye",        icon="inv_misc_gem_nightseye_01",  rate=0.20 },
        { name="Dawnstone",        icon="inv_misc_gem_dawnstone_01",  rate=0.20 },
        { name="Living Ruby",      icon="inv_misc_gem_livingruby_01", rate=0.20 },
        { name="Noble Topaz",      icon="inv_misc_gem_nobletopaz_01", rate=0.20 },
        { name="Star of Elune",    icon="inv_misc_gem_starofelune_01",rate=0.20 },
    },
    ["Khorium Ore"] = {
        { name="Talasite",         icon="inv_misc_gem_talasite_01",   rate=0.15 },
        { name="Nightseye",        icon="inv_misc_gem_nightseye_01",  rate=0.15 },
        { name="Dawnstone",        icon="inv_misc_gem_dawnstone_01",  rate=0.15 },
        { name="Living Ruby",      icon="inv_misc_gem_livingruby_01", rate=0.15 },
        { name="Noble Topaz",      icon="inv_misc_gem_nobletopaz_01", rate=0.15 },
        { name="Star of Elune",    icon="inv_misc_gem_starofelune_01",rate=0.15 },
        { name="Khorium",          icon="inv_ore_khorium_01",         rate=0.50 },  -- guaranteed 1 Khorium per prospect
    },
}

-------------------------------------------------------------------------------
-- Calculation API
-------------------------------------------------------------------------------

-- Find the DE result row for a given quality and ilvl
local function FindDERow(quality, ilvl)
    local bucket = DE.DISENCHANT[quality]
    if not bucket then return nil end
    for _, row in ipairs(bucket) do
        if ilvl >= row.ilvlMin and ilvl <= row.ilvlMax then
            return row.results
        end
    end
    return nil
end

-- Calculate expected DE output for 'count' items of given quality and ilvl
-- Returns: list of { name, icon, expectedQty }
function DE:CalcDisenchant(quality, ilvl, count)
    count = count or 1
    local results = FindDERow(quality, ilvl)
    if not results then return {} end

    local output = {}
    for _, r in ipairs(results) do
        local avgQty = (r.qtyLow + r.qtyHigh) / 2
        local expected = avgQty * r.chance * count
        table.insert(output, {
            name        = r.name,
            icon        = r.icon,
            expectedQty = expected,
            chance      = r.chance,
        })
    end
    return output
end

-- Calculate expected prospect output for 'stacks' stacks of 5 ore each
-- Returns: list of { name, icon, expectedQty }
function DE:CalcProspect(oreName, stacks)
    stacks = stacks or 1
    local gems = DE.PROSPECT[oreName]
    if not gems then return {} end

    local output = {}
    for _, g in ipairs(gems) do
        local expected = g.rate * stacks
        table.insert(output, {
            name        = g.name,
            icon        = g.icon,
            expectedQty = expected,
            rate        = g.rate,
        })
    end
    -- Sort by expected qty desc
    table.sort(output, function(a, b) return a.expectedQty > b.expectedQty end)
    return output
end

-- List available ore types for prospecting
function DE:GetProspectableOres()
    local ores = {}
    for name in pairs(DE.PROSPECT) do
        table.insert(ores, name)
    end
    table.sort(ores)
    return ores
end
