
HuntLineDeer = HuntLineDeer or {}

------------------------               ---------------------------
function HuntLineDeer.doRoll(percent) if percent >= ZombRand(1, 101) then return true end return false end
-----------------------            ---------------------------


function HuntLineDeer.TempMarker(sq, isGood)
	if not sq then return end
	local r, g, b = 1,0.4,0.4
	if isGood then
		r, g, b = 0.4,0.4,1
	end
	local mark = getWorldMarkers():addGridSquareMarker("circle_center", "circle_only_highlight", sq,r,g,b, true, 0.5)
	TestMarkers.add(mark);
	timer:Simple(sec, function()
		mark:remove()
	end)
end


function HuntLineDeer.TicksSinceSeenZombie()
    local pl = getPlayer()
    return pl.TicksSinceSeenZombie >= 6000
end
function HuntLineDeer.lastSeenZombieTime()
    local pl = getPlayer()
    return pl.lastSeenZombieTime >= 6000
end
--[[
print(zed:getVariableString("AttackDidDamage"))
print(zed:getVariableString("ZombieBiteDone"))
 ]]
function HuntLineDeer.isBiteReact(pl)
	local attacker = nil
	if pl:getVariableString("HitReaction") == "Bite" then
		local time = pl:timeSinceLastStab()
		print(time)
		attacker = pl:getVariableString("getLastTargettedBy")

		return true
	end
	return false
end
--[[
print(zed:getVariableString("AttackDidDamage"))
print(zed:getVariableString("bAttack"))
 ]]


-----------------------            ---------------------------

function HuntLineDeer.setStats(zed)
    if zed then
        if zed:isReanimatedPlayer() then
            return
        end

        if HuntLineDeer.isDeerAnimal(zed) then
            print("Test2")
            if zed:getModData()['DeerAnimal_Init'] == nil then
                print("Test3")
                local sandOpt = getSandboxOptions()
                --local zSpeed = sandOpt:getOptionByName("ZombieLore.Speed"):getValue()

                local zCog = sandOpt:getOptionByName("ZombieLore.Cognition"):getValue()
                local zTough = 1
                local zStr = 1

                local zMem = 3
                local zSee = 3
                local zHear = 3

                -----------------------            ---------------------------

                --sandOpt:set("ZombieLore.Speed", 2) 		-- 1 sprinters  		2 fast shamblers  	3 shamblers 		4 random

                sandOpt:set("ZombieLore.Strength",4)  	-- 1 superhuman 		2 normal 			3 weak 				4 random
                sandOpt:set("ZombieLore.Toughness",1)	-- 1 tough 				2 normal 			3 fragile 			4 random
                sandOpt:set("ZombieLore.Cognition",1) 	-- 1 navigate + doors 	2 navigate 			3 basic navigation 	4 random

                sandOpt:set("ZombieLore.Memory",3) 		 --1 long 				2 normal 			3 short				4 none 			5 random
                sandOpt:set("ZombieLore.Sight",3) 		-- 1 eagle 				2 normal 			3 poor 				4 random
                sandOpt:set("ZombieLore.Hearing",3) 	-- 1 pinpoint 			2 normal 			3 poor 				4 random

                -----------------------            ---------------------------
      --[[           local tSpeed =  SandboxVars.HuntLineDeer.TurnSpeed or 1.5
                if tSpeed then
                    HuntLineDeer.setTurnSpeed(zed, tSpeed)
                end ]]
                -----------------------            ---------------------------
                zed:getModData()['Animal_fType'] = HuntLineDeer.getCorpseFtype(zed)
                zed:setVariable('isDeerAnimal', 'true')
                -----------------------            ---------------------------

                HuntLineDeer.setTag(zed)

                zed:makeInactive(true);
                zed:makeInactive(false);
                zed:DoZombieStats()

                --sandOpt:set("ZombieLore.Speed", zSpeed)

                sandOpt:set("ZombieLore.Cognition", zCog)
                sandOpt:set("ZombieLore.Toughness", zTough)
                sandOpt:set("ZombieLore.Strength", zStr)

                sandOpt:set("ZombieLore.Memory", zMem)
                sandOpt:set("ZombieLore.Sight", zSee)
                sandOpt:set("ZombieLore.Hearing", zHear)
                --getSandboxOptions():toLua()


                HuntLineDeer.setCrawler(zed)
                --zed:dressInPersistentOutfit()
                zed:getModData()['DeerAnimal_Init'] = true
            end

        end
    end
end
