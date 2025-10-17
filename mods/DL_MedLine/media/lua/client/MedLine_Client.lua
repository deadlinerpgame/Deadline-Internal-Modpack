MedLine_Client = {};

function MedLine_Client.OnCreatePlayer(playerNum, player)
    if player ~= getPlayer() or not player:isLocalPlayer() then return end;

    local playerModData = getPlayer():getModData();
    if not playerModData then return end;

    if not playerModData.MedLine then
        playerModData.MedLine = {};
    end

    if not playerModData.MedLine.BloodData then
        local bloodData = MLBloodData:new(getPlayer());
        playerModData.MedLine.BloodData = bloodData;
        bloodData:allocateBloodType();

        MedLine_Logging.log("Allocated new blood data: " .. bloodData:tostring());
    end
end

function MedLine_Client.getBloodData()
    local playerModData = getPlayer():getModData();
    if not playerModData then return end;

    return playerModData.MedLine.BloodData or nil;
end

function MedLine_Client.getBloodType()
    local playerModData = getPlayer():getModData();
    if not playerModData then return end;

    if not playerModData.MedLine then
        playerModData.MedLine = {};
    end

    if not playerModData.MedLine.BloodData then
        return {};
    end

    return playerModData.MedLine.BloodData:getBloodType();
end


function MedLine_Client.initiateBloodLossStart()
    local bloodData = MedLine_Client.getBloodData();
    if not bloodData then return end;

    bloodData:setHasLapsedBelowThreshold();

    MF.getMoodle("BloodLoss", getPlayer():getPlayerNum()):setValue(0);
end


function MedLine_Client.hasChangedBloodType()
    local playerModData = getPlayer():getModData();
    if not playerModData then return false end;

    if not playerModData.MedLine then return false end;

    if not playerModData.MedLine.BloodData then return false end;

    return playerModData.MedLine.BloodData:hasChangedBloodType();
end

Events.OnCreatePlayer.Add(MedLine_Client.OnCreatePlayer);

return MedLine_Client;