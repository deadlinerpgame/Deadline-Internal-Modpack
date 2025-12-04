local EFFECTIVENESS = {
  0;
  0.1;
  0.2;
  0.3;
  0.4;
  0.5;
  0.6;
  0.7;
  0.8;
  0.9;
}

local BREAKCHANCE = {
  2;
  5;
  10;
  20;
  50;
  100;
}

local CALIBER = {
  caliberBullets22 = {'SuppressorEffectiveness22';'Firearm9mmSuppressed'};
  caliberBullets9mm = {'SuppressorEffectiveness9mm';'Firearm9mmSuppressed'};
  caliberBullets45 = {'SuppressorEffectiveness45';'Firearm45Suppressed'};
  caliberBullets44 = {'SuppressorEffectiveness44';'Firearm45Suppressed'};
  caliberBullets4440 = {'SuppressorEffectiveness44';'Firearm45Suppressed'};
  caliberBullets38 = {'SuppressorEffectiveness38';'Firearm45Suppressed'};
  caliber223Bullets = {'SuppressorEffectiveness223';'FirearmARSuppressed'};
  caliber308Bullets = {'SuppressorEffectiveness308';'FirearmARSuppressed'};
  caliber556Bullets = {'SuppressorEffectiveness223';'FirearmARSuppressed'};
  caliber762x51Bullets = {'SuppressorEffectiveness308';'FirearmARSuppressed'};
  caliber762x39Bullets = {'SuppressorEffectiveness308';'FirearmARSuppressed'};
  caliberShotgunShells = {'SuppressorEffectivenessShotgunShells';'FirearmShotgunSilencerShot'};
  caliberBullets357 = {'SuppressorEffectiveness38';'Firearm45Suppressed'};
  caliberBullets3006 = {'SuppressorEffectiveness308';'FirearmARSuppressed'};
}

local SUPPRESSORTYPE = {
  type22Silencer = 1;
  type9mmSilencer = 1;
  type45Silencer = 1;
  type44Silencer = 1;
  type38Silencer = 1;
  type223Silencer = 1;
  type308Silencer = 1;
  typeShotgunSilencer = 1;
  typeImprovisedSilencer = EFFECTIVENESS[SandboxVars.Firearms.SuppressorEffectivenessImprovised];
  typeSilencer_PopBottle = EFFECTIVENESS[SandboxVars.Firearms.SuppressorEffectivenessImprovised];
}

function Firearms_Jay_silence(wielder, weapon, overridePart)

	if weapon == nil then return end
	if not weapon:IsWeapon() or not weapon:isRanged() then return; end
    local scriptItem = weapon:getScriptItem()
	local scriptItem2 = InventoryItemFactory.CreateItem(weapon:getFullType())

    local maxHitCount = scriptItem:getMaxHitCount()
    local soundVolume = scriptItem:getSoundVolume()
    local soundRadius = scriptItem:getSoundRadius()
    local maxAmmo = scriptItem2:getMaxAmmo()
	local swingSound = scriptItem:getSwingSound()

    local canon = weapon:getCanon()
	if overridePart and overridePart:getPartType() == "Canon" then
		canon = nil
	end
    local clip = weapon:getClip()
	if overridePart and overridePart:getPartType() == "Clip" then
		clip = nil
	end
    if canon then
		if getDebug() then print(canon:getType()) end
		if string.find(canon:getType(), "Silencer") and not string.find(canon:getType(), "Broken") then
			local weaponAmmo, replaced = string.gsub(weapon:getAmmoType(), "Base.", "")
			local suppressor = "type" .. canon:getType()
			local ammo = "caliber" .. weaponAmmo
			if getDebug() then
			  print("Ammo type: " .. ammo)
			  print("Suppressor Type: " .. canon:getType())
			  print("Suppressor Sound: " .. CALIBER[ammo][2])
			  print("Firearm Condition Lower Chance: " .. weapon:getConditionLowerChance())
			end
			local suppressorQualityMod = 1
			if suppressor == "typeImprovisedSilencer" or suppressor == "typeSilencer_PopBottle" then
				suppressorQualityMod = 1 - EFFECTIVENESS[SandboxVars.Firearms.SuppressorEffectivenessImprovised]
				soundVolume = soundVolume *  (1.0)
			else
				soundVolume = soundVolume *  (0.6)
			end
			local ammoType = CALIBER[ammo][1]
			local effectivnessLevel = SandboxVars.Firearms[ammoType]
			local effectivness = EFFECTIVENESS[effectivnessLevel]
			effectivness = (1 - effectivness) * suppressorQualityMod
			effectivness = 1 - effectivness
			if weapon:getWeaponReloadType() == "revolver" then
				effectivness = (1 - effectivness) * (1 - EFFECTIVENESS[SandboxVars.Firearms.SuppressorEffectivenessRevolver])
				effectivness = 1 - effectivness
			end
			if getDebug() then
				print(suppressorQualityMod)
				print("Suppressor Effectiveness: " .. (1 - effectivness)*100 .. "%")
			end
			  soundRadius = soundRadius * effectivness
			swingSound = CALIBER[ammo][2]
			
		elseif string.find(canon:getType(), "Compensator") or string.find(canon:getType(), "ChokeTubeFull") then
			soundVolume = soundVolume * 1.1
			if string.find(canon:getType(), "44Compensator") then
				soundRadius = soundRadius + 20
			else
				soundRadius = soundRadius + 10
			end
			
		elseif string.find(canon:getType(), "ChokeTubeImproved") then
			maxHitCount = maxHitCount + 1
		end
    end
			
    if clip then
		if string.find(clip:getType(), "MagTubeExtension") then
			maxAmmo = maxAmmo + 2
		end
    end
	
	local oldMaxAmmo = scriptItem2:getMaxAmmo()
	if maxAmmo < oldMaxAmmo  then
		local difference = oldMaxAmmo  - maxAmmo
		weapon:setCurrentAmmoCount(maxAmmo)
		
		for i = 1, difference, 1 do
			local inv = wielder:getInventory();
			inv:AddItem(instanceItem(weapon:getAmmoType()))
		end
	end

    weapon:setMaxHitCount(maxHitCount)
    weapon:setSoundVolume(soundVolume)
    weapon:setSoundRadius(soundRadius)
    weapon:setMaxAmmo(maxAmmo)
    weapon:setSwingSound(swingSound)
    --print("Firearm sound volume: " .. weapon:getSoundVolume())
    --print("Firearm sound radius: " .. weapon:getSoundRadius())
    --print("Firearm sound: " .. weapon:getSwingSound())
end
local silence = Firearms_Jay_silence

Events.OnEquipPrimary.Add(silence);



Events.OnGameStart.Add(function() -- make sure our player is setup on game start
	local player = getPlayer()
	silence(player, player:getPrimaryHandItem())
end)

local function initSuppressor(suppressor, defaultCondition, BreakChance)
	if JFAUtil.InitModData(suppressor) or suppressor:getModData().JFA.Condition == nil then
		suppressor:getModData().JFA.Condition = defaultCondition
		suppressor:getModData().JFA.ConditionMax = defaultCondition
		suppressor:getModData().JFA.BreakChance = BreakChance
	end
end
local function damageSuppressor(suppressor)
	suppressor:getModData().JFA.Condition = suppressor:getModData().JFA.Condition - 1
end
local function getSuppressorCondition(suppressor)
	return suppressor:getModData().JFA.Condition
end

function breakSuppressor(playerObj, weapon)
  if not SandboxVars.Firearms.SuppressorBreak then return end;
	if playerObj ~= getPlayer() then return end;
	if not playerObj or playerObj:isDead() then return end;
	if not weapon then return end;
	if not weapon:isRanged() then return end;

  local canon = weapon:getCanon()
  if canon then
	local breakChanceMulti = 1 --higher is better
	
	if weapon:getAmmoBox() == "Bullets22Box" or weapon:getAmmoBox() == "Bullets38Box" then
		breakChanceMulti = 4
	elseif weapon:getAmmoBox() == "Bullets9mmBox" or weapon:getAmmoBox() == "Bullets45Box" then
		breakChanceMulti = 2
	end
	
	--[[
	if string.find(canon:getType(), "22Silencer") then
	  breakChanceMulti = 4
	elseif string.find(canon:getType(), "9mmSilencer") or string.find(canon:getType(), "45Silencer") then
	  breakChanceMulti = 2
	end
	]]--
	
    if string.find(canon:getType(), "Broken") then
		
    elseif string.find(canon:getType(), "ImprovisedSilencer") then
		initSuppressor(canon, 8, 2)
	
		if ZombRand(BREAKCHANCE[SandboxVars.Firearms.FlashlightSuppressorBreakChance] * breakChanceMulti) == 1 then
			damageSuppressor(canon)
			if getSuppressorCondition(canon) <= 0 then
				weapon:detachWeaponPart(canon)
				local brokenSilencer = InventoryItemFactory.CreateItem('Base.BrokenImprovisedSilencer')
				weapon:attachWeaponPart(brokenSilencer)
				playerObj:resetEquippedHandsModels();
				silence(playerObj, weapon)
				playerObj:playSound("MetalPipeHit")
			end
		end
		
    elseif string.find(canon:getType(), "Silencer_PopBottle") then
		initSuppressor(canon, 4, 1)
		
		if breakChanceMulti > 1 then
			breakChanceMulti = breakChanceMulti * 2
		end
		if ZombRand(BREAKCHANCE[SandboxVars.Firearms.BottleSuppressorBreakChance] * breakChanceMulti) == 1 then
			damageSuppressor(canon)
			if getSuppressorCondition(canon) <= 0 then
				weapon:detachWeaponPart(canon)
				local brokenSilencer = InventoryItemFactory.CreateItem('Base.BrokenSilencer_PopBottle')
				weapon:attachWeaponPart(brokenSilencer)
				playerObj:resetEquippedHandsModels();
				silence(playerObj, weapon)
				playerObj:playSound("StoneHammerHit")
			end
		end
		
    elseif string.find(canon:getType(), "Silencer") then
		initSuppressor(canon, 10, 3)
		
		if ZombRand(BREAKCHANCE[SandboxVars.Firearms.FlashlightSuppressorBreakChance] * 10 * breakChanceMulti) == 1 then
			damageSuppressor(canon)
			if getSuppressorCondition(canon) <= 0 then
				weapon:detachWeaponPart(canon)
				local brokenSilencer = nil
				if canon:getType() == "ShotgunSilencer" then
					brokenSilencer = InventoryItemFactory.CreateItem('Base.BrokenShotgunSilencer')
				else
					brokenSilencer = InventoryItemFactory.CreateItem('Base.BrokenSilencer')
				end
				weapon:attachWeaponPart(brokenSilencer)
				playerObj:resetEquippedHandsModels();
				silence(playerObj, weapon)
				playerObj:playSound("MetalPipeHit")
			end
		end
    end
  end
end

--TODO: make it happen right after the swing to remove visual delay
--TODO: add silencer breaking sound
Events.OnWeaponSwingHitPoint.Add(breakSuppressor);
