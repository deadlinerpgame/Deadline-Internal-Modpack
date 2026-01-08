--Codebase by Yuhiko and his/her mod BodyLocationsTweaker API. All credit of this functionality goes to him/her. 
require "NPCs/BodyLocations" 



local function customGetVal(obj, int) return getClassFieldVal(obj, getClassField(obj, int)); end
local BodyLocationsTweaker = {}; 

BodyLocationsTweaker.group = BodyLocations.getGroup("Human");
BodyLocationsTweaker.list = customGetVal(BodyLocationsTweaker.group, 1); 

function BodyLocationsTweaker:moveOrCreateBeforeOrAfter(toRelocateOrCreate, locationElement, afterBoolean)

    if type(locationElement) ~= "string" then error("Argument 2 is not of type string. Please re-check!", 2); end
    local itemToMoveTo = self.group:getLocation(locationElement); 
    if itemToMoveTo ~= nil then
        
        if type(toRelocateOrCreate) ~= "string" then error("Argument 1 is not of type string. Please re-check!", 2) end
        local curItem = self.group:getOrCreateLocation(toRelocateOrCreate); 
        self.list:remove(curItem); 
        local index = self.group:indexOf(locationElement); 
        if afterBoolean then index = index + 1; end 
        self.list:add(index, curItem); 
        return curItem;
    else 
        error("Could not find the BodyLocation [",locationElement,"] - please check the passed arguments!", 2);
    end
end


function BodyLocationsTweaker:moveOrCreateBefore(toRelocateOrCreate, locationElement) -- for simpler and clearer usage
    return self:moveOrCreateBeforeOrAfter(toRelocateOrCreate, locationElement, false);
end

 BodyLocationsTweaker:moveOrCreateBefore("KIU3", "UnderwearExtra1");
 BodyLocationsTweaker:moveOrCreateBefore("KIU2", "UnderwearExtra1");
 BodyLocationsTweaker:moveOrCreateBefore("KIU1", "UnderwearExtra1");
 BodyLocationsTweaker:moveOrCreateBefore("KIU0", "UnderwearExtra1");
 BodyLocationsTweaker:moveOrCreateBefore("KIUA", "Hat");
 BodyLocationsTweaker:moveOrCreateBefore("KIUB", "Hat");
 BodyLocationsTweaker:moveOrCreateBefore("KIUC", "Hat");
 BodyLocationsTweaker:moveOrCreateBefore("RightLeg", "Neck");
 BodyLocationsTweaker:moveOrCreateBefore("LeftLeg", "Neck");
 BodyLocationsTweaker:moveOrCreateBefore("KIUY", "Neck");
 BodyLocationsTweaker:moveOrCreateBefore("KIUX", "Sweater");
 
 BodyLocationsTweaker:moveOrCreateBefore("BathRobeCoat", "BathRobe");
 BodyLocationsTweaker:moveOrCreateBefore("JacketOpen", "Jacket");
 BodyLocationsTweaker:moveOrCreateBefore("JacketShort", "Jacket");
 BodyLocationsTweaker:moveOrCreateBefore("ShoulderpadLeft", "Sweater");
 BodyLocationsTweaker:moveOrCreateBefore("ShoulderpadRight", "Sweater");
 BodyLocationsTweaker:moveOrCreateBefore("Belt", "Sweater");
 BodyLocationsTweaker:moveOrCreateBefore("BeltExtra", "Sweater");
 BodyLocationsTweaker:moveOrCreateBefore("Shoes", "Skirt");
 BodyLocationsTweaker:moveOrCreateBefore("FSShirt", "Shirt");
 BodyLocationsTweaker:moveOrCreateBefore("Forearm", "LeftWrist");
 BodyLocationsTweaker:moveOrCreateBefore("ForeArm_Left", "LeftWrist");
 BodyLocationsTweaker:moveOrCreateBefore("ForeArm_Right", "RightWrist");
 BodyLocationsTweaker:moveOrCreateBefore("ShortsShort", "Skirt");
 BodyLocationsTweaker:moveOrCreateBefore("ShortPants", "Pants");

 local group = BodyLocations.getGroup("Human")
 group:setExclusive("TankTop", "KIUX")

 group:setExclusive("FullSuitHead", "BathRobeCoat")
 group:setExclusive("FullSuit", "BathRobeCoat")
 group:setExclusive("FullTop", "BathRobeCoat")
 group:setExclusive("Boilersuit", "BathRobeCoat")
 group:setExclusive("BathRobeCoat", "BathRobe")
 group:setExclusive("BathRobeCoat", "Sweater")
 group:setExclusive("BathRobeCoat", "SweaterHat")
 
 group:setExclusive("BathRobeCoat", "Jacket")
 group:setExclusive("BathRobeCoat", "Jacket_Down")
 group:setExclusive("BathRobeCoat", "JacketSuit")
 group:setExclusive("BathRobeCoat", "JacketHat")
 group:setExclusive("BathRobeCoat", "Jacket_Bulky")
 group:setExclusive("BathRobeCoat", "JacketHat_Bulky")
 
 group:setExclusive("BathRobeCoat", "TorsoExtra")
 group:setExclusive("BathRobeCoat", "TorsoExtraVest")

 
 group:setExclusive("BathRobeCoat", "Boilersuit")
 
 

 group:setExclusive("BodyCostume", "BathRobeCoat")
 
 group:setHideModel("BathRobeCoat", "LeftWrist")
 group:setHideModel("BathRobeCoat", "RightWrist")
 group:setHideModel("BathRobeCoat", "FannyPackFront")

 
 group:setExclusive("JacketOpen", "Jacket")
 group:setExclusive("JacketOpen", "BathRobeCoat")
 group:setExclusive("JacketOpen", "JacketShort")
 
 group:setExclusive("FullSuitHead", "JacketOpen")
 group:setExclusive("FullSuit", "JacketOpen")
 group:setExclusive("FullTop", "JacketOpen")
 group:setExclusive("Boilersuit", "JacketOpen")
 group:setExclusive("BathRobe", "JacketOpen")

 group:setExclusive("JacketHat", "JacketOpen")
 group:setExclusive("JacketHat_Bulky", "JacketOpen")

 group:setExclusive("JacketOpen", "JacketHat")
 group:setExclusive("JacketOpen", "Jacket_Down")
 group:setExclusive("JacketOpen", "JacketHat_Bulky")
 group:setExclusive("JacketOpen", "Jacket_Bulky")
 group:setExclusive("JacketOpen", "TorsoExtra")
 group:setExclusive("JacketOpen", "TorsoExtraVest")
 group:setExclusive("JacketSuit", "JacketOpen")
 group:setExclusive("JacketSuit", "BathRobeCoat")
 


 
 group:setExclusive("JacketShort", "Jacket")
 group:setExclusive("JacketShort", "BathRobeCoat")
 
 group:setExclusive("FullSuitHead", "JacketShort")
 group:setExclusive("FullSuit", "JacketShort")
 group:setExclusive("FullTop", "JacketShort")
 group:setExclusive("Boilersuit", "JacketShort")
 group:setExclusive("BathRobe", "JacketShort")
 
 group:setExclusive("JacketHat", "JacketShort")
 group:setExclusive("JacketHat_Bulky", "JacketShort")

 group:setExclusive("JacketShort", "JacketHat")
 group:setExclusive("JacketShort", "Jacket_Down")
 group:setExclusive("JacketShort", "JacketHat_Bulky")
 group:setExclusive("JacketShort", "Jacket_Bulky")
 group:setExclusive("JacketShort", "TorsoExtra")
 group:setExclusive("JacketShort", "TorsoExtraVest")
 group:setExclusive("JacketSuit", "JacketShort")
 group:setExclusive("JacketSuit", "BathRobeCoat")
 


 
 group:setHideModel("Jacket", "Belt")
 group:setHideModel("Jacket_Down", "Belt")
 group:setHideModel("Jacket_Bulky", "Belt")
 group:setHideModel("JacketSuit", "Belt")
 group:setHideModel("TorsoExtra", "Belt")
 group:setHideModel("TorsoExtraVest", "Belt")
 group:setHideModel("BathRobe", "Belt")
 group:setHideModel("BathRobe", "BeltExtra")
 group:setHideModel("FullSuit", "Belt")
 group:setHideModel("FullTop", "Belt")
 group:setHideModel("JacketHat", "Belt")
 group:setHideModel("Jacket_Bulky", "Belt")
 group:setHideModel("Boilersuit", "Belt")
 group:setHideModel("Sweater", "Belt")
 group:setHideModel("SweaterHat", "Belt")
 group:setHideModel("BodyCostume", "Belt")
 
