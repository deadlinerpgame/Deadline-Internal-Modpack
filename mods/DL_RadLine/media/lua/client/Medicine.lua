require "MF_ISMoodle"

local function addPotassiumOption(player, context, worldObjects)
    local primaryItem = worldObjects[1]
    local playerObj = getSpecificPlayer(player)
    local inventory = playerObj:getInventory()
    local RadValue = MF.getMoodle("MoodleRadRes"):getValue()
    if not instanceof(primaryItem, "InventoryItem") then
        primaryItem = primaryItem.items[1]
    end

    if primaryItem:getFullType() == "Base.PotassiumIodide" then
        context:addOption("Use Potassium Iodide", worldObjects, function()
            print("Radiation pill used!")
            
            inventory:Remove(primaryItem)
            if RadValue + 0.25 > 1 then
                MF.getMoodle("MoodleRadRes"):setValue(1)
            else
            MF.getMoodle("MoodleRadRes"):setValue(RadValue + 0.25)
            end

        end)
    end
end

local function addPrussianBlueOption(player, context, worldObjects)
    local primaryItem = worldObjects[1]
    local playerObj = getSpecificPlayer(player)
    local inventory = playerObj:getInventory()
    local RadValue = MF.getMoodle("MoodleRadRes"):getValue()
    if not instanceof(primaryItem, "InventoryItem") then
        primaryItem = primaryItem.items[1]
    end

    if primaryItem:getFullType() == "Base.PrussianBlue" then
        context:addOption("Use Prussian Blue", worldObjects, function()
            print("Radiation pill used!")
            
            inventory:Remove(primaryItem)
            if RadValue + 0.5 > 1 then
                MF.getMoodle("MoodleRadRes"):setValue(1)
            else
            MF.getMoodle("MoodleRadRes"):setValue(RadValue + 0.5)
            end

        end)
    end
end



local function addNeupogenOption(player, context, worldObjects)
    local primaryItem = worldObjects[1]
    local playerObj = getSpecificPlayer(player)
    local inventory = playerObj:getInventory()
    local RadValue = MF.getMoodle("MoodleRad"):getValue()
    if not instanceof(primaryItem, "InventoryItem") then
        primaryItem = primaryItem.items[1]
    end

    if primaryItem:getFullType() == "Base.Neupogen" then
        context:addOption("Inject Neupogen", worldObjects, function()
            print("Radiation pill used!")
            
            inventory:Remove(primaryItem)
            if RadValue + 0.5 > 1 then
                MF.getMoodle("MoodleRad"):setValue(1)
            else
            MF.getMoodle("MoodleRad"):setValue(RadValue + 0.5)
            end

        end)
    end
end

local function addDTPAOption(player, context, worldObjects)
    local primaryItem = worldObjects[1]
    local playerObj = getSpecificPlayer(player)
    local inventory = playerObj:getInventory()
    local RadValue = MF.getMoodle("MoodleRad"):getValue()
    if not instanceof(primaryItem, "InventoryItem") then
        primaryItem = primaryItem.items[1]
    end

    if primaryItem:getFullType() == "Base.DTPA" then
        context:addOption("Inject Diethylenetriamine Pentaacetate", worldObjects, function()
            print("Radiation pill used!")
            
            inventory:Remove(primaryItem)
            if RadValue + 0.5 > 1 then
                MF.getMoodle("MoodleRad"):setValue(1)
            else
            MF.getMoodle("MoodleRad"):setValue(RadValue + 0.5)
            end

        end)
    end
end

local function RadResist()
    local RadValueRes = MF.getMoodle("MoodleRadRes"):getValue()
    local player = getPlayer()
    if RadValueRes > 0 then
        MF.getMoodle("MoodleRadRes"):setValue(RadValueRes - 0.00002)
        print(RadValueRes)

    end
end

-- Hook the function into the game's context menu generator
Events.OnFillInventoryObjectContextMenu.Add(addPotassiumOption)
Events.OnFillInventoryObjectContextMenu.Add(addPrussianBlueOption)
Events.OnFillInventoryObjectContextMenu.Add(addNeupogenOption)
Events.OnFillInventoryObjectContextMenu.Add(addDTPAOption)
Events.OnTick.Add(RadResist)