local DeadlineDiceServerCommands = {}
DeadlineDice = DeadlineDice or {}

function DeadlineDiceServerCommands.doSendMessage(args)
    local sourcePlayer = getPlayerByOnlineID(args.sourcePlayerID)
    if not sourcePlayer then return end
    local character = getPlayer()

    if sourcePlayer == character then return end

    sourcePlayer:addLineChatElement(args.message, 1, 1, 1, UIFont.Dialogue, 10, "default",
        true, true, true, true, true, true)

    local localCoords =
    {
        x = character:getX(),
        y = character:getY(),
        z = character:getZ()
    }
    local playerName = sourcePlayer:getDescriptor():getForename() or sourcePlayer:getUsername()

    local range
    if args.mode == "loud" then
        range = 30
    elseif args.mode == "quiet" then
        range = 10
    end

    if DeadlineDice.areCoordinatesWithinRange(args.coords, localCoords, range) then
        DeadlineDice.addLineInChat(playerName .. ": " .. args.message)
    end
end

function DeadlineDiceServerCommands.doSendInitiativeData(args)
    if not ISDeadlineDiceUI.instance then return end

    local sourcePlayer = getPlayerByOnlineID(args.sourcePlayerID)
    local character = getPlayer()

    local localCoords =
    {
        x = character:getX(),
        y = character:getY(),
        z = character:getZ()
    }
    local playerName = sourcePlayer:getDescriptor():getForename() or sourcePlayer:getUsername()

    local range
    if args.mode == "loud" then
        range = 30
    elseif args.mode == "quiet" then
        range = 10
    end

    if DeadlineDice.areCoordinatesWithinRange(args.coords, localCoords, range) then
        ISDeadlineDiceUI.instance:addOrUpdateInitiative(args.name, args.value)
    end
end

local function OnServerCommand(module, command, args)
    if module == 'DeadlineDice' then
        DeadlineDiceServerCommands[command](args)
    end
end

Events.OnServerCommand.Add(OnServerCommand)
