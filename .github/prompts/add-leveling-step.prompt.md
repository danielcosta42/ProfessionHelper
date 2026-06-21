---
description: "Add a leveling step to a profession's levelingGuide. Use when: adding WotLK/Cata content, fixing a recipe range, improving material counts, or adding a tip to an existing step."
---

# Add Leveling Guide Step

## Variables

- `profession`: Profession name (e.g. `Alchemy`, `Inscription`)
- `start_skill`: Skill level where this step begins
- `end_skill`: Skill level where this step ends (MUST equal the recipe's `grey` value)
- `recipe_name`: Name of the recipe to craft
- `craft_count`: Estimated total crafts needed

---

## Step 1 — READ

1. Open `Data/{profession}.lua`
2. Read the `recipes` table — find the recipe's exact `grey` value
3. Confirm that `end_skill` = `grey` value of the recipe
4. Check what the NEXT step's recipe is and verify it becomes orange at or before `end_skill`
5. Read the surrounding steps to understand continuity

---

## Step 2 — CREATE

Before writing:
- Verify `end_skill` matches the recipe's `grey` threshold in the `recipes` table
- Calculate materials: `count = craft_count × mats_per_craft` (add ~10% buffer)
- Decide if a `tip` locale key is needed (add it first if so)
- If the step uses TBC/WotLK trainer, confirm correct `source` value

---

## Step 3 — WRITE

### 3a. Add locale tip key (if needed)

In `Locales/Locales.lua`, add to all 3 blocks:
```lua
["${PROFESSION}_TIP_${start_skill}_${end_skill}"] = "...",
```

### 3b. Add the step to `Data/{profession}.lua`

```lua
{
    range     = {${start_skill}, ${end_skill}},
    recipe    = "${recipe_name}",
    count     = ${craft_count},
    materials = {
        { name = "MaterialName", count = ${craft_count * mats_per_craft} },
    },
    source    = "Trainer",
    tip       = ProfessionHelper.L["${PROFESSION}_TIP_${start_skill}_${end_skill}"],
},
```

---

## Critical Invariants

```
range[2] MUST equal recipes[recipe].grey
```

If a gap exists between `range[2]` of one step and `orange` of the next recipe, add an overlap step using the later recipe starting from its `orange` value.

Example — gap at 260:
- Recipe A grey = 260
- Recipe B orange = 255 (already craftable)
- Solution: Step A ends at 260, Step B starts at 260 (use B from 260 onward)

---

## Validation Checklist

- [ ] `range[2]` matches the recipe's `grey` value in the `recipes` table
- [ ] Materials count = `craft_count × materials_per_craft` (check creates = N)
- [ ] `source` uses a value from the standard vocabulary
- [ ] Locale tip key added to all 3 language blocks (if tip field used)
- [ ] Step inserted in correct skill-order position in levelingGuide array
- [ ] No gap between this step's `range[2]` and next step's `range[1]`
