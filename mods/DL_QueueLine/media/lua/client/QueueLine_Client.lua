require "QueueLine_Traits";

if isServer() then return end;

--[[
        Dependencies
--]]

WRC = WRC or {};
WRC.Meta = WRC.Meta or {};
WRC.SpecialCommands = WRC.SpecialCommands or {};
WRC.Commands = WRC.Commands or {};

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

QueueLine_Traits = QueueLine_Traits or {};

QueueLine_Client.Functions = 
{
    ADD_LANGUAGE = WRC.Meta.AddLanguageTo,
    REMOVE_LANGUAGE = WRC.Meta.RemoveLanguageFrom,
    ADD_TRAIT = QueueLine_Traits.AddTrait,
    REMOVE_TRAIT = QueueLine_Traits.RemoveTrait,
};

QueueLine_Client.QueueQueriedThisConnect = false;

function QueueLine_Client.OnServerCommand(module, command, args)
    if module ~= "QueueLine" then return end;

    if command ~= "ConnectionReceiveItems" then return end;

    if not args then return end;

    if not args.items then return end;

    for i, v in ipairs(args.items) do
        local item = args.items[i];

        if item and item.type and item.username then
            if item.username == getPlayer():getUsername() then

                print("[QueueLine_Client] Received queue item " .. item.type .. " for username: " .. item.username);

                -- Check the function is valid
                if not QueueLine_Client.Functions[item.type] then
                    print("[QueueLine_Client] Type received with no function: " .. item.type);
                    return;
                end

                -- If the function for the queue item is called successfully, then remove it from queue
                local queueItemFunction = QueueLine_Client.Functions[item.type];
                local queueFuncStatus, queueFuncError = pcall(queueItemFunction, unpack(item.params));

                if queueFuncStatus and not queueFuncError then
                    print("[QueueLine_Client] Queue item redeemed successfully.");
                    sendClientCommand(getPlayer(), "QueueLine", "RemoveOnSuccess", { id = item.id });
                    QueueLine_Client.QueueQueriedThisConnect = true;
                else
                    print("[QueueLine_Client] An error occurred executing your queue item with error: " .. tostring(queueFuncError));
                    sendClientCommand(getPlayer(), "QueueLine", "QueueItemFailed", { id = item.id, error = queueFuncError });
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