require "HuntLinePig_Util"
HuntLinePig = HuntLinePig or {}

local Commands = {};
Commands.HuntLinePig = {};

-----------------------            ---------------------------


local PigStressSounds = { "Pig_Stress_1", "Pig_Stress_2", "Pig_Stress_3", "Pig_Stress_4", "Pig_Stress_5", "Pig_Stress_6", "Pig_Stress_7", }

function isAnyPigStressSoundPlaying(zed)
    local emitter = zed:getEmitter()
    for _, sound in ipairs(PigStressSounds) do
        if emitter:isPlaying(sound) then
            return true
        end
    end
    return false
end

function HuntLinePig.removePigOutfit(zed)
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

Events.OnZombieUpdate.Add(HuntLinePig.removePigOutfit)


function HuntLinePig.coreFunc(zed)
    if not zed then return end
    if zed:isReanimatedPlayer() then
        if zed:getVariableBoolean('isPigAnimal')  then
            zed:setVariable('isPigAnimal', 'false')
        end
        if HuntLinePig.isHasTag(zed) then
            HuntLinePig.removeTag(zed)
        end
        return
    end

    local isPigAnimal = HuntLinePig.isPigAnimal(zed)
    local isPigAnimalVar = zed:getVariableBoolean('isPigAnimal')
    --zed:addLineChatElement(tostring(round(zed:getHealth())))
    if not zed:isCrawling() then
        zed:getModData()['PigAnimal_Init'] = nil

    end
    local init = zed:getModData()['PigAnimal_Init']
    if not init then
        HuntLinePig.setStats(zed)

        

    end
    if (isPigAnimalVar and not isPigAnimal ) or  (isPigAnimal and not isPigAnimalVar)  then
        zed:setVariable('isPigAnimal', isPigAnimal)
        zed:setHealth(30)
        zed:setForwardDirection(ZombRand(-1, 1), ZombRand(-1, 1))
    end


    if HuntLinePig.isPigAnimal(zed) then
            pl = getPlayer()


            if (zed:getHealth() == 30) then
                local forwardVector = zed:getForwardDirection()
                local startx = tostring(forwardVector.X)
                local starty = tostring(forwardVector.Y)

                if HuntLinePig.checkDist(pl, zed) <= 2 then
                    zed:setUseless(false)
                elseif HuntLinePig.checkDist(pl, zed) > 3 and HuntLinePig.checkDist(pl, zed) < 40 then
                    local number = ZombRand(0, 1000)
                    if not isAnyPigStressSoundPlaying(zed) then
                        if number == 1 then
                            HuntLinePig.playSFX(zed, HuntLinePig.getPigStress())
                        end
                    end
                    zed:setUseless(true)
                    HuntLinePig.moveZombieAway(zed, pl, ZombRand(5,10))      
                    zed:setTarget(nil)
                    zed:setUseless(false)                   
                end
            elseif (zed:getHealth() >= 15) then
                if HuntLinePig.checkDist(pl, zed) <= 4 then
                    zed:setUseless(false)
                elseif HuntLinePig.checkDist(pl, zed) > 4 and HuntLinePig.checkDist(pl, zed) < 50 then
                    local number = ZombRand(0, 450)
                    if not isAnyPigStressSoundPlaying(zed) then
                        if number == 1 then
                            HuntLinePig.playSFX(zed, HuntLinePig.getPigStress())
                        end
                    end
                    zed:setUseless(true)
                    HuntLinePig.moveZombieAway(zed, pl, ZombRand(5,10))      
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
            
        if HuntLinePig.isDataSender(zed)  then
            local AnimSpeed = HuntLinePig.getAnimSpeed(zed)
            zed:setVariable('AnimSpeed', AnimSpeed);
            if isClient() then
                sendClientCommand('HuntLinePig', 'isPigAnimal', {isPigAnimal = true, AnimSpeed = HuntLinePig.getAnimSpeed(zed), zedID = zed:getOnlineID()})
            end
        end
    end

end
Events.OnZombieUpdate.Remove(HuntLinePig.coreFunc)
Events.OnZombieUpdate.Add(HuntLinePig.coreFunc)

function HuntLinePig.moveZombieAway(zombie, player, distance)
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
    HuntLinePig.moveToXYZ(zombie, newX, newY, 0)
end

function HuntLinePig.InjuryRoll(pl)
	return HuntLinePig.doRoll(5)
end

function caldistance(zombie,player)
    return (math.abs(zombie:getX()-player:getX())^2 + math.abs(zombie:getY()-player:getY())^2)^0.5
end

Commands.HuntLinePig.isPigAnimal = function(args)
    local source = getPlayer();
    local player = getPlayerByOnlineID(args.id)
    local zedID = args.zedID
    if type(zedID) == 'string' then zedID = tonumber(zedID) end
    local zed = HuntLinePig.findzedID(zedID)
    if zed ~= nil then
		if source ~= player then
			if args.isPigAnimal == 'true' then
				zed:setVariable('isPigAnimal', 'true');
				if args.AnimSpeed then
                    zed:setVariable('AnimSpeed', args.AnimSpeed);
				end
			else
				zed:setVariable('isPigAnimal', 'false');
			end
		end
    end
end

Commands.HuntLinePig.KnockDown = function(args)
    local source = getPlayer();
    local player = getPlayerByOnlineID(args.id)
    local zedID = args.zedID
    if type(zedID) == 'string' then zedID = tonumber(zedID) end
    local zed = HuntLinePig.findzedID(zedID)
	if source ~= player then
		if zed ~= nil then
			zed:setKnockedDown(true)
		end
	end
end

-----------------------            ---------------------------


Commands.HuntLinePig.Injury = function(args)
    local source = getPlayer();
   --local player = getPlayerByOnlineID(args.id)
	local targ = getPlayerByOnlineID(args.targID)
    if source ~= targ then
		HuntLinePig.doInjury(targ)
    end
end




Events.OnServerCommand.Add(function(module, command, args)
	if Commands[module] and Commands[module][command] then
		Commands[module][command](args)
	end
end)
