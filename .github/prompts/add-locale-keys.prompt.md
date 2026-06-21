---
description: "Add one or more locale keys to ProfessionHelper. Use when: adding new user-visible strings, translating existing keys, or fixing missing translations in ptBR/enUS/esES."
---

# Add Locale Keys

## Variables

- `key_name`: The locale key in SCREAMING_SNAKE_CASE (e.g. `MINING_TIP_375_425`)
- `ptBR_value`: Portuguese (Brazil) text — primary language, must be most complete
- `enUS_value`: English text
- `esES_value`: Spanish text

---

## Step 1 — READ

1. Open `Locales/Locales.lua`
2. Search for the nearest existing key in the same category (e.g. search for `MINING_TIP_` if adding a Mining tip)
3. Confirm the key does NOT already exist in any of the three blocks
4. Read `.github/instructions/data-schema.instructions.md` → "Locale Key Naming Convention"

---

## Step 2 — CREATE

Determine the correct key name using this pattern:

| Context | Pattern | Example |
|---|---|---|
| Profession leveling tip | `PROFNAME_TIP_start_end` | `INSCRIPTION_TIP_225_260` |
| Farm location route | `PROFNAME_LOC_N_ROUTE` | `MINING_LOC_34_ROUTE` |
| Farm location tip | `PROFNAME_LOC_N_TIP` | `MINING_LOC_34_TIP` |
| UI label | `MODULE_LABEL_DESCRIPTION` | `FARM_LABEL_GOLD_PER_HOUR` |
| Slash command help | `CMD_HELP_COMMAND` | `CMD_HELP_FARM` |

---

## Step 3 — WRITE

Add the key to ALL THREE blocks in the same relative position within each block.

### In `Locales.ptBR`:
```lua
["${key_name}"] = "${ptBR_value}",
```

### In `Locales.enUS`:
```lua
["${key_name}"] = "${enUS_value}",
```

### In `Locales.esES`:
```lua
["${key_name}"] = "${esES_value}",
```

Then reference the key in code:
```lua
tip = ProfessionHelper.L["${key_name}"],
```

---

## Rules

- Never add a key to only one language block — always add to all three
- If a translation is not available, use the enUS value as fallback (not empty string)
- Keys are final — do not rename existing keys without a global search & replace
- Tip strings should be action-oriented and player-helpful, not generic
