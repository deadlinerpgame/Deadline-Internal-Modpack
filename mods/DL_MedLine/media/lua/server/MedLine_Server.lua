if isClient() then return end;
require "MedLine_Dict";
MedLine_Dict = MedLine_Dict or {};

MedLine_Server = {};

--- BloodData - stores blood type and state of a player.
--- ["username"] = 
--- {
---     bloodType
--- }
MedLine_Server.BloodData = {};

CachedUserData = {};

function MedLine_Server.OnInitGlobalModData(newGame)
    print("MedLine_Server - OnInitGlobalModData");
    CachedUserData = ModData.getOrCreate(MedLine_Dict.ModDataKeys.UserData);
    print("CachedUserData has " .. tostring(#CachedUserData) .. " stored items.");
end

function MedLine_Server.SaveUserData()
    print("MedLine_Server - SaveUserData.");
    ModData.add(MedLine_Dict.ModDataKeys.UserData, CachedUserData);
    ModData.transmit(MedLine_Dict.ModDataKeys.UserData);
end

function MedLine_Server.OnServerStartSave()
    MedLine_Server.SaveUserData();
end

function MedLine_Server.OnClientCommand(module, command, player, args)
    if module ~= "MedLine" then return end;

    if command == "SyncMedicalData" then
        print("SyncMedicalData called from player " .. player:getUsername());
        local character = args.character; -- Username
        local data = args.data;
        if not character or not data then
            MedLine_Logging.log("SyncMedicalData for player " .. player:getUsername() .. " has either nil character or nil data.");
            return;  
        end

        if not CachedUserData then
            CachedUserData = {};
        end

        if CachedUserData[character] then
            print("Updating player " .. character .. " medical data.");
        end

        CachedUserData[character] = data;
        MedLine_Server.SaveUserData();
    end

    if command == "RequestBloodAction" then
        local tgtUsername = args.target;
        local mode = args.mode; -- 1 == draw, 2 == transfuse.
        if not tgtUsername then return end;

        local allPlayers = getOnlinePlayers();

        for i = 0, allPlayers:size() - 1 do
            local iteratedPlayer = allPlayers:get(i);
            if iteratedPlayer then
                if iteratedPlayer:getUsername() == tgtUsername then
                    MedLine_Logging.log("Sending server command to " .. iteratedPlayer:getUsername() .. " ShowBloodActionModal");
                    sendServerCommand(iteratedPlayer, "MedLine", "ShowBloodActionModal", { src = player:getOnlineID(), srcName = player:getDescriptor():getForename(), mode = mode });
                    return;
                end
            end
        end
    end

    if command == "AcceptBloodAction" then
        local srcUsername = args.src;
        local mode = args.mode;

        local allPlayers = getOnlinePlayers();

        for i = 0, allPlayers:size() - 1 do
            local iteratedPlayer = allPlayers:get(i);
            if iteratedPlayer then
                if iteratedPlayer:getUsername() == srcUsername then
                    sendServerCommand(iteratedPlayer, "MedLine", "OnReceiveAcceptedBloodAction", { target = player:getUsername(), mode = mode });
                    return;
                end
            end
        end
    end

    if command == "SyncBloodBag" then
        local item = args.bloodBag;
        local bloodData = args.bloodData;
        local bloodType = args.bloodType;

        if not item or not bloodData or not bloodType then return end;

        local fromPlayer = getPlayerByOnlineID(bloodData.takenFrom);
        if not fromPlayer then
            MedLine_Logging.log("SyncBloodBag - unable to find player from online ID " .. tostring(bloodData.takenFrom) .. " to initialise blood loss.");
            return;
        end;

        item:setCustomName(false);
        local tooltipStr = string.format("Blood Bag - taken from: %s, type: %s", bloodData.takenFromDisplay, bloodType.type);
        item:setName("Blood Bag - Full (" .. bloodType.type .. ")");

        item:setTooltip(tooltipStr);

        item:getModData().bloodBagInfo =
        {
            bloodData = bloodData,
            bloodType = bloodType,
        };

        sendServerCommand(fromPlayer, "MedLine", "StartBloodDrawBloodLoss", {});
    end

    if command == "ReduceBloodLossDuration" then
        print("ReduceBloodLossDuration");
        local targetUsername = args.target;
        print("ReduceBloodLossDuration for player " .. args.target);
        if not targetUsername then return end;

        local allPlayers = getOnlinePlayers();

        for i = 0, allPlayers:size() - 1 do
            local iteratedPlayer = allPlayers:get(i);
            if iteratedPlayer then
                if iteratedPlayer:getUsername() == targetUsername then
                    MedLine_Logging.log("Sending server command to " .. iteratedPlayer:getUsername() .. " ReduceBloodLossDuration with efficiency " .. tostring(args.efficiency));
                    sendServerCommand(iteratedPlayer, "MedLine", "ReduceBloodLossDuration", { efficiency = args.efficiency });
                    return;
                end
            end
        end
    end

    if command == "ADMIN_OverrideBloodLoss" then
        local targetUsername = args.username;
        local hours = args.time;

        if not targetUsername or not hours then
            MedLine_Logging.log("ADMIN_OverrideBloodLoss - invalid username or hours provided.");
            return;
        end

        CachedUserData[targetUsername].bloodLossStartedUnix = getTimestamp();
        CachedUserData[targetUsername].bloodLossTimeoutUnix = getTimestamp() + (hours * 3600);
        MedLine_Server.SaveUserData();

        for i = 0, allPlayers:size() - 1 do
            local iteratedPlayer = allPlayers:get(i);
            if iteratedPlayer then
                if iteratedPlayer:getUsername() == targetUsername then
                    MedLine_Logging.log("Sending server command to " .. iteratedPlayer:getUsername() .. " ADMIN_OverrideBloodLoss.");
                    sendServerCommand(iteratedPlayer, "MedLine", "ADMIN_OverrideBloodLoss_ForceClientEvents");
                    return;
                end
            end
        end
    end
end

Events.OnInitGlobalModData.Add(MedLine_Server.OnInitGlobalModData);
Events.OnReceiveGlobalModData.Add(MedLine_Server.OnReceiveGlobalModData);

Events.OnClientCommand.Add(MedLine_Server.OnClientCommand);
Events.OnServerStartSaving.Add(MedLine_Server.OnServerStartSave);