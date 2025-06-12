
require "HuntLinePig_Util"
--server
if isClient() then return; end

local Commands = {};
Commands.HuntLinePig = {};

Commands.HuntLinePig.isPigAnimal = function(player, args)
    local playerId = player:getOnlineID();
    sendServerCommand('HuntLinePig', 'isPigAnimal', {id = playerId, isPigAnimal = args.isPigAnimal,AnimSpeed = args.AnimSpeed,   zedID = args.zedID})
end

Commands.HuntLinePig.setAnimSpeed = function(player, args)
    local playerId = player:getOnlineID();
    sendServerCommand('HuntLinePig', 'setAnimSpeed', {id = playerId, AnimSpeed = args.AnimSpeed,  zedID = args.zedID})
end

Commands.HuntLinePig.KnockDown = function(player, args)
    local playerId = player:getOnlineID();
    sendServerCommand('HuntLinePig', 'KnockDown', {id = playerId, zedID = args.zedID})
end

Commands.HuntLinePig.Injury = function(player, args)
    local playerId = player:getOnlineID();
    sendServerCommand('HuntLinePig', 'Injury', {id = playerId, targID = args.targID})
end


Commands.HuntLinePig.doDespawn = function(player, args)
    local zed = HuntLinePig.findzedID(tonumber(args.zedID))
    if zed then
        zed:removeFromWorld();
        zed:removeFromSquare();
    end
end


Commands.HuntLinePig.doSpawn = function(player, args)
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
