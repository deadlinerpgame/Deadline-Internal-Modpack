if isClient() and not isServer() then return end;

LootTicket_ServerManager = {};

local randInstance = newrandom();

LootTicket_Templates = {};

function LootTicket_ServerManager.OnInitGlobalModData(newGame)
    LootTicket_Templates = ModData.getOrCreate("LootTicket_Templates");
end

Events.OnInitGlobalModData.Add(LootTicket_ServerManager.OnInitGlobalModData);


function LootTicket_ServerManager.PerformTicketRoll(player, ticket, lootData)

    if not player then
        print("LootTicket_ServerManager.PerformTicketRoll - invalid target username provided, cannot find player.");
        return;
    end

    local itemsToGive = {};

    local totalChance = 0;
    local logStr = "[OPENING LOOT TICKET] Player: " .. player:getUsername() .. " || ID: " .. tostring(lootData.ID) ..  " || ";

    for _, itemData in ipairs(lootData.Items) do
        local chance = tonumber(itemData.item.Chance);
        itemData.item.hasRolledThisTurn = false;
        if chance < 100 then
            totalChance = totalChance + chance;
        else
            table.insert(itemsToGive, itemData);
        end
    end

    logStr = logStr .. string.format(" || Total Weight: %0d ", totalChance);

    local totalRolls = tonumber(lootData.MaxRolls);
    if not totalRolls or totalRolls < 1 then totalRolls = 1 end;

    logStr = logStr .. string.format(" || Total Rolls: %0d ", totalRolls);

    for rollNum = 1, totalRolls do
        randInstance:seed(getTimestampMs());
        local iteratedChance = randInstance:random(0, totalChance);
        local hasRolledSuccessfully = false;

        logStr = logStr .. string.format(" || Current Roll: %0d, Random Number Picked: %0d >", rollNum, iteratedChance);

        for _, rollItem in ipairs(lootData.Items) do
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

function LootTicket_ServerManager.SaveTicketAsTemplate(player, name, lootData)
    if not name then
        print("LootTicket_ServerManager - attempted to save ticket as template with no template name passed.");
        return;
    end

    local ticketPath = string.format("Deadline/LootTickets/LootTicketTemplate_%s.txt", name);
    local templateWriter = getFileWriter(ticketPath, true, false);

    templateWriter:writeln("MAXROLLS:" .. tostring(lootData.MaxRolls) .. "|ALLOWDUPLICATES:" .. (lootData.AllowDuplicates and "1" or "0"));

    for i, item in ipairs(lootData.Items) do
        templateWriter:writeln(string.format("%s|%0d|%0d", item.item.Name, item.item.Quantity, item.item.Chance));
    end
    --[[
        modData.LootTicket = {};
    modData.LootTicket.ID = randInstance:random(999,999999);
    modData.LootTicket.CreatedBy = getPlayer():getUsername();
    modData.LootTicket.CreatedTimestamp = getTimestamp();
    modData.LootTicket.Items = self.datas.items;
    modData.LootTicket.RestrictedTo = nil;
    modData.LootTicket.MaxRolls = tonumber(self.maxRolledItems:getText());
    modData.LootTicket.AllowDuplicates = self.allowDuplicateItems;
    --]]

    templateWriter:close();

    table.insert(LootTicket_Templates, name);
    ModData.add("LootTicket_Templates", LootTicket_Templates);
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

    if command == "RequestSaveTemplate" then
        if not args.name then
            print("LootTicket_ServerManager - RequestSaveTemplate called with no name.");
            return;
        end

        if not args.lootData then
            print("LootTicket_ServerManager - RequestSaveTemplate called with no loot data.");
        end

        LootTicket_ServerManager.SaveTicketAsTemplate(player, args.name, args.lootData);
    end

    if command == "RequestTicketTemplates" then
        -- Get all loot ticket templates.

        sendServerCommand(player, "LootTicket", "ReceiveTicketTemplates", { templates = LootTicket_Templates });
    end

end

Events.OnClientCommand.Add(LootTicket_ServerManager.OnClientCommand);


return LootTicket_ServerManager;