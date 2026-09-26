require "TimedActions/ISBaseTimedAction"

ISRemoveBurntVehicle = ISBaseTimedAction:derive("ISRemoveBurntVehicle")

ISRemoveBurntVehicle.BASE_ROLLS = 1
ISRemoveBurntVehicle.LEVELS_PER_ROLL = 4

ISRemoveBurntVehicle.POOL = {
	{ "DL_MetalLine.Scrap_Iron_S", 16 },
	{ "DL_MetalLine.Scrap_Iron_M", 8 },
	{ "DL_MetalLine.Scrap_Iron_L", 2 },
	{ "DL_MetalLine.Scrap_Carbon_S", 6 },
	{ "DL_MetalLine.Scrap_Aluminum_S", 4 },
	{ "DL_MetalLine.Scrap_Copper_S", 3 },
	{ "DL_MetalLine.Scrap_Lead_S", 3 },
	{ "DL_MetalLine.Scrap_Zinc_S", 2 },
	{ "DL_MetalLine.Scrap_Chromium_S", 2 },
	{ "Base.ScrapMetal", 8 },
	{ "Base.UnusableMetal", 6 },
	{ "Base.SmallSheetMetal", 4 },
	{ "Base.SheetMetal", 2 },
	{ "Base.MetalBar", 2 },
	{ "Base.MetalPipe", 2 },
}

local function predicateBlowTorch(item)
	return (item ~= nil) and
		(item:hasTag("BlowTorch") or item:getType() == "BlowTorch") and
		(item:getDrainableUsesInt() >= 10)
end

function ISRemoveBurntVehicle:isValid()
	if not predicateBlowTorch(self.character:getPrimaryHandItem()) then
		return false
	end
	return self.vehicle and not self.vehicle:isRemovedFromWorld() and not DLSalvage.isSalvaged(self.vehicle)
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
	local level = self.character:getPerkLevel(Perks.MetalWelding)
	local rolls = ISRemoveBurntVehicle.BASE_ROLLS + math.floor(level / ISRemoveBurntVehicle.LEVELS_PER_ROLL)
	local totalXp = 5;
	for i = 1, rolls do
		self:dropItem(DLSalvage.pick(ISRemoveBurntVehicle.POOL))
		totalXp = totalXp + 2
	end
	for i = 1, 10 do
		self.item:Use();
	end
	self.character:getXp():AddXP(Perks.MetalWelding, totalXp);
	DLSalvage.markSalvaged(self.character, self.vehicle)
	self.item:setJobDelta(0);
	ISBaseTimedAction.perform(self)
end

function ISRemoveBurntVehicle:dropItem(item)
	self.vehicle:getSquare():AddWorldInventoryItem(item, ZombRandFloat(0, 0.9), ZombRandFloat(0, 0.9), 0);
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
