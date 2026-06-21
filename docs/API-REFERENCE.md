# ProfessionHelper — API Reference

> Version: 1.17.1  
> Last updated: 2026-06-20  
> All public functions callable from Feature or UI layers.  
> Private helpers (`local function`) are excluded.

---

## Table of Contents

1. [Global Namespace (PH)](#global-namespace-ph)
2. [PH.DB — Database Service](#phdb--database-service)
3. [PH.Event — Event Bus](#phevent--event-bus)
4. [PH.Identity — Character Identity](#phidentity--character-identity)
5. [PH.Logger — Logging](#phlogger--logging)
6. [PH.Config — Configuration](#phconfig--configuration)
7. [PH.TSM — Price Integration](#phtsm--price-integration)
8. [PH.AltManager (AM)](#phaltmanager-am)
9. [PH.CooldownTracker (CD)](#phcooldowntracker-cd)
10. [PH.RecipeTracker (RT)](#phrecipetracker-rt)
11. [PH.BagScanner (BS)](#phbagscanner-bs)
12. [PH.FarmTracker (FT)](#phfarmtracker-ft)
13. [PH.FishingAssist](#phfishingassist)
14. [PH.PathCalculator](#phpathcalculator)
15. [PH.DECalc](#phdecalc)
16. [PH.MapPins](#phmappins)
17. [PH.GatherGuide](#phgatherguide)

---

## Global Namespace (PH)

Declared in `Core/Namespace.lua`. Profession registry, lookups, slash commands
and bootstrap live in `Core/Init.lua`. The root of all addon functionality.

### Properties

| Name | Type | Description |
|---|---|---|
| `PH.version` | `string` | Addon version, e.g. `"1.17.1"` |
| `PH.author` | `string` | `"Chehul @ DreamScyther-US"` |
| `PH.interfaceVersion` | `number` | Client interface version from `GetBuildInfo()` |
| `PH.L` | `table` | Active locale string table |
| `PH.Professions` | `table` | Registry of all profession entries |

> Default settings live in `PH.Config.DEFAULTS` (`Core/Config.lua`), not on `PH`.
> SavedVariables sub-tables are seeded by `PH.DB:Initialize()` (`Core/Storage.lua`).

---

### Database initialization

There is no `PH:InitializeDB()`. SavedVariables is initialized by the storage
service `PH.DB:Initialize()` (see [PH.DB](#phdb--database-service)), called once
in the `ADDON_LOADED` bootstrap in `Core/Init.lua` before any DB access.

```lua
PH.DB:Initialize()
```

---

### PH:GetProfessionData(name)

Returns the data table for a named profession.

```lua
local profData = PH:GetProfessionData("Alchemy")
-- profData.name, profData.type, profData.recipes, profData.levelingGuide, etc.
```

**Parameters**: `name` (string) — English profession name  
**Returns**: `table` or `nil`

---

### PH:GetLocalizedProfessionName(name)

Returns the localized display name for a profession.

```lua
local label = PH:GetLocalizedProfessionName("Blacksmithing")
```

**Parameters**: `name` (string)  
**Returns**: `string`

---

### PH:GetPlayerProfessionLevel(name)

Scans skill lines to find the player's current level in a profession.

```lua
local rank, maxRank = PH:GetPlayerProfessionLevel("Mining")
```

**Parameters**: `name` (string) — English profession name  
**Returns**: `rank` (number), `maxRank` (number). Both 0 if not learned.

---

### PH:CalculateMaterialsForRange(profData, startSkill, targetSkill)

Aggregates all materials needed to level from `startSkill` to `targetSkill`.

```lua
local materials, recipes = PH:CalculateMaterialsForRange(profData, 1, 300)
-- materials = { ["Copper Bar"] = 120, ["Rough Stone"] = 60, ... }
-- recipes = { { recipe, count, ... }, ... }
```

**Parameters**:
- `profData` — profession data table from `GetProfessionData`
- `startSkill` — current skill level (number)
- `targetSkill` — desired skill level (number)

**Returns**: `materials` (table), `recipes` (table)

---

### PH:GetFarmingLocations(profData, currentSkill)

Returns farming locations appropriate for the current skill level.

```lua
local locations = PH:GetFarmingLocations(profData, 250)
-- locations = { { zone, faction, route, tips, levelRange, ... }, ... }
```

**Parameters**: `profData` (table), `currentSkill` (number)  
**Returns**: `table` of location entries

---

### PH:GetSkillTier(skill)

Maps a numeric skill to its expansion tier name.

```lua
local tierName, maxSkill = PH:GetSkillTier(300)
-- "Artisan", 300
```

**Parameters**: `skill` (number)  
**Returns**: `tierName` (string), `maxSkill` (number)

| Range | Tier | Max |
|---|---|---|
| 1–75 | Apprentice | 75 |
| 76–150 | Journeyman | 150 |
| 151–225 | Expert | 225 |
| 226–300 | Artisan | 300 |
| 301–375 | Master | 375 |
| 376–450 | Grand Master | 450 |
| 451–525 | Illustrious | 525 |

---

### PH:GetSkillColor(skill, orange, yellow, green, grey)

Returns a WoW color escape code for a recipe at the given skill level.

```lua
local color = PH:GetSkillColor(280, 260, 270, 285, 295)
-- "|cFFFF8000" (orange) if skill < orange
```

**Parameters**: All numbers  
**Returns**: Color escape string (orange/yellow/green/grey/impossible)

---

### PH:FormatNumber(num)

Abbreviates large numbers.

```lua
PH:FormatNumber(1500)   -- "1.5k"
PH:FormatNumber(25000)  -- "25k"
PH:FormatNumber(800)    -- "800"
```

**Parameters**: `num` (number)  
**Returns**: `string`

---

### PH:GetMaterialInfo(name)

Looks up material metadata from `Data/Materials.lua`.

```lua
local matData, sourceLabel = PH:GetMaterialInfo("Copper Ore")
-- matData = { id, vendor, farmable }, sourceLabel = "Farmable"
```

**Parameters**: `name` (string)  
**Returns**: `matData` (table or nil), `sourceLabel` (string)

---

### PH:CreateItemLink(name)

Returns a WoW item hyperlink for display.

```lua
local link = PH:CreateItemLink("Copper Bar")
-- "|cFF9d9d9d|Hitem:2840:...|h[Copper Bar]|h|r" or plain name if not available
```

**Parameters**: `name` (string)  
**Returns**: `string`

---

### Logging

`PH:Print(msg)` was removed in v2. All addon output now goes through the
logger module (`Core/Logger.lua`). See [PH.Logger](#phlogger--logging).

```lua
PH.Logger.Info("Session started.")
-- [ProfessionHelper] Session started.
```

---

### PH:HandleSlashCommand(msg)

Routes `/ph` slash command text to the appropriate handler.

```lua
PH:HandleSlashCommand("farm start")
PH:HandleSlashCommand("guide Mining")
```

---

### PH:GetRemainingCrafts(step, currentSkill)

Calculates how many more crafts are needed at the current skill.

```lua
local remaining, total = PH:GetRemainingCrafts(step, 270)
```

**Parameters**: `step` (table, from `PathCalculator:Calculate` result), `currentSkill` (number)  
**Returns**: `remaining` (number), `total` (number)

---

### PH:ToggleMainWindow()

Shows the main window if hidden, hides it if shown.

```lua
PH:ToggleMainWindow()
```

---

## PH.DB — Database Service

Declared in `Core/Storage.lua`. The only sanctioned way to read/write `ProfessionHelperDB`.

### PH.DB:Initialize()

Seeds `ProfessionHelperDB` with primitive root defaults, ensures all sub-table
roots (`ahPriceCache`, `inventory`, `cooldowns`, `knownRecipes`, `characters`)
exist, then runs `Migrate()`. Called once in the `ADDON_LOADED` bootstrap
(`Core/Init.lua`). Must run before any DB access.

```lua
PH.DB:Initialize()
```

---

### PH.DB:Get(path)

Reads a value from SavedVariables using dot-path notation.

```lua
local ts = PH.DB:Get("cooldowns.Chehul-Dreamscythe.transmute")
-- Returns nil safely if any segment is missing
```

**Parameters**: `path` (string)  
**Returns**: value at path, or `nil`

---

### PH.DB:Set(path, value)

Writes a value, creating intermediate tables as needed.

```lua
PH.DB:Set("cooldowns.Chehul-Dreamscythe.transmute", { ts = time(), cdHours = 24 })
```

**Parameters**: `path` (string), `value` (any)

---

### PH.DB:Ensure(path)

Ensures a table exists at path without overwriting existing data.

```lua
PH.DB:Ensure("inventory.Chehul-Dreamscythe")
-- No-op if table already exists
```

**Parameters**: `path` (string)

---

### PH.DB:Migrate()

Runs all pending schema migrations up to `PH.DB.SCHEMA_VERSION`. Called at the
end of `PH.DB:Initialize()`.

```lua
PH.DB:Migrate()
```

---

## PH.Event — Event Bus

Declared in `Core/Events.lua`. Replaces per-module `eventFrame` pattern.

### PH.Event:Initialize()

Creates the shared event frame. Must be called before `On` is used.

---

### PH.Event:On(event, callback, owner)

Subscribe to a WoW event or internal `PH_*` event.

```lua
PH.Event:On("SKILL_LINES_CHANGED", function()
    C_Timer.After(2, function() AM:SaveCurrentChar() end)
end, "AltManager")

-- The only internal PH_ event with a real subscriber is PH_FA_UPDATED,
-- consumed by FishingAssistUI to refresh its panel.
PH.Event:On("PH_FA_UPDATED", function()
    PH:UpdateFishingAssistUI()
end, "FishingAssistUI")
```

**Parameters**:
- `event` — WoW event string or `PH_*` internal event
- `callback` — `function(event, ...)` 
- `owner` — string identifier for this subscription group

---

### PH.Event:Off(owner)

Removes all event handlers registered by `owner`.

```lua
PH.Event:Off("FarmTrackerUI")
```

---

### PH.Event:Fire(internalEvent, ...)

Dispatches an internal addon event to all subscribers.

```lua
PH.Event:Fire("PH_FARM_STARTED")
PH.Event:Fire("PH_RECIPE_SCANNED", profName)
```

**Parameters**: `internalEvent` (string, must start with `PH_`), optional varargs

---

## PH.Identity — Character Identity

Declared in `Core/Identity.lua`. Single source of truth for all character-related lookups.

### PH.Identity:Initialize()

Caches player identity. Called in `PLAYER_LOGIN`.

---

### PH.Identity:GetCharKey()

```lua
local key = PH.Identity:GetCharKey()
-- "Chehul-Dreamscythe"
```

**Returns**: `string` — `"CharName-RealmName"`

---

### PH.Identity:GetCharName()

```lua
local name = PH.Identity:GetCharName()
-- "Chehul"
```

**Returns**: `string`

---

### PH.Identity:GetRealmKey()

```lua
local realm = PH.Identity:GetRealmKey()
-- "Dreamscythe"
```

**Returns**: `string`

---

### PH.Identity:GetFaction()

```lua
local faction = PH.Identity:GetFaction()
-- "Alliance" or "Horde"
```

**Returns**: `string`

---

### PH.Identity:GetClass()

```lua
local class = PH.Identity:GetClass()
-- "WARRIOR", "MAGE", etc.
```

**Returns**: `string` — localization-independent file name

---

### PH.Identity:GetLevel()

```lua
local lvl = PH.Identity:GetLevel()
```

**Returns**: `number`

---

## PH.Logger — Logging

Declared in `Core/Logger.lua`. All addon output goes through this module —
never call `print()` or `DEFAULT_CHAT_FRAME:AddMessage()` elsewhere. Note these
are plain functions (dot calls), not methods (colon calls).

### PH.Logger.Info(msg)

Always-shown gameplay message, with the `[ProfessionHelper]` prefix.

```lua
PH.Logger.Info("Session started.")
```

### PH.Logger.Warn(msg)

Unexpected but non-fatal condition.

### PH.Logger.Error(msg)

Failed operation the player should know about.

### PH.Logger.Debug(msg)

Verbose output, only printed when `PH.Config:Get("debug")` is true.

---

## PH.Config — Configuration

Declared in `Core/Config.lua`. Centralized settings access with declared
defaults in `PH.Config.DEFAULTS`. Values persist via `PH.DB`.

### PH.Config:Get(key)

Reads a setting, falling back to `PH.Config.DEFAULTS[key]` when unset.

```lua
local scale = PH.Config:Get("windowScale")   -- 1.0 default
```

**Parameters**: `key` (string)  
**Returns**: stored value, or the declared default

### PH.Config:Set(key, value)

Writes a setting (persisted in SavedVariables via `PH.DB:Set`).

```lua
PH.Config:Set("minimapButtonPosition", 90)
```

---

## PH.TSM — Price Integration

Declared in `Features/TSMIntegration.lua`.

### PH.TSM:IsAvailable()

Detects which AH price addon is loaded.

```lua
local addonType = PH.TSM:IsAvailable()
-- "modern" | "tsm4" | "tsm3" | "auctionator" | nil
```

**Returns**: `string` or `nil`

---

### PH.TSM:GetDisplayName()

Returns a human-readable badge for the active AH addon.

```lua
local badge = PH.TSM:GetDisplayName()
-- "TSM" | "Auctionator" | nil
```

**Returns**: `string` or `nil`

---

### PH.TSM:GetItemPrice(itemName, priceSource)

Fetches the current price for an item. Falls back to local 24h cache, then to vendor price.

```lua
local copper = PH.TSM:GetItemPrice("Eternal Fire", "DBMarket")
-- 50000 (copper) or nil
```

**Parameters**: `itemName` (string), `priceSource` (string, optional, default `"DBMarket"`)  
**Returns**: `number` (copper) or `nil`

---

### PH.TSM:FormatMoney(copper)

Formats a copper value as colorized gold/silver/copper.

```lua
PH.TSM:FormatMoney(123456)
-- "|cFFFFD10012|r|cFFFFD100g|r |cFFC0C0C03|r|cFFC0C0C0s|r |cFFAD8B6056|r|cFFAD8B60c|r"
```

**Returns**: `string`

---

### PH.TSM:CalculateCost(materials)

Returns the total AH cost for a materials list. The argument is an **array** of
`{name, count}` entries (not a `{[itemName] = count}` map).

```lua
local total, itemPrices, hasPricing = PH.TSM:CalculateCost({
    { name = "Copper Ore",  count = 120 },
    { name = "Rough Stone", count = 60  },
})
```

**Parameters**: `materials` — `{ {name = string, count = number}, ... }`  
**Returns**:
- `totalCost` (number, copper)
- `itemPrices` (table) — `{[name] = {unitPrice, totalPrice, count}}`
- `hasPricing` (boolean) — true if at least one item resolved to a price

---

## PH.AltManager (AM)

Declared in `Features/AltManager.lua`. Local alias `local AM = PH.AltManager`.

### AM:Initialize()

Sets up the DB path and subscribes to events.

---

### AM:SaveCurrentChar()

Snapshots the current character's professions, level, faction, and class into SavedVariables.

```lua
AM:SaveCurrentChar()
```

---

### AM:GetAllCharsOnRealm()

Returns all known characters on the current realm.

```lua
local chars = AM:GetAllCharsOnRealm()
-- { { name, class, level, faction, lastSeen, professions[] }, ... }
```

**Returns**: `table[]` sorted by character name

---

### AM:GetCharProfessions(charName)

Returns saved professions for a named character.

```lua
local profs = AM:GetCharProfessions("Chehul")
-- { { name = "Alchemy", skill = 375, maxSkill = 375 }, ... }
```

**Parameters**: `charName` (string)  
**Returns**: `{name, skill, maxSkill}[]`

---

### AM:FormatLastSeen(ts)

Formats a Unix timestamp as a human-readable age.

```lua
AM:FormatLastSeen(1714000000)
-- "2d ago" | "5h ago" | "Just now"
```

**Returns**: `string`

---

### AM:GetRealmKey()

Delegates to `PH.Identity:GetRealmKey()`.

---

### AM:GetCharName()

Delegates to `PH.Identity:GetCharName()`.

---

## PH.CooldownTracker (CD)

Declared in `Features/CooldownTracker.lua`. Local alias `local CD = PH.CooldownTracker`.

### CD:Initialize()

Sets up the DB path and subscribes to `UNIT_SPELLCAST_SUCCEEDED`.

---

### CD:RecordCast(spellName)

Checks if `spellName` matches a tracked cooldown, then records the timestamp.

```lua
CD:RecordCast("Transmute: Primal Might")
```

---

### CD:GetRemainingSeconds(charKey, key)

Returns seconds until a cooldown expires.

```lua
local secs = CD:GetRemainingSeconds("Chehul-Dreamscythe", "transmute")
-- 0 = ready, > 0 = remaining
```

**Returns**: `number`

---

### CD:FormatRemaining(seconds)

Returns a colorized time string.

```lua
CD:FormatRemaining(3600)
-- "|cFFFF4444|1h 0m|r"
CD:FormatRemaining(0)
-- "|cFF44FF44Ready|r"
```

**Returns**: `string`

---

### CD:GetAllForCurrentChar()

Returns all tracked cooldowns for the logged-in character.

```lua
local cds = CD:GetAllForCurrentChar()
--[[
{
  { key, label, category, icon, cdHours, remaining, ready },
  ...
}
]]
```

**Returns**: `table[]`

> The character key is obtained inline via `PH.Identity:GetCharKey()`; this
> module does not expose a `GetCharKey` delegate.

---

## PH.RecipeTracker (RT)

Declared in `Features/RecipeTracker.lua`. Local alias `local RT = PH.RecipeTracker`.

### RT:Initialize()

Sets up the DB path and subscribes to trade skill events.

---

### RT:ScanOpenTradeSkill()

Reads all recipes from the currently open trade skill window and saves to DB.

```lua
RT:ScanOpenTradeSkill()
```

---

### RT:IsKnown(profName, recipeName)

Returns whether the logged-in character knows a specific recipe.

```lua
if RT:IsKnown("Alchemy", "Elixir of the Mongoose") then ... end
```

**Parameters**: `profName` (string), `recipeName` (string)  
**Returns**: `boolean`

---

### RT:GetMissingRecipes(profName, includeTrainer)

Returns unknown recipes for the given profession.

```lua
local missing = RT:GetMissingRecipes("Alchemy", false)
-- { { name, source, orange, yellow, green, grey }, ... }
```

**Parameters**:
- `profName` — English profession name
- `includeTrainer` — if `false`, excludes trainer-only recipes

**Returns**: `table[]`

---

### RT:GetProgress(profName)

Returns recipe completion stats.

```lua
local learned, total = RT:GetProgress("Alchemy")
-- 88, 120
```

**Returns**: `learned` (number), `total` (number)

> The character key is obtained inline via `PH.Identity:GetCharKey()`; this
> module does not expose a `GetCharKey` delegate.

---

## PH.BagScanner (BS)

Declared in `Features/BagScanner.lua`. Local alias `local BS = PH.BagScanner`.

### BS:Initialize()

Sets up the DB path and subscribes to bag update events.

---

### BS:ScanBags()

Counts all items in equipped bags 0–4. Fires `PH_BAG_SCANNED`.

```lua
BS:ScanBags()
```

---

### BS:ScanBank()

Counts all items in bank bags 5–11. Only meaningful when the bank frame is open.

```lua
BS:ScanBank()
```

---

### BS:GetCount(itemName)

Returns total owned count (bags + bank) for a named item.

```lua
local count = BS:GetCount("Copper Ore")
```

**Returns**: `number`

---

### BS:GetAllCounts()

Returns the full current inventory snapshot.

```lua
local inv = BS:GetAllCounts()
-- { ["Copper Ore"] = 240, ["Tin Ore"] = 60, ... }
```

**Returns**: `{[itemName] = count}`

> The character key is obtained inline via `PH.Identity:GetCharKey()`; this
> module does not expose a `GetCharKey` delegate.

---

## PH.FarmTracker (FT)

Declared in `Features/FarmTracker.lua`. Local alias `local FT = PH.FarmTracker`.

### FT:Start()

Begins a farming session. Records start time and start gold. Fires `PH_FARM_STARTED`.

---

### FT:Stop()

Ends the session and prints a summary to chat. Fires `PH_FARM_STOPPED`.

---

### FT:Reset()

Clears all in-memory session data without stopping.

---

### FT:Toggle()

Calls `Start()` if not active, `Stop()` if active.

---

### FT:GetElapsedTime()

```lua
local secs = FT:GetElapsedTime()
```

**Returns**: `number` (seconds) or `0` if no session

---

### FT:GetGoldEarned()

```lua
local copper = FT:GetGoldEarned()
```

**Returns**: `number` (copper change since session start)

---

### FT:GetEstimatedLootValue()

```lua
local copper = FT:GetEstimatedLootValue()
```

**Returns**: `number` (TSM-priced total loot value in copper)

---

### FT:CalculateGoldPerHour()

```lua
local copperPerHour = FT:CalculateGoldPerHour()
```

**Returns**: `number`

---

### FT:FormatDuration(seconds)

```lua
FT:FormatDuration(3700)
-- "1h 1m 40s"
```

**Returns**: `string`

---

### FT:GetTopItems(limit)

Returns the most-looted items by total count.

```lua
local items = FT:GetTopItems(5)
-- { { name, count, icon, quality, unitPrice }, ... }
```

**Parameters**: `limit` (number, optional, default 10)  
**Returns**: `table[]`

---

### FT:RecalcEstimatedLootValue()

Forces a re-price of all looted items using current TSM prices.

---

## PH.FishingAssist

Declared in `Features/FishingAssist.lua` (UI in `UI/FishingAssistUI.lua`). Local
alias `local M = PH.FishingAssist`. One-button fishing assistant for TBC Classic
Anniversary: a secure cast button casts Fishing, the module detects the bobber
channel, auto-interacts with the bobber, and tracks a session.

Initialized in the `ADDON_LOADED` bootstrap via `PH.FishingAssist:Initialize()`
(`Core/Init.lua`). Opened with `/ph fish` (`PH:ShowFishingAssistUI()`). State
changes fire the internal event `PH_FA_UPDATED`, which `FishingAssistUI`
subscribes to in order to refresh.

### M:Initialize()

Subscribes (once) to the fishing channel / loot / aura events through the event
bus and runs an initial lure scan.

### M:Tick()

Called ~10×/s by the UI's `OnUpdate`. While waiting on a bobber it polls
`TryAutoInteract()` and enforces the bobber timeout safety net.

### M:TryAutoInteract()

Targets / interacts with the fishing bobber unit (rate-limited to ~0.4s).

### M:EquipBestGear()

Equips the best available fishing pole (slot 16) and fishing hat (slot 1) found
in bags. No-op in combat.

### M:ScanLureBuff()

Refreshes `M.lureName` / `M.lureExpiry` from the player's active lure buffs.

### M:GetLureRemaining()

**Returns**: `number` — seconds remaining on the active lure (0 if none).

### M:GetElapsedTime()

**Returns**: `number` — seconds since the session started (0 if inactive).

### M:GetFishPerHour()

**Returns**: `number` — extrapolated fish/hour (0 until 10s elapsed).

### M:GetBobberRemaining()

**Returns**: `number` — seconds left before the current bobber sinks (0 if not waiting).

### M:GetBobberDuration()

**Returns**: `number` — full bobber lifetime in seconds (used to scale the UI timer bar).

### M:FormatTime(seconds)

**Returns**: `string` — `"M:SS"` formatted time.

### M:ResetSession()

Resets all session counters and state to idle; fires `PH_FA_UPDATED`.

### M:GetAutoRecast()

**Returns**: `boolean` — current `fa_autoRecast` setting.

### M:SetAutoRecast(enabled)

Persists the `fa_autoRecast` setting via `PH.Config:Set`.

### M:GetSpellName()

**Returns**: `string` — localized Fishing spell name used for casting.

> In-memory state fields (never persisted): `state` (`"idle"`/`"casting"`/`"waiting"`/`"looting"`),
> `sessionActive`, `fishCaught`, `totalCasts`, `lureName`, `lureExpiry`.

---

## PH.PathCalculator

Declared in `Features/PathCalculator.lua`.

### PH.PathCalculator:Calculate(profData, startSkill, targetSkill, comboSkills)

Calculates the optimal crafting path.

```lua
local result = PH.PathCalculator:Calculate(profData, 1, 375, {})
--[[
result = {
    steps = {
        {
            index, absoluteIndex, totalAbsolute,
            recipe, crafts, originalCrafts,
            skillRange   = { effectiveStart, effectiveEnd },
            originalRange = { guideStart, guideEnd },
            materials = {
                { name, totalNeeded, originalNeeded, fromBank, toBuy },
                ...
            },
            cost,            -- copper for this step's purchases
            isIntermediate,
            tier, source, tip, skill,
            isCurrent, isComplete,
        },
        ...
    },
    -- shoppingList is a SORTED ARRAY (not a [name]=count map),
    -- vendor items last, then by total price descending:
    shoppingList = {
        { name, count, needed, inInventory, isVendor,
          unitPrice, totalPrice, icon, id },
        ...
    },
    totalCost    = number,   -- copper, after inventory discount
    hasPricing   = boolean,
    startSkill, targetSkill, professionName,
}
]]
```

**Parameters**:
- `profData` — profession data table
- `startSkill` — current skill (number)
- `targetSkill` — target skill (number)
- `comboSkills` — for combo professions, a `{[skillName] = level}` map; pass `{}`
  (or omit) for single professions

**Returns**: result table (or `nil` if no leveling guide / nothing to do)

> Note the per-step purchase cost field is `cost` (not `totalCost`), and each
> `materials` entry uses `{name, totalNeeded, originalNeeded, fromBank, toBuy}`
> (not `{name, count}`).

---

## PH.DECalc

Declared in `Features/DECalc.lua`. Local alias `local DE = PH.DECalc`.

### PH.DECalc:CalcDisenchant(quality, ilvl, count)

Returns expected disenchant outputs for `count` items of a given quality bracket
and item level.

```lua
local results = DE:CalcDisenchant("uncommon", 30, 1)
-- { { name, icon, expectedQty, chance }, ... }
```

**Parameters**:
- `quality` (string) — bucket key: `"uncommon"`, `"rare"`, or `"epic"` (NOT a numeric 0–6 quality)
- `ilvl` (number)
- `count` (number, optional, default 1)

**Returns**: `{name, icon, expectedQty, chance}[]` (the expected-quantity field is `expectedQty`)

---

### PH.DECalc:CalcProspect(oreName, stacks)

Returns expected gems from prospecting `stacks` stacks of 5 ore each, sorted by
expected quantity descending.

```lua
local results = DE:CalcProspect("Copper Ore", 1)
-- { { name, icon, expectedQty, rate }, ... }
```

**Parameters**: `oreName` (string), `stacks` (number, optional, default 1)  
**Returns**: `{name, icon, expectedQty, rate}[]`

---

### PH.DECalc:GetProspectableOres()

Returns the sorted list of ore names that have prospecting data.

```lua
local ores = DE:GetProspectableOres()
-- { "Adamantite Ore", "Copper Ore", ... }
```

**Returns**: `string[]`

> There is no `CalculateExpectedValue` method.

---

## PH.MapPins

Declared in `Features/MapPins.lua`. Local alias `local MP = PH.MapPins`. Uses
HereBeDragons-Pins-2.0. Zone map IDs are built lazily on first use, and the
NPC coordinate table (`NPC_COORDS`) is file-local — there is no `Initialize`
and no `GetNPCCoords` accessor.

### MP:GetPinsForSource(sourceStr)

Parses a recipe `source` string (`"Vendor: ..."` / `"Quest: ..."`) and returns
the list of pins for known NPCs.

```lua
local pins = MP:GetPinsForSource("Vendor: Nakodu (Shattrath City) / Haalrun (Zangarmarsh)")
-- { { name, zone, x, y, pinType }, ... }
```

**Returns**: `{name, zone, x, y, pinType}[]` (empty array if none recognized)

### MP:HasPinsForSource(sourceStr)

**Returns**: `boolean` — true if any pins are known for the source string.

### MP:ShowSourcePins(sourceStr)

Parses the source string and displays its pins on the world map.

### MP:ShowPins(list)

Clears existing pins, then plots the given pin list on the world map (opens and
navigates the map to the first pin's zone).

**Parameters**: `list` — `{name, zone, x, y, pinType}[]` (as returned by `GetPinsForSource` / `GetFishingPin`)

### MP:ClearPins()

Removes all ProfessionHelper POI pins from the world map.

### MP:GetFishingPin(zone)

```lua
local pin = MP:GetFishingPin("Zangarmarsh")
-- { name, zone, x, y, pinType = "fishing" } or nil
```

**Returns**: pin table or `nil`

### MP:HasFishingSpot(zone)

**Returns**: `boolean` — true if a known fishing spot exists for the zone.

### MP:ShowFishingSpot(zone)

Displays the fishing-spot pin for a zone on the world map (no-op if unknown).

---

## PH.GatherGuide

The gathering-guide state table is `PH.GatherGuide` (alias `local GG`), declared
in `Features/GatheringGuide.lua`. The public entry points are methods on `PH`,
not on the table:

### PH:StartGatheringGuide(profName)

Builds the route steps for a gathering profession, shows the floating widget and
plots the route on the world map / minimap. Slash: `/ph guide <prof>`.

```lua
PH:StartGatheringGuide("Mining")
```

### PH:StopGatheringGuide()

Stops the guide, clears all route visuals and hides the widget.

### PH:ToggleGatheringGuide(profName)

Stops the guide if it's already running for `profName`, otherwise starts it.

---

Internal route methods on `GG` (used by the above, not a stable public API):
`GG:BuildSteps`, `GG:GetCurrentStepIndex`, `GG:UpdateRouteForStep`,
`GG:PlotRouteOnWorldMap`, `GG:PlotMinimapRoute`, `GG:SetClosestWaypoint`,
`GG:AdvanceWaypoint`, `GG:ClearRouteDisplay`, `GG:ClearMinimapArrow`.

> There is no `Initialize`, `ShowRouteForZone`, `StartRouteNavigation`,
> `StopNavigation`, or `GetNextWaypoint`.
