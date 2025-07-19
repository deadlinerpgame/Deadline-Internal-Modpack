local DeadlineDiceClientCommands = {}

function DeadlineDiceClientCommands.requestSendMessage(args)
    sendServerCommand('DeadlineDice', 'doSendMessage', args)
end

function DeadlineDiceClientCommands.requestSendInitiativeData(args)
    sendServerCommand('DeadlineDice', 'doSendInitiativeData', args)
end

DeadlineDiceClientCommands.OnClientCommand = function(module, command, playerObj, args)
    if module == 'DeadlineDice' then
        DeadlineDiceClientCommands[command](args)
    end
end

Events.OnClientCommand.Add(DeadlineDiceClientCommands.OnClientCommand)
