local DeadlineHorseClientCommands = {}

function DeadlineHorseClientCommands.RequestSyncHorseData(args)
    sendServerCommand('DeadlineHorse', 'DoSyncHorseData', args)
end


DeadlineHorseClientCommands.OnClientCommand = function(module, command, playerObj, args)
    if module == 'DeadlineHorse' then
        DeadlineHorseClientCommands[command](args)
    end
end

Events.OnClientCommand.Add(DeadlineHorseClientCommands.OnClientCommand)
