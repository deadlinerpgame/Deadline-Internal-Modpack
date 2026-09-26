local lastGun = nil

local function baseType(item)
	return (item:getType():gsub("^DL", ""))
end

local function StartLight(weapon)
	if weapon:isTorchCone() == false then
		weapon:setTorchCone(true)
		weapon:setLightDistance(12)
		weapon:setLightStrength(0.7)
	end
	lastGun = weapon
end
local function StopLight(weapon)
	weapon:setTorchCone(false)
	weapon:setLightDistance(0.0)
	weapon:setLightStrength(0.0)
	lastGun = nil
end
local function GetBattery(lightAttach)
	if JFAUtil.InitModData(lightAttach) or lightAttach:getModData().JFA.Battery == nil then
		lightAttach:getModData().JFA.Battery = 1.0
	end

	return lightAttach:getModData().JFA.Battery
end
local function SetBattery(lightAttach, newBatteryLevel)
	JFAUtil.InitModData(lightAttach)
	lightAttach:getModData().JFA.Battery = newBatteryLevel
end


local function IsGunWithLight(weapon)
	if weapon and instanceof(weapon, "HandWeapon") then
		local lightAttach = weapon:getClip()
		if lightAttach and ( baseType(lightAttach) == "GunLight" or
		baseType(lightAttach) == "GunLightImprovised" ) then
			return true
		else
			return false
		end
	else
		return false
	end
end


local function WeaponLightBeam()

	local attacker	= getSpecificPlayer(0)
	local weapon	= nil

	if attacker ~= nil then
		weapon	= attacker:getPrimaryHandItem()
	end

	if lastGun and weapon ~= lastGun then
		StopLight(lastGun)
	end

	if IsGunWithLight(weapon) then
		local lightAttach = weapon:getClip()
		if attacker:isAiming() and GetBattery(lightAttach) > 0 then
			StartLight(weapon)
		else
			StopLight(weapon)
		end
	end
end

local function WeaponLightDrain()
	local attacker	= getSpecificPlayer(0)


	if lastGun ~= nil and attacker:getPrimaryHandItem() == lastGun and attacker:isAiming() and instanceof(lastGun, "HandWeapon") then
		local lightAttach = lastGun:getClip()

		if lightAttach then
			SetBattery(lightAttach, GetBattery(lightAttach) - (0.0001) )

			if GetBattery(lightAttach) < 0 then
				SetBattery(lightAttach, 0)
				StopLight(lastGun)
			end
		end
	end
end

Events.OnPlayerUpdate.Add(WeaponLightBeam)
Events.EveryOneMinute.Add(WeaponLightDrain)


function JAY_HideSling_Recipe(items, result, player, firstHand, secondHand)
	for i=0, items:size()-1 do
		JFAUtil.InitModData(result)
		result:getModData().JFA.SlingType = items:get(i):getType()
	end
end

function JAY_UnhideSling_Test_Standard(item)
	return JAY_UnhideSling_Test(item, "Sling")
end
function JAY_UnhideSling_Test_DLStandard(item)
	return JAY_UnhideSling_Test(item, "DLSling")
end
function JAY_UnhideSling_Test_Leather(item)
	return JAY_UnhideSling_Test(item, "Sling_Leather")
end
function JAY_UnhideSling_Test_Olive(item)
	return JAY_UnhideSling_Test(item, "Sling_Olive")
end
function JAY_UnhideSling_Test_Camo(item)
	return JAY_UnhideSling_Test(item, "Sling_Camo")
end

function JAY_UnhideSling_Test(item, slingType)
	if item:getModData().JFA and item:getModData().JFA.SlingType then
		return item:getModData().JFA.SlingType == slingType
	end

	return true
end


function JAY_RemoveGunLightBattery_Test(item)
	if baseType(item) == "GunLight" then
		return GetBattery(item) > 0
	end

	return true
end

function JAY_InsertGunLightBattery_Test(item)
	if item:getType() == "Battery" then
		return item:getUsedDelta() > 0;
	elseif baseType(item) == "GunLight" then
		return GetBattery(item) <= 0
	end

	return true
end


function JAY_RemoveGunLightBattery_Recipe(items, result, player, firstHand, secondHand)
	for i=0, items:size()-1 do
		if baseType(items:get(i)) == "GunLight" then
			result:setUsedDelta( GetBattery(items:get(i)) );
			SetBattery(items:get(i), 0)
		end
	end
end

function JAY_InsertGunLightBattery_Recipe(items, result, player, firstHand, secondHand)
	for i=0, items:size()-1 do
		if items:get(i):getType() == "Battery" then
			SetBattery(result, items:get(i):getUsedDelta())
		end
	end
end
