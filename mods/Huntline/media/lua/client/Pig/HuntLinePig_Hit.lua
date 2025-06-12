HuntLinePig = HuntLinePig or {}


function HuntLinePig.getVarHP(zed)
	return 12
end

function HuntLinePig.hitZed(zed, pl, part, wpn)

	if not HuntLinePig.isPigAnimal(zed) then return end


		zed:setVariable("HitReaction", "Pig_HitReaction")

		local varHP = HuntLinePig.getVarHP(zed)
		local healthDmg = 1 / varHP
		zed:setHealth(zed:getHealth()-healthDmg)


	HuntLinePig.playSFX(zed, HuntLinePig.getPigPain())




	if isDebugEnabled() then
		--zed:addLineChatElement(tostring(zed:getPlayerAttackPosition()))
		--zed:addLineChatElement(tostring(round(zed:getHealth())))
	end

	if zed:getHealth() >= 15 then
		zed:setUseless(true)
		HuntLinePig.moveZombieAway(zed, pl, 20)               
		zed:setTarget(nil)
		zed:setUseless(false)


	end
end



Events.OnHitZombie.Remove(HuntLinePig.hitZed)
Events.OnHitZombie.Add(HuntLinePig.hitZed)



function HuntLinePig.getRandPart(pl)
	return pl:getBodyDamage():getBodyPart(BodyPartType.FromIndex(ZombRand(BodyPartType.ToIndex(BodyPartType.MAX))));
end


function HuntLinePig.doPain(pl)
	local part = HuntLinePig.getPart(pl)
	local ZedPain = part:getAdditionalPain()
	if ZedPain > 0 then
		local max = 101-ZedPain
		local roll = ZedPain + ZombRand(1, max)
		part:setAdditionalPain(roll)
	else
		part:setAdditionalPain(ZombRand(1, 101))
	end
end


function HuntLinePig.getPart(pl)
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


function HuntLinePig.InjuryRoll(pl)
	return HuntLinePig.doRoll(55)
end

function HuntLinePig.doDmg(pl)
	local part = HuntLinePig.getPart(pl)
	part:AddDamage(ZombRand(10, 35))

end



function HuntLinePig.doInjury(targ)
	if instanceof(targ, "IsoPlayer") then
		local part = HuntLinePig.getRandPart(targ)
		if HuntLinePig.doRoll(50) then
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



function HuntLinePig.attackOutput(pl)
	if HuntLinePig.doRoll(50) then
		HuntLinePig.doDmg(pl)
	else
		HuntLinePig.doPain(pl)
	end
end

function HuntLinePig.hit(zed, pl, wpn, HP)
	if not zed then return end



	if not instanceof(zed, 'IsoZombie') then return end
	if HuntLinePig.isPigAnimal(zed) and pl == getPlayer() then
		if HuntLinePig.isMaxPanic() then
			HuntLinePig.doDrop(pl)
		end
		if zed:isCriticalHit() then
			if HuntLinePig.InjuryRoll(pl) then
				HuntLinePig.doInjury(pl)
			end
		end
		HuntLinePig.attackOutput(pl)
		if HuntLinePig.isAnimalPig(zed) then  HuntLinePig.setRadiateSq(pl) end
	end

end
Events.OnWeaponHitCharacter.Remove(HuntLinePig.hit)
Events.OnWeaponHitCharacter.Add(HuntLinePig.hit)
