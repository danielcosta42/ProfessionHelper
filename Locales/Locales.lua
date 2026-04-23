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

    -- Slash Commands
    ["CMD_HELP_HEADER"] = "Comandos disponíveis:",
    ["CMD_HELP_MAIN"] = "/ph ou /professionhelper - Abre a janela principal",
    ["CMD_HELP_SHOW"] = "/ph show - Mostra a janela",
    ["CMD_HELP_HIDE"] = "/ph hide - Esconde a janela",
    ["CMD_HELP_FARM"] = "/ph farm - Inicia sessão de farm",
    ["CMD_HELP_FARM_STOP"] = "/ph farm stop - Para sessão de farm",
    ["CMD_HELP_FARM_TOGGLE"] = "/ph farm toggle - Alterna sessão de farm",
    ["CMD_HELP_FARM_RESET"] = "/ph farm reset - Reseta sessão de farm",
    ["CMD_HELP_FARM_SHOWHIDE"] = "/ph farm show/hide - Mostra/esconde tracker",
    ["CMD_HELP_GUIDE"] = "/ph guide <profissão> - Inicia guia de coleta",
    ["CMD_HELP_HELP"] = "/ph help - Mostra esta ajuda",
    ["CMD_UNKNOWN"] = "Comando desconhecido. Use /ph help para ajuda.",

    -- Minimap Tooltip
    ["MINIMAP_LEFT_CLICK"] = "Click Esquerdo: Abrir janela principal",
    ["MINIMAP_RIGHT_CLICK"] = "Click Direito: Iniciar/Parar Farm Tracker",
    ["MINIMAP_FARM_ACTIVE"] = "Farm ativo:",
    ["MINIMAP_GOLD_PER_HOUR"] = "Gold/hora:",

    -- Farm Tracker Messages
    ["FARM_ALREADY_ACTIVE"] = "Sessão de farm já está ativa! Use |cff00ccff/ph farm stop|r para parar.",
    ["FARM_STARTED_MSG"] = "Sessão de farm iniciada!|r Gold inicial: ",
    ["FARM_NOT_ACTIVE"] = "Nenhuma sessão de farm ativa.",
    ["FARM_ENDED"] = "Sessão de farm encerrada.",
    ["FARM_STAT_DURATION"] = "Duração: %s",
    ["FARM_STAT_GOLD_EARNED"] = "Gold ganho: %s",
    ["FARM_STAT_GOLD_PER_HOUR"] = "Gold/hora: %s",
    ["FARM_TOP_ITEMS"] = "Top itens farmados:",
    ["FARM_RESET_MSG"] = "Sessão de farm resetada.",

    -- Farm Tracker UI
    ["FARM_BTN_STOP"] = "Parar",
    ["FARM_BTN_START"] = "Iniciar",
    ["FARM_GPH_LABEL"] = "Gold / Hora",
    ["FARM_DURATION_LABEL"] = "Duração",
    ["FARM_TOTAL_GOLD_LABEL"] = "Gold Total",
    ["FARM_MOB_GOLD_LABEL"] = "Gold de Mobs",
    ["FARM_EST_VALUE_LABEL"] = "Valor Estimado (TSM)",
    ["FARM_ITEMS_FARMED_LABEL"] = "Itens Farmados",
    ["FARM_STATUS_ACTIVE"] = "Ativo",
    ["FARM_STATUS_STOPPED"] = "Parado",

    -- Gathering Guide
    ["GATHERING_HERE"] = "(aqui)",
    ["GATHERING_GO_TO"] = "Vá para:",
    ["GATHERING_ALTERNATIVES"] = "Alternativas:",
    ["GATHERING_NO_LOCATIONS"] = "Sem locais disponíveis",
    ["GATHERING_STATUS_ACTIVE"] = "Coletando",
    ["GATHERING_STATUS_TRAVELING"] = "Viajando",
    ["GATHERING_ROUTE_LABEL"] = "Rota:",
    ["GATHERING_ROUTE_INFO"] = "WP %d/%d — siga a seta no minimap",
    ["NEXT_STEP_MSG"] = "|cff00ff00Próximo passo!|r Agora faça: |cffffffff%s|r (%d-%d)",

    -- Step Card Badges
    ["BADGE_DONE"] = "CONCLUÍDO",
    ["BADGE_CURRENT"] = ">> FAZENDO AGORA",
    ["BADGE_NEXT"] = "PRÓXIMO",

    -- Step Card Craft Labels
    ["CRAFT_X"] = "Craftar x%d",
    ["CRAFT_X_DONE"] = "Craftar x%d (concluído)",
    ["CRAFTS_REMAINING_LABEL"] = "Faltam:",
    ["CRAFTS_DONE_COUNT"] = "%d feitos",
    ["KEEP_TAG"] = "Guarde!",
    ["INTERMEDIATE_TAG"] = "[Intermediário]",
    ["STEPS_REMAINING"] = "%d passos restantes",
    ["STEP_INLINE_COST"] = "| Custo:",

    -- Material Quantities
    ["MAT_REMAINING"] = "restantes",
    ["MAT_IN_BAG"] = "(%d na bag)",
    ["MAT_USED"] = "(%d/%d usados)",
    ["MAT_IN_STOCK"] = "estoque",
    ["MAT_BUY"] = "comprar",
    ["MAT_EACH"] = "cada",

    -- Step / Next Preview
    ["NEXT_PREVIEW_LABEL"] = "A seguir:",
    ["DONT_SELL"] = "Não venda!",
    ["USED_FOR"] = "Usado para:",
    ["STEP_COST_LABEL"] = "Custo:",

    -- Shopping List
    ["COL_ITEM"] = "Item",
    ["COL_QTY"] = "Qtd",
    ["COL_PRICE"] = "Preço",
    ["INSTALL_TSM"] = "(instale TSM ou Auctionator para preços)",
    ["TSM_BTN_TOOLTIP"] = "Gera string de busca para colar na AH.",
    ["TSM_NO_ITEMS"] = "Nenhum item para buscar na AH.",
    ["TSM_PASTE_MSG"] = "Cole no campo de busca do TSM Shopping na Auction House.",

    -- Gold Farming Guide
    ["GOLD_FARM_GUIDE_TITLE"] = "Guia de Farm de Gold",
    ["GOLD_DATA_UNAVAILABLE"] = "Dados de gold farming não disponíveis.",

    -- Gathering Guide Buttons/UI
    ["GUIDE_STOP_BTN"] = "Parar Guia ■",
    ["GUIDE_START_BTN"] = "▶ Iniciar Guia",
    ["GUIDE_TOOLTIP_TITLE"] = "Guia de Coleta",
    ["GUIDE_TOOLTIP_STOP"] = "Clique para parar o guia e esconder o widget.",
    ["GUIDE_TOOLTIP_START"] = "Abre widget flutuante com passo atual,\nindicador no minimapa e navegação de rota.",
    ["PROGRESS_LABEL"] = "PROGRESSO  %d / %d  (%.0f%%)",
    ["NO_FARM_DATA"] = "Nenhum dado de farm disponível.",
    ["GUIDE_NOT_AVAILABLE"] = "Guia não disponível.",
}
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

    -- Slash Commands
    ["CMD_HELP_HEADER"] = "Available commands:",
    ["CMD_HELP_MAIN"] = "/ph or /professionhelper - Open main window",
    ["CMD_HELP_SHOW"] = "/ph show - Show window",
    ["CMD_HELP_HIDE"] = "/ph hide - Hide window",
    ["CMD_HELP_FARM"] = "/ph farm - Start farm session",
    ["CMD_HELP_FARM_STOP"] = "/ph farm stop - Stop farm session",
    ["CMD_HELP_FARM_TOGGLE"] = "/ph farm toggle - Toggle farm session",
    ["CMD_HELP_FARM_RESET"] = "/ph farm reset - Reset farm session",
    ["CMD_HELP_FARM_SHOWHIDE"] = "/ph farm show/hide - Show/hide tracker",
    ["CMD_HELP_GUIDE"] = "/ph guide <profession> - Start gathering guide",
    ["CMD_HELP_HELP"] = "/ph help - Show this help",
    ["CMD_UNKNOWN"] = "Unknown command. Use /ph help for help.",

    -- Minimap Tooltip
    ["MINIMAP_LEFT_CLICK"] = "Left Click: Open main window",
    ["MINIMAP_RIGHT_CLICK"] = "Right Click: Start/Stop Farm Tracker",
    ["MINIMAP_FARM_ACTIVE"] = "Farm active:",
    ["MINIMAP_GOLD_PER_HOUR"] = "Gold/hour:",

    -- Farm Tracker Messages
    ["FARM_ALREADY_ACTIVE"] = "Farm session already active! Use |cff00ccff/ph farm stop|r to stop.",
    ["FARM_STARTED_MSG"] = "Farm session started!|r Starting gold: ",
    ["FARM_NOT_ACTIVE"] = "No active farm session.",
    ["FARM_ENDED"] = "Farm session ended.",
    ["FARM_STAT_DURATION"] = "Duration: %s",
    ["FARM_STAT_GOLD_EARNED"] = "Gold earned: %s",
    ["FARM_STAT_GOLD_PER_HOUR"] = "Gold/hour: %s",
    ["FARM_TOP_ITEMS"] = "Top farmed items:",
    ["FARM_RESET_MSG"] = "Farm session reset.",

    -- Farm Tracker UI
    ["FARM_BTN_STOP"] = "Stop",
    ["FARM_BTN_START"] = "Start",
    ["FARM_GPH_LABEL"] = "Gold / Hour",
    ["FARM_DURATION_LABEL"] = "Duration",
    ["FARM_TOTAL_GOLD_LABEL"] = "Total Gold",
    ["FARM_MOB_GOLD_LABEL"] = "Mob Gold",
    ["FARM_EST_VALUE_LABEL"] = "Estimated Value (TSM)",
    ["FARM_ITEMS_FARMED_LABEL"] = "Items Farmed",
    ["FARM_STATUS_ACTIVE"] = "Active",
    ["FARM_STATUS_STOPPED"] = "Stopped",

    -- Gathering Guide
    ["GATHERING_HERE"] = "(here)",
    ["GATHERING_GO_TO"] = "Go to:",
    ["GATHERING_ALTERNATIVES"] = "Alternatives:",
    ["GATHERING_NO_LOCATIONS"] = "No locations available",
    ["GATHERING_STATUS_ACTIVE"] = "Gathering",
    ["GATHERING_STATUS_TRAVELING"] = "Traveling",
    ["GATHERING_ROUTE_LABEL"] = "Route:",
    ["GATHERING_ROUTE_INFO"] = "WP %d/%d — follow the arrow on minimap",
    ["NEXT_STEP_MSG"] = "|cff00ff00Next step!|r Now craft: |cffffffff%s|r (%d-%d)",

    -- Step Card Badges
    ["BADGE_DONE"] = "DONE",
    ["BADGE_CURRENT"] = ">> CRAFTING NOW",
    ["BADGE_NEXT"] = "NEXT",

    -- Step Card Craft Labels
    ["CRAFT_X"] = "Craft x%d",
    ["CRAFT_X_DONE"] = "Craft x%d (done)",
    ["CRAFTS_REMAINING_LABEL"] = "Remaining:",
    ["CRAFTS_DONE_COUNT"] = "%d done",
    ["KEEP_TAG"] = "Keep!",
    ["INTERMEDIATE_TAG"] = "[Intermediate]",
    ["STEPS_REMAINING"] = "%d steps remaining",
    ["STEP_INLINE_COST"] = "| Cost:",

    -- Material Quantities
    ["MAT_REMAINING"] = "remaining",
    ["MAT_IN_BAG"] = "(%d in bag)",
    ["MAT_USED"] = "(%d/%d used)",
    ["MAT_IN_STOCK"] = "stock",
    ["MAT_BUY"] = "buy",
    ["MAT_EACH"] = "each",

    -- Step / Next Preview
    ["NEXT_PREVIEW_LABEL"] = "Next up:",
    ["DONT_SELL"] = "Don't sell!",
    ["USED_FOR"] = "Used for:",
    ["STEP_COST_LABEL"] = "Cost:",

    -- Shopping List
    ["COL_ITEM"] = "Item",
    ["COL_QTY"] = "Qty",
    ["COL_PRICE"] = "Price",
    ["INSTALL_TSM"] = "(install TSM or Auctionator for prices)",
    ["TSM_BTN_TOOLTIP"] = "Generates search string to paste in the AH.",
    ["TSM_NO_ITEMS"] = "No items to search in the AH.",
    ["TSM_PASTE_MSG"] = "Paste in the TSM Shopping search field at the Auction House.",

    -- Gold Farming Guide
    ["GOLD_FARM_GUIDE_TITLE"] = "Gold Farming Guide",
    ["GOLD_DATA_UNAVAILABLE"] = "Gold farming data not available.",

    -- Gathering Guide Buttons/UI
    ["GUIDE_STOP_BTN"] = "Stop Guide ■",
    ["GUIDE_START_BTN"] = "▶ Start Guide",
    ["GUIDE_TOOLTIP_TITLE"] = "Gathering Guide",
    ["GUIDE_TOOLTIP_STOP"] = "Click to stop the guide and hide the widget.",
    ["GUIDE_TOOLTIP_START"] = "Opens floating widget with current step,\nminimap indicator and route navigation.",
    ["PROGRESS_LABEL"] = "PROGRESS  %d / %d  (%.0f%%)",
    ["NO_FARM_DATA"] = "No farming data available.",
    ["GUIDE_NOT_AVAILABLE"] = "Guide not available.",

    -- Farming Locations
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

    -- Slash Commands
    ["CMD_HELP_HEADER"] = "Comandos disponibles:",
    ["CMD_HELP_MAIN"] = "/ph o /professionhelper - Abrir ventana principal",
    ["CMD_HELP_SHOW"] = "/ph show - Mostrar ventana",
    ["CMD_HELP_HIDE"] = "/ph hide - Ocultar ventana",
    ["CMD_HELP_FARM"] = "/ph farm - Iniciar sesión de farmeo",
    ["CMD_HELP_FARM_STOP"] = "/ph farm stop - Detener sesión de farmeo",
    ["CMD_HELP_FARM_TOGGLE"] = "/ph farm toggle - Alternar sesión de farmeo",
    ["CMD_HELP_FARM_RESET"] = "/ph farm reset - Reiniciar sesión de farmeo",
    ["CMD_HELP_FARM_SHOWHIDE"] = "/ph farm show/hide - Mostrar/ocultar tracker",
    ["CMD_HELP_GUIDE"] = "/ph guide <profesión> - Iniciar guía de recolección",
    ["CMD_HELP_HELP"] = "/ph help - Mostrar esta ayuda",
    ["CMD_UNKNOWN"] = "Comando desconocido. Usa /ph help para ayuda.",

    -- Minimap Tooltip
    ["MINIMAP_LEFT_CLICK"] = "Click Izquierdo: Abrir ventana principal",
    ["MINIMAP_RIGHT_CLICK"] = "Click Derecho: Iniciar/Detener Farm Tracker",
    ["MINIMAP_FARM_ACTIVE"] = "Farm activo:",
    ["MINIMAP_GOLD_PER_HOUR"] = "Oro/hora:",

    -- Farm Tracker Messages
    ["FARM_ALREADY_ACTIVE"] = "¡Sesión de farmeo ya activa! Usa |cff00ccff/ph farm stop|r para detener.",
    ["FARM_STARTED_MSG"] = "¡Sesión de farmeo iniciada!|r Oro inicial: ",
    ["FARM_NOT_ACTIVE"] = "No hay sesión de farmeo activa.",
    ["FARM_ENDED"] = "Sesión de farmeo terminada.",
    ["FARM_STAT_DURATION"] = "Duración: %s",
    ["FARM_STAT_GOLD_EARNED"] = "Oro ganado: %s",
    ["FARM_STAT_GOLD_PER_HOUR"] = "Oro/hora: %s",
    ["FARM_TOP_ITEMS"] = "Top objetos farmeados:",
    ["FARM_RESET_MSG"] = "Sesión de farmeo reiniciada.",

    -- Farm Tracker UI
    ["FARM_BTN_STOP"] = "Detener",
    ["FARM_BTN_START"] = "Iniciar",
    ["FARM_GPH_LABEL"] = "Oro / Hora",
    ["FARM_DURATION_LABEL"] = "Duración",
    ["FARM_TOTAL_GOLD_LABEL"] = "Oro Total",
    ["FARM_MOB_GOLD_LABEL"] = "Oro de Mobs",
    ["FARM_EST_VALUE_LABEL"] = "Valor Estimado (TSM)",
    ["FARM_ITEMS_FARMED_LABEL"] = "Objetos Farmeados",
    ["FARM_STATUS_ACTIVE"] = "Activo",
    ["FARM_STATUS_STOPPED"] = "Detenido",

    -- Gathering Guide
    ["GATHERING_HERE"] = "(aquí)",
    ["GATHERING_GO_TO"] = "Ve a:",
    ["GATHERING_ALTERNATIVES"] = "Alternativas:",
    ["GATHERING_NO_LOCATIONS"] = "No hay ubicaciones disponibles",
    ["GATHERING_STATUS_ACTIVE"] = "Recolectando",
    ["GATHERING_STATUS_TRAVELING"] = "Viajando",
    ["GATHERING_ROUTE_LABEL"] = "Ruta:",
    ["GATHERING_ROUTE_INFO"] = "WP %d/%d — sigue la flecha en el minimapa",
    ["NEXT_STEP_MSG"] = "|cff00ff00¡Siguiente paso!|r Ahora crea: |cffffffff%s|r (%d-%d)",

    -- Step Card Badges
    ["BADGE_DONE"] = "COMPLETADO",
    ["BADGE_CURRENT"] = ">> HACIENDO AHORA",
    ["BADGE_NEXT"] = "PRÓXIMO",

    -- Step Card Craft Labels
    ["CRAFT_X"] = "Crear x%d",
    ["CRAFT_X_DONE"] = "Crear x%d (completado)",
    ["CRAFTS_REMAINING_LABEL"] = "Faltan:",
    ["CRAFTS_DONE_COUNT"] = "%d hechos",
    ["KEEP_TAG"] = "¡Guarda!",
    ["INTERMEDIATE_TAG"] = "[Intermedio]",
    ["STEPS_REMAINING"] = "%d pasos restantes",
    ["STEP_INLINE_COST"] = "| Costo:",

    -- Material Quantities
    ["MAT_REMAINING"] = "restantes",
    ["MAT_IN_BAG"] = "(%d en bolsa)",
    ["MAT_USED"] = "(%d/%d usados)",
    ["MAT_IN_STOCK"] = "existencias",
    ["MAT_BUY"] = "comprar",
    ["MAT_EACH"] = "c/u",

    -- Step / Next Preview
    ["NEXT_PREVIEW_LABEL"] = "A continuación:",
    ["DONT_SELL"] = "¡No vendas!",
    ["USED_FOR"] = "Usado para:",
    ["STEP_COST_LABEL"] = "Costo:",

    -- Shopping List
    ["COL_ITEM"] = "Objeto",
    ["COL_QTY"] = "Cant",
    ["COL_PRICE"] = "Precio",
    ["INSTALL_TSM"] = "(instala TSM o Auctionator para precios)",
    ["TSM_BTN_TOOLTIP"] = "Genera cadena de búsqueda para pegar en la CA.",
    ["TSM_NO_ITEMS"] = "No hay objetos para buscar en la CA.",
    ["TSM_PASTE_MSG"] = "Pega en el campo de búsqueda de TSM Shopping en la Casa de Subastas.",

    -- Gold Farming Guide
    ["GOLD_FARM_GUIDE_TITLE"] = "Guía de Farmeo de Oro",
    ["GOLD_DATA_UNAVAILABLE"] = "Datos de farmeo de oro no disponibles.",

    -- Gathering Guide Buttons/UI
    ["GUIDE_STOP_BTN"] = "Detener Guía ■",
    ["GUIDE_START_BTN"] = "▶ Iniciar Guía",
    ["GUIDE_TOOLTIP_TITLE"] = "Guía de Recolección",
    ["GUIDE_TOOLTIP_STOP"] = "Clic para detener la guía y ocultar el widget.",
    ["GUIDE_TOOLTIP_START"] = "Abre widget flotante con el paso actual,\nindicador en el minimapa y navegación de ruta.",
    ["PROGRESS_LABEL"] = "PROGRESO  %d / %d  (%.0f%%)",
    ["NO_FARM_DATA"] = "No hay datos de farmeo disponibles.",
    ["GUIDE_NOT_AVAILABLE"] = "Guía no disponible.",
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
