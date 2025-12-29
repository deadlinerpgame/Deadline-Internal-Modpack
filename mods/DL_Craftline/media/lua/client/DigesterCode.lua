local validTiles = {
    "dl_workbenches_0", "dl_workbenches_1", "dl_workbenches_2", "dl_workbenches_3",
    "dl_workbenches_4", "dl_workbenches_5", "dl_workbenches_6", "dl_workbenches_7",
    "dl_workbenches_8", "dl_workbenches_9", "dl_workbenches_10", "dl_workbenches_11"
}

-- Map tiles to their "in use" and "ready" counterparts
local tileStateMapping = {
    -- Original inactive states with transitions to inUse and ready
    ["dl_workbenches_0"] = {inUse = "dl_workbenches_4", ready = "dl_workbenches_8"},
    ["dl_workbenches_1"] = {inUse = "dl_workbenches_5", ready = "dl_workbenches_9"},
    ["dl_workbenches_2"] = {inUse = "dl_workbenches_6", ready = "dl_workbenches_10"},
    ["dl_workbenches_3"] = {inUse = "dl_workbenches_7", ready = "dl_workbenches_11"},

    -- "inUse" states with transitions to ready
    ["dl_workbenches_4"] = {ready = "dl_workbenches_8", inactive = "dl_workbenches_0"},
    ["dl_workbenches_5"] = {ready = "dl_workbenches_9", inactive = "dl_workbenches_1"},
    ["dl_workbenches_6"] = {ready = "dl_workbenches_10", inactive = "dl_workbenches_2"},
    ["dl_workbenches_7"] = {ready = "dl_workbenches_11", inactive = "dl_workbenches_3"},

    -- "ready" states with transitions back to inactive
    ["dl_workbenches_8"] = {inactive = "dl_workbenches_0"},
    ["dl_workbenches_9"] = {inactive = "dl_workbenches_1"},
    ["dl_workbenches_10"] = {inactive = "dl_workbenches_2"},
    ["dl_workbenches_11"] = {inactive = "dl_workbenches_3"}
}

-- 0 is N, 1 is S, 2 is W and 3 is E


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
        else -- Default to inactive
            newSpriteName = spriteName
            modData.tileState = 0
        end

        print("Updating tile to state:", state, "with new sprite:", newSpriteName)  -- Debug output

        -- Set the new sprite and force a network update
        object:setSprite(getSprite(newSpriteName))
        object:transmitUpdatedSprite()
        
        -- Broadcast the sprite change to all clients
        if isServer() then
            object:transmitUpdatedSpriteToClients()  -- Sync with clients
            object:syncIsoObject()               -- Refresh for client display
        else
            object:transmitUpdatedSpriteToServer()
        end
    else
        print("Error: Sprite name does not match any tileStateMapping entry:", spriteName)
    end
end

-- Function to add context menu options only for specific tiles
function OnRightClickTile(player, context, worldobjects)
    -- Loop through the world objects under the cursor
    for _, object in ipairs(worldobjects) do
        -- Check if the object's sprite name is one of the valid tile names
        if object and object:getSprite() then
            local spriteName = object:getSprite():getName()
            if spriteName and isTileValidForMethane(spriteName) then
                local modData = object:getModData()

                -- Initialize modData properties if they don't exist
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
                -- Define the tooltip for the Start Methane Production option
                if not modData.isProducingMethane then
                    local startOption = context:addOption("Start Methane Production", worldobjects, startMethaneProduction, player, object)
                    addMethaneProductionTooltip(startOption, player)      
                elseif isMethaneProductionComplete(modData.methaneStartTime) then
                    -- Add option to fill propane tank if production is complete
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
                break -- Only add the option once for the first matching tile found
            end
        end
    end
end

-- Helper function to check if a tile sprite name is in the valid list
function isTileValidForMethane(spriteName)
    for _, validTile in ipairs(validTiles) do
        if spriteName == validTile then
            return true
        end
    end
    return false
end

-- Helper function to add a tooltip for the Start Methane Production option
function addMethaneProductionTooltip(option, player)
    local tooltip = ISBuildMenu.addToolTip()
    option.toolTip = tooltip
    tooltip:setName("Methane Production Requirements")
    tooltip.description = "Requires:<LINE>"

    local playerInventory = getSpecificPlayer(player):getInventory()
    local wasteCount = playerInventory:getItemCountFromTypeRecurse("Base.WasteItem")

    -- Check if the player has the required 5 waste items
    if wasteCount > 5 then
        tooltip.description = tooltip.description .. "6 x Waste <LINE>"
    else
        tooltip.description = tooltip.description ..  "6 x Waste <LINE>"
    end

    -- Add the production time information to the tooltip
    tooltip.description = tooltip.description .. "Approx. 1 day to complete."
end

-- Function to start methane production, stores state in tile's ModData
function startMethaneProduction(worldobjects, player, tile)
    local playerInventory = getSpecificPlayer(player):getInventory()
    local wasteCount = 0;

    local items = playerInventory:getItems()

    local allWasteBags = playerInventory:getAllTypeRecurse("Base.WasteItem");
    if not allWasteBags or allWasteBags:size() < 6 then
        getSpecificPlayer(player):setHaloNote("I need 6 waste bags to start methane production.");
        return
    end

    -- Remove the waste items.
    for i = 1, 6 do
        local iteratedWasteItem = allWasteBags[i];
        if iteratedWasteItem then
            iteratedWasteItem:getContainer():Remove(iteratedWasteItem);
        end
    end

    local modData = tile:getModData();
    modData.isProducingMethane = true
    modData.methaneStartTime = getGameTime():getWorldAgeHours()
    modData.tileState = 1
    modData.TimeNeeded = SandboxVars.CraftLine.MethaneWorldHours;
    tile:transmitModData() -- Ensure data persists across sessions
    updateTileState(tile, "inUse");  -- Set to in-use sprite

    -- Add the tile's unique identifier to the active production tracking list
    local tileID = tile:getSquare():getX() .. "_" .. tile:getSquare():getY() .. "_" .. tile:getSquare():getZ()
    activeProductionTiles[tileID] = true
end


function checkMethaneProductionStatus()
    for tileID, _ in pairs(activeProductionTiles) do
        -- Parse the tile coordinates from the unique ID
        local x, y, z = tileID:match("^(%d+)_(%d+)_(%d+)$")
        local square = getCell():getGridSquare(tonumber(x), tonumber(y), tonumber(z))

        if square then
            -- Re-fetch each tile object directly from the square
            for i = 0, square:getObjects():size() - 1 do
                local currentTile = square:getObjects():get(i)
                local modData = currentTile:getModData()

                -- Check if production is complete
                if modData.isProducingMethane and isMethaneProductionComplete(modData.methaneStartTime) then
                    -- Update the tile to "ready" state and reset production status
                    updateTileState(currentTile, "ready")
                    modData.tileState = 2
                    currentTile:transmitModData() -- Sync changes

                    -- Remove tile from active tracking list
                    activeProductionTiles[tileID] = nil
                    break  -- Exit loop once the target tile is updated
                end
            end
        end
    end
end

-- Function to check if 3 days have passed
function isMethaneProductionComplete(startTime)
    return getGameTime():getWorldAgeHours() >= startTime + SandboxVars.CraftLine.MethaneWorldHours;
end

local function predicateGetUsedDeltaLessThan(item, count)
	return item:getUsedDelta() <= count;
end

-- Function to fill the propane tank, modifies the tile's ModData
function fillPropaneTank(worldobjects, player, tile)
    local player = getSpecificPlayer(0)
    local inv = player:getInventory()
    local propaneTank = inv:getFirstTypeEvalArgRecurse("Base.PropaneTank", predicateGetUsedDeltaLessThan, 0.0625); -- Use the correct item ID

    if not propaneTank then
        player:Say("I need an empty propane tank to collect the methane.");
        return
    end

    -- Fill the propane tank
    propaneTank:setUsedDelta(math.min(propaneTank:getUsedDelta() + 1));
    local modData = tile:getModData();
    modData.isProducingMethane = false; -- Reset production state for this tile
    updateTileState(tile, "inactive");  -- Set to in-use sprite
    modData.tileState = 0;
    tile:transmitModData(); -- Ensure data persists across sessions
end

function fillMethaneTank(worldobjects, player, tile)
    local player = getSpecificPlayer(0)
    local inv = player:getInventory()
    local propaneTank = inv:getFirstTypeRecurse("Base.EmptyMethaneTank")

    if not propaneTank then
        player:Say("I need an empty methane tank to collect the methane.");
        return;
    end

    -- Fill the propane tank
    inv:Remove(propaneTank);
    inv:AddItem('Base.MethaneTank');
    local modData = tile:getModData();
    modData.isProducingMethane = false; -- Reset production state for this tile
    updateTileState(tile, "inactive");  -- Set to in-use sprite
    modData.tileState = 0;
    tile:transmitModData(); -- Ensure data persists across sessions
end


function makeDigesterIndestructible(object)
    -- Override the takeDamage method to prevent damage
    if object and object:getSprite() and isTileValidForMethane(object:getSprite():getName()) then
        object.takeDamage = function() return false end
    end
end

-- Apply this function to the digester tile when it's created


-- Add the OnRightClickTile function to context menu event
Events.OnObjectAdded.Add(makeDigesterIndestructible)
Events.EveryHours.Add(checkMethaneProductionStatus)
Events.OnFillWorldObjectContextMenu.Add(OnRightClickTile)
