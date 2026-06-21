---
description: "Add a new profession or combo guide to ProfessionHelper. Use when: adding profession data, creating a new Data/ file, registering a new profession in Core.lua."
---

# Add New Profession Data

## Variables

- `profession_name`: The English display name (e.g. `Jewelcrafting`)
- `profession_type`: One of `crafting`, `gathering`, `secondary`, `combo`
- `min_version`: Interface version if expansion-locked (e.g. `20000` for TBC+), or `nil`

---

## Step 1 — READ: Understand the context

Read these files before writing anything:

1. `docs/DATA-SCHEMA.md` — understand the required schema
2. `docs/ARCHITECTURE.md` — confirm this belongs in Data layer
3. `Locales/Locales.lua` — find existing locale patterns to follow
4. `Core.lua` — find the `PH.Professions` registry to add the entry
5. `Data/Alchemy.lua` (crafting) or `Data/Mining.lua` (gathering) as reference

---

## Step 2 — CREATE: Plan the data

Before writing:
- List ALL trainer NPCs with zone and faction
- List recipes with correct orange/yellow/green/grey thresholds
- List leveling guide steps where `range[2]` = recipe grey threshold
- List all locale keys needed (tip keys, location keys)
- If gathering: plan farming locations per skill tier
- If crafting + TBC+ materials: check that materials exist in `Data/Materials.lua`

---

## Step 3 — WRITE: Implement in order

### 3a. Add locale keys to `Locales/Locales.lua`

Add to ALL THREE blocks (ptBR, enUS, esES):
```
["{PROFESSION}_TIP_{startSkill}_{endSkill}"] = "..."
```

### 3b. Add materials to `Data/Materials.lua` (if new materials needed)

```lua
["New Material"] = { id = 12345, vendor = false, farmable = true },
```

### 3c. Create `Data/{ProfessionName}.lua`

Follow the schema from `docs/DATA-SCHEMA.md` exactly.

### 3d. Register in `Core.lua`

In the `PH.Professions` table, add:
```lua
{ name = "${profession_name}", data = "${profession_name}", icon = "...", type = "${profession_type}", minVersion = ${min_version} },
```

### 3e. Add to `ProfessionHelper.toc`

Add `Data/${ProfessionName}.lua` after other Data/ entries.

---

## Validation Checklist

- [ ] All locale keys added to ptBR, enUS, and esES blocks
- [ ] All `range[2]` values in levelingGuide match corresponding recipe `grey` values
- [ ] `trainer` table has both `["Alliance"]` and `["Horde"]` keys
- [ ] `type` field is one of the four valid strings
- [ ] All `source` values use the standard vocabulary from `docs/DATA-SCHEMA.md`
- [ ] File is added to `ProfessionHelper.toc` in correct position
- [ ] Profession is registered in `Core.lua` `PH.Professions` table
- [ ] If `minVersion` set: verify version guard in Core.lua matches
