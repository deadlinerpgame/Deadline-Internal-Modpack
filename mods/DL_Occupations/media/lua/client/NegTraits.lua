
local Player
local PlayerData
local BodyDamage
local Nutrition
local Stats
local SpeedControls
local GameTime
local Climate
local PerformanceSettings
local LSpawnDelay = false

local MoodleFR = false
if getActivatedMods():contains("MoodleFramework") then
	MoodleFR = true
	require "MF_ISMoodle"
	MF.createMoodle("Addict")
	MF.createMoodle("VitaminJunkie")
	MF.createMoodle("Berserk")
	MF.createMoodle("SecondWind")
	MF.createMoodle("Wanderer")
	MF.createMoodle("Homebody")
	--MF.createMoodle("Quicksilver")
	MF.createMoodle("Betrayed")
	MF.createMoodle("Codependant")
end


function GetWeaponPerkLevel(InputWeapon)
	if not InputWeapon or not InputWeapon:IsWeapon() then return -1 end
	local Player = getPlayer()
	if InputWeapon:getCategories():contains("Blunt") then
		return Player:getPerkLevel(Perks.Blunt)
	elseif InputWeapon:getCategories():contains("SmallBlunt") then
		return Player:getPerkLevel(Perks.SmallBlunt)
	elseif InputWeapon:getCategories():contains("LongBlade") then
		return Player:getPerkLevel(Perks.LongBlade)
	elseif InputWeapon:getCategories():contains("SmallBlade") then
		return Player:getPerkLevel(Perks.SmallBlade)
	elseif InputWeapon:getCategories():contains("Axe") then
		return Player:getPerkLevel(Perks.Axe)
	elseif InputWeapon:getCategories():contains("Spear") then
		return Player:getPerkLevel(Perks.Spear)
	end
	return 0 -- no valid class was detected. treating it as perk level 0.
end
function GetStrengthDamageModifier()
	local StrengthLevel = Player:getPerkLevel(Perks.Strength)
	local StrengthMod = 0.75 + (StrengthLevel*0.05)
	if StrengthLevel <= 1 then
		StrengthMod = StrengthMod * 0.6
	elseif StrengthLevel >= 9 then
		StrengthMod = StrengthMod * 1.4
	end
	return StrengthMod
end

function LFramerateModifier()
	return 1/(PerformanceSettings:getFramerate()/75)
end

local function CopyTable(Input)
	local Output = {}
	for i,v in pairs(Input) do
		Output[i] = v
	end
	return Output
end

function CalcDamageMod(Weapon)
	local Player = getPlayer()
	
	local StrengthMod = GetStrengthDamageModifier()
	
	local WeaponLevel = GetWeaponPerkLevel(Weapon)
	local WeaponMod = 0.3 + (WeaponLevel*0.1)
	
	return StrengthMod * WeaponMod
end

local HasLazoloLib = getActivatedMods():contains("LazoloLib") 

local HasInit = false
function LazoloInit()
	Player = getPlayer()
	PlayerModData = Player:getModData()
	BodyDamage = Player:getBodyDamage()
	Nutrition = Player:getNutrition()
	Stats = Player:getStats()
	SpeedControls = UIManager.getSpeedControls()
	GameTime = getGameTime()
	Climate = getClimateManager()
	PerformanceSettings = getPerformance()
	
	PlayerData = PlayerModData.LazoloTraitsData
	if not PlayerData then
		PlayerModData.LazoloTraitsData = {}
		PlayerData = PlayerModData.LazoloTraitsData
		
		-- Specific important values that need to be carried over to the new PlayerData table from the old one
		if PlayerModData.LEnduranceMaximumModifiers then -- check old table for one of the old variables before trying to recover old data when creating the new table.
			if PlayerModData.LTimeSinceLastPills then PlayerData.LTimeSinceLastPills = PlayerModData.LTimeSinceLastPills end
			if PlayerModData.LAddiction then PlayerData.LAddiction = PlayerModData.LAddiction end
			if PlayerModData.AddictRecoveryBoostTime then PlayerData.AddictRecoveryBoostTime = PlayerModData.AddictRecoveryBoostTime end
			if PlayerModData.SentimentalID then PlayerData.SentimentalID = PlayerModData.SentimentalID end
			if PlayerModData.LVitaminJunkieDuration then PlayerData.LVitaminJunkieDuration = PlayerModData.LVitaminJunkieDuration end
			if PlayerModData.LVitaminJunkieIntensity then PlayerData.LVitaminJunkieIntensity = PlayerModData.LVitaminJunkieIntensity end
			if PlayerModData.LBushmanValue then PlayerData.LBushmanValue = PlayerModData.LBushmanValue end
			if PlayerModData.TimeAlone then PlayerData.TimeAlone = PlayerModData.TimeAlone end
		end
	end
	
	
	
	if not PlayerData.EnduranceChange then
		PlayerData.EnduranceChange = 0
	end
	if not PlayerData.LEnduranceMaximumModifiers then
		if PlayerModData.LEnduranceMaximumModifiers then
			PlayerData.LEnduranceMaximumModifiers = CopyTable(PlayerModData.LEnduranceMaximumModifiers)
		else
			PlayerData.LEnduranceMaximumModifiers = {}
		end
	end
	if not PlayerData.LEnduranceGainModifiers then
		if PlayerModData.LEnduranceGainModifiers then
			PlayerData.LEnduranceGainModifiers = CopyTable(PlayerModData.LEnduranceGainModifiers)
		else
			PlayerData.LEnduranceGainModifiers = {}
		end
	end
	if not PlayerData.LEnduranceLossModifiers then
		if PlayerModData.LEnduranceLossModifiers then
			PlayerData.LEnduranceLossModifiers = CopyTable(PlayerModData.LEnduranceLossModifiers)
		else
			PlayerData.LEnduranceLossModifiers = {}
		end
	end
	
	
	if not PlayerData.FatigueChange then
		PlayerData.FatigueChange = 0
	end
	
	
	if not PlayerData.HungerChange then
		PlayerData.HungerChange = 0
	end
	
	
	if not PlayerData.ThirstChange then
		PlayerData.ThirstChange = 0
	end
	
	
	if not PlayerData.StressChange then
		PlayerData.StressChange = 0
	end
	if not PlayerData.LStressGainModifiers then
		if PlayerModData.LStressGainModifiers then
			PlayerData.LStressGainModifiers = CopyTable(PlayerModData.LStressGainModifiers)
		else
			PlayerData.LStressGainModifiers = {}
		end
	end
	if not PlayerData.LStressLossModifiers then
		if PlayerModData.LStressLossModifiers then
			PlayerData.LStressLossModifiers = CopyTable(PlayerModData.LStressLossModifiers)
		else
			PlayerData.LStressLossModifiers = {}
		end
	end
	
	
	if not PlayerData.CigStressChange then
		PlayerData.CigStressChange = 0
	end
	if not PlayerData.LCigStressGainModifiers then
		if PlayerModData.LCigStressGainModifiers then
			PlayerData.LCigStressGainModifiers = CopyTable(PlayerModData.LCigStressGainModifiers)
		else
			PlayerData.LCigStressGainModifiers = {}
		end
	end
	if not PlayerData.LCigStressLossModifiers then
		if PlayerModData.LCigStressLossModifiers then
			PlayerData.LCigStressLossModifiers = CopyTable(PlayerModData.LCigStressLossModifiers)
		else
			PlayerData.LCigStressLossModifiers = {}
		end
	end
	
	
	if not PlayerData.UnhappyChange then
		PlayerData.UnhappyChange = 0
	end
	if not PlayerData.LUnhappyGainModifiers then
		if PlayerModData.LUnhappyGainModifiers then
			PlayerData.LUnhappyGainModifiers = CopyTable(PlayerModData.LUnhappyGainModifiers)
		else
			PlayerData.LUnhappyGainModifiers = {}
		end
	end
	if not PlayerData.LUnhappyLossModifiers then
		if PlayerModData.LUnhappyLossModifiers then
			PlayerData.LUnhappyLossModifiers = CopyTable(PlayerModData.LUnhappyLossModifiers)
		else
			PlayerData.LUnhappyLossModifiers = {}
		end
	end
	
	if not PlayerData.BoredomChange then
		PlayerData.BoredomChange = 0
	end
	if not PlayerData.LBoredomGainModifiers then
		if PlayerModData.LBoredomGainModifiers then
			PlayerData.LBoredomGainModifiers = CopyTable(PlayerModData.LBoredomGainModifiers)
		else
			PlayerData.LBoredomGainModifiers = {}
		end
	end
	if not PlayerData.LBoredomLossModifiers then
		if PlayerModData.LBoredomLossModifiers then
			PlayerData.LBoredomLossModifiers = CopyTable(PlayerModData.LBoredomLossModifiers)
		else
			PlayerData.LBoredomLossModifiers = {}
		end
	end
	
	if not PlayerData.TemperatureChange then
		PlayerData.TemperatureChange = 0
	end
	if not PlayerData.LTemperatureGainModifiers then
		if PlayerModData.LTemperatureGainModifiers then
			PlayerData.LTemperatureGainModifiers = CopyTable(PlayerModData.LTemperatureGainModifiers)
		else
			PlayerData.LTemperatureGainModifiers = {}
		end
	end
	if not PlayerData.LTemperatureLossModifiers then
		if PlayerModData.LTemperatureLossModifiers then
			PlayerData.LTemperatureLossModifiers = CopyTable(PlayerModData.LTemperatureLossModifiers)
		else
			PlayerData.LTemperatureLossModifiers = {}
		end
	end
	
	
	if not PlayerData.LPanicGainModifiers then
		if PlayerModData.LPanicGainModifiers then
			PlayerData.LPanicGainModifiers = CopyTable(PlayerModData.LPanicGainModifiers)
		else
			PlayerData.LPanicGainModifiers = {}
		end
	end
	if not PlayerData.LPanicLossModifiers then
		if PlayerModData.LPanicLossModifiers then
			PlayerData.LPanicLossModifiers = CopyTable(PlayerModData.LPanicLossModifiers)
		else
			PlayerData.LPanicLossModifiers = {}
		end
	end
	
	
	local Inventory = Player:getInventory() -- any changes made to items are reverted when loaded. buut ModData is preserved. causing items to not be fixed.
	for i = 0, Inventory:getItems():size() - 1 do
		local Item = Inventory:getItems():get(i);
		if Item:getModData().LState and Item:getModData().LState ~= "Normal" then
			Item:getModData().LState = "Normal"
		end
	end
	HasInit = true
end

function LazoloCheckReInit()
	if Player ~= getPlayer() or not Player:getModData().LazoloTraitsData then -- if not Player is getPlayer() or not (Insert most recent added variable) then
		LazoloInit()
	end
end


--[[
SMPackCigarettesAdd = player:getInventory():AddItem("SM.SM" .. tostring(TypePackCigarettes));
SMPackCigarettesAdd:setUsedDelta(DeltaPack);
]]
function LazoloGiveTraitItems(player)
	if not getActivatedMods():contains("ToadTraits") or not player:HasTrait("deprived") then
		local Player = player
		local Inventory = Player:getInventory()
		if Player:HasTrait("laddict") then
			local Item
			if ZombRand(2) == 0 then
				Item = Inventory:AddItem("Base.Pills")
			else
				Item = Inventory:AddItem("Base.PillsSleepingTablets")
			end
			Item:setUsedDelta(ZombRand(4,6)/10)
			Inventory:addItemOnServer(Item)
		end
	end
end

local MinStatChange =  0.00005 
-- on an unrelated note.. why is Unhappiness and panic calculated at a 0-100 scale. but everything else is 0-1???
-- like.. ok sure.. depression is technically a "BodyDamage" stat so fine whatever. but panic?

function LazDir(Num) -- this function is deceptively useful at compacting and optimizing math heavy code.
	if not Num then return 1 end
	if Num > 0 then
		return 1
	elseif Num < 0 then
		return -1
	elseif Num == 0 then
		return 0
	end
end

local function SayQuote(List)
	local Item = List[ZombRand(#List)+1] -- wierd bug after setting up translations, sometimes the item in the list is nil?
	if Item then
		Player:Say(Item)
	elseif #List > 0 then
		SayQuote(List)
	end
end

function MakeTranslationsListInLuaTable(TranslationPrefix) -- solved the problem with translating randomized dialog with varying quantities :D
	local i = 0 -- index value
	local ReturningList = {}
	repeat i = i + 1 -- increment
		local Text = getText(TranslationPrefix..i)
		if Text ~= TranslationPrefix..i then -- getText() will return the provided translation string if it fails, we can use this to detect if a translation exists or not. we simply count until we find a non-existant value and then break the loop
			table.insert(ReturningList,Text) -- add the found strings to the list
		else
			break -- no string was found, break the loop.
		end
	until i > 100 -- failsafe to prevent a crash. since repeat will loop infinitely if it doesnt end or break. good habit to have with while and repeat loops.
	return ReturningList -- send the list back.
end

GameSpeedMultipliers = {1,5,20,40}
function GetGSMulti()
	if GameSpeedMultipliers[SpeedControls:getCurrentGameSpeed()] then
		return GameSpeedMultipliers[SpeedControls:getCurrentGameSpeed()]
	else
		return 1
	end
end

function LazoloApplyGradualStatChanges()
	if not HasInit then return end
	if PlayerData.EnduranceChange ~= 0 then
		local Abs = PlayerData.EnduranceChange*LazDir(PlayerData.EnduranceChange) -- cheeky math.abs()
		local Tweak = (MinStatChange*LazDir(PlayerData.EnduranceChange) + PlayerData.EnduranceChange*(Abs/250)) *GetGSMulti()
		-- this formula got a lot more complicated than i would have liked.. oh well :D
		--[[ without LazDir() this would have to be 2 seperate bits of code for negative and positive value changes. but with LazDir() you can do all the
		checks with positive numbers. and then use the negative numbers to do the changes with. congratulations, you learned something :)]]
		
		if Abs < MinStatChange*2*GetGSMulti() or Player:isAsleep() then
			Tweak = PlayerData.EnduranceChange
		end
		
		Stats:setEndurance(Stats:getEndurance()+Tweak)
		PlayerData.EnduranceChange = PlayerData.EnduranceChange - Tweak

	end
	
	if PlayerData.FatigueChange ~= 0 then
		local Abs = PlayerData.FatigueChange*LazDir(PlayerData.FatigueChange) 
		local Tweak = (MinStatChange*LazDir(PlayerData.FatigueChange) + PlayerData.FatigueChange*(Abs/1250))*GetGSMulti()
		
		if Abs < MinStatChange*2*GetGSMulti() or Player:isAsleep() then
			Tweak = PlayerData.FatigueChange
		end
		
		Stats:setFatigue(Stats:getFatigue()+Tweak)
		PlayerData.FatigueChange = PlayerData.FatigueChange - Tweak
	end
	
	if PlayerData.HungerChange ~= 0 then
		local Abs = PlayerData.HungerChange*LazDir(PlayerData.HungerChange)
		local Tweak = (MinStatChange*LazDir(PlayerData.HungerChange) + PlayerData.HungerChange*(Abs/500))*GetGSMulti()
		
		if Abs < MinStatChange*2*GetGSMulti() or Player:isAsleep() then
			Tweak = PlayerData.HungerChange
		end
		
		Stats:setHunger(Stats:getHunger()+Tweak)
		PlayerData.HungerChange = PlayerData.HungerChange - Tweak
		
	end
	
	if PlayerData.ThirstChange ~= 0 then
		local Abs = PlayerData.ThirstChange*LazDir(PlayerData.ThirstChange)
		local Tweak = (MinStatChange*LazDir(PlayerData.ThirstChange) + PlayerData.ThirstChange*(Abs/500))*GetGSMulti()
		
		if Abs < MinStatChange*2*GetGSMulti() or Player:isAsleep() then
			Tweak = PlayerData.ThirstChange
		end
		
		Stats:setThirst(Stats:getThirst()+Tweak)
		PlayerData.ThirstChange = PlayerData.ThirstChange - Tweak
		
	end
	
	if PlayerData.StressChange ~= 0 then
		local Abs = PlayerData.StressChange*LazDir(PlayerData.StressChange)
		local Tweak = (MinStatChange*LazDir(PlayerData.StressChange) + PlayerData.StressChange*(Abs/500))*GetGSMulti()
		
		if Abs < MinStatChange*2*GetGSMulti() or Player:isAsleep() then
			Tweak = PlayerData.StressChange
		end
		
		Stats:setStress(Stats:getStress() - Stats:getStressFromCigarettes()+Tweak)
		PlayerData.StressChange = PlayerData.StressChange - Tweak
		
	end
	
	if PlayerData.CigStressChange ~= 0 then
		local Abs = PlayerData.CigStressChange*LazDir(PlayerData.CigStressChange)
		local Tweak = (MinStatChange*LazDir(PlayerData.CigStressChange) + PlayerData.CigStressChange*(Abs/500))*GetGSMulti()
		
		if Abs < MinStatChange*2*GetGSMulti() or Player:isAsleep() then
			Tweak = PlayerData.CigStressChange
		end
		
		Stats:setStressFromCigarettes(Stats:getStressFromCigarettes()+Tweak)
		PlayerData.CigStressChange = PlayerData.CigStressChange - Tweak
		
	end
	
	if PlayerData.UnhappyChange ~= 0 then
		local Abs = PlayerData.UnhappyChange*LazDir(PlayerData.UnhappyChange) 
		local Tweak = (MinStatChange*LazDir(PlayerData.UnhappyChange) + PlayerData.UnhappyChange*(Abs/500))*GetGSMulti()
		
		if Abs < MinStatChange*2*GetGSMulti() or Player:isAsleep() then
			Tweak = PlayerData.UnhappyChange
		end
		
		BodyDamage:setUnhappynessLevel(BodyDamage:getUnhappynessLevel()+Tweak*100)
		PlayerData.UnhappyChange = PlayerData.UnhappyChange - Tweak
		
	end
	
	if PlayerData.BoredomChange ~= 0 then
		local Abs = PlayerData.BoredomChange*LazDir(PlayerData.BoredomChange)
		local Tweak = (MinStatChange*LazDir(PlayerData.BoredomChange) + PlayerData.BoredomChange*(Abs/500))*GetGSMulti()
		
		if Abs < MinStatChange*2*GetGSMulti() or Player:isAsleep() then
			Tweak = PlayerData.BoredomChange
		end
		
		BodyDamage:setBoredomLevel(BodyDamage:getBoredomLevel()+Tweak*100)
		PlayerData.BoredomChange = PlayerData.BoredomChange - Tweak
	end
	
	if PlayerData.TemperatureChange ~= 0 then
		local Abs = PlayerData.TemperatureChange*LazDir(PlayerData.TemperatureChange)
		local Tweak = (MinStatChange*LazDir(PlayerData.TemperatureChange) + PlayerData.TemperatureChange*(Abs/500))*GetGSMulti()
		
		if Abs < MinStatChange*2*GetGSMulti() or Player:isAsleep() then
			Tweak = PlayerData.TemperatureChange
		end
		
		BodyDamage:setTemperature(BodyDamage:getTemperature()+Tweak)
		PlayerData.TemperatureChange = PlayerData.TemperatureChange - Tweak
	end
end

local OldEndurance
local OldStress

function getTotalModifier(Table)
	local Mod = 1
	for i,v in pairs(Table) do
		Mod = Mod * v
	end
	return Mod
end
function StatChangeModifiers() -- this can run every tick, or every second and it will still work, its just visuals that are affected.
	if not OldEndurance then OldEndurance = Stats:getEndurance() end -- If the old endurance isnt set yet, set it to the current endurance.
	
	local EnduranceMaximum = 1 -- max value since we'll be multiplying by modifiers
	for i,v in pairs(PlayerData.LEnduranceMaximumModifiers) do -- for every value in this table, multiply the maximum endurance by its value.
		EnduranceMaximum = EnduranceMaximum * v
	end
	local NewEndurance = Stats:getEndurance() -- get the new endurance this tick
	local EnduranceDiff = NewEndurance-OldEndurance -- calculate the difference between new and old values so we can adjust it.
		
	if EnduranceMaximum < 1 and Stats:getEndurance() > EnduranceMaximum then -- if the max is reduced and we're above the max, then we need to lower it to the current max instead of doing anything else.
		if Stats:getEndurance() - EnduranceMaximum < 0.0025 then -- if we're close enough just snap to the value.
			Stats:setEndurance(EnduranceMaximum)
		else
			if NewEndurance > OldEndurance then -- Bypass any regen while lowering to the new maximum.
				NewEndurance = OldEndurance - 0.0001 
			else
				NewEndurance = NewEndurance - 0.0001
			end
			Stats:setEndurance(NewEndurance) -- set the new changes
		end
	else
		if EnduranceDiff ~= 0 then -- only run this code if there was a change in the value.
			if NewEndurance < OldEndurance then -- if the new value is less than the old one, we're using endurance.
				local TotalLossMod = getTotalModifier(PlayerData.LEnduranceLossModifiers)
				NewEndurance = OldEndurance + EnduranceDiff*TotalLossMod -- set the new value accordingly
			elseif NewEndurance > OldEndurance then -- new value is greater than old value, we're regening endurance.
				local TotalGainMod = getTotalModifier(PlayerData.LEnduranceGainModifiers)
				NewEndurance = OldEndurance + EnduranceDiff*TotalGainMod
			end
			if NewEndurance > 1 then NewEndurance = 1 end -- don't set the value to something invalid
			if NewEndurance < 0 then NewEndurance = 0 end
			Stats:setEndurance(NewEndurance) -- set the new value.
		end
	end
	
	OldEndurance = NewEndurance -- save the value for next tick.
	
	

	if not OldStress then OldStress = Stats:getStress() - Stats:getStressFromCigarettes() end
	local NewStress = Stats:getStress() - Stats:getStressFromCigarettes()
	local StressDiff = NewStress-OldStress
	if StressDiff ~= 0 then
		if NewStress < OldStress then
			local TotalLossMod = getTotalModifier(PlayerData.LStressLossModifiers)
			NewStress = OldStress + StressDiff*TotalLossMod
		elseif NewStress > OldStress then
			local TotalGainMod = getTotalModifier(PlayerData.LStressGainModifiers)
			NewStress = OldStress + StressDiff*TotalGainMod
		end
		if NewStress > 1 then NewStress = 1 end
		if NewStress < 0 then NewStress = 0 end
		Stats:setStress(NewStress)
	end
	OldStress = NewStress
	
	if not OldCigStress then OldCigStress = Stats:getStressFromCigarettes() end
	local NewCigStress = Stats:getStressFromCigarettes()
	local CigStressDiff = NewCigStress-OldCigStress
	if CigStressDiff ~= 0 then
		if NewCigStress < OldCigStress then
			local TotalLossMod = getTotalModifier(PlayerData.LCigStressLossModifiers)
			NewCigStress = OldCigStress + CigStressDiff*TotalLossMod
		elseif NewCigStress > OldCigStress then
			local TotalGainMod = getTotalModifier(PlayerData.LCigStressGainModifiers)
			NewCigStress = OldCigStress + CigStressDiff*TotalGainMod
		end
		if NewCigStress > 0.51 then NewCigStress = 0.51 end
		if NewCigStress < 0 then NewCigStress = 0 end
		Stats:setStressFromCigarettes(NewCigStress)
	end
	OldCigStress = NewCigStress
	
	
	if not OldUnhappy then OldUnhappy = BodyDamage:getUnhappynessLevel() end
	local NewUnhappy = BodyDamage:getUnhappynessLevel()
	local UnhappyDiff = NewUnhappy-OldUnhappy
	if UnhappyDiff ~= 0 then
		if NewUnhappy < OldUnhappy then
			local TotalLossMod = getTotalModifier(PlayerData.LUnhappyLossModifiers)
			NewUnhappy = OldUnhappy + UnhappyDiff*TotalLossMod
		elseif NewUnhappy > OldUnhappy then
			local TotalGainMod = getTotalModifier(PlayerData.LUnhappyGainModifiers)
			NewUnhappy = OldUnhappy + UnhappyDiff*TotalGainMod
		end
		if NewUnhappy > 100 then NewUnhappy = 100 end
		if NewUnhappy < 0 then NewUnhappy = 0 end
		BodyDamage:setUnhappynessLevel(NewUnhappy)
	end
	OldUnhappy = NewUnhappy
	
	if not OldBoredom then OldBoredom = BodyDamage:getBoredomLevel() end
	local NewBoredom = BodyDamage:getBoredomLevel()
	local BoredomDiff = NewBoredom-OldBoredom
	if BoredomDiff ~= 0 then
		if NewBoredom < OldBoredom then
			local TotalLossMod = getTotalModifier(PlayerData.LBoredomLossModifiers)
			NewBoredom = OldBoredom + BoredomDiff*TotalLossMod
		elseif NewBoredom > OldBoredom then
			local TotalGainMod = getTotalModifier(PlayerData.LBoredomGainModifiers)
			NewBoredom = OldBoredom + BoredomDiff*TotalGainMod
		end
		if NewBoredom > 100 then NewBoredom = 100 end
		if NewBoredom < 0 then NewBoredom = 0 end
		BodyDamage:setBoredomLevel(NewBoredom)
	end
	OldBoredom = NewBoredom
	
	if not OldTemperature then OldTemperature = BodyDamage:getTemperature() end
	local NewTemperature = BodyDamage:getTemperature()
	local TemperatureDiff = NewTemperature-OldTemperature
	if TemperatureDiff ~= 0 then
		if NewTemperature < OldTemperature then
			local TotalLossMod = getTotalModifier(PlayerData.LTemperatureLossModifiers)
			NewTemperature = OldTemperature + TemperatureDiff*TotalLossMod
		elseif NewTemperature > OldTemperature then
			local TotalGainMod = getTotalModifier(PlayerData.LTemperatureGainModifiers)
			NewTemperature = OldTemperature + TemperatureDiff*TotalGainMod
		end
		if NewTemperature > 100 then NewTemperature = 100 end
		if NewTemperature < 0 then NewTemperature = 0 end
		BodyDamage:setTemperature(NewTemperature)
	end
	OldTemperature = NewTemperature
	
	
	if not OldPanic then OldPanic = Stats:getPanic() end
	local NewPanic = Stats:getPanic()
	local PanicDiff = NewPanic-OldPanic
	if PanicDiff ~= 0 then
		if NewPanic < OldPanic then
			local TotalLossMod = getTotalModifier(PlayerData.LPanicLossModifiers)
			NewPanic = OldPanic + PanicDiff*TotalLossMod
		elseif NewPanic > OldPanic then
			local TotalGainMod = getTotalModifier(PlayerData.LPanicGainModifiers)
			NewPanic = OldPanic + PanicDiff*TotalGainMod
		end
		if NewPanic > 100 then NewPanic = 100 end
		if NewPanic < 0 then NewPanic = 0 end
		Stats:setPanic(NewPanic)
	end
	OldPanic = NewPanic
end

--START TRAITS

local OldCalories
local OldCarbs
local OldLips

-- Nutrition info on the wiki is very outdated ugh..
-- from my tests, the first increase in weight gain occurs at 400 fat or carbs, the values do not add together, if either of them is above 400 you'll get 2x. my ASSUMPTION is that since the cap is 1000 the 3x multiplier is at 800? i have no way to confirm that without extensive testing though.
function TraitAnorexic()
	if not OldCalories then OldCalories = Nutrition:getCalories() end
	if not OldCarbs then OldCarbs = Nutrition:getCarbohydrates() end
	if not OldLips then OldLips = Nutrition:getLipids() end
	
	local NewCalories = Nutrition:getCalories()
	local NewCarbs = Nutrition:getCarbohydrates()
	local NewLips = Nutrition:getLipids()
	
	local CalorieMod = 0.7
	local CalorieMax = 3000
	local CarbsMod = 0.7
	local CarbsMax = 600
	local LipsMod = 0.7
	local LipsMax = 600
	
	
	if NewCalories > OldCalories then
		local Diff = NewCalories-OldCalories
		NewCalories = OldCalories + Diff*CalorieMod
		if NewCalories > CalorieMax then NewCalories = CalorieMax end -- normal cap is 3700, you start gaining weight at 1600. if you dont have 1600 you dont gain weight. useful to know for normal gameplay.
		Nutrition:setCalories(NewCalories)
	end
	
	if NewCarbs > OldCarbs then
		local Diff = NewCarbs-OldCarbs
		NewCarbs = OldCarbs + Diff*CarbsMod
		if NewCarbs > CarbsMax then NewCarbs = CarbsMax end
		Nutrition:setCarbohydrates(NewCarbs)
	end
	
	if NewLips > OldLips then
		local Diff = NewLips-OldLips
		NewLips = OldLips + Diff*LipsMod
		if NewLips > LipsMax then NewLips = LipsMax end
		Nutrition:setLipids(NewLips)
	end
	
	OldCalories = NewCalories
	OldCarbs = NewCarbs
	OldLips = NewLips
end

function TraitBloat()
	if not OldCalories then OldCalories = Nutrition:getCalories() end
	if not OldCarbs then OldCarbs = Nutrition:getCarbohydrates() end
	if not OldLips then OldLips = Nutrition:getLipids() end
	
	local NewCalories = Nutrition:getCalories()
	local NewCarbs = Nutrition:getCarbohydrates()
	local NewLips = Nutrition:getLipids()
	
	local CalorieMod = 2.5
	local CalorieMin = -1600
	local CarbsMod = 1.5
	local CarbsMin = 0
	local LipsMod = 1.5
	local LipsMin = 0
	
	
	if NewCalories > OldCalories then
		local Diff = NewCalories-OldCalories
		NewCalories = OldCalories + Diff*CalorieMod
		Nutrition:setCalories(NewCalories)
	elseif NewCalories < CalorieMin then 
		NewCalories = CalorieMin
		Nutrition:setCalories(CalorieMin)
	end
	
	if NewCarbs > OldCarbs then
		local Diff = NewCarbs-OldCarbs
		NewCarbs = OldCarbs + Diff*CarbsMod
		Nutrition:setCarbohydrates(NewCarbs)
	elseif NewCarbs < CarbsMin then
		NewCarbs = CarbsMin
		Nutrition:setCarbohydrates(CarbsMin)
	end
	
	if NewLips > OldLips then
		local Diff = NewLips-OldLips
		NewLips = OldCarbs + Diff*LipsMod
		Nutrition:setLipids(NewLips)
	elseif NewLips < LipsMin then
		NewLips = LipsMin
		Nutrition:setLipids(LipsMin)
	end
	
	OldCalories = NewCalories
	OldCarbs = NewCarbs
	OldLips = NewLips
end

function TraitPTSD()
	if not PlayerData.PTSDSuppressedTime then PlayerData.PTSDSuppressedTime = 0 end
	local StressMod = 1
	local Panic = Stats:getPanic()
	local SuppressedMod = 1
	
	PlayerData.PTSDSuppressedTime = math.max(0,PlayerData.PTSDSuppressedTime-1)
	
	if PlayerData.PTSDSuppressedTime > 0 then SuppressedMod = 0.5 end
	if Panic >= 80 then
		PlayerData.StressChange = PlayerData.StressChange + 0.02 * StressMod * SuppressedMod
	elseif Panic >= 65 then
		PlayerData.StressChange = PlayerData.StressChange + 0.01 * StressMod * SuppressedMod
	end
	if Player:HasTrait("Smoker") and PlayerData.PTSDSuppressedTime <= 0 then
		local CurrentCigStress = Stats:getStressFromCigarettes()
		local CurrentStress = Stats:getStress() - CurrentCigStress
		
		if CurrentCigStress < 0.5 and CurrentStress > 0 then
			local ChangeValue = 0.001
			if CurrentStress < ChangeValue then ChangeValue = CurrentStress end
			local Gain = ChangeValue/getTotalModifier(PlayerData.LCigStressGainModifiers)
			local Loss = ChangeValue/getTotalModifier(PlayerData.LStressLossModifiers)
			Stats:setStressFromCigarettes(CurrentCigStress + Gain)
			Stats:setStress(CurrentStress - Loss)
		end
	end
end

--moodles are at 36.5 and 37.5 respectively.
function TraitNaturalInsulation()
	local CurrentTemp = BodyDamage:getTemperature()
	local BigMod = 1.5
	local SmallMod = 0.67
	if CurrentTemp < 36.9 then
		PlayerData.LTemperatureGainModifiers.NaturalInsulationModifier = BigMod
		PlayerData.LTemperatureLossModifiers.NaturalInsulationModifier = SmallMod
	elseif CurrentTemp > 37.1 then
		PlayerData.LTemperatureGainModifiers.NaturalInsulationModifier = SmallMod
		PlayerData.LTemperatureLossModifiers.NaturalInsulationModifier = BigMod
	else
		PlayerData.LTemperatureGainModifiers.NaturalInsulationModifier = 1
		PlayerData.LTemperatureLossModifiers.NaturalInsulationModifier = 1
	end
	
	
end

--[[
local currsquare = player;
		local lightLevel = currsquare:getLightLevel(player:getPlayerNum());
		if lightLevel <= 0.35 then
]]

function IsDay()
	local CurrentTime = GameTime:getTimeOfDay()
	if CurrentTime >= 6 and CurrentTime < 22 then
		return true
	else
		return false
	end
end

function TraitNyctophobic()
	local Sqr = Player:getCurrentSquare()
	if Sqr then
		local Light = Sqr:getLightLevel(Player:getPlayerNum());
		if Light <= 0.5 then
			if Light < .35 then Light = .35 end
			local Tweak = 0.5*(1-(Light-.35)/.15)
			local Max = 50*(1-(Light-.35)/.15) -- Set a max value for panic based on conditions.
			if not IsDay() and Player:isOutside() then
				Tweak = Tweak * 2
				Max = 100
			end
			local NewPanic = Stats:getPanic()+Tweak*LFramerateModifier()
			if NewPanic < 0 then NewPanic = 0 end
			
			if NewPanic <= Max then
				Stats:setPanic(NewPanic)
			end
			
		end
	end
end
local LGlobalLightIntensity = 0 -- default values that wont cause issues until they get updated
local LFogIntensity = 0
local LCloudIntensity = 0
local LPhotophobicEquipmentModifier = 1 -- Gets changed when wearing sunglasses or a welding mask
function TraitPhotophobic()
	--print("CLOUDINTENSITY: "..Climate:getCloudIntensity())
	--print("FOGINTENSITY: "..Climate:getFogIntensity())
	--print("GLOBALLIGHTINTENSITY: "..Climate:getGlobalLightIntensity())
	--print("ISRAINING: "..Climate:isRaining())
	if LGlobalLightIntensity >= 0.44 and Player:isOutside() then
		local CloudMod = math.min(1,(1.67-LCloudIntensity^2)*0.6) --graphing calculator pog
		local FogMod = math.min(1,1.25-LFogIntensity^2) 
		local LightMod = math.min(1,math.max(0,(LGlobalLightIntensity-.44)/0.11)) -- this sets a clamped 0-1 scale between 0.44 and 0.55 for the light value
		local PanicGain = (0.6+LightMod*0.75)*LFramerateModifier()*CloudMod*FogMod*LPhotophobicEquipmentModifier
		--print("NEWPANICGAIN: "..PanicGain)
		Stats:setPanic(Stats:getPanic()+PanicGain*GetGSMulti())
	end
end
function TraitPhotophobicRapid()
	LGlobalLightIntensity = Climate:getGlobalLightIntensity()
	LFogIntensity = Climate:getFogIntensity()
	LCloudIntensity = Climate:getCloudIntensity()
	local Stuff = Player:getWornItems()
	local ResetValue = true
	for i = 0,Stuff:size() - 1 do
		if Stuff:getItemByIndex(i):getType() == "Glasses_Sun" then
			LPhotophobicEquipmentModifier = 0.5
			ResetValue = false
		end
		if Stuff:getItemByIndex(i):getType() == "WeldingMask" then
			LPhotophobicEquipmentModifier = 0.35
			ResetValue = false
		end
	end
	if ResetValue then
		LPhotophobicEquipmentModifier = 1
	end
end

local stresseaterOldHunger
function TraitStressEater()
	if not stresseaterOldHunger then stresseaterOldHunger = Stats:getHunger() end
	local NewHunger = Stats:getHunger()
	local NewStress = Stats:getStress()
	
	local StressMod = 1
	local HungerMod = 1
	
	if NewHunger < stresseaterOldHunger then
		local Diff = NewHunger - stresseaterOldHunger
		if NewHunger == 0 then
			PlayerData.StressChange = PlayerData.StressChange + Diff*2 -- filling yourself up removes a lot of stress.
		elseif NewHunger < 0.15 then
			PlayerData.StressChange = PlayerData.StressChange + Diff*1.5
		elseif NewHunger < 0.25 then
			PlayerData.StressChange = PlayerData.StressChange + Diff*1.25
		else
			PlayerData.StressChange = PlayerData.StressChange + Diff
		end
	end
	
	if NewHunger > 0.25 and NewStress < 0.51 or NewHunger > 0.45 and NewStress < 0.76 then
		PlayerData.StressChange = PlayerData.StressChange + (0.001 + 0.005*(NewHunger-0.2)/0.25)*StressMod
	end
	if NewStress > 0.5 and NewHunger < 0.45 then
		PlayerData.HungerChange = PlayerData.HungerChange + 0.00015*HungerMod
		if NewStress > 0.75 then
			PlayerData.HungerChange = PlayerData.HungerChange + 0.00015*HungerMod
		end
	end
	
	stresseaterOldHunger = NewHunger
end
local NightWalkerMinLight = 0.67
function SetNightwalkerValue()
	local NewNRLightValue = 0.67
	if NewNRLightValue ~= NightWalkerMinLight then
		NightWalkerMinLight = NewNRLightValue
	end
end
function TraitNightwalker()
	if Climate:getAmbient() < NightWalkerMinLight then
		Climate:setAmbient(NightWalkerMinLight) -- This works on player updates
	end
end

function ForcePlayerTrip() -- stolen from More Traits
	local Fall = nil;
	if ZombRand(2) == 0 then
		Fall = "left"
	else
		Fall = "right"
	end
	Player:setBumpFallType("FallForward");
	Player:setBumpType(Fall);
	Player:setBumpDone(false);
	Player:setBumpFall(true);
	Player:reportEvent("wasBumped");
end

local IsManic = false

--[[
if Item:getContainer() ~= Player:getInventory() then
		local NewAction = ISInventoryTransferAction:new(Player, Item, Item:getContainer(), Player:getInventory(), 50)
		ISTimedActionQueue.add(NewAction)
		for _,Container in ipairs(loot.backpacks) do
			local Inv = Container.inventory
			if Inv:getType() == "floor" then
				local NewAction = ISInventoryTransferAction:new(Player, Item, Player:getInventory(), Inv, 50)
				ISTimedActionQueue.add(NewAction)
				break
			end
		end
		]]
		
--[[function FoodItemCheck(Item)
	if Item:IsFood() then
		if Item:getRequireInHandOrInventory() then
			for i=0,Item:getRequireInHandOrInventory():size()-1 do
				print(Item:getRequireInHandOrInventory():get(i))
			end
		end
	end
end]]--
--[[function TryCompulsiveEat() -- Maybe i'll reuse this later, it was going to be part of Insanity
	local Inventory = Player:getInventory()
	local FoodItem = nil
	for i=0, Inventory:getItems():size() - 1 do
		local Item = Inventory:getItems():get(i)
		if FoodItemCheck(Item) then FoodItem = Item end
		if Item:isEquipped() and Item:getCategory() == "Container" then
			for i2=0, Item:getInventory():getItems():size() - 1 do
				local Item2 = Item:getInventory():getItems():get(i2)
				if Item2:IsFood() then FoodItem = Item2 break end
			end
		end
		if FoodItem then break end
	end
	
	if FoodItem then
		if FoodItem:getContainer() ~= Player:getInventory() then
			local NewAction = ISInventoryTransferAction:new(Player, FoodItem, FoodItem:getContainer(), Player:getInventory(), 1)
			ISTimedActionQueue.add(NewAction)
			ISInventoryPaneContextMenu.onEatItems({FoodItem},0.25,Player:getPlayerNum())
		else
			ISInventoryPaneContextMenu.onEatItems({FoodItem},0.25,Player:getPlayerNum())
		end
		return true
	end
	
	if Player:isPlayerMoving() then return false end

	local loot = getPlayerLoot(Player:getPlayerNum())
	for _,Container in ipairs(loot.backpacks) do
		local Inventory = Container.inventory
		for i=0,Inventory:getItems():size() - 1 do
			local Item = Inventory:getItems():get(i)
			if FoodItemCheck(Item) then 
				local NewAction = ISInventoryTransferAction:new(Player, Item, Item:getContainer(), Player:getInventory(), 1)
				ISTimedActionQueue.add(NewAction)
				ISInventoryPaneContextMenu.onEatItems({Item},0.25,Player:getPlayerNum())
				return true
			end
		end
	end
	
	return false -- no food was found to eat
end]]--
local SandboxDillusionsEnabled =  true
function TraitInsanity() -- minute timer
	
	local SandboxMoodSwingsEnabled = true
	local SandboxMoodSwingsMod =  1
	local SandboxMoodSwingsFreq =  1
	local SandboxItemRejectEnabled =  true
	local SandboxItemRejectTripEnabled =  true
	local SandboxItemRejectFreq =  1
	local SandboxItemRejectCD =  24
	local SandboxManiaEnabled = true
	local SandboxManiaFreq =  1
	local SandboxManiaCD =  96
	local SandboxManiaDurMod =  1

	SandboxDillusionsEnabled =  true
	SandboxManiaTripMod =  1
	SandboxManiaDropFreq =  1
	
	if not PlayerData.ManiaCD then PlayerData.ManiaCD = 96*60 end -- 4 day grace period for mania
	if not PlayerData.ManiaDuration then PlayerData.ManiaDuration = 0 end
	if not PlayerData.PolarCD then PlayerData.PolarCD = 120+ZombRand(60) end
	if not PlayerData.RejectCD then PlayerData.RejectCD = 48*60 end -- 2 day grace period for rejecting items
	if not PlayerData.RejectItem then PlayerData.RejectItem = nil end
	
	if SandboxMoodSwingsEnabled and SandboxMoodSwingsFreq > 0 then
		if PlayerData.PolarCD <= 0 then
			local Altering = ZombRand(5) -- returns a random number between 0 and 4
			
			if Altering <= 1 or Altering == 4 then
				if ZombRand(100)/100 > Stats:getStress() - Stats:getStressFromCigarettes() then
					PlayerData.StressChange = PlayerData.StressChange + 0.12*SandboxMoodSwingsMod
				else
					PlayerData.StressChange = PlayerData.StressChange - 0.12*SandboxMoodSwingsMod
				end
			end
			if Altering >= 2 then
				if ZombRand(100) > BodyDamage:getUnhappynessLevel() then
					PlayerData.UnhappyChange = PlayerData.UnhappyChange + 0.05*SandboxMoodSwingsMod
				else
					PlayerData.UnhappyChange = PlayerData.UnhappyChange - 0.05*SandboxMoodSwingsMod
				end
			end
			PlayerData.PolarCD = (90 + ZombRand(91))/SandboxMoodSwingsFreq
		else
			PlayerData.PolarCD = PlayerData.PolarCD - 1
		end
	end
	if PlayerData.RejectItem ~= nil then
		if ZombRand(480) == 0 then
			PlayerData.RejectItem = nil
		end
	end
	if SandboxItemRejectEnabled and SandboxItemRejectFreq > 0 then
		if PlayerData.RejectCD <= 0 and not IsManic then
			if ZombRand(48) == 0 then -- one in 48 tries will succeed
				local Inventory = Player:getInventory()
				local ItemNum = ZombRand(Inventory:getItems():size())
				local Item = Inventory:getItems():get(ItemNum);
				
				local RejectID = ZombRand(1000)
				PlayerData.RejectItem = RejectID
				Item:getModData().RejectID = RejectID
				DropItemOnFloor(Item)
				SayQuote(InsanityInitalDropQuotes)
				PlayerData.RejectCD = SandboxItemRejectCD*60 -- minimum 24 hour cooldown before the next rejection.
			else
				PlayerData.RejectCD = (30 + ZombRand(61))/SandboxItemRejectFreq -- aprox 1 in game hour between tries
			end
		else
			PlayerData.RejectCD = PlayerData.RejectCD - 1
		end
	end
	
	--[[if PlayerData.ImpulsiveEatingCD <= 0 then -- Unfinished.
		if ZombRand(200) == 0 then
			--PlayerData.ImpulsiveEatingCD = 60*12
		else
			
		end
		PlayerData.ImpulsiveEatingCD = 5
		Player:Say("Compulse")
		TryCompulsiveEat()
	else
		PlayerData.ImpulsiveEatingCD = PlayerData.ImpulsiveEatingCD - 1
	end]]--
	if SandboxManiaEnabled and SandboxManiaFreq > 0 then
		if PlayerData.ManiaCD <= 0 then
			if ZombRand(192) == 0 or true then -- with 1 hour between attempts, this should fire every 8 days
				PlayerData.ManiaDuration = (150 + ZombRand(61))*SandboxManiaDurMod -- assuming 1 day is 1 hour IRL time, this is 6 - 9 minutes
				PlayerData.ManiaCD = SandboxManiaCD*60 -- 4 day cooldown once it has activated
			else
				PlayerData.ManiaCD = (30 + ZombRand(61))/SandboxManiaFreq
			end
		else
			PlayerData.ManiaCD = PlayerData.ManiaCD - 1
		end
	end
	--print("CD: "..PlayerData.ManiaCD)
	--print("DUR: "..PlayerData.ManiaDuration)
	if PlayerData.ManiaDuration > 0 then
		IsManic = true
		PlayerData.ManiaDuration = PlayerData.ManiaDuration - 1
	else
		IsManic = false
		ManiaEnduranceLock = 1
	end
end
local DillusionCheck = true
local HaveDillusion = false
function InsanityDilusions()
	if SandboxDillusionsEnabled and Player:hasTimedActions() then
		if DillusionCheck and (ZombRand(1000) <= Stats:getStress()*10 or IsManic and ZombRand(5) == 0) then -- ranges from 0.1% to 1% per action based on stress
			HaveDillusion = true
		end
		DillusionCheck = false
		if HaveDillusion then -- dilusions have stopped working? 6/22/2023
			local Actions = Player:getCharacterActions()
			if Actions:size() <= 1 then -- don't want to cancel qued actions, only enable on the last action performed in the que
				local Action = Actions:get(0)
				local Type = Action:getMetaType()
				local Delta = Action:getJobDelta()
				if Type ~= "IsWalkToTimedAction" and Type ~= "IsPathFindAction" and Type ~= "" then -- copied blacklist from More Traits
					if IsManic and Delta > 0.33 then
						Action:forceStop()
						SayQuote(ManiaDillusionsQuotes)
					end
					if Delta > 0.85 then
						Action:forceStop()
					end
				end
			end
		end
	else
		DillusionCheck = true
		HaveDillusion = false
	end
end

local ManiaQuotes = MakeTranslationsListInLuaTable("UI_Insanity_ManiaShout")
local ManiaDropHandItemQuotes = MakeTranslationsListInLuaTable("UI_Insanity_ManiaDropHandItem")
local ManiaDropItemQuotes = MakeTranslationsListInLuaTable("UI_Insanity_ManiaDropInventoryItem")
local ManiaTrippedQuotes = MakeTranslationsListInLuaTable("UI_Insanity_ManiaTripped")
local ManiaDillusionsQuotes = MakeTranslationsListInLuaTable("UI_Insanity_ManiaDillusion")
local InsanityInitalDropQuotes = MakeTranslationsListInLuaTable("UI_Insanity_RejectionDropInitial")
local InsanityRepeatDropQuotes = MakeTranslationsListInLuaTable("UI_Insanity_RejectionDropRepeat")
local ScreamCD = 0
local ManiaEnduranceLock = 1

local SandboxManiaTripMod = 1
local SandboxManiaDropFreq = 1
function Mania()
	if PlayerData.ManiaDuration > 0 then
		Stats:setPanic(Stats:getPanic()+0.02)
		Stats:setStress(Stats:getStress() - Stats:getStressFromCigarettes()+0.02)
		if Stats:getEndurance() > ManiaEnduranceLock then
			Stats:setEndurance(ManiaEnduranceLock)
		elseif Stats:getEndurance() < ManiaEnduranceLock then
			ManiaEnduranceLock = Stats:getEndurance()
		end
		if SandboxManiaDropFreq > 0 then
			if ZombRand(PZMath.floor(2000/SandboxManiaDropFreq)) == 0 and  Player:getPrimaryHandItem() then Player:dropHandItems() SayQuote(ManiaDropHandItemQuotes) end
			if not Player:IsRunning() and not Player:isSprinting() and ZombRand(PZMath.floor(4000/SandboxManiaDropFreq)) == 0 then
				local Inventory = Player:getInventory()
				if Inventory:getItems():size() > 0 then -- no items in inventory, skip.
					local ItemsToDrop = {}
					local DropCount = ZombRand(3) + 1
					local i = 0
					repeat
						i = i + 1
						if Inventory:getItems():size() <= i then break end -- no more items, skip the rest.
						local ItemNum = ZombRand(Inventory:getItems():size())
						local Item = Inventory:getItems():get(ItemNum)
						if Item:getType() ~= "KeyRing" then
							if Item:getCategory() == "Container" then 
								if ZombRand(10) >= 1 and Item:getInventory():getItems():size() > 0 then-- 10% chance to drop the backpack itself.
									NewItemNum = ZombRand(Item:getInventory():getItems():size())
									NewItem = Item:getInventory():getItems():get(NewItemNum)
									Item = NewItem
								end
							end
							if not Item:isEquipped() or ZombRand(5) == 0 then -- 80% chance to re-roll or skip dropping an equipped item.
								table.insert(ItemsToDrop,Item)
							end
						end
					until #ItemsToDrop >= DropCount or i >= 4
					if #ItemsToDrop > 0 then
						SayQuote(ManiaDropItemQuotes)
						for i,v in pairs(ItemsToDrop) do
							DropItemOnFloor(v)
						end
					end
				end
			end
		end
		if SandboxManiaTripMod > 0 then
			if Player:isSprinting() and ZombRand(PZMath.floor(500/SandboxManiaTripMod)) == 0 or Player:IsRunning() and ZombRand(PZMath.floor(1000/SandboxManiaTripMod)) == 0 or ZombRand(PZMath.floor(10000/SandboxManiaTripMod)) == 0 then  -- im going to hell for this one..
				if EvenMoreTraits.settings.InsaneTalking then
					SayQuote(ManiaTrippedQuotes)
				end
				ForcePlayerTrip()
			end
		end
		if ScreamCD <= 0 and ZombRand(200) == 0 then
			if EvenMoreTraits.settings.InsaneTalking then
				SayQuote(ManiaQuotes)
			end
			ScreamCD = 200+ZombRand(150)
			addSound(Player, Player:getX(), Player:getY(), Player:getZ(), 200, 200);	
		else
			ScreamCD = ScreamCD - 1
		end
		--if not isClient() or getServerOptions():getBoolean("SleepNeeded") then
			--ISWorldObjectContextMenu.onSleepWalkToComplete(Player:getPlayerNum(), nil) --Pass out?
		--end
	end
end

function TraitHomebody()
	local TimeToActivate = 30
	local StressMod = 1
	local UnhappyMod = 1
	
	PlayerData.LBoredomGainModifiers.HomebodyModifier = 1
	PlayerData.LBoredomLossModifiers.HomebodyModifier = 1
	
	if not PlayerData.IndoorTimer then PlayerData.IndoorTimer = 0 end

	if not Player:isOutside() then
		PlayerData.IndoorTimer = PlayerData.IndoorTimer + 1
		PlayerData.LBoredomGainModifiers.HomebodyModifier = 0.7
		PlayerData.LBoredomLossModifiers.HomebodyModifier = 1.3
	else
		PlayerData.IndoorTimer = 0
		PlayerData.LBoredomGainModifiers.HomebodyModifier = 1
		PlayerData.LBoredomLossModifiers.HomebodyModifier = 1
		if MoodleFR then
			MF.getMoodle("Homebody"):setValue(0.5)
		end
	end
	
	
	
	if PlayerData.IndoorTimer >= SandboxVars.EvenMoreTraits.HomebodyTimeToActivate then
		PlayerData.StressChange = PlayerData.StressChange - ((Stats:getStress() - Stats:getStressFromCigarettes())*0.004*StressMod)
		PlayerData.UnhappyChange = PlayerData.UnhappyChange - (BodyDamage:getUnhappynessLevel()/100)*0.001*UnhappyMod
		
		if MoodleFR then
			MF.getMoodle("Homebody"):setValue(0.6)
		end
	end
end

local SqrList = {}
local WanderRate = 6
local function TrackMovement()
	local Sqr = Player:getSquare()
	table.insert(SqrList,Sqr)
	if #SqrList > 7 then
		table.remove(SqrList,1)
	end
end
local function IsBackTracking()
	local LastChecked = 1000
	for i,v in pairs(SqrList) do
		local Dist = v:DistTo(Player)
		if Dist > LastChecked then -- Check distance from player to previous steps. if they ascend in distance then the player isnt walking in circles.
			return true
		end
		LastChecked = Dist
	end
	return false
end
function TraitWanderer()
	local BacktrackingCheckEnabled = true
	local StressMod = 1
	local UnhappyMod = 1
	if not PlayerData.WanderTime then PlayerData.WanderTime = 0 end
	
	PlayerData.LBoredomGainModifiers.WandererModifier = 1
	PlayerData.LBoredomLossModifiers.WandererModifier = 1
	
	if Player:isOutside() then
		PlayerData.LBoredomGainModifiers.WandererModifier = 0.7
		PlayerData.LBoredomLossModifiers.WandererModifier = 1.3
	else
		PlayerData.LBoredomGainModifiers.WandererModifier = 1
		PlayerData.LBoredomLossModifiers.WandererModifier = 1
	end
	
	if (not BacktrackingCheckEnabled or not IsBackTracking()) and Player:isOutside() and Player:isPlayerMoving() and not Player:IsRunning() and not Player:isSprinting() then
		PlayerData.WanderTime = PlayerData.WanderTime + 1
		if MoodleFR then
			MF.getMoodle("Wanderer"):setChevronCount(PZMath.floor(PlayerData.WanderTime/WanderRate))
			MF.getMoodle("Wanderer"):setChevronIsUp(true)
		end
	elseif PlayerData.WanderTime > 0 then
		PlayerData.WanderTime = PlayerData.WanderTime - 1
		if MoodleFR then
			MF.getMoodle("Wanderer"):setChevronCount(PZMath.floor(PlayerData.WanderTime/WanderRate))
			MF.getMoodle("Wanderer"):setChevronIsUp(false)
		end
	end
	
	if PlayerData.WanderTime < 0 or Player:isTargetedByZombie() or not Player:isOutside() then
		PlayerData.WanderTime = 0
		SqrList = {}
	elseif PlayerData.WanderTime > WanderRate*4 then
		PlayerData.WanderTime = WanderRate*4
	end
	
	if MoodleFR then
		if PlayerData.WanderTime > 3 then
			MF.getMoodle("Wanderer"):setValue(0.6)
		else
			MF.getMoodle("Wanderer"):setValue(0.5)
		end
	end
	
	if not IsBackTracking() and PlayerData.WanderTime > 3 then
		PlayerData.StressChange = PlayerData.StressChange - ((Stats:getStress() - Stats:getStressFromCigarettes())*0.005*(PlayerData.WanderTime/WanderRate)*StressMod)
		PlayerData.UnhappyChange = PlayerData.UnhappyChange - (BodyDamage:getUnhappynessLevel()/100)*0.0025*(PlayerData.WanderTime/WanderRate)*UnhappyMod
	end
end
local AnnouncedPhotographer = false
local TimeSpentGazing = 0
local SunsetGoodQuotes = {"Sunset looks beautiful today","Nice to see that some things havn't changed","Sunset looks amazing..","Sunset.. I wish i still had my camera","Another day gone.. well.. not yet.","Sunset, That has got to be one of the better ones i've seen"}
local SunsetNeutralQuotes = {"Phew, long day.. Sun looks nice though","Sun is going down, looks nice today","A fleeting comfort in this cruel world.. i should make sure im ready for tonight","Another day.. Another night looming past the horizon"}
local SunsetBadQuotes = {"Sunset looks alright, definitely seen better though","Sun's going down.. What did i get done today?","Another day gone.. Another potentially fatal night ahead"}
local SunsetNoneQuotes = {"Guess theres no sunset tonight..","Damn clouds, no sunset today","*sigh* I was hoping to see a nice sunset today"}
local SunriseQuotes = {"Another day.. another beaten and bloodied skull to smash","Made it through the night.. Sunrise looks ok too","Sunrise, dawn of hope and peace.. for the next few mintues at least","Sun's up, do i have time to watch?","Sunrise o'clock, What's on my todo list?","Sunrise, I got a minute to sit and watch..","Rise and shine oh giant ball of superheated... stuff.. yeah.."}
local FinishedGazingQuotes = {"I should get going..","Alright thats enough sunwatching, time to move","*Yawn* I should probably get moving now","*Yawn* Wish i could stay longer.. but theres things to do","That was refreshing.. wheres my todo list?"}
-- not adding these to translation because the trait is gone. :(

function TraitPhotographer()
	local CurrentTime = GameTime:getTimeOfDay()
	if CurrentTime > 21 and CurrentTime < 22 or CurrentTime > 5 and CurrentTime < 6 then
		--Color = getClimateManager():getClimateColor(Player:getPlayerNum()):getFinalValue():getExterior() -- what in the actual fuck is this path? who's idea was this??
		--local SunsetQuality = Color:getRed() - (Color:getGreen() + Color:getBlue())/2
		local SunsetQuality = 30 -- Temporary fix, quality detector is breaking ISVehicleMechanics.lua from vanilla???
		if Player:isOutside() and not Player:isDriving() then
			if Stats:getPanic() <= 0 and not AnnouncedPhotographer then
				AnnouncedPhotographer = true
				if CurrentTime > 21 then
					if SunsetQuality >= 50 then
						SayQuote(SunsetGoodQuotes)
					elseif SunsetQuality >= 25 then
						SayQuote(SunsetNeutralQuotes)
					elseif SunsetQuality > 0 then
						SayQuote(SunsetBadQuotes)
					else
						SayQuote(SunsetNoneQuotes)
					end
				else
					SayQuote(SunriseQuotes)
				end
			end
			if Player:isOutside() and Stats:getPanic() <= 0 and not Player:isPlayerMoving() and TimeSpentGazing < 15 then
				TimeSpentGazing = TimeSpentGazing + 1
				if TimeSpentGazing == 15 then
					SayQuote(FinishedGazingQuotes)
				end

				local Multiplier = SunsetQuality/50
				if Multiplier < 0 then Multiplier = 0 end
				
				PlayerData.StressChange = PlayerData.StressChange - 0.5/15 - (1*Multiplier)/15 -- Get a minimum of 50% reduction to stress and 30% depression. increases based on sunset quality.
				PlayerData.UnhappyChange = PlayerData.UnhappyChange - 0.3/15 - (1*Multiplier)/15
				if Player:isSitOnGround() then
					PlayerData.EnduranceChange = PlayerData.EnduranceChange + 0.05 -- if sitting while watching sunset, boost endurance regen too
				end
			end
		end
	else
		AnnouncedPhotographer = false
		TimeSpentGazing = 0
	end
end

function TraitPlotArmor()
	local PreventCombatActivation = true
	if (not PreventCombatActivation or Player:getStats():getNumChasingZombies() <= 0) and BodyDamage:IsInfected() then
		local bodyParts = BodyDamage:getBodyParts();
		for i=bodyParts:size()-1, 0, -1  do
			local bodyPart = bodyParts:get(i);
			bodyPart:SetInfected(false);
		end
		BodyDamage:setInfected(false);
		BodyDamage:setInfectionLevel(0);
		BodyDamage:setInfectionMortalityDuration(-1);
		BodyDamage:setInfectionTime(-1);
		Player:getTraits():remove("plotarmor");
		HaloTextHelper.addTextWithArrow(Player, "Plot Armor", false, HaloTextHelper.getColorRed());
		getSoundManager():PlaySound("GainExperienceLevel", false, 0):setVolume(0.50);	
	end
end

RestrictiveFastQuotes = MakeTranslationsListInLuaTable("UI_Restrictive_Lightweight")
RestrictiveNeutralQuotes = MakeTranslationsListInLuaTable("UI_Restrictive_Neutralweight")
RestrictiveSlowQuotes = MakeTranslationsListInLuaTable("UI_Restrictive_Heavyweight")
RestrictiveHeavyQuotes = MakeTranslationsListInLuaTable("UI_Restrictive_Massiveweight")

--[[
	getDefForPart() is a weird function. you need to specify 2 additional booleans or it will crash.
	the first one is to specify you want bite resist, the 2nd one is to specifiy bullet. if neither is true it will give you scratch resistance
	ie:
	true true -> bullet defense
	true false -> bite defense
	false false -> scratch defense
	false true -> bullet defense
]]
local PreviousWornItems
function TraitRestrictive()
	if not PlayerData.LRestrictiveState then PlayerData.LRestrictiveState = "Fast" end
	local PositiveStatsEnabled = true
	local EffectMod = 1
	local WornItems = Player:getWornItems()
	PreviousWornItems = WornItems
	local TotalProtection = 0
	for i=0,14 do
		TotalProtection = TotalProtection+ Player:getBodyPartClothingDefense(i,false,false)
		--TotalProtection = TotalProtection+ Player:getBodyPartClothingDefense(i,true,false) -- Ignoring bite defense for now, since scratch is the most common.
	end
	-- Restrictive ignores the protection of Feet, because it single handedly accounts for 12% of the average if you wear military boots
	local Avg = TotalProtection/1500
	
	if Avg <= 0.20 then -- 20% or less
		if PositiveStatsEnabled then
			PlayerData.LEnduranceLossModifiers.RestrictiveLossMod = 0.9
		else
			PlayerData.LEnduranceLossModifiers.RestrictiveLossMod = 1
		end
		PlayerData.LEnduranceGainModifiers.RestrictiveGainMod = 1
		if PlayerData.LRestrictiveState ~= "Fast" then
			PlayerData.LRestrictiveState = "Fast"
			SayQuote(RestrictiveFastQuotes)
		end
	elseif Avg <= 0.30 then -- 20-30%
		PlayerData.LEnduranceLossModifiers.RestrictiveLossMod = 1
		PlayerData.LEnduranceGainModifiers.RestrictiveGainMod = 1
		if PlayerData.LRestrictiveState ~= "Neutral" then
			PlayerData.LRestrictiveState = "Neutral"
			SayQuote(RestrictiveNeutralQuotes)
		end
	elseif Avg <= 0.60 then --30-60%
		PlayerData.LEnduranceLossModifiers.RestrictiveLossMod = 1 + 0.5*EffectMod
		PlayerData.LEnduranceGainModifiers.RestrictiveGainMod = 1 - 0.3*EffectMod
		if PlayerData.LRestrictiveState ~= "Slow" then
			PlayerData.LRestrictiveState = "Slow"
			SayQuote(RestrictiveSlowQuotes)
		end
	else -- More than 60%
		PlayerData.LEnduranceLossModifiers.RestrictiveLossMod = 1 + 1.5*EffectMod
		PlayerData.LEnduranceGainModifiers.RestrictiveGainMod = 1 - 0.5*EffectMod
		if PlayerData.LRestrictiveState ~= "Heavy" then
			PlayerData.LRestrictiveState = "Heavy"
			SayQuote(RestrictiveHeavyQuotes)
		end
	end
end

local function VehicleUpdate() --- YOINK, sorry.
	if getActivatedMods():contains("DrivingSkill") == true then
        --skip processing if Driving Skill mod is installed.
        return ;
    end
	
	if Player:isDriving() == true then
        local vehicle = Player:getVehicle();
        local vmd = vehicle:getModData();
        if vmd.fRegulatorSpeed == nil then
            vmd.bUpdated = nil;
        end
        if not vmd.lbUpdated then
            vmd.fBrakingForce = vehicle:getBrakingForce();
            vmd.fMaxSpeed = vehicle:getMaxSpeed();
            vmd.iEngineQuality = vehicle:getEngineQuality();
            vmd.iEngineLoudness = vehicle:getEngineLoudness()
            vmd.iEnginePower = vehicle:getEnginePower();
            vmd.iMass = vehicle:getMass();
            vmd.iInitialMass = vehicle:getInitialMass();
            vmd.fOffRoadEfficiency = vehicle:getScript():getOffroadEfficiency();
            vmd.fRegulatorSpeed = vehicle:getRegulatorSpeed();
            vmd.LOffroaded = false;
            vmd.bUpdated = true;
        else
            if Player:HasTrait("offroader") and not vmd.LOffroaded then
                vehicle:setBrakingForce(vmd.fBrakingForce);
                vehicle:setEngineFeature(vmd.iEngineQuality, vmd.iEngineLoudness, vmd.iEnginePower * 2);
                vehicle:setMaxSpeed(vmd.fMaxSpeed);
                vehicle:setMass(vmd.iMass * 0.75);
                vehicle:setInitialMass(vmd.iInitialMass * 0.75);
                vehicle:updateTotalMass();
                vehicle:getScript():setOffroadEfficiency(vmd.fOffRoadEfficiency * 3);
                vmd.LOffroaded = true;
                vehicle:update();
            end
            if not Player:HasTrait("offroader") and vmd.LOffroaded then
                vehicle:setBrakingForce(vmd.fBrakingForce);
                vehicle:setEngineFeature(vmd.iEngineQuality, vmd.iEngineLoudness, vmd.iEnginePower);
                vehicle:setMaxSpeed(vmd.fMaxSpeed);
                vehicle:setMass(vmd.iMass);
                vehicle:setInitialMass(vmd.iInitialMass);
                vehicle:updateTotalMass();
                vehicle:getScript():setOffroadEfficiency(vmd.fOffRoadEfficiency);
                vehicle:setRegulatorSpeed(vmd.fRegulatorSpeed);
                vmd.LOffroaded = false;
                vehicle:update();
            end
        end
    end
end

RageThreshhold = 0.3
BerMaximumStreak = 100

HungerWarn = false
HungerRepeatChance = 10

RageAlert = false
RageRepeatChance = 7


ZerkQuotesRage = MakeTranslationsListInLuaTable("UI_Berserker_RageShout") -- Rage happens at 30% maximum streak. grants a damage bonus to all melee attacks when active.

ZerkQuoteRush = MakeTranslationsListInLuaTable("UI_Berserker_RageAdrenaline") --Adrenaline rush, if you're at max streak and missing endurance, a chunk of endurance is restored and you lose a chunk of streak.
ZerkQuotesHungry = MakeTranslationsListInLuaTable("UI_Berserker_RageHungry")

function UpdateBerserkerMoodle()
	MF.getMoodle("Berserk"):setThresholds(nil,nil,nil,nil,0.1,0.3,0.5,0.9)
	MF.getMoodle("Berserk"):setValue(PlayerData.BerzerkerStreak/BerMaximumStreak)
end

HungerChatCooldown = 0
RageChatCooldown = 0
OverheadCooldown = 0


BerzerkerStreakDecay = 1500
function TraitBerserker()
	if not PlayerData.BerzerkerStreak or type(PlayerData.BerzerkerStreak) ~= type(1) then PlayerData.BerzerkerStreak = 0 end
	if not PlayerData.BerzerkerStreakDecayAmmont then PlayerData.BerzerkerStreakDecayAmmont = 1 end
	if not PlayerData.BerzerkerFatigueAmmount then PlayerData.BerzerkerFatigueAmmount = 0 end
	if not PlayerData.BerRushStacks then PlayerData.BerRushStacks = 0 end
	local LTimeScale = 1*LFramerateModifier() -- make the timers consistent across framerates. since player updates happen every frame.
	BerzerkerStreakDecay = BerzerkerStreakDecay - LTimeScale
	RageChatCooldown = RageChatCooldown - LTimeScale
	HungerChatCooldown = HungerChatCooldown - LTimeScale
	OverheadCooldown = OverheadCooldown - LTimeScale
	--print("Streak Decay: "..math.floor(BerzerkerStreakDecay))
	
	if (Player:isSitOnGround() or Player:getVehicle()) and BerzerkerStreakDecay > 300 then -- if your sitting, your not fighting.
		BerzerkerStreakDecay = 300 
		PlayerData.BerzerkerStreakDecayAmmont = PlayerData.BerzerkerStreakDecayAmmont + 1
	end
	
	if BerzerkerStreakDecay <= 0 then
		BerzerkerStreakDecay = 400;
		
		if PlayerData.BerzerkerStreak > 0 then
			PlayerData.BerzerkerStreak = PlayerData.BerzerkerStreak - PlayerData.BerzerkerStreakDecayAmmont;
			if PlayerData.BerzerkerStreak < 0 then
				PlayerData.BerzerkerStreak = 0
			end
			PlayerData.BerzerkerStreakDecayAmmont = PlayerData.BerzerkerStreakDecayAmmont + 1
			if PlayerData.BerzerkerStreak <= 0 and PlayerData.BerRushStacks > 0 then
				PlayerData.BerRushStacks = 0
				HaloTextHelper.addText(Player, getText("UI_Berserker_AdrenalineEnded") , false, HaloTextHelper.getColorRed());
			else
				if EvenMoreTraits.settings.BerserkerDisplayStreak and OverheadCooldown <= 0 then
					HaloTextHelper.addTextWithArrow(Player, getText("UI_Berserker_BerserkerStreak")..": "..PlayerData.BerzerkerStreak , false, HaloTextHelper.getColorRed());
					OverheadCooldown = 150
				end
			end
			
			
		end
	end
	
	if PlayerData.BerzerkerStreak <= 0 and (RageAlert or HungerWarn) then
		RageAlert = false
		HungerWarn = false
	end
	
	
	
	if PlayerData.BerzerkerStreak > RageThreshhold*BerMaximumStreak then
		-- (Streak - Threshold) / (Max - Threshold) = Scale from threshold to max
		local Scale = (PlayerData.BerzerkerStreak - (BerMaximumStreak*RageThreshhold)) / (BerMaximumStreak-(BerMaximumStreak*RageThreshhold))
		PlayerData.LStressGainModifiers.BerserkerModifier = 0.75 - 0.25*Scale
		PlayerData.LPanicGainModifiers.BerserkerModifier = 0.75 - 0.5*Scale
	else
		PlayerData.LStressGainModifiers.BerserkerModifier = 1
		PlayerData.LPanicGainModifiers.BerserkerModifier = 1
	end
	
	if MoodleFR then
		UpdateBerserkerMoodle()
	end
	
	if SandboxVars.EvenMoreTraits.BerserkerEnableFatigue and PlayerData.BerzerkerFatigueAmmount > 0 and PlayerData.BerzerkerStreak <= 0 then
		PlayerData.FatigueChange = PlayerData.BerzerkerFatigueAmmount
		PlayerData.BerzerkerFatigueAmmount = 0
	elseif not SandboxVars.EvenMoreTraits.BerserkerEnableFatigue and PlayerData.BerzerkerFatigueAmmount > 0 then
		PlayerData.BerzerkerFatigueAmmount = 0
	end
end

local TakenPillsChat = MakeTranslationsListInLuaTable("UI_Addict_PillsTaken")
local TakenPillsRecoveredChat = MakeTranslationsListInLuaTable("UI_Addict_RecoveredPillsTaken")
local AddictDay1Chat = MakeTranslationsListInLuaTable("UI_Addict_WithdrawlsStarted")
local AddictDay2Chat = MakeTranslationsListInLuaTable("UI_Addict_WithdrawlsLight")
local AddictDay3Chat = MakeTranslationsListInLuaTable("UI_Addict_WithdrawlsModerate")
local AddictDay4Chat = MakeTranslationsListInLuaTable("UI_Addict_WithdrawlsHeavy")
local AddictEarlyRecoveringChat = MakeTranslationsListInLuaTable("UI_Addict_WithdrawlsRecoveryStarted")
local AddictLateRecoveringChat = MakeTranslationsListInLuaTable("UI_Addict_WithdrawlsRecoveryProgressing")

function AddictChatAttempt()
	if ZombRand(1440) <= 5 then
		local DaysSinceLastPills = PlayerData.LTimeSinceLastPills/60/24
		
		if DaysSinceLastPills > 4 and PlayerData.LAddiction < 33 then
			SayQuote(AddictLateRecoveringChat)
			
		elseif DaysSinceLastPills > 4 and PlayerData.LAddiction < 66 then
			SayQuote(AddictEarlyRecoveringChat)
			
		elseif DaysSinceLastPills > 4 then
			SayQuote(AddictDay4Chat)
			
		elseif DaysSinceLastPills > 3 then
			SayQuote(AddictDay3Chat)
			
		elseif DaysSinceLastPills > 2 then
			SayQuote(AddictDay2Chat)
			
		elseif DaysSinceLastPills > 1 then
			SayQuote(AddictDay1Chat)
			
		end
	end
end

function AddictPillsTaken()
	PlayerData.LTimeSinceLastPills = 0
	BodyDamage:setUnhappynessLevel(BodyDamage:getUnhappynessLevel()-15)
	PlayerData.UnhappyChange = PlayerData.UnhappyChange - 0.15
	Stats:setStress(Stats:getStress() - Stats:getStressFromCigarettes() - 0.50)
	PlayerData.StressChange = PlayerData.StressChange - 0.50
	
	PlayerData.LAddiction = PlayerData.LAddiction + ZombRand(1,5)
	if PlayerData.LAddiction > 120 then PlayerData.LAddiction = 120 end
	if EvenMoreTraits.settings.AddictTalking then
		if Player:HasTrait("laddict") then
			SayQuote(TakenPillsChat)
		else
			SayQuote(TakenPillsRecoveredChat)
		end
	end
end

function AttemptMuscleFatigue(DailyTriggers,Rate,AddictMod)
	if not PlayerData.TimeSinceLastFatigue then PlayerData.TimeSinceLastFatigue = ZombRand(900) end
	PlayerData.TimeSinceLastFatigue = PlayerData.TimeSinceLastFatigue + 1
	if PlayerData.TimeSinceLastFatigue >= 1440/DailyTriggers then
		PlayerData.TimeSinceLastFatigue = 0
		 for i = 0, BodyDamage:getBodyParts():size() - 1 do
            local Part = BodyDamage:getBodyParts():get(i);
            local Pain = Part:getAdditionalPain();
			if ZombRand(100) <= Rate*AddictMod then
				Part:setAdditionalPain(Pain+(25+ZombRand(75))*AddictMod);
			end
        end
	end
end

function RecoveredAddict()
	local RelapseEnabled = true

	PlayerData.LEnduranceMaximumModifiers.AddictModifier = 1
	PlayerData.LStressGainModifiers.AddictModifier = 1
	
	if PlayerData.LAddiction > 1 and ZombRand(30) == 0 then
		PlayerData.LAddiction = PlayerData.LAddiction - 1
	elseif RelapseEnabled and PlayerData.LAddiction >= 6 and PlayerData.LAddiction <= 12 then
		Player:getTraits():add("laddict");
		PlayerData.LAddiction = 60+ZombRand(21)
		HaloTextHelper.addTextWithArrow(Player, getText("UI_Trait_Addict") , true, HaloTextHelper.getColorRed());
		getSoundManager():PlaySound("GainExperienceLevel", false, 0):setVolume(0.50);
	elseif PlayerData.LAddiction > 12 then
		PlayerData.LAddiction = nil
	end
end

function TraitAddict()
	if not PlayerData.LTimeSinceLastPills then PlayerData.LTimeSinceLastPills = ZombRand(250,500) end
	if not PlayerData.AddictRecoveryBoostTime then PlayerData.AddictRecoveryBoostTime = 0 end
	if not PlayerData.LAddiction then PlayerData.LAddiction = 80+ZombRand(41) end
	
	local SandboxPenaltiesMod = 4
	local SandboxTimescaleMod = 4
	local SandboxRecoveryMod = 1
	
	PlayerData.LTimeSinceLastPills = PlayerData.LTimeSinceLastPills + 1
	PlayerData.AddictRecoveryBoostTime = math.max(0,PlayerData.AddictRecoveryBoostTime-1)
	
	local DaysSinceLastPills = PlayerData.LTimeSinceLastPills/60/24
	local AddictMod = PlayerData.LAddiction/100
	
	local RecoverySpeed = 60*SandboxRecoveryMod
	local RecoveryBoost = false
	
	if PlayerData.AddictRecoveryBoostTime > 0 or Stats:getDrunkenness() > 0 then
		AddictMod = AddictMod*0.33
		RecoveryBoost = true
	end
	
	if DaysSinceLastPills > 4*SandboxTimescaleMod then
		if MoodleFR then
			MF.getMoodle("Addict"):setChevronIsUp(false)
			if RecoveryBoost then
				MF.getMoodle("Addict"):setChevronCount(math.floor(2+(PlayerData.AddictRecoveryBoostTime/180)))
			else
				MF.getMoodle("Addict"):setChevronCount(1)
			end
			
			if PlayerData.LAddiction > 85 then
				MF.getMoodle("Addict"):setValue(0.1)
			elseif PlayerData.LAddiction > 50 then
				MF.getMoodle("Addict"):setValue(0.2)
			elseif PlayerData.LAddiction > 20 then
				MF.getMoodle("Addict"):setValue(0.3)
			else
				MF.getMoodle("Addict"):setValue(0.4)
			end
		end
		if ZombRand(RecoverySpeed) == 0 or RecoveryBoost and ZombRand(RecoverySpeed/2) == 0 then
			PlayerData.LAddiction = PlayerData.LAddiction - 1
		end
	elseif RecoveryBoost and ZombRand(RecoverySpeed*2) == 0 then
		PlayerData.LAddiction = PlayerData.LAddiction - 1
	end
	
	if DaysSinceLastPills > 3*SandboxTimescaleMod then
		PlayerData.LStressGainModifiers.AddictModifier = 1	
		PlayerData.StressChange = PlayerData.StressChange + 0.0125*AddictMod*SandboxPenaltiesMod
		PlayerData.UnhappyChange = PlayerData.UnhappyChange + 0.006*AddictMod*SandboxPenaltiesMod
		local i = 0.35*AddictMod
		if i - 0.25 <= 0.01 and i - 0.25 >= -0.01 then i = i-0.02 end -- if we're within 1% of the 25% threshhold, we skip 2% so the endurnace moodle doesnt flicker.
		PlayerData.LEnduranceMaximumModifiers.AddictModifier = 1 - i*SandboxPenaltiesMod
		--if Stats:getEndurance() > 1 - i then PlayerData.EnduranceChange = PlayerData.EnduranceChange - 0.02*AddictMod end
		AttemptMuscleFatigue(17*AddictMod,35,AddictMod)
		if MoodleFR and DaysSinceLastPills <= 4 then
			MF.getMoodle("Addict"):setValue(0.1)
			MF.getMoodle("Addict"):setChevronCount(0)
		end
	elseif DaysSinceLastPills > 2.25*SandboxTimescaleMod then
		PlayerData.LStressGainModifiers.AddictModifier = 1
		PlayerData.StressChange = PlayerData.StressChange + 0.0075*AddictMod*SandboxPenaltiesMod
		PlayerData.LEnduranceMaximumModifiers.AddictModifier = 1 - 0.2*AddictMod*SandboxPenaltiesMod
		--if Stats:getEndurance() > 1 - 0.15*AddictMod then PlayerData.EnduranceChange = PlayerData.EnduranceChange - 0.015*AddictMod end
		AttemptMuscleFatigue(4.45,18,AddictMod*0.75)
		if MoodleFR then
			MF.getMoodle("Addict"):setValue(0.2)
			MF.getMoodle("Addict"):setChevronCount(0)
		end
	elseif DaysSinceLastPills > 1.5*SandboxTimescaleMod then
		PlayerData.LStressGainModifiers.AddictModifier = 1
		PlayerData.StressChange = PlayerData.StressChange + 0.005*AddictMod*SandboxPenaltiesMod
		PlayerData.LEnduranceMaximumModifiers.AddictModifier = 1 - 0.1*AddictMod*SandboxPenaltiesMod
		--if Stats:getEndurance() > 1 - 0.05*AddictMod then PlayerData.EnduranceChange = PlayerData.EnduranceChange - 0.01*AddictMod end
		AttemptMuscleFatigue(2.2,10,AddictMod*0.5)
		if MoodleFR then
			MF.getMoodle("Addict"):setValue(0.3)
			MF.getMoodle("Addict"):setChevronCount(0)
		end
	elseif DaysSinceLastPills > 0.75*SandboxTimescaleMod then
		PlayerData.LStressGainModifiers.AddictModifier = 1
		PlayerData.StressChange = PlayerData.StressChange + 0.0025*AddictMod*SandboxPenaltiesMod
		PlayerData.LEnduranceMaximumModifiers.AddictModifier = 1
		if MoodleFR then
			MF.getMoodle("Addict"):setValue(0.4)
			MF.getMoodle("Addict"):setChevronCount(0)
		end
	elseif DaysSinceLastPills < 0.325*SandboxTimescaleMod then
		PlayerData.LStressGainModifiers.AddictModifier = 0.5
		PlayerData.LEnduranceMaximumModifiers.AddictModifier = 1
		if MoodleFR then
			MF.getMoodle("Addict"):setValue(0.6)
			MF.getMoodle("Addict"):setChevronCount(0)
		end
	else
		PlayerData.LStressGainModifiers.AddictModifier = 1
		if MoodleFR then
			MF.getMoodle("Addict"):setValue(0.5)
			MF.getMoodle("Addict"):setChevronCount(0)
		end
	end
	
	if EvenMoreTraits.settings.AddictTalking then 
		AddictChatAttempt()
	end
	
	
	if PlayerData.LAddiction <= 0 then
		Player:getTraits():remove("laddict");
		HaloTextHelper.addTextWithArrow(Player, getText("UI_Trait_Addict") , false, HaloTextHelper.getColorGreen());
		getSoundManager():PlaySound("GainExperienceLevel", false, 0):setVolume(0.50);	
		if MoodleFR then
			MF.getMoodle("Addict"):setValue(0.5)
			MF.getMoodle("Addict"):setChevronCount(0)
		end
	end
end


--ISTimedActionQueue.add(ISInventoryTransferAction:new(Player, Item, curItem:getContainer(), curInv.inv))
-- thank you Manage Containers
function DropItemOnFloor(Item)
	local loot = getPlayerLoot(Player:getPlayerNum())
	if Item:getContainer() ~= Player:getInventory() then
		local NewAction = ISInventoryTransferAction:new(Player, Item, Item:getContainer(), Player:getInventory(), 1)
		ISTimedActionQueue.add(NewAction)
		for _,Container in ipairs(loot.backpacks) do
			local Inv = Container.inventory
			if Inv:getType() == "floor" then
				local NewAction = ISInventoryTransferAction:new(Player, Item, Player:getInventory(), Inv, 1)
				ISTimedActionQueue.add(NewAction)
				break
			end
		end
	else
		for _,Container in ipairs(loot.backpacks) do
			local Inv = Container.inventory
			if Inv:getType() == "floor" then
				local NewAction = ISInventoryTransferAction:new(Player, Item, Item:getContainer(), Inv, 1)
				ISTimedActionQueue.add(NewAction)
				break
			end
		end
	end
end

function PickRandomFromTable(Table)
	return Table[ZombRand(#Table)+1]
end

local EasterEggItems = {
{"Hat_SurgicalMask_Blue",getText("UI_Sentimental_EasterEggNursesMask"),getText("UI_Sentimental_EasterEggNursesMaskTooltip")},
{"Hat_BunnyEarsWhite",getText("UI_Sentimental_EasterEggLolasEars"),getText("UI_Sentimental_EasterEggLolasEarsTooltip")},
{"Necklace_DogTag",getText("UI_Sentimental_EasterEggRicksTags"),getText("UI_Sentimental_EasterEggRicksTagsTooltip")},
{"Hat_HockeyMask",getText("UI_Sentimental_EasterEggJasonsMask"),getText("UI_Sentimental_EasterEggJasonsMaskTooltip")},
{"Hat_SantaHat",getText("UI_Sentimental_EasterEggLalaozsHat"),getText("UI_Sentimental_EasterEggLalaozsHatTooltip")},
{"Glasses_Sun",getText("UI_Sentimental_EasterEggWeskerGlasses"),getText("UI_Sentimental_EasterEggWeskerGlassesTooltip")},
{"Glasses_Reading",getText("UI_Sentimental_EasterEggNerdyGlasses"),getText("UI_Sentimental_EasterEggNerdyGlassesTooltip")},
{"Hat_BaseballCapBlue",getText("UI_Sentimental_EasterEggLeesHat"),getText("UI_Sentimental_EasterEggLeesHatTooltip")},
{"Key1",getText("UI_Sentimental_EasterEggPickleKey"),getText("UI_Sentimental_EasterEggPickleKeyTooltip")},
{"Bracelet_RightFriendshipTINT",getText("UI _Sentimental_EasterEggLionShakxtra"),getText("UI_Sentimental_EasterEggLionShakxtraTooltip")},
}
--First,Last,Item
local EasterEggNames = {
{"Nurse",nil,EasterEggItems[1]},
{"Lola",nil,EasterEggItems[2]},
{"Soldier",nil,EasterEggItems[3]},
{"Jason","Voorhees",EasterEggItems[4]},
{"Lalaoz",nil,EasterEggItems[5]},
{"Albert","Wesker",EasterEggItems[6]},
{nil,"Funpimp",EasterEggItems[7]},
{"Clementine","Marsh",EasterEggItems[8]},
{"Lion",nil,EasterEggItems[10]},
--{"Aria","Clover",{"Shirt_CropTopTINT",getText("UI_SentimentalEasterEggAriaClover"),getText("UI_Sentimental_EasterEggAriaCloverTooltip"),ColorInfo.new(0.2,1,0.2)}}
}



local HatString = getText("UI_Sentimental_Hat")
local NecklaceString = getText("UI_Sentimental_Necklace")
local CrossNecklaceString = getText("UI_Sentimental_CrossNecklace")
local BeretString = getText("UI_Sentimental_Beret")
local BeanyString = getText("UI_Sentimental_Beany")
local DogTagsString = getText("UI_Sentimental_DogTags")
local WatchString = getText("UI_Sentimental_Watch")
local SunglassesString = getText("UI_Sentimental_Sunglasses")
local BoonieString = getText("UI_Sentimental_Boonie")
local RacoonHatString = getText("UI_Sentimental_RacoonHat")
local EarringsString = getText("UI_Sentimental_Earrings")
local SentimentalTooltip = getText("UI_Sentimental_Tooltip")

local SentimentalItemsMale = {
{"NecklaceLong_Amber",NecklaceString},
{"Necklace_Crucifix",CrossNecklaceString},
{"Necklace_SilverCrucifix",CrossNecklaceString},
{"Hat_Beret",BeretString},
{"Hat_BeretArmy",BeretString},
{"Hat_Beany",BeanyString},
{"Necklace_DogTag",DogTagsString},
{"WristWatch_Left_DigitalDress", WatchString},
{"Hat_PeakedCapArmy",HatString},
{"Glasses_Sun",SunglassesString},
{"Hat_BaseballCapBlue",HatString},
{"Hat_BaseballCapRed",HatString},
{"Hat_BaseballCapGreen",HatString},
{"Hat_BonnieHat",BoonieString},
{"Hat_Raccoon",RacoonHatString},
}

local SentimentalItemsFemale = {
{"Earring_Dangly_Diamond",EarringsString},
{"Earring_Dangly_Emerald",EarringsString},
{"Earring_Dangly_Pearl",EarringsString},
{"Earring_Dangly_Ruby",EarringsString},
{"Earring_Dangly_Sapphire",EarringsString},
{"Earring_Stone_Emerald",EarringsString},
{"Earring_Stud_Gold",EarringsString},
{"Earring_Pearl",EarringsString},
{"Earring_Stone_Ruby",EarringsString},
{"Earring_Stone_Sapphire",EarringsString},
{"Earring_Stud_Silver",EarringsString},
{"Necklace_GoldDiamond",NecklaceString},
{"Necklace_GoldRuby",NecklaceString},
{"NecklaceLong_GoldDiamond",NecklaceString},
{"NecklaceLong_Amber",NecklaceString},
{"NecklaceLong_SilverDiamond",NecklaceString},
{"NecklaceLong_SilverEmerald",NecklaceString},
{"NecklaceLong_SilverSapphire",NecklaceString},
{"Necklace_Crucifix",NecklaceString},
{"Necklace_SilverCrucifix",NecklaceString},
{"Necklace_SilverDiamond",NecklaceString},
{"Necklace_SilverSapphire",NecklaceString},
{"Hat_BaseballCapBlue",HatString},
{"Hat_BaseballCapRed",HatString},
{"Hat_BaseballCapGreen",HatString},
{"Hat_Beany",BeanyString},
}

local SentimentalNamesMale = MakeTranslationsListInLuaTable("UI_Sentimental_NamesMale")

local SentimentalNamesFemale = MakeTranslationsListInLuaTable("UI_Sentimental_NamesFemale")

function GetEasterEggItemFromName(Forename,Surname)
	for i,v in pairs(EasterEggNames) do
		if (not v[1] or v[1] == Forename) and (not v[2] or v[2] == Surname) then
			return v[3]
		end
	end
	return nil
end

function GenerateSentimentalItem()
	if Player:HasTrait("Sentimental") then
		local Inventory = Player:getInventory()
		local ItemType
		local Title
		local SentiName
		
		local ItemName
		local ItemTooltip
		--local ItemColor
		local NamedEggItem = GetEasterEggItemFromName(Player:getDescriptor():getForename(),Player:getDescriptor():getSurname())

				if ZombRand(2) == 0 then
					SentiName = PickRandomFromTable(SentimentalNamesMale)
					local TempItem = PickRandomFromTable(SentimentalItemsMale)
					ItemType = TempItem[1]
					Title = TempItem[2]
				else
					SentiName = PickRandomFromTable(SentimentalNamesFemale)
					local TempItem = PickRandomFromTable(SentimentalItemsFemale)
					ItemType = TempItem[1]
					Title = TempItem[2]
				end
				ItemName = SentiName..getText("UI_Sentimental_OwnershipSuffix").." "..Title
				ItemTooltip = "\n"..SentimentalTooltip

		
		local Item = Inventory:AddItem("Base."..ItemType)
		local ID = ZombRand(10000)
		Item:getModData().SentimentalID = ID
		PlayerData.SentimentalID = ID
		
		Item:getModData().SentimentalName = ItemName
		Item:getModData().SentimentalTooltip = ItemTooltip
		Item:setName(ItemName)
		Item:setTooltip(ItemTooltip)
		--if ItemColor then
			--Item:setColorRed(0.2)
			--Item:setColorGreen(1)
			--Item:setColorBlue(0.2)
			--Item:setColor(Item:getColor():set(0.2,1,0.2))
			--Item:update()
		--end
		
		Inventory:addItemOnServer(Item)
	end
end
function ClearSentimentalItems()
	local ItemsToDelete = {}
	local Inventory = Player:getInventory()
	for i=0,Inventory:getItems():size() - 1 do
		local Item = Inventory:getItems():get(i)
		if Item:getModData().SentimentalID ~= nil then table.insert(ItemsToDelete,Item) end
	end
	for i,v in pairs(ItemsToDelete) do
		Inventory:Remove(v)
	end
end

local MissingSentimentalItem = false
function DeepSearchInventory(Container)
	local Inventory = Container:getInventory()
	for i = 0, Inventory:getItems():size() - 1 do
		local Item = Inventory:getItems():get(i);
		if Item:getCategory() == "Container" then 
			DeepSearchInventory(Item)
		else
			if Item:getModData().SentimentalName then
				Item:setName(Item:getModData().SentimentalName)
				Item:setTooltip(Item:getModData().SentimentalTooltip)
			end
			if Player:HasTrait("Sentimental") then
				if Item:getModData().SentimentalID and PlayerData.SentimentalID == nil then
					PlayerData.SentimentalID = Item:getModData().SentimentalID
				end
				if PlayerData.SentimentalID and Item:getModData().SentimentalID == PlayerData.SentimentalID then
					MissingSentimentalItem = false
				end
			end
			if Player:HasTrait("insanity") then
				if PlayerData.RejectItem ~= nil then
					if Item:getModData().RejectID == PlayerData.RejectItem then
						if not Player:getVehicle() then
							if Player:IsRunning() or Player:isSprinting() then
								if ZombRand(10) == 0 then
									ForcePlayerTrip()
								end
							else
								if ZombRand(100) == 0 then
									Item:getModData().RejectID = nil -- 1% chance that you pick it up successfully
									PlayerData.RejectItem = nil
									InsaneConsequitiveDropAttempts = 0
								else
									DropItemOnFloor(Item)
									SayQuote(InsanityRepeatDropQuotes)
								end
							end
						end
					end
				else
					if Item:getModData().RejectID ~= nil then
						Item:getModData().RejectID = nil -- try to clean up.
					end
				end
			end
		end
	end
	
	if Player:HasTrait("Sentimental") then
		if MissingSentimentalItem and PlayerData.SentimentalID == nil and LSpawnDelay then -- Player doesnt have a sentimental item? Make one
			GenerateSentimentalItem()
		end
	else
		MissingSentimentalItem = false
	end
end

local SentimentalItemGenTimer = 0
function TraitSentimental()
	local EnableItemGeneration = false
	if EnableItemGeneration and not Player:getPrimaryHandItem() and Player:getSecondaryHandItem() and Player:getSecondaryHandItem():getType() == "TreeBranch" then
		if SentimentalItemGenTimer >= 3 then
			ClearSentimentalItems()
			GenerateSentimentalItem()
			SentimentalItemGenTimer = 0
		else
			SentimentalItemGenTimer = SentimentalItemGenTimer + 1
		end
	end
	local MaxUnhappy = 0.5
	if PlayerData.SentimentalID and MissingSentimentalItem and BodyDamage:getUnhappynessLevel() <= MaxUnhappy*100 then
		PlayerData.UnhappyChange = PlayerData.UnhappyChange + 0.0008
	end
end



function VitaminJunkieTaken()
	local DurationMod =  1
	local EnduranceGain = 0.07
	
	PlayerData.LVitaminJunkieIntensity = PlayerData.LVitaminJunkieIntensity + 1
	PlayerData.EnduranceChange = PlayerData.EnduranceChange + EnduranceGain
	--Stats:setEndurance(Stats:getEndurance() + EnduranceGain)
	
	if PlayerData.LVitaminJunkieIntensity <= 2 then
		PlayerData.LVitaminJunkieDuration = 360*DurationMod
		if MoodleFR then
			MF.getMoodle("VitaminJunkie"):setValue(0.6)
		end
	elseif PlayerData.LVitaminJunkieIntensity <= 4 then
		PlayerData.LVitaminJunkieDuration = 180*DurationMod
		if MoodleFR then
			MF.getMoodle("VitaminJunkie"):setValue(0.7)
		end
	elseif PlayerData.LVitaminJunkieIntensity <= 6 then
		PlayerData.LVitaminJunkieDuration = 90*DurationMod
		if MoodleFR then
			MF.getMoodle("VitaminJunkie"):setValue(0.8)
		end
	else
		PlayerData.LVitaminJunkieDuration = 45*DurationMod
		if MoodleFR then
			MF.getMoodle("VitaminJunkie"):setValue(0.9)
		end
	end
end


function TableCheck(Table,For)
	for i,v in pairs(Table) do
		if v == For then return true end
	end
	return false
end
--onxpgained
--AddXP(Perk, Amount, Callback to AddXP event?, ???, ???
--Player:getPerkLevel(Perks.Woodwork))

LCombatPerks = {Perks.Aiming,Perks.Axe,Perks.Blunt,Perks.LongBlade,Perks.Maintenance,Perks.Reloading,Perks.SmallBlade,Perks.SmallBlunt,Perks.Spear}
LCraftingPerks = {Perks.Woodwork,Perks.Cooking,Perks.Farming,Perks.Doctor,Perks.Electricity,Perks.MetalWelding,Perks.Mechanics,Perks.Tailoring}
LAgilityPerks = {Perks.Nimble,Perks.Sprinting,Perks.Sneak,Perks.Lightfoot}
LSurvivalistPerks = {Perks.Trapping,Perks.Fishing,Perks.PlantScavenging}
local function XpRecieved(Player, Perk, Amount)
	local Modifier = 1
	if Player:HasTrait("vitaminjunkie") and PlayerData.LVitaminJunkieIntensity and (Perk == Perks.Fitness or Perk == Perks.Strength or Perk == Perks.Sprinting) then
		if PlayerData.LVitaminJunkieIntensity <= 2 then
			Modifier = Modifier * 1.4
		elseif PlayerData.LVitaminJunkieIntensity <= 4 then
			Modifier = Modifier * 1.8
		elseif PlayerData.LVitaminJunkieIntensity <= 6 then
			Modifier = Modifier * 2.6
		else
			Modifier = Modifier * 4.2
		end
	end
	if Player:HasTrait("lcomposure") and TableCheck(LCombatPerks,Perk) then
		local ComposureMin = 1
		local ComposureMax = 1.4
		local CompBonus = (1 - Stats:getPanic()/100)*(ComposureMax-ComposureMin)
		Modifier = Modifier * (ComposureMin+CompBonus)
	end
	if Player:HasTrait("lambitious") and TableCheck(LCraftingPerks,Perk) then
		local AmbitiousBase = 1.2
		local AmbitiousScale = 0.02
		local AmbitiousModifier = AmbitiousBase
		for i,v in pairs(LCraftingPerks) do
			AmbitiousModifier = AmbitiousModifier + AmbitiousScale*Player:getPerkLevel(v)
		end
		--print("Modifier: "..AmbitiousModifier)
		Modifier = Modifier * AmbitiousModifier
	end
	if Player:HasTrait("lquicksilver") and TableCheck(LAgilityPerks,Perk) then
		local XpBase = 1.3
		local XPScale = true
		if XPScale then
			Modifier = Modifier * math.min(3,1.1^Player:getStats():getNumVeryCloseZombies())
			Modifier = Modifier * math.min(3,1.02^Player:getStats():getNumChasingZombies())
		end
		Modifier = Modifier * XpBase
	end
	if Player:HasTrait("lbushman") and TableCheck(LSurvivalistPerks,Perk) then
		local XPBase = 1.3
		local XPScaleMax = 0.5
		local XPScaleTime = 4
		
		local Bonus = (XPBase + (XPScaleMax*(PlayerData.LBushmanValue/(XPScaleTime*1440))))
		--print("Bonus: "..Bonus)
		Modifier = Modifier * Bonus
	end
	if Player:HasTrait("lexpeditious") and Perk == Perks.Sprinting and Player:isSprinting() then
		local ExpedXp = 4
		Modifier = Modifier * ExpedXp
	end
	if Player:HasTrait("lanabolic") and (Perk == Perks.Fitness or Perk == Perks.Strength) then
		local AnabolicModifier = 1.5
		Modifier = Modifier*AnabolicModifier
	end
	
	if Modifier ~= 1 then
		Player:getXp():AddXP(Perk, Amount*(Modifier-1), false, false, false)
		--Player:Say("XPMod"..Modifier)
	end
end
local NecrophobicNoCorpses = MakeTranslationsListInLuaTable("UI_Necrophobic_RefuseCorpsePickup")
function TraitNecrophobic()
	local PanicScale = 20
	if Stats:getPanic() < Stats:getNumChasingZombies()*PanicScale then
		Stats:setPanic(Stats:getNumChasingZombies()*PanicScale)
	end
end

function TraitExpeditious()
	local ExpeditiousRunningLossMod =  0.7
	local ExpeditiousSprintingLossMod = 0.25
	if Player:IsRunning() then
		PlayerData.LEnduranceLossModifiers.ExpeditiousModifier = ExpeditiousRunningLossMod
	elseif Player:isSprinting() then
		PlayerData.LEnduranceLossModifiers.ExpeditiousModifier = ExpeditiousSprintingLossMod
	else
		PlayerData.LEnduranceLossModifiers.ExpeditiousModifier = 1
	end
end

function TraitVitaminJunkie()
	if not PlayerData.LVitaminJunkieDuration then PlayerData.LVitaminJunkieDuration = 0 end
	if not PlayerData.LVitaminJunkieIntensity then PlayerData.LVitaminJunkieIntensity = 0 end
	--Player:Say("Duration: "..PlayerData.LVitaminJunkieDuration.." Intensity: "..PlayerData.LVitaminJunkieIntensity)
	local EffectMod = 1
	local DurationMod = 1
	if PlayerData.LVitaminJunkieDuration > 0 then
		PlayerData.LVitaminJunkieDuration = PlayerData.LVitaminJunkieDuration - 1
		if PlayerData.LVitaminJunkieIntensity <= 2 then
			PlayerData.LEnduranceGainModifiers.VitaminJunkieModifier = 1 + 0.1*EffectMod
			PlayerData.LEnduranceLossModifiers.VitaminJunkieModifier = 1 - 0.1*EffectMod
			if MoodleFR then
				MF.getMoodle("VitaminJunkie"):setValue(0.6)
			end
		elseif PlayerData.LVitaminJunkieIntensity <= 4 then
			PlayerData.LEnduranceGainModifiers.VitaminJunkieModifier = 1 + 0.2*EffectMod
			PlayerData.LEnduranceLossModifiers.VitaminJunkieModifier = 1 - 0.2*EffectMod
			if MoodleFR then
				MF.getMoodle("VitaminJunkie"):setValue(0.7)
			end
		elseif PlayerData.LVitaminJunkieIntensity <= 6 then
			PlayerData.LEnduranceGainModifiers.VitaminJunkieModifier = 1 + 0.3*EffectMod
			PlayerData.LEnduranceLossModifiers.VitaminJunkieModifier = 1 - 0.3*EffectMod
			if MoodleFR then
				MF.getMoodle("VitaminJunkie"):setValue(0.8)
			end
		else
			PlayerData.LEnduranceGainModifiers.VitaminJunkieModifier = 1 + 0.75*EffectMod
			PlayerData.LEnduranceLossModifiers.VitaminJunkieModifier = 1 - 0.6*EffectMod
			if MoodleFR then
				MF.getMoodle("VitaminJunkie"):setValue(0.9)
			end
		end
	elseif PlayerData.LVitaminJunkieIntensity > 1 then
		PlayerData.LVitaminJunkieIntensity = PlayerData.LVitaminJunkieIntensity - 1
		if PlayerData.LVitaminJunkieIntensity <= 2 then
			PlayerData.LVitaminJunkieDuration = 360*DurationMod
		elseif PlayerData.LVitaminJunkieIntensity <= 4 then
			PlayerData.LVitaminJunkieDuration = 180*DurationMod
		elseif PlayerData.LVitaminJunkieIntensity <= 6 then
			PlayerData.LVitaminJunkieDuration = 90*DurationMod
		else
			PlayerData.LVitaminJunkieDuration = 45*DurationMod
		end
	else
		PlayerData.LEnduranceGainModifiers.VitaminJunkieModifier = 1
		PlayerData.LEnduranceLossModifiers.VitaminJunkieModifier = 1
		PlayerData.LVitaminJunkieIntensity = 0
		if MoodleFR then
			MF.getMoodle("VitaminJunkie"):setValue(0.5)
		end
	end
end

local function ActivateSecondWind()
	PlayerData.LSecondWindState = "Active"
	PlayerData.LSecondWindTimer = 45 + ZombRand(0,30)
	PlayerData.LSecondWindFatigueRemoved = Stats:getFatigue()*0.75
	Stats:setFatigue(Stats:getFatigue()*0.25)
	Stats:setPanic(Stats:getPanic()*0.5)
	local MissingEndurance = 1-Stats:getEndurance()
	Stats:setEndurance(1-MissingEndurance*.33)
	
	if MoodleFR then MF.getMoodle("SecondWind"):setValue(0.6) end
	PlayerData.LEnduranceLossModifiers.SecondWindModifier = 0.67
	PlayerData.LPanicGainModifiers.SecondWindModifier = 0.67
end

local function TraitSecondWind()
	if not PlayerData.LSecondWindState then PlayerData.LSecondWindState = "Ready" end
	if not PlayerData.LSecondWindTimer then PlayerData.LSecondWindTimer = 0 end
	if not PlayerData.LSecondWindFatigueRemoved then PlayerData.LSecondWindFatigueRemoved = 0 end
	
	local WindPoints = 0
	if Stats:getFatigue() >= 0.6 then WindPoints = WindPoints + 1 end
	if Stats:getFatigue() >= 0.7 then WindPoints = WindPoints + 1 end
	if Stats:getFatigue() >= 0.8 then WindPoints = WindPoints + 3 end
	if Stats:getFatigue() >= 0.9 then WindPoints = (WindPoints + 5)*2 end
	
	if Stats:getEndurance() <= 0.75 then WindPoints = WindPoints + 1 end
	if Stats:getEndurance() <= 0.5 then WindPoints = WindPoints + 2 end
	if Stats:getEndurance() <= 0.25 then WindPoints = (WindPoints + 3)*2 end
	if Stats:getEndurance() <= 0.1 then WindPoints = (WindPoints + 4)*2 end
	
	if PlayerData.LSecondWindState == "Ready" and WindPoints >= 3 and Player:isTargetedByZombie() then -- only activate 2nd wind if you can benefit from it, and are targetted by a zombie.
		Targets = Player:getSpottedList();
		local Buffer = 2
		for i = 0, Targets:size() - 1 do
            local v = Targets:get(i);
            if v:isZombie() and v:DistTo(Player) < 10 then
				if Buffer > 0 then
					Buffer = Buffer - 1 -- the first 2 zombies don't cause activation rolls
				elseif ZombRand(1,400) <= WindPoints then
					ActivateSecondWind() -- Each zombie the player sees within 10 tiles causes a roll to activate the perk.
				end
			end
        end
	elseif PlayerData.LSecondWindTimer > 0 then
			
		if not Player:isAsleep() then
			PlayerData.LSecondWindTimer = PlayerData.LSecondWindTimer - 1
		else --2nd wind recharges 4x faster if your asleep.
			PlayerData.LSecondWindTimer = PlayerData.LSecondWindTimer - 4
		end
		
		if PlayerData.LSecondWindTimer <= 0 then
			if PlayerData.LSecondWindState == "Active" then
				PlayerData.LSecondWindState = "Used"
				PlayerData.LSecondWindTimer = 60*32
				PlayerData.FatigueChange = PlayerData.LSecondWindFatigueRemoved*0.4
				PlayerData.LSecondWindFatigueRemoved = 0
			else
				PlayerData.LSecondWindState = "Ready"
			end
		end
	end

	if PlayerData.LSecondWindState == "Active" then
		if MoodleFR then MF.getMoodle("SecondWind"):setValue(0.6) end
		PlayerData.LEnduranceLossModifiers.SecondWindModifier = 0.67
		PlayerData.LPanicGainModifiers.SecondWindModifier = 0.67
	elseif PlayerData.LSecondWindState == "Ready" then
		if MoodleFR then MF.getMoodle("SecondWind"):setValue(0.5) end
		PlayerData.LEnduranceLossModifiers.SecondWindModifier = 1
		PlayerData.LPanicGainModifiers.SecondWindModifier = 1
	elseif PlayerData.LSecondWindState == "Used" then
		if MoodleFR then MF.getMoodle("SecondWind"):setValue(0.4) end
		PlayerData.LEnduranceLossModifiers.SecondWindModifier = 1
		PlayerData.LPanicGainModifiers.SecondWindModifier = 1
	end
end

local ADHDAddBored = 0
local ADHDTooDistractedThreshold = 99
local ADHDBoringActions = {"ISBuryCorpse","ISDismantleAction","ISReadABook","ISRepairClothing","ISWashClothing","ISWashYourself","ISCraftAction","ISBuildAction","ISMoveablesAction","ISUninstallVehiclePart","ISInstallVehiclePart"}
local ADHDBoredAvoidActions = {"ISReadABook","ISMoveablesAction","ISCraftAction","ISDismantleAction","ISUninstallVehiclePart","ISBuildAction","ISRepairClothing"}

local ADHDTooBoringQuotes = MakeTranslationsListInLuaTable("UI_ADHD_Distracted")
local ADHDOldBored
local BoredomFromReadingModifier = 0.5
local ADHDBoredomSkillMod = 1
local ADHDProfessionSpecialty = {1,1,1,1} -- Carpentry, Metalworking, Mechanics, Electrical
local ADHDProfessionsTable = {
constructionworker = {.6,.6,1,1},
carpenter = {.2,1,1,1},
repairman = {.6,1,1,.6},
lumberjack = {.6,1,1,1},
electrician = {1,1,1,.2},
metalworker = {1,.2,1,1},
mechanics = {1,0.6,.2,1},
engineer = {.6,.6,.6,.6},
}
function TraitADHDMinute()
	if not PlayerData.ADHDSuppressedTime then PlayerData.ADHDSuppressedTime = 0 end
	local SuppressedMod = 1
	if PlayerData.ADHDSuppressedTime > 0 then SuppressedMod = 0.5 end
	local BoredomFromActionsMod = 1
	BoredomFromReadingModifier = 0.5
	local Prof = Player:getDescriptor():getProfession()
	for i,v in pairs(ADHDProfessionsTable) do
		if i == Prof then
			ADHDProfessionSpecialty = v
		end
	end
	
	PlayerData.ADHDSuppressedTime = math.max(0,PlayerData.ADHDSuppressedTime-1)
	
	if not PlayerData.LBoredomGainModifiers.ADHDScaleModifier then PlayerData.LBoredomGainModifiers.ADHDScaleModifier = 1 end
	if not ADHDOldBored then ADHDOldBored = BodyDamage:getBoredomLevel() end
	local ADHDNewBored = BodyDamage:getBoredomLevel() 
	-- if you use panic to clear boredom, you'll get a panic gain penalty based on how much boredom was cleared. this decays over time but can stack up to a +200% peanlty if your not careful. (stacks multiplicitavely with the 2x modifier from the trait itself)
	if PlayerData.LBoredomGainModifiers.ADHDScaleModifier < 3 and ADHDNewBored - ADHDOldBored <= -25 and Stats:getPanic() > 0 then
		if PlayerData.LBoredomGainModifiers.ADHDScaleModifier + ADHDOldBored/150 <= 3 then
			PlayerData.LBoredomGainModifiers.ADHDScaleModifier = PlayerData.LBoredomGainModifiers.ADHDScaleModifier + ADHDOldBored/200 -- 50% penalty added if it clears 100% boredom.
		else
			PlayerData.LBoredomGainModifiers.ADHDScaleModifier = 3
		end
	end
	ADHDOldBored = ADHDNewBored
	
	if PlayerData.LBoredomGainModifiers.ADHDScaleModifier > 1 then
		if BodyDamage:getBoredomLevel() <= 0 then
			PlayerData.LBoredomGainModifiers.ADHDScaleModifier = PlayerData.LBoredomGainModifiers.ADHDScaleModifier - 1/180
		elseif BodyDamage:getBoredomLevel() > 10 then
			PlayerData.LBoredomGainModifiers.ADHDScaleModifier = PlayerData.LBoredomGainModifiers.ADHDScaleModifier - 1/720
		else
			PlayerData.LBoredomGainModifiers.ADHDScaleModifier = PlayerData.LBoredomGainModifiers.ADHDScaleModifier - 1/360
		end
		if PlayerData.LBoredomGainModifiers.ADHDScaleModifier < 1 then PlayerData.LBoredomGainModifiers.ADHDScaleModifier = 1 end
	end
	
	if BodyDamage:getBoredomLevel() <= 90 then ADHDTooDistractedThreshold = 99 end
	--if not Player:hasTimedActions() or not TableCheck(ADHDBoringActions,Player:getCharacterActions():get(0):getMetaType()) then
		-- ADHDAddBored = 0
	--end
	print(BodyDamage:getBoredomLevel() + PlayerData.BoredomChange*100)
	if PlayerData.ADHDSuppressedTime > 0 and BodyDamage:getBoredomLevel() + PlayerData.BoredomChange*100 > 50 then
		ADHDAddBored = 0
	end
	if ADHDAddBored ~= 0 then
		if Player:isOutside() then ADHDAddBored = ADHDAddBored*2 end -- theres some wierd shinanagains going on with indoors and outdoors. while indoors and doing a timed action it looks like the boredom gain stops.. but then it re-enables when adding boredom. causing it to gain a lot more than it should.
		PlayerData.BoredomChange = PlayerData.BoredomChange + ADHDAddBored*BoredomFromActionsMod*SuppressedMod
		ADHDAddBored = 0
	end
end
--local HammerTable = getScriptManager():getItemsTag("Hammer") -- pulls a janky list of all items with the tag. do it the other way around if you can.
--Profession table order;
--Carpentry Metalworking Mechanics Electrical

function ADHDGetProfSkillModifier(action)
	local Mod = 1
	local actionType = action:getMetaType()
	local PrimaryItem = Player:getPrimaryHandItem()
	local SecondaryItem = Player:getSecondaryHandItem()
	
	
	--if PrimaryItem then print(PrimaryItem:getTags()) end
	
	if actionType == "ISBuildAction" or actionType == "ISCraftAction" or actionType == "ISMoveablesAction" or actionType == "ISDismantleAction" then
		if PrimaryItem and PrimaryItem:getTags():contains("Hammer") then
			Mod = Mod * (1-0.05*Player:getPerkLevel(Perks.Woodwork)) * ADHDProfessionSpecialty[1]
		elseif PrimaryItem and PrimaryItem:getType() == "BlowTorch" then
			Mod = Mod * (1-0.05*Player:getPerkLevel(Perks.MetalWelding)) * ADHDProfessionSpecialty[2]
		elseif PrimaryItem and PrimaryItem:getTags():contains("Screwdriver") then
			Mod = Mod * (1-0.05*Player:getPerkLevel(Perks.Electricity)) * ADHDProfessionSpecialty[4]
		elseif SecondaryItem and SecondaryItem:getTags():contains("Hammer") then -- primary items failed, try secondary hand items.
			Mod = Mod * (1-0.05*Player:getPerkLevel(Perks.Woodwork)) * ADHDProfessionSpecialty[1]
		elseif SecondaryItem and SecondaryItem:getType() == "BlowTorch" then
			Mod = Mod * (1-0.05*Player:getPerkLevel(Perks.MetalWelding)) * ADHDProfessionSpecialty[2]
		elseif SecondaryItem and SecondaryItem:getTags():contains("Screwdriver") then
			Mod = Mod * (1-0.05*Player:getPerkLevel(Perks.Electricity)) * ADHDProfessionSpecialty[4]
		end
	elseif actionType == "ISUninstallVehiclePart" or actionType == "ISInstallVehiclePart" then
		Mod = Mod * (1-0.05*Player:getPerkLevel(Perks.Mechanics)) * ADHDProfessionSpecialty[3]
	elseif actionType == "ISRepairClothing" then
		Mod = Mod * (1-0.05*Player:getPerkLevel(Perks.Tailoring))
	elseif actionType == "ISReadABook" then
		Mod = Mod*BoredomFromReadingModifier
	end
	return Mod
end

function CheckItemsReduceBoredom(Table)
	for i,v in pairs(Table) do
		if v and v:getBoredomChange() and v:getBoredomChange() < 0 then
			--print("Item Reduces Boredom")
			return true
		end
	end
	return false
end

function LGetPlayersInLuaTable()
	if not isClient() and not isServer() then
		local Table = {}
		for i=0, getNumActivePlayers()-1 do
			table.insert(Table,getSpecificPlayer(i))
		end
		return Table
	else
		local Players = getOnlinePlayers()
		local Table = {}
		for i=0,Players:size()-1 do
			table.insert(Table,Players:get(i))
		end
		return Table
	end
end

local CodepMaxAlone = 1440
local CodepStartTime = 180
local CodepUnhapHrMax = 0.25
local CodepMFThreshold = 1 - CodepStartTime/CodepMaxAlone -- 0.125
function TraitCodependant()
	if not PlayerData.TimeAlone then PlayerData.TimeAlone = 0 end
	local CodependentUnhappinessModifier = 1
	local Players = LGetPlayersInLuaTable()
	local Closest = 9999
	for i,v in pairs(Players) do
		local Dist = v:DistTo(Player)
		if Dist > 0.35 and Dist < 20 and Dist < Closest then
			Closest = Dist
		end
	end
	if Closest >= 20 then
		PlayerData.TimeAlone = math.min(CodepMaxAlone,PlayerData.TimeAlone + 1)
		if PlayerData.TimeAlone > CodepStartTime then
			local CoDepGain = ((CodepUnhapHrMax/60)*((PlayerData.TimeAlone-CodepStartTime)/(CodepMaxAlone-CodepStartTime))^2)*CodependentUnhappinessModifier
			PlayerData.UnhappyChange = PlayerData.UnhappyChange + CoDepGain
		end
		if MoodleFR then
			MF.getMoodle("Codependant"):setChevronCount(1)
			MF.getMoodle("Codependant"):setChevronIsUp(true)
		end
	elseif Closest >= 10 then -- 10 to 20
		PlayerData.TimeAlone = math.max(0,PlayerData.TimeAlone*0.99 - 1)
		if MoodleFR then
			MF.getMoodle("Codependant"):setChevronCount(1)
			MF.getMoodle("Codependant"):setChevronIsUp(false)
		end
	elseif Closest >= 5 then -- 5 to 10
		PlayerData.TimeAlone = math.max(0,PlayerData.TimeAlone*0.97 - 3)
		if MoodleFR then
			MF.getMoodle("Codependant"):setChevronCount(2)
			MF.getMoodle("Codependant"):setChevronIsUp(false)
		end
	elseif Closest > 0.5 then -- 0.5 to 5
		PlayerData.TimeAlone = math.max(0,PlayerData.TimeAlone*0.95 - 5)
		if MoodleFR then
			MF.getMoodle("Codependant"):setChevronCount(3)
			MF.getMoodle("Codependant"):setChevronIsUp(false)
		end
	end
	if Closest < 10 and PlayerData.TimeAlone <= 180 and BodyDamage:getUnhappynessLevel() > 65 then
		PlayerData.UnhappyChange = PlayerData.UnhappyChange - CodepUnhapHrMax/60*CodependentUnhappinessModifier
	end
	if MoodleFR then
		MF.getMoodle("Codependant"):setValue(1-(PlayerData.TimeAlone/CodepMaxAlone))
		MF.getMoodle("Codependant"):setThresholds(CodepMFThreshold*0.1,CodepMFThreshold*0.4,CodepMFThreshold*0.7,CodepMFThreshold,nil,nil,nil,nil)
	end
end

function TraitBetrayed()
	if not PlayerData.BetrayFear then PlayerData.BetrayFear = 0 end
	local FearToAdd = 0
	local BetrayedStressModifier = 1
	local HasWeapon = false
	local HasGun = false
	if Player:getPrimaryHandItem() then
		if Player:getPrimaryHandItem():IsWeapon() then
			HasWeapon = true
			if Player:getPrimaryHandItem():getReloadTime() and Player:getPrimaryHandItem():getReloadTime() > 0 then
				HasGun = true
			end
		end
	end
	
	local Players = LGetPlayersInLuaTable()
	local NearPlayersDistances = {}
	for i,v in pairs(Players) do
		local Dist = v:DistTo(Player)
		if Dist > 0.35 and Dist < 20 then -- players within 20 tiles are added to this list
			table.insert(NearPlayersDistances,Dist)
		end
	end
	
	local BetrayedMaxFear = 50
	local BetrayedFearPoints = 0
	if #NearPlayersDistances > 0 then -- any players within 20 tiles trigger this, but only players within 15 tiles add fear.
		for i,v in pairs(NearPlayersDistances) do
			if v <= 5 then
				FearToAdd = FearToAdd + 6
				BetrayedMaxFear = BetrayedMaxFear + 20
			elseif v <= 10 then
				FearToAdd = FearToAdd + 3
				BetrayedMaxFear = BetrayedMaxFear + 15
			elseif v <= 15 then
				FearToAdd = FearToAdd + 1
				BetrayedMaxFear = BetrayedMaxFear + 5
			end
		end
		if HasGun then 
			FearToAdd = FearToAdd * 0.35
		elseif HasWeapon then 
			FearToAdd = FearToAdd * 0.5
		end
	elseif HasWeapon or PlayerData.BetrayFear > 50 then -- no players within 20 tiles, and either holding a weapon or high fear
		FearToAdd = -PlayerData.BetrayFear*0.05 - 1
		if MoodleFR then
			MF.getMoodle("Betrayed"):setChevronCount(2)
			MF.getMoodle("Betrayed"):setChevronIsUp(false)
		end
	elseif PlayerData.BetrayFear < 50 then -- no players within 20 tiles, not holding a weapon, and below 50 fear
		FearToAdd = FearToAdd + 1
	end
	--print("FearToAdd: "..FearToAdd)
	if BetrayedMaxFear >= 90 then
		if MoodleFR then
			MF.getMoodle("Betrayed"):setChevronCount(4)
			MF.getMoodle("Betrayed"):setChevronIsUp(true)
		end
	elseif BetrayedMaxFear >= 80 then
		if MoodleFR then
			MF.getMoodle("Betrayed"):setChevronCount(3)
			MF.getMoodle("Betrayed"):setChevronIsUp(true)
		end
	elseif BetrayedMaxFear >= 65 then
		if MoodleFR then
			MF.getMoodle("Betrayed"):setChevronCount(2)
			MF.getMoodle("Betrayed"):setChevronIsUp(true)
		end
	elseif BetrayedMaxFear >= 51 then
		if MoodleFR then
			MF.getMoodle("Betrayed"):setChevronCount(1)
			MF.getMoodle("Betrayed"):setChevronIsUp(true)
		end
	end
	if PlayerData.BetrayFear + FearToAdd >= BetrayedMaxFear and FearToAdd > 0 then
		FearToAdd = 0
		PlayerData.BetrayFear = BetrayedMaxFear
	end
	PlayerData.BetrayFear = math.min(100,math.max(0,PlayerData.BetrayFear + FearToAdd)) -- clamp value between 0 and 100.
	--print("BetrayFear: "..PlayerData.BetrayFear)
	if (PlayerData.BetrayFear > 10 and Stats:getStress() < 50) or PlayerData.BetrayFear > 50 then
		PlayerData.StressChange = PlayerData.StressChange + ((PlayerData.BetrayFear/100)^2.5*2/60)*BetrayedStressModifier --Percentage^1.25*MaxStress/PerHR
	end
	if MoodleFR then
		MF.getMoodle("Betrayed"):setValue(1-(PlayerData.BetrayFear/100))
		MF.getMoodle("Betrayed"):setThresholds(0.1,0.34,0.49,0.9,nil,nil,nil,nil)
	end
end


function TraitAnabolic()
	local Protein = Player:getNutrition():getProteins()
	if Protein > 300 then
		Burning = 1 + (Protein - 300)*0.02
		Player:getNutrition():setProteins(Protein-Burning)
		Player:getXp():AddXP(Perks.Strength, Burning*9, false, false, false)
	end
	if Player:getCurrentState() == FitnessState.instance() then
		PlayerData.StressChange = PlayerData.StressChange - 0.7/60
		PlayerData.UnhappyChange = PlayerData.UnhappyChange - 0.5/60
	end
end

local function getZoneType(_x, _y) -- stolen from official lua foraging code. (ISZoneDisplay.lua)
	local zones = getWorld():getMetaGrid():getZonesAt(_x, _y, 0);
	if zones then
		for i = zones:size(),1,-1 do
			local zone = zones:get(i-1);
			if zone then
				if forageSystem.zoneDefs[zone:getType()] then
					return zone:getType();
				end;
			end;
		end;
	end;
	return "Unknown";
end
function IsPlayerFishing()
	if Player:hasTimedActions() then
		local Actions = Player:getCharacterActions()
		local Action = Actions:get(0)
		if Action then
			--print(Action:getMetaType())
			if Action:getMetaType() == "ISFishingAction" then
				return true
			end
		end
	end
	return false
end
local UrbanZones = {"TownZone","Nav","TrailerPark","Unknown"}
--[[
TownZone -- Urban Area
Nav -- Road
Forest -- Forest
DeepForest -- Deep Forest
Vegitation -- Vegitation
TrailerPark -- Trailer Park
FarmLand -- Farm Land
]]--
function TraitBushman()
	if not PlayerData.LBushmanValue then PlayerData.LBushmanValue = 0 end
	local XPScaleTime = 2
	local CurrentZone = getZoneType(Player:getX(),Player:getY())
	local IsFishing = IsPlayerFishing()
	--print(CurrentZone)
	if not TableCheck(UrbanZones,CurrentZone) or IsFishing then
		PlayerData.LBushmanValue = math.min(PlayerData.LBushmanValue + 1,XPScaleTime*1440)
	else
		PlayerData.LBushmanValue = math.min(math.max(0,PlayerData.LBushmanValue - 1),XPScaleTime*1440)
	end
	if IsFishing then
		PlayerData.LBushmanValue = math.min(PlayerData.LBushmanValue + 1,XPScaleTime*1440)
		PlayerData.StressChange = PlayerData.StressChange - 0.50/60
		PlayerData.UnhappyChange = PlayerData.UnhappyChange - 0.30/60
	end
end


local JuggDmgS = 0.05
local JuggCritDmg = 0.1
local JuggCritRate = 0.01
local JuggTileRange = 0.03
local JuggDurability = 0.05

local PsychoDmgS = 0.1
local PsychoCritDmg = 0.2
local PsychoCritRate = 0.06
local PsychoDurability = 0.2

local SpartainDmgS = 0.1
local SpartainDurability = 0.4

function UpdateJuggPsychoBases()
	JuggDmgS =  0.05
	JuggCritDmg =  0.1
	JuggCritRate = 0.01
	JuggDurability = 0.05

	PsychoDmgS = 0.1
	PsychoCritDmg = 0.2
	PsychoCritRate =  0.06
	PsychoDurability = 0.2
	
	SpartainDmgS = 0.1
	SpartainDurability = 0.4
end


local StringBoostedBy = getText("UI_Tooltip_BoostedBy")
local StringDamage = getText("UI_Tooltip_Damage")
local StringCritDamage = getText("UI_Tooltip_CritDamage")
local StringCritChance = getText("UI_Tooltip_CritChance")
local StringDurability = getText("UI_Tooltip_Durability")
local StringMaxHits = getText("UI_Tooltip_MaxHits")
local StringDoorDamage = getText("UI_Tooltip_DoorDamage")
local StringEnduranceLoss = getText("UI_Tooltip_EnduranceLoss")
local StringMinRange = getText("UI_Tooltip_MinRange")
local StringMaxRange = getText("UI_Tooltip_MaxRange")

function MakeJuggernautTooltip(ws,th) -- Weapon Skill, Two Handed
	local JuggDmgS = JuggDmgS*100
	local JuggCritDmg = JuggCritDmg*100
	local JuggCritRate = JuggCritRate*100
	local JuggDurability = JuggDurability*100
	
	
	local String = StringBoostedBy.." "..getText("UI_Trait_Juggernaut")..";"
	
	String = String.. "\n  "..StringDamage..": +".. 10+JuggDmgS*ws .."%"
	
	if ws > 0 then String = String.. "\n  "..StringCritChance..": +".. ws*JuggCritRate .."%" end
	
	if ws > 0 or th then
		local i = 0
		if th then i = 50 end
		String = String.. "\n  "..StringCritDamage..": +".. i+ws*JuggCritDmg .."%"
	end
	
	if ws > 0 then String = String.. "\n  "..StringDurability..": +".. JuggDurability*ws .."%" end
	
	if ws >= 8 then
		String = String.. "\n  "..StringMaxHits..": +2"
	elseif ws >= 4 then
		String = String.. "\n  "..StringMaxHits..": +1"
	end
	
	if th then
		if ws > 0 then String = String.. "\n  "..StringMaxRange..": +".. JuggTileRange*ws end
		String = String.. "\n  "..StringDoorDamage..": +".. 15+ws*2
	end
	
	String = String.. "\n  "..StringEnduranceLoss..": +35%"
	
	return String
end

function MakePsychopathTooltip(ws)
	local PsychoDmgS = PsychoDmgS*100
	local PsychoCritDmg = PsychoCritDmg*100
	local PsychoCritRate = PsychoCritRate*100
	local PsychoDurability = PsychoDurability*100
	
	local String = StringBoostedBy.." "..getText("UI_Trait_Psychopath")..";"
	
	String = String.. "\n  "..StringDamage..": +".. 20+PsychoDmgS*ws .."%"
	
	if ws > 0 then String = String.. "\n  "..StringCritChance..": +".. ws*PsychoCritRate .."%" end
	
	String = String.. "\n  "..StringCritDamage..": +".. 50+ws*PsychoCritDmg .."%"
	
	if ws > 0 then String = String.. "\n  "..StringDurability..": +".. PsychoDurability*ws .."%" end
	
	
	return String
end

function MakeSpartainTooltip(ws)
	local SpartainDmgS = SpartainDmgS*100
	local SpartainDurability = SpartainDurability*100
	
	local String = StringBoostedBy.." "..getText("UI_Trait_Spartan")..";"
	
	if ws > 0 then String = String.. "\n  "..StringDamage..": +".. SpartainDmgS*ws .."%" end
	
	if ws > 0 then String = String.. "\n  "..StringDurability..": +".. SpartainDurability*ws .."%" end
	
	if ws >= 10 then
		String = String.. "\n  "..StringMaxHits..": +2"
	elseif ws >= 6 then
		String = String.. "\n  "..StringMaxHits..": +1"
	end
	if ws > 0 then String = String.. "\n  "..StringMinRange..": -".. 0.04*ws end
	if ws > 0 then String = String.. "\n  "..StringMaxRange..": +".. 0.02*ws end
	
	return String
end

function JuggCheck(Item)
	if Item:getCategories():contains("Blunt") then
		return true
	elseif Item:getCategories():contains("SmallBlunt") then
		return true
	elseif Item:getCategories():contains("Axe") then
		return true
	end
	return false
end

function PsychoCheck(Item)
	if Item:getCategories():contains("LongBlade") then
		return true
	elseif Item:getCategories():contains("SmallBlade") then
		return true
	else
		return false
	end
end

function SpartainCheck(Item)
	if Item:getCategories():contains("Spear") then
		return true
	else
		return false
	end
end
local BerRushInit = false
local function UpdateHeldWeapon()
	local Item = Player:getPrimaryHandItem()
	local WeaponSkill = GetWeaponPerkLevel(Item)
	if WeaponSkill >= 0 then
		local imd = Item:getModData()
		if not imd.LStatsLogged or not imd.LSwingTime then -- stole this idea from More Traits. it works on items too. just be careful about modded weapons not having their values set which would break it.
		-- btw, if your reading this. there a loop in your elseif statement for expert driver. the sState gets set to "Expert Driver" which causes the next check to fail its sState ~= "Expert Driver" and the following elseif to change it back to normal. causing it to toggle between them. it wasnt aparent to me until i noticed it happening to the items.
			local imd = Item:getModData()
			imd.LMinDamage = Item:getMinDamage()
			imd.LMaxDamage = Item:getMaxDamage()
			imd.LCriticalChance = Item:getCriticalChance()
			imd.LCritDmgMultiplier = Item:getCritDmgMultiplier()
			imd.LMaxHitCount = Item:getMaxHitCount()
			imd.LDoorDamage = Item:getDoorDamage()
			imd.LMinRange = Item:getMinRange()
			imd.LMaxRange = Item:getMaxRange()
			imd.LSwingTime = Item:getSwingTime()
			imd.LBaseSpeed = Item:getBaseSpeed()
			imd.LMinimumSwingTime = Item:getMinimumSwingTime()
			imd.LEnduranceMod = Item:getEnduranceMod()
			imd.LConditionLowerChance = Item:getConditionLowerChance()
			imd.LTooltip = Item:getTooltip()
			imd.LUserSkill = 0
			imd.LState = "Normal"
			imd.LStatsLogged = true
		end
		if Player:HasTrait("berserker") then
			if PlayerData.BerRushStacks > 0 then
				if not imd.BerRushInit then
					imd.LBerSwingTime = Item:getSwingTime()
					imd.LBerBaseSpeed = Item:getBaseSpeed()
					imd.LBerMinimumSwingTime = Item:getMinimumSwingTime()
				end
				imd.BerRushInit = true
				local rushmod = 0.1*PlayerData.BerRushStacks
				Item:setSwingTime(imd.LBerSwingTime - rushmod)
				Item:setBaseSpeed(imd.LBerBaseSpeed + rushmod)
				Item:setMinimumSwingTime(imd.LBerMinimumSwingTime - rushmod)
			elseif imd.BerRushInit then
				Item:setSwingTime(imd.LBerSwingTime)
				Item:setBaseSpeed(imd.LBerBaseSpeed)
				Item:setMinimumSwingTime(imd.LBerMinimumSwingTime)
				imd.BerRushInit = false
			end
		end
		if Player:HasTrait("juggernaut") and JuggCheck(Item) and (imd.LState ~= "Juggernaut" or imd.LUserSkill ~= WeaponSkill) then
			Item:setMinDamage(imd.LMinDamage*(1.1+WeaponSkill*JuggDmgS))
			Item:setMaxDamage(imd.LMaxDamage*(1.1+WeaponSkill*JuggDmgS))
			Item:setCriticalChance(imd.LCriticalChance + WeaponSkill*JuggCritRate)
			Item:setConditionLowerChance(imd.LConditionLowerChance*(1+WeaponSkill*JuggDurability))
			--print("Making Juggernaut Weapon")
			if WeaponSkill >= 8 then
				Item:setMaxHitCount(imd.LMaxHitCount+2)
			elseif WeaponSkill >= 4 then
				Item:setMaxHitCount(imd.LMaxHitCount+1)
			else
				Item:setMaxHitCount(imd.LMaxHitCount)
			end
			
			local JuggTip
			if Player:getPrimaryHandItem() == Player:getSecondaryHandItem() then
				Item:setEnduranceMod(imd.LEnduranceMod*1.35)
				Item:setDoorDamage(imd.LDoorDamage + 15 + (2*WeaponSkill))
				Item:setMaxRange(imd.LMaxRange+WeaponSkill*JuggTileRange)
				Item:setCritDmgMultiplier(imd.LCritDmgMultiplier + 0.5 + WeaponSkill*JuggCritDmg)
				JuggTip = MakeJuggernautTooltip(WeaponSkill,true)
			else
				Item:setEnduranceMod(imd.LEnduranceMod*1.35)
				Item:setCritDmgMultiplier(imd.LCritDmgMultiplier + WeaponSkill*JuggCritDmg)
				JuggTip = MakeJuggernautTooltip(WeaponSkill,false)
			end
			
			if EvenMoreTraits.settings.TooltipBehavior == 1 then
				Item:setTooltip(JuggTip)
			elseif EvenMoreTraits.settings.TooltipBehavior == 2 then
				if imd.LTooltip then
					Item:setTooltip(imd.LTooltip.."\n"..JuggTip)
				else
					Item:setTooltip(JuggTip)
				end
			elseif EvenMoreTraits.settings.TooltipBehavior == 3 then
				if not imd.LTooltip then
					Item:setTooltip(JuggTip)
				end
			end
			
			imd.LUserSkill = WeaponSkill
			imd.LState = "Juggernaut"
		end
		if Player:HasTrait("psychopath") and PsychoCheck(Item) and (imd.LState ~= "Psychopath" or imd.LUserSkill ~= WeaponSkill) then
			Item:setMinDamage(imd.LMinDamage*(1.2+WeaponSkill*PsychoDmgS))
			Item:setMaxDamage(imd.LMaxDamage*(1.2+WeaponSkill*PsychoDmgS))
			Item:setCriticalChance(imd.LCriticalChance + WeaponSkill*PsychoCritRate)
			Item:setCritDmgMultiplier(imd.LCritDmgMultiplier + WeaponSkill*PsychoCritDmg)
			Item:setConditionLowerChance(imd.LConditionLowerChance*(1+WeaponSkill*PsychoDurability))
			
			local PsychoTip
			
			PsychoTip = MakePsychopathTooltip(WeaponSkill)
			
			if EvenMoreTraits.settings.TooltipBehavior == 1 then
				Item:setTooltip(PsychoTip)
			elseif EvenMoreTraits.settings.TooltipBehavior == 2 then
				if imd.LTooltip then
					Item:setTooltip(imd.LTooltip.."\n"..PsychoTip)
				else
					Item:setTooltip(PsychoTip)
				end
			elseif EvenMoreTraits.settings.TooltipBehavior == 3 then
				if not imd.LTooltip then
					Item:setTooltip(PsychoTip)
				end
			end
			imd.LUserSkill = WeaponSkill
			imd.LState = "Psychopath"
		end
		
		if Player:HasTrait("lspartain") and SpartainCheck(Item) and (imd.LState ~= "Spartain" or imd.LUserSkill ~= WeaponSkill) then
			Item:setMinDamage(imd.LMinDamage*(1+WeaponSkill*SpartainDmgS))
			Item:setMaxDamage(imd.LMaxDamage*(1+WeaponSkill*SpartainDmgS))
			Item:setMinRange(imd.LMinRange - 0.04*WeaponSkill)
			Item:setMaxRange(imd.LMaxRange + 0.02*WeaponSkill)
			Item:setConditionLowerChance(imd.LConditionLowerChance*(1+WeaponSkill*SpartainDurability))
			
			if WeaponSkill >= 8 then
				Item:setMaxHitCount(imd.LMaxHitCount+2)
			elseif WeaponSkill >= 4 then
				Item:setMaxHitCount(imd.LMaxHitCount+1)
			else
				Item:setMaxHitCount(imd.LMaxHitCount)
			end
			
			
			local SpartainTip
			SpartainTip = MakeSpartainTooltip(WeaponSkill)
			
			if EvenMoreTraits.settings.TooltipBehavior == 1 then
				Item:setTooltip(SpartainTip)
			elseif EvenMoreTraits.settings.TooltipBehavior == 2 then
				if imd.LTooltip then
					Item:setTooltip(imd.LTooltip.."\n"..SpartainTip)
				else
					Item:setTooltip(SpartainTip)
				end
			elseif EvenMoreTraits.settings.TooltipBehavior == 3 then
				if not imd.LTooltip then
					Item:setTooltip(SpartainTip)
				end
			end
			imd.LUserSkill = WeaponSkill
			imd.LState = "Spartain"
		end
		--print("BaseLower: "..imd.LConditionLowerChance)
		--print("CondLower: "..Item:getConditionLowerChance())
		if (not Player:HasTrait("juggernaut") or not JuggCheck(Item)) and imd.LState == "Juggernaut" or
		(not Player:HasTrait("psychopath") or not PsychoCheck(Item)) and imd.LState == "Psychopath" or 
		(not Player:HasTrait("lspartain") or not SpartainCheck(Item)) and imd.LState == "Spartain" then
			Item:setMinDamage(imd.LMinDamage)
			Item:setMaxDamage(imd.LMaxDamage)
			Item:setCriticalChance(imd.LCriticalChance)
			Item:setCritDmgMultiplier(imd.LCritDmgMultiplier)
			Item:setMaxHitCount(imd.LMaxHitCount)
			Item:setDoorDamage(imd.LDoorDamage)
			Item:setSwingTime(imd.LSwingTime)
			Item:setBaseSpeed(imd.LBaseSpeed)
			Item:setMaxRange(imd.LMaxRange)
			Item:setMinimumSwingTime(imd.LMinimumSwingTime)
			Item:setConditionLowerChance(imd.LConditionLowerChance)
			Item:setTooltip(imd.LTooltip)
			
			Item:setEnduranceMod(imd.LEnduranceMod)
			imd.LState = "Normal"
		end
	end
end
--onkill
local function LOnZombieDeath(Zombie)
	if Player:HasTrait("berserker") and Zombie:getModData().LKiller and Zombie:getModData().LKiller == Player and GetWeaponPerkLevel(Player:getPrimaryHandItem()) and Zombie:DistTo(Player) <= 3 then
		local CurrentEndurance = Stats:getEndurance();
		local CurrentHunger = Stats:getHunger();
		local EnduranceMod = 1
			
		local Base  = 0.15/100
		local Scale = 0.015/100
		local Ammount = (Base + Scale*PlayerData.BerzerkerStreak)*EnduranceMod
		if SandboxVars.EvenMoreTraits.BerserkerEnableHunger then
			Ammount = Ammount*(1-Stats:getHunger())^1.25
		end	
			
		if CurrentEndurance + Ammount > 1 then
			Ammount = 1-CurrentEndurance -- reduce the amount to hit the endurance cap so we arent burning extra hunger and fatigue.
		end
		if Ammount > 0 then
			Stats:setEndurance(CurrentEndurance + Ammount);
		end
		
		
		PlayerData.BerzerkerStreak = PlayerData.BerzerkerStreak + 1
		if PlayerData.BerzerkerStreak > BerMaximumStreak then
			PlayerData.BerzerkerStreak = BerMaximumStreak
		elseif PlayerData.BerzerkerStreak < 0 then
			PlayerData.BerzerkerStreak = 0
		end
		if PlayerData.BerzerkerStreak > BerMaximumStreak*RageThreshhold then
			if CurrentHunger < 0.45 and RageChatCooldown <= 0 then
				if not RageAlert then
					if EvenMoreTraits.settings.BerserkerTalking then
						SayQuote(ZerkQuotesRage)
					end
					if SandboxVars.EvenMoreTraits.BerserkerShoutingNoise then
						addSound(Player, Player:getX(), Player:getY(), Player:getZ(), 85, 75);	
					end
					RageChatCooldown = 500
					RageAlert = true
				elseif ZombRand(RageRepeatChance) == 0 then
					if EvenMoreTraits.settings.BerserkerTalking then
						SayQuote(ZerkQuotesRage)
					end
					if SandboxVars.EvenMoreTraits.BerserkerShoutingNoise then
						addSound(Player, Player:getX(), Player:getY(), Player:getZ(), 85, 75);	
					end
					RageChatCooldown = 500
				end
			elseif SandboxVars.EvenMoreTraits.BerserkerEnableHunger and CurrentHunger >= 0.45 and HungerChatCooldown <= 0 then
				if not HungerWarn then
					if EvenMoreTraits.settings.BerserkerTalking then
						SayQuote(ZerkQuotesHungry)
					end
					HungerChatCooldown = 500
					HungerWarn = true
				elseif ZombRand(HungerRepeatChance) == 0 then
					if EvenMoreTraits.settings.BerserkerTalking then
						SayQuote(ZerkQuotesHungry)
					end
					HungerChatCooldown = 500
				end
			end
		end
		if PlayerData.BerzerkerStreak >= BerMaximumStreak then -- i want to eventually add more buffs to this.
			
			if Stats:getEndurance() < 0.75 then
				OverheadCooldown = 150
				PlayerData.BerzerkerStreak = PlayerData.BerzerkerStreak - 30
				PlayerData.EnduranceChange = PlayerData.EnduranceChange + 0.25
				
				if EvenMoreTraits.settings.BerserkerTalking then
					SayQuote(ZerkQuoteRush)
				end
				
				HaloTextHelper.addTextWithArrow(Player, getText("UI_Berserker_AdrenalineEndurance").." ", true, HaloTextHelper.getColorGreen());
				HaloTextHelper.addTextWithArrow(Player, " -30 "..getText("UI_Berserker_BerserkerStreakShort") , false, HaloTextHelper.getColorRed());
			elseif PlayerData.BerRushStacks < 5 then
				OverheadCooldown = 150
				PlayerData.BerzerkerStreak = PlayerData.BerzerkerStreak - 30
				PlayerData.BerRushStacks = PlayerData.BerRushStacks + 1
				if EvenMoreTraits.settings.BerserkerTalking then
					SayQuote(ZerkQuoteRush)
				end
				
				HaloTextHelper.addTextWithArrow(Player, getText("UI_Berserker_AdrenalineAttackSpeed").." ", true, HaloTextHelper.getColorGreen());
				HaloTextHelper.addTextWithArrow(Player, " -30 "..getText("UI_Berserker_BerserkerStreakShort") , false, HaloTextHelper.getColorRed());
			end
			
		end
	
		if SandboxVars.EvenMoreTraits.BerserkerEnableFatigue and PlayerData.BerzerkerStreak >= BerMaximumStreak*RageThreshhold then
			PlayerData.BerzerkerFatigueAmmount = PlayerData.BerzerkerFatigueAmmount + Ammount*0.05 --  5% of gained stamina is eventually added to your fatigue.
		end
		if SandboxVars.EvenMoreTraits.BerserkerEnableHunger then
			if Stats:getHunger() + PlayerData.HungerChange <= 0.45 and PlayerData.BerzerkerStreak >= BerMaximumStreak*RageThreshhold then
				PlayerData.HungerChange = PlayerData.HungerChange + Ammount*0.15 -- 15% of gained stamina is added to your hunger.
			end
		end
		BerzerkerStreakDecay = 1500;
		PlayerData.BerzerkerStreakDecayAmmont = 1;
		if EvenMoreTraits.settings.BerserkerDisplayStreak and OverheadCooldown <= 0 then
			HaloTextHelper.addTextWithArrow(Player, getText("UI_Berserker_BerserkerStreak")..": "..PlayerData.BerzerkerStreak , true, HaloTextHelper.getColorGreen());
			OverheadCooldown = 200
		end
	end
	if Player:HasTrait("psychopath") and Zombie:getModData().LKiller and Zombie:getModData().LKiller == Player then
		PlayerData.StressChange = PlayerData.StressChange - 0.05
		PlayerData.UnhappyChange = PlayerData.UnhappyChange - 0.02
	end
	if Player:HasTrait("lspartain") and Zombie:getModData().LKiller and Zombie:getModData().LKiller == Player then
		Stats:setPanic(Stats:getPanic()*0.75)
	end
	if Player:HasTrait("lquicksilver") and Zombie:getModData().LKiller and Zombie:getModData().LKiller == Player and not Player:isDriving() and Zombie:DistTo(Player) <= 3 then
		local XPonKill = true
		if XPonKill then
			Player:getXp():AddXP(Perks.Nimble, Player:getPerkLevel(Perks.Nimble)*0.25, true, false, false)
		end
	end
end
--onhit
local function OnWeaponHitSomething(Target, Actor, bodyparttype, Weapon)
	Target:getModData().LKiller = Actor
	if Actor == Player then 
		if Player:HasTrait("berserker") and (GetWeaponPerkLevel(Player:getPrimaryHandItem()) > -1 or Weapon:getType() == "BareHands") then
			if BerzerkerStreakDecay < 500 then BerzerkerStreakDecay = 500 end -- prevent stacks from decaying as long as your actively fighting things
			if PlayerData.BerzerkerStreak > BerMaximumStreak*RageThreshhold and (not SandboxVars.EvenMoreTraits.BerserkerEnableHunger or Stats:getHunger() < 0.45) then
				local SandboxMod = SandboxVars.EvenMoreTraits.BerserkerRageDamageMultiplier or 1
				local Scale = (PlayerData.BerzerkerStreak - (BerMaximumStreak*RageThreshhold)) / (BerMaximumStreak-(BerMaximumStreak*RageThreshhold))
				local BaseDmg = 0.1 + 0.15*Scale
				local Dmg = 0.1
				local EnduranceModifier = Stats:getEndurance()^1.5
				local HungerModifier = (1-Stats:getHunger())^1.25
				local PanicModifier = 0.5 + 0.5*(1-(Stats:getPanic()/100))
				
				if Weapon:getType() == "BareHands" then
					Dmg = BaseDmg*GetStrengthDamageModifier()*0.5 --the x0.5 modifier is to mimic a level 2 weapon skill, since there is no unarmed skill.
				else
					Dmg = BaseDmg*CalcDamageMod(Player:getPrimaryHandItem())
				end
				Dmg = Dmg*EnduranceModifier*SandboxMod
				
				if Dmg > 0.99 then Dmg = 0.99 end
				
				Target:setHealth(Target:getHealth()*(1-Dmg))
				
				if Target:getHealth() <= 0 then
					Target:update()
				end
			end
		end
		if Player:HasTrait("juggernaut") then
			if EvenMoreTraits.settings.JuggernautTwoHandedKnockbackHits and Stats:getEndurance() > 0.75 and Weapon == Player:getPrimaryHandItem() and Weapon == Player:getSecondaryHandItem() and GetWeaponPerkLevel(Weapon) and JuggCheck(Weapon) then
				Target:setStaggerBack(true)
			end
			if Weapon:getType() == "BareHands" then
				if PlayerData.LBareHandsWeapon == nil then
					PlayerData.LBareHandsWeapon = Weapon
				end
				PlayerData.LBareHandsWeapon:setMinAngle(0.35) -- base 0.5
				PlayerData.LBareHandsWeapon:setMaxRange(1.25) -- base 1.1
				if Target:getHealth() > 0 and not Target:getModData().LJuggPushDmg then
					Target:getModData().LJuggPushDmg = true
					Target:setHealth(Target:getHealth()*0.67)
				end
			end
		end
	end	
end
--[[
			local inv = player:getInventory();
            for i = 0, inv:getItems():size() - 1 do
                local item = player:getInventory():getItems():get(i);
                if item:getName() == getText("Tooltip_MoreTraits_GordaniteBoost") then
                    local crowbar = item;
                    crowbar:setMinDamage(0.6);
                    crowbar:setMaxDamage(1.15);
                    crowbar:setPushBackMod(0.5);
                    crowbar:setDoorDamage(8);
                    crowbar:setCriticalChance(35);
                    crowbar:setSwingTime(3);
                    if getActivatedMods():contains("VorpalWeapons") == false then
                        crowbar:setName(getText("Tooltip_MoreTraits_GordaniteDefault"));
                    end
                    crowbar:setWeaponLength(0.4);
                    crowbar:setMinimumSwingTime(3);
                    crowbar:setTreeDamage(0);
                    crowbar:setBaseSpeed(1);
                    crowbar:setTooltip(null);
                    break ;
                end
            end

]]
local LSavedTimedAction
local LOldSavedTime = 0
--pillstaken
function LWatchTimedActions()
	if LSavedTimedAction then
		local ActionType = LSavedTimedAction:getMetaType()
		
		if ActionType == "ISTakePillAction" and LSavedTimedAction:finished() then
			local ItemType = LSavedTimedAction:getSecondaryHandItem():getType() -- for ISTakePillAction, the item always gets saved to the secondary hand slot for the animation, thing is it saves the ENTIRE item, not just the model. So we can pull it and then use :getType() to determine which pill they're taking.
			-- this method may also work for other timed actions such as ISEatFoodAction, but i havn't checked.
			if Player:HasTrait("vitaminjunkie") and ItemType == "PillsVitamins" then
				VitaminJunkieTaken()
			end
			if (Player:HasTrait("laddict") or PlayerData.LAddiction) then
				if (ItemType == "Pills" or ItemType == "PillsSleepingTablets") then
					AddictPillsTaken()
				end
				if ItemType == "PillsBeta" then
					if not PlayerData.AddictRecoveryBoostTime then PlayerData.AddictRecoveryBoostTime = 0 end
					PlayerData.AddictRecoveryBoostTime = math.min(480,PlayerData.AddictRecoveryBoostTime + ZombRand(120,180))
				end
			end
			if Player:HasTrait("ladhd") and ItemType == "PillsBeta" then
				PlayerData.ADHDSuppressedTime = math.min(720,PlayerData.ADHDSuppressedTime + ZombRand(240,360))
				--print("SuppTime: "..PlayerData.ADHDSuppressedTime)
			end
			if Player:HasTrait("ptsd") and ItemType == "PillsAntiDep" then
				PlayerData.PTSDSuppressedTime = math.min(1440,PlayerData.PTSDSuppressedTime + ZombRand(1080,1440))
			end
		elseif ActionType == "ISForageAction" and (LSavedTimedAction:finished() or LSavedTimedAction:getCurrentTime() == 0) then
			--Discarding doesnt set :finished() on the timed action.
			if Player:HasTrait("lbushman") then
				PlayerData.LBushmanValue = PlayerData.LBushmanValue + 45
				PlayerData.StressChange = PlayerData.StressChange - 0.10
				PlayerData.UnhappyChange = PlayerData.UnhappyChange - 0.035
				--processSayMessage("Forage")
			end
		end
		LSavedTimedAction = nil -- clear the saved action after we check it so it doesnt linger.
	end
	-- the order is important here, if you que actions back to back, then the new action replaces the old one immediately after it completes. meaning the script doesnt get to check the old action for completion before saving the new one.
	if Player:hasTimedActions() then
		local actions = Player:getCharacterActions();
		local action = actions:get(0)
		if action then
			local actionType = action:getMetaType()
			--print(LSavedTimedAction:getMetaType())
			--print("CURTM: "..LSavedTimedAction:getCurrentTime())
			if actionType == "ISTakePillAction" or actionType == "ISForageAction" then
				LSavedTimedAction = action -- save this action so we can check if its finished or not later
			end
			if Player:HasTrait("ladhd") then
				if BodyDamage:getBoredomLevel() >= ADHDTooDistractedThreshold and TableCheck(ADHDBoredAvoidActions,actionType) and not CheckItemsReduceBoredom({action:getPrimaryHandItem(),action:getSecondaryHandItem()}) then
					SayQuote(ADHDTooBoringQuotes)
					action:forceStop()
					ADHDTooDistractedThreshold = 90
					BodyDamage:setBoredomLevel(100) -- Player:Say() causes you to lose ~5% boredom. set the unhappy so the talking doesnt reduce boredom enough to allow interactions again.
					PlayerData.LBoredomLossModifiers.ADHDLossBlock = 1
					ADHDAddBored = 0
				elseif TableCheck(ADHDBoringActions,actionType) then
					PlayerData.LBoredomLossModifiers.ADHDLossBlock = 0
					ADHDAddBored = 0.005*ADHDGetProfSkillModifier(action)
				end
			end
			if Player:HasTrait("Necrophobic") and actionType == "ISGrabCorpseAction" then
				SayQuote(NecrophobicNoCorpses)
				action:forceStop()
			end
		end
	else
		if Player:HasTrait("ladhd") then
			PlayerData.LBoredomLossModifiers.ADHDLossBlock = 1
			ADHDAddBored = 0
		end
	end
end

function LSetPassiveModifiers()
	--put all the passive modifiers in here so we can simplify a lot of this.
	--this handles adding/removing the passive modifiers for the traits.
	local TemperatureBigMod = 1.5
	local TemperatureSmallMod =  0.67
	if Player:HasTrait("lwarmbodied") then
		PlayerData.LTemperatureGainModifiers.WarmBodiedModifier = TemperatureBigMod
		PlayerData.LTemperatureLossModifiers.WarmBodiedModifier = TemperatureSmallMod
	elseif PlayerData.LTemperatureGainModifiers.WarmBodiedModifier then
		PlayerData.LTemperatureGainModifiers.WarmBodiedModifier = 1
		PlayerData.LTemperatureLossModifiers.WarmBodiedModifier = 1
	end
	if Player:HasTrait("lcoldbodied") then
		PlayerData.LTemperatureGainModifiers.ColdBodiedModifier = TemperatureSmallMod
		PlayerData.LTemperatureLossModifiers.ColdBodiedModifier = TemperatureBigMod
	elseif PlayerData.LTemperatureGainModifiers.ColdBodiedModifier then
		PlayerData.LTemperatureGainModifiers.ColdBodiedModifier = 1
		PlayerData.LTemperatureLossModifiers.ColdBodiedModifier = 1
	end
	
	local PTSDStressLossMod =  0.35
	if Player:HasTrait("ptsd") then
		if not PlayerData.PTSDSuppressedTime then PlayerData.PTSDSuppressedTime = 0 end
		if PlayerData.PTSDSuppressedTime > 0 then
			PlayerData.LStressLossModifiers.PTSDModifier = 1-(1-PTSDStressLossMod)/2 -- i love this little function. it halves the distance to 1x in all instances of positive numbers.
		else
			PlayerData.LStressLossModifiers.PTSDModifier = PTSDStressLossMod
		end
	elseif PlayerData.LStressLossModifiers.PTSDModifier then
		PlayerData.LStressLossModifiers.PTSDModifier = 1
	end
	local PTSDSmokerGainMod =  1.50
	local PTSDSmokerLossMod =  0.5
	if Player:HasTrait("ptsd") and Player:HasTrait("Smoker") then
		if PlayerData.PTSDSuppressedTime > 0 then
			PlayerData.LCigStressGainModifiers.PTSDModifier = 1-(1-PTSDSmokerGainMod)/2
			PlayerData.LCigStressLossModifiers.PTSDModifier = 1-(1-PTSDSmokerLossMod)/2
		else
			PlayerData.LCigStressGainModifiers.PTSDModifier = PTSDSmokerGainMod
			PlayerData.LCigStressLossModifiers.PTSDModifier = PTSDSmokerLossMod
		end
	else
		PlayerData.LCigStressGainModifiers.PTSDModifier = 1
		PlayerData.LCigStressLossModifiers.PTSDModifier = 1
	end
	
	local CardioLossMod = 0.75
	local CardioGainMod = 1.3
	if Player:HasTrait("lcardio") then
		PlayerData.LEnduranceLossModifiers.CardioModifier = CardioLossMod
		PlayerData.LEnduranceGainModifiers.CardioModifier = CardioGainMod
	elseif PlayerData.LEnduranceLossModifiers.CardioModifier then
		PlayerData.LEnduranceLossModifiers.CardioModifier = 1
		PlayerData.LEnduranceGainModifiers.CardioModifier = 1
	end
	
	local InsanitySGainMod = 5
	local InsanitySLossMod =  3
	local InsanityUHGainMod = 5
	local InsanityUHLossMod =  3
	if Player:HasTrait("insanity") then
		PlayerData.LStressGainModifiers.InsanityModifier = InsanitySGainMod
		PlayerData.LStressLossModifiers.InsanityModifier = InsanitySLossMod
		PlayerData.LUnhappyGainModifiers.InsanityModifier = InsanityUHGainMod
		PlayerData.LUnhappyLossModifiers.InsanityModifier = InsanityUHLossMod
	elseif PlayerData.LStressGainModifiers.InsanityModifier then
		PlayerData.LStressGainModifiers.InsanityModifier = 1
		PlayerData.LStressLossModifiers.InsanityModifier = 1
		PlayerData.LUnhappyGainModifiers.InsanityModifier = 1
		PlayerData.LUnhappyLossModifiers.InsanityModifier = 1
	end
	
	local ADHDGainMod =  2
	if Player:HasTrait("ladhd") then
		PlayerData.LBoredomGainModifiers.ADHDModifier = ADHDGainMod
	elseif PlayerData.LBoredomGainModifiers.ADHDModifier then
		PlayerData.LBoredomGainModifiers.ADHDModifier = 1
		PlayerData.LBoredomLossModifiers.ADHDLossBlock = 1
	end
	
	if not Player:HasTrait("restrictive") and PlayerData.LEnduranceLossModifiers.RestrictiveLossMod then
		PlayerData.LEnduranceLossModifiers.RestrictiveLossMod = 1
		PlayerData.LEnduranceGainModifiers.RestrictiveGainMod = 1
	end
end

function LRapidPassiveModifiers()
	if Player:HasTrait("lanabolic") then
		local AnabolicEnduranceLossModifier = 0.5
		if Player:getCurrentState() == FitnessState.instance() then
			PlayerData.LEnduranceLossModifiers.AnabolicModifier = AnabolicEnduranceLossModifier
		else
			PlayerData.LEnduranceLossModifiers.AnabolicModifier = 1
		end
	elseif PlayerData.LEnduranceLossModifiers.AnabolicModifier then
		PlayerData.LEnduranceLossModifiers.AnabolicModifier = 1
	end
end

CD = 15
function LMainUpdate()
	LazoloCheckReInit()
	VehicleUpdate()
	LWatchTimedActions()
	
	
	
	if Player:HasTrait("nightwalker") then
		TraitNightwalker()
	end
	
	if Player:HasTrait("Necrophobic") then
		TraitNecrophobic()
	end
	
	if Player:HasTrait("anorexic") then
		TraitAnorexic()
	end
	if Player:HasTrait("bloat") then
		TraitBloat()
	end
	if Player:HasTrait("berserker") then
		TraitBerserker()
	end
	if Player:HasTrait("Nyctophobic") then
		TraitNyctophobic()
	end
	if Player:HasTrait("Photophobic") then
		TraitPhotophobic()
	end
	if Player:HasTrait("insanity") then
		InsanityDilusions()
		if IsManic then 
			Mania()
		end
	end
	
	CD = CD - 1
	if CD <= 0 then
		CD = 60
		LRapidUpdates()
	end
	if not HasLazoloLib then
		LazoloApplyGradualStatChanges()
		StatChangeModifiers()
	end
end



function LRapidUpdates()
	LazoloCheckReInit()
	if Player:HasTrait("Sentimental") then MissingSentimentalItem = true end -- this will get set to false if the item is found
	DeepSearchInventory(Player)
	LRapidPassiveModifiers()
	
	--local Color = Player:getSpeakColour()
	--Player:Say("OF COURSE",Color:getRed(),Color:getGreen(),Color:getBlue(),TextDrawObject():getDefaultFontEnum(),0,"")
	--Player:Say("Maybe") -- maybe this will work? Font is being annoying. nothing seems to work for it.
	
	if Player:HasTrait("restrictive") then
		TraitRestrictive()
	end
	if Player:HasTrait("Photophobic") then
		TraitPhotophobicRapid()
	end
	if Player:HasTrait("lexpeditious") then
		TraitExpeditious()
	end
end

local LDelayTimer = 0

--local TestQuotes = MakeTranslationsListInLuaTable("UI_TestQuotes")

function LMinuteUpdates()
	LazoloCheckReInit()
	UpdateJuggPsychoBases()
	UpdateHeldWeapon()
	
	if LDelayTimer >= 3 then
		LSpawnDelay = true
	else
		LDelayTimer = LDelayTimer + 1
	end
	
	if Player:HasTrait("Sentimental") then
		TraitSentimental()
	end
	if Player:HasTrait("nightwalker") then
		SetNightwalkerValue()
	end
	if Player:HasTrait("wanderer") then
		TrackMovement()
	end
	if Player:HasTrait("vitaminjunkie") then
		TraitVitaminJunkie()
	end
	if Player:HasTrait("lsecondwind") then
		TraitSecondWind()
	end
	if Player:HasTrait("ptsd") then
		TraitPTSD()
	end
	if Player:HasTrait("StressEater") then
		TraitStressEater()
	end
	if Player:HasTrait("insanity") then
		TraitInsanity()
	end
	if Player:HasTrait("homebody") then
		TraitHomebody()
	end
	if Player:HasTrait("wanderer") then
		TraitWanderer()
	end
	if Player:HasTrait("photographer") then
		TraitPhotographer()
	end
	if Player:HasTrait("laddict") then
		TraitAddict()
	elseif PlayerData.LAddiction then
		RecoveredAddict()
	end
	if Player:HasTrait("ladhd") then
		TraitADHDMinute()
	end
	if Player:HasTrait("lnaturalinsulation") then
		TraitNaturalInsulation()
	end
	if Player:HasTrait("Codependant") then
		TraitCodependant()
	end
	if Player:HasTrait("lbetrayed") then
		TraitBetrayed()
	end
	if Player:HasTrait("lanabolic") then
		TraitAnabolic()
	end
	if Player:HasTrait("lbushman") then
		TraitBushman()
	end
	
	LSetPassiveModifiers()
end
function LHourUpdates()
	LazoloCheckReInit()
	if Player:HasTrait("plotarmor") then
		TraitPlotArmor()
	end
end


Events.OnPlayerUpdate.Add(LMainUpdate);
Events.OnGameStart.Add(Init)
Events.OnNewGame.Add(LazoloGiveTraitItems)
Events.EveryOneMinute.Add(LMinuteUpdates)
Events.EveryHours.Add(LHourUpdates)
Events.OnHitZombie.Add(OnWeaponHitSomething);
Events.OnZombieDead.Add(LOnZombieDeath)
Events.AddXP.Add(XpRecieved)