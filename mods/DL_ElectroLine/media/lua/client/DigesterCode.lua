local validTiles = {
    "dl_workbenches_0", "dl_workbenches_1", "dl_workbenches_2", "dl_workbenches_3",
    "dl_workbenches_4", "dl_workbenches_5", "dl_workbenches_6", "dl_workbenches_7",
    "dl_workbenches_8", "dl_workbenches_9", "dl_workbenches_10", "dl_workbenches_11"
}

local tileStateMapping = {
    ["dl_workbenches_0"] = {inUse = "dl_workbenches_4", ready = "dl_workbenches_8"},
    ["dl_workbenches_1"] = {inUse = "dl_workbenches_5", ready = "dl_workbenches_9"},
    ["dl_workbenches_2"] = {inUse = "dl_workbenches_6", ready = "dl_workbenches_10"},
    ["dl_workbenches_3"] = {inUse = "dl_workbenches_7", ready = "dl_workbenches_11"},

    ["dl_workbenches_4"] = {ready = "dl_workbenches_8", inactive = "dl_workbenches_0"},
    ["dl_workbenches_5"] = {ready = "dl_workbenches_9", inactive = "dl_workbenches_1"},
    ["dl_workbenches_6"] = {ready = "dl_workbenches_10", inactive = "dl_workbenches_2"},
    ["dl_workbenches_7"] = {ready = "dl_workbenches_11", inactive = "dl_workbenches_3"},

    ["dl_workbenches_8"] = {inactive = "dl_workbenches_0"},
    ["dl_workbenches_9"] = {inactive = "dl_workbenches_1"},
    ["dl_workbenches_10"] = {inactive = "dl_workbenches_2"},
    ["dl_workbenches_11"] = {inactive = "dl_workbenches_3"}
}

local activeProductionTiles = ModData.getOrCreate("ActiveProductionTiles")

function updateTileState(object, state)
    if not object or not object:getSprite() then
        print("Error: Invalid tile object or missing sprite.")
        return
    end

    local spriteName = object:getSprite():getName()
    local modData = object:getModData()
    if tileStateMapping[spriteName] then
        local newSpriteName
        if state == "inUse" then
            newSpriteName = tileStateMapping[spriteName].inUse
            modData.tileState = 1
        elseif state == "ready" then
            newSpriteName = tileStateMapping[spriteName].ready
            modData.tileState = 2
        else
            newSpriteName = spriteName
            modData.tileState = 0
        end

        print("Updating tile to state:", state, "with new sprite:", newSpriteName)

        object:setSprite(getSprite(newSpriteName))
        object:transmitUpdatedSprite()
        
        if isServer() then
            object:transmitUpdatedSpriteToClients()
            object:syncIsoObject()
        else
            object:transmitUpdatedSpriteToServer()
        end
    else
        print("Error: Sprite name does not match any tileStateMapping entry:", spriteName)
    end
end

function OnRightClickTile(player, context, worldobjects)
    for _, object in ipairs(worldobjects) do
        if object and object:getSprite() then
            local spriteName = object:getSprite():getName()
            if spriteName and isTileValidForMethane(spriteName) then
                local modData = object:getModData()

                if not modData.isProducingMethane then
                    modData.isProducingMethane = false
                    modData.methaneStartTime = 0
                    modData.TimeNeeded = 0
                end

                    if object:getSprite():getName() == "dl_workbenches_0" or object:getSprite():getName() == "dl_workbenches_4" or object:getSprite():getName() == "dl_workbenches_8"  then
                        modData.tileDirection = 1
                    elseif object:getSprite():getName() ==  "dl_workbenches_1" or object:getSprite():getName() == "dl_workbenches_5" or object:getSprite():getName() == "dl_workbenches_9" then
                        modData.tileDirection = 2
                    elseif object:getSprite():getName() ==  "dl_workbenches_2" or object:getSprite():getName() == "dl_workbenches_6" or object:getSprite():getName() == "dl_workbenches_10"  then
                        modData.tileDirection = 3
                    elseif object:getSprite():getName() ==  "dl_workbenches_3" or object:getSprite():getName() == "dl_workbenches_7" or object:getSprite():getName() == "dl_workbenches_11" then
                        modData.tileDirection = 4
                    end
                    if modData.tileDirection == 1 then
                        if modData.tileState == 0 then object:setSprite(getSprite("dl_workbenches_0")) end
                        if modData.tileState == 1 then object:setSprite(getSprite("dl_workbenches_4")) end
                        if modData.tileState == 2 then object:setSprite(getSprite("dl_workbenches_8")) end
                    end
                    if modData.tileDirection == 2 then
                        if modData.tileState == 0 then object:setSprite(getSprite("dl_workbenches_1")) end
                        if modData.tileState == 1 then object:setSprite(getSprite("dl_workbenches_5")) end
                        if modData.tileState == 2 then object:setSprite(getSprite("dl_workbenches_9")) end
                    end
                    if modData.tileDirection == 3 then
                        if modData.tileState == 0 then object:setSprite(getSprite("dl_workbenches_2")) end
                        if modData.tileState == 1 then object:setSprite(getSprite("dl_workbenches_6")) end
                        if modData.tileState == 2 then object:setSprite(getSprite("dl_workbenches_10")) end
                    end
                    if modData.tileDirection == 4 then
                        if modData.tileState == 0 then object:setSprite(getSprite("dl_workbenches_3")) end
                        if modData.tileState == 1 then object:setSprite(getSprite("dl_workbenches_7")) end
                        if modData.tileState == 2 then object:setSprite(getSprite("dl_workbenches_11")) end
                    end
                print("Hours Passed")
                print(modData.tileState)
                print("World Start Time")
                print(modData.tileDirection)
                print("World Start Time")
                print(modData.isProducingMethane)
                print("World Start Time")
                print(modData.methaneStartTime)
                if not modData.isProducingMethane then
                    local startOption = context:addOption("Start Methane Production", worldobjects, startMethaneProduction, player, object)
                    addMethaneProductionTooltip(startOption, player)      
                elseif isMethaneProductionComplete(modData.methaneStartTime) then
                    context:addOption("Fill Propane Tank", worldobjects, fillPropaneTank, player, object)
                    context:addOption("Fill Methane Tank", worldobjects, fillMethaneTank, player, object)
                elseif modData.isProducingMethane == true then
                    local progresspercentage = getProductionProgress(modData.methaneStartTime, modData.TimeNeeded)
                    local currentTime = getGameTime():getWorldAgeHours()
                    local elapsedTime = currentTime - modData.methaneStartTime
                    local timeLeft = modData.TimeNeeded - elapsedTime
                    timeLeft = tonumber(string.format("%.1f", timeLeft))
                    local ProductionProgressOption = context:addOption("Production Progress " .. progresspercentage .. "%" .. " / Hours Required " .. timeLeft, worldobjects, dummy, player, object)
                end
                break
            end
        end
    end
end

function isTileValidForMethane(spriteName)
    for _, validTile in ipairs(validTiles) do
        if spriteName == validTile then
            return true
        end
    end
    return false
end

function addMethaneProductionTooltip(option, player)
    local tooltip = ISBuildMenu.addToolTip()
    option.toolTip = tooltip
    tooltip:setName("Methane Production Requirements")
    tooltip.description = "Requires:<LINE>"

    local playerInventory = getSpecificPlayer(player):getInventory()
    local wasteCount = playerInventory:getItemCountFromTypeRecurse("Base.WasteItem")

    if wasteCount > 5 then
        tooltip.description = tooltip.description .. "6 x Waste <LINE>"
    else
        tooltip.description = tooltip.description ..  "6 x Waste <LINE>"
    end

    tooltip.description = tooltip.description .. "Approx. 1 day to complete."
end

function startMethaneProduction(worldobjects, player, tile)
    local playerInventory = getSpecificPlayer(player):getInventory()
    local wasteCount = 0;

    local items = playerInventory:getItems()

    local allWasteBags = playerInventory:getAllTypeRecurse("Base.WasteItem");
    if not allWasteBags or allWasteBags:size() < 6 then
        getSpecificPlayer(player):setHaloNote("I need 6 waste bags to start methane production.", 255, 0, 0, 300);
        return
    end

    for i = 0, 5 do
        local iteratedWasteItem = allWasteBags:get(i);
        if iteratedWasteItem then
            iteratedWasteItem:getContainer():Remove(iteratedWasteItem);
        end
    end

    local modData = tile:getModData();
    modData.isProducingMethane = true
    modData.methaneStartTime = getGameTime():getWorldAgeHours()
    modData.tileState = 1
    modData.TimeNeeded = ((SandboxVars.ElectroLine and SandboxVars.ElectroLine.MethaneWorldHours) or (SandboxVars.CraftLine and SandboxVars.CraftLine.MethaneWorldHours) or 90);
    tile:transmitModData()
    updateTileState(tile, "inUse");

    local tileID = tile:getSquare():getX() .. "_" .. tile:getSquare():getY() .. "_" .. tile:getSquare():getZ()
    activeProductionTiles[tileID] = true
end


function checkMethaneProductionStatus()
    for tileID, _ in pairs(activeProductionTiles) do
        local x, y, z = tileID:match("^(%d+)_(%d+)_(%d+)$")
        local square = getCell():getGridSquare(tonumber(x), tonumber(y), tonumber(z))

        if square then
            for i = 0, square:getObjects():size() - 1 do
                local currentTile = square:getObjects():get(i)
                local modData = currentTile:getModData()

                if modData.isProducingMethane and isMethaneProductionComplete(modData.methaneStartTime) then
                    updateTileState(currentTile, "ready")
                    modData.tileState = 2
                    currentTile:transmitModData()

                    activeProductionTiles[tileID] = nil
                    break
                end
            end
        end
    end
end

function isMethaneProductionComplete(startTime)
    local methaneWorldHours = ((SandboxVars.ElectroLine and SandboxVars.ElectroLine.MethaneWorldHours) or (SandboxVars.CraftLine and SandboxVars.CraftLine.MethaneWorldHours) or 90);
    return getGameTime():getWorldAgeHours() >= (startTime + methaneWorldHours);
end

local function predicateGetUsedDeltaLessThan(item, count)
	return item:getUsedDelta() <= count;
end

function fillPropaneTank(worldobjects, player, tile)
    local player = getSpecificPlayer(0)
    local inv = player:getInventory()
    local propaneTank = inv:getFirstTypeEvalArgRecurse("Base.PropaneTank", predicateGetUsedDeltaLessThan, 0.0625);

    if not propaneTank then
        player:Say("I need an empty propane tank to collect the methane.");
        return
    end

    propaneTank:setUsedDelta(math.min(propaneTank:getUsedDelta() + 1));
    local modData = tile:getModData();
    modData.isProducingMethane = false;
    updateTileState(tile, "inactive");
    modData.tileState = 0;
    tile:transmitModData();
end

function fillMethaneTank(worldobjects, player, tile)
    local player = getSpecificPlayer(0)
    local inv = player:getInventory()
    local propaneTank = inv:getFirstTypeRecurse("Base.EmptyMethaneTank")

    if not propaneTank then
        player:Say("I need an empty methane tank to collect the methane.");
        return;
    end

    inv:Remove(propaneTank);
    inv:AddItem('Base.MethaneTank');
    local modData = tile:getModData();
    modData.isProducingMethane = false;
    updateTileState(tile, "inactive");
    modData.tileState = 0;
    tile:transmitModData();
end


function makeDigesterIndestructible(object)
    if object and object:getSprite() and isTileValidForMethane(object:getSprite():getName()) then
        object.takeDamage = function() return false end
    end
end

Events.OnObjectAdded.Add(makeDigesterIndestructible)
Events.EveryHours.Add(checkMethaneProductionStatus)
Events.OnFillWorldObjectContextMenu.Add(OnRightClickTile)
