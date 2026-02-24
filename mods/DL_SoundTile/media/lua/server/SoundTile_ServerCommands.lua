local DLSoundTileServerCommands = {}

function DLSoundTileServerCommands.playSoundAndDelete(args)
    local triggerPlayer = getPlayerByOnlineID(args.triggerPlayerID)
    if not triggerPlayer then return end

    local soundName = args.soundName
    local range = tonumber(args.range) or 0
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

    if range == 0 then
        triggerPlayer:playSound(soundName)
    else
        local players = getOnlinePlayers()
        if players then
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
                        otherPlayer:playSound(soundName)
                    end
                end
            end
        else
            triggerPlayer:playSound(soundName)
        end
    end

    md.ddSoundName = nil
    md.ddSoundRange = nil

    if sq.transmitModData then
        sq:transmitModData()
    elseif sq.transmitModdata then
        sq:transmitModdata()
    end

    local who = triggerPlayer:getDisplayName() or triggerPlayer:getUsername() or "Unknown"
    print(string.format("[SoundTile] %s triggered sound '%s' at %d, %d, %d (range: %d) - tile deleted",
            who, soundName, tileX, tileY, tileZ, range))
end

local function OnServerCommand(module, command, args)
    if module == 'DLSoundTile' then
        if DLSoundTileServerCommands[command] then
            DLSoundTileServerCommands[command](args)
        end
    end
end

Events.OnServerCommand.Add(OnServerCommand)
