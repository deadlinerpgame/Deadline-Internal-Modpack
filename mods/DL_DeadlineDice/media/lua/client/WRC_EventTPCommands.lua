if not isClient() then return end
WRC = WRC or {}
WRC.Commands = WRC.Commands or {}
WRC.TabHandlers = WRC.TabHandlers or {}
local player = getPlayer();
local eventLocations = ModData.getOrCreate("eventLocations")


function WRC.Commands.AddEvent(args)
    ModData.request("eventLocations")
    local player = getPlayer();
    local parts = WRC.SplitString(args)
    local eventName = parts[1];
    local coordinates = {x = parts[2], y = parts[3], z = parts[4]}
    if (getAccessLevel() == "admin") then
        if #parts ~= 4 then WL_Utils.addInfoToChat("Usage: /addevent EventName x y z") return end
        if (eventLocations[parts[1]]) then WL_Utils.addInfoToChat("An event with this name already exists.") return end

        eventLocations[eventName] = {}
        eventLocations[eventName] = coordinates
        local localtext = string.format("EVENT TP LOG: Player %s has created event %s to location %d, %d, %d", player:getUsername(), eventName, parts[2], parts[3], parts[4])
        sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "EventTP", logText = localtext})
        WL_Utils.addInfoToChat("Added event " .. eventName)
        ModData.add("eventLocations", eventLocations)
        ModData.transmit("eventLocations")
    else
        WL_Utils.addInfoToChat("Invalid command.")
    end
end

function WRC.Commands.RemoveEvent(args)
    ModData.request("eventLocations")
    local player = getPlayer();
    local parts = WRC.SplitString(args)
    local eventName = parts[1];
    if (getAccessLevel() == "admin") then
        if (eventName == nil) then WL_Utils.addInfoToChat("Usage: /removeevent EventName") return end
        if (not eventLocations[eventName]) then WL_Utils.addInfoToChat("This event does not exist.") return end

        eventLocations[eventName] = nil
        WL_Utils.addInfoToChat("Removed event " .. eventName)
        local localtext = string.format("EVENT TP LOG: Player %s has removed event %s", player:getUsername(), eventName)
        sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "EventTP", logText = localtext})
        ModData.getOrCreate("eventLocations")
        ModData.add("eventLocations", eventLocations)
        ModData.transmit("eventLocations")
    else
        WL_Utils.addInfoToChat("Invalid command.")
    end
end

function WRC.Commands.ListEvent()
    local player = getPlayer();
    local player = getPlayer()
    if (getAccessLevel() == "admin") then
    ModData.request("eventLocations")
    WL_Utils.addInfoToChat("Current events:")
        for eventName, _ in pairs(eventLocations) do
            WL_Utils.addInfoToChat(eventName)
        end
    else
        WL_Utils.addInfoToChat("Invalid command.")
    end
end

function WRC.Commands.GoToEvent(args)
    local player = getPlayer();
    local parts = WRC.SplitString(args)
    local eventName = parts[1]
    local playerReturnCoords = {x = player:getX(), y = player:getY(), z = player:getZ()}
    if #parts ~= 1 then WL_Utils.addInfoToChat("Usage: /gotoevent EventName") return end
    player:getModData().returnCoordinates = playerReturnCoords;
    player:setX(tonumber(eventLocations[eventName].x));
    player:setY(tonumber(eventLocations[eventName].y));
    player:setZ(tonumber(eventLocations[eventName].z));
    player:setLx(player:getX());
    player:setLy(player:getY());
    player:setLz(player:getZ());
    local localtext = string.format("EVENT TP LOG: Sending player %s to event %s at location %d, %d, %d", player:getUsername(), eventName, eventLocations[eventName].x, eventLocations[eventName].y, eventLocations[eventName].z)
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "EventTP", logText = localtext})
end

function WRC.Commands.ReturnPlayer()
    local player = getPlayer();
    local returnCoords = player:getModData().returnCoordinates
    if not returnCoords then WL_Utils.addInfoToChat("You are currently not in an event.") return end

    player:setX(returnCoords.x);
    player:setY(returnCoords.y);
    player:setZ(returnCoords.z);
    player:setLx(player:getX());
    player:setLy(player:getY());
    player:setLz(player:getZ());
    player:getModData().returnCoordinates = nil;
    local localtext = string.format("EVENT TP LOG: Returned player %s from location %d, %d, %d to location %d, %d, %d", player:getUsername(),player:getX(), player:getY(), player:getZ(),returnCoords.x, returnCoords.y, returnCoords.z)
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "EventTP", logText = localtext})
end

WRC.SpecialCommands["/addevent"] = {
    handler = "AddEvent",
    tabHandlers = {},
    usage = "/addevent <eventname> <x> <y> <z>",
    help = "Add a new event.",
    adminOnly = true,
}

WRC.SpecialCommands["/removeevent"] = {
    handler = "RemoveEvent",
    tabHandlers = {},
    usage = "/removeevent <eventname>",
    help = "Remove an existing event.",
    adminOnly = true,
}

WRC.SpecialCommands["/listevent"] = {
    handler = "ListEvent",
    tabHandlers = {},
    usage = "/listevent",
    help = "List of existing events",
    adminOnly = true,
}

WRC.SpecialCommands["/gotoevent"] = {
    handler = "GoToEvent",
    tabHandlers = {},
    usage = "/gotoevent <eventname>",
    help = "Go to an event.",
    adminOnly = false,
}

WRC.SpecialCommands["/return"] = {
    handler = "ReturnPlayer",
    tabHandlers = {},
    usage = "/return",
    help = "Return home after concluding an event.",
    adminOnly = false,
}

function SyncEventZones()
    ModData.request("eventLocations")
end

Events.OnConnected.Add(SyncEventZones)