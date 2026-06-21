# ProfessionHelper — Data Schema

> Version: 1.17.1  
> This document is the authoritative reference for all `Data/*.lua` files.

---

## Table of Contents

1. [Top-Level Profession Object](#1-top-level-profession-object)
2. [Trainer Block](#2-trainer-block)
3. [Recipe Entry](#3-recipe-entry)
4. [Leveling Guide Step](#4-leveling-guide-step)
5. [Skill Ranges (Gathering)](#5-skill-ranges-gathering)
6. [Farming Locations](#6-farming-locations)
7. [Milling Guide (Inscription)](#7-milling-guide-inscription)
8. [Ink Trader (Inscription)](#8-ink-trader-inscription)
9. [Synergies Block](#9-synergies-block)
10. [Combo Data Files](#10-combo-data-files)
11. [Materials File (Data/Materials.lua)](#11-materials-file)
12. [Locale Key Naming Convention](#12-locale-key-naming-convention)

---

## 1. Top-Level Profession Object

**File**: `Data/{ProfessionName}.lua`  
**Global key**: `ProfessionHelper.{ProfessionName}`

```lua
ProfessionHelper.ProfessionName = {
    name    = "ProfessionName",              -- string, English display name
    type    = "crafting",                    -- string, see valid values below

    trainer = { ... },                       -- see section 2

    -- Crafting professions only:
    recipes       = { ... },                 -- see section 3
    levelingGuide = { ... },                 -- see section 4

    -- Gathering professions only:
    skillRanges      = { ... },              -- see section 5
    farmingLocations = { ... },              -- see section 6

    -- Inscription only:
    millingGuide = { ... },                  -- see section 7
    inkTrader    = { ... },                  -- see section 8

    -- Optional (all professions):
    synergies = { ... },                     -- see section 9
}
```

### Valid `type` values

| Value | Description |
|---|---|
| `"crafting"` | Pure crafting (Alchemy, Blacksmithing, Engineering, etc.) |
| `"gathering"` | Pure gathering (Herbalism, Mining, Skinning, Fishing) |
| `"secondary"` | Secondary professions (Cooking, First Aid, Archaeology) |
| `"combo"` | Has both crafting and gathering elements (not currently used for base professions) |

---

## 2. Trainer Block

```lua
trainer = {
    ["Alliance"] = {
        { name = "Trainer NPC Name", zone = "Zone Name", coords = "44.2, 67.8" },
        ...
    },
    ["Horde"] = {
        { name = "Trainer NPC Name", zone = "Zone Name", coords = "52.0, 33.1" },
        ...
    },
    -- Optional shared trainers:
    ["Neutral"] = {
        { name = "Trainer NPC Name", zone = "Zone Name", coords = "48.5, 50.0" },
    },
}
```

### Trainer entry fields

| Field | Type | Required | Description |
|---|---|---|---|
| `name` | string | ✓ | Exact in-game NPC name |
| `zone` | string | ✓ | Zone display name |
| `coords` | string | ○ | `"X.X, Y.Y"` as percentage of zone map |

### Trainer tiers by expansion

| Tier name | Skill range | Notes |
|---|---|---|
| Apprentice | 1–75 | Covers all expansions |
| Journeyman | 75–150 | Covers all expansions |
| Expert | 150–225 | Not available in some zones |
| Artisan | 225–300 | Classic-era cap |
| Master | 300–375 | TBC trainers |
| Grand Master | 375–450 | WotLK trainers |
| Illustrious | 450–525 | Cata trainers |

---

## 3. Recipe Entry

Entries in the `recipes` table. Used by `RecipeTracker` and `PathCalculator`.

```lua
{
    name      = "Recipe Display Name",  -- string, matches in-game recipe name
    creates   = 1,                      -- number, items created per craft (default 1)
    orange    = 1,                      -- number, skill for orange (100% chance) threshold
    yellow    = 50,                     -- number, skill for yellow (75%+) threshold
    green     = 75,                     -- number, skill for green (50%+) threshold
    grey      = 100,                    -- number, skill where recipe becomes grey (0%)
    materials = {
        { name = "MaterialName", count = 2 },
        ...
    },
    source    = "Trainer",              -- string, see valid source values below
    faction   = nil,                    -- string | nil, "Alliance" | "Horde" if faction-specific
    minVersion = nil,                   -- number | nil, interface version requirement
}
```

### Valid `source` values

| Value | Description |
|---|---|
| `"Trainer"` | Learned from profession trainer |
| `"Drop"` | World or mob drop |
| `"Quest"` | Quest reward |
| `"Vendor: NPC Name (Zone)"` | Vendor purchase — NPC name and zone are parsed for map pins |
| `"Auction House"` | AH purchase |
| `"Reputation: FactionName Honored/Revered/Exalted"` | Reputation vendor |
| `"Crafted"` | Produced as intermediate in another recipe |
| `"World Drop"` | Any zone world drop |
| `"Engineering Only"` | Requires Engineering to use (Engineering recipes) |

---

## 4. Leveling Guide Step

Entries in the `levelingGuide` table. Used by `PathCalculator` and displayed in the UI.

```lua
{
    range     = {startSkill, endSkill},  -- {number, number}
    recipe    = "Recipe Name",           -- string, must match a key in recipes{}
    count     = 80,                      -- number, estimated total crafts needed
    materials = {
        { name = "MaterialName", count = 160 },  -- count = crafts × mat_per_craft
        ...
    },
    source    = "Trainer",               -- string, same vocabulary as recipe source
    tip       = ProfessionHelper.L["PROF_TIP_START_END"],  -- string | nil
    creates   = 1,                       -- number | nil (overrides recipe.creates if set)
}
```

### Critical invariant

```
range[2] MUST equal recipes[recipe].grey
```

If `range[2]` does not equal the recipe's `grey` threshold, the PathCalculator will produce incorrect results — either a gap in coverage or overlapping steps.

### Step count rule

```
count = crafts_needed
materials[n].count = crafts_needed × mat_per_craft
```

If a recipe creates multiple items (`creates > 1`), the effective skill gain per craft is the same, but the material usage is still per craft — not per item created.

### Source vs. recipe.source

The step's `source` field may differ from the recipe's `source` if the trainer must be visited at a higher tier. For example, an Artisan trainer recipe that continues to be craftable into Master range should have `source = "Trainer"` in the step.

---

## 5. Skill Ranges (Gathering)

Used in gathering professions (`Mining`, `Herbalism`, `Skinning`, `Fishing`).

```lua
skillRanges = {
    { skillRequired = 1,   name = "Copper Ore",       minLevel = 1,  maxLevel = 15 },
    { skillRequired = 65,  name = "Tin Ore",          minLevel = 15, maxLevel = 35 },
    { skillRequired = 125, name = "Iron Ore",         minLevel = 30, maxLevel = 50 },
    ...
}
```

### skillRanges entry fields

| Field | Type | Required | Description |
|---|---|---|---|
| `skillRequired` | number | ✓ | Minimum gathering skill to successfully gather |
| `name` | string | ✓ | Node/herb/creature name |
| `minLevel` | number | ○ | Minimum character level for the zone/mob |
| `maxLevel` | number | ○ | Maximum character level for the zone/mob |

---

## 6. Farming Locations

```lua
farmingLocations = {
    {
        skillRange = {minSkill, maxSkill},     -- {number, number}
        ore        = "Copper Ore",             -- string, primary resource (or: herb, leather)
        locations  = {
            {
                zone       = "Dun Morogh",     -- string, zone display name
                faction    = "Both",           -- string: "Both" | "Alliance" | "Horde"
                route      = ProfessionHelper.L["MINING_LOC_1_ROUTE"],
                tips       = ProfessionHelper.L["MINING_LOC_1_TIP"],
                levelRange = "1-10",           -- string, suggested character level
            },
            ...
        },
    },
    ...
}
```

### farmingLocations entry fields

| Field | Type | Required | Description |
|---|---|---|---|
| `skillRange` | `{number, number}` | ✓ | `{minSkill, maxSkill}` for when to use this tier |
| `ore` / `herb` / `leather` | string | ✓ | Primary resource name |
| `locations` | table | ✓ | Array of zone entries |

### location entry fields

| Field | Type | Required | Description |
|---|---|---|---|
| `zone` | string | ✓ | Zone name for map pin placement |
| `faction` | string | ✓ | `"Both"`, `"Alliance"`, or `"Horde"` |
| `route` | string | ○ | `PH.L[...]` locale reference for route description |
| `tips` | string | ○ | `PH.L[...]` locale reference for gathering tips |
| `levelRange` | string | ○ | `"min-max"` character level range |

---

## 7. Milling Guide (Inscription)

Used only in `Data/Inscription.lua`.

```lua
millingGuide = {
    {
        herb    = "Silverleaf",       -- string, herb name
        ink     = "Ivory Ink",        -- string, resulting ink name
        pigment = "Alabaster Pigment",-- string, intermediate pigment name
        skillRequired = 1,            -- number, Inscription skill required
        zone    = "Tirisfal Glades",  -- string | nil, best farming zone
    },
    ...
}
```

### millingGuide entry fields

| Field | Type | Required | Description |
|---|---|---|---|
| `herb` | string | ✓ | Herb that is milled |
| `ink` | string | ✓ | Resulting ink after combining pigments |
| `pigment` | string | ✓ | Pigment produced from milling |
| `skillRequired` | number | ✓ | Inscription skill needed |
| `zone` | string | ○ | Best zone to farm this herb |

---

## 8. Ink Trader (Inscription)

Used only in `Data/Inscription.lua`. Defines the NPC who trades inks.

```lua
inkTrader = {
    name  = "Jessica Sellers",  -- string, NPC name
    zone  = "Dalaran",          -- string, zone where NPC is found
    notes = "Trades all WotLK inks for Ink of the Sea",
}
```

---

## 9. Synergies Block

Describes how this profession benefits from or complements other professions. Used by the UI to display profession pairing recommendations.

```lua
synergies = {
    {
        profession = "Herbalism",             -- string, profession name
        type       = "materials",             -- string, see valid types below
        benefit    = "Provides herbs for leveling and enchanting scrolls",
    },
    {
        profession = "Enchanting",
        type       = "gold",
        benefit    = "Disenchant crafted items for materials worth selling",
    },
}
```

### synergies entry fields

| Field | Type | Required | Description |
|---|---|---|---|
| `profession` | string | ✓ | Related profession name |
| `type` | string | ✓ | Nature of the synergy (see table below) |
| `benefit` | string | ✓ | Human-readable explanation |

### Valid `type` values

| Value | Description |
|---|---|
| `"materials"` | Provides raw materials for this profession |
| `"gold"` | Creates a gold-making opportunity |
| `"leveling"` | Helps level this profession more efficiently |
| `"utility"` | Provides utility items useful while practicing this profession |
| `"combo"` | Strong two-way synergy — both professions heavily benefit each other |

---

## 10. Combo Data Files

Some `Data/` files represent cross-profession guides rather than a single profession.

| File | Content |
|---|---|
| `Data/FishingCooking.lua` | Fishing routes that yield ingredients for Cooking |
| `Data/HerbalismAlchemy.lua` | Herb farming routes optimized for Alchemy material needs |
| `Data/SkinningLeatherworking.lua` | Creature farming routes for Leatherworking mats |
| `Data/GoldFarming.lua` | General gold farming routes by zone/expansion |
| `Data/Dailies.lua` | Daily quest sources for profession-related dailies |

Combo files may use a simplified structure:

```lua
ProfessionHelper.ComboName = {
    name  = "Fishing + Cooking",
    type  = "combo",
    zones = {
        {
            zone       = "Zangarmarsh",
            fish       = "Zangarian Sporefish",
            recipe     = "Spicy Crawdad",
            skillRange = {340, 375},
            faction    = "Both",
            route      = ProfessionHelper.L["FISHING_LOC_1_ROUTE"],
            tips       = ProfessionHelper.L["FISHING_LOC_1_TIP"],
        },
        ...
    },
}
```

---

## 11. Materials File

**File**: `Data/Materials.lua`  
**Global key**: `ProfessionHelper.Materials`

```lua
ProfessionHelper.Materials = {
    ["Copper Ore"] = {
        id       = 2770,     -- number | nil, WoW item ID
        vendor   = false,    -- boolean, can be bought from a vendor
        farmable = true,     -- boolean, obtained by gathering
    },
    ["Runed Copper Rod"] = {
        id       = 6218,
        vendor   = true,
        farmable = false,
    },
    ...
}
```

### Materials entry fields

| Field | Type | Required | Description |
|---|---|---|---|
| `id` | number | ○ | WoW item ID (used for GetItemInfo) |
| `vendor` | boolean | ✓ | Sold by a vendor |
| `farmable` | boolean | ✓ | Obtained by gathering in the world |

---

## 12. Locale Key Naming Convention

All user-visible text must be declared as locale keys in `Locales/Locales.lua`.

### Key Format Table

| Context | Pattern | Example |
|---|---|---|
| Leveling tip | `PROFNAME_TIP_start_end` | `INSCRIPTION_TIP_225_260` |
| Farm route desc | `PROFNAME_LOC_N_ROUTE` | `MINING_LOC_34_ROUTE` |
| Farm location tip | `PROFNAME_LOC_N_TIP` | `MINING_LOC_34_TIP` |
| Module UI label | `MODULE_LABEL_DESCRIPTION` | `FARM_LABEL_GOLD_PER_HOUR` |
| Module UI header | `MODULE_HEADER_TITLE` | `ALTMGR_HEADER_PROFESSIONS` |
| Slash command help | `CMD_HELP_COMMAND` | `CMD_HELP_FARM` |
| Error/status message | `MODULE_MSG_DESCRIPTION` | `RECIPE_MSG_NONE_MISSING` |

### All-three-languages rule

Every key MUST appear in all three language blocks:

```lua
-- Block 1
Locales.ptBR = {
    ["MINING_TIP_375_425"] = "Mine nas minas de Cobalt em Howling Fjord ou Borean Tundra.",
    ...
}

-- Block 2
Locales.enUS = {
    ["MINING_TIP_375_425"] = "Mine Cobalt deposits in Howling Fjord or Borean Tundra.",
    ...
}

-- Block 3
Locales.esES = {
    ["MINING_TIP_375_425"] = "Mina depósitos de Cobalt en Howling Fjord o Borean Tundra.",
    ...
}
```

If a translation is unavailable, copy the enUS string as placeholder. Never use an empty string `""`.
