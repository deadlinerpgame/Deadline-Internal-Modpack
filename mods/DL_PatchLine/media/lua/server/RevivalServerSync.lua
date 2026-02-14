local function OnClientCommand(module, command, player, args)
    if module ~= "RevivePatch" then return end;

    if command == "RequestReviveSync" then
        local target = args.target;
        if not target then return end;
    end

end
Events.OnClientCommand.Add(OnClientCommand);