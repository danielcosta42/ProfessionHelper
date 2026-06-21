---
description: "Use when designing new features, adding modules, or refactoring existing code in ProfessionHelper. Covers the target layered architecture, module contracts, service APIs, and anti-patterns to avoid."
---

# Architecture Instructions

## Target Architecture (v2.0)

ProfessionHelper uses a strict layered architecture. **Never bypass layers.**

```
┌─────────────────────────────────────────────────────────────┐
│  Layer 5 — UI                                               │
│  UI/*.lua (UI/Main.lua, UI/*UI.lua)                         │
│  Presentation only. Calls Feature APIs. Never reads DB.     │
├─────────────────────────────────────────────────────────────┤
│  Layer 4 — Features (Features/*.lua)                        │
│  AltManager, CooldownTracker, RecipeTracker, BagScanner,    │
│  FarmTracker, PathCalculator, DECalc, TSMIntegration,       │
│  GatheringGuide, MapPins, FishingAssist                     │
│  Business logic. Uses services. Exposes clean public API.   │
├─────────────────────────────────────────────────────────────┤
│  Layer 3 — Core Services (Core/*.lua)                       │
│  Storage(PH.DB), Events(PH.Event), Identity(PH.Identity),   │
│  Logger(PH.Logger), Config(PH.Config); Init.lua bootstrap   │
│  Foundation services shared by all Feature modules.         │
├─────────────────────────────────────────────────────────────┤
│  Layer 2 — Data                                             │
│  Data/*.lua                                                  │
│  Pure Lua tables. No logic, no function calls.              │
├─────────────────────────────────────────────────────────────┤
│  Layer 1 — Locales                                          │
│  Locales/Locales.lua                                        │
│  All user-visible strings. Loaded first.                    │
└─────────────────────────────────────────────────────────────┘
```

---

## Three Core Services (Layer 3)

These eliminate all the duplicate code scattered across modules.

### PH.Identity — Character Identity Service

Single source of truth for character + realm identification.

```lua
PH.Identity:GetCharKey()   -- → "CharName-RealmName"
PH.Identity:GetRealmKey()  -- → "RealmName"
PH.Identity:GetCharName()  -- → "CharName"
PH.Identity:GetFaction()   -- → "Alliance" | "Horde"
PH.Identity:GetClass()     -- → "WARRIOR" | "MAGE" | ...
PH.Identity:GetLevel()     -- → number
```

**All modules must use PH.Identity.** Never call `UnitName("player")` or `GetRealmName()` directly in Feature/UI layers.

---

### PH.DB — Database Service

Centralized SavedVariables access with schema versioning.

```lua
-- Read a value (dot-path notation)
PH.DB:Get("cooldowns.CharName-Realm.transmute")
-- Returns nil safely if any segment is missing

-- Write a value
PH.DB:Set("cooldowns.CharName-Realm.transmute", { ts = time(), cdHours = 24 })

-- Ensure a table exists at path
PH.DB:Ensure("inventory.CharName-Realm")

-- Schema migration
PH.DB.SCHEMA_VERSION = 3
PH.DB:Migrate()  -- runs pending migration functions
```

**Schema version** is stored in `ProfessionHelperDB._schemaVersion`. Each version bump must include a migration function.

---

### PH.Event — Event Bus Service

Centralized WoW event subscription. Replaces per-module `eventFrame`.

```lua
-- Subscribe to a WoW event
PH.Event:On("PLAYER_ENTERING_WORLD", function(event, ...)
    AM:SaveCurrentChar()
end, "AltManager")

-- Subscribe to an internal addon event
-- (PH_FA_UPDATED is the only internal event with a real subscriber today)
PH.Event:On("PH_FA_UPDATED", function()
    PH:UpdateFishingAssistUI()
end, "FishingAssistUI")

-- Fire an internal addon event
PH.Event:Fire("PH_FA_UPDATED")

-- Unsubscribe all handlers from an owner
PH.Event:Off("AltManager")
```

**Rules:**
- Each WoW event is registered on a single shared frame
- Modules identify themselves with an owner string (3rd arg)
- Internal events are prefixed with `PH_`

---

## Feature Module Contract

Every Feature module MUST:

1. **Declare itself** as a sub-table of PH:
   ```lua
   PH.ModuleName = {}
   local M = PH.ModuleName
   ```

2. **Expose `Initialize()`**:
   ```lua
   function M:Initialize()
       PH.DB:Ensure("moduleName")  -- ensure DB path
       PH.Event:On("WOW_EVENT", handler, "ModuleName")
   end
   ```

3. **Use PH.Identity for all character lookups**:
   ```lua
   local charKey = PH.Identity:GetCharKey()
   ```

4. **Use PH.DB for all SavedVariables access**:
   ```lua
   PH.DB:Set("cooldowns." .. charKey .. ".transmute", entry)
   local entry = PH.DB:Get("cooldowns." .. charKey .. ".transmute")
   ```

5. **NOT create UI frames or modify the screen** — that belongs in the UI layer.

6. **NOT call other Feature modules** — if data sharing is needed, use PH.DB or raise a PH_ event.

---

## UI Layer Contract

Every UI file MUST:

1. Read display data exclusively through Feature module public methods:
   ```lua
   -- CORRECT
   local chars = PH.AltManager:GetAllCharsOnRealm()
   local remaining = PH.CooldownTracker:GetAllForCurrentChar()

   -- WRONG
   local chars = ProfessionHelperDB.characters[realm]
   ```

2. Delegate all mutations to Feature module methods:
   ```lua
   -- CORRECT
   PH.FarmTracker:Start()
   PH.FarmTracker:Stop()

   -- WRONG
   PH.FarmTracker.active = true
   ```

3. Use `PH.Event:On("PH_*", ...)` for reactive updates where a producer fires one
   (e.g. `FishingAssistUI` subscribes to `PH_FA_UPDATED`). Most UIs instead refresh
   via direct `PH:UpdateXxxUI()` calls — do not assume an event subscriber exists:
   ```lua
   PH.Event:On("PH_FA_UPDATED", function()
       PH:UpdateFishingAssistUI()
   end, "FishingAssistUI")
   ```

---

## Data Layer Contract

Data files (`Data/*.lua`) must:

1. Contain ONLY Lua tables — no function calls, no conditionals
2. NOT reference `PH.L[...]` in any field except `tip` (which is evaluated at runtime)
3. NOT call any API functions
4. NOT `require` or `dofile` other files

---

## Anti-Patterns to Eliminate

| Pattern | Problem | Fix |
|---|---|---|
| `local function GetCharKey()` in modules | Duplicated logic in 4+ files | Use `PH.Identity:GetCharKey()` |
| `frame:RegisterEvent(...)` in each module | N frames for same events | Use `PH.Event:On(...)` |
| `ProfessionHelperDB.cooldowns[key] = ...` | No schema validation | Use `PH.DB:Set(...)` |
| `if not ProfessionHelperDB.table then ProfessionHelperDB.table = {} end` | Scattered init guards | Use `PH.DB:Ensure(path)` |
| Local `EnsureTable()` variants in each module | 5+ identical functions | Handled by `PH.DB:Ensure()` |
| UI accessing DB directly | Bypasses feature layer | Always go through Feature API |
| Feature modules calling each other | Creates coupling cycles | Use PH.Event bus or PH.DB |

---

## Adding a New Feature Module — Checklist

1. Create `Features/NewModule.lua` and `UI/NewModuleUI.lua`
2. Add both to `ProfessionHelper.toc` in correct load-order position
3. Declare `PH.NewModule = {}; local M = PH.NewModule`
4. Implement `M:Initialize()` using PH.DB and PH.Event
5. Add `PH.NewModule:Initialize()` call to the `ADDON_LOADED` bootstrap in `Core/Init.lua`
6. Add any new locale keys to all 3 blocks in Locales.lua
7. Document all public methods in `docs/API-REFERENCE.md`
8. If new SavedVariables schema: bump `PH.DB.SCHEMA_VERSION` and add migration

---

## Module Initialization Order in Core/Init.lua

The real bootstrap lives in `Core/Init.lua`. Only modules that actually define
an `Initialize()` are called. `PH.Config`, `PH.TSM`, `PH.FarmTracker`,
`PH.PathCalculator`, `PH.DECalc`, `PH.MapPins`, and `PH.GatherGuide` have **no**
`Initialize()` — calling one would nil-error.

```lua
-- ADDON_LOADED handler:
PH.DB:Initialize()                -- must be first (NOT PH:InitializeDB)
PH.Event:Initialize()             -- must be second
-- PH.Config is purely functional, no init needed
PH.BagScanner:Initialize()
PH.CooldownTracker:Initialize()
PH.RecipeTracker:Initialize()
PH.AltManager:Initialize()
PH.FishingAssist:Initialize()
PH:CreateMinimapButton()

-- PLAYER_LOGIN handler (UnitName reliable here):
PH.Identity:Initialize()
PH.AltManager:SaveCurrentChar()

-- UI initialization happens lazily (on first show)
```
