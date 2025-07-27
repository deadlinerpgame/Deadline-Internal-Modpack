HuntLineSheep = HuntLineSheep or {}


function HuntLineSheep.getVarHP(zed)
	return 12
end

function HuntLineSheep.hitZed(zed, pl, part, wpn)

	if not HuntLineSheep.isSheepAnimal(zed) then return end


		zed:setVariable("HitReaction", "Sheep_HitReaction")

		local varHP = HuntLineSheep.getVarHP(zed)
		local healthDmg = 1 / varHP
		zed:setHealth(zed:getHealth()-healthDmg)


	HuntLineSheep.playSFX(zed, HuntLineSheep.getSheepPain())




	if isDebugEnabled() then
		--zed:addLineChatElement(tostring(zed:getPlayerAttackPosition()))
		--zed:addLineChatElement(tostring(round(zed:getHealth())))
	end

	if zed:getHealth() >= 15 then
		zed:setUseless(true)
		HuntLineSheep.moveZombieAway(zed, pl, 20)               
		zed:setTarget(nil)
		zed:setUseless(false)


	end
end



Events.OnHitZombie.Remove(HuntLineSheep.hitZed)
Events.OnHitZombie.Add(HuntLineSheep.hitZed)



function HuntLineSheep.getRandPart(pl)
	return pl:getBodyDamage():getBodyPart(BodyPartType.FromIndex(ZombRand(BodyPartType.ToIndex(BodyPartType.MAX))));
end


function HuntLineSheep.doPain(pl)
	local part = HuntLineSheep.getPart(pl)
	local ZedPain = part:getAdditionalPain()
	if ZedPain > 0 then
		local max = 101-ZedPain
		local roll = ZedPain + ZombRand(1, max)
		part:setAdditionalPain(roll)
	else
		part:setAdditionalPain(ZombRand(1, 101))
	end
end


function HuntLineSheep.getPart(pl)
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


function HuntLineSheep.InjuryRoll(pl)
	return HuntLineSheep.doRoll(55)
end

function HuntLineSheep.doDmg(pl)
	local part = HuntLineSheep.getPart(pl)
	part:AddDamage(ZombRand(10, 35))

end



function HuntLineSheep.doInjury(targ)
	if instanceof(targ, "IsoPlayer") then
		local part = HuntLineSheep.getRandPart(targ)
		if HuntLineSheep.doRoll(50) then
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



function HuntLineSheep.attackOutput(pl)
	if HuntLineSheep.doRoll(50) then
		HuntLineSheep.doDmg(pl)
	else
		HuntLineSheep.doPain(pl)
	end
end

function HuntLineSheep.hit(zed, pl, wpn, HP)
	if not zed then return end



	if not instanceof(zed, 'IsoZombie') then return end
	if HuntLineSheep.isSheepAnimal(zed) and pl == getPlayer() then
		if HuntLineSheep.isMaxPanic() then
			HuntLineSheep.doDrop(pl)
		end
		if zed:isCriticalHit() then
			if HuntLineSheep.InjuryRoll(pl) then
				HuntLineSheep.doInjury(pl)
			end
		end
		HuntLineSheep.attackOutput(pl)
		if HuntLineSheep.isAnimalSheep(zed) then  HuntLineSheep.setRadiateSq(pl) end
	end

end
Events.OnWeaponHitCharacter.Remove(HuntLineSheep.hit)
Events.OnWeaponHitCharacter.Add(HuntLineSheep.hit)
