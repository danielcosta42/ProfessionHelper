# ProfessionHelper — Architectural Decision Records

_Last updated: 2026-04-26_

---

## ADR-0001 — Subdirectório Core/ em vez de Core.lua monolítico

**Status:** Aceito

**Context:**  
O addon originalmente tinha um único `Core.lua` de ~800 linhas com o namespace, eventos, DB,
identidade, bootstrap e slash commands misturados. Isso tornava impossível raciocinar sobre
dependências e criava múltiplos pontos de falha.

**Decision:**  
Dividir `Core.lua` em 7 arquivos responsáveis individualmente dentro de `Core/`:
`Namespace.lua`, `Logger.lua`, `Compat.lua`, `Storage.lua`, `Events.lua`, `Identity.lua`,
`Config.lua`, com `Init.lua` como hub de wiring carregado por último.

**Consequences:**
- (+) Cada serviço tem responsabilidade única e pode ser lido/testado em isolamento
- (+) Dependências explícitas pela ordem do TOC
- (+) Novo serviço = novo arquivo, sem tocar nos existentes
- (-) TOC mais longo
- (-) `Core.lua` original foi preservado como arquivo de compatibilidade (stripped)

---

## ADR-0002 — PH.DB como serviço com dot-path em vez de acesso direto ao SavedVariables

**Status:** Aceito

**Context:**  
Módulos anteriormente acessavam `ProfessionHelperDB` diretamente com guards `if not ProfessionHelperDB.t then ... end` duplicados em cada arquivo. Não havia versionamento de schema e as migrations eram impossíveis.

**Decision:**  
Criar `PH.DB` em `Core/Storage.lua` com:
- `DB:Get(dotPath)` — nil-safe, navega sub-tabelas automaticamente
- `DB:Set(dotPath, value)` — cria sub-tabelas conforme necessário
- `DB:Ensure(dotPath)` — garante que uma tabela existe sem sobrescrever
- `DB.SCHEMA_VERSION` + `DB:Migrate()` para migrations futuras

**Consequences:**
- (+) Zero duplicação de guards por módulo
- (+) Schema pode ser migrado deterministicamente
- (+) Módulos não precisam conhecer a estrutura raiz do DB
- (+) Fácil de mock em testes
- (-) Leve overhead de string parsing para dot-path (aceitável — não é hot path)

---

## ADR-0003 — PH.Event como bus único em vez de eventFrames por módulo

**Status:** Aceito

**Context:**  
Cada módulo criava seu próprio `local eventFrame = CreateFrame("Frame")` e registrava eventos
individualmente. Havia 6+ frames registrando os mesmos eventos WoW (`BAG_UPDATE_DELAYED`, etc.).
Módulos não podiam se comunicar entre si sem criar novas globais.

**Decision:**  
Criar `PH.Event` em `Core/Events.lua` com:
- Um único frame WoW para todos os eventos de sistema
- `EV:On(event, callback, owner)` para subscribe
- `EV:Off(owner)` para unsubscribe de todos os handlers de um módulo
- `EV:Fire(event, ...)` para eventos internos do addon (prefixo `PH_`)

**Consequences:**
- (+) Um único `RegisterEvent` por tipo de evento, independente de quantos módulos querem
- (+) Comunicação pub/sub entre módulos via `PH_*` eventos sem acoplamento direto
- (+) `owner` string facilita debug e cleanup
- (+) Cada handler envolto em pcall — erros em um não quebram outros
- (-) Eventos WoW e eventos internos PH compartilham o mesmo bus — nomes de evento `PH_*` devem ser únicos
- (-) O `bootstrapFrame` em `Core/Init.lua` ainda usa CreateFrame direto (necessário para bootstrap o próprio bus)

---

## ADR-0004 — PH.Identity como serviço em vez de chamadas inline de UnitName

**Status:** Aceito

**Context:**  
`UnitName("player")` e `UnitFactionGroup("player")` foram chamados diretamente em 4+ módulos,
incluindo antes de `PLAYER_LOGIN` (onde podem retornar nil). `GetCharKey()` era definido
localmente em múltiplos arquivos com implementações ligeiramente diferentes.

**Decision:**  
Criar `PH.Identity` em `Core/Identity.lua` que:
- Inicializa APENAS em `PLAYER_LOGIN` (garantia de UnitName não-nil)
- Cacheia name, realm, faction, class, level após inicialização
- Expõe `GetCharKey()`, `GetCharName()`, `GetRealmKey()`, `GetFaction()`, `GetClass()`, `GetLevel()`
- `AltManager` mantém `GetRealmKey()`/`GetCharName()` como wrappers públicos de retrocompatibilidade, mas delegam a `PH.Identity`

**Consequences:**
- (+) UnitName nunca chamado antes de ser confiável
- (+) Implementação única e testável
- (+) Todas as chamadas de `UnitFactionGroup` centralizadas (incluindo UI.lua)
- (-) Módulos não podem acessar identidade antes de `PLAYER_LOGIN` — devem aguardar o evento

---

## ADR-0005 — bootstrapFrame separado para o problema chicken-and-egg do PH.Event

**Status:** Aceito

**Context:**  
`PH.Event` precisa de um frame WoW para funcionar. Mas para criar esse frame, precisamos saber
que o addon carregou (`ADDON_LOADED`). E para saber que o addon carregou, precisamos do bus de
eventos. Paradoxo.

**Decision:**  
`Core/Init.lua` cria um `bootstrapFrame` dedicado com `CreateFrame("Frame")` que:
1. Ouve `ADDON_LOADED` e `PLAYER_LOGIN` diretamente (sem PH.Event)
2. Em `ADDON_LOADED`: chama `PH.DB:Initialize()`, `PH.Event:Initialize()`, etc.
3. Em `PLAYER_LOGIN`: chama `PH.Identity:Initialize()`, depois todos os módulos que precisam de identidade

**Consequences:**
- (+) O ciclo de bootstrap é explícito e auto-documentado em `Core/Init.lua`
- (+) Após bootstrap, todo o resto usa `PH.Event` normalmente
- (-) `bootstrapFrame` é a única exceção à regra "sem CreateFrame por módulo"
- (-) `bootstrapFrame` deve ser documentado como exceção explícita nos coding standards

---

## ADR-0006 — ZONE_MAP_IDS duplicado em MapPins e GatheringGuide (known tech debt)

**Status:** Accepted with known tech debt

**Context:**  
Ambos `GatheringGuide.lua` e `MapPins.lua` precisam de lookup zoneName → mapID para HereBeDragons.
Ambos foram escritos independentemente e têm tabelas `ZONE_MAP_IDS` idênticas (~100 entradas)
mais uma função `BuildZoneMapIDs()` idêntica.

**Decision:**  
**Por enquanto:** Manter a duplicação. Extrair para `Core/MapUtils.lua` é a correção correta,
mas requer testar que ambos os módulos usam exatamente os mesmos IDs.

**Plan:**  
Quando qualquer um dos dois arquivos precisar de mudança de zona:
1. Criar `Core/MapUtils.lua` com `PH.MapUtils = {}` e a tabela `ZONE_MAP_IDS` única
2. Adicionar ao TOC antes de `MapPins.lua` e `GatheringGuide.lua`
3. Atualizar ambos para usar `PH.MapUtils.GetZoneMapID(zoneName)`
4. Deletar as tabelas duplicadas

**Consequences:**
- (+) Sem trabalho prematuro de refatoração
- (-) Inconsistência de zona pode surgir se uma tabela for atualizada e a outra não
- Monitorar: se as tabelas divergirem, executar o plano de extração imediatamente

---

## ADR-0007 — PH.Logger em vez de PH:Print()

**Status:** Aceito

**Context:**  
`PH:Print(msg)` era um método único sem níveis de log. Debug output era impossível de silenciar
e tinha o mesmo formato que output funcional.

**Decision:**  
Criar `PH.Logger` com 4 níveis: `Info`, `Warn`, `Error`, `Debug`.
`Debug` é silenciado por `PH.Config:Get("debug") == false`.
`PH:Print()` foi removido e `Core.lua` foi stripped.

**Consequences:**
- (+) Debug pode ser ativado/desativado sem modificar código
- (+) Mensagens de erro e aviso têm formatação visual diferente
- (+) Fácil de estender com timestamps ou log para arquivo no futuro
- (-) Todos os callers anteriores de `PH:Print()` precisaram ser atualizados (feito na v2)

---

## ADR-0008 — Marketplace de crafters: transporte via scan de chat + GUILD, NÃO via CHANNEL

**Status:** Aceito (design; ver `docs/MARKETPLACE-DESIGN.md`)

**Context:**  
Proposta de um "mercado de crafters" in-game (ofertas, pedidos abertos, rede de criadores)
que funcione junto com o addon PartyLens (mesmo autor), ambos standalone mas se enriquecendo.
Verificação empírica no cliente TBC 2.5.5 Anniversary:
`C_ChatInfo.SendAddonMessage(prefix, msg, "CHANNEL", n)` retorna **`4` (InvalidChatType)** —
o chatType `CHANNEL` foi desabilitado no patch 1.13.3 e o bloqueio vale neste cliente.
**Não existe broadcast oculto realm-wide.** (A malha oculta do PartyLens, que usa esse caminho,
nunca entregou nada — falha silenciosa, sem erro.)

**Decision:**  
Arquitetura transport-agnostic com um único board alimentado por 4 fontes (`source` tag):
`scan` (parse passivo de Trade/LFG via `CHAT_MSG_CHANNEL` — realm-wide, zero cold-start, a
espinha dorsal), `guild` (addon msg estruturada sobre `GUILD`), `hub` (SAY/YELL ~40yd nos AH),
`self` (alts locais). Handshake `ChehulNet` (prefixo compartilhado com PartyLens) sobre
GUILD/WHISPER para enriquecimento cruzado. Sem auto-post/auto-whisper (só 1-clique).

**Consequences:**
- (+) MVP (Phase 1) útil solo, sem network effect, sem risco de ToS (só recebe)
- (+) Reaproveita RecipeTracker/BagScanner/CooldownTracker/TSM/AltManager (supply-side já existe)
- (+) Sinergia com PartyLens sem dependência rígida (convenção → micro-lib depois)
- (-) Sem alcance realm-wide oculto; rede estruturada limitada a guild/grupo/whisper/proximidade
- (-) Precisa de map craft-output nome↔itemID novo (Phase 2) e libs embarcadas (LibSerialize/LibDeflate/CTL)
- (-) `C_ChatInfo` precisa entrar no `.luacheckrc read_globals`
