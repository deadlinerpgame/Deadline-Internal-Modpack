if isClient() then return end; -- Otherwise this will throw errors with getOnlinePlayers().

SoundQOL_Server = {};

function SoundQOL_Server.GetPlayersInRange(range, pos)
    if not range then return nil end;
    if not pos then return nil end;

    local allPlayers = getOnlinePlayers();
    if not allPlayers then return nil end;

    local returnList = {};

    for i = 0, allPlayers:size() - 1 do
        local player = allPlayers:get(i);

        local playerPos = { x = player:getX(), y = player:getY(), z = player:getZ() };

        -- As we are not using the Z position, this is just triangle maths.

        local dX = playerPos.x - pos.x;
        local dY = playerPos.y - pos.y;

        local distance = math.sqrt(dX * dX + dY * dY);

        print ("Player " .. player:getUsername() .. " is " .. tostring(distance) .. " distance.");

        if distance <= range then
            table.insert(returnList, player);
        end
    end

    return returnList;
end

function SoundQOL_Server.OnClientCommand(module, command, player, args)
    if module ~= "PatchLine" then return end;

    if command == "PlaySoundEx" then
        if not player:getAccessLevel() == "Admin" then return end;

        if not args.range then return end;
        if not args.soundStr then return end;
        if not args.showMsg then args.showMsg = 1 end;
        if not args.pos then args.pos = { x = player:getX(), y = player:getY(), z = player:getZ() } end;
        if not args.looped then args.looped = 0 return end;
        
        local playersInRange = SoundQOL_Server.GetPlayersInRange(args.range, args.pos);
        if not playersInRange or #playersInRange == 0 then
            sendServerCommand(player, "PatchLine", "PlaySoundEx_NoPlayers", {});
            return
        end

        local logStr = string.format("/playsoundex %0d %0d %s by %s (looped: %s)", tonumber(args.showMsg), tonumber(args.range), args.soundStr, player:getUsername(), tostring(args.looped));
        writeLog("LogLine_SoundQOL", logStr);
        print(logStr);

        for i, v in ipairs(playersInRange) do
            local iteratedPlayer = playersInRange[i];
            print("Playing for player " .. iteratedPlayer:getUsername());
            if iteratedPlayer then
                sendServerCommand(iteratedPlayer, "PatchLine", "PlaySoundEx_PlayInRange", { sound = args.soundStr, showMsg = args.showMsg, looped = args.looped });
            end
        end
    end

    if command == "StopSoundEx" then
        if not player:getAccessLevel() == "Admin" then return end;

        if not args.range then return end;
        if not args.pos then args.pos = { x = player:getX(), y = player:getY(), z = player:getZ() } end;

        local playersInRange = SoundQOL_Server.GetPlayersInRange(args.range, args.pos);
        if not playersInRange or #playersInRange == 0 then
            sendServerCommand(player, "PatchLine", "StopSoundEx_NoPlayers", {});
            return
        end

        for i, v in ipairs(playersInRange) do
            local iteratedPlayer = playersInRange[i];
            if iteratedPlayer then
                sendServerCommand(iteratedPlayer, "PatchLine", "StopSoundEx_StopInRange", {});
            end
        end
    end
end

Events.OnClientCommand.Add(SoundQOL_Server.OnClientCommand);

return SoundQOL_Server;