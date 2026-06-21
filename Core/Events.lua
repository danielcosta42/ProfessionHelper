-- ProfessionHelper - Event Bus (PH.Event)
-- One shared WoW event frame for the entire addon.
-- Modules MUST use PH.Event:On / PH.Event:Off / PH.Event:Fire.
-- Never create per-module eventFrame objects or call RegisterEvent directly.
--
-- WoW events: registered on the shared frame; dispatched to all subscribers.
-- Internal events: prefixed with "PH_"; dispatched in-process via Fire().

local PH = _G.ProfessionHelper
local EV = PH.Event

-- Per-event tables of { [owner] = callback }
local wowHandlers      = {}  -- WoW engine events
local internalHandlers = {}  -- PH_ addon-internal events

-- WoW events currently registered on the shared frame
local registeredEvents = {}

-- The single shared frame (created in Initialize)
local sharedFrame

-------------------------------------------------------------------------------
-- Lifecycle
-------------------------------------------------------------------------------

function EV:Initialize()
    if sharedFrame then return end

    sharedFrame = CreateFrame("Frame", "ProfessionHelperEventFrame")
    sharedFrame:SetScript("OnEvent", function(_, event, ...)
        local bucket = wowHandlers[event]
        if not bucket then return end
        for _, fn in pairs(bucket) do
            local ok, err = pcall(fn, event, ...)
            if not ok then
                PH.Logger.Error("Event [" .. event .. "] handler error: " .. tostring(err))
            end
        end
    end)

    -- Re-register any events that were subscribed before Initialize (race-free)
    for event in pairs(wowHandlers) do
        if not registeredEvents[event] then
            registeredEvents[event] = true
            sharedFrame:RegisterEvent(event)
        end
    end
end

-------------------------------------------------------------------------------
-- Public API
-------------------------------------------------------------------------------

-- Subscribe to a WoW event or an internal PH_ event.
--   event    : string — WoW event name or "PH_*" internal event
--   callback : function(event, ...) for WoW events; function(...) for PH_ events
--   owner    : string — identifies this subscription group (required)
function EV:On(event, callback, owner)
    if type(owner) ~= "string" or owner == "" then
        PH.Logger.Warn("PH.Event:On — missing owner for event: " .. tostring(event))
        owner = "Unknown"
    end

    if event:sub(1, 3) == "PH_" then
        if not internalHandlers[event] then internalHandlers[event] = {} end
        internalHandlers[event][owner] = callback
        return
    end

    -- WoW event
    if not wowHandlers[event] then wowHandlers[event] = {} end
    wowHandlers[event][owner] = callback

    -- Register on shared frame if not already done
    if not registeredEvents[event] then
        registeredEvents[event] = true
        if sharedFrame then
            sharedFrame:RegisterEvent(event)
        end
    end
end

-- Unsubscribe all handlers registered by owner.
-- Call during module teardown or when a feature stops.
function EV:Off(owner)
    for _, bucket in pairs(wowHandlers) do
        bucket[owner] = nil
    end
    for _, bucket in pairs(internalHandlers) do
        bucket[owner] = nil
    end
end

-- Dispatch an internal PH_ event to all subscribers.
--   event : must start with "PH_"
--   ...   : arbitrary arguments passed to each handler
function EV:Fire(event, ...)
    if type(event) ~= "string" or event:sub(1, 3) ~= "PH_" then
        PH.Logger.Warn("PH.Event:Fire — event must start with PH_: " .. tostring(event))
        return
    end
    local bucket = internalHandlers[event]
    if not bucket then return end
    for _, fn in pairs(bucket) do
        local ok, err = pcall(fn, ...)
        if not ok then
            PH.Logger.Error("Internal event [" .. event .. "] error: " .. tostring(err))
        end
    end
end
