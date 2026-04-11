require "NPCDialogueShared"

local NPCDialogueServerCommands = {}

local function isAdminOrDebug(player)
    if not player then return false end
    local lvl     = player:getAccessLevel()
    local isAdmin = lvl ~= nil and lvl ~= "" and lvl ~= "None"
    local isDebug = isDebugEnabled and isDebugEnabled()
    return isAdmin or isDebug
end

function NPCDialogueServerCommands.RequestSync(playerObj, args)
    
    sendServerCommand(playerObj, "NPCDialogue", "SyncReady", {})
end

function NPCDialogueServerCommands.PlaceZone(playerObj, args)
    
    if not isAdminOrDebug(playerObj) then
        return
    end

    local zoneId = args.existingId or NPCDialogue.generateId()
    local zone = NPCDialogue.newZone(
        zoneId,
        args.name or "Unnamed NPC",
        math.floor(args.x), math.floor(args.y), math.floor(args.z)
    )

    sendServerCommand("NPCDialogue", "SyncZone", { zone = zone })
end

function NPCDialogueServerCommands.RemoveZone(playerObj, args)
    
    if not isAdminOrDebug(playerObj) then return end
    if not args.id then return end

    sendServerCommand("NPCDialogue", "RemoveAck", { id = args.id, x = args.x, y = args.y, z = args.z })
end

local function onClientCommand(module, command, playerObj, args)
    if module ~= "NPCDialogue" then return end
    
    if NPCDialogueServerCommands[command] then
        NPCDialogueServerCommands[command](playerObj, args)
    end
end

Events.OnClientCommand.Add(onClientCommand)

local activeSessions = {}

function NPCDialogueServerCommands.StartSession(playerObj, args)
    local zoneId = args.zoneId
    if not zoneId then return end

    local username = playerObj:getUsername()
    
    local cell = getCell()
    local zone = nil
    if cell then
        local sq = cell:getGridSquare(math.floor(args.x), math.floor(args.y), math.floor(args.z))
        if sq then zone = sq:getModData()["NPCDialogueZone"] end
    end

    local zoneName   = (zone and zone.name)       or args.name or "NPC"
    local concurrent = (zone and zone.concurrent)
    if concurrent == nil then concurrent = true end

    if not concurrent and activeSessions[zoneId] then
        local occupant = activeSessions[zoneId]
        if occupant ~= username then
            sendServerCommand(playerObj, "NPCDialogue", "SessionDenied", {
                zoneId  = zoneId,
                message = zoneName .. " is already talking to someone.",
            })
            return
        end
    end

    activeSessions[zoneId] = username
    
    sendServerCommand(playerObj, "NPCDialogue", "SessionGranted", {
        zoneId = zoneId,
        name   = zoneName,
        x      = math.floor(args.x),
        y      = math.floor(args.y),
        z      = math.floor(args.z),
    })
end

function NPCDialogueServerCommands.EndSession(playerObj, args)
    local zoneId = args.zoneId
    if not zoneId then return end
    local username = playerObj:getUsername()
    if activeSessions[zoneId] == username then
        activeSessions[zoneId] = nil
    end
end

local function onPlayerDisconnect(playerObj)
    if not playerObj then return end
    local username = playerObj:getUsername()
    if not username then return end
    for zoneId, occupant in pairs(activeSessions) do
        if occupant == username then
            activeSessions[zoneId] = nil
        end
    end
end

if Events.OnPlayerDisconnect then
    Events.OnPlayerDisconnect.Add(onPlayerDisconnect)
elseif Events.OnClientDisconnect then
    Events.OnClientDisconnect.Add(onPlayerDisconnect)
end

if Events.EveryTenMinutes then
    Events.EveryTenMinutes.Add(function()
        local online = {}
        local players = getOnlinePlayers and getOnlinePlayers() or nil
        if not players then return end
        for i = 0, players:size() - 1 do
            local p = players:get(i)
            if p then online[p:getUsername()] = true end
        end
        for zoneId, occupant in pairs(activeSessions) do
            if not online[occupant] then
                activeSessions[zoneId] = nil
            end
        end
    end)
end

function NPCDialogueServerCommands.UpdateZone(playerObj, args)
    
    if not isAdminOrDebug(playerObj) then return end
    if not args.zone or not args.zone.id then return end
    
    sendServerCommand("NPCDialogue", "SyncZone", { zone = args.zone })
end
