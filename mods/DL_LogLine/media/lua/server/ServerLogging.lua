if isClient() and not isDebugEnabled() then return end;

LogLineServer = {};

function LogLineServer.OnClientCommand(module, command, player, args)
    if module ~= "LogLine" then return end;

    if command == "LogClient" then
        if not args then return end;

        local prefix = args.prefix;
        local msg = args.message;

        writeLog("LogLine_" .. prefix, msg);
    end
    
end

Events.OnClientCommand.Add(LogLineServer.OnClientCommand);