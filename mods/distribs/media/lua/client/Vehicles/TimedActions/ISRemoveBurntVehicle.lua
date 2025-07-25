--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

require "TimedActions/ISBaseTimedAction"

ISRemoveBurntVehicle = ISBaseTimedAction:derive("ISRemoveBurntVehicle")

local function predicateBlowTorch(item)
	return (item ~= nil) and
		(item:hasTag("BlowTorch") or item:getType() == "BlowTorch") and
		(item:getDrainableUsesInt() >= 10)
end

function ISRemoveBurntVehicle:isValid()
	if not predicateBlowTorch(self.character:getPrimaryHandItem()) then
		return false
	end
	return self.vehicle and not self.vehicle:isRemovedFromWorld();
end

function ISRemoveBurntVehicle:update()
	self.character:faceThisObject(self.vehicle)
	self.item:setJobDelta(self:getJobDelta())
	self.item:setJobType(getText("ContextMenu_RemoveBurntVehicle"))

	if self.sound ~= 0 and not self.character:getEmitter():isPlaying(self.sound) then
		self.sound = self.character:playSound("BlowTorch")
	end

    self.character:setMetabolicTarget(Metabolics.HeavyWork);
end

function ISRemoveBurntVehicle:start()
	self.item = self.character:getPrimaryHandItem()
	self:setActionAnim("BlowTorch")
	self:setOverrideHandModels(self.item, nil)
	self.sound = self.character:playSound("BlowTorch")
end

function ISRemoveBurntVehicle:stop()
	if self.item then
		self.item:setJobDelta(0)
	end
	if self.sound ~= 0 then
		self.character:getEmitter():stopSound(self.sound)
	end
	ISBaseTimedAction.stop(self)
end

function ISRemoveBurntVehicle:perform()
	if self.sound ~= 0 then
		self.character:getEmitter():stopSound(self.sound)
	end
	local totalXp = 5;
	for i=1,math.max(5,self.character:getPerkLevel(Perks.MetalWelding)) do
		if self:checkAddItem("MetalBar", 20) then totalXp = totalXp + 2 end;
		if self:checkAddItem("MetalBar", 20) then totalXp = totalXp + 2 end;
		if self:checkAddItem("MetalBar", 20) then totalXp = totalXp + 2 end;
		if self:checkAddItem("MetalBar", 20) then totalXp = totalXp + 2 end;
		if self:checkAddItem("MetalPipe", 20) then totalXp = totalXp + 2 end;
		if self:checkAddItem("MetalPipe", 20) then totalXp = totalXp + 2 end;
		if self:checkAddItem("MetalPipe", 20) then totalXp = totalXp + 2 end;
		if self:checkAddItem("MetalPipe", 20) then totalXp = totalXp + 2 end;
		if self:checkAddItem("SheetMetal", 25) then totalXp = totalXp + 2 end;
		if self:checkAddItem("SheetMetal", 25) then totalXp = totalXp + 2 end;
		if self:checkAddItem("SheetMetal", 25) then totalXp = totalXp + 2 end;
		if self:checkAddItem("SheetMetal", 25) then totalXp = totalXp + 2 end;
		if self:checkAddItem("SmallSheetMetal", 20) then totalXp = totalXp + 2 end;
		if self:checkAddItem("SmallSheetMetal", 20) then totalXp = totalXp + 2 end;
		if self:checkAddItem("SmallSheetMetal", 20) then totalXp = totalXp + 2 end;
		if self:checkAddItem("SmallSheetMetal", 20) then totalXp = totalXp + 2 end;
        if self:checkAddItem("ScrapMetal", 15) then totalXp = totalXp + 2 end;
		if self:checkAddItem("ScrapMetal", 15) then totalXp = totalXp + 2 end;


        if self:checkAddItem("aerx.AluminumFragments", 16) then totalXp = totalXp + 1 end;
        if self:checkAddItem("aerx.AluminumFragments", 16) then totalXp = totalXp + 1 end;
        if self:checkAddItem("aerx.AluminumScrap", 25) then totalXp = totalXp + 2 end;
        if self:checkAddItem("aerx.AluminumScrap", 25) then totalXp = totalXp + 2 end;

        if self:checkAddItem("aerx.TinFragments", 16) then totalXp = totalXp + 1 end;
        if self:checkAddItem("aerx.TinFragments", 16) then totalXp = totalXp + 1 end;
        if self:checkAddItem("aerx.TinScrap", 25) then totalXp = totalXp + 2 end;
        if self:checkAddItem("aerx.TinScrap", 25) then totalXp = totalXp + 2 end;

        if self:checkAddItem("aerx.CopperFragments", 16) then totalXp = totalXp + 1 end;
        if self:checkAddItem("aerx.CopperFragments", 16) then totalXp = totalXp + 1 end;
        if self:checkAddItem("aerx.CopperScrap", 26) then totalXp = totalXp + 2 end;
        if self:checkAddItem("aerx.CopperScrap", 26) then totalXp = totalXp + 2 end;

        if self:checkAddItem("aerx.NickelFragments", 16) then totalXp = totalXp + 1 end;
        if self:checkAddItem("aerx.NickelFragments", 16) then totalXp = totalXp + 1 end;
        if self:checkAddItem("aerx.NickelScrap", 25) then totalXp = totalXp + 2 end;
        if self:checkAddItem("aerx.NickelScrap", 25) then totalXp = totalXp + 2 end;

        if self:checkAddItem("aerx.LeadFragments", 16) then totalXp = totalXp + 1 end;
        if self:checkAddItem("aerx.LeadFragments", 16) then totalXp = totalXp + 1 end;
        if self:checkAddItem("aerx.LeadScrap", 25) then totalXp = totalXp + 2 end;
        if self:checkAddItem("aerx.LeadScrap", 25) then totalXp = totalXp + 2 end;

        if self:checkAddItem("aerx.IronFragments", 20) then totalXp = totalXp + 1 end;
        if self:checkAddItem("aerx.IronFragments", 20) then totalXp = totalXp + 1 end;
        if self:checkAddItem("aerx.IronScrap", 12) then totalXp = totalXp + 2 end;
        if self:checkAddItem("aerx.IronScrap", 12) then totalXp = totalXp + 2 end;

        if self:checkAddItem("aerx.GoldScrap", 80) then totalXp = totalXp + 3 end;
        if self:checkAddItem("aerx.GoldScrap", 80) then totalXp = totalXp + 3 end;

        if self:checkAddItem("aerx.SilverScrap", 80) then totalXp = totalXp + 3 end;
        if self:checkAddItem("aerx.SilverScrap", 80) then totalXp = totalXp + 3 end;

        if self:checkAddItem("aerx.ZincFragments", 16) then totalXp = totalXp + 1 end;
        if self:checkAddItem("aerx.ZincFragments", 16) then totalXp = totalXp + 1 end;
        if self:checkAddItem("aerx.ZincScrap", 25) then totalXp = totalXp + 2 end;
        if self:checkAddItem("aerx.ZincScrap", 25) then totalXp = totalXp + 2 end;
	end
	for i=1,10 do
		self.item:Use();
	end
	self.character:getXp():AddXP(Perks.MetalWelding, totalXp);
	sendClientCommand(self.character, "vehicle", "remove", { vehicle = self.vehicle:getId() })
	self.item:setJobDelta(0);
	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self)
end

-- Drop chance is calculated by random between BaseChance (after item name) and MW level

function ISRemoveBurntVehicle:checkAddItem(item, baseChance)
	if ZombRand(baseChance-self.character:getPerkLevel(Perks.MetalWelding)) == 0 then
--		self.character:getInventory():AddItem(item);
		self.vehicle:getSquare():AddWorldInventoryItem(item, ZombRandFloat(0,0.9), ZombRandFloat(0,0.9), 0);
		return true;
	end
	return false;
end

function ISRemoveBurntVehicle:new(character, vehicle)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.vehicle = vehicle
	o.maxTime = 800 - (character:getPerkLevel(Perks.MetalWelding) * 20);
	if character:isTimedActionInstant() then o.maxTime = 10 end
	return o
end

