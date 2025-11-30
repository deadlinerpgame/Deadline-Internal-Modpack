HorseFeed = ISBaseTimedAction:derive("HorseFeed");

function HorseFeed:isValid()
    return self.character:getInventory():contains(self.foodItem)
end

function HorseFeed:handleFoodItem(feed, oldHunger, oldThirst)

    newHunger = oldHunger - self.foodItem:getHungerChange() * 100
    if newHunger > 300 then newHunger = 300 end
    newThirst = oldThirst - self.foodItem:getThirstChange() * 100
    if newThirst > 300 then newThirst = 300 end

    self.character:getInventory():DoRemoveItem(self.foodItem)

    return newHunger, newThirst
end

function HorseFeed:handleWaterItem(feed, oldHunger, oldThirst)
    local waterAmount = self.foodItem:getUsedDelta() / self.foodItem:getUseDelta() * 2
    local amountToUse = math.min(oldThirst, waterAmount)
    print("Water amount: " .. waterAmount)
    print("Amount to use: " .. amountToUse)
    self.foodItem:setUsedDelta(self.foodItem:getUsedDelta() - amountToUse * self.foodItem:getUseDelta())
    if self.foodItem:getUsedDelta() <= 0 then
        self.foodItem:Use()
    end
    return oldHunger, math.min(300, oldThirst + amountToUse)
end

function HorseFeed:perform()
    local modData = self.horse:getModData() or {}
    local oldHunger = getHunger(modData)
    local oldThirst = getThirst(modData)
    local currentTime = getGameTime():getWorldAgeHours()
    local feed = self.foodItem:getFullType()
    
    local newHunger = oldHunger
    local newThirst = oldThirst
    if feed == "Base.BucketWaterFull" or feed == "Base.WaterPot" or feed == "Base.WaterBottleFull" or feed == "aerx.ClayJarWater" or feed == "Base.WaterPopBottle" then
        newHunger, newThirst = self:handleWaterItem(feed, oldHunger, oldThirst)
    else
        newHunger, newThirst = self:handleFoodItem(feed, oldHunger, oldThirst)
    end
    
    if newHunger < 0 then
        newHunger = 0
    end
    
    if newThirst < 0 then
        newThirst = 0
    end
   
    modifyModData( self.character,  self.horse, {
        hunger = newHunger,
        thirst = newThirst,
        thirstTimestamp = currentTime
    })

    ISBaseTimedAction.perform(self)
end

function HorseFeed:new(character, horse, foodItem)
    local o = ISBaseTimedAction.new(self, character);
    o.horse = horse;
    o.foodItem = foodItem;
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.maxTime = 40;
    return o;
end