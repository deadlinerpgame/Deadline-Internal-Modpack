ProstheticsCore = {};

function ProstheticsCore.CheckForAmputations()
    local player = getPlayer();
    if not player then return end;

    local amputationSlots = {};
    local currentAmputations = {};

    -- Find all the clothing locations named "amputation".
    local humanGroup = BodyLocations.getGroup("Human");
    local clothingLocs = humanGroup:getAllLocations();

    for i = 0, clothingLocs:size() - 1 do
        local location = clothingLocs:get(i):getId();

        if string.find(location, "Amputation") then
            table.insert(amputationSlots, location);
        end
    end

    -- For each amputation slot, is something worn there? (i.e. is there an amputation)
    if #amputationSlots == 0 then return {} end;

    for i, v in ipairs(amputationSlots) do
        if player:getWornItem(amputationSlots[i]) then
            print("getWornItem: " .. player:getWornItem(amputationSlots[i]):getName() or "NO NAME");
            table.insert(currentAmputations, amputationSlots[i]);
        end
    end

    print("AmputationChecks:");
    print(tostring(#currentAmputations));

    return currentAmputations or {};
end

function ProstheticsCore.IsLegLocation(bodyLocation)
    if not bodyLocation then return false end;

    return string.find(bodyLocation, "_RL") or string.find(bodyLocation, "_LL");
end

function ProstheticsCore.IsArmLocation(bodyLocation)
    if not bodyLocation then return false end;

    return string.find(bodyLocation, "_LA") or string.find(bodyLocation, "_RA");
end

function ProstheticsCore.IsAmputation(bodyLocation)
    if not bodyLocation then return false end;

    return string.find(bodyLocation, "Amputation");
end

function ProstheticsCore.IsProsthetic(bodyLocation)
    if not bodyLocation then return false end;

    return string.find(bodyLocation, "Prosthetic");
end

function ProstheticsCore.GetArmAmputations()
    local player = getPlayer();
    if not player then return end;

    return player:getModData().ProstheticsLine_ArmAmputations or {};
end

function ProstheticsCore.GetLegAmputations()
    local player = getPlayer();
    if not player then return end;

    return player:getModData().ProstheticsLine_LegAmputations or {};
end

function ProstheticsCore.GetAllAmputations()
    local player = getPlayer();
    if not player then return end;

    local amputations = {};
    local armAmputations = player:getModData().ProstheticsLine_ArmAmputations;
    local legAmputations = player:getModData().ProstheticsLine_LegAmputations;

    if armAmputations and #armAmputations > 0 then
        table.insert(amputations, armAmputations);
    end

    if legAmputations and #legAmputations > 0 then
        table.insert(amputations, legAmputations);
    end

    return amputations;
end

function ProstheticsCore.GetAmputationActionModifier()
    if SandboxVars.ProstheticsLine and SandboxVars.ProstheticsLine.AmputationDebuffMulti then
        return SandboxVars.ProstheticsLine.AmputationDebuffMulti;
    end 
end

function ProstheticsCore.DoMultiAmputationsDisableActions()
    if SandboxVars.ProstheticsLine and SandboxVars.ProstheticsLine.MultiAmputationDisableActions then
        return SandboxVars.ProstheticsLine.MultiAmputationDisableActions;
    end 
end

return ProstheticsCore;