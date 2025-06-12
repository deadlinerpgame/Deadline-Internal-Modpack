
require "HuntLineDeer_Util"
--server
if isClient() then return; end

local Commands = {};
Commands.HuntLineDeer = {};

Commands.HuntLineDeer.isDeerAnimal = function(player, args)
    local playerId = player:getOnlineID();
    sendServerCommand('HuntLineDeer', 'isDeerAnimal', {id = playerId, isDeerAnimal = args.isDeerAnimal,AnimSpeed = args.AnimSpeed,   zedID = args.zedID})
end

Commands.HuntLineDeer.setAnimSpeed = function(player, args)
    local playerId = player:getOnlineID();
    sendServerCommand('HuntLineDeer', 'setAnimSpeed', {id = playerId, AnimSpeed = args.AnimSpeed,  zedID = args.zedID})
end

Commands.HuntLineDeer.KnockDown = function(player, args)
    local playerId = player:getOnlineID();
    sendServerCommand('HuntLineDeer', 'KnockDown', {id = playerId, zedID = args.zedID})
end

Commands.HuntLineDeer.Injury = function(player, args)
    local playerId = player:getOnlineID();
    sendServerCommand('HuntLineDeer', 'Injury', {id = playerId, targID = args.targID})
end


Commands.HuntLineDeer.doDespawn = function(player, args)
    local zed = HuntLineDeer.findzedID(tonumber(args.zedID))
    if zed then
        zed:removeFromWorld();
        zed:removeFromSquare();
    end
end


Commands.HuntLineDeer.doSpawn = function(player, args)
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
