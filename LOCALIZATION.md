# Sistema de Localização - Profession Helper

## Idiomas Suportados

O addon agora suporta **3 idiomas**:
- **Português (ptBR)** - Português do Brasil
- **Inglês (enUS)** - English (US)
- **Español (esES/esMX)** - Español (Europa y México)

## Detecção Automática

O idioma é detectado automaticamente baseado na configuração do cliente do WoW:
- `GetLocale()` retorna o idioma do cliente
- O sistema mapeia automaticamente para um dos idiomas suportados
- Se o idioma não for suportado, **o inglês é usado como padrão**

## Como Usar no Código

### Acessar Strings Traduzidas

```lua
-- Usar a tabela ProfessionHelper.L para acessar strings traduzidas
local text = ProfessionHelper.L["ADDON_NAME"]
local welcomeText = ProfessionHelper.L["WELCOME_LINE1"]

-- Para nomes de profissões traduzidos
local localizedName = PH:GetLocalizedProfessionName("Alchemy")
-- Retorna: "Alquimia" (PT), "Alchemy" (EN), "Alquimia" (ES)

-- Para skill tiers traduzidos
local tierName = PH:GetSkillTier(150)
-- Retorna: "Perito" (PT), "Expert" (EN), "Experto" (ES)
```

### Strings com Formatação

Para strings que precisam de valores dinâmicos, use `string.format`:

```lua
-- Exemplo: "Passo 1", "Step 1", "Paso 1"
local stepText = string.format(PH.L["STEP"], stepNumber)

-- Exemplo: "Skill 1-75", "Skill 1-75", "Habilidad 1-75"
local rangeText = string.format(PH.L["SKILL_RANGE"], start, finish)
```

## Categorias de Strings

### UI Geral
- `ADDON_NAME` - Nome do addon
- `SELECT_PROFESSION` - Texto de seleção
- `WELCOME_LINE1-4` - Linhas de boas-vindas
- `DATA_NOT_FOUND` - Erro de dados não encontrados

### Abas
- `TAB_LEVELING` - Aba de leveling
- `TAB_SHOPPING` - Aba de compras
- `TAB_FARMING` - Aba de farm

### Status de Profissão
- `NOT_LEARNED` - "Não aprendida"
- `SKILL_LEVEL` - Formato do nível de skill

### Profissões
Todas as profissões têm suas traduções:
- `Alchemy`, `Blacksmithing`, `Enchanting`, etc.
- Profissões combo: `Herbalism & Alchemy`, etc.

### Tiers de Skill
- `Apprentice` - Aprendiz / Apprentice / Aprendiz
- `Journeyman` - Profissional / Journeyman / Oficial
- `Expert` - Perito / Expert / Experto
- `Artisan` - Artesão / Artisan / Artesano
- `Master` - Mestre / Master / Maestro

### Guia de Crafting
- `STEP` - "Passo %d" com formatação
- `SKILL_RANGE` - "Skill %d-%d" com formatação
- `MATERIALS` - Materiais
- `MATERIALS_REMAINING` - Materiais restantes
- `RECIPE` - Receita
- `TIP` - Dica
- `VENDOR` - Vendedor
- `TRAINER` - Treinador
- `TRAINERS` - TREINADORES
- `CURRENT` - Botão atual
- `NEXT` - Próximo
- `PREVIOUS` - Anterior
- `MAX_LEVEL_REACHED` - Nível máximo atingido
- `NO_MATERIALS_NEEDED` - Sem materiais necessários
- `LOCATIONS` - Locais

### Farming
- `FARM_LOCATIONS` - Locais de farmeo
- `ZONE` - Zona
- `LOCATION` - Localização
- `LEVEL` - Nível
- `RECOMMENDED` - Recomendado

### Compras
- `SHOPPING_LIST` - Lista de compras
- `TOTAL_MATERIALS` - Total de materiais
- `BUYABLE` - Comprável
- `FARMABLE` - Farmável

### Farm de Gold
- `GOLD_FARMING` - Farm de gold
- `GOLD_PER_HOUR` - Gold/Hora
- `DIFFICULTY` - Dificuldade
- `EASY` - Fácil
- `MEDIUM` - Médio
- `HARD` - Difícil
- `VERY_HARD` - Muito difícil

## Adicionando Novas Strings

Para adicionar uma nova string traduzida:

1. Abra `Locales/Locales.lua`
2. Adicione a chave em **todos os 3 idiomas** (ptBR, enUS, esES):

```lua
-- Em Locales.ptBR
["NOVA_STRING"] = "Texto em Português",

-- Em Locales.enUS
["NOVA_STRING"] = "Text in English",

-- Em Locales.esES
["NOVA_STRING"] = "Texto en Español",
```

3. Use no código:
```lua
local text = PH.L["NOVA_STRING"]
```

## Debugging

Para verificar o idioma ativo:
```lua
print("Idioma atual:", ProfessionHelper.Locale)
-- Saída: "ptBR", "enUS", ou "esES"
```

Para acessar todas as tabelas de localização:
```lua
-- Ver todas as strings em inglês
for key, value in pairs(ProfessionHelper.AllLocales.enUS) do
    print(key, value)
end
```

## Notas Importantes

1. **SEMPRE** use `PH.L["KEY"]` para textos visíveis ao usuário
2. **NUNCA** coloque strings hardcoded diretamente na UI
3. Mantenha as 3 traduções sincronizadas
4. Use nomes de chave em UPPER_CASE para facilitar identificação
5. IDs internos (como nomes de profissões em `Core.lua`) permanecem em inglês
6. A tradução acontece apenas na camada de apresentação (UI)

## Estrutura de Arquivos

```
Locales/
  └─ Locales.lua          # Sistema completo de localização
     ├─ Locales.ptBR      # Traduções em português
     ├─ Locales.enUS      # Traduções em inglês
     └─ Locales.esES      # Traduções em espanhol
```

## Compatibilidade

O sistema é totalmente compatível com:
- WoW Classic (TBC)
- WoW Classic Era
- Clientes em qualquer idioma suportado pelo WoW

Clientes em outros idiomas (deDE, frFR, ruRU, etc.) automaticamente usarão inglês como fallback.
