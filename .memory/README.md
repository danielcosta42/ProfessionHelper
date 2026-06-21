# ProfessionHelper — Project Memory

> ## ⚠ DIRETIVA PRINCIPAL DO PROJETO
> **Antes de implementar qualquer coisa:**
> 1. **Leia** os arquivos `.memory/` relevantes para a tarefa.
> 2. **Implemente** a mudança seguindo o que foi lido.
> 3. **Atualize** `.memory/implementation-log.md` com o que mudou, por quê, e arquivos tocados.
> 4. **Atualize** qualquer outro `.md` afetado (`architecture.md`, `data-model.md`, etc.).
>
> Sem exceção. Ler → Implementar → Escrever.

Esta pasta é **tooling local de desenvolvimento**. Listada em `.gitignore` e nunca deve ser
commitada ou distribuída.

O addon **não tem dependência em tempo de execução** de nada dentro de `.memory/`.

---

## Purpose

`.memory/` é a camada de governança para desenvolvimento assistido por IA do ProfessionHelper.
Captura decisões de arquitetura, padrões de código, modelos de dados e um log de implementação
contínuo para que toda mudança — humana ou por agente IA — permaneça consistente com a intenção
do projeto.

---

## Index

| Arquivo | Propósito |
|---|---|
| `README.md` | Este arquivo. Ponto de entrada e instruções do Copilot. |
| `architecture.md` | Mapa de módulos, fluxo de dados, ordem de carregamento |
| `coding-standards.md` | Regras de namespace, padrão de módulo, performance, proibições |
| `quality-checklist.md` | Lista de verificação pré-implementação |
| `data-model.md` | Schema do SavedVariables, estruturas de profissão, tipos |
| `compatibility-notes.md` | Matriz API Retail vs Classic, wrappers do Compat |
| `decisions.md` | Architectural Decision Records (ADRs) |
| `implementation-log.md` | Log contínuo de cada sessão de mudança |

---

# Instruções para Copilot / Agente IA

Antes de fazer **qualquer** mudança neste addon:

1. Leia `.memory/architecture.md` — entenda as camadas e fronteiras dos módulos.
2. Leia `.memory/coding-standards.md` — siga os padrões de namespace e módulo.
3. Leia `.memory/quality-checklist.md` — verifique sua implementação contra ela.
4. Leia `.memory/compatibility-notes.md` — se tocar qualquer chamada de API.
5. Leia `.memory/data-model.md` — se tocar estruturas de dados ou SavedVariables.

Durante a implementação:

6. Respeite fronteiras de módulo. Não misture responsabilidades entre arquivos.
7. Não crie padrões arquiteturais novos sem adicionar um ADR em `decisions.md`.
8. Nunca contorne `PH.Compat` — envolva toda API sensível a versão lá.
9. Nunca acesse `ProfessionHelperDB` diretamente fora de `Core/Storage.lua`.
10. Nunca chame `UnitName("player")` ou `GetRealmName()` fora de `Core/Identity.lua`.
11. Nunca crie `eventFrame` por módulo — use `PH.Event:On(...)`.
12. Nunca adicione globais fora do namespace `ProfessionHelper`.

Após a implementação:

13. Atualize `implementation-log.md` com o que mudou, por quê, e arquivos tocados.
14. Atualize `architecture.md` ou `data-model.md` se o comportamento mudou.
15. Se incerto sobre uma decisão de design, prefira **mudanças modulares menores** a grandes rewrites.

---

## Regras Absolutas (nunca negociáveis)

- `.memory/` **nunca** é carregado pelo WoW nem referenciado por nenhum arquivo `.lua`.
- `ProfessionHelper` (aliás `PH`) é o único global. Sem exceções.
- Toda chamada de API sensível a versão passa por `PH.Compat`.
- Todo acesso ao SavedVariables passa por `PH.DB`.
- Toda identidade de personagem/realm vem de `PH.Identity`.
- Todo output de texto ao usuário usa `PH.Logger`.
- Todo evento WoW é registrado via `PH.Event:On(...)` — nunca `CreateFrame` por módulo.
