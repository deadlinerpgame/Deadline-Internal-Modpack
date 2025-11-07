require "MedLine_Events";
require "MedLine_Dict";
require "MF_ISMoodle";

MF = MF or {};

MedLine_Client = {};
MedLine_Dict = MedLine_Dict or {};
MedLine_Events = MedLine_Events or {};

MedLine_Client.CachedMedicalData = {};

function MedLine_Client.initialiseMedicalData(player)
    if not player then player = getPlayer() end;

    MedLine_Logging.log("Medical data does not exist for player " .. player:getUsername());

    player:getModData().MedLine = {};
    player:getModData().MedLine.BloodData = {};

    MedLine_Client.allocateBloodType(player);
    MedLine_Client.saveMedicalData();

    MedLine_Logging.log("Allocated new blood data.");
end

function MedLine_Client.getBloodTypeTraits()
    local returnList = {};

    for _, bloodType in ipairs(MedLine_Dict.BLOOD_TYPES) do
        table.insert(returnList, TraitFactory.getTrait(bloodType.traitStr));
    end
    
    return returnList;
end

---Gets the blood type table for the given player.
---@param player IsoPlayer The player whose blood type to get.
---@return table|nil table The returned blood type or nil if not found.
function MedLine_Client.getBloodType(player)
    if not player then player = getPlayer() end;

    local returnType = nil;

    for _, bloodType in ipairs(MedLine_Dict.BLOOD_TYPES) do
        if player:HasTrait(bloodType.traitStr) then
            returnType = bloodType;
        end
    end

    if returnType == nil then
        MedLine_Logging.log("Attempted to get blood type " .. player:getUsername() .. " from player but could not find it.");
    end
    return returnType;
end

function MedLine_Client.doesPlayerHaveBloodLoss(player)
    if not player then return end;
    if not player:getPlayerNum() then return end;
    if not MF then return end;

    local num = player:getPlayerNum();
    local bloodLossMoodle = MF.getMoodle("BloodLoss", num);

    local value = bloodLossMoodle:getValue();
    if not value or value == 0.5 then return false end;

    return true;
end


function MedLine_Client.allocateBloodType(player)
    if not player then player = getPlayer() end;
    if player ~= getPlayer() then return end; -- Since this is random, you only want this to be done once and on the client.

    MedLine_Logging.log("[allocateBloodType] Start");

    local weight = 0;
    local allocatedBloodType = nil;

    -- Calculate total value of all blood type chances.
    for _, bloodType in ipairs(MedLine_Dict.BLOOD_TYPES) do
        if bloodType and bloodType.chance then
            weight = weight + bloodType.chance;
        end
    end

    MedLine_Logging.log("[allocateBloodType] Weights calculated.");

    -- Get random num which is used to essentially determine the blood type.
    local randomNum = ZombRandFloat(0.0, weight);
    MedLine_Logging.log("[allocateBloodType] Random weight: " .. tostring(randomNum));

    local iteratedWeight = 0;
    for _, bloodType in ipairs(MedLine_Dict.BLOOD_TYPES) do
        if bloodType and not allocatedBloodType then
            iteratedWeight = iteratedWeight + bloodType.chance;

            MedLine_Logging.log("[allocateBloodType] " .. tostring(bloodType.type) .. " - iterated weight is " .. tostring(iteratedWeight) .. " vs random weight of " .. tostring(randomNum));

            if randomNum < iteratedWeight then
                allocatedBloodType = bloodType;
                MedLine_Logging.log("[allocateBloodType] Allocated blood type is " .. bloodType.type);
            end
        end
    end

    getPlayer():getModData().MedLine.BloodData.bloodType = allocatedBloodType;

    if allocatedBloodType and allocatedBloodType.traitStr then
        getPlayer():getTraits():add(allocatedBloodType.traitStr);
        SyncXp(getPlayer());
    end
    
    MedLine_Logging.log("[allocateBloodType] Blood type allocated and stopping.\n");
end

function MedLine_Client.saveMedicalData()
    local username = getPlayer():getUsername();

    sendClientCommand(getPlayer(), "MedLine", "SyncMedicalData", { character = username, data = getPlayer():getModData().MedLine.BloodData or {} });
end

function MedLine_Client.OnCreatePlayer(playerNum, player)
    print("OnCreatePlayer for " .. player:getUsername());
    ModData.request(MedLine_Dict.ModDataKeys.UserData);
    print("Mod data requested for userdata.");
end

function MedLine_Client.getBloodData()
    return getPlayer():getModData().MedLine.BloodData or {};
end


function MedLine_Client.changeBloodType(newType, override)
    if not override and MedLine_Client.hasPrevChangedBloodType() then return end;

    local player = getPlayer();

    local currentBloodType = MedLine_Client.getBloodType(player);
    if not currentBloodType then return end;
    
    local matchingType = nil;
    for _, bloodType in pairs(MedLine_Dict.BLOOD_TYPES) do
        if bloodType.type == newType then
            matchingType = bloodType;
        end
    end

    -- Conceivably if something intercepts the ISChat options and prevents the full blood types dict being added, then this will error.
    -- Setting a player's blood type to an invalid one or nil could be disasterous.
    if not matchingType then return end;

    player:getTraits():remove(currentBloodType.traitStr);
    player:getTraits():add(matchingType.traitStr);
    SyncXp(player);
    
    MedLine_Client.getBloodData().hasPrevChangedBloodType = true;
    MedLine_Client.saveMedicalData();

    MedLine_Logging.log("Blood type changed completed.");
end

function MedLine_Client.hasPrevChangedBloodType()
    
    local bloodData = MedLine_Client.getBloodData();
    if not bloodData then return end;

    return bloodData.hasPrevChangedBloodType;
end

function MedLine_Client.setHasLapsedBelowThreshold(timeInDays)
    local bloodData = MedLine_Client.getBloodData();
    if not bloodData then return end;

    if not timeInDays then timeInDays = (SandboxVars.MedLine.BloodLoss_RecoveryTimeDays or 14) end;

    -- Multiply that by number of seconds in a day. 
    local daysAsSeconds = timeInDays * 86400;

    bloodData.bloodLossStartedUnix = getTimestamp();
    bloodData.bloodLossTimeoutUnix = getTimestamp() + daysAsSeconds;
    bloodData.hasLapsedBelowThreshold = true;
end

function MedLine_Client.hasLapsedBelowThreshold()
    local bloodData = MedLine_Client.getBloodData();
    if not bloodData then return end;

    return bloodData.hasLapsedBelowThreshold;
end

function MedLine_Client.setNowAboveThreshold()
    local bloodData = MedLine_Client.getBloodData();
    if not bloodData then return end;

    bloodData.hasLapsedBelowThreshold = false;
end

function MedLine_Client.getRecoveryDaysRemaining()
    local bloodData = MedLine_Client.getBloodData();
    if not bloodData then return end;

    if not bloodData.bloodLossStartedUnix or not bloodData.bloodLossTimeoutUnix then return 0 end;

    local remainingSeconds = bloodData.bloodLossTimeoutUnix - getTimestamp();
    return remainingSeconds / 86400;
end

function MedLine_Client.getRecoveryDaysRemainingAsString()
    local daysRemaining = MedLine_Client.getRecoveryDaysRemaining();
    if not daysRemaining then return "Not Recovering" end;

    if daysRemaining <= 0.9 then return "Less than a day remaining." end;

    if daysRemaining > 0.9 and daysRemaining < 1.2 then return "Approximately a day remaining." end;

    return daysRemaining .. " days remaining";
end

---Initiates the blood loss process on the local client and applies the moodle.
---@param timeInDays number The number of days that the blood loss should last for based on how the blood loss was caused.
function MedLine_Client.initiateBloodLossStart(timeInDays)
    local bloodData = MedLine_Client.getBloodData();
    if not bloodData then return end;

    if not timeInDays then timeInDays = (SandboxVars.MedLine.BloodLoss_RecoveryTimeDays or 14) end;

    MedLine_Client.setHasLapsedBelowThreshold(timeInDays);

    local bloodLossMoodle = MF.getMoodle("BloodLoss", getPlayer():getPlayerNum());
    bloodLossMoodle:setValue(0);
    MedLine_Client.saveMedicalData();

    -- Now handle events.
    Events.OnPlayerUpdate.Add(MedLine_Events.OnPlayerUpdate);
end

function MedLine_Client.setHasRecoveredFromBloodLoss()
    local bloodData = MedLine_Client.getBloodData();
    if not bloodData then return end;

    bloodData.bloodLossStartedUnix = nil;
    bloodData.bloodLossTimeoutUnix = nil;
    bloodData.hasLapsedBelow = nil;
end

function MedLine_Client.setBloodLossStopped()
    local bloodData = MedLine_Client.getBloodData();
    if not bloodData then return end;

    local bloodLossMoodle = MF.getMoodle("BloodLoss", getPlayer():getPlayerNum());
    bloodLossMoodle:setValue(0.5);

    MedLine_Client.setHasRecoveredFromBloodLoss();

    local stats = getPlayer():getStats();
    if not stats then return end;

    stats:setEndurancelast(1.0);
end

function MedLine_Client.reduceBloodLossByPercentage(efficiency)

    if not efficiency then
        MedLine_Logging.log("reduceBloodLossByPercentage called with nil efficiency.");
        return;
    end

    local totalReduction = SandboxVars.BloodLoss_TransfusionPercentageReduction or 50;
    local actualEfficiency = (totalReduction / 100) * (efficiency / 100);

    if not totalReduction or actualEfficiency then
        MedLine_Logging.log("reduceBloodLossByPercentage totalReduction or actualEfficiency is nil.");
        return;
    end

    -- We are going to reduce the remaining blood loss time by X% which is expressed in terms of IRL days.
    -- If 5 days remaining, then at 50% actual efficiency this is reduced to 5 days * 0.5 = 2.5 days of blood loss remaining.

    -- To do that, we simply get the current timestamp and that value to the days remaining.
    local bloodData = MedLine_Client.getBloodData();
    if not bloodData then
        MedLine_Logging.log("Could not find blood data.");
        return;
    end

    local totalSecondsDiff = bloodData.bloodLossTimeoutUnix - bloodData.bloodLossStartedUnix;
    print("reduceBloodLossByPercentage totalSecondsDiff is " .. tostring(totalSecondsDiff));

    local relativePosition = bloodData.bloodLossTimeoutUnix - getTimestamp();
    print("reduceBloodLossByPercentage relativePosition is " .. tostring(relativePosition));

    local newRemainingTime = relativePosition * actualEfficiency;
    print("New remaining time is " .. tostring(newRemainingTime));

end

function MedLine_Client.stopBloodLossEventHooks()
    Events.OnPlayerUpdate.Remove(MedLine_Events.OnPlayerUpdate);
end

function MedLine_Client.hasChangedBloodType()
    local bloodData = MedLine_Client.getBloodData();
    if not bloodData then return end;
    
    return bloodData.hasChangedBloodType;
end

function MedLine_Client.isRecoveringFromBloodLoss()
    local bloodData = MedLine_Client.getBloodData();
    if not bloodData then return end;

    return bloodData.isRecoveringFromBloodLoss;
end

function MedLine_Client.checkBloodLossRecovery()
    print("Checking for blood loss recovery.");
    local bloodData = MedLine_Client.getBloodData();
    if not bloodData then return end;

    if not bloodData.bloodLossTimeoutUnix then
        return;
    end

    local currentTime = getTimestamp();

    if bloodData.bloodLossTimeoutUnix > currentTime then -- If unix > current then we're not there yet.
        if isDebugEnabled() then
            print("BloodLossRecovery: timeout unix is " .. tostring(bloodData.bloodLossTimeoutUnix) .. " vs current time " .. getTimestamp());
            return;
        end
    end;

    if currentTime >= bloodData.bloodLossTimeoutUnix then
        MedLine_Client.setBloodLossStopped();
        return;
    end

    local moodleVal = MedLine_Client.getRecoveryMoodleValue();
    if not moodleVal then moodleVal = 0.5; end;
    MF.getMoodle("BloodLoss", getPlayer():getPlayerNum()):setValue(moodleVal);
end

--[[

--]]

function MedLine_Client.procedureItemsToString(player, itemList)
    if not player then return end;
    if not itemList then return "INVALID_PROC_ITEM_LIST" end;

    local scriptManager = getScriptManager();
    if not scriptManager then return end;

    local outputString = "";

    for i, v in ipairs(itemList) do
        local itemDef = scriptManager:getItem(v);
        if itemDef then
            local hasItem = player:getInventory():containsTypeRecurse(v);
            local colourTxt = hasItem and " <RGB:0,1,0> " or " <RGB:1,0,0> ";

            outputString = outputString .. string.format("%s %s %s", colourTxt or "", itemDef:getDisplayName() or v, (i > 1 and ", " or " "));
        end
    end

    return outputString;
end

MedLine_Client.bloodDrawItems = {
    "MedLine.BloodBag_Empty",
};

MedLine_Client.bloodTransfusionItems = {
    "MedLine.BloodBag_Full",
};


---Checks a player's inventory to determine if their inventory contains the item specified.
---Returns true if found in inventory or a container, returns false if not.
---@param player IsoPlayer The player whose inventory and all containers to check.
---@param itemType string The item type e.g. "BloodBag_Empty".
function MedLine_Client.recursiveItemCheck(player, itemType)
    if not player then return end;
    if not itemType then return end;

    return player:getInventory():containsTypeRecurse(itemType);
end

---recursiveItemCheck but accepts a list of strings instead.
---@param player IsoPlayer The player whose containers and inventory to check.
---@param itemTypeList table<string> A table of strings for which item types to check.
function MedLine_Client.recursiveItemCheckEx(player, itemTypeList)
    if not player then return end;
    if not itemTypeList then return end;
    if #itemTypeList == 0 then return end;

    for _, iteratedType in ipairs(itemTypeList) do
        if not player:getInventory():containsTypeRecurse(iteratedType) then
            return false
        end
    end

    return true;
end

function MedLine_Client.hasItemsForBloodDraw(player)
    if not player then return end;
    
    return MedLine_Client.recursiveItemCheckEx(player, MedLine_Client.bloodDrawItems);
end

function MedLine_Client.getSalineBag(player)
    if not player then return end;

    local salineBags = player:getInventory():getAllTypeRecurse("MedLine.BloodBag_Saline");
    if not salineBags or salineBags:size() == 0 then return nil end;

    return salineBags:get(0) or nil;
end

function MedLine_Client.getBloodBagOfType(player, targetBloodType)
    if not player then return end;
    if not targetBloodType or not targetBloodType.type then
        MedLine_Logging.log("getBloodBagOfType - no targetBloodType");
        error("getBloodBagOfType invalid targetBloodType", 1);
    end

    local bloodBags = player:getInventory():getAllTypeRecurse("MedLine.BloodBag_Full");

    for i = 0, bloodBags:size() - 1 do
        local bag = bloodBags:get(i);
        if bag then
            local modData = bag:getModData().bloodBagInfo;
            if modData then
                if modData.bloodType.type == targetBloodType.type then
                    return bag;
                end
            end
        end
    end

    return nil;
end

function MedLine_Client.hasItemsForBloodTransfusion(player, targetBloodtype)
    if not player then return end;
    if not targetBloodType then
        MedLine_Logging.log("hasItemsForBloodTransfusion - no targetBloodType");
        error("hasItemsForBloodTransfusion", 1);
    end;
    
    if not MedLine_Client.recursiveItemCheckEx(player, MedLine_Client.bloodTransfusionItems) then return false end;

    local bagList = player:getInventory():getAllTypeRecurse("MedLine.BloodBag_Full");
    for i = 0, bagList:size() - 1 do
        local bag = bagList:get(i);
        if bag then
            local modData = bag:getModData().bloodBagInfo;
            if modData then
                if modData.bloodType and modData.bloodType.type and modData.bloodType.type == targetBloodtype.type then
                    return true;
                end
            end
        end
    end
end


--[[

--]]

function MedLine_Client.setBloodBagData(item, fromPlayer)
    if not item or not fromPlayer then return end;

    MedLine_Logging.log("setBloodBagData for player " .. fromPlayer:getUsername());

    local bloodData =
    {
        takenFrom = fromPlayer:getOnlineID(),
        takenFromDisplay = fromPlayer:getDescriptor():getForename(),
        takenDate = getTimestamp(),
    }

    local bloodType = MedLine_Client.getBloodType(fromPlayer);
    if not bloodType then return end;

    MedLine_Logging.log("Blood type for player " .. fromPlayer:getUsername() .. " is " .. bloodType.type);
    
    item:setCustomName(false);

    item:setName("Blood Bag - Full (" .. bloodType.type .. ")");
    item:getModData().bloodBagInfo =
    {
        bloodData = bloodData,
        bloodType = bloodType,
    };

    sendClientCommand(getPlayer(), "MedLine", "SyncBloodBag", { bloodBag = item, bloodData = bloodData, bloodType = bloodType });
end

--[[

--]]

function MedLine_Client.getRecoveryMoodleValue()
    local bloodData = MedLine_Client.getBloodData();
    if not bloodData then return 0.5 end;

    if not bloodData.bloodLossTimeoutUnix or not bloodData.bloodLossStartedUnix then return 0.5 end;

    local totalSecondsDiff = bloodData.bloodLossTimeoutUnix - bloodData.bloodLossStartedUnix;
    local relativePosition = bloodData.bloodLossTimeoutUnix - getTimestamp();

    local timeDiff = Math.floor((relativePosition / totalSecondsDiff) * 100); -- % of days remaining.
     
    -- This will give % of time remaining. As there are 4 levels to the moodle, split into 25%;
    if timeDiff > 75 then
        return 0.1;
    end

    if timeDiff <= 75 and timeDiff > 50 then
        return 0.2;
    end

    if timeDiff <= 50 and timeDiff > 25 then
        return 0.3;
    end

    if timeDiff > 0.0 then
        return 0.4;
    end;

    return 0.5; -- This is the default "neutral" value which means no more time remaining.
end

Events.OnCreatePlayer.Add(MedLine_Client.OnCreatePlayer);

return MedLine_Client;