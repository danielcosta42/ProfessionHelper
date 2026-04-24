-- Profession Helper - AH Price Integration
-- Supports TSM (3/4/5), Auctionator, and a 24h local price cache

ProfessionHelper = ProfessionHelper or {}
local PH = ProfessionHelper

PH.TSM = {}

-- Cache TTL: 24 hours in seconds
local CACHE_TTL = 86400

-- Write a price to the local SavedVariables cache
local function WriteToCache(itemName, price, source)
    if not ProfessionHelperDB or not ProfessionHelperDB.ahPriceCache then return end
    ProfessionHelperDB.ahPriceCache[itemName] = { price = price, source = source, ts = time() }
end

-- Read a cached price. Returns price (copper) or nil if absent / expired.
local function ReadFromCache(itemName)
    if not ProfessionHelperDB or not ProfessionHelperDB.ahPriceCache then return nil end
    local entry = ProfessionHelperDB.ahPriceCache[itemName]
    if entry and entry.price and entry.ts and (time() - entry.ts) < CACHE_TTL then
        return entry.price
    end
    return nil
end

-- Detect which AH addon (if any) is currently loaded.
-- Priority: TSM modern > TSM4 > TSM3 > Auctionator
function PH.TSM:IsAvailable()
    if TSM_API then return "modern" end
    if TSMAPI_FOUR then return "tsm4" end
    if TSMAPI then return "tsm3" end
    -- Auctionator: check for both the global namespace and at least one price source
    if Auctionator and (AUCTIONATOR_ITEM_BUY_PRICE or (Auctionator.API and Auctionator.API.v1)) then
        return "auctionator"
    end
    return nil
end

-- Return a human-readable display name for the active addon (used in UI badges).
function PH.TSM:GetDisplayName()
    local v = self:IsAvailable()
    if v == "modern" or v == "tsm4" or v == "tsm3" then return "TSM" end
    if v == "auctionator" then return "Auctionator" end
    return nil
end

-- Get market price for an item.
-- Priority chain: live addon → 24h cache → static vendor price → nil
function PH.TSM:GetItemPrice(itemName, priceSource)
    local matData = PH.Materials and PH.Materials[itemName]
    local itemID = matData and matData.id
    if not itemID then return nil end

    local itemString = "i:" .. itemID
    priceSource = priceSource or "DBMarket"

    local version = self:IsAvailable()
    local price

    if version == "modern" then
        price = TSM_API.GetCustomPriceValue(priceSource, itemString)
        if not price or price == 0 then
            local fallbacks = { "DBMarket", "DBMinBuyout", "DBHistorical", "DBRegionMarketAvg" }
            for _, src in ipairs(fallbacks) do
                if src ~= priceSource then
                    price = TSM_API.GetCustomPriceValue(src, itemString)
                    if price and price > 0 then break end
                end
            end
        end
    elseif version == "tsm4" then
        price = TSMAPI_FOUR.CustomPrice.GetValue(priceSource, itemString)
    elseif version == "tsm3" then
        price = TSMAPI:GetItemValue(itemString, priceSource)
    elseif version == "auctionator" then
        -- Newer Auctionator API (v1, post-Shadowlands backports)
        if Auctionator.API and Auctionator.API.v1 and Auctionator.API.v1.GetAuctionPriceByItemID then
            price = Auctionator.API.v1.GetAuctionPriceByItemID("ProfessionHelper", itemID)
        end
        -- Legacy TBC Auctionator: price table keyed by item name
        if (not price or price == 0) and AUCTIONATOR_ITEM_BUY_PRICE then
            price = AUCTIONATOR_ITEM_BUY_PRICE[itemName]
        end
    end

    -- Cache write on successful live-addon fetch
    if price and price > 0 then
        WriteToCache(itemName, price, version)
        return price
    end

    -- Cache read fallback (no addon or addon returned nothing)
    local cached = ReadFromCache(itemName)
    if cached then return cached end

    -- Final fallback: static vendor price
    if matData and matData.vendor and matData.vendorPrice then
        return matData.vendorPrice
    end

    return nil
end

-- Get market price for an item by its itemID directly.
-- Used by Farm Tracker for looted items that may not be in Materials table.
-- Also tries Auctionator; does NOT fall back to cache (no item-name key available here).
function PH.TSM:GetItemPriceByID(itemID, priceSource)
    if not itemID then return nil end
    local itemString = "i:" .. itemID
    priceSource = priceSource or "DBMarket"

    local version = self:IsAvailable()
    if version == "modern" then
        local price = TSM_API.GetCustomPriceValue(priceSource, itemString)
        if price and price > 0 then return price end
        local fallbacks = { "DBMarket", "DBMinBuyout", "DBHistorical", "DBRegionMarketAvg" }
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
    elseif version == "auctionator" then
        if Auctionator.API and Auctionator.API.v1 and Auctionator.API.v1.GetAuctionPriceByItemID then
            local price = Auctionator.API.v1.GetAuctionPriceByItemID("ProfessionHelper", itemID)
            if price and price > 0 then return price end
        end
    end

    -- Final fallback: native WoW vendor sell price (available even with no AH addon)
    local vendorSell = select(11, GetItemInfo(itemID))
    if vendorSell and vendorSell > 0 then return vendorSell end

    return nil
end

-- Return the internal price-source string used by TSM API calls.
-- Returns nil for non-TSM addons (Auctionator uses a different lookup path).
function PH.TSM:GetPriceSourceName()
    local version = self:IsAvailable()
    if version == "modern" or version == "tsm4" then return "DBMinBuyout" end
    if version == "tsm3" then return "DBMarket" end
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
