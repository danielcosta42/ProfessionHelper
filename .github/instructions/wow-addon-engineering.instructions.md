---
description: "Generic engineering standards for any World of Warcraft addon. Apply when designing architecture, adding modules, writing event handlers, managing SavedVariables, or reviewing code quality. Addon-agnostic — not specific to ProfessionHelper."
---

# WoW Addon Engineering Standards

> These rules apply to **any** WoW addon. They are addon-agnostic.  
> Do not assume any specific addon name, domain, feature, or namespace.

---

## Core Philosophy

- Addons are **event-driven systems**, not web apps.
- Performance matters more than feature count.
- Architecture must be modular, predictable, and easy to extend.
- UI must **never** own business logic.
- Game API differences must be isolated.
- SavedVariables must be treated as persistent storage, not runtime state.

---

## Standard Folder Structure

```
AddonName/
  AddonName.toc
  Core/
    Init.lua        ← ADDON_LOADED handler, wires everything
    Namespace.lua   ← global namespace declaration
    Events.lua      ← centralized event dispatcher
    Compat.lua      ← version/API compatibility wrappers
    Config.lua      ← settings access (Get/Set with defaults)
    State.lua       ← in-memory runtime state only
    Storage.lua     ← SavedVariables read/write only
    Logger.lua      ← all debug and error output
  Modules/
    FeatureA.lua    ← one responsibility per file
    FeatureB.lua
  UI/
    UI.lua          ← UI orchestration only
    Components.lua  ← reusable frame builders
    Panels.lua      ← top-level panel layout
  Data/
    Constants.lua   ← static data tables
    Rules.lua       ← data-driven logic tables
```

---

## Architecture Rules

### 1. Namespace

Use exactly one global, declare defensively.

```lua
-- Correct
_G.AddonName = _G.AddonName or {}
local Addon = _G.AddonName

-- Wrong — pollutes global scope
MyFunction = function() end
SomeTable = {}
```

All module tables must live under the namespace:

```lua
Addon.Modules.FeatureA = {}
function Addon.Modules.FeatureA.Run() end
```

---

### 2. Module Boundaries

Each file has one responsibility.

| File | Responsibility |
|---|---|
| `Events.lua` | Event registration and dispatch |
| `Storage.lua` | SavedVariables read/write |
| `State.lua` | Runtime/session state only |
| `Compat.lua` | API compatibility wrappers |
| `Logger.lua` | Debug and error output |
| `UI.lua` | UI orchestration only |

**No module mixes UI, storage, and game logic.**

---

### 3. One-Way Data Flow

```
Game Events / API  →  Event Layer  →  Feature Modules  →  State  →  UI
```

Rules:
- UI reads processed state — it does not call raw game APIs unless purely visual
- Feature modules compute and store results into State
- Modules do not directly mutate SavedVariables
- Storage does not run business logic

---

### 4. Compatibility Layer

All version-sensitive API calls go through `Compat.lua`. Never scatter Retail/Classic checks across feature modules.

```lua
-- All expansions resolved in one place
Addon.Compat.GetSpellInfo(spellID)
Addon.Compat.GetItemInfo(itemID)
Addon.Compat.RegisterEvent(frame, eventName)
Addon.Compat.GetUnitAura(unit, aura)
```

---

### 5. Event System

Use a centralized dispatcher. Never create multiple `eventFrame` objects scattered across files.

```lua
-- Centralized registration
Addon.Events.Register("PLAYER_LOGIN",  Module.OnLogin)
Addon.Events.Register("BAG_UPDATE",    Module.OnBagUpdate)
```

---

### 6. Runtime State vs Persistent Storage

| Store type | Location | Rule |
|---|---|---|
| Session/combat data | `State.lua` | Never persisted |
| UI transient data | `State.lua` | Never persisted |
| User settings | `SavedVariables` | Versioned and migrated |
| Long-term history | `SavedVariables` | Only keep what is needed |

Do not write temporary data to SavedVariables.

---

### 7. SavedVariables Discipline

SavedVariables must be:
- **versioned** — always have a `version` field
- **migrated safely** — run migration on every load
- **compact** — store only necessary data
- **validated** at load time

```lua
-- Default structure
AddonDB = {
    version  = 1,
    settings = {},
    profiles = {},
}

-- Migration function
function Storage.Migrate(db)
    if not db.version then
        db.version = 1
        -- v1 → v2 transform here
    end
end
```

---

### 8. Configuration Model

All settings accessed through a single Config module. No direct SavedVariables reads in feature code.

```lua
-- Declare defaults in one place
Addon.Defaults = {
    enabled = true,
    debug   = false,
    scale   = 1.0,
}

-- Always resolved through Config
Addon.Config.Get("debug")
Addon.Config.Set("debug", true)
```

---

### 9. Logging

All output goes through `Logger`. No raw `print()` or `DEFAULT_CHAT_FRAME:AddMessage()` outside Logger.

```lua
Addon.Logger.Debug("message")  -- only when debug = true
Addon.Logger.Info("message")
Addon.Logger.Warn("message")
Addon.Logger.Error("message")
```

Rules:
- Debug output is gated behind `Addon.Config.Get("debug")`
- No chat spam during normal operation
- Error messages must be actionable

---

### 10. UI Separation

UI callbacks must not contain business logic.

```lua
-- Wrong
Button:SetScript("OnClick", function()
    -- 80 lines of scanning, state updates, saves...
end)

-- Correct
Button:SetScript("OnClick", function()
    Addon.Modules.FeatureA.Toggle()
end)
```

UI reads processed state — it does not compute it.

---

### 11. Performance Rules

**Avoid:**
- Heavy `OnUpdate` handlers that run every frame
- Scanning bags, auras, or raid roster every frame
- Rebuilding large tables repeatedly
- Storing raw event logs indefinitely
- String concatenation in hot paths (combat events, OnUpdate)

**Prefer:**
- Event-driven updates
- Throttled polling with `GetTime()` delta checks
- Cached lookup tables
- Lazy frame rendering (build on first show)
- Summary/aggregate storage instead of raw logs

---

### 12. Error Safety

Every module must fail gracefully. One broken feature must not break the whole addon.

```lua
-- Guard nil values at API boundaries
local name = UnitName("player") or "Unknown"

-- Wrap version-sensitive calls
local ok, result = pcall(Addon.Compat.GetSpellInfo, spellID)
if not ok then
    Addon.Logger.Warn("GetSpellInfo failed for " .. tostring(spellID))
    return
end

-- Validate inputs at function entry
function M.ProcessItem(itemID)
    if type(itemID) ~= "number" or itemID <= 0 then return end
    ...
end
```

---

### 13. Extensibility

New features are added as new module files — not injected into core files.

```
-- Good
Modules/
  QuestTracker.lua
  RaidTools.lua
  InventoryScanner.lua

-- Bad
Core.lua with 5000 lines
```

---

### 14. Data-Driven Rules

Avoid hardcoding logic inline. Use data tables.

```lua
-- Bad
if class == "HUNTER" then
    -- hunter-specific branch
end

-- Good
local rule = Addon.Data.ClassRules[class]
if rule then rule.Apply() end
```

---

## Anti-Patterns

Never:
- Create one giant Lua file with all logic
- Pollute global scope with random functions or tables
- Put business logic inside UI `OnClick` / `OnEvent` callbacks
- Mutate SavedVariables directly from feature modules
- Parse the same game event in multiple places
- Use Retail-only APIs without a Compat fallback
- Rebuild UI frames on every update tick
- Store data "just in case" with no cleanup path
- Copy/paste feature logic across modules

---

## Quality Checklist

Before finishing any addon change:

- [ ] Uses exactly one global namespace
- [ ] Module responsibilities are clearly separated
- [ ] UI does not contain business logic
- [ ] No API compatibility checks outside Compat.lua
- [ ] No unnecessary runtime data written to SavedVariables
- [ ] SavedVariables schema is versioned and migrated
- [ ] No heavy `OnUpdate` without throttling
- [ ] Debug output is behind a flag
- [ ] Fails safely when data or API is missing
- [ ] Functions are small and readable

---

## Final Rule

Build addons like small software products:

- **modular** — each file has one job
- **predictable** — data flows in one direction
- **defensive** — assume APIs can fail
- **fast** — event-driven, not polling
- **maintainable** — readable in six months

Do not optimize for "it works today".  
Optimize for "I can still understand and extend this in six months".
