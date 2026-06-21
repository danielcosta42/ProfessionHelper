# ProfessionHelper — Implementation Log

_Last updated: 2026-06-20_

O entry mais recente fica no topo.

---

## 2026-06-20 — One-key fishing (técnica do Angleur) + fix de release/CI (sessão 7)

### O que mudou

**Release/CI (bloqueios resolvidos):**
- `ProfessionHelper.toc` — interface da Era `11503`→`11508` e BCC `20504`→`20505` (2.5.5, build vivo do TBC Anniversary). A `11503` foi aposentada pela CurseForge e quebrava o packager (`-g classic`).
- `.github/workflows/publish.yml` — `-g classic -g bcc -g wrath -g cata` → `-g classic -g bcc` (Wrath/Cata não têm realms vivos).
- `.luacheckrc` — **o lint do CI roda `luacheck . --config .luacheckrc` e o luacheck retorna exit 1 com QUALQUER warning.** Completado o allowlist (LOOT_ITEM_PUSHED/CREATED_SELF, e as novas APIs de fishing); `C_Container` removido de `read_globals` (estava em `globals` também → warning "read-only"). **Regra: validar `luacheck . --config .luacheckrc` com exit 0 antes de pushar.**

**One-key fishing (reescrita do FishingAssist, modelado no addon Angleur):**
O auto-interact antigo (`TargetUnit("Fishing Bobber")`+`InteractUnit`) era impossível — bóia não é unidade alvejável. Substituído pelo mecanismo real do Angleur:
- `Features/FishingAssist.lua` reescrito: tecla única do usuário com **override-binding swap** — ocioso `SetOverrideBindingSpell(owner, key, "Fishing")`, pescando+bóia `SetOverrideBinding(owner, key, "INTERACTMOUSEOVER")`. CVars temporários no cast (`SoftTargetInteract=3`, `SoftTargetInteractRange=15`, `SoftTargetInteractRangeIsHard=0`, `autoLootDefault=1`) restaurados no channel stop / logout. Bóia detectada via `PLAYER_SOFT_INTERACT_CHANGED` (GameObject 35591). Segurança em combate (clear/rebind em REGEN_DISABLED/ENABLED), guard de tecla-segurada. **Scanner de câmera** opt-in (default OFF): gira a câmera (`MoveView*Start/Stop`) varrendo até a bóia cair sob o cursor parado numa caixa (`CURSOR_CHANGED`+`SetCursor(nil)`), com timeout de 15s.
- `Core/Compat.lua` — `C.GetCVar`/`C.SetCVar`/`C.HasSoftInteract`.
- `UI/FishingAssistUI.lua` — atribuição de tecla (captura modal), label honesto "Pressione [tecla] para recolher", toggle do scanner de câmera; removido o estado morto "casting".
- Locales (3) — chaves `FA_KEY_*`/`FA_BTN_REEL*`/`FA_CAMERA_SCAN`/`FA_SCAN_*`.

### Limite honesto

Lootar a bóia **exige um toque real de tecla** (`INTERACTMOUSEOVER` só dispara de input de hardware). É pesca de UM botão, não bot zero-toque — igual ao Angleur. Cast e busca da bóia são automáticos; o toque de recolher é input real.

### Verificação

`luacheck . --config .luacheckrc` → **exit 0** (0/0, 51 arquivos). **Runtime precisa de teste in-client** (override bindings + CVars de soft-target não são testáveis fora do jogo).

### Itens abertos

- Validar in-client: soft-target pega a bóia? `INTERACTMOUSEOVER` recolhe? Scanner de câmera acha a bóia?
- Docs (`docs/API-REFERENCE.md`) do FishingAssist precisam refletir a nova API (`SetOneKey`/`GetOneKey`/`ShowScanBox`).

---

## 2026-06-20 — Feedback de usuários: descoberta de features, i18n, release fix (sessão 6)

### O que mudou

Resposta a comentários de usuários no CurseForge.

**Descoberta de features ("não acho Recipe/Alt/DE/Cooldown tracker"):**
- `UI/Main.lua` — adicionada **toolbar de ícones sempre visível** no cabeçalho (Cooldowns, Recipes, Alts, DE/Prospect, Farm) que abre cada painel. Antes só acessíveis por slash command.
- `Core/Init.lua` — `/ph help` agora lista `cd`/`recipes`/`alts`/`de` (chaves `CMD_HELP_*` nos 3 locales).
- `UI/Main.lua` — `liveTracker` → `_skillTracker` (bug latente que crashava ao renderizar profissão de craft; exposto pela restauração de profissão da sessão 5). A sidebar destaca a profissão restaurada.

**i18n ("textos não-ingleses no cliente inglês" e vice-versa):**
- `UI/Main.lua` — strings hardcoded em PT localizadas: "PROGRESSO" (→ `PROGRESS_LABEL`/`PROGRESS_LABEL_PCT`), "Gerar busca TSM" (→ `TSM_GENERATE_BTN`), "A seguir:" (→ `NEXT_UP_LABEL`), "Dica:" (→ `TIP_LABEL`); e "AUCTION HOUSE"/"VENDOR"/"TSM Shopping" (→ `SECTION_AH`/`SECTION_VENDOR`/`TSM_BTN_TITLE`).
- Títulos dos painéis (hardcoded em inglês, vazavam no cliente PT/ES) localizados: `RT_TITLE`/`AM_TITLE`/`DE_TITLE`/`FT_TITLE` em RecipeTrackerUI/AltManagerUI/DECalcUI/FarmTrackerUI.
- `Core/Init.lua` — `PH:GetClientShortLabel()`/`GetClientLabel()` derivam o badge/nome do cliente de `interfaceVersion` (badge "TBC" fixo, nome "...Burning Crusade Classic" fixo, e "1.0.0 - TBC Classic" no popup de créditos → versão real + cliente real).
- `UI/Main.lua` — quebra de linha quebrada na descrição dos créditos (`\\n` → `\n`).

**Release / packaging ("flagged for Retail"):**
- `.github/workflows/release.yml` — `Core.lua` → `Core/Namespace.lua` (linhas 74 e 139). O root `Core.lua` foi deletado na sessão 5 e a versão real vive em `Core/Namespace.lua`; o pipeline de bump quebraria no próximo push.
- O flag "Retail" NÃO vem do código: `publish.yml` empacota só `-g classic -g bcc -g wrath -g cata` e o TOC só declara `Interface-Classic/BCC/Wrath/Cata`. É uma config do site CurseForge (Project → Game Versions) que o autor precisa remover manualmente.

### Verificação

`luacheck Core Features UI Locales Data` → **0 erros** (51 arquivos). Paridade das novas chaves de locale conferida nos 3 idiomas.

## 2026-06-20 — Auditoria multi-agente + correção de bugs e doc drift (sessão 5)

### O que mudou

Auditoria das 5 camadas (47 achados verificados adversarialmente → 17 issues). Correções aplicadas:

**Crashes / features quebradas (group A):**
- `Features/TSMIntegration.lua` + `UI/Main.lua` — `PH:Print` (removido na v2) substituído por `PH.Logger.Info`. Eram 3 call-sites que davam *nil-method crash* (botão "Gerar busca TSM" e profissão sem data).
- `Features/CooldownTracker.lua` — handler de `UNIT_SPELLCAST_SUCCEEDED` recebia `(unit, ...)` mas o bus entrega `(event, ...)`; o guard `unit ~= "player"` era sempre verdadeiro → **nenhum** cooldown era gravado. Assinatura corrigida para `(_, unit, arg2, arg3)`.
- `Locales/{enUS,ptBR,esES}.lua` — adicionadas chaves `CD_READY`/`CD_READY_IN`/`CD_TITLE` (faltavam → concat de nil ao abrir `/ph cd` em char novo). Título do painel localizado em `UI/CooldownTrackerUI.lua`.
- `Features/FishingAssist.lua` + `Core/Compat.lua` — `GetContainerNumSlots/GetContainerItemLink/UseContainerItem` (globais removidas no Cata) roteadas via `PH.Compat`; adicionado wrapper `PH.Compat.UseContainerItem`. Evita crash no auto-equip de pesca no Cata.
- `Core/Init.lua` + `UI/Main.lua` — `targetSkill`/cap de skill estava hardcoded em 375; adicionado `PH:GetMaxSkillForClient()` (300/375/450/525 por `interfaceVersion`). Restaura toda a rota 375→450/525 no WotLK/Cata. Atualizados os 4 call-sites de `Calculate` + checagens de combo/gold-farming.

**Features incompletas (group B):**
- `Features/RecipeTracker.lua` — `PH[profName]` (quebrava First Aid, tabela em `PH.FirstAid`) → `PH:GetProfessionData(profName)`.
- `UI/Main.lua` + `Core/Init.lua` — `selectedProfession` agora persiste via `PH.Config:Set` e é restaurada no `PLAYER_LOGIN` (era declarada no schema mas nunca gravada). A sidebar destaca a profissão restaurada ao abrir.
- `UI/Main.lua` — **bug latente exposto pela restauração:** `CreateCraftingContent` lia `self.liveTracker` (campo que NUNCA foi inicializado — sobra de rename não concluído; o tracker real é `PH._skillTracker`, criado em `Core/Init.lua`). Crashava ao renderizar qualquer profissão de craft. Trocado `self.liveTracker` → `self._skillTracker` (3 refs).

**Wiring / polish (group C):**
- `Core/Init.lua` — removido double-dispatch: `bootstrapFrame` registrava SKILL_LINES_CHANGED/CHAT_MSG_SKILL/TRADE_SKILL_UPDATE/BAG_UPDATE_DELAYED direto **e** via `PH.Event`. Agora só ADDON_LOADED/PLAYER_LOGIN no frame; resto via bus (1× por evento).
- `Features/FishingAssist.lua` + `UI/FishingAssistUI.lua` — barra da bóia dividia por 60 (máx real 30); exposto `M:GetBobberDuration()`.

**Encoding (bug de carregamento real):**
- `Locales/esES.lua` (4×), `Data/Herbalism.lua`, `Data/Mining.lua` — escapes `¡`/`—` inválidos em Lua 5.1 (quebravam o carregamento desses arquivos) → caractere UTF-8 literal (`¡`, `—`).

**Cleanup (group D):**
- Removidas 11 duplicatas obsoletas da raiz (não carregadas pelo TOC): `Core.lua`, `DECalc.lua`, `DECalcUI.lua`, `GatheringGuide.lua`, `MapPins.lua`, `PathCalculator.lua`, `AltManagerUI.lua`, `CooldownTrackerUI.lua`, `RecipeTrackerUI.lua`, `FarmTrackerUI.lua`, `UI.lua`. Conclui o move da v2.
- `.luacheckrc` — completado o allowlist (GetBuildInfo, UseContainerItem, GetInventoryItemLink, UnitExists/UnitBuff/TargetUnit/InteractUnit, PROFESSIONS_FISHING, LOOT_ITEM_*_SELF_MULTIPLE).

**Documentação:**
- `docs/API-REFERENCE.md`, `docs/ARCHITECTURE.md`, `.github/instructions/architecture.instructions.md` — corrigidos para o código real: `PH.DB:Initialize` (não `PH:InitializeDB`), `PH.Logger` (não `PH:Print`), `PH.Config.DEFAULTS`, `PH.TSM:CalculateCost`, `BS:GetCount`, `DE:CalcDisenchant/CalcProspect/GetProspectableOres`, `MP:ShowSourcePins`/`ClearPins`, namespace `PH.GatherGuide`, return shape real de `PathCalculator:Calculate`, layout em subpastas, seção `PH.FishingAssist` + `/ph fish` + `PH_FA_UPDATED`, eventos internos sem subscriber marcados.

### Por quê

Estado pós-refator v2 tinha crashes silenciosos (CooldownTracker nunca gravava; `/ph cd` crashava; TSM e Cata quebravam) e divergência grande entre docs e código. Validação: `luacheck` em 51 arquivos → 0 erros.

### Verificação

`luacheck Core Features UI Locales Data` → **0 erros**, 6 warnings pré-existentes benignos
(C_Container read-only guardado por `if not C_Container`; `_fishingNames` morto em FishingAssist).

### Itens abertos (pendências deixadas)

- B2: `BagScanner._MergeInventory` não zera itens consumidos (contagem stale); `GetAllCounts` vaza `_bags`/`_bank`.
- B3: máquinas de cor de skill-up em `PathCalculator` (GAIN_CHANCE/GetRecipeColor/ExpectedCraftsPerPoint/BuildProductionMap) são dead code — decidir entre remover ou wirar.
- B4: painéis cd/recipes/alts/de só acessíveis por slash; faltam botões na UI e linhas em `/ph help`.
- C4: `AltManager` não assina `PLAYER_ENTERING_WORLD` (re-snapshot ao zonar).
- FishingAssist: estado `"casting"` no enum/UI é inalcançável (dead branches).

---

## 2026-04-27 — Modularização completa: Locales split, Features/, UI/ (sessão 4)

### O que mudou

**Locales divididos em arquivos por idioma:**
- `Locales/ptBR.lua` — tabela ptBR (865 linhas) com padrão `ProfessionHelper._Locales["ptBR"] = {...}`
- `Locales/enUS.lua` — tabela enUS (864 linhas)
- `Locales/esES.lua` — tabela esES (865 linhas) + alias `esMX` via init
- `Locales/Locales.lua` — reescrito como thin init (22 linhas): detecta locale, seta `PH.L`, `PH.Locale`, `PH.AllLocales`

**Módulos Feature movidos para `Features/`:**
- `Features/TSMIntegration.lua`, `Features/BagScanner.lua`, `Features/RecipeTracker.lua`
- `Features/AltManager.lua`, `Features/DECalc.lua`, `Features/PathCalculator.lua`
- `Features/FarmTracker.lua`, `Features/MapPins.lua`, `Features/GatheringGuide.lua`
- `Features/CooldownTracker.lua`

**Módulos UI movidos para `UI/`:**
- `UI/Main.lua` (antigo `UI.lua`) — header + `UnitFactionGroup("player")` → `PH.Identity:GetFaction()`
- `UI/FarmTrackerUI.lua`, `UI/CooldownTrackerUI.lua`, `UI/RecipeTrackerUI.lua`
- `UI/AltManagerUI.lua`, `UI/DECalcUI.lua`

**Headers antigos corrigidos (4 arquivos):**
- `DECalc.lua` — `ProfessionHelper = ProfessionHelper or {}; local PH = ProfessionHelper` → `local PH = _G.ProfessionHelper`
- `PathCalculator.lua` — mesmo padrão
- `GatheringGuide.lua` — `local PH = ProfessionHelper` → `local PH = _G.ProfessionHelper`
- `MapPins.lua` — mesmo padrão
- Todos os 6 módulos UI também corrigidos para `local PH = _G.ProfessionHelper`

**TOC atualizado** — 48 entradas com caminhos corretos: `Locales\`, `Features\`, `UI\`

### Por quê

Separação de responsabilidades: cada idioma em seu próprio arquivo (editável independentemente),
feature business-logic isolada de UI, estrutura de pastas clara e consistente com a arquitetura em
5 camadas.

### Arquivos tocados

`Locales/ptBR.lua` (novo), `Locales/enUS.lua` (novo), `Locales/esES.lua` (novo),
`Locales/Locales.lua` (reescrito), `Features/` (10 arquivos movidos),
`UI/` (6 arquivos movidos/renomeados), `ProfessionHelper.toc` (atualizado),
`.memory/architecture.md` (atualizado)

---

## 2026-04-26 — Sistema .memory/ de governança criado (sessão 3)

### O que mudou

**Novos arquivos criados:**
- `.memory/README.md` — ponto de entrada, DIRETIVA PRINCIPAL, instruções para Copilot
- `.memory/architecture.md` — mapa de módulos (45 entradas), ordem de carregamento, diagrama de camadas, fluxo de dados, tabela de responsabilidades, anti-padrões eliminados
- `.memory/coding-standards.md` — 12 regras: namespace, módulo pattern, identidade, storage, eventos, output, compat, version guards, locale, performance, pcall, proibições
- `.memory/quality-checklist.md` — checklist completo pré-implementação
- `.memory/data-model.md` — schema SavedVariables completo, API pública por módulo, estrutura de profissão Data/*.lua, padrão de schema versioning
- `.memory/compatibility-notes.md` — matriz de 4 clientes (Classic/TBC/WotLK/Cata), todas as implementações de wrappers PH.Compat, padrão BackdropTemplate
- `.memory/decisions.md` — ADR-0001 a ADR-0007 cobrindo todas as decisões arquiteturais da v2
- `.memory/implementation-log.md` — este arquivo

### Por quê

Sistema de governança inspirado no AutoRaidCoach's `.memory/` folder — provê contexto arquitetural
persistente para sessões de desenvolvimento assistido por IA. Cada arquivo documenta um aspecto
diferente do projeto para que o Copilot possa retomar com contexto completo em qualquer sessão.

### Arquivos tocados

Apenas arquivos novos em `.memory/`. Nenhum arquivo Lua ou TOC modificado.

---

## 2026-04-26 — Refatoração completa v2: arquitetura em 5 camadas (sessão 2)

### O que mudou

**Novos arquivos criados:**
- `Core/Namespace.lua` — global `PH`, metadados, stubs de sub-módulos
- `Core/Logger.lua` — `PH.Logger`: Info/Warn/Error/Debug, output centralizado
- `Core/Compat.lua` — C_Container polyfill, 6 wrappers cross-version
- `Core/Storage.lua` — `PH.DB`: dot-path, `SCHEMA_VERSION=1`, `Initialize/Migrate/Get/Set/Ensure`
- `Core/Events.lua` — `PH.Event`: frame único, `On/Off/Fire`, handlers em pcall
- `Core/Identity.lua` — `PH.Identity`: cache em PLAYER_LOGIN, 6 getters
- `Core/Config.lua` — `PH.Config`: DEFAULTS, Get/Set via PH.DB
- `Core/Init.lua` — profession registry (18 profissões com minVersion), bootstrap, slash cmds

**Módulos reescritos (Feature Layer):**
- `AltManager.lua` — usa PH.Identity, PH.DB, PH.Event; remove eventFrame local; fires PH_CHAR_UPDATED
- `BagScanner.lua` — remove C_Container polyfill inline; usa PH.Compat; fires PH_BAG_SCANNED
- `CooldownTracker.lua` — usa PH.Identity, PH.DB, PH.Compat.GetSpellInfo
- `RecipeTracker.lua` — usa PH.Identity, PH.DB, PH.Compat.GetTradeSkillLine; fires PH_RECIPE_SCANNED
- `FarmTracker.lua` — usa PH.Logger, PH.Event, PH.Compat.GetMoney; fires PH_FARM_STARTED/STOPPED
- `TSMIntegration.lua` — WriteToCache/ReadFromCache via PH.DB:Set/Get

**Arquivos modificados:**
- `ProfessionHelper.toc` — ordem de carregamento completa (45 entradas)
- `Core.lua` — stripped para 14-line deprecation comment

### Por quê

Addon original tinha múltiplos anti-padrões críticos:
- C_Container polyfill duplicado em múltiplos arquivos
- `GetCharKey()` definido localmente em 4+ módulos
- `eventFrame` por módulo (6+ frames para os mesmos eventos)
- `ProfessionHelperDB` acessado diretamente sem guards consistentes
- Zero versionamento de schema
- `PH:Print()` sem níveis de log

### Arquivos com pendências identificadas

- `DECalc.lua` — ainda usa `ProfessionHelper = ProfessionHelper or {}` (header v1)
- `PathCalculator.lua` — ainda usa `ProfessionHelper = ProfessionHelper or {}` (header v1)
- `GatheringGuide.lua` — usa `local PH = ProfessionHelper` (sem `_G.`)
- `MapPins.lua` — usa `local PH = ProfessionHelper` (sem `_G.`)
- `UI.lua` — usa `local PH = ProfessionHelper` + chama `UnitFactionGroup("player")` diretamente

---

## 2026-04-26 — Auditoria de arquivos e identificação de duplicações (sessão 1)

### O que mudou

Apenas análise — nenhum arquivo modificado nesta sessão.

### Findings

1. `Core.lua` era monolítico (~800 linhas) — candidato à divisão em `Core/`
2. `BagScanner.lua` e `Compat.lua` (se existisse) repetiam o polyfill `C_Container`
3. `AltManager.lua`, `BagScanner.lua`, `CooldownTracker.lua`, `RecipeTracker.lua` cada um com `GetCharKey()` local
4. 6 módulos Feature com `local eventFrame = CreateFrame("Frame")` próprio
5. `GatheringGuide.lua` e `MapPins.lua` com `ZONE_MAP_IDS` (~100 entradas) duplicada

---

## Formato de Entry

```
## YYYY-MM-DD — Título curto (sessão N)

### O que mudou

### Por quê

### Arquivos tocados

### Itens abertos (pendências deixadas)
```
