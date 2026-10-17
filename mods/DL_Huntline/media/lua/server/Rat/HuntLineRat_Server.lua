
require "HuntLineRat_Util"
--server
if isClient() then return; end

local Commands = {};
Commands.HuntLineRat = {};

Commands.HuntLineRat.isRatAnimal = function(player, args)
    local playerId = player:getOnlineID();
    sendServerCommand('HuntLineRat', 'isRatAnimal', {id = playerId, isRatAnimal = args.isRatAnimal,AnimSpeed = args.AnimSpeed,   zedID = args.zedID})
end

Commands.HuntLineRat.setAnimSpeed = function(player, args)
    local playerId = player:getOnlineID();
    sendServerCommand('HuntLineRat', 'setAnimSpeed', {id = playerId, AnimSpeed = args.AnimSpeed,  zedID = args.zedID})
end

Commands.HuntLineRat.KnockDown = function(player, args)
    local playerId = player:getOnlineID();
    sendServerCommand('HuntLineRat', 'KnockDown', {id = playerId, zedID = args.zedID})
end

Commands.HuntLineRat.Injury = function(player, args)
    local playerId = player:getOnlineID();
    sendServerCommand('HuntLineRat', 'Injury', {id = playerId, targID = args.targID})
end


Commands.HuntLineRat.doDespawn = function(player, args)
    local zed = HuntLineRat.findzedID(tonumber(args.zedID))
    if zed then
        zed:removeFromWorld();
        zed:removeFromSquare();
    end
end

Commands.HuntLineRat.doDespawnCorpse = function(player, args)
    local corpse = args.corpse
    print("Despawn 2")
    if corpse then
        corpse:removeFromWorld();
        corpse:getSquare():removeCorpse(corpse, true);
        corpse:removeFromSquare();
        print("Despawn 3")
    end
end




Commands.HuntLineRat.doSpawn = function(player, args)
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
