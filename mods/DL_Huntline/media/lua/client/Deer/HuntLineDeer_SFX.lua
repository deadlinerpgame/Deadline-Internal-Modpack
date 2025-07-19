
HuntLineDeer = HuntLineDeer or {}

function HuntLineDeer.VolumeHandler(dist, range)
    if dist >= range then
        return 0
    elseif dist <= 0 then
        return 1
    else
        return 1 - (dist / range)
    end
end



function HuntLineDeer.getDeerIdle()
	return 'Deer_Idle_0'..tostring(ZombRand(1,4))
end

function HuntLineDeer.getDeerPain()
	return 'Deer_Pain_0'..tostring(ZombRand(1,5))
end

function HuntLineDeer.getDeerStress()
	return 'Deer_Stress_0'..tostring(ZombRand(1,5))
end

function HuntLineDeer.getDeerDeath()
	return 'Deer_Death_0'..tostring(ZombRand(1,5))
end


function HuntLineDeer.playSFX(zed, sfx, isAttract)
	if not HuntLineDeer.isDeerAnimal(zed) then return end
	local range = 150
	local pl = getPlayer(); if not pl then return end
	if HuntLineDeer.isClosestPl(pl, zed) or pl == zed then
		local sq = zed:getSquare()
		if sq then
			local vol = HuntLineDeer.VolumeHandler(HuntLineDeer.checkDist(pl, zed), range)
			getSoundManager():PlayWorldSound(tostring(sfx), sq, 0, 150, 1, false);
		end
	end
end



HuntLineDeer.sfxBanList = {
	--'ZombieSurprisedPlayer', 'BodyHitGround',
	'ZombieThumpMetal', 'ZombieThumpGeneric', 'BurningFlesh', 'MaleZombieCombined', 'FemaleZombieCombined',
	'ZombieFootstepsCombined', 	'ZombieThumpVehicle', 'ZombieThumpVehicleWindow', 'ZombieThumpWindow',
	'ZombieThumpBarbedFence', 'ZombieThumpGarageDoor', 'ZombieScratch', 'ZombieBite', 'ZombieCrawlLungeSwing',
	'ZombieCrawlLungeHit',  'ZombieTrip', 'TutorialZombie', 'MaleZombieIdle', 'FemaleZombieIdle',
	'MaleZombieHurt', 'FemaleZombieHurt', 'FemaleZombieAttack', 'MaleZombieDeath', 'FemaleZombieDeath',
	'FemaleBeingEatenDeath', 'FemaleHeavyBreath', 'fzombiedeath', 'MaleHeavyBreathPanic', 'MaleHeavyBreath',
	'FemaleHeavyBreathPanic', 'MaleBeingEatenDeath', 'ZombieFootstepGrass', 'ZombieFootstepWood', 'ZombieFootstepConcrete',
	'fzombierand', 'fzombierand1', 'fzombierand2', 'fzombierand3', 'fzombierand4', 'fzombierand5', 'fzombierand6',
	'fzombierand7', 'fzombierand8', 'fzombierand9', 'fzombiehit', 'fzombiehit1', 'fzombiehit2', 'fzombiehit3',
	'fzombiehit4', 'fzombiehit5', 'PZ_FemaleBeingEaten_Death', 	'PZ_FemaleZombieEating', 'PZ_Female_zombie',
	'PZ_Female_zombie_01', 'PZ_Female_zombie_02', 'PZ_Female_zombie_03', 'PZ_Female_zombie_04', 'PZ_Female_zombie_05',
	'PZ_Female_zombie_06', 'PZ_Female_zombie_07', 'PZ_Female_zombie_08', 'PZ_Female_zombie_09', 'PZ_Female_zombie_Death',
	'PZ_Female_zombie_Death_01', 'PZ_Female_zombie_Death_02', 'PZ_Female_zombie_Death_03', 'PZ_Female_zombie_Death_04',
	'PZ_MaleBeingEaten_Death', 'PZ_MaleDeath', 'PZ_MaleDeath_01', 'PZ_MaleDeath_02', 'PZ_MaleDeath_03', 'PZ_MaleDeath_04',
	'PZ_MaleDeath_05', 'PZ_MaleDeath_06', 'PZ_MaleDeath_07', 'PZ_MaleZombieEating', 'PZ_MaleZombie', 'PZ_MaleZombie_01',
	'PZ_MaleZombie_02', 'PZ_MaleZombie_03', 'PZ_MaleZombie_04', 'PZ_MaleZombie_05', 'PZ_MaleZombie_06', 'PZ_MaleZombie_07',
	'PZ_MaleZombie_08', 'zombieambient1', 'zombiebite',	'zombieeating', 'zombieImpact', 'zombierand', 'zombierand1',
	'zombierand2', 'zombierand3', 'zombierand4', 'zombierand5', 'zombierand6', 'zombierand7', 'zombierand8', 'zombierand9',
	'zombie_footstep_m', 'zombie_footstep_m_01', 'zombie_footstep_m_02', 'zombie_footstep_m_03', 'zombie_footstep_m_04',
	'zombie_footstep_m_05', 'zombie_footstep_m_06',	'zombie_footstep_m_07', 'zombie_footstep_m_08', 'zombie_footstep_m_09',
	'zombie_footstep_m_10', 'zombie_footstep_m_11', 'zombie_footstep_m_12',
	'zombie_vocal_C_aggro','zombie_vocal_B_aggro', 'zombie_vocal_A_aggro',
	'Zombie_Female_A_Aggro','Zombie_Female_B_Aggro','Zombie_Female_C_Aggro', 'zombie_vocal',
	'zombie_male_vocal_C_aggro','zombie_male_vocal_B_aggro', 'zombie_male_vocal_A_aggro',
}

function HuntLineDeer.getSFX()
	local list = HuntLineDeer.sfxZedList
	return list[ZombRand(1, #list)]
end

function HuntLineDeer.preSFX(zed)
	if not HuntLineDeer.isDeerAnimal(zed) then return end
	if zed:getEmitter() then
		local audioName = nil
		local list = HuntLineDeer.sfxBanList
		for _, audioName in ipairs(list) do
			if zed:getEmitter():isPlaying(audioName) then
				zed:getEmitter():stopSoundByName(tostring(audioName))
				getWorld():getFreeEmitter():stopSoundByName(tostring(audioName))
				if HuntLineDeer.doRoll(10) then
					--HuntLineDeer.playRandSfx(zed)
				end
			end
		end
	end
end
Events.OnZombieUpdate.Remove(HuntLineDeer.preSFX)
Events.OnZombieUpdate.Add(HuntLineDeer.preSFX)



function HuntLineDeer.playRandSfx(zed)
	if not HuntLineDeer.isDeerAnimal(zed) then return end
	if HuntLineDeer.doRoll(5) then
		local toPlay = HuntLineDeer.getSFX()
		--zed:getEmitter():playSound(toPlay)
	end
end


function HuntLineDeer.OnZombieDead(zed)
	if not HuntLineDeer.isDeerAnimal(zed) then return end
	HuntLineDeer.playSFX(zed, HuntLineDeer.getDeerDeath())
	local inventory = zed:getInventory()

	local sq = zed:getSquare()
	print("[SERVER] Dropping 'Base.Deer_Dead' at:", sq:getX(), sq:getY(), sq:getZ())
	sq:AddWorldInventoryItem("Base.Deer_Dead", ZombRand(0, 1.5), ZombRand(0, 1.5), 0)

end
Events.OnZombieDead.Remove(HuntLineDeer.OnZombieDead)
Events.OnZombieDead.Add(HuntLineDeer.OnZombieDead)
