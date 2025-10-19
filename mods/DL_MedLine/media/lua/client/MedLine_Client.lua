require "MedLine_Events";
require "MF_ISMoodle";

MF = MF or {};

MedLine_Client = {};
MedLine_Events = MedLine_Events or {};

function MedLine_Client.initialiseMedicalData()
    local playerModData = getPlayer():getModData();

    local bloodData = MLBloodData:new(getPlayer());
    playerModData.MedLine = {};
    playerModData.MedLine.BloodData = bloodData;
    bloodData:allocateBloodType();
    bloodData:save();

    getPlayer():transmitModData();
    MedLine_Logging.log("Allocated new blood data: " .. bloodData:tostring());
end

function MedLine_Client.OnCreatePlayer(playerNum, player)
    if player ~= getPlayer() or not player:isLocalPlayer() then return end;

    local playerModData = getPlayer():getModData();
    if not playerModData then return end;

    if not playerModData.MedLine then
        playerModData.MedLine = {};
    end

    -- This is simply because due to multiplayer tomfoolery players may have corrupted mod data, so find the most common function and if it doesn't exist, make it.
    if not playerModData.MedLine.BloodData or not playerModData.MedLine.BloodData["isRecoveringFromBloodLoss"] then
        MedLine_Client.initialiseMedicalData();
    else
        MedLine_Client.checkBloodLossRecovery();
    end
end

function MedLine_Client.getBloodData()
    local playerModData = getPlayer():getModData();
    if not playerModData then return end;

    if not playerModData.MedLine then
        playerModData.MedLine = {};
    end

    if not playerModData.MedLine.BloodData then
        MedLine_Client.initialiseMedicalData();
    end

    return playerModData.MedLine.BloodData;
end

function MedLine_Client.getBloodDataEx(player)
    if not player then return nil end;

    local playerModData = player:getModData();
    if not playerModData then return end;

    return playerModData.MedLine.BloodData or nil;
end

function MedLine_Client.hasPrevChangedBloodType()
    
    local bloodData = MedLine_Client.getBloodData();
    if not bloodData then return end;

    return bloodData:hasChangedBloodType();
end

function MedLine_Client.initiateBloodLossStart()
    local bloodData = MedLine_Client.getBloodData();
    if not bloodData then return end;

    bloodData:setHasLapsedBelowThreshold();

    local bloodLossMoodle = MF.getMoodle("BloodLoss", getPlayer():getPlayerNum());
    bloodLossMoodle:setValue(0);

    -- Now handle events.
    Events.OnPlayerUpdate.Add(MedLine_Events.OnPlayerUpdate);
end

function MedLine_Client.setBloodLossStopped()
    local bloodData = MedLine_Client.getBloodData();
    if not bloodData then return end;

    local bloodLossMoodle = MF.getMoodle("BloodLoss", getPlayer():getPlayerNum());
    bloodLossMoodle:setValue(0.5);

    bloodData:setHasRecoveredFromBloodLoss();

    local stats = getPlayer():getStats();
    if not stats then return end;

    stats:setEndurancelast(1.0);
end

function MedLine_Client.stopBloodLossEventHooks()
    Events.OnPlayerUpdate.Remove(MedLine_Events.OnPlayerUpdate);
end

function MedLine_Client.hasChangedBloodType()
    local playerModData = getPlayer():getModData();
    if not playerModData then return false end;

    if not playerModData.MedLine then return false end;

    if not playerModData.MedLine.BloodData then return false end;

    return playerModData.MedLine.BloodData:hasChangedBloodType();
end

function MedLine_Client.isRecoveringFromBloodLoss()
    local bloodData = MedLine_Client.getBloodData();
    if not bloodData then return end;

    return bloodData:isRecoveringFromBloodLoss();
end

function MedLine_Client.isRecoveringFromBloodLossEx(player)
    local bloodData = MedLine_Client.getBloodDataEx(player);
    if not bloodData then return end;

    return bloodData:isRecoveringFromBloodLoss();
end

function MedLine_Client.checkBloodLossRecovery()
    local bloodData = MedLine_Client.getBloodData();
    if not bloodData then return end;

    local moodleVal = bloodData:getRecoveryMoodleValue();
    if not moodleVal then moodleVal = 0.5; end;
    MF.getMoodle("BloodLoss", getPlayer():getPlayerNum()):setValue(moodleVal);

    if moodleVal == 0.5 then
        MedLine_Client.setBloodLossStopped();
    end
end

Events.OnCreatePlayer.Add(MedLine_Client.OnCreatePlayer);

return MedLine_Client;