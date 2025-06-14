if isServer() then return end;

DebuffManager = {};
ProstheticsCore = require("ProstheticsCore");

function DebuffManager.AmputationChecks()
    local player = getPlayer();
    if not player then return end;

    local amputations = ProstheticsCore.CheckForAmputations();
    if #amputations == 0 then return end;
    
    local armAmputations = 0;
    local legAmputations = 0;

    -- Clear amputations.
    player:getModData().ProstheticsLine_ArmAmputations = {};
    player:getModData().ProstheticsLine_LegAmputations = {};

    for i, v in ipairs(amputations) do
        local slot = amputations[i];
        if ProstheticsCore.IsArmLocation(slot) then
            armAmputations = armAmputations + 1;
            table.insert(getPlayer():getModData().ProstheticsLine_ArmAmputations, slot);
        end

        if ProstheticsCore.IsLegLocation(slot) then
            legAmputations = legAmputations + 1;
            table.insert(getPlayer():getModData().ProstheticsLine_LegAmputations, slot);
        end
    end

    player:transmitModData();
end

function DebuffManager.OnLoad()
    DebuffManager.AmputationChecks();
end

function DebuffManager.OnClothingUpdated(character)
    if character ~= getPlayer() then return end;

    DebuffManager.AmputationChecks();
end

Events.OnLoad.Add(DebuffManager.OnLoad);
Events.OnClothingUpdated.Add(DebuffManager.OnClothingUpdated);
