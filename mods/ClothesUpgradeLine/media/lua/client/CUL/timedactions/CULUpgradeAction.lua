require "TimedActions/ISBaseTimedAction"

CULUpgradeAction = ISBaseTimedAction:derive("CULUpgradeAction")

function CULUpgradeAction:isValid()
    local inv = self.character:getInventory()
    if not (self.item and inv:contains(self.item)) then return false end
    if self.bench and not ClothesUpgrade.Bench.isNear(self.character, self.bench) then return false end
    local perk = self.character:getPerkLevel(ClothesUpgrade.perk())
    return ClothesUpgrade.canUpgrade(inv, self.item, self.track, perk)
end

function CULUpgradeAction:update()
    self.character:setMetabolicTarget(Metabolics.UsingTools)
end

function CULUpgradeAction:start()
    self:setActionAnim("Loot")
    self.sound = self.character:playSound("PutItemInBag")
end

function CULUpgradeAction:stop()
    if self.sound and self.character:getEmitter() then
        self.character:getEmitter():stopSound(self.sound)
    end
    ISBaseTimedAction.stop(self)
end

function CULUpgradeAction:perform()
    if self.sound and self.character:getEmitter() then
        self.character:getEmitter():stopSound(self.sound)
    end
    local result, flaw = ClothesUpgrade.attemptUpgrade(self.character, self.item, self.track)
    ISBaseTimedAction.perform(self)
    if self.onComplete then
        self.onComplete(result, self.item, flaw)
    end
end

function CULUpgradeAction:new(character, item, track, time, onComplete, bench)
    local o = ISBaseTimedAction.new(self, character)
    o.character = character
    o.item = item
    o.track = track
    o.maxTime = time or 180
    o.onComplete = onComplete
    o.bench = bench
    o.stopOnWalk = true
    o.stopOnRun = true
    o.caloriesModifier = 2
    return o
end
