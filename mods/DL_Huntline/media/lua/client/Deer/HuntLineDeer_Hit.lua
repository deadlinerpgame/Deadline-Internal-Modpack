HuntLineDeer = HuntLineDeer or {}


function HuntLineDeer.getVarHP(zed)
	return 12
end

function HuntLineDeer.hitZed(zed, pl, part, wpn)

	if not HuntLineDeer.isDeerAnimal(zed) then return end


		zed:setVariable("HitReaction", "Deer_HitReaction")

		local varHP = HuntLineDeer.getVarHP(zed)
		local healthDmg = 1 / varHP
		zed:setHealth(zed:getHealth()-healthDmg)


	HuntLineDeer.playSFX(zed, HuntLineDeer.getDeerPain())




	if isDebugEnabled() then
		--zed:addLineChatElement(tostring(zed:getPlayerAttackPosition()))
		--zed:addLineChatElement(tostring(round(zed:getHealth())))
	end

	if zed:getHealth() >= 15 then
		zed:setUseless(true)
		HuntLineDeer.moveZombieAway(zed, pl, 20)               
		zed:setTarget(nil)
		zed:setUseless(false)


	end
end



Events.OnHitZombie.Remove(HuntLineDeer.hitZed)
Events.OnHitZombie.Add(HuntLineDeer.hitZed)



function HuntLineDeer.getRandPart(pl)
	return pl:getBodyDamage():getBodyPart(BodyPartType.FromIndex(ZombRand(BodyPartType.ToIndex(BodyPartType.MAX))));
end


function HuntLineDeer.doPain(pl)
	local part = HuntLineDeer.getPart(pl)
	local ZedPain = part:getAdditionalPain()
	if ZedPain > 0 then
		local max = 101-ZedPain
		local roll = ZedPain + ZombRand(1, max)
		part:setAdditionalPain(roll)
	else
		part:setAdditionalPain(ZombRand(1, 101))
	end
end


function HuntLineDeer.getPart(pl)
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


function HuntLineDeer.InjuryRoll(pl)
	return HuntLineDeer.doRoll(55)
end

function HuntLineDeer.doDmg(pl)
	local part = HuntLineDeer.getPart(pl)
	part:AddDamage(ZombRand(10, 35))

end



function HuntLineDeer.doInjury(targ)
	if instanceof(targ, "IsoPlayer") then
		local part = HuntLineDeer.getRandPart(targ)
		if HuntLineDeer.doRoll(50) then
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



function HuntLineDeer.attackOutput(pl)
	if HuntLineDeer.doRoll(50) then
		HuntLineDeer.doDmg(pl)
	else
		HuntLineDeer.doPain(pl)
	end
end

function HuntLineDeer.hit(zed, pl, wpn, HP)
	if not zed then return end



	if not instanceof(zed, 'IsoZombie') then return end
	if HuntLineDeer.isDeerAnimal(zed) and pl == getPlayer() then
		if HuntLineDeer.isMaxPanic() then
			HuntLineDeer.doDrop(pl)
		end
		if zed:isCriticalHit() then
			if HuntLineDeer.InjuryRoll(pl) then
				HuntLineDeer.doInjury(pl)
			end
		end
		HuntLineDeer.attackOutput(pl)
		if HuntLineDeer.isAnimalDeer(zed) then  HuntLineDeer.setRadiateSq(pl) end
	end

end
Events.OnWeaponHitCharacter.Remove(HuntLineDeer.hit)
Events.OnWeaponHitCharacter.Add(HuntLineDeer.hit)
