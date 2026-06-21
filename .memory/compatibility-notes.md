# ProfessionHelper — Compatibility Notes

_Last updated: 2026-04-26_

---

## Clientes Suportados

| Cliente | Interface TOC | Constante `PH.interfaceVersion` |
|---|---|---|
| Classic Era / Vanilla | `11503` | `>= 11000` |
| TBC Classic / Anniversary | `20504` | `>= 20000` |
| WotLK Classic | `30403` | `>= 30000` |
| Cata Classic | `40402` | `>= 40000` |

> ProfessionHelper **não** suporta Retail Mainline.  
> Archaeology (Cata), Inscription/Jewelcrafting (TBC/WotLK) têm guards de versão.

---

## Padrão de Detecção de Versão

`PH.interfaceVersion` é cached em `Core/Namespace.lua`:

```lua
PH.interfaceVersion = select(4, GetBuildInfo())
```

Use sempre `PH.interfaceVersion` para guards — nunca `WOW_PROJECT_ID` diretamente.

```lua
-- CORRETO
if PH.interfaceVersion >= 30000 then  -- WotLK+
    -- Inscription, Death Knight, etc.
end

-- ERRADO
if WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC then
    -- acoplado ao valor específico
end
```

---

## Matriz de Disponibilidade de API

| API | Classic | TBC | WotLK | Cata | Wrapper PH |
|---|---|---|---|---|---|
| `GetSpellInfo(id)` global | ✅ | ✅ | ✅ | ✅ | `PH.Compat.GetSpellInfo` |
| `C_Spell.GetSpellInfo(id)` | ❌ | ❌ | ❌ | ❌ | `PH.Compat.GetSpellInfo` |
| `GetItemInfo(link)` global | ✅ | ✅ | ✅ | ✅ | `PH.Compat.GetItemInfo` |
| `GetContainerNumSlots(bag)` | ✅ | ✅ | ✅ | ⚠️ | `PH.Compat.GetContainerNumSlots` |
| `C_Container.GetContainerNumSlots` | ❌ | ❌ | ❌ | ✅ | `PH.Compat.GetContainerNumSlots` |
| `GetContainerItemLink(bag,slot)` | ✅ | ✅ | ✅ | ⚠️ | `PH.Compat.GetContainerItemLink` |
| `C_Container.GetContainerItemLink` | ❌ | ❌ | ❌ | ✅ | `PH.Compat.GetContainerItemLink` |
| `GetContainerItemInfo(bag,slot)` | ✅ | ✅ | ✅ | ⚠️ | `PH.Compat.GetContainerItemInfo` |
| `C_Container.GetContainerItemInfo` | ❌ | ❌ | ❌ | ✅ | `PH.Compat.GetContainerItemInfo` |
| `GetTradeSkillLine()` | ✅ | ✅ | ✅ | ✅ | `PH.Compat.GetTradeSkillLine` |
| `PlaySound(soundKitID)` | ✅ | ✅ | ✅ | ✅ | `PH.Compat.PlaySound` |
| `GetMoney()` | ✅ | ✅ | ✅ | ✅ | `PH.Compat.GetMoney` |
| `UnitName("player")` | ✅ | ✅ | ✅ | ✅ | `PH.Identity:GetCharName()` |
| `UnitFactionGroup("player")` | ✅ | ✅ | ✅ | ✅ | `PH.Identity:GetFaction()` |
| `HereBeDragons` library | ✅ | ✅ | ✅ | ✅ | usado diretamente por MapPins/GatherGuide |

Legenda: ✅ disponível · ⚠️ movido para C_Container · ❌ não presente

---

## Implementações dos Wrappers (`Core/Compat.lua`)

### `PH.Compat.GetSpellInfo(spellID)`

```lua
-- Classic/TBC/WotLK/Cata: função global retorna name, rank, icon, ...
if GetSpellInfo then
    return GetSpellInfo(spellID)
end
-- Retail (não suportado, mas guard defensivo):
if C_Spell and C_Spell.GetSpellInfo then
    local info = C_Spell.GetSpellInfo(spellID)
    return info and info.name or nil
end
return nil
```

### `PH.Compat.GetItemInfo(itemLinkOrID)`

```lua
if GetItemInfo then
    return GetItemInfo(itemLinkOrID)
end
return nil
```

> Nota: `GetItemInfo` pode retornar nil para itens que não estão no cache do cliente.
> O caller deve verificar o retorno antes de usar.

### `PH.Compat.GetContainerNumSlots(bag)` / `GetContainerItemLink` / `GetContainerItemInfo`

Polyfill C_Container — Cata moveu as funções para o namespace `C_Container`:

```lua
-- Polyfill executado no carregamento de Core/Compat.lua:
if C_Container then
    if not GetContainerNumSlots then
        GetContainerNumSlots = C_Container.GetContainerNumSlots
    end
    if not GetContainerItemLink then
        GetContainerItemLink = C_Container.GetContainerItemLink
    end
    if not GetContainerItemInfo then
        GetContainerItemInfo = function(bag, slot)
            local info = C_Container.GetContainerItemInfo(bag, slot)
            if not info then return nil end
            return info.iconFileID, info.stackCount, info.isLocked,
                   info.quality, info.isReadable, info.hasLoot,
                   info.hyperlink, info.isFiltered, info.noValue,
                   info.itemID, info.isBound
        end
    end
end
-- Wrappers usam as globais (já normalizadas pelo polyfill):
function Compat.GetContainerNumSlots(bag)
    return GetContainerNumSlots and GetContainerNumSlots(bag) or 0
end
```

### `PH.Compat.GetTradeSkillLine()`

```lua
function Compat.GetTradeSkillLine()
    if GetTradeSkillLine then
        return GetTradeSkillLine()   -- retorna name, isArmor, skillLevel, maxSkillLevel
    end
    return nil
end
```

### `PH.Compat.PlaySound(soundKitID, fallbackID)`

```lua
function Compat.PlaySound(soundKitID, fallbackID)
    if PlaySound then
        local ok = pcall(PlaySound, soundKitID, "Master")
        if not ok and fallbackID then
            pcall(PlaySound, fallbackID, "Master")
        end
    end
end
```

### `PH.Compat.GetMoney()`

```lua
function Compat.GetMoney()
    return GetMoney and GetMoney() or 0
end
```

---

## Padrão de BackdropTemplate

Cata e versões mais recentes do Classic removeram `SetBackdrop` do tipo base `Frame`.
Use o probe pattern (executado uma vez no carregamento de `UI.lua`):

```lua
local _backdropTpl
do
    local probe = CreateFrame("Frame")
    _backdropTpl = (not probe.SetBackdrop) and "BackdropTemplate" or nil
end

-- Uso ao criar frames:
local f = CreateFrame("Frame", name, parent, _backdropTpl)
if _backdropTpl then
    f:SetBackdrop(backdropDef)
else
    -- frame já tem SetBackdrop nativo
    f:SetBackdrop(backdropDef)
end
```

---

## Registro Seguro de Eventos

`Core/Events.lua` usa pcall internamente para cada handler.
Para eventos que podem não existir em alguns clientes (como `ENCOUNTER_START`),
o registration em si é seguro — WoW simplesmente ignora `RegisterEvent` para eventos desconhecidos.

---

## Adicionando um Novo Wrapper

1. Adicione a função em `Core/Compat.lua`.
2. Nomeie como `PH.Compat.FunctionName` (PascalCase).
3. Comente cada branch: `-- [Classic]`, `-- [Cata/C_Container]`, `-- [Fallback]`.
4. Retorne `nil` em indisponibilidade total (nunca `error()`).
5. Atualize a tabela de Matriz de Disponibilidade acima.
6. Chame via `PH.Compat.FunctionName()` em todos os lugares — nunca inline a detecção.
