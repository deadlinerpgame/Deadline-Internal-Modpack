ProstheticsCore = {};

ProstheticsCore.PROSTHETIC_TIERS =
{
    [1] = "Basic",
    [2] = "Articulated",
    [3] = "Battery-Powered",
    [4] = "Futuristic"
}

GameTime = {};

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

function ProstheticsCore.CheckForProsthetics()
    local player = getPlayer();
    if not player then return end;

    local prosSlots = {};
    local currentPros = {};

    local humanGroup = BodyLocations.getGroup("Human");
    local clothingLocs = humanGroup:getAllLocations();

    for i = 0, clothingLocs:size() - 1 do
        local location = clothingLocs:get(i):getId();

        if string.find(location, "Prosthetic") then
            table.insert(prosSlots, location);
        end
    end

    if #prosSlots == 0 then return {} end;

    for i, v in ipairs(prosSlots) do
        if player:getWornItem(prosSlots[i]) then
            print("getWornItem: " .. player:getWornItem(prosSlots[i]):getName() or "NO NAME");
            table.insert(currentPros, prosSlots[i]);
        end
    end

    return currentPros or {};
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

function ProstheticsCore.GetProstheticTier(item)
    for i, v in ipairs(ProstheticsCore.PROSTHETIC_TIERS) do
        local tier = ProstheticsCore.PROSTHETIC_TIERS[i];

        if item:hasTag(tier) then
            return i;
        end
    end

    return 0;
end

function ProstheticsCore.GetMultiplierFromProstheticTier(tier)
    if tier == 1 then return SandboxVars.ProstheticsLine.ProsTier_BasicMult end;
    if tier == 2 then return SandboxVars.ProstheticsLine.ProsTier_ArticulatedMult end;
    if tier == 3 then return SandboxVars.ProstheticsLine.ProsTier_BatteryMult end;
    if tier == 4 then return SandboxVars.ProstheticsLine.ProsTier_FuturisticMult end;

    return 1;
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

function ProstheticsCore.GetAmputationCount()
    local player = getPlayer();
    if not player then return end;

    local count = 0;

    local armAmputations = player:getModData().ProstheticsLine_ArmAmputations;
    local legAmputations = player:getModData().ProstheticsLine_LegAmputations;

    if armAmputations then
        count = count + #armAmputations;
    end

    if legAmputations then
        count = count + #legAmputations;
    end

    return count;
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

--[[
        TIME HELPERS
--]]
function ProstheticsCore.GetMinutesDiffMs(oldTimestamp)
    return ProstheticsCore.GetMinutesDiff(Calendar.getInstance():getTimeInMillis(), oldTimestamp);
end

function ProstheticsCore.GetMinutesDiffMs(currentTimestamp, oldTimestamp)
    local diff = math.abs(currentTimestamp - oldTimestamp);
    return math.floor(diff / 60000);
end

function ProstheticsCore.GetCurrentTimeInMs()
    return getGameTime():getInstance():getTimeInMillis();
end

function ProstheticsCore.MinutesToMs(minutes)
    return math.floor(minutes * 60000);
end

---------------------------------------------------------------

return ProstheticsCore;