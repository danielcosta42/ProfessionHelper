# ProfessionHelper — Data Model

_Last updated: 2026-04-26_

---

## SavedVariables — Estrutura Raiz

```lua
ProfessionHelperDB = {
    _schemaVersion = 1,         -- incrementar a cada mudança de schema
    config         = { ... },   -- settings do usuário
    cooldowns      = { ... },   -- cooldowns de profissão por personagem
    inventory      = { ... },   -- bag/bank scan por personagem
    alts           = { ... },   -- personagens desta conta por realm
    recipes        = { ... },   -- receitas conhecidas por personagem
    minimapPos     = 220,       -- ângulo do botão do minimapa
}
```

**Regra:** Todo acesso via `PH.DB:Get(dotPath)` / `PH.DB:Set(dotPath, value)`.

---

## DB Paths por Serviço

### Config (`config.*`)

```lua
-- Acessado via PH.Config:Get(key) / PH.Config:Set(key, value)
PH.Config.DEFAULTS = {
    debug                  = false,
    minimapButtonPosition  = 220,
    showTooltips           = true,
    preferredLocale        = "auto",    -- "auto" = usa locale do cliente
    farmTrackerAutoStart   = false,
}
```

Caminhos DB: `"config.debug"`, `"config.minimapButtonPosition"`, etc.

---

### Cooldowns (`cooldowns.<charKey>.<profInternalName>`)

```lua
ProfessionHelperDB.cooldowns = {
    ["Nome-Realm"] = {
        ["transmutation"] = {
            ts       = 1712345678,    -- Unix timestamp da última execução
            cdHours  = 24,            -- duração do cooldown em horas
        },
        ["inscription_research"] = {
            ts       = 1712345678,
            cdHours  = 24,
        },
    }
}
```

**Chaves de profissão:** `transmutation`, `inscription_research`, `daily_cooldown`.
Acessado por `CooldownTracker.lua`.

---

### Inventory (`inventory.<charKey>`)

```lua
ProfessionHelperDB.inventory = {
    ["Nome-Realm"] = {
        [12345] = 10,    -- itemID → quantidade (bags + bank)
        [67890] = 5,
    }
}
```

Acessado por `BagScanner.lua`. Exposto via `PH.BagScanner:GetCount(itemID)`.

---

### Alts (`alts.<realmKey>.<charName>`)

```lua
ProfessionHelperDB.alts = {
    ["Realm"] = {
        ["NomePersonagem"] = {
            class     = "WARRIOR",
            level     = 80,
            faction   = "Alliance",
            professions = {
                ["Blacksmithing"] = 450,
                ["Mining"]        = 450,
            },
            lastSeen  = 1712345678,
        }
    }
}
```

Acessado por `AltManager.lua`. Exposto via `PH.AltManager:GetAlts(realmKey)`.

---

### Recipes (`recipes.<charKey>.<profInternalName>`)

```lua
ProfessionHelperDB.recipes = {
    ["Nome-Realm"] = {
        ["Alchemy"] = {
            known   = { [2329] = true, [3395] = true },  -- spellID do recipe
            scanned = 1712345678,  -- Unix timestamp do último scan
        }
    }
}
```

Acessado por `RecipeTracker.lua`. Exposto via `PH.RecipeTracker:KnowsRecipe(spellID)`.

---

## Estrutura de Profissão (Data/*.lua)

Cada arquivo `Data/ProfissionName.lua` segue este schema:

```lua
ProfessionHelper.ProfessionName = {
    name    = "ProfessionName",              -- string; deve bater com chave no PH.Professions
    type    = "crafting",                    -- "crafting"|"gathering"|"secondary"|"combo"
    minVersion = 0,                          -- número TOC mínimo (0 = todos os clientes)

    trainer = {
        ["Alliance"] = {
            { name="NPC Name", zone="Zone", coords={x=52, y=33} },
        },
        ["Horde"] = {
            { name="NPC Name", zone="Zone", coords={x=48, y=61} },
        },
    },

    -- Apenas para type = "crafting"
    recipes = {
        [spellID] = {
            name       = "Recipe Name",
            skillRange = { orange=300, yellow=325, green=350, grey=375 },
            reagents   = { [itemID]=5, [itemID2]=2 },
        },
    },

    levelingGuide = {
        { from=1,   to=75,  recipe="Recipe Name", makes=1 },
        { from=75,  to=150, recipe="Other Recipe", makes=1 },
    },

    -- Apenas para type = "gathering"
    skillRanges = {
        { min=1,   max=75,  node="Copper Vein",   zones={"Elwynn Forest"} },
        { min=50,  max=125, node="Tin Vein",       zones={"Redridge Mountains"} },
    },

    farmingLocations = {
        { zone="Zone Name", nodes={"Node1"}, route="Clockwise outer loop" },
    },

    -- Opcional
    synergies = {
        { profession="Engineering", description="PH.L['ALCHEMY_SYNERGY_ENG']" },
    },

    -- Inscription somente
    millingGuide  = { ... },   -- ver Inscription.lua para schema completo
    inkTrader     = { ... },
}
```

**Regra:** Arquivos Data nunca chamam funções — somente tabelas Lua literais.
**Regra:** Strings visíveis ao usuário dentro de Data são chaves de locale (`PH.L["KEY"]`), não strings literais.

---

## Registro de Profissões (Core/Init.lua)

`PH.Professions` é o índice principal, filtrado por `minVersion`:

```lua
PH.Professions = {}
local allProfessions = {
    { key="Alchemy",       data=PH.Alchemy,        minVersion=0     },
    { key="Blacksmithing", data=PH.Blacksmithing,  minVersion=0     },
    { key="Jewelcrafting", data=PH.Jewelcrafting,  minVersion=20000 }, -- TBC+
    { key="Inscription",   data=PH.Inscription,    minVersion=30000 }, -- WotLK+
    { key="Archaeology",   data=PH.Archaeology,    minVersion=40000 }, -- Cata+
    -- ...
}
-- Filtrado em ADDON_LOADED:
for _, p in ipairs(allProfessions) do
    if PH.interfaceVersion >= p.minVersion then
        PH.Professions[p.key] = p.data
    end
end
```

---

## Mapa de Zona — MapPins / GatheringGuide

Ambos `MapPins.lua` e `GatheringGuide.lua` usam a mesma estrutura de lookup:

```lua
-- ZONA_MAP_IDS: nome de zona → mapID do HBD
local ZONE_MAP_IDS = {
    ["Elwynn Forest"]     = 1411,
    ["Dun Morogh"]        = 1412,
    ["Redridge Mountains"] = 1418,
    -- ...
}
```

**Problema identificado:** Esta tabela está duplicada nos dois arquivos.
**Candidato a extração:** `Core/MapUtils.lua` com `PH.MapUtils.GetZoneMapID(zoneName)`.

---

## AltManager — API Pública

```lua
-- Salvar char atual no DB
PH.AltManager:SaveCurrentChar()

-- Ler lista de alts de um realm
local alts = PH.AltManager:GetAlts(realmKey)  -- tabela { charName → record }

-- Ler skill de profissão de um alt
local skill = PH.AltManager:GetProfessionSkill(charKey, profName)  -- number|nil

-- Wrapper de identidade (compatibilidade retroativa)
PH.AltManager:GetRealmKey()   -- delega a PH.Identity:GetRealmKey()
PH.AltManager:GetCharName()   -- delega a PH.Identity:GetCharName()
```

---

## BagScanner — API Pública

```lua
-- Disparado automaticamente em BAG_UPDATE_DELAYED e BANKFRAME_OPENED
PH.BagScanner:Scan()

-- Consulta de quantidade
local count = PH.BagScanner:GetCount(itemID)   -- number (0 se não encontrado)
local count = PH.BagScanner:GetCountForChar(itemID, charKey)

-- Evento disparado após scan: PH.Event:Fire("PH_BAG_SCANNED")
```

---

## CooldownTracker — API Pública

```lua
-- Registro de cooldown via evento UNIT_SPELLCAST_SUCCEEDED
PH.CooldownTracker:RegisterCooldown(spellID)

-- Consulta
local cdData = PH.CooldownTracker:GetCooldown(charKey, profKey)
-- cdData = { ts=Unix, cdHours=24 } ou nil

local ready, timeLeftSec = PH.CooldownTracker:IsReady(charKey, profKey)

-- Evento disparado quando cooldown expirar: PH.Event:Fire("PH_CD_EXPIRED", profKey)
```

---

## FarmTracker — API Pública (In-Memory, sem persistência)

```lua
-- Controle de sessão
PH.FarmTracker:Start()
PH.FarmTracker:Stop()
PH.FarmTracker:Reset()

-- Consulta de sessão ativa
local session = PH.FarmTracker:GetSession()
-- session = {
--   startTime     = Unix,
--   startGold     = number,
--   currentGold   = number,
--   goldPerHour   = number,
--   kills         = number,
--   lootedItems   = { [itemID]=count },
-- }

local isActive = PH.FarmTracker:IsActive()  -- bool

-- Eventos:
-- PH.Event:Fire("PH_FARM_STARTED")
-- PH.Event:Fire("PH_FARM_STOPPED", session)
```

---

## RecipeTracker — API Pública

```lua
-- Scan de receitas da janela de Trade Skill aberta
PH.RecipeTracker:Scan()   -- disparado em TRADE_SKILL_SHOW / TRADE_SKILL_UPDATE

-- Consulta
local known = PH.RecipeTracker:KnowsRecipe(spellID)   -- bool

-- Evento: PH.Event:Fire("PH_RECIPE_SCANNED", profInternalName)
```

---

## PathCalculator — API Pública

```lua
local path = PH.PathCalculator:Calculate(profData, currentSkill, targetSkill)
-- path = {
--   steps = {
--     { recipe="Name", count=10, color="orange"|"yellow"|"green" },
--   },
--   shoppingList = {
--     { itemID=123, name="Item", quantity=50, priceEach=1500, priceTotal=75000 },
--   },
--   totalGoldCost = number,
-- }
```

---

## DECalc — API Pública

```lua
local result = PH.DECalc:CalculateDE(itemLink)
-- result = {
--   small  = { mat="Strange Dust",  qty=2 },
--   large  = { mat="Dream Dust",    qty=1 },
--   chance = 0.75,
-- }

local result = PH.DECalc:CalculateProspect(itemID)
local ores   = PH.DECalc:GetProspectableOres()   -- tabela de ores prospectáveis
```

---

## TSMIntegration — API Pública

```lua
local priceCopper = PH.TSM:GetItemPrice(itemNameOrLink)   -- number|nil
local formatted   = PH.TSM:FormatGold(priceCopper)         -- "12g 34s 56c"

-- Fonte de preços: TSM3/TSM4/TSM5, Auctionator, ou cache interno
```

---

## Schema Versioning

Ao mudar a estrutura do SavedVariables:

1. Incrementar `PH.DB.SCHEMA_VERSION` em `Core/Storage.lua`
2. Adicionar migration em `PH.DB:Migrate()`:

```lua
-- Em Core/Storage.lua
function DB:Migrate()
    local v = ProfessionHelperDB._schemaVersion or 0
    if v < 1 then
        -- migration v0 → v1: renomear "chars" para "alts"
        ProfessionHelperDB.alts = ProfessionHelperDB.chars
        ProfessionHelperDB.chars = nil
        ProfessionHelperDB._schemaVersion = 1
    end
    -- if v < 2 then ... end
end
```
