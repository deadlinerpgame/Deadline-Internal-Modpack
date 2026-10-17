require "TimedActions/ISBaseTimedAction"

DLReinforceAction = ISBaseTimedAction:derive("DLReinforceAction")

function DLReinforceAction:isValid()
    local inv = self.character:getInventory()
    if not (self.weapon and inv:contains(self.weapon)) then return false end
    if self.bench and not DLRepair.Bench.isNear(self.character, self.bench) then return false end
    local perk = self.character:getPerkLevel(Perks.Maintenance)
    return DLRepair.canReinforce(inv, self.weapon, perk)
end

function DLReinforceAction:update()
    self.character:setMetabolicTarget(Metabolics.UsingTools)
end

function DLReinforceAction:start()
    self:setActionAnim("Loot")
    self.sound = self.character:playSound("PutItemInBag")
end

function DLReinforceAction:stop()
    if self.sound and self.character:getEmitter() then
        self.character:getEmitter():stopSound(self.sound)
    end
    ISBaseTimedAction.stop(self)
end

function DLReinforceAction:perform()
    if self.sound and self.character:getEmitter() then
        self.character:getEmitter():stopSound(self.sound)
    end
    local result = DLRepair.attemptReinforce(self.character, self.weapon)
    if type(self.onComplete) == "function" then
        self.onComplete(result, self.weapon)
    end
    ISBaseTimedAction.perform(self)
end

function DLReinforceAction:new(character, weapon, time, onComplete, bench)
    local o = ISBaseTimedAction.new(self, character)
    o.character = character
    o.weapon = weapon
    o.maxTime = time or 240
    o.onComplete = onComplete
    o.bench = bench
    o.stopOnWalk = true
    o.stopOnRun = true
    o.caloriesModifier = 3
    return o
end
