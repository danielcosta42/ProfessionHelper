-- Luacheck configuration for ProfessionHelper WoW Addon

std = "lua51"
max_line_length = false

-- Suppress warnings that are false positives or acceptable in WoW addon code
ignore = {
    "211",  -- unused variable / unused function (positional API returns, dead utility code)
    "212",  -- unused argument (self in event handlers is intentional)
    "213",  -- unused loop variable
    "311",  -- value overwritten before use (intentional in data files)
    "411",  -- redefining local variable
    "421",  -- shadowing local
    "431",  -- shadowing upvalue
    "432",  -- shadowing upvalue argument
    "542",  -- empty if branch
    "611",  -- line contains only whitespace
}

-- Globals that the addon WRITES to
globals = {
    "PH",
    "ProfessionHelper",
    "ProfessionHelperDB",
    "SlashCmdList",
    "SLASH_PROFESSIONHELPER1",
    "SLASH_PROFESSIONHELPER2",
    "C_Container",  -- polyfill for pre-Cata clients
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
    "ChatFontNormal",
    "BackdropTemplateMixin",
    "STANDARD_TEXT_FONT",
    "DEFAULT_CHAT_FRAME",
    "Minimap",
    "WorldMapFrame",
    "ToggleWorldMap",
    "WorldMapFrame_SetDisplayedMapByID",

    -- WoW API: Input
    "IsShiftKeyDown",
    "IsControlKeyDown",
    "IsAltKeyDown",

    -- WoW API: Locale & Game
    "GetLocale",
    "GetTime",
    "GetRealmName",
    "GetRealZoneText",
    "ReloadUI",
    "InCombatLockdown",
    "PlaySound",
    "hooksecurefunc",
    "StaticPopup_Show",
    "ChatFrame_AddMessageEventFilter",
    "SOUNDKIT",
    "wipe",
    "time",

    -- WoW API: Unit functions
    "UnitName",
    "UnitClass",
    "UnitLevel",
    "UnitFactionGroup",

    -- WoW API: Items & Inventory
    "GetItemInfo",
    "GetItemIcon",
    "GetItemCount",
    "GetItemQualityColor",
    "GetCursorPosition",
    "GetCoinTextureString",
    "GetMoney",

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
    "GetNumTradeSkills",
    "GetTradeSkillInfo",
    "GetSpellInfo",

    -- WoW API: Map
    "C_Map",

    -- WoW API: Chat & Social
    "SendChatMessage",

    -- WoW API: Timers
    "C_Timer",

    -- WoW Global strings/colors
    "RAID_CLASS_COLORS",
    "ITEM_QUALITY_COLORS",
    "LOOT_ITEM_SELF",
    "LOOT_ITEM_SELF_MULTIPLE",
    "GOLD_AMOUNT",
    "SILVER_AMOUNT",
    "COPPER_AMOUNT",

    -- Third-party libraries
    "LibStub",
    "HBD_PINS_WORLDMAP_SHOW_PARENT",

    -- Auctionator (optional integration)
    "Auctionator",
    "AUCTIONATOR_ITEM_BUY_PRICE",

    -- TSM (optional integration)
    "TSM_API",
    "TSMAPI",
    "TSMAPI_FOUR",
}
