---
description: "Use when creating or editing profession data files (Data/*.lua) or locale strings (Locales/Locales.lua). Covers required fields, type rules, schema invariants, and milling/synergy structures."
applyTo: ["Data/**/*.lua", "Locales/**/*.lua"]
---

# Data Layer & Locale Schema

## Profession Data File — Top-Level Structure

Every `Data/ProfessionName.lua` must declare:

```lua
ProfessionHelper = ProfessionHelper or {}
ProfessionHelper.ProfessionName = {
    name    = "ProfessionName",    -- string, matches filename and Professions registry key
    type    = "crafting",          -- "crafting" | "gathering" | "secondary" | "combo"
    minVersion = nil,              -- number | nil (e.g. 30000 for Inscription/WotLK-only)

    trainer  = { ... },            -- see Trainer block
    synergies = { ... },           -- optional, see Synergies block

    -- CRAFTING ONLY:
    recipes       = { ... },
    levelingGuide = { ... },

    -- GATHERING ONLY:
    skillRanges      = { ... },
    farmingLocations = { ... },

    -- INSCRIPTION ONLY:
    millingGuide = { ... },
    inkTrader    = { ... },
}
```

**Rules:**
- `name` must exactly match the key used in `PH.Professions` registry in Core.lua
- No function calls inside Data files. No `PH.L[...]` in data fields (only in `tip` fields)
- `type` must be one of the four valid strings

---

## Trainer Block

```lua
trainer = {
    ["Alliance"] = {
        "TrainerName (Zone — District)",
        "TrainerName2 (Zone — Qualifier — Rank)",  -- e.g. "Grand Master"
    },
    ["Horde"] = {
        "TrainerName (Zone — District)",
    },
},
```

- Include both factions even if one has no trainer (use empty table `{}`)
- Append rank after zone for Grand Master / Illustrious trainers
- Format: `"Name (Zone — Qualifier)"` with em-dash `—` separator

---

## Recipe Entry (crafting professions)

```lua
{
    name    = "Recipe Display Name",      -- required
    creates = 1,                          -- items produced per craft (default 1)
    orange  = 210,                        -- skill where recipe turns orange (learnable)
    yellow  = 230,                        -- skill where guaranteed skill-up ends
    green   = 250,                        -- skill where occasional skill-up ends  
    grey    = 270,                        -- skill where no skill-up possible
    materials = {
        { name = "Material Name", count = 2 },
    },
    source  = "Trainer",                  -- see Source Values below
},
```

### Source Values
| Value | Meaning |
|---|---|
| `"Trainer"` | Learned from any profession trainer |
| `"Trainer (Outland)"` | Requires TBC (Master rank) trainer |
| `"Trainer (Northrend)"` | Requires WotLK (Grand Master) trainer |
| `"World Drop"` | Random world drop recipe |
| `"Drop: BossName (Instance)"` | Specific boss drop |
| `"Vendor: NPC (Zone, Faction)"` | Sold by specific vendor |
| `"Quest: QuestName"` | Reward from quest |

---

## Leveling Guide Entry (crafting professions)

```lua
{
    range     = {225, 260},          -- {startSkill, endSkill} — MUST match recipe grey threshold
    recipe    = "Recipe Display Name",
    count     = 70,                   -- estimated crafts needed (with ~10% buffer)
    materials = {
        { name = "Material Name", count = 140 },
        { name = "Other Mat",     count = 70  },
    },
    source    = "Trainer",
    tip       = ProfessionHelper.L["PROF_TIP_225_260"],  -- optional locale key
},
```

**Critical invariants:**
- `range[2]` MUST equal the `grey` value of the recipe being used
- If a recipe goes grey before the next recipe becomes orange, add an overlap step
- `count` is total crafts needed assuming 100% at orange and diminishing returns as color shifts
- `tip` field should reference a locale key — do NOT embed raw strings

---

## Skill Ranges Entry (gathering professions)

```lua
{
    ore      = "Ore Name",        -- or: herb, leather — matches material node name
    skillRequired = 350,          -- minimum skill to gather
    skillYellow   = 375,          -- skill where node turns yellow (moderate xp)
    skillGreen    = 400,          -- skill where node turns green (low xp)
    skillGrey     = 450,          -- skill where no skill-up possible
},
```

---

## Farming Location Entry (gathering professions)

```lua
{
    skillRange = {375, 425},      -- {minSkill, maxSkill} for this tier
    ore        = "Cobalt Ore",    -- or: herb = ..., leather = ...
    locations  = {
        {
            zone       = "Howling Fjord",
            faction    = "Both",          -- "Alliance" | "Horde" | "Both"
            route      = ProfessionHelper.L["MINING_LOC_34_ROUTE"],
            tips       = ProfessionHelper.L["MINING_LOC_34_TIP"],
            levelRange = "68-72",
        },
    },
},
```

---

## Milling Guide Entry (Inscription only)

```lua
{
    herbs     = "Peacebloom, Silverleaf, Earthroot",  -- comma-separated
    skillMin  = 1,
    skillMax  = 75,
    pigment   = "Alabaster Pigment",
    ink       = "Ivory Ink",
    inkCount  = 1,
    altPigment = nil,   -- secondary/rare pigment if applicable
    altInk    = nil,
},
```

---

## Ink Trader Block (Inscription only)

```lua
inkTrader = {
    name = "NPC Name",
    zone = "Zone — Sub-area",
    rate = "1 Ink of the Sea → 1 qualquer tinta (exceto Snowfall Ink)",
    tip  = "Strategy description string (plain, no locale key needed here)",
},
```

---

## Synergies Block (all professions)

```lua
synergies = {
    {
        profession = "Herbalism",    -- exact name from PH.Professions registry
        type       = "primary",      -- "primary" | "gold" | "economy"
        benefit    = "Description",  -- ptBR preferred, plain string
        tip        = "Extra detail", -- optional
        route      = "Farm route",   -- optional, for gathering pairs
    },
},
```

**Synergy types:**
- `"primary"` — direct material supply (e.g. Mining → Blacksmithing)
- `"gold"` — produces high-value items for AH (e.g. Inscription → Glyphs)
- `"economy"` — indirect benefit (e.g. dual-gather on same route)

---

## Locale File Structure

`Locales/Locales.lua` must contain three language blocks in this order:

```lua
local Locales = {}

-- ================================================================
-- PORTUGUESE (PRIMARY — most complete)
-- ================================================================
Locales.ptBR = {
    ["KEY"] = "valor",
}

-- ================================================================
-- ENGLISH
-- ================================================================
Locales.enUS = {
    ["KEY"] = "value",
}

-- ================================================================
-- SPANISH
-- ================================================================
Locales.esES = {
    ["KEY"] = "valor",
}

ProfessionHelper.L = Locales[GetLocale()] or Locales.enUS
```

### Locale Key Naming Convention

| Pattern | Example |
|---|---|
| `PROFNAME_TIP_STARTSKILL_ENDSKILL` | `MINING_TIP_375_425` |
| `PROFNAME_LOC_INDEX_TIP` | `MINING_LOC_34_TIP` |
| `PROFNAME_LOC_INDEX_ROUTE` | `MINING_LOC_34_ROUTE` |
| `PROFNAME_STEP_DESCRIPTION` | `INSCRIPTION_TIP_225_260` |
| `FEATURE_STAT_DESCRIPTION` | `FARM_STAT_GOLD_PER_HOUR` |
| `CMD_HELP_COMMAND` | `CMD_HELP_FARM` |
| `SOURCE_DISPLAY_NAME` | `SOURCE_TRAINER_OUTLAND` |

### Rules
1. ALL keys must exist in ALL three language blocks
2. If a translation is missing, copy the enUS value — never leave blank
3. Keys are `SCREAMING_SNAKE_CASE`
4. Values for tip keys should be player-facing, action-oriented text
