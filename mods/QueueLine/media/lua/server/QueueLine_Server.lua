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
    ADD_ITEM = {},
    REMOVE_ITEM = {},
    SHOW_NOTIFICATION = {}
}

QueueLine_Server.QueueItems = {};

--[[
        FUNCTIONS   
--]]

function QueueLine_Server.GetQueueItemsForUsername(username)
    if not QueueLine_Server.QueueItems or not username then return end;

    local returnList = {};

    for i, v in ipairs(QueueLine_Server.QueueItems) do
        local item = QueueLine_Server[i];
        if item then
            print("Checking item username against given...");
            print(item.username);
            print(item.type);
            if item.username == username then
                table.insert(returnList, item);
            end
        end
    end

    return returnList;
end

function QueueLine_Server.OnClientCommand(module, command, player, args)
    if module ~= "QueueLine" then return end;

    print("[QueueLine_Server] OnClientCommand: " .. command);

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
    
end

function QueueLine_Server.OnInitGlobalModData(newGame)
    QueueLine_Server.QueueItems = ModData.getOrCreate("QueueLine_CurrentQueue");
end

function QueueLine_Server.SaveQueue()
    print("[QueueLine_Server] Saving queue.");
    if not QueueLine_Server.QueueItems then
        QueueLine_Server.QueueItems = {};
    end

    ModData.add("QueueLine_Queue", QueueLine_Server.QueueItems);
    ModData.transmit("QueueLine_Queue");

    for i, v in ipairs(QueueLine_Server.QueueItems) do
        print("Queue item: " .. tostring(i));
        print(v.username);
        print(v.type);
    end
end


function QueueLine_Server.AddLanguageItem(targetUsername, newLanguage)
    print("[QueueLine_Server] Add Language Item for player " .. targetUsername .. " with language " .. newLanguage);
    if not username or not newLanguage then return end;

    local item = 
    {
        username = targetUsername,
        type = QueueLine_Server.ItemTypes.ADD_LANGUAGE,
        params =
        {
            username = targetUsername,
            language = newLanguage
        }
    };

    print("Item: ");
    print(tostring(item))

    --print(table.unpack(item));

    table.insert(QueueLine_Server.QueueItems, item);
    QueueLine_Server.SaveQueue();
end



Events.OnClientCommand.Add(QueueLine_Server.OnClientCommand);
Events.OnInitGlobalModData.Add(QueueLine_Server.OnInitGlobalModData);

return QueueLine_Server;
