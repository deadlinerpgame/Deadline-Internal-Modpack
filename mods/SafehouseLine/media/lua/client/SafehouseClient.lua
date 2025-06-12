if isServer() then return end;

SafehouseManagersCache = {};

SafehouseClient = {};

local SANDBOX_OPTIONS = getSandboxOptions();

function SafehouseClient.OnReceiveGlobalModData(key, data)
    if key ~= "SafehouseLine_Managers" then return end;

    SafehouseManagersCache = data;

    if ISSafehouseUI.instance then
        ISSafehouseUI.instance:populateList();
        ISSafehouseUI.instance:updateManagerButtons();
    end
end

function SafehouseClient.OnInitGlobalModData(newGame)
    SafehouseManagersCache = ModData.getOrCreate("SafehouseLine_Managers");
    ModData.request("SafehouseLine_Managers");
end

function SafehouseClient.AddSafehouseManager(safehouse, newManager)
    if SafehouseClient.IsManager(newManager, safehouse) then return end;

    local id  = SafehouseClient.GetSafehouseKey(safehouse);
    sendClientCommand(getPlayer(), "SafehouseLine", "AddSafehouseManager", { safehouse = id, manager = newManager:getUsername(), issuer = getPlayer():getUsername() });
end

function SafehouseClient.RemoveSafehouseManager(safehouse, newManager)
    if not SafehouseClient.IsManager(newManager, safehouse) then return end;

    local id  = SafehouseClient.GetSafehouseKey(safehouse);
    sendClientCommand(getPlayer(), "SafehouseLine", "RemoveSafehouseManager", { safehouse = id, manager = newManager:getUsername(), issuer = getPlayer():getUsername() });
end

function SafehouseClient.getUIFontScale()
	return 1 + (getCore():getOptionFontSize() - 1) / 4;
end

function SafehouseClient.IsManager(player, safehouse)
    if not player or not safehouse then return false end;

    local username = player:getUsername();
    if not username then return false end;

    return SafehouseClient.IsManagerEx(username, safehouse);
end

function SafehouseClient.IsManagerEx(playerName, safehouse)
    if not playerName or not safehouse then return false end;

    local mgrs = SafehouseClient.GetSafehouseManagers(safehouse);
    if not mgrs or #mgrs == 0 then return false end;

    for i, v in ipairs(mgrs) do

        if v == playerName then
            return true;
        end
    end

    return false;
end

function SafehouseClient.GetSafehouseManagers(safehouse)
    local key = SafehouseClient.GetSafehouseKey(safehouse);
    if not key then return {} end;
    
    if not SafehouseManagersCache[key] then return {} end;

    return SafehouseManagersCache[key];
end

function SafehouseClient.GetRemainingManagerSlots(safehouse)
    local maxManagers = SANDBOX_OPTIONS:getOptionByName("SafehouseLine.MaxManagers"):getValue(); 

    local key = SafehouseClient.GetSafehouseKey(safehouse);
    if not key then return  end;
    
    if not SafehouseManagersCache[key] then return maxManagers end;

    local managersForSafehouse = SafehouseClient.GetSafehouseManagers(safehouse);
    if not maxManagers or not managersForSafehouse then return maxManagers end;

    return maxManagers - #managersForSafehouse;
end

function SafehouseClient.GetSafehouseKey(safehouse)
    if not safehouse then return nil end;

    return string.format("%s|%d-%d-%d", safehouse:getTitle(), safehouse:getX(), safehouse:getY(), safehouse:getW());
end


function SafehouseClient.OnCreatePlayer(playerNum, player)
    ModData.request("SafehouseLine_Managers");
end


Events.OnReceiveGlobalModData.Add(SafehouseClient.OnReceiveGlobalModData);
Events.OnInitGlobalModData.Add(SafehouseClient.OnInitGlobalModData);
Events.OnCreatePlayer.Add(SafehouseClient.OnCreatePlayer);

return SafehouseClient;