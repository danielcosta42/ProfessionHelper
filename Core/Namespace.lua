-- ProfessionHelper - Namespace
-- Declares the single global namespace for the entire addon.
-- This file MUST be loaded first (see ProfessionHelper.toc).
-- No other file should declare globals or extend the namespace root.
--
-- Copyright (c) 2026 Chehul @ DreamScyther-US
-- MIT License

_G.ProfessionHelper = _G.ProfessionHelper or {}
local PH = _G.ProfessionHelper

-- Addon metadata
PH.version = "1.20.0"
PH.author  = "Chehul @ DreamScyther-US"
PH.github  = "https://github.com/danielcosta42"
PH.license = "MIT License - Free for personal use"

-- Sub-namespaces (populated by their respective files)
PH.Logger   = PH.Logger   or {}
PH.Compat   = PH.Compat   or {}
PH.DB       = PH.DB       or {}
PH.Event    = PH.Event    or {}
PH.Identity = PH.Identity or {}
PH.Config   = PH.Config   or {}
