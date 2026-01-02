if isClient() then return end;

require "Logs/ISLogSystem";

--[[
        QueueLine Tables
--]]

QueueLine_Server = {};

QueueLine_Server.ItemTypes = 
{
    ADD_LANGUAGE = "ADD_LANGUAGE",
    REMOVE_LANGUAGE = "REMOVE_LANGUAGE",
    ADD_TRAIT = "ADD_TRAIT",
    ADD_ITEM = "ADD_ITEM",
    REMOVE_ITEM = {},
    SHOW_NOTIFICATION = {}
}

QueueLine_Server.QueueItems = {};

--[[
        FUNCTIONS   
--]]

function QueueLine_Server.PrettyPrintParams(itemParams)
    if not itemParams then return "" end;

    local formattedStr = "";

    for k, v in pairs(itemParams) do
        local param = itemParams[k];
        
        if param then
            formattedStr = formattedStr .. string.format("| %s: %s", tostring(k), tostring(v));
        end
    end

    return formattedStr;
end


function QueueLine_Server.GetQueueItemsForUsername(username)
    if not username then return end;

    local returnList = {};

    for i, v in ipairs(QueueLine_Server.QueueItems) do
        local item = QueueLine_Server.QueueItems[i];
        if item then
            if string.lower(item.username) == string.lower(username) then
                if item.activateTime and item.activateTime <= getTimestamp() then
                    table.insert(returnList, item);
                elseif not item.activateTime or item.activateTime == 0 then
                    table.insert(returnList, item);
                end
                
            end
        end
    end

    return returnList;
end

function QueueLine_Server.GetItemFromId(id)
    if not id then return end;

    for i, v in ipairs(QueueLine_Server.QueueItems) do
       
        local item = QueueLine_Server.QueueItems[i];
        if item and item.id == id  then
            return item;
        end
    end
    
    return nil;
end

function QueueLine_Server.RemoveItemFromQueue(id)
    if not id then return end;

    for i, v in ipairs(QueueLine_Server.QueueItems) do
        local item = QueueLine_Server.QueueItems[i];
        if item and item.id == id then
            table.remove(QueueLine_Server.QueueItems, i);
            print("[QueueLine_Server] Removed queue item " .. tostring(i) .. " with ID " .. tostring(id));
        end
    end

    QueueLine_Server.SaveQueue();
end

function QueueLine_Server.OnClientCommand(module, command, player, args)
    if module ~= "QueueLine" then return end;

    if command == "OnConnectQuery" then
        if not args then return end;
        if not args.username then return end;

        print("[QueueLine_Server] [OnConnectQuery] Querying queue for player " .. tostring(args.username) .. ".");
        local queueItems = QueueLine_Server.GetQueueItemsForUsername(args.username);

        local countStr = string.format("[QueueLine_Server] [OnConnectQuery] Received %0d queue items for player %s.", #queueItems, args.username);
        print(countStr);

        local allPlayers = getOnlinePlayers();
        local matchingPlayer = nil;
        for i = 0, allPlayers:size() - 1 do
            local onlinePlayer = allPlayers:get(i);
            if onlinePlayer and onlinePlayer:getUsername() == args.username then
                matchingPlayer = onlinePlayer;
            end
        end

        if not matchingPlayer then
            local noPlayerStr = string.format("[QueueLine_Server] [OnConnectQuery] Player %s has requested OnConnectQuery but no player by that username is retrievable.", player:getUsername());
            print(noPlayerStr);
            return;
        end

        sendServerCommand(matchingPlayer, "QueueLine", "ConnectionReceiveItems", { items = queueItems });
    end

    if command == "AddLanguage" then
        if not args then return end;
        if not args.username or not args.language then return end;

        if player:getAccessLevel() ~= "Admin" then return end;

        QueueLine_Server.AddLanguageItem(args.username, args.language);
    end

    if command == "AddItem" then
        if not args then return end;
        if not args.username or not args.item or not args.quantity then return end;

        if player:getAccessLevel() ~= "Admin" then return end;

        QueueLine_Server.AddItem(args.username, args.item, args.quantity);
    end

    if command == "AddTrait" then
        if not args then return end;
        if not args.trait then return end;

        if player:getAccessLevel() ~= "Admin" then 
            print("[QueueLine_Server] Player " .. player:getUsername() .. " has called AddTrait but they are not an admin - their access level is " .. player:getAccessLevel());
            return;
        end;

        QueueLine_Server.AddTraitItem(args.username, args.trait, args.timestamp);
    end


    if command == "AddTimedTrait" then
        if not args then return end;
        if not args.trait then return end;
        if not args.timestamp then return end;

        if player:getAccessLevel() ~= "Admin" then return end;
    end
    
    if command == "RemoveOnSuccess" then
        if not args then return end;
        if not args.id then return end;

        QueueLine_Server.RemoveItemFromQueue(args.id);
    end 

    if command == "QueueItemFailed" then
        if not args then return end;
        if not args.id then return end;
        if not args.error then args.error = "QueueItemFailedNoErrorMsg" end;

        local item = QueueLine_Server.GetItemFromId(args.id);
        if not item then
            print("[QueueLine_Server] [QueueItemFailed] Queue item failed for username " .. args.username .. " but no queue item retrieved for ID: " .. (args.id or "INVALID_ID"));
        end
        local errorStr = string.format("[QueueLine_Server] [QueueItemFailed] Player %s redeem type %s failed with error: %s", args.username, item.type, args.error);
        print(errorStr);
    end
end

function QueueLine_Server.OnInitGlobalModData(newGame)
    QueueLine_Server.QueueItems = ModData.getOrCreate("QueueLine_CurrentQueue");
    print("[QueueLine_Server] Queue Items initialised with " .. tostring(#QueueLine_Server.QueueItems) .. " items.");

    for i, v in ipairs(QueueLine_Server.QueueItems) do
        local queueItemStr = string.format("[QueueLine_Server] Queue item %0d - username: %s - type: %s - activate time: %s || Params: %s", i, v.username, v.type, v.activateTime or "next connect", QueueLine_Server.PrettyPrintParams(v.params));
        print(queueItemStr);
    end

end

function QueueLine_Server.SaveQueue()
    print("[QueueLine_Server] Saving queue.");
    if not QueueLine_Server.QueueItems then
        QueueLine_Server.QueueItems = {};
    end

    ModData.add("QueueLine_Queue", QueueLine_Server.QueueItems);
    ModData.transmit("QueueLine_Queue");

    for i, v in ipairs(QueueLine_Server.QueueItems) do
        local queueItemStr = string.format("[QueueLine_Server] Queue item %0d - username: %s - type: %s - activate time: %s || Params: %s", i, v.username, v.type, v.activateTime or "next connect", QueueLine_Server.PrettyPrintParams(v.params));
        print(queueItemStr);
    end

    print("[QueueLine_Server] Queue saved.");
end


function QueueLine_Server.AddLanguageItem(targetUsername, newLanguage)
    if not targetUsername or not newLanguage then
        print("[QueueLine_Server] AddLanguageItem - no username or language passed.");
        return;
    end

    local addLangStr = string.format("[QueueLine_Server] Add Language for player %s with language %s", targetUsername, newLanguage);
    print(addLangStr);

    local item = 
    {
        id = tostring(getTimestampMs()) .. "|" .. targetUsername,
        username = targetUsername,
        type = QueueLine_Server.ItemTypes.ADD_LANGUAGE,
        params =
        {
            [1] = targetUsername,
            [2] = newLanguage
        },
    };

    table.insert(QueueLine_Server.QueueItems, item);
    QueueLine_Server.SaveQueue();
end

function QueueLine_Server.AddTraitItem(targetUsername, trait, timestamp)
    if not targetUsername or not trait then
        print("[QueueLine_Server] AddTraitItem - no username or trait passed.");
        return;
    end

    local addTraitStr = string.format("[QueueLine_Server] Add Trait for player %s with language %s", targetUsername, trait);
    if timestamp then
        addTraitStr = addTraitStr .. string.format(" with start time as %s", timestamp);
    end
    print(addTraitStr);

    local item = 
    {
        id = tostring(getTimestampMs()) .. "|" .. targetUsername,
        username = targetUsername,
        type = QueueLine_Server.ItemTypes.ADD_TRAIT,
        params =
        {
            [1] = targetUsername,
            [2] = trait,
        },
        activateTime = timestamp or 0
    };

    table.insert(QueueLine_Server.QueueItems, item);
    QueueLine_Server.SaveQueue();
end

function QueueLine_Server.AddItem(targetUsername, item, quantity)
    if not targetUsername or not item or not quantity then
        print("[QueueLine_Server] AddItem - invalid params passed, either no username, item or quantity.");
        return;
    end

    local logStr = string.format("[QueueLine_Server] Add item %s (quantity: %0d) for player %s.", item, quantity, targetUsername);
    print(logStr);

    local item = 
    {
        id = tostring(getTimestampMs()) .. "|" .. targetUsername,
        username = targetUsername,
        type = QueueLine_Server.ItemTypes.ADD_ITEM,
        params =
        {
            [1] = targetUsername,
            [2] = item,
            [3] = quantity
        },
    };

    table.insert(QueueLine_Server.QueueItems, item);
    QueueLine_Server.SaveQueue();
end

Events.OnClientCommand.Add(QueueLine_Server.OnClientCommand);
Events.OnInitGlobalModData.Add(QueueLine_Server.OnInitGlobalModData);

return QueueLine_Server;