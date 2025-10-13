local DeadlineCorpsesClientCommands = {}

function DeadlineCorpsesClientCommands.requestDeleteCorpse(args)
    sendServerCommand('DeadlineCorpse', 'doDeleteCorpse', args)
end


DeadlineCorpsesClientCommands.OnClientCommand = function(module, command, playerObj, args)
    if module == 'DeadlineCorpse' then
        DeadlineCorpsesClientCommands[command](args)
    end
end

Events.OnClientCommand.Add(DeadlineCorpsesClientCommands.OnClientCommand)
