DC_ServerManager = {};

if isClient() then return end

local config_path = "Deadline/donator_slots.txt";

function DC_ServerManager.ParseLine(slotTabs, line)

    local locType = nil;
    for match in string.gmatch(line, "%w+=") do
        if not locType then
            locType = match;
            break;
        end
    end

    locType = string.gsub(locType, "=", "");
    local splitLocs = string.sub(line, #locType + 1);

    local components = {};
    
    for match in string.gmatch(splitLocs, "[%w%s]+;") do
        table.insert(components, match);
    end
    
    for i,v in ipairs(components) do
        local loc, count = string.gsub(components[i], ";", "");
        if not slotTabs[locType] then
            slotTabs[locType] = {};
        end

        table.insert(slotTabs[locType], loc);
    end
end

-- Retrieve the lua from the server and parse it.
function DC_ServerManager.ParseSlotsConfig(config)
    if not config then return end;

    local slotTabs = {};

    local line = config:readLine();
    while line do
        if line and slotTabs then
            DC_ServerManager.ParseLine(slotTabs, line);
        end

        line = config:readLine();
        if not line then break end;
    end

    return slotTabs;
end

function DC_ServerManager.OnClientCommand(module, command, player, args)
    if module ~= "DeadlineDonatorClothes" then return end;

    if command ~= "RequestSlots" then return end;

    if not args then return end;

    -- Retrieve the config lua.
    local config = getFileReader(config_path, false, false);
    local slotTabs = DC_ServerManager.ParseSlotsConfig(config);

    sendServerCommand(player, "DeadlineDonatorClothes", "ReceiveSlots", { result = slotTabs, item = args.item });
end

Events.OnServerStarted.Add(DC_ServerManager.RetrieveCustomConfig);
Events.OnClientCommand.Add(DC_ServerManager.OnClientCommand);