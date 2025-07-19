if isClient() then return end;

local function OnClientCommand(module, command, player, args)
    if module ~= "PatchLine" then return end;

    if command == "QuitChecker" then
        local msgString = string.format("[%s] %s has clicked exit from ESC menu", args.time, player:getUsername());
        writeLog("Disconnections", msgString);
    end
end

Events.OnClientCommand.Add(OnClientCommand);