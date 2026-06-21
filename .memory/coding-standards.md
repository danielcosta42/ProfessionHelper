# ProfessionHelper — Coding Standards

_Last updated: 2026-04-26_

---

## Regra 1 — Namespace Único

- `ProfessionHelper` é o **único global** do addon. Criado em `Core/Namespace.lua`.
- Todos os módulos usam `local PH = _G.ProfessionHelper` no topo do arquivo.
- **Nunca** escreva `ProfessionHelper = ProfessionHelper or {}` em módulos. Isso é feito exclusivamente em `Core/Namespace.lua`.
- Sub-módulos são nested tables: `PH.AltManager`, `PH.DB`, `PH.Event`, etc.

```lua
-- CORRETO
local PH = _G.ProfessionHelper

-- ERRADO
local PH = ProfessionHelper          -- não usa _G explícito
ProfessionHelper = ProfessionHelper or {}  -- duplica declaração do namespace
```

---

## Regra 2 — Padrão de Módulo

Cada módulo Feature ou Service usa este padrão exato:

```lua
local PH = _G.ProfessionHelper
PH.ModuleName = PH.ModuleName or {}
local M = PH.ModuleName

-- Constantes locais ao arquivo
local THRESHOLD_SECONDS = 86400

-- Funções privadas (helpers locais)
local function helperFn(arg)
    -- ...
end

-- Métodos públicos com colon (self-aware)
function M:MethodName(arg)
    -- self é M
end

-- Inicialização (chamada de Core/Init.lua)
function M:Initialize()
    PH.Event:On("SOME_EVENT", function() self:Handler() end, "ModuleName")
end
```

**Regras:**
- Métodos públicos: `function M:MethodName(...)` (colon, self implícito)
- Helpers privados: `local function helperName(...)` (dot, sem self, file-local)
- Constantes: `local CONSTANT_NAME = value` (all caps, file-local)
- O owner do `PH.Event:On(...)` **deve** ser o nome do módulo como string

---

## Regra 3 — Identidade de Personagem

**Nunca** defina `GetCharKey()`, `GetCharName()` ou `GetRealmKey()` locais em módulos.
**Nunca** chame `UnitName("player")`, `GetRealmName()`, ou `UnitFactionGroup("player")` diretamente.

```lua
-- CORRETO
local charKey  = PH.Identity:GetCharKey()   -- "Nome-Realm"
local charName = PH.Identity:GetCharName()  -- "Nome"
local realm    = PH.Identity:GetRealmKey()  -- "Realm"
local faction  = PH.Identity:GetFaction()   -- "Alliance" | "Horde"
local class    = PH.Identity:GetClass()     -- "WARRIOR" | ...
local level    = PH.Identity:GetLevel()     -- number

-- ERRADO
local name, realm = UnitName("player")
local faction = UnitFactionGroup("player")
```

---

## Regra 4 — Acesso a SavedVariables

**Nunca** acesse `ProfessionHelperDB` diretamente fora de `Core/Storage.lua`.
**Nunca** crie guards `if not ProfessionHelperDB.t then ... end` em módulos.
**Nunca** escreva `EnsureTable()` localmente — use `PH.DB:Ensure(path)`.

```lua
-- CORRETO
PH.DB:Ensure("cooldowns." .. charKey)
local cd = PH.DB:Get("cooldowns." .. charKey .. ".transmute")
PH.DB:Set("cooldowns." .. charKey .. ".transmute", { ts = time() })

-- ERRADO
if not ProfessionHelperDB.cooldowns then
    ProfessionHelperDB.cooldowns = {}
end
ProfessionHelperDB.cooldowns[charKey] = { ts = time() }
```

---

## Regra 5 — Registro de Eventos

**Nunca** crie `local eventFrame = CreateFrame("Frame")` em módulos.
**Nunca** chame `frame:RegisterEvent()` em módulos.
Todo registro de evento vai por `PH.Event:On(...)`.

```lua
-- CORRETO
function M:Initialize()
    PH.Event:On("BAG_UPDATE_DELAYED", function()
        self:ScanBags()
    end, "BagScanner")
end

-- ERRADO
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("BAG_UPDATE_DELAYED")
eventFrame:SetScript("OnEvent", function(_, event)
    M:ScanBags()
end)
```

---

## Regra 6 — Output de Texto

**Nunca** chame `DEFAULT_CHAT_FRAME:AddMessage(...)` ou `print(...)` em módulos.
**Nunca** use `PH:Print(msg)` — isso foi removido na v2.

```lua
-- CORRETO
PH.Logger.Info("BagScanner: " .. count .. " itens escaneados")
PH.Logger.Warn("CooldownTracker: spell não encontrada: " .. spellID)
PH.Logger.Error("Storage: falha ao migrar schema")
PH.Logger.Debug("FarmTracker: ouro por hora = " .. rate)  -- só com debug=true

-- ERRADO
DEFAULT_CHAT_FRAME:AddMessage(msg)
print(msg)
PH:Print(msg)
```

---

## Regra 7 — Compatibilidade Cross-Version

**Nunca** chame APIs sensíveis a versão diretamente fora de `Core/Compat.lua`.
**Nunca** use `WOW_PROJECT_ID` ou `C_Spell`, `C_Container`, etc. fora de `Core/Compat.lua`.

```lua
-- CORRETO
local spellName = PH.Compat.GetSpellInfo(spellID)
local itemName  = PH.Compat.GetItemInfo(itemLink)
local numSlots  = PH.Compat.GetContainerNumSlots(bag)

-- ERRADO
local spellName = GetSpellInfo(spellID)         -- pode não existir em retail
local spellName = C_Spell.GetSpellInfo(spellID) -- não existe no Classic
```

---

## Regra 8 — Version Guards

Código específico de expansão usa `PH.interfaceVersion`:

```lua
-- Classic: >= 11000
-- TBC:     >= 20000
-- WotLK:   >= 30000
-- Cata:    >= 40000

if PH.interfaceVersion >= 30000 then
    -- Inscription, Death Knight, etc.
end
```

**Nunca** use números mágicos sem constantes nomeadas ou comentário explicando o threshold.

---

## Regra 9 — Localização

**Toda** string visível ao usuário deve estar em `Locales/{langName}.lua`.
**Nunca** hardcode strings de UI em módulos Feature ou UI.

```lua
-- CORRETO
PH.Logger.Info(PH.L["FARM_SESSION_STARTED"])
label:SetText(PH.L["COOLDOWN_READY"])

-- ERRADO
PH.Logger.Info("Farm session started!")
label:SetText("Ready")
```

**Formato de chave de locale:** `MODULENAME_CONTEXT_DESCRIPTION` em SCREAMING_SNAKE_CASE.
**Idiomas obrigatórios:** `ptBR` (primário), `enUS`, `esES`. Se tradução indisponível, use o valor `enUS`.

---

## Regra 10 — Performance

- **Nunca** use `OnUpdate` para polling periódico. Use o throttled poll de `Core/Init.lua` (`PH._skillTracker`).
- **Nunca** chame `GetSpellInfo`, `GetItemInfo`, `UnitName` a cada frame — cache no Initialize.
- Handlers de evento devem retornar cedo se o estado não está pronto:

```lua
PH.Event:On("TRADE_SKILL_SHOW", function()
    if not PH.Identity:GetCharKey() then return end
    self:ScanRecipes()
end, "RecipeTracker")
```

- Iterações pesadas sobre bags/receitas devem ser feitas uma vez e cacheadas em tabela.

---

## Regra 11 — Segurança com pcall

Envolva chamadas de WoW API que podem não existir em todos os clientes:

```lua
-- Para API que pode não existir:
local ok, result = pcall(SomeWowAPI, arg1, arg2)
if ok and result then
    -- usar result
end

-- Para registro de eventos raros:
PH.Event:On("ENCOUNTER_START", handler, owner)  -- PH.Event usa pcall internamente
```

---

## Regra 12 — Proibições Absolutas

Estes padrões são **proibidos** no codebase:

| Padrão | Razão |
|---|---|
| `_G.variable = value` (qualquer global nova) | Namespace poluído |
| `select('#', ...)` em hot paths | Lento em Lua 5.1 |
| `table.getn(t)` | Deprecated; use `#t` |
| `string.format` em loops de eventos frequentes | Alocação desnecessária |
| `loadstring(...)` ou `load(...)` | Inseguro + não disponível em todos os clientes |
| `dofile(...)` ou `loadfile(...)` | N/A no ambiente WoW |
| `require(...)` | N/A no ambiente WoW |
| `io.*` / `os.*` (exceto `os.time`, `os.date`) | N/A no ambiente WoW |
| Frames criados antes de `ADDON_LOADED` | Crashes em alguns clientes |
| SavedVariables acessados antes de `PLAYER_LOGIN` | DB não inicializado |
