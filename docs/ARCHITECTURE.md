# ProfessionHelper — Architecture

> Version: 2.0  
> Addon version: 1.17.1+  
> Last updated: 2026-06-20

---

## Overview

ProfessionHelper uses a **strict five-layer architecture** inspired by clean architecture principles, adapted for WoW Lua 5.1 constraints (no modules, no require, single global namespace, TOC load order as dependency injection). Source is split into `Core/`, `Features/`, `UI/`, `Data/`, and `Locales/` subfolders.

```
┌──────────────────────────────────────────────────────────────────┐
│  Layer 5 — UI                                                    │
│  UI/Main.lua, UI/FarmTrackerUI, UI/CooldownTrackerUI,           │
│  UI/RecipeTrackerUI, UI/AltManagerUI, UI/DECalcUI,             │
│  UI/FishingAssistUI                                              │
│  Presentation only. Zero business logic. Zero DB access.         │
├──────────────────────────────────────────────────────────────────┤
│  Layer 4 — Feature Modules (Features/*.lua)                      │
│  AltManager · CooldownTracker · RecipeTracker · BagScanner       │
│  FarmTracker · PathCalculator · DECalc · TSMIntegration          │
│  GatheringGuide · MapPins · FishingAssist                       │
│  Business logic. Uses Core services. Exposes typed public APIs.  │
├──────────────────────────────────────────────────────────────────┤
│  Layer 3 — Core (Foundation Services, Core/*.lua)               │
│  Namespace · Logger · Compat · Storage(PH.DB) · Events(PH.Event)│
│  Identity(PH.Identity) · Config(PH.Config) · Init (bootstrap)   │
│  Shared infrastructure used by all Feature modules.             │
├──────────────────────────────────────────────────────────────────┤
│  Layer 2 — Data                                                  │
│  Data/Alchemy · Blacksmithing · Enchanting · Engineering        │
│  Data/Jewelcrafting · Inscription · Leatherworking · Tailoring  │
│  Data/Herbalism · Mining · Skinning · Cooking · FirstAid        │
│  Data/Fishing · Archaeology · Materials · GoldFarming · Dailies │
│  Data/FishingCooking · HerbalismAlchemy · SkinningLeatherworking│
│  Pure Lua tables. No logic. No function calls.                   │
├──────────────────────────────────────────────────────────────────┤
│  Layer 1 — Locales                                               │
│  Locales/enUS · esES · ptBR · Locales.lua                       │
│  All user-visible strings. ptBR · enUS · esES.                  │
└──────────────────────────────────────────────────────────────────┘
```

**Dependency rule**: Layer N can only depend on layers < N.  
Upper layers call down. Lower layers never call up.

---

## File Load Order (TOC)

Source of truth is `ProfessionHelper.toc`. Actual order:

```
Locales/ptBR.lua            ← Layer 1: per-locale string tables
Locales/enUS.lua
Locales/esES.lua
Locales/Locales.lua         ← Layer 1: locale selection / shared keys
Core/Namespace.lua          ← Layer 3: declares PH + sub-tables
Core/Logger.lua             ← Layer 3: PH.Logger
Core/Compat.lua             ← Layer 3: API polyfills (C_Container, etc.)
Core/Storage.lua            ← Layer 3: PH.DB
Core/Events.lua             ← Layer 3: PH.Event
Core/Identity.lua           ← Layer 3: PH.Identity
Core/Config.lua             ← Layer 3: PH.Config
Data/Materials.lua          ← Layer 2: materials index
Data/Alchemy.lua            ← Layer 2: profession data
... (all Data/*.lua files)
Features/TSMIntegration.lua  ← Layer 4: AH price service
Features/BagScanner.lua      ← Layer 4: inventory scanner
Features/RecipeTracker.lua   ← Layer 4: recipe scanner
Features/AltManager.lua      ← Layer 4: multi-char tracking
Features/DECalc.lua          ← Layer 4: DE/prospecting calc
Features/PathCalculator.lua  ← Layer 4: optimal leveling paths
Features/FarmTracker.lua     ← Layer 4: gold/item session tracker
Features/MapPins.lua         ← Layer 4: map pin system
Features/GatheringGuide.lua  ← Layer 4: route waypoints
Features/CooldownTracker.lua ← Layer 4: CD tracking
Features/FishingAssist.lua   ← Layer 4: one-button fishing assistant
Core/Init.lua               ← Layer 3: bootstrap; wires everything together
UI/Main.lua                 ← Layer 5: main window
UI/FarmTrackerUI.lua        ← Layer 5: farm session UI
UI/CooldownTrackerUI.lua    ← Layer 5: cooldown panel
UI/RecipeTrackerUI.lua      ← Layer 5: recipe tracking UI
UI/AltManagerUI.lua         ← Layer 5: alt management UI
UI/DECalcUI.lua             ← Layer 5: DE/prospect calculator UI
UI/FishingAssistUI.lua      ← Layer 5: fishing assistant UI
```

---

## Layer 3 — Core Services

### PH.DB — Database Service (`Core/Storage.lua`)

Centralizes all access to `ProfessionHelperDB`.

| Method | Signature | Description |
|---|---|---|
| `Initialize` | `()` | Seed root defaults, ensure sub-table roots, then `Migrate()`. Called once in `ADDON_LOADED`. |
| `Get` | `(path: string) → any` | Read a value by dot-path. Returns nil if any segment missing. |
| `Set` | `(path: string, value: any)` | Write a value, creating intermediate tables if needed. |
| `Ensure` | `(path: string)` | Ensure table exists at path (creates if absent). |
| `Migrate` | `()` | Run pending schema migrations up to `SCHEMA_VERSION`. |

**Schema versioning**: `ProfessionHelperDB._schemaVersion` tracks the current version.  
Each breaking change bumps `PH.DB.SCHEMA_VERSION` and adds a migration function.

### PH.Event — Event Bus (`Core/Events.lua`)

Centralized WoW event subscription. One shared frame for all events.

| Method | Signature | Description |
|---|---|---|
| `On` | `(event, callback, owner)` | Subscribe. `owner` is a string for deregistration. |
| `Off` | `(owner)` | Unsubscribe all handlers registered by `owner`. |
| `Fire` | `(internalEvent, ...)` | Dispatch an internal `PH_*` event to all subscribers. |
| `Initialize` | `()` | Creates the shared frame. Called once in `ADDON_LOADED`. |

**Internal events** (prefix `PH_`):

| Event | Fired when | Subscribers |
|---|---|---|
| `PH_FA_UPDATED` | FishingAssist state changes (cast/bite/loot/reset/timeout) | `FishingAssistUI` (refreshes panel) |
| `PH_FARM_STARTED` | FarmTracker:Start() called | none (no reactive subscriber) |
| `PH_FARM_STOPPED` | FarmTracker:Stop() called | none (no reactive subscriber) |
| `PH_BAG_SCANNED` | BagScanner finishes a full bag scan | none (no reactive subscriber) |
| `PH_RECIPE_SCANNED` | RecipeTracker scans a tradeskill window | none (no reactive subscriber) |
| `PH_CHAR_UPDATED` | AltManager saves new character snapshot | none (no reactive subscriber) |

> `PH_FA_UPDATED` is the only internal event currently consumed via
> `PH.Event:On`. The other `PH_*` events are fired but have no subscribers — the
> corresponding UIs refresh through direct `PH:UpdateXxxUI()` / `PH:ShowXxxUI()`
> calls rather than a reactive subscription. (There is no `PH_FARM_UPDATED`
> event — nothing fires it.)

### PH.Logger — Logging (`Core/Logger.lua`)

All addon chat output. Plain functions (dot calls), not methods.

| Function | Description |
|---|---|
| `PH.Logger.Info(msg)` | Always-shown message with `[ProfessionHelper]` prefix |
| `PH.Logger.Warn(msg)` | Non-fatal warning |
| `PH.Logger.Error(msg)` | Error the player should see |
| `PH.Logger.Debug(msg)` | Verbose; only when `PH.Config:Get("debug")` is true |

### PH.Config — Configuration (`Core/Config.lua`)

Settings access with declared defaults in `PH.Config.DEFAULTS`; values persist via `PH.DB`.

| Method | Signature | Description |
|---|---|---|
| `Get` | `(key) → any` | Read a setting; falls back to `DEFAULTS[key]` |
| `Set` | `(key, value)` | Persist a setting via `PH.DB:Set` |

### PH.Identity — Character Identity (`Core/Identity.lua`)

Single source of truth for player identity. Prevents duplication of `UnitName/GetRealmName` calls.

| Method | Signature | Description |
|---|---|---|
| `GetCharKey` | `() → string` | `"CharName-RealmName"` composite key |
| `GetCharName` | `() → string` | `UnitName("player")` |
| `GetRealmKey` | `() → string` | `GetRealmName()` |
| `GetFaction` | `() → string` | `"Alliance"` or `"Horde"` |
| `GetClass` | `() → string` | `"WARRIOR"`, `"MAGE"`, etc. (file name format) |
| `GetLevel` | `() → number` | `UnitLevel("player")` |
| `Initialize` | `()` | Caches identity on `PLAYER_LOGIN`. |

---

## Layer 4 — Feature Modules

### PH.AltManager

Saves and queries profession data for all characters on the account.

**SavedVariables path**: `ProfessionHelperDB.characters[realmKey][charName]`

| Method | Returns | Description |
|---|---|---|
| `Initialize()` | — | Sets up DB path, registers events |
| `SaveCurrentChar()` | — | Snapshots current character's professions |
| `GetAllCharsOnRealm()` | `{name, class, level, faction, lastSeen, professions}[]` | All known chars, sorted by name |
| `GetCharProfessions(charName)` | `{name, skill, maxSkill}[]` | Professions for a specific char |
| `FormatLastSeen(ts)` | `string` | Human-readable "Xd ago" / "Xh ago" |
| `GetRealmKey()` | `string` | Delegates to `PH.Identity:GetRealmKey()` |
| `GetCharName()` | `string` | Delegates to `PH.Identity:GetCharName()` |

**Events subscribed**: `SKILL_LINES_CHANGED` (re-saves after a 2s delay)  
**Events fired**: `PH_CHAR_UPDATED` (no reactive subscriber)

---

### PH.CooldownTracker

Tracks TBC/WotLK profession daily and weekly cooldowns.

**SavedVariables path**: `ProfessionHelperDB.cooldowns[charKey][cdKey]`

| Method | Returns | Description |
|---|---|---|
| `Initialize()` | — | Sets up DB path, registers UNIT_SPELLCAST_SUCCEEDED |
| `RecordCast(spellName)` | — | Checks pattern match, writes timestamp to DB |
| `GetRemainingSeconds(charKey, key)` | `number` | Seconds until CD expires (0 = ready) |
| `FormatRemaining(seconds)` | `string` | Colorized "Xd Xh" / "Xh Xm" / "Ready" |
| `GetAllForCurrentChar()` | `{key, label, category, icon, cdHours, remaining, ready}[]` | All tracked CDs for current char |

> No `GetCharKey()` delegate — the char key is read inline via `PH.Identity:GetCharKey()`.

**CD Database entries** (`CD.DATABASE`):

| key | Label | Category | CD |
|---|---|---|---|
| `transmute` | Transmute | Alchemy | 24h |
| `shadowcloth` | Shadowcloth | Tailoring | 84h |
| `spellcloth` | Spellcloth | Tailoring | 84h |
| `primal_mooncloth` | Primal Mooncloth | Tailoring | 84h |

**Events subscribed**: `UNIT_SPELLCAST_SUCCEEDED`

---

### PH.RecipeTracker

Scans the trade skill window and tracks learned recipes per character.

**SavedVariables path**: `ProfessionHelperDB.knownRecipes[charKey][profName][recipeName]`

| Method | Returns | Description |
|---|---|---|
| `Initialize()` | — | Sets up DB path, registers trade skill events |
| `ScanOpenTradeSkill()` | — | Reads all recipes from the open window |
| `IsKnown(profName, recipeName)` | `boolean` | Whether player knows the recipe |
| `GetMissingRecipes(profName, includeTrainer)` | `{name, source, orange, yellow, green, grey}[]` | Unknown recipes, non-trainer first |
| `GetProgress(profName)` | `(learned, total)` | Recipe completion count |

> No `GetCharKey()` delegate — the char key is read inline via `PH.Identity:GetCharKey()`.

**Events subscribed**: `TRADE_SKILL_SHOW`, `TRADE_SKILL_UPDATE`  
**Events fired**: `PH_RECIPE_SCANNED` (no reactive subscriber)

---

### PH.BagScanner

Counts materials owned across bags and bank.

**SavedVariables path**: `ProfessionHelperDB.inventory[charKey]`

| Method | Returns | Description |
|---|---|---|
| `Initialize()` | — | Sets up DB path, registers bag events |
| `ScanBags()` | — | Counts all items in equipped bags 0-4 |
| `ScanBank()` | — | Counts all items in bank bags 5-11 (call only when bank open) |
| `GetCount(itemName)` | `number` | Total owned (bags + bank) |
| `GetAllCounts()` | `{[itemName] = count}` | Full inventory snapshot |

> No `GetCharKey()` delegate — the char key is read inline via `PH.Identity:GetCharKey()`.

**Events subscribed**: `BAG_UPDATE_DELAYED`, `BANKFRAME_OPENED`  
**Events fired**: `PH_BAG_SCANNED` (no reactive subscriber)

---

### PH.FarmTracker

Tracks gold-per-hour and item loot during a farming session.

**State** (in-memory, not persisted):

| Field | Type | Description |
|---|---|---|
| `active` | boolean | Whether a session is running |
| `startTime` | number | `GetTime()` at session start |
| `startGold` | number | Copper at session start |
| `itemsLooted` | table | `{[name] = {count, icon, quality, unitPrice, itemID}}` |
| `rawGoldLooted` | number | Direct copper from mob drops |
| `estimatedLootValue` | number | TSM-priced loot value in copper |
| `goldSnapshots` | table | `{{time, gold}, ...}` for graph |

| Method | Returns | Description |
|---|---|---|
| `Start()` | — | Begins session, fires `PH_FARM_STARTED` |
| `Stop()` | — | Ends session, prints summary, fires `PH_FARM_STOPPED` |
| `Reset()` | — | Clears all session data |
| `Toggle()` | — | Start if inactive, Stop if active |
| `GetElapsedTime()` | `number` | Seconds since session start |
| `GetGoldEarned()` | `number` | Copper change since start |
| `GetEstimatedLootValue()` | `number` | TSM-priced loot total in copper |
| `CalculateGoldPerHour()` | `number` | Copper/hour extrapolated |
| `FormatDuration(seconds)` | `string` | `"Xh Xm Xs"` formatted string |
| `GetTopItems(limit)` | `{name, count, icon, quality, unitPrice}[]` | Most-looted items |
| `RecalcEstimatedLootValue()` | — | Recomputes from current item prices |

**Events subscribed**: `PLAYER_MONEY`, `CHAT_MSG_LOOT`, `CHAT_MSG_MONEY` (registered inside `Start()`)  
**Events fired**: `PH_FARM_STARTED`, `PH_FARM_STOPPED` (no reactive subscribers). There is no `PH_FARM_UPDATED`.

> FarmTracker has no `Initialize()`. It subscribes its events lazily inside
> `Start()` and unsubscribes via `PH.Event:Off("FarmTracker")` on `Stop()`.

---

### PH.FishingAssist

One-button fishing assistant for TBC Classic Anniversary. A secure cast button
casts Fishing; the module detects the bobber channel, auto-interacts with the
bobber, handles looting, and tracks a session. State is in-memory only.

| Method | Returns | Description |
|---|---|---|
| `Initialize()` | — | Subscribes to channel/loot/aura events; runs initial lure scan |
| `Tick()` | — | Called ~10×/s by the UI; polls bobber + enforces timeout |
| `TryAutoInteract()` | — | Targets/interacts with the fishing bobber unit |
| `EquipBestGear()` | — | Equips best fishing pole + hat from bags |
| `ScanLureBuff()` | — | Refreshes `lureName`/`lureExpiry` from player buffs |
| `GetLureRemaining()` | `number` | Seconds left on active lure |
| `GetElapsedTime()` | `number` | Session elapsed seconds |
| `GetFishPerHour()` | `number` | Extrapolated fish/hour |
| `GetBobberRemaining()` | `number` | Seconds before current bobber sinks |
| `GetBobberDuration()` | `number` | Full bobber lifetime (timer-bar scale) |
| `FormatTime(seconds)` | `string` | `"M:SS"` |
| `ResetSession()` | — | Reset counters; fires `PH_FA_UPDATED` |
| `GetAutoRecast()` | `boolean` | Current `fa_autoRecast` setting |
| `SetAutoRecast(enabled)` | — | Persist `fa_autoRecast` |
| `GetSpellName()` | `string` | Localized Fishing spell name |

**Initialized in**: `Core/Init.lua` `ADDON_LOADED` (`PH.FishingAssist:Initialize()`)  
**Opened via**: `/ph fish` → `PH:ShowFishingAssistUI()`  
**Events subscribed**: `UNIT_SPELLCAST_CHANNEL_START/_STOP`, `UNIT_SPELLCAST_FAILED`, `LOOT_OPENED`, `LOOT_CLOSED`, `UNIT_AURA`, `PLAYER_ENTERING_WORLD`  
**Events fired**: `PH_FA_UPDATED` (subscribed by `FishingAssistUI`)

---

### PH.PathCalculator

Calculates the optimal crafting path between two skill levels.

| Method | Returns | Description |
|---|---|---|
| `Calculate(profData, startSkill, targetSkill, comboSkills)` | `{steps, shoppingList, totalCost, hasPricing, ...}` or `nil` | Full crafting path with materials |

**Step entry fields**: `index, absoluteIndex, totalAbsolute, recipe, crafts, originalCrafts, skillRange, originalRange, materials[], cost, isIntermediate, laterUsage, recipeData, tier, source, tip, skill, isCurrent, isComplete`  
**Step material entry**: `{name, totalNeeded, originalNeeded, fromBank, toBuy}`  
**Shopping list**: a **sorted array** of `{name, count, needed, inInventory, isVendor, unitPrice, totalPrice, icon, id}` — vendor items last, then by total price descending (NOT a `{[name]=count}` map).

> The per-step purchase cost field is `cost` (not `totalCost`). `comboSkills`
> is a `{[skillName]=level}` map for combo professions; pass `{}` otherwise.

Uses TSM prices when available. Falls back to cache → vendor price → nil.

---

### PH.DECalc

Statistical DE output calculator for Enchanting; Prospecting for Jewelcrafting.

| Method | Returns | Description |
|---|---|---|
| `CalcDisenchant(quality, ilvl, count)` | `{name, icon, expectedQty, chance}[]` | Expected DE drops for `count` items |
| `CalcProspect(oreName, stacks)` | `{name, icon, expectedQty, rate}[]` | Expected gems from `stacks` × 5 ore (sorted desc) |
| `GetProspectableOres()` | `string[]` | Sorted list of prospectable ore names |

> `quality` is a string bucket key (`"uncommon"`/`"rare"`/`"epic"`), not a numeric
> 0–6 quality. The expected-quantity field is `expectedQty`. There is no
> `CalculateExpectedValue` method.

---

### PH.TSMIntegration (PH.TSM)

AH price integration with TSM 3/4/5, Auctionator, and 24h local cache.

| Method | Returns | Description |
|---|---|---|
| `IsAvailable()` | `"modern"\|"tsm4"\|"tsm3"\|"auctionator"\|nil` | Detect loaded AH addon |
| `GetDisplayName()` | `string\|nil` | Human-readable addon badge |
| `GetItemPrice(itemName, priceSource)` | `number\|nil` | Copper price via live addon or cache |
| `GetItemPriceByID(itemID, priceSource)` | `number\|nil` | Copper price by itemID (no name cache) |
| `FormatMoney(copper)` | `string` | Colorized `"Xg Xs Xc"` format |
| `CalculateCost(materials)` | `(totalCost, itemPrices, hasPricing)` | Total cost for a `{ {name, count}, ... }` array |

**Cache TTL**: 86400 seconds (24h)  
**Fallback chain**: Live addon → 24h cache → vendor price → nil

> `CalculateCost` takes an **array** of `{name, count}` entries (not a
> `{[itemName]=count}` map) and returns three values.

---

### PH.MapPins

Places vendor/quest/fishing pins on the world map (HereBeDragons-Pins-2.0).
Zone map IDs are built lazily; `NPC_COORDS` is file-local.

| Method | Returns | Description |
|---|---|---|
| `GetPinsForSource(sourceStr)` | `{name, zone, x, y, pinType}[]` | Parse a `Vendor:`/`Quest:` source string into pins |
| `HasPinsForSource(sourceStr)` | `boolean` | Whether any pins are known for the source |
| `ShowSourcePins(sourceStr)` | — | Parse + display pins on the world map |
| `ShowPins(list)` | — | Plot a pin list on the world map |
| `ClearPins()` | — | Remove all PH POI pins |
| `GetFishingPin(zone)` | `{...}\|nil` | Fishing-spot pin for a zone |
| `HasFishingSpot(zone)` | `boolean` | Whether a known fishing spot exists |
| `ShowFishingSpot(zone)` | — | Display the fishing-spot pin for a zone |

> There is no `Initialize`, `ShowPinsForSource`, `ClearAllPins`, or
> `GetNPCCoords`. NPC coordinates live in the file-local `NPC_COORDS` table.

---

### PH.GatherGuide (`PH.GatherGuide`)

Draws farming routes on the world map and minimap. The state table is
`PH.GatherGuide`; the public entry points are methods on `PH`.

| Method | Returns | Description |
|---|---|---|
| `PH:StartGatheringGuide(profName)` | — | Build steps, show widget, plot route |
| `PH:StopGatheringGuide()` | — | Stop, clear visuals, hide widget |
| `PH:ToggleGatheringGuide(profName)` | — | Toggle the guide for a profession |

Internal `GG` route methods (not stable public API): `BuildSteps`,
`GetCurrentStepIndex`, `UpdateRouteForStep`, `PlotRouteOnWorldMap`,
`PlotMinimapRoute`, `SetClosestWaypoint`, `AdvanceWaypoint`,
`ClearRouteDisplay`, `ClearMinimapArrow`.

**Zone routes** (`ZONE_ROUTES`): Classic + Outland zones.

> The table is `PH.GatherGuide` (not `PH.GatheringGuide`). There is no
> `Initialize`, `ShowRouteForZone`, `StartRouteNavigation`, `StopNavigation`, or
> `GetNextWaypoint`.

---

## Layer 3 — Core/Namespace.lua + Core/Init.lua

`Core/Namespace.lua` declares the `PH` global and its service sub-tables.
`Core/Init.lua` (loaded last among `Core/`) holds the profession registry,
profession/skill utility functions, the slash-command dispatcher, the minimap
button, and the `ADDON_LOADED`/`PLAYER_LOGIN` bootstrap.

### PH (global namespace)

| Member | Type | Description |
|---|---|---|
| `version` | string | `"1.17.1"` |
| `author` | string | `"Chehul @ DreamScyther-US"` |
| `interfaceVersion` | number | Runtime TOC version from `GetBuildInfo()` |
| `Professions` | table | Registry of all profession entries |
| `L` | table | Active locale table (ptBR/enUS/esES) |

> Default settings live in `PH.Config.DEFAULTS` (`Core/Config.lua`); SavedVariables
> sub-tables are seeded by `PH.DB:Initialize()` (`Core/Storage.lua`). There is no
> `PH.defaults`.

### Core Public Methods (declared in `Core/Init.lua`)

| Method | Description |
|---|---|
| `PH:GetProfessionData(name)` | Returns the data table for a named profession |
| `PH:GetLocalizedProfessionName(name)` | Returns translated profession name |
| `PH:GetPlayerProfessionLevel(name)` | Returns `(skillRank, skillMaxRank)` via skill line scan |
| `PH:CalculateMaterialsForRange(profData, start, target)` | Returns `(totalMaterials, recipes)` for a skill range |
| `PH:GetFarmingLocations(profData, currentSkill)` | Returns relevant farming locations at current skill |
| `PH:GetSkillTier(skill)` | Returns `(tierName, nextThreshold)` |
| `PH:GetMaxSkillForClient()` | Max profession skill on this client (300/375/450/525) |
| `PH:GetSkillColor(skill, orange, yellow, green, grey)` | Returns WoW color escape code |
| `PH:FormatNumber(num)` | `1500` → `"1.5k"` |
| `PH:GetMaterialInfo(name)` | Returns `(matData, sourceLabel)` |
| `PH:CreateItemLink(name)` | Returns WoW item hyperlink string |
| `PH:HandleSlashCommand(msg)` | Routes `/ph` commands |
| `PH:GetRemainingCrafts(step, currentSkill)` | Returns `(remaining, total)` for a path step |
| `PH:ToggleMainWindow()` | Shows/hides main UI frame |

> There is no `PH:InitializeDB()` (use `PH.DB:Initialize()`) and no `PH:Print()`
> (use `PH.Logger.Info/Warn/Error/Debug`).

### Bootstrap order (`Core/Init.lua`, `ADDON_LOADED` → `PLAYER_LOGIN`)

```lua
-- ADDON_LOADED:
PH.DB:Initialize()          -- seed SavedVariables + migrate
PH.Event:Initialize()       -- create the shared event frame
-- prune professions not available on this client
PH.BagScanner:Initialize()
PH.CooldownTracker:Initialize()
PH.RecipeTracker:Initialize()
PH.AltManager:Initialize()
PH.FishingAssist:Initialize()
PH:CreateMinimapButton()

-- PLAYER_LOGIN:
PH.Identity:Initialize()
PH.AltManager:SaveCurrentChar()
```

> `PH.Config`, `PH.TSM`, `PH.PathCalculator`, `PH.DECalc`, `PH.FarmTracker`,
> `PH.MapPins`, and `PH.GatherGuide` have **no** `Initialize()` — they are either
> purely functional or set themselves up lazily.

---

## SavedVariables Schema

**Root**: `ProfessionHelperDB`

```
ProfessionHelperDB = {
    _schemaVersion        = 1,          -- int, bump when schema breaks

    -- User preferences
    minimapButtonPosition = 45,         -- number, degrees
    windowScale           = 1.0,        -- number
    selectedProfession    = nil,        -- string | nil
    autoTrackMaterials    = true,       -- boolean
    showFarmingTips       = true,       -- boolean

    -- Feature module data
    ahPriceCache = {
        [itemName] = { price, source, ts }  -- 24h cache
    },
    inventory = {
        [charKey] = {
            _bags = { [itemName] = count },
            _bank = { [itemName] = count },
            [itemName] = count            -- merged total
        }
    },
    cooldowns = {
        [charKey] = {
            [cdKey] = { spellName, ts, cdHours }
        }
    },
    knownRecipes = {
        [charKey] = {
            [profName] = { [recipeName] = true }
        }
    },
    characters = {
        [realmKey] = {
            [charName] = {
                class, level, faction, lastSeen,
                professions = { { name, skill, maxSkill } }
            }
        }
    },
}
```

---

## Slash Commands

All routed through `PH:HandleSlashCommand()`.

| Command | Action |
|---|---|
| `/ph` or `/ph show` | Toggle main window |
| `/ph hide` | Hide main window |
| `/ph farm start` | Start farm session |
| `/ph farm stop` | Stop farm session |
| `/ph farm toggle` | Toggle farm session |
| `/ph farm reset` | Reset all session data |
| `/ph farm show` | Show farm tracker UI |
| `/ph farm hide` | Hide farm tracker UI |
| `/ph guide [profName]` | Toggle gathering guide for profession |
| `/ph cd` or `/ph cooldowns` | Show cooldown tracker |
| `/ph recipes [profName]` | Show recipe tracker |
| `/ph alts` | Show alt manager |
| `/ph de` or `/ph prospect` | Show DE/Prospect calculator |
| `/ph fish` or `/ph fishing` | Show fishing assistant |
| `/ph help` | Print command list |

Also `/professionhelper` is registered as a second slash alias.

---

## Version Guard Reference

| Expansion | Minimum `interfaceVersion` | Unlock |
|---|---|---|
| Classic 1.x | `11000` | Base professions |
| TBC 2.x | `20000` | Jewelcrafting, Outland content |
| WotLK 3.x | `30000` | Inscription, Death Knight |
| Cata 4.x | `40000` | Archaeology, Cata professions |
