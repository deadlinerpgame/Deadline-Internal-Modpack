DrinkWaterGround = ISBaseTimedAction:derive("DrinkWaterGround");

function DrinkWaterGround:isValid()
    return true
end

function DrinkWaterGround:perform()    

    modifyModData(self.character, self.horse, {
        thirst = 300,
        timestamp = getGameTime():getWorldAgeHours()
    })
    
    ISBaseTimedAction.perform(self)
end

function DrinkWaterGround:new(character, horse, waterX, waterY, waterZ)
    local o = ISBaseTimedAction.new(self, character);
    o.horse = horse;
    o.waterX = waterX;
    o.waterY = waterY;
    o.waterZ = waterZ;
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.maxTime = 60;
    return o;
end