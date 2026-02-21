LootTicketManager = {};

local original_ISInventoryTransferAction_perform = ISInventoryTransferAction.perform;
function ISInventoryTransferAction:perform()
    if self.item:getType() ~= "DLDC_ItemLootTicket_Set" then 
        return original_ISInventoryTransferAction_perform(self);
    end

    if (not isAdmin() and not isDebugEnabled()) then

        if self.item:getModData().LootTicket and self.item:getModData().LootTicket.RestrictedTo then
            if self.item:getModData().LootTicket.RestrictedTo ~= getPlayer():getUsername() then
                getPlayer():setHaloNote("This isn't my loot ticket to take.", 180, 25, 25, 300);
                return false;
            end
        end

    end

    return original_ISInventoryTransferAction_perform(self);
end

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

function LootTicketManager.OpenTicket(playerNum, item)
    if not item:getType() == "DLDC_ItemLootTicket_Set" then return end;
    if not item:getModData().LootTicket then return end;

    ISTimedActionQueue.add(DLOpenLootTicketAction:new(item));
end

function LootTicketManager.SetTicketRestricted(target, button, item)
    if not item then return end;

    if button.internal ~= "OK" then
        return
    end

    local targetUsername = button.target.entry:getText();
    if targetUsername and targetUsername ~= "" then
        local modData = item:getModData();
        if not modData.LootTicket then
            print("ERROR ATTEMPTING TO RESTRICT TICKET - NO LOOT TICKET MODDATA");
            return;
        end

        modData.LootTicket.RestrictedTo = targetUsername;

        LogLineUtils.LogFromClient("LootTicket", string.format("Staff %s has set loot ticket ID %0d to be restricted to username %s", getPlayer():getUsername(), modData.LootTicket.ID, targetUsername));
        getPlayer():setHaloNote("Loot ticket restricted to " .. targetUsername, 180, 25, 25, 300);
    else
        local modData = item:getModData();
        if not modData.LootTicket then
            print("ERROR ATTEMPTING TO UNRESTRICT TICKET - NO LOOT TICKET MODDATA");
            return;
        end

        modData.LootTicket.RestrictedTo = nil;

        LogLineUtils.LogFromClient("LootTicket", string.format("Staff %s has set loot ticket ID %0d to be unrestricted", getPlayer():getUsername(), modData.LootTicket.ID));
        getPlayer():setHaloNote("Loot ticket unrestricted!", 180, 25, 25, 300);
    end
end

function LootTicketManager.ShowTicketParams(playerNum, item)
    if isAdmin() or isDebugEnabled() then
        local itemData = item:getModData().LootTicket.Items;

        local ui = DLLootTicketInspectionUI:new(0, 0, 500, 300, itemData);
        ui:initialise();
        ui:addToUIManager();
    end
end


function LootTicketManager.RestrictToPlayer(playerNum, item)
    local labelStr = "Enter the username for who this should be restricted to."
    local width = getTextManager():MeasureStringX(UIFont.Small, labelStr);
    local modal = ISTextBox:new(0, 0, width * 1.2, 150, labelStr, "", nil, LootTicketManager.SetTicketRestricted, playerNum, item);
    modal:initialise();
    modal:addToUIManager();
end

function LootTicketManager.OnFillInventoryObjectContextMenu(playerNum, context, items)

    if not playerNum then return end

    local playerObj = getSpecificPlayer(playerNum);
    if not playerObj then return end;

    items = ISInventoryPane.getActualItems(items);

    for i, item in ipairs(items) do
        if instanceof(item, "InventoryItem") then
            if item:getType() == "DLDC_ItemLootTicket_Unset" and item:getContainer() == playerObj:getInventory() and (isAdmin() or isDebugEnabled()) then
                local controlsOpt = context:addOption(getText("ContextMenu_LootTicketControls"), playerNum, nil);
                local lootSubMenu = context:getNew(context);
                context:addSubMenu(controlsOpt, lootSubMenu);

                lootSubMenu:addOption(getText("ContextMenu_SetLootTicketParameters"), playerNum, LootTicketManager.ShowSetContext, item);
            end

            if item:getType() == "DLDC_ItemLootTicket_Set" and item:getContainer() == playerObj:getInventory() then
                local controlsOpt = context:addOption(getText("ContextMenu_LootTicketControls"), playerNum, nil);
                local lootSubMenu = context:getNew(context);
                context:addSubMenu(controlsOpt, lootSubMenu);

                if item:getModData().LootTicket then
                    local lootData = item:getModData().LootTicket;
                    local showOpenOption = false;

                    if not lootData.RestrictedTo then
                        showOpenOption = true;
                    end

                    if lootData.RestrictedTo and lootData.RestrictedTo == getPlayer():getUsername() then
                        showOpenOption = true;
                    end

                    local openOption = lootSubMenu:addOption(getText("ContextMenu_OpenLootTicket"), playerNum, LootTicketManager.OpenTicket, item);
                    if not showOpenOption then
                        openOption.notAvailable = true;
                        openOption.toolTip = ISWorldObjectContextMenu.addToolTip();
                        openOption.toolTip.description = "<RED>This loot ticket is restricted to a specific player and you cannot open it. <LINE> <LINE> If you think this is in error, contact a staff member.";

                        if isAdmin() or isDebugEnabled() then
                            local adminString = string.format(" <LINE> <LINE> <ORANGE> STAFF - Username: %s", lootData.RestrictedTo);
                            local newWidth = getTextManager():MeasureStringX(UIFont.Medium, adminString);
                            openOption.toolTip.description = openOption.toolTip.description .. adminString;
                            if newWidth > openOption.toolTip:getWidth() then
                                openOption.toolTip:setWidth(newWidth * 1.1);
                            end
                        end
                    end
                end

                if isAdmin() or isDebugEnabled() then
                    lootSubMenu:addOption(getText("ContextMenu_SeeLootTicketParameters"), playerNum, LootTicketManager.ShowTicketParams, item);
                    lootSubMenu:addOption(getText("ContextMenu_RestrictToPlayer"), playerNum, LootTicketManager.RestrictToPlayer, item);
                end
            end
        end
    end
end

function LootTicketManager.OnServerCommand(module, command, args)
    if module ~= "LootTicket" then return end;

    if command == "ReceiveRollResults" then
        print("LootTicketOnServerCommand");

        if not args.ticket then
            print("No ticket, cancelling roll.");
            return;
        end

        local halfScreenX = Math.ceil(getCore():getScreenWidth() / 2);
        local halfScreenY = Math.ceil(getCore():getScreenHeight() / 2);

        local uiWidth = Math.ceil(halfScreenX * 0.5);
        local uiHeight = Math.ceil(halfScreenY * 0.5);

        local posX = halfScreenX - uiWidth;
        local posY = halfScreenY - uiHeight

        local rewardScreen = DLLootResultsUI:new(posX, posY, uiWidth, uiHeight, args.rewards);
        rewardScreen:initialise();
        rewardScreen:addToUIManager();
    end
end


Events.OnServerCommand.Add(LootTicketManager.OnServerCommand);
Events.OnFillInventoryObjectContextMenu.Add(LootTicketManager.OnFillInventoryObjectContextMenu);