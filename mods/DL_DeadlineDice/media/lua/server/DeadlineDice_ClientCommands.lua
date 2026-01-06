local DeadlineDiceClientCommands = {}

function DeadlineDiceClientCommands.requestSendMessage(args)
    sendServerCommand('DeadlineDice', 'doSendMessage', args)
end

function DeadlineDiceClientCommands.requestSendInitiativeData(args)
    sendServerCommand('DeadlineDice', 'doSendInitiativeData', args)
end

function DeadlineDiceClientCommands.ToggleMeleeMarker(args)
    sendServerCommand('DeadlineDice', 'doToggleMeleeMarker', args)
end

function DeadlineDiceClientCommands.EnableCircleMarker(args)
    sendServerCommand('DeadlineDice', 'doEnableCircleMarker', args)
end

function DeadlineDiceClientCommands.DisableStartCombat(args)
    sendServerCommand('DeadlineDice', 'doDisableStartCombat', args)
end

function DeadlineDiceClientCommands.SyncTurnOrder(args)
    sendServerCommand('DeadlineDice', 'doSyncTurnOrder', args)
end

function DeadlineDiceClientCommands.SyncTurnDuration(args)
    sendServerCommand('DeadlineDice', 'doSyncTurnDuration', args)
end

function DeadlineDiceClientCommands.FinishCombat(args)
    sendServerCommand('DeadlineDice', 'doFinishCombat', args)
end

function DeadlineDiceClientCommands.LockPlayerPosition(args)
    sendServerCommand('DeadlineDice', 'doLockPlayerPosition', args)
end

function DeadlineDiceClientCommands.SyncHP(args)
    sendServerCommand('DeadlineDice', 'doSyncHP', args)
end

function DeadlineDiceClientCommands.SyncFullInitiative(args)
    sendServerCommand("DeadlineDice", "doReceiveFullInitiative", args)
end

DeadlineDiceClientCommands.OnClientCommand = function(module, command, playerObj, args)
    if module == 'DeadlineDice' then
        DeadlineDiceClientCommands[command](args)
    end
end

Events.OnClientCommand.Add(DeadlineDiceClientCommands.OnClientCommand)
