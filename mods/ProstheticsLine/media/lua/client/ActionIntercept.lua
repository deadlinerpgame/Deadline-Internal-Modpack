if isServer() then return end;

ProstheticsCore = require("ProstheticsCore");
require "TimedActions/ISBaseTimedAction"

local original_adjustMaxTime = ISBaseTimedAction.adjustMaxTime;
function ISBaseTimedAction:adjustMaxTime(maxTime)
    print("[ProstheticsLine_ActionIntercept] Start of function with base time: " .. maxTime);
    local player = getPlayer();
    if not player then return end;

    local armAmputations = ProstheticsCore.GetArmAmputations();
    
    local armProsthetics = ProstheticsCore.GetArmProsthetics();

    if armAmputations and #armAmputations > 0 then

        if armProsthetics and #armProsthetics > 0 then
            local prosMult = 1;
            for i, v in ipairs(armProsthetics) do
                local prosSlot = armProsthetics[i];
                local item = player:getWornItem(prosSlot);
                if item then
                    local mult = item:getModData().ProstheticsLine_ProstheticModifier;
                    prosMult = prosMult * mult;
                end
            end

            maxTime = math.floor(maxTime * prosMult);
            print("[FINAL] New max time: " .. tostring(maxTime));
            return original_adjustMaxTime(self, maxTime);
        end

        if ProstheticsCore.DoMultiAmputationsDisableActions() == true and #armAmputations == 2 then
            HaloTextHelper.addTextWithArrow(player, "I need hands to do that.", false, HaloTextHelper.getColorRed());
            return { ignoreAction = true };
        end

        local multiplier = ProstheticsCore.GetAmputationActionModifier();
        local totalMult = (multiplier ^ #armAmputations);

        maxTime = math.floor(maxTime * totalMult);
    end
	
    return original_adjustMaxTime(self, maxTime);
end