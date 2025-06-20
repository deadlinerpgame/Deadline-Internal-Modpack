if isServer() then return end;

--[[
        Dependencies
--]]

WRC = WRC or {};
WRC.Meta = WRC.Meta or {};

WRC.SpecialCommands["/queuelang"] = {
    handler = "QueueLanguage",
    tabHandlers = {},
    usage = "/queuelang [username] [lang (e.g. en, es)]",
    help = "Adds a language to the offline action queue to be given to the username specified on their next connection.",
    adminOnly = true,
}

function WRC.Commands.QueueLanguage(args)
    local params = WRC.SplitString(args);

    if #params ~= 2 then
        WL_Utils.addErrorToChat("Invalid format. /queuelang [username] [language]");
        return
    end

    local username, lang = params[1], params[2];
    print("USERNAME: " .. username);
    print("LANG: " .. lang);

    if username == "" or lang == "" then
        WL_Utils.addErrorToChat("Invalid format. /queuelang [username] [language]");
        return
    end

    if not WRC.Languages[lang] then
        WL_Utils.addErrorToChat("Invalid language. Give the language code, e.g. 'es', 'pl', 'en', etc");
        return
    end

    sendClientCommand(getPlayer(), "QueueLine", "AddLanguage", { username = username, language = lang });
    local queuedStr = string.format("[QueueLine] Added language %s to the queue for player %s on their next connection.", lang, username);
    WL_Utils.addInfoToChat(queuedStr);
end
--[[
        QueueLine Main
--]]

QueueLine_Client = {};

QueueLine_Client.Functions = 
{
    ADD_LANGUAGE = WRC.Meta.AddLanguageTo,
    REMOVE_LANGUAGE = WRC.Meta.RemoveLanguageFrom,
};

QueueLine_Client.QueueQueriedThisConnect = false;

function QueueLine_Client.OnServerCommand(module, command, args)
    if module ~= "QueueLine" then return end;

    if command ~= "ConnectionReceiveItems" then return end;

    if not args then return end;

    if not args.items then return end;

    print("[QueueLine] [ConnectionReceiveItems] For no. items: " .. tostring(#args.items));
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
                for i, v in ipairs(item.params) do
                    print(tostring(i) .. ": " .. tostring(v));
                end

                -- If the function for the queue item is called successfully, then remove it from queue
                local status, error = pcall(QueueLine_Client.Functions[item.type](unpack(item.params)))

                if status then
                    print("[QueueLine_Client] Queue item redeemed successfully.");
                    sendClientCommand(getPlayer(), "QueueLine", "RemoveOnSuccess", { id = item.id });
                else    
                    print("[QueueLine_Client] An error occurred executing your queue item with code: " .. tostring(code));
                    sendClientCommand(getPlayer(), "QueueLine", "QueueItemFailed", { id = item.id });
                end
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

    sendClientCommand(getPlayer(), "QueueLine", "OnConnectQuery", { username = getPlayer():getUsername() });
end

function QueueLine_Client.EveryOneMinute()
    if not QueueLine_Client.QueueQueriedThisConnect or QueueLine_Client.QueueQueriedThisConnect == false then
        print("[QueueLine] Querying queue for any pending items.");
        sendClientCommand(getPlayer(), "QueueLine", "OnConnectQuery", { username = getPlayer():getUsername() });
        QueueLine_Client.QueueQueriedThisConnect = false;
        Events.EveryOneMinute.Remove(QueueLine_Client.EveryOneMinute);
    end
end

Events.EveryOneMinute.Add(QueueLine_Client.EveryOneMinute);
Events.OnServerCommand.Add(QueueLine_Client.OnServerCommand);

return QueueLine_Client;