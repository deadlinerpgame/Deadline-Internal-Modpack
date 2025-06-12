GlobalModData = GlobalModData or {}
GlobalModData.DonoMallContainers = GlobalModData.DonoMallContainers or {}

function OnRightClickDonoContainer(player, context, worldobjects)
    local player = getSpecificPlayer(0)

    -- Check if the player is in debug mode or has admin privileges
    if isDebugEnabled() or player:isAccessLevel("admin") then
        local optionsAdded = false
        -- Iterate through the objects the player is right-clicking on
        for _, object in ipairs(worldobjects) do
            local square = object:getSquare()
            if square and not optionsAdded then
                for i = 0, square:getObjects():size() - 1 do
                    local obj = square:getObjects():get(i)
                    local spr = obj:getObjectName()

                    -- Check if the object has a container
                    if obj:getContainer() then
                        ObjectName = obj:getObjectName()
                        local modData = obj:getModData()
                        local x = player:getX()
                        local y = player:getY()
                        local z = player:getZ()
                        object:transmitModData()
                        ISLogSystem.sendLog(player, "containerrespawn", "Player " .. player:getUsername() .. " has respawned a container at " .. x .. " , " .. y .. " , " .. z )

                        if not modData.DonoMallContainer or not modData.DonoMallContainer == true then
                        context:addOption("Enable Respawn Container", worldobjects, enableContainer, player, object)
                        context:addOption("See Container Contents", worldobjects, openContainerContentsUI, player, object)
                        elseif modData.DonoMallContainer == true then
                            context:addOption("Modify Respawn Container", worldobjects, openTextInputUI, player, object)                        
                            context:addOption("Disable Respawn Container", worldobjects, disableContainer, player, object)

                        end
                        optionsAdded = true -- Prevent further additions
                        break
                    end
                end
            end

            if optionsAdded then
                break -- Exit the outer loop as well
            end
        end
    end
    for _, object in ipairs(worldobjects) do
        local modData = object:getModData()
        modData.DonoMallContainer = modData.DonoMallContainer
        modData.Entries = modData.Entries
        object:transmitModData()
        if modData.DonoMallContainer and modData.Entries then
            print("modData.Entries:", table.concat(modData.Entries, ", ")) 
            local container = object:getContainer()
            if container then
                -- Empty the container
                container:clear()
                -- Add items from modData.Entries
                for _, entry in ipairs(modData.Entries) do
                    local newItem = InventoryItemFactory.CreateItem(entry)
                    if newItem then
                        container:AddItem(newItem)
                    end
                end
                

            end
        end
    end
end

function enableContainer(worldobjects, player, object)
    local modData = object:getModData() 
    modData.DonoMallContainer = true
    object:transmitModData()
    table.insert(GlobalModData.DonoMallContainers, object)
    local x = player:getX()
    local y = player:getY()
    local z = player:getZ()
    ISLogSystem.sendLog(player, "containerrespawn", "Player " .. player:getUsername() .. " has enabled a respawning container at " .. x .. " , " .. y .. " , " .. z )
end

function disableContainer(worldobjects, player, object)
    local modData = object:getModData()
    modData.DonoMallContainer = false
    object:transmitModData()
    local x = player:getX()
    local y = player:getY()
    local z = player:getZ()
    ISLogSystem.sendLog(player, "containerrespawn", "Player " .. player:getUsername() .. " has disabled a respawning container at " .. x .. " , " .. y .. " , " .. z )
    for i, obj in ipairs(GlobalModData.DonoMallContainers) do
        if obj == object then
            table.remove(GlobalModData.DonoMallContainers, i)
            break
        end
    end
end

function openTextInputUI(worldobjects, player, object)
    -- Get screen dimensions


    print(ObjectName)
    local screenWidth = getCore():getScreenWidth()
    local screenHeight = getCore():getScreenHeight()

    -- Calculate centered position
    local uiWidth = 800
    local uiHeight = 150
    local uiX = (screenWidth - uiWidth) / 2
    local uiY = (screenHeight - uiHeight) / 2

    local ui = ISPanel:new(uiX, uiY, uiWidth, uiHeight)
    ui:initialise()
    ui:instantiate()
    ui:addToUIManager()

    -- Prepare the array data
    local modData = object:getModData()
    modData.Entries = modData.Entries or {}
    local arrayText = table.concat(modData.Entries, ";")

    -- Text Box
    local textBox = ISTextEntryBox:new(arrayText, 10, 20, 780, 30)
    textBox:initialise()
    ui:addChild(textBox)

    -- Submit Button
    local submitButton = ISButton:new(10, 50, 100, 25, "Submit", ui, function()
        local inputText = textBox:getText()
        local newArray = {}
        for entry in string.gmatch(inputText, "[^;]+") do
            table.insert(newArray, entry)
        end
        modData.Entries = newArray
        print("Updated Entries: " .. table.concat(modData.Entries, ";"))
        local x = player:getX()
        local y = player:getY()
        local z = player:getZ()
        ISLogSystem.sendLog(player, "containerrespawn", "Player " .. player:getUsername() .. " has modified a respawning container at " .. x .. " , " .. y .. " , " .. z .. " with the following items: " .. table.concat(modData.Entries, ";") )
        ObjectName = object:getObjectName()
        ui:removeFromUIManager()
    end)
    submitButton:initialise()
    object:transmitModData()
    ui:addChild(submitButton)

    -- Cancel Button
    local cancelButton = ISButton:new(120, 50, 100, 25, "Cancel", ui, function()
        print("UI Cancelled")
        ui:removeFromUIManager()
    end)
    cancelButton:initialise()
    ui:addChild(cancelButton)
    -- UI Title
    local titleLabel = ISLabel:new(240, 0, 25, "List of items, separated by a dotcomma(;):", 1, 1, 1, 1, UIFont.Small)
    titleLabel:initialise()
    ui:addChild(titleLabel)
end

function openContainerContentsUI(worldobjects, player, object)
    -- Get screen dimensions
    local screenWidth = getCore():getScreenWidth()
    local screenHeight = getCore():getScreenHeight()

    -- Calculate centered position
    local uiWidth = 800
    local uiHeight = 150
    local uiX = (screenWidth - uiWidth) / 2
    local uiY = (screenHeight - uiHeight) / 2

    local ui = ISPanel:new(uiX, uiY, uiWidth, uiHeight)
    ui:initialise()
    ui:instantiate()
    ui:addToUIManager()

    -- Get container contents
    local container = object:getContainer()
    local itemsText = ""
    if container then
        local items = {}
        for i = 0, container:getItems():size() - 1 do
            local item = container:getItems():get(i)
            if item then
                table.insert(items, getFullItemName(item)) -- Use full item name
            end
        end
        itemsText = table.concat(items, ";")
    end

    -- Text Box
    local textBox = ISTextEntryBox:new(itemsText, 10, 20, 780, 30)
    textBox:initialise()
    ui:addChild(textBox)

    -- Submit Button
    local submitButton = ISButton:new(10, 50, 100, 25, "Submit", ui, function()
        local inputText = textBox:getText()
        local newArray = {}
        for entry in string.gmatch(inputText, "[^;]+") do
            table.insert(newArray, entry)
        end

        -- Update container with new items
        if container then
            container:clear()
            for _, entry in ipairs(newArray) do
                local newItem = InventoryItemFactory.CreateItem(entry)
                if newItem then
                    container:AddItem(newItem)
                end
            end
        end

        print("Updated Container Items: " .. table.concat(newArray, ";"))
        ui:removeFromUIManager()
    end)
    submitButton:initialise()
    ui:addChild(submitButton)

    -- Cancel Button
    local cancelButton = ISButton:new(120, 50, 100, 25, "Cancel", ui, function()
        print("UI Cancelled")
        ui:removeFromUIManager()
    end)
    cancelButton:initialise()
    ui:addChild(cancelButton)

    -- UI Title
    local titleLabel = ISLabel:new(240, 0, 25, "Current container contents (editable):", 1, 1, 1, 1, UIFont.Small)
    titleLabel:initialise()
    ui:addChild(titleLabel)
end

function getFullItemName(item)
    if item then
        return item:getModule() .. "." .. item:getType()
    end
    return nil
end

Events.OnFillWorldObjectContextMenu.Add(OnRightClickDonoContainer)