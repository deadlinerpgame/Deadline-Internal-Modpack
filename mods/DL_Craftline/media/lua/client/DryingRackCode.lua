-- Updated leather tanning code with multi-tile rack support and debugging

local validTiles = {
    "aerx_tools_82", "aerx_tools_83",
    "aerx_tools_84", "aerx_tools_85",
    "aerx_tools_90", "aerx_tools_91",   
    "aerx_tools_92", "aerx_tools_93",
}

local dryingRackPairs = {
    ["aerx_tools_82"] = "aerx_tools_83",
    ["aerx_tools_83"] = "aerx_tools_82",
    ["aerx_tools_84"] = "aerx_tools_85",
    ["aerx_tools_85"] = "aerx_tools_84",
    ["aerx_tools_90"] = "aerx_tools_91",
    ["aerx_tools_91"] = "aerx_tools_90",
    ["aerx_tools_92"] = "aerx_tools_93",
    ["aerx_tools_93"] = "aerx_tools_92",
}

local activeTanningTiles = ModData.getOrCreate("activeTanningTiles")

function isTileValidForTanning(spriteName)
    for _, validTile in ipairs(validTiles) do
        if spriteName == validTile then
            return true
        end
    end
    return false
end

function getTanningProgress(startTime, totalTanningTime)
    local currentTime = getGameTime():getWorldAgeHours()
    local elapsedTime = currentTime - startTime
    local progress = math.min(math.max((elapsedTime / totalTanningTime) * 100, 0), 100)
    return math.floor(progress + 0.5)
end

function getPartnerTile(object)
    local sprite = object:getSprite() and object:getSprite():getName()
    if not sprite or not dryingRackPairs[sprite] then
        return nil
    end

    local pairName = dryingRackPairs[sprite]
    local square = object:getSquare()
    if not square then return nil end

    local directions = {}
    if sprite == "aerx_tools_82" or sprite == "aerx_tools_83" or sprite == "aerx_tools_90" or sprite == "aerx_tools_91"  then
        directions = { IsoDirections.E, IsoDirections.W }
    elseif sprite == "aerx_tools_84" or sprite == "aerx_tools_85" or sprite == "aerx_tools_92" or sprite == "aerx_tools_93" then
        directions = { IsoDirections.N, IsoDirections.S }
    end

    for _, dir in ipairs(directions) do
        local adj = square:getAdjacentSquare(dir)
        if adj then
            for i = 0, adj:getObjects():size() - 1 do
                local obj = adj:getObjects():get(i)
                if obj and obj:getSprite() and obj:getSprite():getName() == pairName then
                    return obj
                end
            end
        end
    end

    return nil
end

function syncModDataAcrossTiles(tile1, tile2, modData)
    for k, v in pairs(modData) do
        tile1:getModData()[k] = v
        tile2:getModData()[k] = v
    end
    tile1:transmitModData()
    tile2:transmitModData()
end

function OnRightClickTile(player, context, worldobjects)
    print("[TanningRack] Right-click context triggered.")
    for _, object in ipairs(worldobjects) do
        if object and object:getSprite() then
            local spriteName = object:getSprite():getName()
            print("[TanningRack] Clicked sprite: " .. tostring(spriteName))

            if not spriteName then return end
            if not isTileValidForTanning(spriteName) then
                print("[TanningRack] Skipping non-tanning tile: " .. tostring(spriteName))
                return end

            if spriteName and isTileValidForTanning(spriteName) then
                local partnerTile = getPartnerTile(object)
                if not partnerTile then
                    print("[TanningRack] Proceeding with solo tile operation.")
                    partnerTile = object
                end

                local modData = object:getModData()
                if not modData.isTanning then
                    modData.isTanning = false
                    modData.TanningStartTime = 0
                    modData.TanningType = 0
                    modData.TimeNeeded = 0
                end

                if modData.isTanning == false then
                    local cowOption = context:addOption("Tan and Dry Cow Leather", worldobjects, startTanningCowLeather, player, object, partnerTile)
                    addTooltip(cowOption, "Cow Leather Tanning", {"2 x Tannin", "1 x Simmental Cow Hide"}, "6 hours")

                    local deerOption = context:addOption("Tan and Dry Deer Leather", worldobjects, startTanningDeerLeather, player, object, partnerTile)
                    addTooltip(deerOption, "Deer Leather Tanning", {"2 x Tannin", "1 x Deer Hide"}, "6 hours")

                    local pigOption = context:addOption("Tan and Dry Pig Leather", worldobjects, startTanningPigLeather, player, object, partnerTile)
                    addTooltip(pigOption, "Pig Leather Tanning", {"2 x Tannin", "1 x Landrace Pig Hide"}, "6 hours")

                    local sheepOption = context:addOption("Tan and Dry Sheep Leather", worldobjects, startTanningSheepLeather, player, object, partnerTile)
                    addTooltip(sheepOption, "Sheep Leather Tanning", {"2 x Tannin", "1 x Sheep Hide"}, "6 hours")

                    local rabbitOption = context:addOption("Tan and Dry Rabbit Leather", worldobjects, startTanningRabbitLeather, player, object, partnerTile)
                    addTooltip(rabbitOption, "Rabbit Leather Tanning", {"2 x Tannin", "1 x Rabbit Hide"}, "6 hours")
                    break
                elseif modData.TanningType ~= 0 and isBrewComplete(modData.TanningStartTime, modData.TimeNeeded) then
                    local tanningResults = {
                        [1] = "aerx.CowLeather_Simmental_Fur_Tan",
                        [2] = "aerx.DeerLeather_Fur_Tan",
                        [3] = "aerx.PigLeather_Landrace_Fur_Tan",
                        [4] = "aerx.SheepLeather_Fur_Tan",
                        [5] = "aerx.RabbitLeather_Fur_Tan"
                    }
                    local resultItem = tanningResults[modData.TanningType]
                    if resultItem then
                        context:addOption("Retrieve Tanned Leather", worldobjects, function()
                            giveTannedLeather(worldobjects, player, object, partnerTile, resultItem)
                        end)
                    end
                    break
                else
                    local progresspercentage = getTanningProgress(modData.TanningStartTime, modData.TimeNeeded)
                    local elapsedTime = getGameTime():getWorldAgeHours() - modData.TanningStartTime
                    local timeLeft = modData.TimeNeeded - elapsedTime
                    timeLeft = tonumber(string.format("%.1f", timeLeft))
                    context:addOption("Tanning Progress: " .. progresspercentage .. "% / Time Left: " .. timeLeft .. "h", worldobjects, dummy, player, object)
                    break
                end
            end
        end
    end
end

Events.OnFillWorldObjectContextMenu.Add(OnRightClickTile)

function addTooltip(option, name, requirements, timeToComplete)
    local tooltip = ISBuildMenu.addToolTip()
    option.toolTip = tooltip
    tooltip:setName(name or "Tooltip")
    tooltip.description = "Requires: <LINE>"
    for _, requirement in ipairs(requirements) do
        tooltip.description = tooltip.description .. requirement .. " <LINE>"
    end
    tooltip.description = tooltip.description .. "Approx. " .. (timeToComplete or "Unknown") .. " to complete."
end

function checkAndStartTanning(player, tile1, tile2, hideType, tanningType)
    local playerInventory = getSpecificPlayer(player):getInventory()
    if playerInventory:getItemCount("aerx.Tannin") < 2 or not playerInventory:containsType(hideType) then
        getSpecificPlayer(player):Say("I don't have the materials for tanning.")
        return
    end

    playerInventory:RemoveOneOf(hideType)
    playerInventory:RemoveOneOf("aerx.Tannin")
    playerInventory:RemoveOneOf("aerx.Tannin")

    local modData = {
        isTanning = true,
        TanningStartTime = getGameTime():getWorldAgeHours(),
        TanningType = tanningType,
        TimeNeeded = 6
    }

    local function applyOverlay(tile)
        local sprite = tile:getSprite():getName()
        local newSprites = {
            ["aerx_tools_82"] = "aerx_tools_90",
            ["aerx_tools_83"] = "aerx_tools_91",
            ["aerx_tools_84"] = "aerx_tools_92",
            ["aerx_tools_85"] = "aerx_tools_93"
        }
        local newSprite = newSprites[sprite]
        if newSprite then
            tile:setSprite(newSprite)
            tile:transmitUpdatedSprite()

            if isServer() then
                tile:transmitUpdatedSpriteToClients()
                tile:syncIsoObject()
            else
                tile:transmitUpdatedSpriteToServer()
            end
        end
    end
    applyOverlay(tile1)
    applyOverlay(tile2)

    local tileID = tile1:getSquare():getX() .. "_" .. tile1:getSquare():getY() .. "_" .. tile1:getSquare():getZ()
    activeTanningTiles[tileID] = true
    syncModDataAcrossTiles(tile1, tile2, modData)
    getSpecificPlayer(player):Say("Tanning started!")
end

function startTanningCowLeather(worldobjects, player, tile1, tile2)
    checkAndStartTanning(player, tile1, tile2, "aerx.CowLeather_Simmental_Full", 1)
end

function startTanningDeerLeather(worldobjects, player, tile1, tile2)
    checkAndStartTanning(player, tile1, tile2, "aerx.DeerLeather_Full", 2)
end

function startTanningPigLeather(worldobjects, player, tile1, tile2)
    checkAndStartTanning(player, tile1, tile2, "aerx.PigLeather_Landrace_Full", 3)
end

function startTanningSheepLeather(worldobjects, player, tile1, tile2)
    checkAndStartTanning(player, tile1, tile2, "aerx.SheepLeather_Full", 4)
end

function startTanningRabbitLeather(worldobjects, player, tile1, tile2)
    checkAndStartTanning(player, tile1, tile2, "aerx.RabbitLeather_Full", 5)
end

function giveTannedLeather(worldobjects, player, tile1, tile2, resultItem)
    local playerObj = getSpecificPlayer(player)
    playerObj:getInventory():AddItem(resultItem)

    local modData1 = tile1:getModData()
    local modData2 = tile2:getModData()
    modData1.isTanning = false
    modData1.TanningStartTime = 0
    modData1.TanningType = 0
    modData1.TimeNeeded = 0
    modData2.isTanning = false
    modData2.TanningStartTime = 0
    modData2.TanningType = 0
    modData2.TimeNeeded = 0

    tile1:transmitModData()
    tile2:transmitModData()

    local function removeOverlay(tile)
        local sprite = tile:getSprite() and tile:getSprite():getName()
        local originalSprites = {
            ["aerx_tools_90"] = "aerx_tools_82",
            ["aerx_tools_91"] = "aerx_tools_83",
            ["aerx_tools_92"] = "aerx_tools_84",
            ["aerx_tools_93"] = "aerx_tools_85"
        }
        local original = originalSprites[sprite]
        if original then
            tile:setSprite(original)
            tile:transmitUpdatedSprite()

            if isServer() then
                tile:transmitUpdatedSpriteToClients()
                tile:syncIsoObject()
            else
                tile:transmitUpdatedSpriteToServer()
            end
        end
    end
    removeOverlay(tile1)
    removeOverlay(tile2)
end

function isBrewComplete(startTime, timeToProduce)
    return getGameTime():getWorldAgeHours() >= startTime + timeToProduce
end
