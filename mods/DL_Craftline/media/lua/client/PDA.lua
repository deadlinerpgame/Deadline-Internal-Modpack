local function OpenPDANotepad(player, item)
    local itemModData = item:getModData()
    local screenWidth = getCore():getScreenWidth()
    local screenHeight = getCore():getScreenHeight()

    local modalWidth = 480
    local modalHeight = 640

    local modalX = (screenWidth - modalWidth) / 2
    local modalY = (screenHeight - modalHeight) / 2

    local modal = ISPanel:new(modalX, modalY, modalWidth, modalHeight)
    modal:setVisible(true)
    modal:addToUIManager()

    local title = ISLabel:new(300, 10, 20, "Z-Top PDA Notepad", 1, 1, 1, 1, UIFont.Medium)
    modal:addChild(title)


    local contentsField = ISTextEntryBox:new("", 25, 40, 430 , 500)
	contentsField:initialise()

	contentsField:setAnchorRight(true)
	contentsField:setAnchorBottom(true)

    modal:addChild(contentsField)

	contentsField:setMultipleLine(true)
	contentsField:addScrollBars()
    contentsField:setText(itemModData["journalText"] or "Thank you for purchasing our Z-Top PDA!");



    -- Submit button
    local submitButton = ISButton:new(20, 580, 100, 30, "Save", modal, function()
        local contents = contentsField:getText()

        itemModData["journalText"] = contents
        print(contents)
        print(itemModData["journalText"])
        
        modal:removeFromUIManager()
    end)
    modal:addChild(submitButton)
    local cancelButton = ISButton:new(360, 580, 100, 30, "Quit", modal, function()
        local contents = contentsField:getText()

        itemModData["journalText"] = contents
        print(contents)
        print(itemModData["journalText"])
        
        modal:removeFromUIManager()
    end)
    modal:addChild(cancelButton)
end


local function PDAWrite(player, context, worldObjects)
    local primaryItem = worldObjects[1]
    local playerObj = getSpecificPlayer(player)
    local inventory = playerObj:getInventory()
    if not instanceof(primaryItem, "InventoryItem") then
        primaryItem = primaryItem.items[1]
    end

    if primaryItem:getFullType() == "Base.PDA" then
        print(primaryItem)
        context:addOption("Write in PDA", playerObj, OpenPDANotepadd, primaryItem);      
    end
end

Events.OnFillInventoryObjectContextMenu.Add(PDAWrite)

function OpenPDANotepadd(player, item)
    local itemModData = item:getModData()
    local screenWidth = getCore():getScreenWidth()
    local screenHeight = getCore():getScreenHeight()

    local modalWidth = 480
    local modalHeight = 640

    local modalX = (screenWidth - modalWidth) / 2
    local modalY = (screenHeight - modalHeight) / 2

    local notepadUI = PDA_NotepadUI:new(modalX, modalY, modalWidth, modalHeight, itemModData)
    notepadUI:initialise()
    notepadUI:addToUIManager()
end