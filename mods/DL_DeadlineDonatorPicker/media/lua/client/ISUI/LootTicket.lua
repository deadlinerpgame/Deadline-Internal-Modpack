LootTicketManager = {};

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