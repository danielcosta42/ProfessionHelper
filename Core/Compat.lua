-- ProfessionHelper - Compatibility Layer
-- All version-sensitive WoW API calls are wrapped here.
-- Feature modules MUST use PH.Compat.* wrappers — never scatter
-- Retail/Classic/TBC/WotLK API checks across module files.

local PH = _G.ProfessionHelper
local C  = PH.Compat

-------------------------------------------------------------------------------
-- Interface version (cached once, read-only everywhere)
-------------------------------------------------------------------------------

do
    local _, _, _, toc = GetBuildInfo()
    PH.interfaceVersion = toc or 0
end

-------------------------------------------------------------------------------
-- C_Container polyfill for Classic / TBC / WotLK (pre-Cata API)
-- Cata introduced C_Container with a different GetContainerItemInfo signature.
-- This polyfill lets BagScanner use the Cata-style API on all clients.
-------------------------------------------------------------------------------

if not C_Container then
    C_Container = {
        GetContainerNumSlots = GetContainerNumSlots,
        GetContainerItemLink = GetContainerItemLink,
        GetContainerItemInfo = function(bag, slot)
            local tex, count, locked, q, readable, lootable,
                  link, isFiltered, noValue, id = GetContainerItemInfo(bag, slot)
            return {
                iconFileID = tex,
                stackCount = count,
                isLocked   = locked,
                quality    = q,
                isReadable = readable,
                hasLoot    = lootable,
                itemLink   = link,
                isFiltered = isFiltered,
                noValue    = noValue,
                itemID     = id,
            }
        end,
        UseContainerItem = UseContainerItem,
    }
end

-------------------------------------------------------------------------------
-- Wrappers
-------------------------------------------------------------------------------

-- Safe GetSpellInfo (signature differs between Classic and Retail)
function C.GetSpellInfo(spellID)
    if not spellID then return nil end
    local ok, name = pcall(GetSpellInfo, spellID)
    return ok and name or nil
end

-- Safe GetItemInfo
function C.GetItemInfo(itemIDorLink)
    if not itemIDorLink then return nil end
    local ok, name = pcall(GetItemInfo, itemIDorLink)
    return ok and name or nil
end

-- Container helpers (always use C_Container, polyfilled above for old clients)
function C.GetContainerNumSlots(bag)
    return C_Container.GetContainerNumSlots(bag)
end

function C.GetContainerItemLink(bag, slot)
    return C_Container.GetContainerItemLink(bag, slot)
end

function C.GetContainerItemInfo(bag, slot)
    return C_Container.GetContainerItemInfo(bag, slot)
end

-- Use (equip/consume) a container item. Cata moved this into C_Container;
-- pre-Cata clients keep the bare global. Must be called synchronously from a
-- hardware event (button OnClick) so the equip action is permitted.
function C.UseContainerItem(bag, slot)
    if C_Container and C_Container.UseContainerItem then
        return C_Container.UseContainerItem(bag, slot)
    end
    return UseContainerItem(bag, slot)
end

-- GetTradeSkillLine (differs slightly across expansions)
function C.GetTradeSkillLine()
    local ok, result = pcall(GetTradeSkillLine)
    return ok and result or nil
end

-- SOUNDKIT guard (not all soundkit IDs exist on all clients)
function C.PlaySound(soundKitID, fallbackID)
    local id = soundKitID or fallbackID
    if not id then return end
    local ok = pcall(PlaySound, id)
    if not ok and fallbackID and fallbackID ~= soundKitID then
        pcall(PlaySound, fallbackID)
    end
end

-- GetMoney: safe wrapper
function C.GetMoney()
    local ok, copper = pcall(GetMoney)
    return ok and copper or 0
end

-------------------------------------------------------------------------------
-- CVar access (C_CVar on newer clients, bare globals on older) — used by the
-- Fishing Assistant to toggle soft-target / auto-loot CVars during fishing.
-------------------------------------------------------------------------------

function C.GetCVar(name)
    local getter = (C_CVar and C_CVar.GetCVar) or GetCVar
    if not getter then return nil end
    local ok, v = pcall(getter, name)
    return ok and v or nil
end

function C.SetCVar(name, value)
    local setter = (C_CVar and C_CVar.SetCVar) or SetCVar
    if not setter then return end
    pcall(setter, name, value)
end

-- True if this client has the soft-target interact system (Retail and the
-- Classic Anniversary clients). Used to gate the one-key reel/soft-target path.
function C.HasSoftInteract()
    return C.GetCVar("SoftTargetInteract") ~= nil
end
