require "HuntLineRat_Util"
HuntLineRat = HuntLineRat or {}

local Commands = {};
Commands.HuntLineRat = {};

-----------------------            ---------------------------


local RatStressSounds = { "Rat_Stress_1", "Rat_Stress_2", "Rat_Stress_3", "Rat_Stress_4", "Rat_Stress_5", "Rat_Stress_6", "Rat_Stress_7", }

function isAnyRatStressSoundPlaying(zed)
    local emitter = zed:getEmitter()
    for _, sound in ipairs(RatStressSounds) do
        if emitter:isPlaying(sound) then
            return true
        end
    end
    return false
end

function HuntLineRat.removeRatOutfit(zed)
    if not zed then return end
    
    -- Get the outfit name
    local outfit = zed:getOutfitName()
    if outfit == "AnimalRat" then
    local wornItems = zed:getWornItems()
    if (zed:getHealth() > 0.5) then
    for i = wornItems:size() - 1, 0, -1 do
        local item = wornItems:get(i)
        local location = item:getLocation()
        
        if location ~= "Animal" then
            wornItems:remove(item)
        end
    end
	    zed:resetModel()
end
    return
end
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

Events.OnZombieUpdate.Add(HuntLineRat.removeRatOutfit)


function HuntLineRat.coreFunc(zed)
    if not zed then return end
    if zed:isReanimatedPlayer() then
        if zed:getVariableBoolean('isRatAnimal')  then
            zed:setVariable('isRatAnimal', 'false')
        end
        if HuntLineRat.isHasTag(zed) then
            HuntLineRat.removeTag(zed)
        end
        return
    end

    local isRatAnimal = HuntLineRat.isRatAnimal(zed)
    local isRatAnimalVar = zed:getVariableBoolean('isRatAnimal')
    --zed:addLineChatElement(tostring(round(zed:getHealth())))
    if not zed:isCrawling() then
        zed:getModData()['RatAnimal_Init'] = nil

    end
    local init = zed:getModData()['RatAnimal_Init']
    if not init then
        HuntLineRat.setStats(zed)

        

    end
    if (isRatAnimalVar and not isRatAnimal ) or  (isRatAnimal and not isRatAnimalVar)  then
        zed:setVariable('isRatAnimal', isRatAnimal)
        zed:setHealth(1)
        zed:setForwardDirection(ZombRand(-1, 1), ZombRand(-1, 1))
    end


    if HuntLineRat.isRatAnimal(zed) then
            pl = getPlayer()


            if (zed:getHealth() == 30) then
                local forwardVector = zed:getForwardDirection()
                local startx = tostring(forwardVector.X)
                local starty = tostring(forwardVector.Y)

                if HuntLineRat.checkDist(pl, zed) <= 2 then
                    zed:setUseless(false)
                elseif HuntLineRat.checkDist(pl, zed) > 3 and HuntLineRat.checkDist(pl, zed) < 40 then
                    local number = ZombRand(0, 1000)
                    if not isAnyRatStressSoundPlaying(zed) then
                        if number == 1 then
                            HuntLineRat.playSFX(zed, HuntLineRat.getRatStress())
                        end
                    end          
                end
            elseif (zed:getHealth() >= 15) then
                if HuntLineRat.checkDist(pl, zed) <= 4 then
                    zed:setUseless(false)
                elseif HuntLineRat.checkDist(pl, zed) > 4 and HuntLineRat.checkDist(pl, zed) < 50 then
                    local number = ZombRand(0, 450)
                    if not isAnyRatStressSoundPlaying(zed) then
                        if number == 1 then
                            HuntLineRat.playSFX(zed, HuntLineRat.getRatStress())
                        end
                    end    
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
            
        if HuntLineRat.isDataSender(zed)  then
            local AnimSpeed = HuntLineRat.getAnimSpeed(zed)
            zed:setVariable('AnimSpeed', AnimSpeed);
            if isClient() then
                sendClientCommand('HuntLineRat', 'isRatAnimal', {isRatAnimal = true, AnimSpeed = HuntLineRat.getAnimSpeed(zed), zedID = zed:getOnlineID()})
            end
        end
    end

end
Events.OnZombieUpdate.Remove(HuntLineRat.coreFunc)
Events.OnZombieUpdate.Add(HuntLineRat.coreFunc)

function HuntLineRat.moveZombieAway(zombie, player, distance)
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
    HuntLineRat.moveToXYZ(zombie, newX, newY, 0)
end

function HuntLineRat.InjuryRoll(pl)
	return HuntLineRat.doRoll(5)
end

function caldistance(zombie,player)
    return (math.abs(zombie:getX()-player:getX())^2 + math.abs(zombie:getY()-player:getY())^2)^0.5
end

Commands.HuntLineRat.isRatAnimal = function(args)
    local source = getPlayer();
    local player = getPlayerByOnlineID(args.id)
    local zedID = args.zedID
    if type(zedID) == 'string' then zedID = tonumber(zedID) end
    local zed = HuntLineRat.findzedID(zedID)
    if zed ~= nil then
		if source ~= player then
			if args.isRatAnimal == 'true' then
				zed:setVariable('isRatAnimal', 'true');
				if args.AnimSpeed then
                    zed:setVariable('AnimSpeed', args.AnimSpeed);
				end
			else
				zed:setVariable('isRatAnimal', 'false');
			end
		end
    end
end

Commands.HuntLineRat.KnockDown = function(args)
    local source = getPlayer();
    local player = getPlayerByOnlineID(args.id)
    local zedID = args.zedID
    if type(zedID) == 'string' then zedID = tonumber(zedID) end
    local zed = HuntLineRat.findzedID(zedID)
	if source ~= player then
		if zed ~= nil then
			zed:setKnockedDown(true)
		end
	end
end

-----------------------            ---------------------------


Commands.HuntLineRat.Injury = function(args)
    local source = getPlayer();
   --local player = getPlayerByOnlineID(args.id)
	local targ = getPlayerByOnlineID(args.targID)
    if source ~= targ then
		HuntLineRat.doInjury(targ)
    end
end




Events.OnServerCommand.Add(function(module, command, args)
	if Commands[module] and Commands[module][command] then
		Commands[module][command](args)
	end
end)
