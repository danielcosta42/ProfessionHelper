-- Profession Helper - Raid Consumables checklist logic
-- Prints your raid consumable status per role: how many you're carrying vs the
-- recommended count, and whether you can craft each (from RecipeTracker's known
-- recipes). Data lives in Data/RaidConsumables.lua. Command: /ph raid <role>.

local PH = _G.ProfessionHelper
local RC = PH.RaidConsumables
if not RC then return end

-- Does the current character know a recipe that makes this item (exact name)?
local function CanCraft(itemName)
    if not (PH.Identity and PH.DB) then return false end
    local charKey = PH.Identity:GetCharKey()
    local known = charKey and PH.DB:Get("knownRecipes." .. charKey)
    if type(known) ~= "table" then return false end
    local target = itemName:lower()
    for _, recipes in pairs(known) do
        if type(recipes) == "table" then
            for recipeName in pairs(recipes) do
                if type(recipeName) == "string" and recipeName:lower() == target then
                    return true
                end
            end
        end
    end
    return false
end

function RC:RoleByKey(key)
    for _, r in ipairs(self.roles) do
        if r.key == key then return r end
    end
    return nil
end

function RC:Print(roleKey)
    roleKey = tostring(roleKey or ""):lower():gsub("%s+", "")
    local alias = { dps = "melee", ranged = "caster", spell = "caster", heal = "healer", healing = "healer" }
    roleKey = alias[roleKey] or roleKey
    local role = self:RoleByKey(roleKey)
    if not role then
        PH.Logger.Info(PH.L["RAID_USAGE"] or "Usage: /ph raid tank|melee|caster|healer")
        return
    end

    PH.Logger.Info(string.format(PH.L["RAID_HEADER"] or "Raid consumables - %s:", role.label))

    local byCat = {}
    for _, it in ipairs(role.items) do
        byCat[it.cat] = byCat[it.cat] or {}
        table.insert(byCat[it.cat], it)
    end

    for _, cat in ipairs(self.order) do
        local items = byCat[cat]
        if items then
            for _, it in ipairs(items) do
                local have = (GetItemCount and GetItemCount(it.name)) or 0
                local want = it.want or 1
                local col = (have >= want) and "4dda5d" or (have > 0) and "ffa033" or "ff5555"
                local status = "|cff" .. col .. have .. "/" .. want .. "|r"
                local link = (GetItemInfo and select(2, GetItemInfo(it.name)))
                    or ("|cffffffff" .. it.name .. "|r")
                local craft = CanCraft(it.name)
                    and (" |cff30a5ff[" .. (PH.L["RAID_CRAFT"] or "craft") .. "]|r") or ""
                PH.Logger.Info(string.format("  %s %s%s  |cff8e8e93%s|r",
                    status, link, craft, it.note or ""))
            end
        end
    end
end
