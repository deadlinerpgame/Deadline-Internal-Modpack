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

    -- The movement speed debuff is handled by the actual items themselves.

    player:transmitModData();
end


function DebuffManager.ProstheticChecks()
    local player = getPlayer();
    if not player then return end;

    local prosthetics = ProstheticsCore.CheckForProsthetics();
    if #prosthetics == 0 then return end;
    
    local armProsthetics = 0;
    local legProsthetics = 0;

    player:getModData().ProstheticsLine_ArmProsthetics = {};
    player:getModData().ProstheticsLine_LegProsthetics = {};

    for i, v in ipairs(prosthetics) do
        local slot = prosthetics[i];
        if ProstheticsCore.IsArmLocation(slot) then
            armProsthetics = armProsthetics + 1;
            table.insert(getPlayer():getModData().ProstheticsLine_ArmProsthetics, slot);
        end

        if ProstheticsCore.IsLegLocation(slot) then
            legProsthetics = legProsthetics + 1;
            table.insert(getPlayer():getModData().ProstheticsLine_LegProsthetics, slot);
        end
    end

    player:transmitModData();
end

function DebuffManager.OnLoad()
    DebuffManager.AmputationChecks();
    --DebuffManager.ProstheticChecks();
end

function DebuffManager.OnClothingUpdated(character)
    if character ~= getPlayer() then return end;

    DebuffManager.AmputationChecks();
    --DebuffManager.ProstheticChecks();
end

Events.OnLoad.Add(DebuffManager.OnLoad);
Events.OnClothingUpdated.Add(DebuffManager.OnClothingUpdated);
