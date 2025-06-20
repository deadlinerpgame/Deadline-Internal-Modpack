if isServer() then return end;

--[[
        Dependencies
--]]

require "WL_Utils";

WRC = WRC or {};
WRC.Meta = WRC.Meta or {};

--[[
        QueueLine Main
--]]

QueueLine_Client = {};

QueueLine_Client.Functions = 
{
    AddLanguage = WRC.Meta.AddLanguageTo,
    RemoveLanguage = WRC.Meta.RemoveLanguageFrom,
};



function QueueLine_Client.OnCreatePlayer(playerNum, player)
    print("[QueueLine] Querying queue for any pending items.");
    sendClientCommand(getPlayer(), "QueueLine", "OnConnectQuery", { username = getPlayer():getUsername(), timestamp = getTimestampMs() });
end

function QueueLine_Client.OnServerCommand(module, command, args)
    if module ~= "QueueLine" then return end;

    if command ~= "ConnectionReceiveItems" then return end;

    if not args then return end;

    if not args.items then return end;

    print("[QueueLine] [ConnectionReceiveItems] For items: " .. tostring(#args.items));
    for i, v in ipairs(args.items) do
        local item = args.items[i];

        if item and item.type and item.username then
            if item.username == getPlayer():getUsername() then

                -- Check the function is valid
                if not QueueLine_Client.Functions[item.type] then
                    print("[QueueLine_Client] Queue type called but does not have client function - " .. tostring(item.type));
                    return;
                end

                print("[QueueLine] Calling function for type " .. tostring(item.type) .. " with args:");
                print(table.unpack(item.params));

                QueueLine_Client.Functions[item.type](table.unpack(item.params));
            end
        end
    end
end

function QueueLine_Client.DEBUG_AddLanguage(language)
    if not isDebugEnabled() then return end;

    sendClientCommand(getPlayer(), "QueueLine", "AddLanguage", { username = getPlayer():getUsername(), language = language });
end

function QueueLine_Client.DEBUG_RequestQueue()
    if not isDebugEnabled() then return end;

    sendClientCommand(getPlayer(), "QueueLine", "OnConnectQuery", { username = getPlayer():getUsername(), timestamp = getTimestampMs() });
end

Events.OnCreatePlayer.Add(QueueLine_Client.OnCreatePlayer);
Events.OnServerCommand.Add(QueueLine_Client.OnServerCommand);

return QueueLine_Client;