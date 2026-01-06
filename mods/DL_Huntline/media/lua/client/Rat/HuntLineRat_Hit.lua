HuntLineRat = HuntLineRat or {}


function HuntLineRat.getVarHP(zed)
	return 1
end

function HuntLineRat.hitZed(zed, pl, part, wpn)

	if not HuntLineRat.isRatAnimal(zed) then return end


		zed:setVariable("HitReaction", "Rat_HitReaction")

		local varHP = HuntLineRat.getVarHP(zed)
		local healthDmg = 1 / varHP
		zed:setHealth(zed:getHealth()-healthDmg)


	HuntLineRat.playSFX(zed, HuntLineRat.getRatPain())




	if isDebugEnabled() then
		--zed:addLineChatElement(tostring(zed:getPlayerAttackPosition()))
		--zed:addLineChatElement(tostring(round(zed:getHealth())))
	end
end



Events.OnHitZombie.Remove(HuntLineRat.hitZed)
Events.OnHitZombie.Add(HuntLineRat.hitZed)



function HuntLineRat.getRandPart(pl)
	return pl:getBodyDamage():getBodyPart(BodyPartType.FromIndex(ZombRand(BodyPartType.ToIndex(BodyPartType.MAX))));
end


function HuntLineRat.doPain(pl)
	local part = HuntLineRat.getPart(pl)
	local ZedPain = part:getAdditionalPain()
	if ZedPain > 0 then
		local max = 101-ZedPain
		local roll = ZedPain + ZombRand(1, max)
		part:setAdditionalPain(roll)
	else
		part:setAdditionalPain(ZombRand(1, 101))
	end
end


function HuntLineRat.getPart(pl)
	local bdDmg = pl:getBodyDamage()
	local parts = {
		[1]=bdDmg:getBodyPart(BodyPartType.LowerLeg_L),
		[2]=bdDmg:getBodyPart(BodyPartType.LowerLeg_R),
	}
	return parts[ZombRand(1,3)]
end


function HuntLineRat.InjuryRoll(pl)
	return HuntLineRat.doRoll(55)
end

function HuntLineRat.doDmg(pl)
	local part = HuntLineRat.getPart(pl)
	part:AddDamage(ZombRand(10, 35))

end



function HuntLineRat.doInjury(targ)
	if instanceof(targ, "IsoPlayer") then
		local part = HuntLineRat.getRandPart(targ)
		if HuntLineRat.doRoll(50) then
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



function HuntLineRat.attackOutput(pl)
	if HuntLineRat.doRoll(50) then
		HuntLineRat.doDmg(pl)
	else
		HuntLineRat.doPain(pl)
	end
end

function HuntLineRat.hit(zed, pl, wpn, HP)
	if not zed then return end



	if not instanceof(zed, 'IsoZombie') then return end
	if HuntLineRat.isRatAnimal(zed) and pl == getPlayer() then
		if HuntLineRat.isMaxPanic() then
			HuntLineRat.doDrop(pl)
		end
		if zed:isCriticalHit() then
			if HuntLineRat.InjuryRoll(pl) then
				HuntLineRat.doInjury(pl)
			end
		end
		HuntLineRat.attackOutput(pl)
		if HuntLineRat.isAnimalRat(zed) then  HuntLineRat.setRadiateSq(pl) end
	end

end
Events.OnWeaponHitCharacter.Remove(HuntLineRat.hit)
Events.OnWeaponHitCharacter.Add(HuntLineRat.hit)
