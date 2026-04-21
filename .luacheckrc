-- Luacheck configuration for WoW TBC Classic AddOns
-- See: https://luacheck.readthedocs.io/en/stable/

std = "lua51"

-- WoW API globals (common TBC Classic functions)
globals = {
    -- Core WoW globals
    "PH",
    "ProfessionHelperDB",
    
    -- Frame creation
    "CreateFrame",
    "UIParent",
    "GameTooltip",
    "GameFontNormal",
    "GameFontNormalSmall",
    "GameFontNormalLarge",
    "GameFontNormalHuge",
    "GameFontHighlight",
    "GameFontHighlightSmall",
    
    -- Game functions
    "GetLocale",
    "GetNumSkillLines",
    "GetSkillLineInfo",
    "ExpandSkillHeader",
    "CollapseSkillHeader",
    "GetTradeSkillLine",
    "GetItemInfo",
    "GetItemIcon",
    "GetCursorPosition",
    "GetTime",
    "GetContainerNumSlots",
    "GetContainerItemInfo",
    "GetContainerItemLink",
    
    -- Input
    "IsShiftKeyDown",
    "IsControlKeyDown",
    "IsAltKeyDown",
    
    -- UI functions
    "PlaySound",
    "StaticPopup_Show",
    "ChatFrame_AddMessageEventFilter",
    
    -- Chat
    "DEFAULT_CHAT_FRAME",
    "SendChatMessage",
    
    -- Minimap
    "Minimap",
    
    -- Colors
    "RAID_CLASS_COLORS",
    "ITEM_QUALITY_COLORS",
    
    -- Slash commands
    "SlashCmdList",
    "SLASH_PROFESSIONHELPER1",
    "SLASH_PROFESSIONHELPER2",
    
    -- Events
    "ADDON_LOADED",
    "SKILL_LINES_CHANGED",
    "CHAT_MSG_SKILL",
    "TRADE_SKILL_UPDATE",
    "BAG_UPDATE_DELAYED",
    
    -- Backdrops (TBC)
    "BackdropTemplateMixin",
    
    -- Standard Lua
    "bit",
    "math",
    "string",
    "table",
    "pairs",
    "ipairs",
    "next",
    "select",
    "tonumber",
    "tostring",
    "type",
    "unpack",
    "assert",
    "error",
    "print",
    "setmetatable",
    "getmetatable",
    "rawget",
    "rawset",
    
    -- TSM (TradeSkillMaster) - optional integration
    "TSM_API",
    "TSMAPI",
    "TSMAPI_FOUR",
}

-- Read-only globals (WoW constants)
read_globals = {
    "C_Timer",
    "C_Map",
    "UnitName",
    "UnitClass",
    "UnitLevel",
}

-- Ignore certain warnings
ignore = {
    "211",  -- Unused local variable
    "212",  -- Unused argument
    "213",  -- Unused loop variable
    "311",  -- Value assigned to a local variable is unused
    "542",  -- Empty if branch
    "631",  -- Line is too long
}

-- Only report warnings for code that is actually used
unused_args = false
unused = false

-- Exclude files and directories
exclude_files = {
    -- Version control
    ".git/**",
    ".github/**",
    
    -- Build artifacts
    "releases/**",
    "*.zip",
    
    -- Temporary files
    "*.bak",
    "*.old",
    "*.tmp",
    
    -- Development docs (if they contain Lua examples)
    "LOCALIZATION.md",
    "PUBLISHING.md",
    "MARKETING.md",
}

-- Maximum line length (default 120, WoW conventions often use longer)
max_line_length = 120

-- Maximum code complexity
max_cyclomatic_complexity = 20

-- Allow redefinition of globals
allow_defined_top = true
