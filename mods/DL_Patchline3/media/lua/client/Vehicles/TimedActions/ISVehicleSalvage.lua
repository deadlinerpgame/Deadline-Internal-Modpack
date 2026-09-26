require "TimedActions/ISBaseTimedAction"

ISVehicleSalvage = ISBaseTimedAction:derive("ISVehicleSalvage")

ISVehicleSalvage.BASE_ROLLS = 2
ISVehicleSalvage.LEVELS_PER_ROLL = 3

ISVehicleSalvage.POOL = {
    { "DL_MetalLine.Scrap_Iron_S", 14 },
    { "DL_MetalLine.Scrap_Iron_M", 10 },
    { "DL_MetalLine.Scrap_Iron_L", 3 },
    { "DL_MetalLine.Scrap_Carbon_S", 6 },
    { "DL_MetalLine.Scrap_Carbon_M", 3 },
    { "DL_MetalLine.Scrap_Aluminum_S", 8 },
    { "DL_MetalLine.Scrap_Aluminum_M", 4 },
    { "DL_MetalLine.Scrap_Copper_S", 6 },
    { "DL_MetalLine.Scrap_Copper_M", 2 },
    { "DL_MetalLine.Scrap_Lead_S", 4 },
    { "DL_MetalLine.Scrap_Lead_M", 1 },
    { "DL_MetalLine.Scrap_Zinc_S", 3 },
    { "DL_MetalLine.Scrap_Nickel_S", 3 },
    { "DL_MetalLine.Scrap_Chromium_S", 3 },
    { "DL_MetalLine.Scrap_Chromium_M", 1 },
    { "DL_MetalLine.Scrap_Tin_S", 2 },
    { "DL_MetalLine.Scrap_Silver_S", 1 },
    { "DL_MetalLine.Scrap_Gold_S", 1 },
    { "Base.SmallSheetMetal", 6 },
    { "Base.SheetMetal", 3 },
    { "Base.MetalBar", 3 },
    { "Base.MetalPipe", 3 },
    { "Base.ScrapMetal", 4 },
}

local function predicateBlowTorch(item)
    return (item ~= nil) and
            (item:hasTag("BlowTorch") or item:getType() == "BlowTorch") and
            (item:getDrainableUsesInt() >= 10)
end

function ISVehicleSalvage:isValid()
    if not predicateBlowTorch(self.character:getPrimaryHandItem()) then
        return false
    end
    return self.vehicle and not self.vehicle:isRemovedFromWorld() and not DLSalvage.isSalvaged(self.vehicle)
end

function ISVehicleSalvage:update()
    self.character:faceThisObject(self.vehicle)
    self.item:setJobDelta(self:getJobDelta())
    self.item:setJobType(getText("ContextMenu_SalvageVehicle"))

    if self.sound ~= 0 and not self.character:getEmitter():isPlaying(self.sound) then
        self.sound = self.character:playSound("BlowTorch")
    end

    self.character:setMetabolicTarget(Metabolics.HeavyWork);
end

function ISVehicleSalvage:start()
    self.item = self.character:getPrimaryHandItem()
    self:setActionAnim("BlowTorch")
    self:setOverrideHandModels(self.item, nil)
    self.sound = self.character:playSound("BlowTorch")
end

function ISVehicleSalvage:stop()
    if self.item then
        self.item:setJobDelta(0)
    end
    if self.sound ~= 0 then
        self.character:getEmitter():stopSound(self.sound)
    end
    ISBaseTimedAction.stop(self)
end

function ISVehicleSalvage:perform()
    if self.sound ~= 0 then
        self.character:getEmitter():stopSound(self.sound)
    end
    local level = self.character:getPerkLevel(Perks.MetalWelding)
    local rolls = ISVehicleSalvage.BASE_ROLLS + math.floor(level / ISVehicleSalvage.LEVELS_PER_ROLL)
    local totalXp = 10;
    for i = 1, rolls do
        self:dropItem(DLSalvage.pick(ISVehicleSalvage.POOL))
        totalXp = totalXp + 2
    end
    for i = 1, 10 do
        self.item:Use();
    end
    self.character:getXp():AddXP(Perks.MetalWelding, totalXp);
    //This is a stupid way of doing this, but I have no time to do it in a cleaner way
    DLSalvage.markSalvaged(self.character, self.vehicle)
    self.item:setJobDelta(0);
    ISBaseTimedAction.perform(self)
end

function ISVehicleSalvage:dropItem(item)
    self.vehicle:getSquare():AddWorldInventoryItem(item, ZombRandFloat(0, 0.9), ZombRandFloat(0, 0.9), 0);
end

function ISVehicleSalvage:new(character, vehicle)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
    o.vehicle = vehicle
    o.maxTime = 3000 - (character:getPerkLevel(Perks.MetalWelding) * 20);
    if character:isTimedActionInstant() then o.maxTime = 10 end
    return o
end
