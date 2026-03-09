if isClient() and not isServer() then return end;

LootTicket_ServerManager = {};

local randInstance = newrandom();

local function sortOnChance(a, b)
    return tonumber(a.item.Chance) > tonumber(b.item.Chance);
end

function LootTicket_ServerManager.GetWeightedChance(items)
    local totalChance = 0;

    for _, itemData in ipairs(items) do
        local chance = tonumber(itemData.item.Chance);
        if chance < 100 then
            totalChance = totalChance + chance;
        end
    end

    return totalChance;
end

function LootTicket_ServerManager.PerformTicketRoll(player, ticket, lootData)

    if not player then
        print("LootTicket_ServerManager.PerformTicketRoll - invalid target username provided, cannot find player.");
        return;
    end

    local itemsToGive = {};
    local possibleItems = {};

    local totalChance = 0;
    local logStr = "[OPENING LOOT TICKET] Player: " .. player:getUsername() .. " || ID: " .. tostring(lootData.ID) ..  " || ";


    for _, itemData in ipairs(lootData.Items) do
        local chance = tonumber(itemData.item.Chance);

        itemData.hasRolled = false;
        if chance < 100 then
            totalChance = totalChance + chance; -- If not guaranteed, get their chance and get the weighted total.
            table.insert(possibleItems, itemData);
        else
            table.insert(itemsToGive, itemData); -- Guaranteed items should always be added.
        end
    end

    logStr = logStr .. string.format(" Total Weight: %0d ||", totalChance);

    local totalRolls = tonumber(lootData.MaxRolls);
    if not totalRolls or totalRolls < 1 then totalRolls = 1 end;

    logStr = logStr .. string.format(" Total Rolls: %0d ||", totalRolls);

    local iteratedChance = 0;
    local hasRolledSuccessfully = false;

    for rollNum = 1, totalRolls do
        table.sort(possibleItems, sortOnChance);

        totalChance = LootTicket_ServerManager.GetWeightedChance(possibleItems);
        iteratedChance = randInstance:random(0, totalChance);

        hasRolledSuccessfully = false;
        local indexToRemove = nil;

        logStr = logStr .. string.format(" [Current Roll: %0d, Random Number Picked: %0d]", rollNum, iteratedChance);

        for possibleIndex, possibleItem in ipairs(possibleItems) do
            logStr = logStr .. string.format("      >>> %0d - %s", possibleIndex, possibleItem.item.Name);
            
            if not hasRolledSuccessfully then
                iteratedChance = iteratedChance - possibleItem.item.Chance;
                logStr = logStr .. string.format("> IvC %0d,%0d", iteratedChance, possibleItem.item.Chance);

                if iteratedChance <= 0 then

                    logStr = logStr .. string.format(" ADDED]");
                    hasRolledSuccessfully = true;
                    table.insert(itemsToGive, possibleItem);

                    if not lootData.AllowDuplicates then
                        indexToRemove = possibleIndex;
                        logStr = logStr .. string.format("  NO DUP, REMOVE");
                    end
                
                else
                    logStr = logStr .. string.format(" NOT HIT]");
                end
            else
                logStr = logStr .. "[already rolled, skip this item]";
            end
        end

        if indexToRemove and tonumber(indexToRemove) then
            table.remove(possibleItems, indexToRemove);
        end
    end

    writeLog("LootTicket", logStr);
    print(logStr);

    local rewardStr = "[REWARD] Giving player " .. player:getUsername() .. " the following items: ";
    for _, item in ipairs(itemsToGive) do
        player:sendObjectChange('addItemOfType', { type = item.item.Name, count = tonumber(item.item.Quantity) });

        local templateItem = InventoryItemFactory.CreateItem(item.item.Name);
        if templateItem then
            if instanceof(templateItem, "HandWeapon") and templateItem:isRanged() then
                local magazine = templateItem:getMagazineType();
                if magazine then
                    player:sendObjectChange('addItemOfType', { type = magazine, count = tonumber(item.item.Quantity) });
                end
            end
        end
        rewardStr = rewardStr .. item.item.Name .. " [count: " .. item.item.Quantity .. "] |";
    end

    player:sendObjectChange('removeItemID', { id = ticket:getID(), type = ticket:getFullType() });

    writeLog("LogLine_LootTicket", rewardStr);
    print(rewardStr);

    sendServerCommand(player, "LootTicket", "ReceiveRollResults", { success = true, ticket = ticket, rewards = itemsToGive });
end

function LootTicket_ServerManager.OnClientCommand(module, command, player, args)

    if module ~= "LootTicket" then return end;

    if command == "RequestRoll" then
        if not args.ticket then
            print("LootTicket_ServerManager - RequestRoll called with no ticket provided.");
            return;
        end

        if not args.lootData then
            print("LootTicket_ServerManager - RequestRoll called with no loot ticket data provided.");
            return;
        end

        if not args.lootData.Items then
            print("LootTicket_ServerManager - no items in ticket.");
            return;
        end

        LootTicket_ServerManager.PerformTicketRoll(player, args.ticket, args.lootData);
    end

end

Events.OnClientCommand.Add(LootTicket_ServerManager.OnClientCommand);

return LootTicket_ServerManager;