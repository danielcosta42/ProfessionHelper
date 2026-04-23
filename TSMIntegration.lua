-- Profession Helper - TSM (TradeSkillMaster) Integration
-- Provides pricing data and AH shopping list support

ProfessionHelper = ProfessionHelper or {}
local PH = ProfessionHelper

PH.TSM = {}

-- Check if TSM is loaded and available
function PH.TSM:IsAvailable()
    -- Modern TSM (4.10+/5.x) uses TSM_API as the global
    if TSM_API then
        return "modern"
    end
    -- Legacy TSM4 uses TSMAPI_FOUR
    if TSMAPI_FOUR then
        return "tsm4"
    end
    -- Legacy TSM3 uses TSMAPI
    if TSMAPI then
        return "tsm3"
    end
    return nil
end

-- Get market price for an item via TSM
-- Returns price in copper, or nil if unavailable
function PH.TSM:GetItemPrice(itemName, priceSource)
    local matData = PH.Materials and PH.Materials[itemName]
    local itemID = matData and matData.id
    if not itemID then return nil end

    local itemString = "i:" .. itemID
    priceSource = priceSource or "DBMarket"

    local version = self:IsAvailable()
    if version == "modern" then
        -- Modern TSM_API (4.10+ / 5.x)
        local price, err = TSM_API.GetCustomPriceValue(priceSource, itemString)
        if price and price > 0 then
            return price
        end
        -- Try fallback sources if the primary failed
        if not price or price == 0 then
            local fallbacks = {"DBMarket", "DBMinBuyout", "DBHistorical", "DBRegionMarketAvg"}
            for _, src in ipairs(fallbacks) do
                if src ~= priceSource then
                    price = TSM_API.GetCustomPriceValue(src, itemString)
                    if price and price > 0 then return price end
                end
            end
        end
    elseif version == "tsm4" then
        -- Legacy TSM4 API
        local price = TSMAPI_FOUR.CustomPrice.GetValue(priceSource, itemString)
        return price
    elseif version == "tsm3" then
        -- Legacy TSM3 API
        local price = TSMAPI:GetItemValue(itemString, priceSource)
        return price
    end

    -- Fallback: vendor price from our data
    if matData and matData.vendor and matData.price then
        return matData.price
    end

    return nil
end

-- Get market price for an item by its itemID directly
-- Used by Farm Tracker for looted items that may not be in Materials table
function PH.TSM:GetItemPriceByID(itemID, priceSource)
    if not itemID then return nil end
    local itemString = "i:" .. itemID
    priceSource = priceSource or "DBMarket"

    local version = self:IsAvailable()
    if version == "modern" then
        local price = TSM_API.GetCustomPriceValue(priceSource, itemString)
        if price and price > 0 then return price end
        local fallbacks = {"DBMarket", "DBMinBuyout", "DBHistorical", "DBRegionMarketAvg"}
        for _, src in ipairs(fallbacks) do
            if src ~= priceSource then
                price = TSM_API.GetCustomPriceValue(src, itemString)
                if price and price > 0 then return price end
            end
        end
    elseif version == "tsm4" then
        return TSMAPI_FOUR.CustomPrice.GetValue(priceSource, itemString)
    elseif version == "tsm3" then
        return TSMAPI:GetItemValue(itemString, priceSource)
    end
    return nil
end

-- Get the best price source string available
function PH.TSM:GetPriceSourceName()
    local version = self:IsAvailable()
    if version == "modern" or version == "tsm4" then
        return "DBMinBuyout"
    elseif version == "tsm3" then
        return "DBMarket"
    end
    return nil
end

-- Calculate total cost for a materials list using TSM prices
-- materials: { {name = "Item Name", count = 10}, ... }
-- Returns totalCost (copper), and a table with per-item prices
function PH.TSM:CalculateCost(materials)
    local totalCost = 0
    local priceSource = self:GetPriceSourceName()
    local itemPrices = {}
    local hasPricing = false

    for _, mat in ipairs(materials) do
        local price = self:GetItemPrice(mat.name, priceSource)
        if price and price > 0 then
            hasPricing = true
            local lineCost = price * mat.count
            totalCost = totalCost + lineCost
            itemPrices[mat.name] = {
                unitPrice = price,
                totalPrice = lineCost,
                count = mat.count,
            }
        else
            itemPrices[mat.name] = {
                unitPrice = 0,
                totalPrice = 0,
                count = mat.count,
            }
        end
    end

    return totalCost, itemPrices, hasPricing
end

-- Calculate cost for a single recipe craft
function PH.TSM:GetRecipeCost(recipe)
    if not recipe or not recipe.materials then return 0 end
    local cost = 0
    local priceSource = self:GetPriceSourceName()
    for _, mat in ipairs(recipe.materials) do
        local price = self:GetItemPrice(mat.name, priceSource) or 0
        cost = cost + (price * mat.count)
    end
    return cost
end

-- Build a TSM shopping string for materials
-- Format: "item1/item2/item3" (TSM shopping search format)
function PH.TSM:BuildShoppingString(materials)
    local parts = {}
    for _, mat in ipairs(materials) do
        local matData = PH.Materials and PH.Materials[mat.name]
        if matData and matData.id and not matData.vendor then
            table.insert(parts, mat.name)
        end
    end
    return table.concat(parts, "/")
end

-- Reusable copy popup
local copyFrame
local function ShowCopyPopup(text)
    if not copyFrame then
        copyFrame = CreateFrame("Frame", "PHCopyPopup", UIParent, "BackdropTemplate")
        copyFrame:SetSize(420, 100)
        copyFrame:SetPoint("CENTER")
        copyFrame:SetFrameStrata("DIALOG")
        copyFrame:SetBackdrop({ bgFile = "Interface\\BUTTONS\\WHITE8X8", edgeFile = "Interface\\BUTTONS\\WHITE8X8", edgeSize = 1 })
        copyFrame:SetBackdropColor(0.06, 0.06, 0.08, 0.95)
        copyFrame:SetBackdropBorderColor(0.3, 0.85, 0.45, 0.6)
        copyFrame:EnableMouse(true)
        copyFrame:SetMovable(true)
        copyFrame:RegisterForDrag("LeftButton")
        copyFrame:SetScript("OnDragStart", copyFrame.StartMoving)
        copyFrame:SetScript("OnDragStop", copyFrame.StopMovingOrSizing)

        local title = copyFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        title:SetPoint("TOP", 0, -10)
        title:SetText("|cff4dda5dCtrl+C para copiar  —  Esc para fechar|r")

        local eb = CreateFrame("EditBox", nil, copyFrame, "BackdropTemplate")
        eb:SetSize(396, 22)
        eb:SetPoint("CENTER", 0, -8)
        eb:SetFontObject(ChatFontNormal)
        eb:SetAutoFocus(true)
        eb:SetBackdrop({ bgFile = "Interface\\BUTTONS\\WHITE8X8", edgeFile = "Interface\\BUTTONS\\WHITE8X8", edgeSize = 1 })
        eb:SetBackdropColor(0.1, 0.1, 0.13, 1)
        eb:SetBackdropBorderColor(0.2, 0.2, 0.25, 1)
        eb:SetTextInsets(4, 4, 0, 0)
        eb:SetScript("OnEscapePressed", function() copyFrame:Hide() end)
        eb:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
        copyFrame.editBox = eb
    end

    copyFrame.editBox:SetText(text)
    copyFrame:Show()
    copyFrame.editBox:SetFocus()
    copyFrame.editBox:HighlightText()
end

-- Open TSM shopping scan with a search string
function PH.TSM:OpenShoppingScan(searchString)
    if not searchString or searchString == "" then
        PH:Print(PH.L["TSM_NO_ITEMS"])
        return false
    end

    ShowCopyPopup(searchString)
    PH:Print(PH.L["TSM_PASTE_MSG"])
    return true
end

-- Format copper value into gold/silver/copper display
function PH.TSM:FormatMoney(copper)
    if not copper then return "|cff808080N/A|r" end
    if copper == 0 then return "|cffffd7000|rg |cffc7c7cf0|rs |cffeda55f0|rc" end
    local gold = math.floor(copper / 10000)
    local silver = math.floor((copper % 10000) / 100)
    local copperRem = copper % 100

    local parts = {}
    if gold > 0 then
        table.insert(parts, string.format("|cffffd700%d|rg", gold))
    end
    if silver > 0 or gold > 0 then
        table.insert(parts, string.format("|cffc7c7cf%d|rs", silver))
    end
    if copperRem > 0 or (gold == 0 and silver == 0) then
        table.insert(parts, string.format("|cffeda55f%d|rc", copperRem))
    end
    return table.concat(parts, " ")
end
