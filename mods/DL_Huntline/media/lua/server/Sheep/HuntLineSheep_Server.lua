
require "HuntLineSheep_Util"
--server
if isClient() then return; end

local Commands = {};
Commands.HuntLineSheep = {};

Commands.HuntLineSheep.isSheepAnimal = function(player, args)
    local playerId = player:getOnlineID();
    sendServerCommand('HuntLineSheep', 'isSheepAnimal', {id = playerId, isSheepAnimal = args.isSheepAnimal,AnimSpeed = args.AnimSpeed,   zedID = args.zedID})
end

Commands.HuntLineSheep.setAnimSpeed = function(player, args)
    local playerId = player:getOnlineID();
    sendServerCommand('HuntLineSheep', 'setAnimSpeed', {id = playerId, AnimSpeed = args.AnimSpeed,  zedID = args.zedID})
end

Commands.HuntLineSheep.KnockDown = function(player, args)
    local playerId = player:getOnlineID();
    sendServerCommand('HuntLineSheep', 'KnockDown', {id = playerId, zedID = args.zedID})
end

Commands.HuntLineSheep.Injury = function(player, args)
    local playerId = player:getOnlineID();
    sendServerCommand('HuntLineSheep', 'Injury', {id = playerId, targID = args.targID})
end


Commands.HuntLineSheep.doDespawn = function(player, args)
    local zed = HuntLineSheep.findzedID(tonumber(args.zedID))
    if zed then
        zed:removeFromWorld();
        zed:removeFromSquare();
    end
end


Commands.HuntLineSheep.doSpawn = function(player, args)
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
