LootTicketManager = {};

function LootTicketManager.ShowSetContext(playerNum, item)
    if not playerNum or not item then return end;

    local playerObj = getSpecificPlayer(playerNum);
    if not playerObj then return end;

    if item:getType() ~= "DLDC_ItemLootTicket_Unset" then return end;

    -- Get the item in the player's primary hand.
    local primaryHandItem = playerObj:getPrimaryHandItem();
    if not primaryHandItem then
        playerObj:setHaloNote("I need a container equipped in my primary hand to get the items from.", 180, 25, 25, 300);
        return;
    end

    if not primaryHandItem:IsInventoryContainer() then
        playerObj:setHaloNote("I must have a container equipped in my primary hand to continue.", 180, 25, 25, 300);
        return;
    end

    local uniqueItemsTable = {};

    local possibleItems = primaryHandItem:getInventory():getItems();
    for i = 0, possibleItems:size() - 1 do
        local item = possibleItems:get(i);
        if item and not uniqueItemsTable[item:getFullType()] then
            local itemType = item:getFullType();
            uniqueItemsTable[itemType] = 1;
        elseif item and uniqueItemsTable[item:getFullType()] then
            local itemType = item:getFullType();
            local count = uniqueItemsTable[itemType];

            uniqueItemsTable[itemType] = count + 1;
        end
    end

    local halfScreenX = Math.ceil(getCore():getScreenWidth() / 2);
    local halfScreenY = Math.ceil(getCore():getScreenHeight() / 2);

    local uiWidth = Math.ceil(halfScreenX * 0.8);
    local uiHeight = Math.ceil(halfScreenY * 0.8);

    local posX = halfScreenX - uiWidth;
    local posY = halfScreenY - uiHeight

    -- Now we have all the items and the number of them, we need to show the player a UI which has the full item list and the chance to win.
    local ui = DLLootTicketChancesUI:new(posX, posY, uiWidth, uiHeight, item, uniqueItemsTable);
    ui:initialise();
    ui:addToUIManager();
end

function LootTicketManager.OnFillInventoryObjectContextMenu(playerNum, context, items)

    if not playerNum then return end

    local playerObj = getSpecificPlayer(playerNum);
    if not playerObj then return end;

    items = ISInventoryPane.getActualItems(items);

    for i, item in ipairs(items) do
        if instanceof(item, "InventoryItem") then
            if item:getType() == "DLDC_ItemLootTicket_Unset" and item:isInPlayerInventory() and (isAdmin() or isDebugEnabled()) then
                local controlsOpt = context:addOption(getText("ContextMenu_LootTicketControls"), playerNum, nil);
                local lootSubMenu = context:getNew(context);
                context:addSubMenu(controlsOpt, lootSubMenu);

                lootSubMenu:addOption(getText("ContextMenu_SetLootTicketParameters"), playerNum, LootTicketManager.ShowSetContext, item);
                lootSubMenu:addOption(getText("ContextMenu_LootTicketParameters_Help"), playerNum, LootTicketManager.ShowHelpMenu, item);
            end
        end
    end
end

Events.OnFillInventoryObjectContextMenu.Add(LootTicketManager.OnFillInventoryObjectContextMenu);