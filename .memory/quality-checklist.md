# ProfessionHelper — Quality Checklist

_Last updated: 2026-04-26_

Execute esta lista antes de considerar qualquer implementação completa.

---

## Namespace & Globals

- [ ] Usa apenas o namespace global `ProfessionHelper` (aliás `PH`)
- [ ] Nenhuma global acidental (todas variáveis file-scope são `local`)
- [ ] Nenhum novo global top-level introduzido
- [ ] Header do arquivo: `local PH = _G.ProfessionHelper`
- [ ] Sub-tabela do módulo declarada com `PH.ModuleName = PH.ModuleName or {}`
- [ ] Sub-tabela do módulo já existe como stub em `Core/Namespace.lua`

## Compatibilidade

- [ ] Todas as chamadas de API sensíveis a versão vão por `PH.Compat`
- [ ] Nenhuma API exclusiva de versão chamada sem guard `if API then`
- [ ] `pcall` usado para chamadas de API arriscadas
- [ ] Version guards usam `PH.interfaceVersion` (não `WOW_PROJECT_ID` direto)
- [ ] `.toc` atualizado se novos arquivos foram adicionados (na ordem correta)

## Arquitetura de Camadas

- [ ] Módulo permanece dentro da sua responsabilidade definida
- [ ] Camadas inferiores não chamam camadas superiores
- [ ] Módulos UI não contêm lógica de dados ou análise
- [ ] Módulos Feature não contêm lógica de UI
- [ ] Módulos Data (Data/*.lua) contêm apenas tabelas Lua puras — zero chamadas de função
- [ ] Nenhuma dependência circular entre módulos

## Identidade de Personagem

- [ ] Nenhuma chamada direta a `UnitName("player")` fora de `Core/Identity.lua`
- [ ] Nenhuma chamada direta a `UnitFactionGroup("player")` fora de `Core/Identity.lua`
- [ ] Nenhuma chamada direta a `GetRealmName()` fora de `Core/Identity.lua`
- [ ] Nenhuma definição local de `GetCharKey()`, `GetCharName()`, `GetRealmKey()`
- [ ] Identidade acessada apenas após `PLAYER_LOGIN`

## Dados & Storage

- [ ] Nenhum acesso direto a `ProfessionHelperDB` fora de `Core/Storage.lua`
- [ ] SavedVariables acessados apenas após `PLAYER_LOGIN` (DB inicializado)
- [ ] `PH.DB:Ensure()` usado para inicializar estruturas antes de escrever
- [ ] `PH.DB:Get()` usado para leitura (nil-safe, sem panic em path vazio)
- [ ] `PH.DB:Set()` usado para escrita
- [ ] Se schema mudou: `DB.SCHEMA_VERSION` incrementado e migration adicionada

## Eventos

- [ ] Nenhum `local eventFrame = CreateFrame("Frame")` em módulos Feature/UI
- [ ] Nenhum `frame:RegisterEvent(...)` diretamente em módulos Feature/UI
- [ ] Todos os eventos registrados via `PH.Event:On(event, handler, "OwnerName")`
- [ ] Owner string é único por módulo (e.g. "BagScanner", "AltManager")
- [ ] `PH.Event:Off("OwnerName")` chamado ao desativar módulo (se aplicável)
- [ ] Eventos internos do addon têm prefixo `PH_` (ex: `PH_FARM_STARTED`)

## Output & UX

- [ ] Nenhum `DEFAULT_CHAT_FRAME:AddMessage()` ou `print()` em módulos
- [ ] Nenhum `PH:Print()` — removido na v2
- [ ] Output via `PH.Logger.Info/Warn/Error` para mensagens de usuário
- [ ] Output debug via `PH.Logger.Debug()` (gateado por `PH.Config:Get("debug")`)
- [ ] Toda string visível ao usuário usa `PH.L["CHAVE"]` (nunca hardcoded)
- [ ] Chaves de locale adicionadas em todos os 3 idiomas: ptBR, enUS, esES

## Localização

- [ ] Todas as novas strings estão em `Locales/Locales.lua`
- [ ] Chave no formato `MODULENAME_CONTEXT_DESCRIPTION` (SCREAMING_SNAKE_CASE)
- [ ] Adicionadas nos 3 blocos: `Locales.ptBR`, `Locales.enUS`, `Locales.esES`
- [ ] Strings sem tradução usam o valor `enUS` como fallback (nunca string vazia)

## Performance

- [ ] Nenhum `OnUpdate` para polling — usa throttled poll de `Core/Init.lua`
- [ ] Nenhuma chamada `GetSpellInfo/GetItemInfo` a cada frame
- [ ] Handlers de evento têm early-exit quando estado não está pronto
- [ ] Nenhuma alocação pesada em handlers de eventos frequentes (`BAG_UPDATE`, etc.)
- [ ] Iterações sobre bags/receitas feitas uma vez e cacheadas

## Correção

- [ ] Todos os nil-paths testados (char não inicializado, DB vazio, etc.)
- [ ] Nenhuma divisão por zero em cálculos de média (ex: farm tracker)
- [ ] Version guard correto para features de expansão específica
- [ ] `Initialize()` idempotente (chamado mais de uma vez não causa problemas)
- [ ] Nenhum estado global mutado durante carregamento de arquivo (apenas em handlers)

## Documentação (.memory/)

- [ ] `implementation-log.md` atualizado com as mudanças desta sessão
- [ ] `architecture.md` atualizado se estrutura de módulos mudou
- [ ] `data-model.md` atualizado se schemas mudaram
- [ ] `decisions.md` atualizado se um novo padrão arquitetural foi introduzido
- [ ] `compatibility-notes.md` atualizado se novo wrapper foi adicionado ao Compat

## Integridade do Addon

- [ ] Addon carrega sem erros Lua no `/reload`
- [ ] `/ph help` exibe comandos esperados
- [ ] `/ph debug` alterna o modo debug corretamente
- [ ] Janela principal abre e fecha via `/ph show` e `/ph hide`
- [ ] Posições de painéis salvas e restauradas após `/reload`
- [ ] `.memory/` não é referenciado em nenhum arquivo `.lua` ou `.toc`
