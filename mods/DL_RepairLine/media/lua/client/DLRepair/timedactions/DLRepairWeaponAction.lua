require "TimedActions/ISBaseTimedAction"

DLRepairWeaponAction = ISBaseTimedAction:derive("DLRepairWeaponAction")

function DLRepairWeaponAction:isValid()
    local inv = self.character:getInventory()
    if not (self.weapon and inv:contains(self.weapon)) then return false end
    if self.bench and not DLRepair.Bench.isNear(self.character, self.bench) then return false end
    local perk = self.character:getPerkLevel(Perks.Maintenance)
    return DLRepair.canAttempt(inv, self.weapon, self.option, perk)
end

function DLRepairWeaponAction:update()
    self.character:setMetabolicTarget(Metabolics.UsingTools)
end

function DLRepairWeaponAction:start()
    self:setActionAnim("Loot")
    self.sound = self.character:playSound("PutItemInBag")
end

function DLRepairWeaponAction:stop()
    if self.sound and self.character:getEmitter() then
        self.character:getEmitter():stopSound(self.sound)
    end
    ISBaseTimedAction.stop(self)
end

function DLRepairWeaponAction:perform()
    if self.sound and self.character:getEmitter() then
        self.character:getEmitter():stopSound(self.sound)
    end
    local result = DLRepair.attemptRepair(self.character, self.weapon, self.option)
    if type(self.onComplete) == "function" then
        self.onComplete(result, self.weapon)
    end
    ISBaseTimedAction.perform(self)
end

function DLRepairWeaponAction:new(character, weapon, option, time, onComplete, bench)
    local o = ISBaseTimedAction.new(self, character)
    o.character = character
    o.weapon = weapon
    o.option = option
    o.maxTime = time or 150
    o.onComplete = onComplete
    o.bench = bench
    o.stopOnWalk = true
    o.stopOnRun = true
    o.caloriesModifier = 2
    return o
end
