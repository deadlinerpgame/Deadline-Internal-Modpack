ProstheticsCore = {};

ProstheticsCore.PROSTHETIC_TIERS = {};

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
            table.insert(currentAmputations, amputationSlots[i]);
        end
    end

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
        local slot = prosSlots[i];

        if player:getWornItem(slot) then
            
            table.insert(currentPros, slot);

            local item = player:getWornItem(slot);
            local tier = ProstheticsCore.GetProstheticTier(item:getType());
            if tier then
                item:getModData().ProstheticsLine_ProstheticModifier = ProstheticsCore.GetMultiplierFromProstheticTier(tier);
            end
        end
    end

    return currentPros or {};
end

function ProstheticsCore.GetProstheticTier(itemName)
    print("GET PROSTHETIC TIER")
    print(itemName);
    for tier, tierStr in ipairs(ProstheticsCore.PROSTHETIC_TIERS) do
        local splitList = string.split(tierStr, ";");
        if not splitList then return 1 end;

        for i, iteratedItem in ipairs(splitList) do
            if itemName == iteratedItem then
                print("Tier is " .. tostring(tier));
                return tier;
            end
        end
    end
end

function ProstheticsCore.IsLegLocation(bodyLocation)
    if not bodyLocation then return false end;

    return string.find(bodyLocation, "_RL") or string.find(bodyLocation, "_LL") or string.find(bodyLocation, "Leg");
end

function ProstheticsCore.IsArmLocation(bodyLocation)
    if not bodyLocation then return false end;

    return string.find(bodyLocation, "_LA") or string.find(bodyLocation, "_RA") or string.find(bodyLocation, "Arm");
end

function ProstheticsCore.IsAmputation(bodyLocation)
    if not bodyLocation then return false end;

    return string.find(bodyLocation, "Amputation");
end

function ProstheticsCore.IsProsthetic(bodyLocation)
    if not bodyLocation then return false end;

    return string.find(bodyLocation, "Prosthetic");
end

function ProstheticsCore.GetMultiplierFromProstheticTier(tier)
    if tier == 1 then return SandboxVars.ProstheticsLine.ProsTierBasic end;
    if tier == 2 then return SandboxVars.ProstheticsLine.ProsTierArticulated end;
    if tier == 3 then return SandboxVars.ProstheticsLine.ProsTierBattery end;
    if tier == 4 then return SandboxVars.ProstheticsLine.ProsTierFuturistic end;

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



function ProstheticsCore.GetArmProsthetics()
    local player = getPlayer();
    if not player then return end;

    return player:getModData().ProstheticsLine_ArmProsthetics or {};
end

function ProstheticsCore.GetLegProsthetics()
    local player = getPlayer();
    if not player then return end;

    return player:getModData().ProstheticsLine_LegProsthetics or {};
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
    return getGametimeTimestamp();
end

function ProstheticsCore.MinutesToMs(minutes)
    return math.floor(minutes * 60000);
end

---------------------------------------------------------------
function ProstheticsCore.LoadProstheticItems()
    ProstheticsCore.PROSTHETIC_TIERS = {};

    local basic = SandboxVars.ProstheticsLine.ProsItemsBasic;
    local artic = SandboxVars.ProstheticsLine.ProsItemsArticulated;
    local batt = SandboxVars.ProstheticsLine.ProsItemsBattery;
    local future = SandboxVars.ProstheticsLine.ProsItemsFuturistic;

    if basic then ProstheticsCore.PROSTHETIC_TIERS[1] = basic end;
    if artic then ProstheticsCore.PROSTHETIC_TIERS[2] = artic end;
    if batt then ProstheticsCore.PROSTHETIC_TIERS[3] = batt end;
    if future then ProstheticsCore.PROSTHETIC_TIERS[4] = future end;
end

function ProstheticsCore.OnLoad()
    ProstheticsCore.LoadProstheticItems();
end

Events.OnLoad.Add(ProstheticsCore.OnLoad);
---------------------------------------------------------------

return ProstheticsCore;