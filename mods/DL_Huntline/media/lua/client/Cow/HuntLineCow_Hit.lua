HuntLineCow = HuntLineCow or {}


function HuntLineCow.getVarHP(zed)
	return 12
end

function HuntLineCow.hitZed(zed, pl, part, wpn)

	if not HuntLineCow.isCowAnimal(zed) then return end


		zed:setVariable("HitReaction", "Cow_HitReaction")

		local varHP = HuntLineCow.getVarHP(zed)
		local healthDmg = 1 / varHP
		zed:setHealth(zed:getHealth()-healthDmg)


	HuntLineCow.playSFX(zed, HuntLineCow.getCowPain())




	if isDebugEnabled() then
		--zed:addLineChatElement(tostring(zed:getPlayerAttackPosition()))
		--zed:addLineChatElement(tostring(round(zed:getHealth())))
	end

	if zed:getHealth() >= 15 then
		zed:setUseless(true)
		HuntLineCow.moveZombieAway(zed, pl, 20)               
		zed:setTarget(nil)
		zed:setUseless(false)


	end
end



Events.OnHitZombie.Remove(HuntLineCow.hitZed)
Events.OnHitZombie.Add(HuntLineCow.hitZed)



function HuntLineCow.getRandPart(pl)
	return pl:getBodyDamage():getBodyPart(BodyPartType.FromIndex(ZombRand(BodyPartType.ToIndex(BodyPartType.MAX))));
end


function HuntLineCow.doPain(pl)
	local part = HuntLineCow.getPart(pl)
	local ZedPain = part:getAdditionalPain()
	if ZedPain > 0 then
		local max = 101-ZedPain
		local roll = ZedPain + ZombRand(1, max)
		part:setAdditionalPain(roll)
	else
		part:setAdditionalPain(ZombRand(1, 101))
	end
end


function HuntLineCow.getPart(pl)
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


function HuntLineCow.InjuryRoll(pl)
	return HuntLineCow.doRoll(55)
end

function HuntLineCow.doDmg(pl)
	local part = HuntLineCow.getPart(pl)
	part:AddDamage(ZombRand(10, 35))

end



function HuntLineCow.doInjury(targ)
	if instanceof(targ, "IsoPlayer") then
		local part = HuntLineCow.getRandPart(targ)
		if HuntLineCow.doRoll(50) then
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



function HuntLineCow.attackOutput(pl)
	if HuntLineCow.doRoll(50) then
		HuntLineCow.doDmg(pl)
	else
		HuntLineCow.doPain(pl)
	end
end

function HuntLineCow.hit(zed, pl, wpn, HP)
	if not zed then return end



	if not instanceof(zed, 'IsoZombie') then return end
	if HuntLineCow.isCowAnimal(zed) and pl == getPlayer() then
		if HuntLineCow.isMaxPanic() then
			HuntLineCow.doDrop(pl)
		end
		if zed:isCriticalHit() then
			if HuntLineCow.InjuryRoll(pl) then
				HuntLineCow.doInjury(pl)
			end
		end
		HuntLineCow.attackOutput(pl)
		if HuntLineCow.isAnimalCow(zed) then  HuntLineCow.setRadiateSq(pl) end
	end

end
Events.OnWeaponHitCharacter.Remove(HuntLineCow.hit)
Events.OnWeaponHitCharacter.Add(HuntLineCow.hit)
