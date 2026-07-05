-- Wires ProfessionHelper into the shared ChehulNet presence mesh (see Core/ChehulNet.lua).
-- ProfessionHelper works fully standalone; this only adds cross-addon recognition
-- (PartyLens flagging this player as a crafter; the Marketplace showing which
-- nearby / guild peers also run ProfessionHelper).
local PH = _G.ProfessionHelper
local CN = _G.ChehulNet
if not PH or not CN then
    return
end

CN:Register("ph", function()
    -- Advertise the professions this character can craft.
    if not (PH.AltManager and PH.Identity) then
        return ""
    end
    local list = PH.AltManager:GetCharProfessions(PH.Identity:GetCharName())
    if type(list) ~= "table" or #list == 0 then
        return ""
    end
    local names = {}
    for _, prof in ipairs(list) do
        if prof.name then
            names[#names + 1] = prof.name
        end
    end
    if #names == 0 then
        return ""
    end
    return "craft:" .. table.concat(names, "/")
end, nil)
