local function RemoveGlass_OnClientCommand(module, command, player, args)
    if module ~= "ISRemoveGlassPatch" then return end;

    if command ~= "RemoveGlassFromBodyPart" then return end;

    if not args.target then return end;
    if not args.bodyPart then return end;

    print("[ISRemoveGlassPatch] RemoveGlassFromBodyPart called for target " .. args.target:getUsername() .. " body part: " .. tostring(args.bodyPart:getType()));
    sendServerCommand(args.target, "ISRemoveGlassPatch", "RemoveGlassFromBodyPart", args.bodyPart);
end

Events.OnClientCommand.Add(RemoveGlass_OnClientCommand);