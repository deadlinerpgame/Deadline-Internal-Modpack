require "HuntLineSheep_Util"
HuntLineSheep = HuntLineSheep or {}

local Commands = {};
Commands.HuntLineSheep = {};

-----------------------            ---------------------------


local SheepStressSounds = { "Sheep_Stress_1", "Sheep_Stress_2", "Sheep_Stress_3", "Sheep_Stress_4", "Sheep_Stress_5", "Sheep_Stress_6", "Sheep_Stress_7", }

function isAnySheepStressSoundPlaying(zed)
    local emitter = zed:getEmitter()
    for _, sound in ipairs(SheepStressSounds) do
        if emitter:isPlaying(sound) then
            return true
        end
    end
    return false
end

function HuntLineSheep.removeSheepOutfit(zed)
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

Events.OnZombieUpdate.Add(HuntLineSheep.removeSheepOutfit)


function HuntLineSheep.coreFunc(zed)
    if not zed then return end
    if zed:isReanimatedPlayer() then
        if zed:getVariableBoolean('isSheepAnimal')  then
            zed:setVariable('isSheepAnimal', 'false')
        end
        if HuntLineSheep.isHasTag(zed) then
            HuntLineSheep.removeTag(zed)
        end
        return
    end

    local isSheepAnimal = HuntLineSheep.isSheepAnimal(zed)
    local isSheepAnimalVar = zed:getVariableBoolean('isSheepAnimal')
    --zed:addLineChatElement(tostring(round(zed:getHealth())))
    if not zed:isCrawling() then
        zed:getModData()['SheepAnimal_Init'] = nil

    end
    local init = zed:getModData()['SheepAnimal_Init']
    if not init then
        HuntLineSheep.setStats(zed)

        

    end
    if (isSheepAnimalVar and not isSheepAnimal ) or  (isSheepAnimal and not isSheepAnimalVar)  then
        zed:setVariable('isSheepAnimal', isSheepAnimal)
        zed:setHealth(30)
        zed:setForwardDirection(ZombRand(-1, 1), ZombRand(-1, 1))
    end


    if HuntLineSheep.isSheepAnimal(zed) then
            pl = getPlayer()


            if (zed:getHealth() == 30) then
                local forwardVector = zed:getForwardDirection()
                local startx = tostring(forwardVector.X)
                local starty = tostring(forwardVector.Y)

                if HuntLineSheep.checkDist(pl, zed) <= 2 then
                    zed:setUseless(false)
                elseif HuntLineSheep.checkDist(pl, zed) > 3 and HuntLineSheep.checkDist(pl, zed) < 40 then
                    local number = ZombRand(0, 1000)
                    if not isAnySheepStressSoundPlaying(zed) then
                        if number == 1 then
                            HuntLineSheep.playSFX(zed, HuntLineSheep.getSheepStress())
                        end
                    end
                    zed:setUseless(true)
                    HuntLineSheep.moveZombieAway(zed, pl, ZombRand(5,10))      
                    zed:setTarget(nil)
                    zed:setUseless(false)                   
                end
            elseif (zed:getHealth() >= 15) then
                if HuntLineSheep.checkDist(pl, zed) <= 4 then
                    zed:setUseless(false)
                elseif HuntLineSheep.checkDist(pl, zed) > 4 and HuntLineSheep.checkDist(pl, zed) < 50 then
                    local number = ZombRand(0, 450)
                    if not isAnySheepStressSoundPlaying(zed) then
                        if number == 1 then
                            HuntLineSheep.playSFX(zed, HuntLineSheep.getSheepStress())
                        end
                    end
                    zed:setUseless(true)
                    HuntLineSheep.moveZombieAway(zed, pl, ZombRand(5,10))      
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
            
        if HuntLineSheep.isDataSender(zed)  then
            local AnimSpeed = HuntLineSheep.getAnimSpeed(zed)
            zed:setVariable('AnimSpeed', AnimSpeed);
            if isClient() then
                sendClientCommand('HuntLineSheep', 'isSheepAnimal', {isSheepAnimal = true, AnimSpeed = HuntLineSheep.getAnimSpeed(zed), zedID = zed:getOnlineID()})
            end
        end
    end

end
Events.OnZombieUpdate.Remove(HuntLineSheep.coreFunc)
Events.OnZombieUpdate.Add(HuntLineSheep.coreFunc)

function HuntLineSheep.moveZombieAway(zombie, player, distance)
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
    HuntLineSheep.moveToXYZ(zombie, newX, newY, 0)
end

function HuntLineSheep.InjuryRoll(pl)
	return HuntLineSheep.doRoll(5)
end

function caldistance(zombie,player)
    return (math.abs(zombie:getX()-player:getX())^2 + math.abs(zombie:getY()-player:getY())^2)^0.5
end

Commands.HuntLineSheep.isSheepAnimal = function(args)
    local source = getPlayer();
    local player = getPlayerByOnlineID(args.id)
    local zedID = args.zedID
    if type(zedID) == 'string' then zedID = tonumber(zedID) end
    local zed = HuntLineSheep.findzedID(zedID)
    if zed ~= nil then
		if source ~= player then
			if args.isSheepAnimal == 'true' then
				zed:setVariable('isSheepAnimal', 'true');
				if args.AnimSpeed then
                    zed:setVariable('AnimSpeed', args.AnimSpeed);
				end
			else
				zed:setVariable('isSheepAnimal', 'false');
			end
		end
    end
end

Commands.HuntLineSheep.KnockDown = function(args)
    local source = getPlayer();
    local player = getPlayerByOnlineID(args.id)
    local zedID = args.zedID
    if type(zedID) == 'string' then zedID = tonumber(zedID) end
    local zed = HuntLineSheep.findzedID(zedID)
	if source ~= player then
		if zed ~= nil then
			zed:setKnockedDown(true)
		end
	end
end

-----------------------            ---------------------------


Commands.HuntLineSheep.Injury = function(args)
    local source = getPlayer();
   --local player = getPlayerByOnlineID(args.id)
	local targ = getPlayerByOnlineID(args.targID)
    if source ~= targ then
		HuntLineSheep.doInjury(targ)
    end
end




Events.OnServerCommand.Add(function(module, command, args)
	if Commands[module] and Commands[module][command] then
		Commands[module][command](args)
	end
end)
