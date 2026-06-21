---
description: "Add a new farming route or location to a gathering profession. Use when: adding WotLK/Cata zones, improving existing routes, or adding gathering tips for specific zones."
---

# Add Farming Route

## Variables

- `profession`: Gathering profession (`Mining`, `Herbalism`, `Skinning`, `Fishing`)
- `skill_min`: Minimum skill for this tier
- `skill_max`: Maximum skill for this tier
- `node_name`: Primary node/herb/leather name (e.g. `Cobalt Ore`, `Goldclover`)
- `zones`: List of zones with faction and level range

---

## Step 1 — READ

1. Open `Data/${profession}.lua`
2. Find the `farmingLocations` array
3. Find the last existing entry to understand numbering (e.g. `MINING_LOC_32_*` → next is `33`)
4. Check `GatheringGuide.lua` for `ZONE_ROUTES` to see if zone waypoints exist
5. Read `Locales/Locales.lua` searching for the last `${PROFESSION}_LOC_` key

---

## Step 2 — CREATE

For each new zone in your route:
1. Assign sequential index: `N = last_index + 1`
2. Plan route description (start point → loop direction → notable subzones)
3. Plan tip text (what drops, how to smelt/process, level range for mobs)
4. Decide if `GatheringGuide.lua` needs waypoints for this zone

---

## Step 3 — WRITE

### 3a. Add locale keys to all 3 blocks in `Locales/Locales.lua`

```lua
["${PROFESSION}_LOC_${N}_ROUTE"] = "Route description...",
["${PROFESSION}_LOC_${N}_TIP"]   = "Tip text...",
```

### 3b. Add farming location to `Data/${profession}.lua`

```lua
{
    skillRange = {${skill_min}, ${skill_max}},
    ore        = "${node_name}",      -- or: herb = ..., leather = ...
    locations  = {
        {
            zone       = "Zone Name",
            faction    = "Both",
            route      = ProfessionHelper.L["${PROFESSION}_LOC_${N}_ROUTE"],
            tips       = ProfessionHelper.L["${PROFESSION}_LOC_${N}_TIP"],
            levelRange = "68-72",
        },
    },
},
```

### 3c. Add waypoints to `GatheringGuide.lua` (optional but recommended)

In the `ZONE_ROUTES` table, add the zone loop:
```lua
["Zone Name"] = {
    {0.45, 0.30}, {0.55, 0.25}, ...  -- {x, y} as 0-1 zone fractions
},
```

---

## Validation Checklist

- [ ] Locale keys added to all 3 language blocks
- [ ] `skillRange` values are accurate for the node type
- [ ] `faction` is `"Both"`, `"Alliance"`, or `"Horde"` (not nil)
- [ ] `levelRange` reflects actual character level needed for the zone
- [ ] New location inserted in correct skill-order in `farmingLocations` array
