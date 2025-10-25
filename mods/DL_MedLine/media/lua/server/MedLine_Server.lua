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
MedLine_Server.UserData = {};

function MedLine_Server.OnInitGlobalModData(newGame)
    print("MedLine_Server - OnInitGlobalModData");
    MedLine_Server.UserData = ModData.getOrCreate(MedLine_Dict.ModDataKeys.UserData);

    print("MedLine_Server - UserData keys:");
    for k, _ in pairs(MedLine_Server.UserData) do
        print(k);

        for i, v in ipairs(MedLine_Server.UserData[k]) do
            print(" -> " .. tostring(i) .. ": " .. tostring(v));
        end
    end
end

function MedLine_Server.SaveUserData()
    print("MedLine_Server - SaveUserData with " .. tostring(#MedLine_Server.UserData) .. " entries.");
    ModData.add(MedLine_Dict.ModDataKeys.UserData, MedLine_Server.UserData);
    ModData.transmit(MedLine_Dict.ModDataKeys.UserData);
end

function MedLine_Server.OnReceiveGlobalModData(key, data)

end

function MedLine_Server.OnClientCommand(module, command, player, args)
    if module ~= "MedLine" then return end;

    if command == "SyncMedicalData" then
        local character = args.character; -- Username
        local data = args.data;
        if not character or not data then return end;

        if not MedLine_Server.UserData then
            MedLine_Server.UserData = {};
        end

        if not MedLine_Server.UserData[character] then
            table.insert(MedLine_Server.UserData[character], data);
        else
            MedLine_Server.UserData[character] = data;
        end
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
end

Events.OnInitGlobalModData.Add(MedLine_Server.OnInitGlobalModData);
Events.OnReceiveGlobalModData.Add(MedLine_Server.OnReceiveGlobalModData);

Events.OnClientCommand.Add(MedLine_Server.OnClientCommand);