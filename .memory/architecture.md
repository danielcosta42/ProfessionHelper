# ProfessionHelper — Architecture

_Last updated: 2026-04-26_

---

## Design Principles

1. **Single global namespace** — `ProfessionHelper` (aliased `PH`). Todos os sub-módulos são nested tables.
2. **Layered architecture** — 5 camadas estritas. Camadas superiores chamam inferiores; nunca o contrário.
3. **Defensive coding** — toda chamada de API que pode não existir é guardada ou encapsulada.
4. **Classic-first compatibility** — nenhuma API exclusiva de Retail é chamada fora de `Core/Compat.lua`.
5. **Zero UI no pipeline de dados** — módulos Feature têm zero dependência de UI.
6. **Serviços centralizados** — DB, Event, Identity, Logger, Compat, Config eliminam toda duplicação.

---

## Camadas de Arquitetura

```
┌─────────────────────────────────────────────────────────────┐
│  Layer 5 — UI                                               │
│  UI/Main.lua, UI/FarmTrackerUI.lua,                         │
│  UI/CooldownTrackerUI.lua, UI/RecipeTrackerUI.lua,          │
│  UI/AltManagerUI.lua, UI/DECalcUI.lua                       │
│  Apresentação apenas. Chama APIs de Feature. Nunca lê DB.   │
├─────────────────────────────────────────────────────────────┤
│  Layer 4 — Features                                         │
│  AltManager, BagScanner, CooldownTracker, RecipeTracker,    │
│  FarmTracker, PathCalculator, DECalc, TSMIntegration,       │
│  GatheringGuide, MapPins                                     │
│  Lógica de negócio. Usa serviços Core. Expõe API pública.   │
├─────────────────────────────────────────────────────────────┤
│  Core/Init.lua  ← hub de wiring, registrado após features   │
│  (Professions registry, utilidades, bootstrap, slash cmds)  │
├─────────────────────────────────────────────────────────────┤
│  Layer 3 — Core Services                                    │
│  Core/Namespace.lua   PH global + metadados                 │
│  Core/Logger.lua      PH.Logger  (Info/Warn/Error/Debug)    │
│  Core/Compat.lua      PH.Compat  (wrappers de versão)       │
│  Core/Storage.lua     PH.DB      (acesso a SavedVariables)  │
│  Core/Events.lua      PH.Event   (bus de eventos central)   │
│  Core/Identity.lua    PH.Identity (identidade de char)      │
│  Core/Config.lua      PH.Config   (settings com defaults)   │
│  Fundação compartilhada por todos os módulos Feature.       │
├─────────────────────────────────────────────────────────────┤
│  Layer 2 — Data                                             │
│  Data/Materials.lua, Data/Alchemy.lua, Data/Mining.lua ...  │
│  Tabelas Lua puras. Sem lógica, sem chamadas de função.     │
├─────────────────────────────────────────────────────────────┤
│  Layer 1 — Locales                                          │
│  Locales/ptBR.lua  Locales/enUS.lua  Locales/esES.lua       │
│  Locales/Locales.lua  (thin init — selects active locale)   │
│  Todas as strings visíveis ao usuário. Carregado primeiro.  │
└─────────────────────────────────────────────────────────────┘
```

---

## Mapa de Arquivos

```
ProfessionHelper/
  ProfessionHelper.toc             — ordem de carregamento, SavedVariables
  Core/
    Namespace.lua                  — global PH + metadados + stubs de sub-módulos
    Logger.lua                     — PH.Logger: Info/Warn/Error/Debug
    Compat.lua                     — wrappers cross-version, polyfill C_Container
    Storage.lua                    — PH.DB: acesso dot-path ao ProfessionHelperDB
    Events.lua                     — PH.Event: bus de eventos único compartilhado
    Identity.lua                   — PH.Identity: fonte única de identidade de char
    Config.lua                     — PH.Config: settings com defaults
    Init.lua                       — profession registry, utilitários, bootstrap, slash cmds
  Data/
    Materials.lua                  — tabela global de materiais (id, vendor, etc.)
    Alchemy.lua                    — dados da profissão Alchemy
    Blacksmithing.lua
    Enchanting.lua
    Engineering.lua
    Jewelcrafting.lua              — minVersion = 20000 (TBC+)
    Inscription.lua                — minVersion = 30000 (WotLK+)
    Leatherworking.lua
    Tailoring.lua
    Cooking.lua
    FirstAid.lua
    Mining.lua
    Herbalism.lua
    Skinning.lua
    Fishing.lua
    Archaeology.lua                — minVersion = 40000 (Cata+)
    GoldFarming.lua
    FishingCooking.lua             — guia combo
    HerbalismAlchemy.lua           — guia combo
    SkinningLeatherworking.lua     — guia combo
    Dailies.lua
  Locales/
    ptBR.lua                       — tabela locale ptBR (865 linhas)
    enUS.lua                       — tabela locale enUS (864 linhas)
    esES.lua                       — tabela locale esES (865 linhas)
    Locales.lua                    — thin init: detecta locale, seta PH.L
  Features/
    TSMIntegration.lua             — PH.TSM: preços AH (TSM 3/4/5, Auctionator)
    BagScanner.lua                 — PH.BagScanner: inventário de bags/bank
    RecipeTracker.lua              — PH.RecipeTracker: receitas conhecidas
    AltManager.lua                 — PH.AltManager: personagens desta conta
    DECalc.lua                     — PH.DECalc: DE/Prospect calculator
    PathCalculator.lua             — PH.PathCalculator: rota ótima de craft
    FarmTracker.lua                — PH.FarmTracker: sessão de farm (gold/hora)
    MapPins.lua                    — PH.MapPins: pins de POI no mapa
    GatheringGuide.lua             — PH.GatherGuide: rota de coleta no mapa
    CooldownTracker.lua            — PH.CooldownTracker: cooldowns de profissão
  UI/
    Main.lua                       — janela principal (antigo UI.lua)
    FarmTrackerUI.lua
    CooldownTrackerUI.lua
    RecipeTrackerUI.lua
    AltManagerUI.lua
    DECalcUI.lua
```

---

## Ordem de Carregamento (TOC)

| # | Arquivo | Depende de |
|---|---------|-----------|
| 1 | Locales/ptBR.lua | nada |
| 2 | Locales/enUS.lua | nada |
| 3 | Locales/esES.lua | nada |
| 4 | Locales/Locales.lua | PH._Locales (carregado por 1-3) |
| 5 | Core/Namespace.lua | nada (cria todos os stubs PH.*) |
| 6 | Core/Logger.lua | PH |
| 7 | Core/Compat.lua | PH |
| 8 | Core/Storage.lua | PH, PH.Compat |
| 9 | Core/Events.lua | PH, PH.Compat |
| 10 | Core/Identity.lua | PH, PH.Events |
| 11 | Core/Config.lua | PH, PH.DB |
| 12 | Data/Materials.lua | PH |
| 13–31 | Data/*.lua | PH |
| 32 | Features/TSMIntegration.lua | PH, PH.DB |
| 33 | Features/BagScanner.lua | PH, PH.Identity, PH.DB, PH.Event, PH.Compat |
| 34 | Features/RecipeTracker.lua | PH, PH.Identity, PH.DB, PH.Event, PH.Compat |
| 35 | Features/AltManager.lua | PH, PH.Identity, PH.DB, PH.Event |
| 36 | Features/DECalc.lua | PH |
| 37 | Features/PathCalculator.lua | PH, PH.TSM, PH.BagScanner |
| 38 | Features/FarmTracker.lua | PH, PH.Logger, PH.Event, PH.Compat, PH.TSM |
| 39 | Features/MapPins.lua | PH |
| 40 | Features/GatheringGuide.lua | PH |
| 41 | Features/CooldownTracker.lua | PH, PH.Identity, PH.DB, PH.Event, PH.Compat |
| 42 | Core/Init.lua | todos acima |
| 43 | UI/Main.lua | PH, todos os módulos Feature |
| 44 | UI/FarmTrackerUI.lua | PH, PH.FarmTracker |
| 45 | UI/CooldownTrackerUI.lua | PH, PH.CooldownTracker |
| 46 | UI/RecipeTrackerUI.lua | PH, PH.RecipeTracker |
| 47 | UI/AltManagerUI.lua | PH, PH.AltManager |
| 48 | UI/DECalcUI.lua | PH, PH.DECalc |

---

## Serviços Core (Layer 3)

### PH.DB — Database Service

Acesso centralizado ao SavedVariables com versionamento de schema.

```lua
PH.DB:Get("cooldowns.CharName-Realm.transmute")   -- leitura dot-path, nil-safe
PH.DB:Set("cooldowns.CharName-Realm.transmute", { ts = time(), cdHours = 24 })
PH.DB:Ensure("inventory.CharName-Realm")          -- no-op se já existe
PH.DB.SCHEMA_VERSION = N                          -- incrementar a cada mudança de schema
PH.DB:Migrate()                                   -- roda migrations pendentes
```

**Regra:** Nenhum módulo fora de `Core/Storage.lua` acessa `ProfessionHelperDB` diretamente.

---

### PH.Event — Event Bus Service

Frame WoW único compartilhado. Substitui `eventFrame` por módulo.

```lua
PH.Event:On("PLAYER_ENTERING_WORLD", function() AM:SaveCurrentChar() end, "AltManager")
PH.Event:On("PH_FARM_STARTED", function() PH:ShowFarmTrackerUI() end, "FarmTrackerUI")
PH.Event:Fire("PH_FARM_STARTED")   -- interno; prefixo PH_
PH.Event:Off("AltManager")         -- remove todos os handlers deste owner
```

**Regra:** Módulos se identificam com uma string owner (3º arg). Eventos internos têm prefixo `PH_`.

---

### PH.Identity — Identity Service

Fonte única de verdade para identidade de char/realm.

```lua
PH.Identity:GetCharKey()    -- "CharName-RealmName"
PH.Identity:GetCharName()   -- "CharName"
PH.Identity:GetRealmKey()   -- "RealmName"
PH.Identity:GetFaction()    -- "Alliance" | "Horde"
PH.Identity:GetClass()      -- "WARRIOR" | "MAGE" | ...
PH.Identity:GetLevel()      -- number
```

**Regra:** Nenhum módulo chama `UnitName("player")` ou `GetRealmName()` diretamente.

---

### PH.Logger — Output Service

Todo output de texto ao usuário passa por aqui.

```lua
PH.Logger.Info(msg)    -- sempre exibido
PH.Logger.Warn(msg)    -- sempre exibido, com cor de aviso
PH.Logger.Error(msg)   -- sempre exibido, com cor de erro
PH.Logger.Debug(msg)   -- só exibido se PH.Config:Get("debug") == true
```

**Regra:** Nenhum módulo chama `DEFAULT_CHAT_FRAME:AddMessage` ou `print()` diretamente.

---

### PH.Compat — Compatibility Service

Todos os wrappers cross-version vivem aqui.

```lua
PH.Compat.GetSpellInfo(spellID)              -- → name ou nil
PH.Compat.GetItemInfo(itemLinkOrID)          -- → name ou nil
PH.Compat.GetTradeSkillLine()                -- → título da janela aberta
PH.Compat.GetContainerNumSlots(bag)
PH.Compat.GetContainerItemLink(bag, slot)
PH.Compat.GetContainerItemInfo(bag, slot)
PH.Compat.PlaySound(soundKitID, fallbackID)
PH.Compat.GetMoney()
PH.interfaceVersion                          -- número TOC cached do cliente
```

**Regra:** Nenhum módulo usa `WOW_PROJECT_ID` ou checa `C_Spell`, `C_Container`, etc. diretamente.

---

### PH.Config — Config Service

```lua
PH.Config:Get("minimapButtonPosition")   -- retorna valor ou default
PH.Config:Set("debug", true)             -- persiste via PH.DB
PH.Config.DEFAULTS = { ... }
```

---

## Bootstrap (Core/Init.lua)

```
ADDON_LOADED "ProfessionHelper"
  │
  ├─► PH.DB:Initialize()        ← deve ser primeiro
  ├─► PH.Event:Initialize()     ← deve ser segundo
  ├─► filtra PH.Professions por minVersion
  ├─► PH.BagScanner:Initialize()
  ├─► PH.CooldownTracker:Initialize()
  ├─► PH.RecipeTracker:Initialize()
  ├─► PH.AltManager:Initialize()
  └─► PH:CreateMinimapButton()

PLAYER_LOGIN
  │
  ├─► PH.Identity:Initialize()  ← UnitName() confiável aqui
  └─► PH.AltManager:SaveCurrentChar()
```

**Nota:** `bootstrapFrame` em `Core/Init.lua` é o único frame NÃO criado via `PH.Event`.
Ele bootstrapa o próprio bus de eventos e deve ser auto-contido.

---

## Fluxo de Dados — Profession Guide

```
Usuário seleciona profissão
  │
  ▼
PH:GetProfessionData(profName)          — lê Data/Profession.lua
  │
  ▼
PH.PathCalculator:Calculate(profData, currentSkill, targetSkill)
  │                                     — usa PH.TSM:GetItemPrice()
  │                                     — usa PH.BagScanner:GetCount()
  ▼
pathData = { steps[], shoppingList[] }
  │
  ▼
UI.lua — renderiza steps e shoppingList
```

---

## Tabela de Responsabilidades por Módulo

| Módulo | Responsabilidade | NÃO possui |
|---|---|---|
| Core/Namespace.lua | Criação do global PH + stubs | tudo mais |
| Core/Logger.lua | Todo output de texto | lógica de negócio |
| Core/Compat.lua | Wrappers cross-version | registro de eventos, dados |
| Core/Storage.lua | Leitura/escrita do SavedVariables | lógica de negócio |
| Core/Events.lua | Frame único de eventos, pub/sub | lógica de negócio |
| Core/Identity.lua | Identidade de char/realm | SavedVariables, UI |
| Core/Config.lua | Settings com defaults | lógica de negócio |
| Core/Init.lua | Profession registry, bootstrap, slash cmds | data, UI |
| TSMIntegration.lua | Preços de AH e formatação de gold | UI, storage direto |
| BagScanner.lua | Inventário de bags/bank | UI, análise |
| RecipeTracker.lua | Receitas conhecidas | UI, análise |
| AltManager.lua | Histórico de personagens | UI |
| CooldownTracker.lua | Cooldowns de profissão | UI |
| FarmTracker.lua | Sessão de farm in-memory | SavedVariables |
| PathCalculator.lua | Rota ótima de craft | UI, storage |
| DECalc.lua | Cálculo DE/Prospect | UI, storage |
| GatheringGuide.lua | Rotas de coleta no mapa | lógica de craft |
| MapPins.lua | Pins de POI no mapa | lógica de negócio |
| UI.lua | Janela principal | dados, análise |
| *UI.lua | Apresentação de feature | dados, análise |

---

## Anti-Padrões Eliminados

| Padrão | Problema | Correção |
|---|---|---|
| `local function GetCharKey()` em módulos | Duplicado em 4+ arquivos | `PH.Identity:GetCharKey()` |
| `frame:RegisterEvent(...)` por módulo | N frames para os mesmos eventos | `PH.Event:On(...)` |
| `ProfessionHelperDB.cooldowns[key] = ...` | Sem validação de schema | `PH.DB:Set(...)` |
| `if not ProfessionHelperDB.t then ... end` | Guards espalhados | `PH.DB:Ensure(path)` |
| `EnsureTable()` local em cada módulo | 5+ funções idênticas | `PH.DB:Ensure()` |
| `PH:Print(msg)` | Não filtrado, sem nível | `PH.Logger.Info(msg)` |
| UI acessando DB diretamente | Bypassa camada Feature | Sempre via Feature API |
| Módulos Feature chamando uns aos outros | Cria ciclos de acoplamento | Usar PH.Event bus ou PH.DB |
| C_Container polyfill inline | Duplicado em múltiplos arquivos | `PH.Compat` (uma vez só) |
