# ProfessionHelper — Architectural Decision Records

_Last updated: 2026-07-05_

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

---

## ADR-0009 — Rotas de gather: seed real do Wowhead (via GatherMate2_Data) + waypoints redesenhados

**Status:** Aceito (implementado — v1.28.0)

**Context:**  
Os waypoints de gather eram loops circulares hand-drawn (`ZONE_ROUTES`, ~8 pontos/zona) —
imprecisos e visualmente feios (quadrados brancos; depois dots com "borda" que na verdade era
um círculo preto PREENCHIDO maior que o dot → tudo lia como bolinha escura). O usuário pediu
precisão real e visual estilo Zygor "com a nossa cara" (teal).

**Decision:**  
1. **Seed real, baked-in.** `Data/GatherSeed.lua` é gerado a partir do `GatherMate2_Data` (BCC,
   dados do Wowhead) que o usuário tem instalado. Formato de coord do GatherMate2:
   `coord = floor(x*10000)*1000000 + floor(y*10000)*100 + level`; zonas keyed por **uiMapID**
   (mesmo espaço do `C_Map.GetBestMapForUnit`, então seed + coleta ao vivo fazem merge direto).
   Filtrado a nível 0 (superfície), grid-downsample ~0.02 → ~16k nós, ~114KB. Regenerar via
   `scratchpad/gen_seed.py` (Python; parser linha-a-linha do `.lua` do GatherMate2).
2. **Seed separado do DB do usuário** (`PH.GatherSeed`, in-memory, read-only). `GatherData:GetNodes`
   faz union seed + nós crowd-sourced (dedup por célula 0.001). Seed não incha SavedVariables e
   sempre vem fresco no update.
3. **Rota de nós evenly-spaced:** `BuildNodeRoute` faz thinning espacial (min gap 0.045, máx 50 WP)
   e depois nearest-neighbor — dots não empilham em clusters densos. Zona é elegível se tem ≥6 nós
   (seed OU ao vivo) OU rota hardcoded (fallback). Cobre MUITO mais zonas que os loops antigos.
4. **Visual:** textura própria `Media/route-dot.tga` (círculo AA branco 64×64, tintável) referenciada
   COM extensão `.tga` (convenção LibSharedMedia, carrega em Classic/TBC). Dot = fill teal/gold +
   rim escuro suave (não mais blob preto). Trilha = dots pequenos evenly-spaced (spacing 0.02 mapa /
   0.008 minimapa), não mais smear denso de `dist*300`.

**Consequences:**
- (+) Rotas precisas desde o 1º login, sem depender de coletar; melhora com o uso (mesh).
- (+) Standalone — não requer GatherMate2 em runtime (só foi a fonte do seed offline).
- (-) +114KB no addon; seed só cobre herb/ore (skinning/fishing seguem sem seed).
- (-) Assume que uiMapIDs do GatherMate2_Data == C_Map do cliente 2.5.5 (verdade: GatherMate2 roda
  neste cliente). Se a textura `.tga` não carregar em algum cliente, dots somem (baixo risco).
- Regeneração do seed é offline (Python), não parte do build de CI.

**Refinamento (v1.28.1):** Rota node — depois do nearest-neighbor, roda **2-opt** (fecha
cruzamentos; removeu os saltos longos que faziam a rota "zigzagar" — pior aresta de Tirisfal
0.47→0.18). Afinada a ~30 waypoints (MINSPACE 0.06). Visual "Zygor": fita de **glow suave**
(`Media/route-glow.tga`, ADD blend) com dots espaçados por **jardas reais** (via `HBD:GetZoneSize`,
não mais fração de mapa) + halo de brilho nos marcadores. Prévia validada com dados reais de
Tirisfal antes do deploy.

---

## ADR-0010 — Modelo de rota estendido a Skinning/Fishing + auditoria de dados (v1.29.0)

**Status:** Aceito (parcial — parity feito; gaps de qualidade catalogados).

**Context:** Depois do sucesso das rotas de herb/ore (seed Wowhead + node route + 2-opt + glow),
pedido de "todas as profissões no mesmo modelo e qualidade". Auditoria dos 18 arquivos de Data.

**Decision:**
- **Skinning (8613) e Fishing (7620)** entram no mesmo pipeline de coleta crowd-source do GatherData
  → PROF_NTYPE skin/fish → node route + 2-opt + glow. **Sem seed** (GatherMate2 não mapeia mob/água),
  então preenchem pelo uso e via mesh. Coleta agora casa por **nome de spell** (além do ID) p/ pegar
  os vários ranks de Fishing + locales. Removidos IDs falsos (2383 = tracking Find Herbs, não coleta).
- **Fishing.lua `type="gathering"`** (apesar do registry dizer "secondary") — é *load-bearing*: é o que
  faz o Fishing mostrar a rota (Main.lua:933 usa `profData.type`). NÃO mudar.
- Corrigido `faction="Respective"` inválido (Fishing.lua) → "Both" (escondia a location de todos).

**Gaps de qualidade achados (pendentes, NÃO corrigidos — precisam de decisão/verificação):**
1. Texto de `synergies` hardcoded em **português** em ~11 arquivos EN (Alchemy:310, BS:342, Eng:629…) —
   inconsistência de localização (users EN/ES veem PT).
2. farmingLocations de Herb/Mining: tiers 1–375 usam locale keys, 375–525 hardcoded EN. Inscription/
   Archaeology 100% hardcoded EN.
3. `materials = {}` vazio em TODOS os 23 steps dos 3 guias combo.
4. Nomes de zona vagos no Fishing ("Any Starting Zone") não resolvem mapID → rota não aparece.
5. Drift de chaves em farmingLocations (Fishing usa spot/recommended; Skinning add mobs) — cosmético.

**Consequences:** modelo de rota agora uniforme p/ as 3 gathering + fishing. Qualidade de *dados*
(localização/combos) fica como próximo lote, priorizado pelo usuário.
