if isServer() then return end;

ProstheticsCore = require("ProstheticsCore");
require "TimedActions/ISBaseTimedAction"

local original_adjustMaxTime = ISBaseTimedAction.adjustMaxTime;
function ISBaseTimedAction:adjustMaxTime(maxTime)

    local player = getPlayer();
    if not player then return end;

    local armAmputations = ProstheticsCore.GetArmAmputations();
    if armAmputations and #armAmputations > 0 then
        local multiplier = ProstheticsCore.GetAmputationActionModifier();
        local totalMult = (multiplier ^ #armAmputations);

        maxTime = math.floor(maxTime * totalMult);
    end
	
    return original_adjustMaxTime(self, maxTime);
end