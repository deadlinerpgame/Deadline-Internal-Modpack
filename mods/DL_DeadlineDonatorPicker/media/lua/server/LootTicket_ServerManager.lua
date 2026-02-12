if isClient() and not isServer() then return end;

LootTicket_ServerManager = {};

local randInstance = newrandom();

function LootTicket_ServerManager.PerformTicketRoll(player, ticket, lootData)

    if not player then
        print("LootTicket_ServerManager.PerformTicketRoll - invalid target username provided, cannot find player.");
        return;
    end

    print("1");
    local itemsToGive = {};

    local totalChance = 0;
    local logStr = "[OPENING LOOT TICKET] Player: " .. player:getUsername() .. " || ID: " .. tostring(lootData.ID) ..  " || ";

    print("2");

    for _, itemData in ipairs(lootData.Items) do
        local chance = tonumber(itemData.item.Chance);
        print("3 " .. tostring(chance));
        itemData.item.hasRolledThisTurn = false;
        if chance < 100 then
            totalChance = totalChance + chance;
        else
            table.insert(itemsToGive, itemData);
        end
    end

    print("4");

    logStr = logStr .. string.format(" || Total Weight: %0d ", totalChance);

    local totalRolls = tonumber(lootData.MaxRolls);
    if not totalRolls or totalRolls < 1 then totalRolls = 1 end;

    print("5");

    logStr = logStr .. string.format(" || Total Rolls: %0d ", totalRolls);

    print("6");

    for rollNum = 1, totalRolls do
        print("7 " .. tostring(rollNum));
        randInstance:seed(getTimestampMs());
        local iteratedChance = randInstance:random(0, totalChance);
        local hasRolledSuccessfully = false;

        logStr = logStr .. string.format(" || Current Roll: %0d, Random Number Picked: %0d >", rollNum, iteratedChance);

        for _, rollItem in ipairs(lootData.Items) do
            print("8 " .. tostring(rollItem.item.Name));
            logStr = logStr .. string.format(" [%s ", rollItem.item.Name);
            
            -- If the item is guaranteed, add it to the list.
            if tonumber(rollItem.item.Chance) < 100 then
                -- Make sure there's not already been an item selected for this roll (not withstanding the guaranteed ones.)
                if not hasRolledSuccessfully then

                    iteratedChance = iteratedChance - tonumber(rollItem.item.Chance);

                    logStr = logStr .. string.format("original: %0d, comp is: %0d", rollItem.item.Chance, iteratedChance);

                    if not lootData.AllowDuplicates and not rollItem.item.hasRolledThisTurn then
                        
                        if iteratedChance <= 0 then
                            logStr = logStr .. string.format(" !SUCCESS! ", iteratedChance);
                            hasRolledSuccessfully = true;
                            rollItem.item.hasRolledThisTurn = true;
                            table.insert(itemsToGive, rollItem);
                        end
                    else
                        logStr = logStr .. " !Has already rolled, no duplicates allowed ! ";
                    end
                else
                    logStr = logStr .. " skip";
                end

                logStr = logStr .. " ] ";
            end

            
        end
    end

    writeLog("LootTicket", logStr);
    print(logStr);

    logStr = "[REWARD] Giving player " .. player:getUsername() .. " the following items: ";
    for _, item in ipairs(itemsToGive) do
        player:sendObjectChange('addItemOfType', { type = item.item.Name, count = tonumber(item.item.Quantity) });
        logStr = logStr .. item.item.Name .. " [count: " .. item.item.Quantity .. "] |";
    end

    player:sendObjectChange('removeItemID', { id = ticket:getID(), type = ticket:getFullType() });

    print(logStr);
    writeLog("LootTicket", logStr);
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

        LootTicket_ServerManager.PerformTicketRoll(player, args.ticket, args.lootData);
    end

end

Events.OnClientCommand.Add(LootTicket_ServerManager.OnClientCommand);

return LootTicket_ServerManager;