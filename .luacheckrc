-- Luacheck configuration for ProfessionHelper WoW Addon

std = "lua51"
max_line_length = false

-- Globals that the addon WRITES to
globals = {
    -- Addon tables
    "PH",
    "ProfessionHelperDB",

    -- Slash commands
    "SlashCmdList",
    "SLASH_PROFESSIONHELPER1",
    "SLASH_PROFESSIONHELPER2",
}

-- Globals that the addon READS (WoW environment)
read_globals = {
    -- WoW API: Frames & UI
    "CreateFrame",
    "UIParent",
    "GameTooltip",
    "GameFontNormal",
    "GameFontNormalSmall",
    "GameFontNormalLarge",
    "GameFontNormalHuge",
    "GameFontHighlight",
    "GameFontHighlightSmall",
    "BackdropTemplateMixin",
    "STANDARD_TEXT_FONT",
    "DEFAULT_CHAT_FRAME",
    "Minimap",

    -- WoW API: Input
    "IsShiftKeyDown",
    "IsControlKeyDown",
    "IsAltKeyDown",

    -- WoW API: Locale & Game
    "GetLocale",
    "GetTime",
    "GetRealmName",
    "ReloadUI",
    "InCombatLockdown",
    "PlaySound",
    "hooksecurefunc",
    "StaticPopup_Show",
    "ChatFrame_AddMessageEventFilter",

    -- WoW API: Items & Inventory
    "GetItemInfo",
    "GetItemIcon",
    "GetItemCount",
    "GetItemQualityColor",
    "GetCursorPosition",

    -- WoW API: Containers
    "C_Container",
    "GetContainerNumSlots",
    "GetContainerItemInfo",
    "GetContainerItemLink",

    -- WoW API: Skills & Professions
    "GetNumSkillLines",
    "GetSkillLineInfo",
    "ExpandSkillHeader",
    "CollapseSkillHeader",
    "GetTradeSkillLine",

    -- WoW API: Chat & Social
    "SendChatMessage",

    -- WoW API: Minimap & World
    "C_Timer",

    -- WoW Global colors/strings
    "RAID_CLASS_COLORS",
    "ITEM_QUALITY_COLORS",

    -- TSM (optional integration)
    "TSM_API",
    "TSMAPI",
    "TSMAPI_FOUR",
}
