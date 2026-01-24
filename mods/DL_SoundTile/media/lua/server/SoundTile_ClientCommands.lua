local DLSoundTileClientCommands = {}

function DLSoundTileClientCommands.triggerSoundTile(playerObj, args)
    if not playerObj then return end

    local soundName = args.soundName
    local range = tonumber(args.range) or 0
    local message = args.message
    local tileX = tonumber(args.tileX)
    local tileY = tonumber(args.tileY)
    local tileZ = tonumber(args.tileZ)

    if not soundName or not tileX or not tileY or tileZ == nil then return end

    local cell = getCell()
    if not cell then return end

    local sq = cell:getGridSquare(tileX, tileY, tileZ)
    if not sq then return end

    local md = sq:getModData()
    if not md or not md.ddSoundName then return end

    local players = getOnlinePlayers()
    local isMultiplayer = players and players:size() > 0

    local soundArgs = { soundName = soundName }
    if message and message ~= "" then
        soundArgs.message = message
    end

    if range == 0 then
        sendServerCommand(playerObj, "DLSoundTile", "playSound", soundArgs)
    else
        if isMultiplayer then
            for i = 0, players:size() - 1 do
                local otherPlayer = players:get(i)
                if otherPlayer then
                    local px = otherPlayer:getX()
                    local py = otherPlayer:getY()
                    local pz = otherPlayer:getZ()

                    local dx = px - tileX
                    local dy = py - tileY
                    local dist = math.sqrt(dx * dx + dy * dy)

                    if dist <= range and math.abs(pz - tileZ) <= 1 then
                        sendServerCommand(otherPlayer, "DLSoundTile", "playSound", soundArgs)
                    end
                end
            end
        else
            sendServerCommand(playerObj, "DLSoundTile", "playSound", soundArgs)
        end
    end

    md.ddSoundName = nil
    md.ddSoundRange = nil
    md.ddSoundMessage = nil

    if sq.transmitModData then
        sq:transmitModData()
    elseif sq.transmitModdata then
        sq:transmitModdata()
    end

    local who = playerObj:getDisplayName() or playerObj:getUsername() or "Unknown"
    local logText = string.format(
        "%s triggered Sound Tile at %d, %d, %d (sound: '%s', range: %d)",
        who, tileX, tileY, tileZ, soundName, range
    )
    sendServerCommand(playerObj, "DLSoundTile", "logTrigger", { logText = logText })
end

DLSoundTileClientCommands.OnClientCommand = function(module, command, playerObj, args)
    if module == 'DLSoundTile' then
        if DLSoundTileClientCommands[command] then
            DLSoundTileClientCommands[command](playerObj, args)
        end
    end
end

Events.OnClientCommand.Add(DLSoundTileClientCommands.OnClientCommand)
