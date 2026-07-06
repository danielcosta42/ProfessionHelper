-- Wires ProfessionHelper into the shared ChehulNet presence mesh (see Core/ChehulNet.lua).
-- ProfessionHelper works fully standalone; this only adds cross-addon recognition
-- (PartyLens flagging this player as a crafter; the Marketplace showing which
-- nearby / guild peers also run ProfessionHelper).
local PH = _G.ProfessionHelper
local CN = _G.ChehulNet
if not PH or not CN then
    return
end

-- Show network alerts in ProfessionHelper's identity (blue). Forever-dismissed ids persist
-- in our SavedVariables (ProfessionHelperDB.alertDismissed), resolved at call time.
if CN.EnableAlerts then
    CN:EnableAlerts({
        accent = { 0.30, 0.65, 1.0 },
        title = "Profession Helper",
        priority = 1,
        store = function()
            ProfessionHelperDB = ProfessionHelperDB or {}
            ProfessionHelperDB.alertDismissed = ProfessionHelperDB.alertDismissed or {}
            return ProfessionHelperDB.alertDismissed
        end,
    })
end

CN:Register("ph", function()
    -- Advertise this character's professions, split into what it can craft vs
    -- gather, so peers (and the marketplace) know both sides. e.g.
    --   "craft:Alchemy/Enchanting,gather:Herbalism/Mining"
    if not (PH.AltManager and PH.Identity) then
        return ""
    end
    local list = PH.AltManager:GetCharProfessions(PH.Identity:GetCharName())
    if type(list) ~= "table" or #list == 0 then
        return ""
    end
    local craft, gather = {}, {}
    for _, prof in ipairs(list) do
        local name = prof.name
        if name then
            local data = PH.GetProfessionData and PH:GetProfessionData(name)
            if data and data.type == "gathering" then
                gather[#gather + 1] = name
            else
                craft[#craft + 1] = name
            end
        end
    end
    local parts = {}
    if #craft > 0 then parts[#parts + 1] = "craft:" .. table.concat(craft, "/") end
    if #gather > 0 then parts[#parts + 1] = "gather:" .. table.concat(gather, "/") end
    return table.concat(parts, ",")
end, nil)
