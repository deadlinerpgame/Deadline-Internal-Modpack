if isClient() then return end;

require "Logs/ISLogSystem";

SafehouseManagers = {};

function LogSafehouseChange(safehouseKey, changeStr)
    local messageString = string.format("[SafehouseLine] %s: %s", safehouseKey, changeStr); 
    print(messageString);
    writeLog("SafehouseLine", messageString);
    ISLogSystem.sendLog(getPlayer(), "SafehouseLine", messageString);
end

--[[function ValidateManagers()
    local allSafehouses = SafeHouse.getSafehouseList();

    print("ValidateManagers");

    print("There are " .. tostring(allSafehouses:size()) .. " safehouses to iterate");

    for i = 0, allSafehouses:size() - 1 do
        -- Iterate through all safehouses. Check that there are no extraneous managers.
        -- Rare edge case, may happen if player account is deleted rather than them being removed from SH.

        local safehouse = allSafehouses:get(i);
        print("Iterating on safehouse " .. safehouse:getTitle());

        if not safehouse then return end; -- Something's gone badly wrong, kill loop.

        -- Get all safehouse managers.
        local managersForSafehouse = SafehouseManagers[safehouse:getId()];

        if managersForSafehouse and #managersForSafehouse > 0 then
            print("Safehouse has managers.");
            for _, mgr in ipairs(managersForSafehouse) do
                print("Is " .. tostring(mgr) .. " still in SH?");
                if not safehouse:playerAllowed(mgr) then -- If the name ISN'T allowed in the safehouse, something has happened.
                    print("No, removing from list :(");
                    RemoveManagerFromSafehouse(safehouse:getId(), mgr, "ValidateManagers_Server");
                end
            end
        end
    end
end--]]

function OnInitGlobalModData(newGame)
    SafehouseManagers = ModData.getOrCreate("SafehouseLine_Managers");

    --ValidateManagers(); -- You can't be a manager if you are not part of the safehouse.
end

function OnReceiveGlobalModData(key, data)
    --print("OnReceiveGlobalModData");
end

function OnServerStartSave()
    SaveSafehouseManagers();
end 

function SaveSafehouseManagers()
    print("SaveSafehouseManagers");

    if not SafehouseManagers then
        SafehouseManagers = {};
    end

    ModData.add("SafehouseLine_Managers", SafehouseManagers);
    ModData.transmit("SafehouseLine_Managers");

    LogSafehouseChange("SERVER_ALL_SAFEHOUSES", "Safehouse manager list saved");
end

function AddManagerToSafehouse(safehouseKey, newManagerName, issuerName)
    if not SafehouseManagers[safehouseKey] then
        SafehouseManagers[safehouseKey] = {};
    end

    table.insert(SafehouseManagers[safehouseKey], newManagerName);
    
    LogSafehouseChange(safehouseKey, string.format("%s has been added as a manager by %s", newManagerName, issuerName));
    SaveSafehouseManagers();
end

function RemoveManagerFromSafehouse(safehouseKey, managerName, issuerName)
    if not safehouseKey then return end;

    if not SafehouseManagers[safehouseKey] then return end;

    for i, v in ipairs(SafehouseManagers[safehouseKey]) do
        local iteratedManager = SafehouseManagers[safehouseKey][i];

        if iteratedManager and iteratedManager == managerName then
            table.remove(SafehouseManagers[safehouseKey], i);
        end
    end

    LogSafehouseChange(safehouseKey, string.format("%s has been removed as a manager by %s", managerName, issuerName));
    SaveSafehouseManagers();
end

function OnClientCommand(module, command, player, args)
    if module ~= "SafehouseLine" then return end;
    if not args then return end;

    if not (args.safehouse or args.manager or args.issuer) then return end;

    local safehouseId = tostring(args.safehouse); -- Allows giving either safehouse itself or the ID.
    if not safehouseId then return end;

    if command == "AddSafehouseManager" then
        AddManagerToSafehouse(safehouseId, args.manager, args.issuer);
    elseif command == "RemoveSafehouseManager" then
        RemoveManagerFromSafehouse(safehouseId, args.manager, args.issuer);
    end
end


Events.OnInitGlobalModData.Add(OnInitGlobalModData);
Events.OnReceiveGlobalModData.Add(OnReceiveGlobalModData);
Events.OnServerStartSaving.Add(OnServerStartSave);
Events.OnClientCommand.Add(OnClientCommand);