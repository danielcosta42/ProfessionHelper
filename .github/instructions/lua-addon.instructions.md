---
description: "Use when writing, editing, or reviewing any Lua file in ProfessionHelper. Covers WoW Lua 5.1 standards, naming conventions, error safety, performance patterns, and forbidden patterns. Apply to all *.lua files."
applyTo: "**/*.lua"
---

# Lua WoW Addon — Coding Standards

## Module Pattern (mandatory)

Every module file must start with:
```lua
ProfessionHelper = ProfessionHelper or {}
local PH = ProfessionHelper

PH.ModuleName = {}
local M = PH.ModuleName
```

Public API uses colon syntax (receives `self`):
```lua
function M:MethodName(arg1, arg2)
    -- self == M
end
```

Private helpers use `local function` (file-scoped, no `self`):
```lua
local function helperName(arg1)
    -- not accessible outside this file
end
```

Constants are `local` and `ALL_CAPS`:
```lua
local MAX_SKILL = 525
local CACHE_TTL = 86400
```

---

## Forbidden Patterns

| ❌ Forbidden | ✅ Correct |
|---|---|
| `ProfessionHelperDB.cooldowns[char]` (direct DB access from features) | `PH.DB:Get("cooldowns." .. char)` |
| `local function GetCharKey()` in any module | `PH.Identity:GetCharKey()` |
| `local function GetRealmKey()` in any module | `PH.Identity:GetRealmKey()` |
| `frame:RegisterEvent(...)` per module | `PH.Event:On(eventName, cb, owner)` |
| `SomeWowAPI()` without pcall for cross-version APIs | `pcall(SomeWowAPI, ...)` |
| `string.format("%d", nil)` | Always guard `nil` before format |
| `table[#table + 1] = v` | `table.insert(table, v)` |
| Global variable declarations (`myVar = 5`) | `local myVar = 5` |
| `if foo == true then` | `if foo then` |
| `if foo == false then` | `if not foo then` |
| `if foo == nil then` | `if not foo then` (unless distinguishing false from nil) |

---

## Error Safety

**Cross-version WoW API calls** must use pcall:
```lua
-- CORRECT: C_Container may not exist in Classic
local ok, info = pcall(C_Container.GetContainerItemInfo, bag, slot)
if ok and info then
    local count = info.stackCount or 0
end

-- CORRECT: GetProfessions() not in TBC Classic
local ok, p1, p2 = pcall(GetProfessions)
```

**SavedVariables access** must guard nil:
```lua
-- CORRECT
local db = ProfessionHelperDB
if not db or not db.cooldowns then return end
local entry = db.cooldowns[charKey]
if not entry then return end
```

**String format** must guard nil arguments:
```lua
-- CORRECT
local rank = skillRank or 0
local max  = skillMaxRank or 1
local pct  = string.format("%d%%", math.floor(100 * rank / max))
```

---

## Performance Rules

1. **Cache table lookups**: `local insert = table.insert` at file top if used in loops
2. **Avoid string concatenation in loops**: use `table.insert` + `table.concat`
3. **Avoid global lookups in hot paths**: local-ize globals used more than twice
4. **No frame creation in OnUpdate**: create frames once, reuse via pool
5. **Throttle OnUpdate handlers**: use timer or compare `GetTime()` delta

```lua
-- WRONG: creates garbage every frame
frame:SetScript("OnUpdate", function()
    frame.txt:SetText("Gold: " .. GetMoney())
end)

-- CORRECT: throttle
local UPDATE_INTERVAL = 1.0
local lastUpdate = 0
frame:SetScript("OnUpdate", function(_, elapsed)
    lastUpdate = lastUpdate + elapsed
    if lastUpdate < UPDATE_INTERVAL then return end
    lastUpdate = 0
    frame.txt:SetText("Gold: " .. GetMoney())
end)
```

---

## Locale Usage

Every user-visible string MUST use the locale table:
```lua
-- WRONG
PH:Print("Farm session started!")

-- CORRECT
PH:Print(PH.L["FARM_STARTED_MSG"])
```

Dynamic strings use `string.format` with locale template:
```lua
-- WRONG
PH:Print("Gold per hour: " .. goldAmt)

-- CORRECT  
PH:Print(string.format(PH.L["FARM_STAT_GOLD_PER_HOUR"], PH.TSM:FormatMoney(gph)))
```

---

## Version Guards

Any feature unavailable across all supported clients must be version-gated:
```lua
-- Inscription only exists in WotLK+
if PH.interfaceVersion >= 30000 then
    -- register Inscription-specific events
end

-- C_Map API only in Cata+
if C_Map and C_Map.GetMapInfo then
    -- use C_Map
else
    -- fallback
end
```

Version constants:
- Classic 1.x: `PH.interfaceVersion >= 11000`
- TBC 2.x:     `PH.interfaceVersion >= 20000`
- WotLK 3.x:   `PH.interfaceVersion >= 30000`
- Cata 4.x:    `PH.interfaceVersion >= 40000`

---

## Module Initialization

Every feature module must expose an `Initialize()` method:
```lua
function M:Initialize()
    -- validate SavedVariables schema
    -- subscribe events via PH.Event:On(...)
    -- set up initial state
end
```

`Core.lua` calls each `Initialize()` in `ADDON_LOADED` handler, in dependency order.

---

## UI Rules (UI layer only)

- Never read `ProfessionHelperDB` directly — call Feature module APIs
- Never perform game logic in UI callbacks — delegate to Feature module methods
- Frame names must be unique; use `"PH" .. moduleName .. "Frame"` pattern
- All textures use `Interface\\Buttons\\WHITE8X8` for flat solid fills
- `MakeFlat(frame, bgColor, borderColor)` utility must be used for all panels

---

## TOC Load Order Contract

Files load in TOC order. Respect dependency order:
1. `Locales/Locales.lua` — must be first
2. `Data/*.lua` — before any module that reads profession data
3. `TSMIntegration.lua`, `BagScanner.lua`, `RecipeTracker.lua` — service tier
4. `AltManager.lua`, `CooldownTracker.lua`, `FarmTracker.lua` — feature tier
5. `PathCalculator.lua`, `DECalc.lua`, `MapPins.lua`, `GatheringGuide.lua`
6. `Core.lua` — event wiring and initialization dispatcher
7. `*UI.lua` files — last, after all logic is available
