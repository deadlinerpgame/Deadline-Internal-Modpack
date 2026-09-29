HuntLineRabbit = HuntLineRabbit or {}


function HuntLineRabbit.getVarHP(zed)
	return 12
end

function HuntLineRabbit.hitZed(zed, pl, part, wpn)

	if not HuntLineRabbit.isRabbitAnimal(zed) then return end


		zed:setVariable("HitReaction", "Rabbit_HitReaction")

		local varHP = HuntLineRabbit.getVarHP(zed)
		local healthDmg = 1 / varHP
		zed:setHealth(zed:getHealth()-healthDmg)


	HuntLineRabbit.playSFX(zed, HuntLineRabbit.getRabbitPain())




	if isDebugEnabled() then
		--zed:addLineChatElement(tostring(zed:getPlayerAttackPosition()))
		--zed:addLineChatElement(tostring(round(zed:getHealth())))
	end

	if zed:getHealth() >= 15 then
		zed:setUseless(true)
		HuntLineRabbit.moveZombieAway(zed, pl, 20)               
		zed:setTarget(nil)
		zed:setUseless(false)


	end
end



Events.OnHitZombie.Remove(HuntLineRabbit.hitZed)
Events.OnHitZombie.Add(HuntLineRabbit.hitZed)



function HuntLineRabbit.getRandPart(pl)
	return pl:getBodyDamage():getBodyPart(BodyPartType.FromIndex(ZombRand(BodyPartType.ToIndex(BodyPartType.MAX))));
end


function HuntLineRabbit.doPain(pl)
	local part = HuntLineRabbit.getPart(pl)
	local ZedPain = part:getAdditionalPain()
	if ZedPain > 0 then
		local max = 101-ZedPain
		local roll = ZedPain + ZombRand(1, max)
		part:setAdditionalPain(roll)
	else
		part:setAdditionalPain(ZombRand(1, 101))
	end
end


function HuntLineRabbit.getPart(pl)
	local bdDmg = pl:getBodyDamage()
	local parts = {
		[1]=bdDmg:getBodyPart(BodyPartType.Groin),
		[2]=bdDmg:getBodyPart(BodyPartType.LowerLeg_L),
		[3]=bdDmg:getBodyPart(BodyPartType.LowerLeg_R),
		[4]=bdDmg:getBodyPart(BodyPartType.UpperLeg_L),
		[5]=bdDmg:getBodyPart(BodyPartType.UpperLeg_R),
		[6]=bdDmg:getBodyPart(BodyPartType.Torso_Lower),
	}
	return parts[ZombRand(1,7)]
end


function HuntLineRabbit.InjuryRoll(pl)
	return HuntLineRabbit.doRoll(55)
end

function HuntLineRabbit.doDmg(pl)
	local part = HuntLineRabbit.getPart(pl)
	part:AddDamage(ZombRand(10, 35))

end



function HuntLineRabbit.doInjury(targ)
	if instanceof(targ, "IsoPlayer") then
		local part = HuntLineRabbit.getRandPart(targ)
		if HuntLineRabbit.doRoll(50) then
			local dmgTime = part:getCutTime()
			if dmgTime > 0 then
				local max = 101-dmgTime
				local roll = dmgTime + ZombRand(1, max)
				part:setCutTime(roll)
			end
			part:setCut(true);
		else
			local dmgTime = part:getScratchTime()
			if dmgTime > 0 then
				local max = 101-dmgTime
				local roll = dmgTime + ZombRand(1, max)
				part:setScratchTime(roll)
			end
			part:setScratched(true, false);
		end
	end
end



function HuntLineRabbit.attackOutput(pl)
	if HuntLineRabbit.doRoll(50) then
		HuntLineRabbit.doDmg(pl)
	else
		HuntLineRabbit.doPain(pl)
	end
end

function HuntLineRabbit.hit(zed, pl, wpn, HP)
	if not zed then return end



	if not instanceof(zed, 'IsoZombie') then return end
	if HuntLineRabbit.isRabbitAnimal(zed) and pl == getPlayer() then
		if HuntLineRabbit.isMaxPanic() then
			HuntLineRabbit.doDrop(pl)
		end
		if zed:isCriticalHit() then
			if HuntLineRabbit.InjuryRoll(pl) then
				HuntLineRabbit.doInjury(pl)
			end
		end
		HuntLineRabbit.attackOutput(pl)
		if HuntLineRabbit.isAnimalRabbit(zed) then  HuntLineRabbit.setRadiateSq(pl) end
	end

end
Events.OnWeaponHitCharacter.Remove(HuntLineRabbit.hit)
Events.OnWeaponHitCharacter.Add(HuntLineRabbit.hit)
