local DeadlineTeleportClientCommands = {}

function DeadlineTeleportClientCommands.requestTileTeleport(args)
    sendServerCommand('DeadlineTeleport', 'doTileTeleport', args)
end


DeadlineTeleportClientCommands.OnClientCommand = function(module, command, playerObj, args)
    if module == 'DeadlineTeleport' then
        DeadlineTeleportClientCommands[command](args)

    end
end

Events.OnClientCommand.Add(DeadlineTeleportClientCommands.OnClientCommand)
