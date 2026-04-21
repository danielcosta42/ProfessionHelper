-- Profession Helper - Localization System
-- Supports: Portuguese (ptBR), English (enUS), Spanish (esES/esMX)

ProfessionHelper = ProfessionHelper or {}

-- Locale tables
local Locales = {}

-------------------------------------------------------------------------------
-- PORTUGUÊS (ptBR)
-------------------------------------------------------------------------------
Locales.ptBR = {
    -- UI General
    ["ADDON_NAME"] = "Profession Helper",
    ["SELECT_PROFESSION"] = "Selecione uma profissão na barra lateral.",
    ["WELCOME_LINE1"] = "Guia passo-a-passo",
    ["WELCOME_LINE2"] = "Lista de compras inteligente",
    ["WELCOME_LINE3"] = "Locais de farm",
    ["WELCOME_LINE4"] = "Integração TSM",
    ["DATA_NOT_FOUND"] = "Dados não encontrados para: %s",
    
    -- Tabs
    ["TAB_LEVELING"] = "Leveling",
    ["TAB_SHOPPING"] = "Compras",
    ["TAB_FARMING"] = "Farm",
    
    -- Profession Status
    ["NOT_LEARNED"] = "Não aprendida",
    ["SKILL_LEVEL"] = "%d / %d",
    
    -- Professions
    ["Alchemy"] = "Alquimia",
    ["Blacksmithing"] = "Ferraria",
    ["Enchanting"] = "Encantamento",
    ["Engineering"] = "Engenharia",
    ["Jewelcrafting"] = "Joalheria",
    ["Leatherworking"] = "Couraria",
    ["Tailoring"] = "Alfaiataria",
    ["Cooking"] = "Culinária",
    ["First Aid"] = "Primeiros Socorros",
    ["Mining"] = "Mineração",
    ["Herbalism"] = "Herbalismo",
    ["Skinning"] = "Esfolamento",
    ["Fishing"] = "Pesca",
    ["Herbalism & Alchemy"] = "Herbalismo & Alquimia",
    ["Skinning & Leatherworking"] = "Esfolamento & Couraria",
    ["Fishing & Cooking"] = "Pesca & Culinária",
    
    -- Skill Tiers
    ["Apprentice"] = "Aprendiz",
    ["Journeyman"] = "Profissional",
    ["Expert"] = "Perito",
    ["Artisan"] = "Artesão",
    ["Master"] = "Mestre",
    
    -- Skill Colors
    ["ORANGE"] = "Laranja",
    ["YELLOW"] = "Amarelo",
    ["GREEN"] = "Verde",
    ["GREY"] = "Cinza",
    
    -- Crafting Guide
    ["STEP"] = "Passo %d",
    ["SKILL_RANGE"] = "Skill %d-%d",
    ["MAKE"] = "Fazer",
    ["CRAFT"] = "Craftear",
    ["TOTAL_COST"] = "Custo Total",
    ["MATERIALS_NEEDED"] = "Materiais Necessários",
    ["MATERIALS"] = "Materiais",
    ["MATERIALS_REMAINING"] = "Materiais restantes",
    ["RECIPES_TO_CRAFT"] = "Receitas para Craftar",
    ["RECIPE"] = "Receita",
    ["TIP"] = "Dica",
    ["VENDOR"] = "Vendedor",
    ["TRAINER"] = "Treinador",
    ["TRAINERS"] = "TREINADORES",
    ["CURRENT"] = "Atual",
    ["NEXT"] = "Próximo",
    ["PREVIOUS"] = "Anterior",
    ["MAX_LEVEL_REACHED"] = "Nível Máximo Atingido! (375)",
    ["NO_MATERIALS_NEEDED"] = "Nível máximo ou nenhum material necessário.",
    ["LOCATIONS"] = "Locais",
    
    -- Farming
    ["FARM_LOCATIONS"] = "Locais de Farm",
    ["ZONE"] = "Zona",
    ["LOCATION"] = "Localização",
    ["LEVEL"] = "Nível",
    ["RECOMMENDED"] = "Recomendado",
    
    -- Shopping
    ["SHOPPING_LIST"] = "Lista de Compras",
    ["TOTAL_MATERIALS"] = "Total de Materiais",
    ["BUYABLE"] = "Comprável",
    ["FARMABLE"] = "Farmável",
    
    -- Gold Farming
    ["GOLD_FARMING"] = "Farm de Gold",
    ["GOLD_PER_HOUR"] = "Gold/Hora",
    ["DIFFICULTY"] = "Dificuldade",
    ["EASY"] = "Fácil",
    ["MEDIUM"] = "Médio",
    ["HARD"] = "Difícil",
    ["VERY_HARD"] = "Muito Difícil",
    
    -- Credits & About
    ["CREDITS"] = "Créditos",
    ["ABOUT"] = "Sobre",
    ["VERSION"] = "Versão",
    ["AUTHOR"] = "Autor",
    ["DEVELOPED_BY"] = "Desenvolvido por",
    ["GITHUB"] = "GitHub",
    ["VISIT_GITHUB"] = "Visite o repositório no GitHub",
    ["SUPPORT"] = "Suporte",
    ["REPORT_BUGS"] = "Reportar bugs e sugestões",
    ["THANK_YOU"] = "Obrigado por usar Profession Helper!",
    ["DESCRIPTION_LINE1"] = "Guia completo de profissões para TBC Classic",
    ["DESCRIPTION_LINE2"] = "Otimize seu leveling com rotas inteligentes",
    ["DESCRIPTION_LINE3"] = "Integração com TSM e cálculo de custos",
    ["DESCRIPTION_LINE4"] = "Suporte para todas as profissões e combinações",
    ["FEATURES"] = "Recursos",
    ["FEATURE_1"] = "Guias passo-a-passo otimizados",
    ["FEATURE_2"] = "Lista de compras automática",
    ["FEATURE_3"] = "Locais de farm e gathering",
    ["FEATURE_4"] = "Cálculo de custos com TSM",
    ["FEATURE_5"] = "Suporte a 3 idiomas (PT/EN/ES)",
    ["FEATURE_6"] = "Interface moderna e limpa",
    ["LICENSE"] = "Licença",
    ["LICENSE_TEXT"] = "Livre para uso pessoal. Código aberto no GitHub.",
}

-------------------------------------------------------------------------------
-- ENGLISH (enUS)
-------------------------------------------------------------------------------
Locales.enUS = {
    -- UI General
    ["ADDON_NAME"] = "Profession Helper",
    ["SELECT_PROFESSION"] = "Select a profession from the sidebar.",
    ["WELCOME_LINE1"] = "Step-by-step guide",
    ["WELCOME_LINE2"] = "Smart shopping list",
    ["WELCOME_LINE3"] = "Farming locations",
    ["WELCOME_LINE4"] = "TSM Integration",
    ["DATA_NOT_FOUND"] = "Data not found for: %s",
    
    -- Tabs
    ["TAB_LEVELING"] = "Leveling",
    ["TAB_SHOPPING"] = "Shopping",
    ["TAB_FARMING"] = "Farming",
    
    -- Profession Status
    ["NOT_LEARNED"] = "Not learned",
    ["SKILL_LEVEL"] = "%d / %d",
    
    -- Professions
    ["Alchemy"] = "Alchemy",
    ["Blacksmithing"] = "Blacksmithing",
    ["Enchanting"] = "Enchanting",
    ["Engineering"] = "Engineering",
    ["Jewelcrafting"] = "Jewelcrafting",
    ["Leatherworking"] = "Leatherworking",
    ["Tailoring"] = "Tailoring",
    ["Cooking"] = "Cooking",
    ["First Aid"] = "First Aid",
    ["Mining"] = "Mining",
    ["Herbalism"] = "Herbalism",
    ["Skinning"] = "Skinning",
    ["Fishing"] = "Fishing",
    ["Herbalism & Alchemy"] = "Herbalism & Alchemy",
    ["Skinning & Leatherworking"] = "Skinning & Leatherworking",
    ["Fishing & Cooking"] = "Fishing & Cooking",
    
    -- Skill Tiers
    ["Apprentice"] = "Apprentice",
    ["Journeyman"] = "Journeyman",
    ["Expert"] = "Expert",
    ["Artisan"] = "Artisan",
    ["Master"] = "Master",
    
    -- Skill Colors
    ["ORANGE"] = "Orange",
    ["YELLOW"] = "Yellow",
    ["GREEN"] = "Green",
    ["GREY"] = "Grey",
    
    -- Crafting Guide
    ["STEP"] = "Step %d",
    ["SKILL_RANGE"] = "Skill %d-%d",
    ["MAKE"] = "Make",
    ["CRAFT"] = "Craft",
    ["TOTAL_COST"] = "Total Cost",
    ["MATERIALS_NEEDED"] = "Materials Needed",
    ["MATERIALS"] = "Materials",
    ["MATERIALS_REMAINING"] = "Materials Remaining",
    ["RECIPES_TO_CRAFT"] = "Recipes to Craft",
    ["RECIPE"] = "Recipe",
    ["TIP"] = "Tip",
    ["VENDOR"] = "Vendor",
    ["TRAINER"] = "Trainer",
    ["TRAINERS"] = "TRAINERS",
    ["CURRENT"] = "Current",
    ["NEXT"] = "Next",
    ["PREVIOUS"] = "Previous",
    
    -- Credits & About
    ["CREDITS"] = "Credits",
    ["ABOUT"] = "About",
    ["VERSION"] = "Version",
    ["AUTHOR"] = "Author",
    ["DEVELOPED_BY"] = "Developed by",
    ["GITHUB"] = "GitHub",
    ["VISIT_GITHUB"] = "Visit the GitHub repository",
    ["SUPPORT"] = "Support",
    ["REPORT_BUGS"] = "Report bugs and suggestions",
    ["THANK_YOU"] = "Thank you for using Profession Helper!",
    ["DESCRIPTION_LINE1"] = "Complete profession guide for TBC Classic",
    ["DESCRIPTION_LINE2"] = "Optimize your leveling with smart routes",
    ["DESCRIPTION_LINE3"] = "TSM integration and cost calculation",
    ["DESCRIPTION_LINE4"] = "Support for all professions and combinations",
    ["FEATURES"] = "Features",
    ["FEATURE_1"] = "Optimized step-by-step guides",
    ["FEATURE_2"] = "Automatic shopping lists",
    ["FEATURE_3"] = "Farm and gathering locations",
    ["FEATURE_4"] = "Cost calculation with TSM",
    ["FEATURE_5"] = "Support for 3 languages (PT/EN/ES)",
    ["FEATURE_6"] = "Modern and clean interface",
    ["LICENSE"] = "License",
    ["LICENSE_TEXT"] = "Free for personal use. Open source on GitHub.",
    ["MAX_LEVEL_REACHED"] = "Maximum Level Reached! (375)",
    ["NO_MATERIALS_NEEDED"] = "Maximum level or no materials needed.",
    ["LOCATIONS"] = "Locations",
    
    -- Farming
    ["FARM_LOCATIONS"] = "Farming Locations",
    ["ZONE"] = "Zone",
    ["LOCATION"] = "Location",
    ["LEVEL"] = "Level",
    ["RECOMMENDED"] = "Recommended",
    
    -- Shopping
    ["SHOPPING_LIST"] = "Shopping List",
    ["TOTAL_MATERIALS"] = "Total Materials",
    ["BUYABLE"] = "Buyable",
    ["FARMABLE"] = "Farmable",
    
    -- Gold Farming
    ["GOLD_FARMING"] = "Gold Farming",
    ["GOLD_PER_HOUR"] = "Gold/Hour",
    ["DIFFICULTY"] = "Difficulty",
    ["EASY"] = "Easy",
    ["MEDIUM"] = "Medium",
    ["HARD"] = "Hard",
    ["VERY_HARD"] = "Very Hard",
}

-------------------------------------------------------------------------------
-- ESPAÑOL (esES/esMX)
-------------------------------------------------------------------------------
Locales.esES = {
    -- UI General
    ["ADDON_NAME"] = "Profession Helper",
    ["SELECT_PROFESSION"] = "Selecciona una profesión de la barra lateral.",
    ["WELCOME_LINE1"] = "Guía paso a paso",
    ["WELCOME_LINE2"] = "Lista de compras inteligente",
    ["WELCOME_LINE3"] = "Ubicaciones de farmeo",
    ["WELCOME_LINE4"] = "Integración TSM",
    ["DATA_NOT_FOUND"] = "Datos no encontrados para: %s",
    
    -- Tabs
    ["TAB_LEVELING"] = "Subir Nivel",
    ["TAB_SHOPPING"] = "Compras",
    ["TAB_FARMING"] = "Farmeo",
    
    -- Profession Status
    ["NOT_LEARNED"] = "No aprendida",
    ["SKILL_LEVEL"] = "%d / %d",
    
    -- Professions
    ["Alchemy"] = "Alquimia",
    ["Blacksmithing"] = "Herrería",
    ["Enchanting"] = "Encantamiento",
    ["Engineering"] = "Ingeniería",
    ["Jewelcrafting"] = "Joyería",
    ["Leatherworking"] = "Peletería",
    ["Tailoring"] = "Sastrería",
    ["Cooking"] = "Cocina",
    ["First Aid"] = "Primeros Auxilios",
    ["Mining"] = "Minería",
    ["Herbalism"] = "Herboristería",
    ["Skinning"] = "Desuello",
    ["Fishing"] = "Pesca",
    ["Herbalism & Alchemy"] = "Herboristería y Alquimia",
    ["Skinning & Leatherworking"] = "Desuello y Peletería",
    ["Fishing & Cooking"] = "Pesca y Cocina",
    
    -- Skill Tiers
    ["Apprentice"] = "Aprendiz",
    ["Journeyman"] = "Oficial",
    ["Expert"] = "Experto",
    ["Artisan"] = "Artesano",
    ["Master"] = "Maestro",
    
    -- Skill Colors
    ["ORANGE"] = "Naranja",
    ["YELLOW"] = "Amarillo",
    ["GREEN"] = "Verde",
    ["GREY"] = "Gris",
    
    -- Crafting Guide
    ["STEP"] = "Paso %d",
    ["SKILL_RANGE"] = "Habilidad %d-%d",
    ["MAKE"] = "Hacer",
    ["CRAFT"] = "Crear",
    ["TOTAL_COST"] = "Costo Total",
    ["MATERIALS_NEEDED"] = "Materiales Necesarios",
    ["MATERIALS"] = "Materiales",
    ["MATERIALS_REMAINING"] = "Materiales Restantes",
    ["RECIPES_TO_CRAFT"] = "Recetas para Crear",
    ["RECIPE"] = "Receta",
    ["TIP"] = "Consejo",
    ["VENDOR"] = "Vendedor",
    ["TRAINER"] = "Entrenador",
    ["TRAINERS"] = "ENTRENADORES",
    ["CURRENT"] = "Actual",
    ["NEXT"] = "Siguiente",
    ["PREVIOUS"] = "Anterior",
    
    -- Credits & About
    ["CREDITS"] = "Créditos",
    ["ABOUT"] = "Acerca de",
    ["VERSION"] = "Versión",
    ["AUTHOR"] = "Autor",
    ["DEVELOPED_BY"] = "Desarrollado por",
    ["GITHUB"] = "GitHub",
    ["VISIT_GITHUB"] = "Visita el repositorio en GitHub",
    ["SUPPORT"] = "Soporte",
    ["REPORT_BUGS"] = "Reportar errores y sugerencias",
    ["THANK_YOU"] = "¡Gracias por usar Profession Helper!",
    ["DESCRIPTION_LINE1"] = "Guía completa de profesiones para TBC Classic",
    ["DESCRIPTION_LINE2"] = "Optimiza tu subida con rutas inteligentes",
    ["DESCRIPTION_LINE3"] = "Integración con TSM y cálculo de costos",
    ["DESCRIPTION_LINE4"] = "Soporte para todas las profesiones y combinaciones",
    ["FEATURES"] = "Características",
    ["FEATURE_1"] = "Guías paso a paso optimizadas",
    ["FEATURE_2"] = "Listas de compras automáticas",
    ["FEATURE_3"] = "Ubicaciones de farmeo y recolección",
    ["FEATURE_4"] = "Cálculo de costos con TSM",
    ["FEATURE_5"] = "Soporte para 3 idiomas (PT/EN/ES)",
    ["FEATURE_6"] = "Interfaz moderna y limpia",
    ["LICENSE"] = "Licencia",
    ["LICENSE_TEXT"] = "Libre para uso personal. Código abierto en GitHub.",
    ["MAX_LEVEL_REACHED"] = "¡Nivel Máximo Alcanzado! (375)",
    ["NO_MATERIALS_NEEDED"] = "Nivel máximo o no se necesitan materiales.",
    ["LOCATIONS"] = "Ubicaciones",
    
    -- Farming
    ["FARM_LOCATIONS"] = "Ubicaciones de Farmeo",
    ["ZONE"] = "Zona",
    ["LOCATION"] = "Ubicación",
    ["LEVEL"] = "Nivel",
    ["RECOMMENDED"] = "Recomendado",
    
    -- Shopping
    ["SHOPPING_LIST"] = "Lista de Compras",
    ["TOTAL_MATERIALS"] = "Total de Materiales",
    ["BUYABLE"] = "Comprable",
    ["FARMABLE"] = "Farmeable",
    
    -- Gold Farming
    ["GOLD_FARMING"] = "Farmeo de Oro",
    ["GOLD_PER_HOUR"] = "Oro/Hora",
    ["DIFFICULTY"] = "Dificultad",
    ["EASY"] = "Fácil",
    ["MEDIUM"] = "Medio",
    ["HARD"] = "Difícil",
    ["VERY_HARD"] = "Muy Difícil",
}

-- Copy esES to esMX
Locales.esMX = Locales.esES

-------------------------------------------------------------------------------
-- Auto-detect locale and set default
-------------------------------------------------------------------------------
local function GetGameLocale()
    local locale = GetLocale()
    -- Map game locales to our supported locales
    if locale == "ptBR" then
        return "ptBR"
    elseif locale == "esES" or locale == "esMX" then
        return "esES"
    else
        -- Default to English for all other locales
        return "enUS"
    end
end

-- Set active locale
local activeLocale = GetGameLocale()
ProfessionHelper.L = Locales[activeLocale] or Locales.enUS

-- Expose locale info for debugging
ProfessionHelper.Locale = activeLocale
ProfessionHelper.AllLocales = Locales
