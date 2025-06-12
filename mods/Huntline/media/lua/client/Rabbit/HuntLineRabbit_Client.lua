require "HuntLineRabbit_Util"
HuntLineRabbit = HuntLineRabbit or {}

local Commands = {};
Commands.HuntLineRabbit = {};

-----------------------            ---------------------------


local RabbitStressSounds = { "Rabbit_Stress_1", "Rabbit_Stress_2", "Rabbit_Stress_3", "Rabbit_Stress_4", "Rabbit_Stress_5", "Rabbit_Stress_6", "Rabbit_Stress_7", }

function isAnyRabbitStressSoundPlaying(zed)
    local emitter = zed:getEmitter()
    for _, sound in ipairs(RabbitStressSounds) do
        if emitter:isPlaying(sound) then
            return true
        end
    end
    return false
end

function HuntLineRabbit.removeRabbitOutfit(zed)
    if not zed then return end
    
    -- Get the outfit name
    local outfit = zed:getOutfitName()

    -- Check if it's one of the generic outfits
    if outfit == "Generic01" or outfit == "Generic02" or 
       outfit == "Generic03" or outfit == "Generic04" or outfit == "Outfit_Generic05" then

        local wornItems = zed:getWornItems()
        local inventory = zed:getInventory()
        
        for i = 0, wornItems:size() - 1 do
            local wornItem = inv:getItemByIndex(i)
            local Type = wornItem:getFullType()
            if wornItem and (string.find(Type, "Internal")) then
                print("Gottem")
                return true 
            end
        end
    end
end

Events.OnZombieUpdate.Add(HuntLineRabbit.removeRabbitOutfit)


function HuntLineRabbit.coreFunc(zed)
    if not zed then return end
    if zed:isReanimatedPlayer() then
        if zed:getVariableBoolean('isRabbitAnimal')  then
            zed:setVariable('isRabbitAnimal', 'false')
        end
        if HuntLineRabbit.isHasTag(zed) then
            HuntLineRabbit.removeTag(zed)
        end
        return
    end

    local isRabbitAnimal = HuntLineRabbit.isRabbitAnimal(zed)
    local isRabbitAnimalVar = zed:getVariableBoolean('isRabbitAnimal')
    --zed:addLineChatElement(tostring(round(zed:getHealth())))
    if not zed:isCrawling() then
        zed:getModData()['RabbitAnimal_Init'] = nil

    end
    local init = zed:getModData()['RabbitAnimal_Init']
    if not init then
        HuntLineRabbit.setStats(zed)

        

    end
    if (isRabbitAnimalVar and not isRabbitAnimal ) or  (isRabbitAnimal and not isRabbitAnimalVar)  then
        zed:setVariable('isRabbitAnimal', isRabbitAnimal)
        zed:setHealth(30)
        zed:setForwardDirection(ZombRand(-1, 1), ZombRand(-1, 1))
    end


    if HuntLineRabbit.isRabbitAnimal(zed) then
            pl = getPlayer()


            if (zed:getHealth() == 30) then
                local forwardVector = zed:getForwardDirection()
                local startx = tostring(forwardVector.X)
                local starty = tostring(forwardVector.Y)

                if HuntLineRabbit.checkDist(pl, zed) <= 2 then
                    zed:setUseless(false)
                elseif HuntLineRabbit.checkDist(pl, zed) > 3 and HuntLineRabbit.checkDist(pl, zed) < 40 then
                    local number = ZombRand(0, 1000)
                    if not isAnyRabbitStressSoundPlaying(zed) then
                        if number == 1 then
                            HuntLineRabbit.playSFX(zed, HuntLineRabbit.getRabbitStress())
                        end
                    end
                    zed:setUseless(true)
                    HuntLineRabbit.moveZombieAway(zed, pl, ZombRand(5,10))      
                    zed:setTarget(nil)
                    zed:setUseless(false)                   
                end
            elseif (zed:getHealth() >= 15) then
                if HuntLineRabbit.checkDist(pl, zed) <= 4 then
                    zed:setUseless(false)
                elseif HuntLineRabbit.checkDist(pl, zed) > 4 and HuntLineRabbit.checkDist(pl, zed) < 50 then
                    local number = ZombRand(0, 450)
                    if not isAnyRabbitStressSoundPlaying(zed) then
                        if number == 1 then
                            HuntLineRabbit.playSFX(zed, HuntLineRabbit.getRabbitStress())
                        end
                    end
                    zed:setUseless(true)
                    HuntLineRabbit.moveZombieAway(zed, pl, ZombRand(5,10))      
                    zed:setTarget(nil)
                    zed:setUseless(false)     
                else
                    zed:setUseless(true)              
                end
 --[[           else
                local modData = zed:getModData()
                    if not modData.Angry then
                        oppositeAngle = (pl:getDirectionAngle() + 180) % 360
                        if oppositeAngle > 180 then
                            oppositeAngle = oppositeAngle - 360
                        end

                        zed:setDirectionAngle(oppositeAngle)
                        if zed:getDirectionAngle() == oppositeAngle then
                            modData.Angry = true
                        end
                    end



                zed:setUseless(false)--]]
            end
            
        if HuntLineRabbit.isDataSender(zed)  then
            local AnimSpeed = HuntLineRabbit.getAnimSpeed(zed)
            zed:setVariable('AnimSpeed', AnimSpeed);
            if isClient() then
                sendClientCommand('HuntLineRabbit', 'isRabbitAnimal', {isRabbitAnimal = true, AnimSpeed = HuntLineRabbit.getAnimSpeed(zed), zedID = zed:getOnlineID()})
            end
        end
    end

end
Events.OnZombieUpdate.Remove(HuntLineRabbit.coreFunc)
Events.OnZombieUpdate.Add(HuntLineRabbit.coreFunc)

function HuntLineRabbit.moveZombieAway(zombie, player, distance)
    if not zombie or not player or not distance then return end
    -- Calculate direction vector from player to zombie
    local diffX = zombie:getX() - player:getX()
    local diffY = zombie:getY() - player:getY()

    -- Normalize the direction vector
    local magnitude = math.sqrt(diffX * diffX + diffY * diffY)
    if magnitude == 0 then
        -- If the zombie is exactly at the player's position, pick a random direction
        diffX, diffY = 1, 0
        magnitude = 1
    end

    local dirX = diffX / magnitude
    local dirY = diffY / magnitude
    --print(dirY)
    -- Calculate the new position based on the desired distance
    local newX = zombie:getX() + dirX * distance
    local newY = zombie:getY() + dirY * distance

    -- Set the zombie's path to the new location
    zombie:setTarget(nil)
    HuntLineRabbit.moveToXYZ(zombie, newX, newY, 0)
end

function HuntLineRabbit.InjuryRoll(pl)
	return HuntLineRabbit.doRoll(5)
end

function caldistance(zombie,player)
    return (math.abs(zombie:getX()-player:getX())^2 + math.abs(zombie:getY()-player:getY())^2)^0.5
end

Commands.HuntLineRabbit.isRabbitAnimal = function(args)
    local source = getPlayer();
    local player = getPlayerByOnlineID(args.id)
    local zedID = args.zedID
    if type(zedID) == 'string' then zedID = tonumber(zedID) end
    local zed = HuntLineRabbit.findzedID(zedID)
    if zed ~= nil then
		if source ~= player then
			if args.isRabbitAnimal == 'true' then
				zed:setVariable('isRabbitAnimal', 'true');
				if args.AnimSpeed then
                    zed:setVariable('AnimSpeed', args.AnimSpeed);
				end
			else
				zed:setVariable('isRabbitAnimal', 'false');
			end
		end
    end
end

Commands.HuntLineRabbit.KnockDown = function(args)
    local source = getPlayer();
    local player = getPlayerByOnlineID(args.id)
    local zedID = args.zedID
    if type(zedID) == 'string' then zedID = tonumber(zedID) end
    local zed = HuntLineRabbit.findzedID(zedID)
	if source ~= player then
		if zed ~= nil then
			zed:setKnockedDown(true)
		end
	end
end

-----------------------            ---------------------------


Commands.HuntLineRabbit.Injury = function(args)
    local source = getPlayer();
   --local player = getPlayerByOnlineID(args.id)
	local targ = getPlayerByOnlineID(args.targID)
    if source ~= targ then
		HuntLineRabbit.doInjury(targ)
    end
end




Events.OnServerCommand.Add(function(module, command, args)
	if Commands[module] and Commands[module][command] then
		Commands[module][command](args)
	end
end)
