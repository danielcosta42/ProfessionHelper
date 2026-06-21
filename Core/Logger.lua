-- ProfessionHelper - Logger
-- All addon output (debug, info, warn, error) goes through this module.
-- Never use print() or DEFAULT_CHAT_FRAME:AddMessage() outside this file.
-- Debug output is gated behind PH.Config:Get("debug") to avoid chat spam.

local PH = _G.ProfessionHelper
local L  = PH.Logger

local PREFIX      = "|cff30a5ff[ProfessionHelper]|r "
local PREFIX_WARN = "|cffffcc00[PH:Warn]|r "
local PREFIX_ERR  = "|cffff4444[PH:Error]|r "
local PREFIX_DBG  = "|cff808080[PH:Debug]|r "

-- Info: always shown, standard gameplay messages
function L.Info(msg)
    DEFAULT_CHAT_FRAME:AddMessage(PREFIX .. tostring(msg))
end

-- Warn: unexpected but non-fatal conditions
function L.Warn(msg)
    DEFAULT_CHAT_FRAME:AddMessage(PREFIX_WARN .. tostring(msg))
end

-- Error: failed operations the player should know about
function L.Error(msg)
    DEFAULT_CHAT_FRAME:AddMessage(PREFIX_ERR .. tostring(msg))
end

-- Debug: verbose output, gated behind the debug setting
function L.Debug(msg)
    -- Config may not exist yet during early startup, so guard defensively
    if PH.Config and PH.Config:Get("debug") then
        DEFAULT_CHAT_FRAME:AddMessage(PREFIX_DBG .. tostring(msg))
    end
end
