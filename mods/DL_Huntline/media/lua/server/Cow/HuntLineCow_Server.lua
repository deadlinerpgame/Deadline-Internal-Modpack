
require "HuntLineCow_Util"
--server
if isClient() then return; end

local Commands = {};
Commands.HuntLineCow = {};

Commands.HuntLineCow.isCowAnimal = function(player, args)
    local playerId = player:getOnlineID();
    sendServerCommand('HuntLineCow', 'isCowAnimal', {id = playerId, isCowAnimal = args.isCowAnimal,AnimSpeed = args.AnimSpeed,   zedID = args.zedID})
end

Commands.HuntLineCow.setAnimSpeed = function(player, args)
    local playerId = player:getOnlineID();
    sendServerCommand('HuntLineCow', 'setAnimSpeed', {id = playerId, AnimSpeed = args.AnimSpeed,  zedID = args.zedID})
end

Commands.HuntLineCow.KnockDown = function(player, args)
    local playerId = player:getOnlineID();
    sendServerCommand('HuntLineCow', 'KnockDown', {id = playerId, zedID = args.zedID})
end

Commands.HuntLineCow.Injury = function(player, args)
    local playerId = player:getOnlineID();
    sendServerCommand('HuntLineCow', 'Injury', {id = playerId, targID = args.targID})
end


Commands.HuntLineCow.doDespawn = function(player, args)
    local zed = HuntLineCow.findzedID(tonumber(args.zedID))
    if zed then
        zed:removeFromWorld();
        zed:removeFromSquare();
    end
end


Commands.HuntLineCow.doSpawn = function(player, args)
    local x, y, z, count, fit, fChance, isDown = args.x,  args.y,  args.z, args.count, args.fit, args.fChance, args.isDown
    local zed = addZombiesInOutfit(round(x), round(y), round(z), 1, tostring(fit), tonumber(fChance), isDown, false, isDown, isDown, 1.0)
    if zed then
        if isDown then
            if not zed:isOnFloor() then
                zed:knockDown(true)
            end
        end
    end
end

Events.OnClientCommand.Add(function(module, command, player, args)
	if Commands[module] and Commands[module][command] then
	    Commands[module][command](player, args)
	end
end)
