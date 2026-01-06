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

    if command == "RollbackInventoryLog" then
        if not args.username then args.username = player:getUsername() end;
        if not args.event then args.event = "INVALID_EVENT" end;
        if not args.pos then args.pos = "INVALID_POS" end;
        if not args.inventory then args.inventory = "INVALID_INVENTORY" end;

        local logStr = string.format("%s - [%s] %s >> %s", args.username, args.event, args.pos, args.inventory);
        writeLog("LogLine_RollbackTracking", logStr);
    end
    
end


Events.OnClientCommand.Add(LogLineServer.OnClientCommand);