LootTicketManager = {};

function LootTicketManager.ShowSetContext(playerNum, item)
    if not playerNum or not item then return end;

    local playerObj = getSpecificPlayer(playerNum);
    if not playerObj then return end;

    if item:getFullType() ~= "DLDC_ItemLootTicket_Unset" then return end;

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

    -- Get all items from the container.
    local handContainer = primaryHandItem:getContainer();
    if not handContainer then return end; -- Something's gone wrong as IsInventoryContainer should catch this.

    local uniqueItemsTable = {};

    local possibleItems = handContainer:getItems();
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

    -- Now we have all the items and the number of them, we need to show the player a UI which has the full item list and the chance to win.
    
end

function LootTicketManager.OnFillInventoryObjectContextMenu(playerNum, context, items)

    if not playerNum then return end

    local playerObj = getSpecificPlayer(playerNum);
    if not playerObj then return end;

    items = ISInventoryPane.getActualItems(items);

    for i, item in ipairs(items) do
        if instanceof(item, "InventoryItem") then
            if item:getType() == "DLDC_ItemLootTicket_Unset" and item:isInPlayerInventory() and isAdmin() then
                context:addOption(getText("ContextMenu_LootTicketControls"), playerNum, nil);
                local lootSubMenu = context:getNew(context);
                context:addSubMenu(context, lootSubMenu);

                lootSubMenu:addOption(getText("ContextMenu_SetLootTicketParameters"), playerNum, LootTicketManager.ShowSetContext, item);
                lootSubMenu:addOption(getText("ContextMenu_LootTicketParameters_Help"), playerNum, LootTicketManager.ShowHelpMenu, item);
            end
        end
    end
end

Events.OnFillInventoryObjectContextMenu.Add(LootTicketManager.OnFillInventoryObjectContextMenu);