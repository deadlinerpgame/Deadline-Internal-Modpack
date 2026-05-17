require "NPCDialogueShared"

local NPCDialogueServerCommands = {}
local PERSIST_KEY = "NPCDialogueZones_Server"

local zones = {}
local loaded = false

local function loadZones()
    if loaded then return end
    local gt = getGameTime and getGameTime()
    if not gt then return end
    local md = gt:getModData()
    if md and type(md[PERSIST_KEY]) == "table" then
        for id, zone in pairs(md[PERSIST_KEY]) do
            zones[id] = zone
        end
    end
    loaded = true
end

local function getZones()
    if not loaded then loadZones() end
    return zones
end

local function persistZones()
    local gt = getGameTime and getGameTime()
    if not gt then return end
    local md = gt:getModData()
    if not md then return end
    md[PERSIST_KEY] = getZones()
end

if Events.OnServerStarted then
    Events.OnServerStarted.Add(loadZones)
end
if Events.OnInitWorld then
    Events.OnInitWorld.Add(loadZones)
end

local function isAdminOrDebug(player)
    if not player then return false end
    local lvl     = player:getAccessLevel()
    local isAdmin = lvl ~= nil and lvl ~= "" and lvl ~= "None"
    local isDebug = isDebugEnabled and isDebugEnabled()
    return isAdmin or isDebug
end

local function broadcastAllZones()
    for _, zone in pairs(getZones()) do
        sendServerCommand("NPCDialogue", "SyncZone", { zone = zone })
    end
end

function NPCDialogueServerCommands.RequestSync(playerObj, args)
    broadcastAllZones()
    sendServerCommand("NPCDialogue", "SyncReady", {})
end

function NPCDialogueServerCommands.PlaceZone(playerObj, args)
    if not isAdminOrDebug(playerObj) then return end

    local zoneId = args.existingId or NPCDialogue.generateId()
    local zone = NPCDialogue.newZone(
        zoneId,
        args.name or "Unnamed NPC",
        math.floor(args.x), math.floor(args.y), math.floor(args.z)
    )

    getZones()[zoneId] = zone
    persistZones()

    sendServerCommand("NPCDialogue", "SyncZone", { zone = zone })
end

function NPCDialogueServerCommands.RemoveZone(playerObj, args)
    if not isAdminOrDebug(playerObj) then return end
    if not args.id then return end

    getZones()[args.id] = nil
    persistZones()

    sendServerCommand("NPCDialogue", "RemoveAck", { id = args.id, x = args.x, y = args.y, z = args.z })
end

function NPCDialogueServerCommands.UpdateZone(playerObj, args)
    if not isAdminOrDebug(playerObj) then return end
    if not args.zone or not args.zone.id then return end

    getZones()[args.zone.id] = args.zone
    persistZones()

    sendServerCommand("NPCDialogue", "SyncZone", { zone = args.zone })
end

local function onClientCommand(module, command, playerObj, args)
    if module ~= "NPCDialogue" then return end
    if NPCDialogueServerCommands[command] then
        NPCDialogueServerCommands[command](playerObj, args)
    end
end

Events.OnClientCommand.Add(onClientCommand)

local activeSessions = {}
local syncedPlayers = {}

function NPCDialogueServerCommands.StartSession(playerObj, args)
    local zoneId = args.zoneId
    if not zoneId then return end

    local username = playerObj:getUsername()
    local zone = getZones()[zoneId]

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
    syncedPlayers[username] = nil
    for zoneId, occupant in pairs(activeSessions) do
        if occupant == username then
            activeSessions[zoneId] = nil
        end
    end
end

if Events.OnPlayerDisconnect then Events.OnPlayerDisconnect.Add(onPlayerDisconnect) end
if Events.OnClientDisconnect then Events.OnClientDisconnect.Add(onPlayerDisconnect) end

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

local broadcastCountdown = 0

local function scheduleBroadcast(ticks)
    if broadcastCountdown == 0 or ticks < broadcastCountdown then
        broadcastCountdown = ticks
    end
end

local function pollPlayers()
    local players = getOnlinePlayers and getOnlinePlayers() or nil
    if not players then return end
    local current = {}
    local newPlayer = false
    for i = 0, players:size() - 1 do
        local p = players:get(i)
        if p then
            local username = p:getUsername()
            if username then
                current[username] = true
                if not syncedPlayers[username] then
                    syncedPlayers[username] = true
                    newPlayer = true
                end
            end
        end
    end
    for username in pairs(syncedPlayers) do
        if not current[username] then
            syncedPlayers[username] = nil
        end
    end
    if newPlayer then
        scheduleBroadcast(300)
    end
end

local pollTicks = 0
local POLL_INTERVAL_TICKS = 60
if Events.OnTick then
    Events.OnTick.Add(function()
        pollTicks = pollTicks + 1
        if pollTicks >= POLL_INTERVAL_TICKS then
            pollTicks = 0
            pollPlayers()
        end
        if broadcastCountdown > 0 then
            broadcastCountdown = broadcastCountdown - 1
            if broadcastCountdown == 0 then
                broadcastAllZones()
                sendServerCommand("NPCDialogue", "SyncReady", {})
            end
        end
    end)
end

local function onPlayerConnectEvent(playerObj)
    if not playerObj then return end
    local username = playerObj:getUsername()
    if username then
        syncedPlayers[username] = true
        scheduleBroadcast(300)
    end
end

if Events.OnPlayerConnect then
    Events.OnPlayerConnect.Add(onPlayerConnectEvent)
end
if Events.OnCreatePlayer then
    Events.OnCreatePlayer.Add(function(playerIndex, playerObj)
        onPlayerConnectEvent(playerObj)
    end)
end

if Events.EveryOneMinute then
    Events.EveryOneMinute.Add(function()
        broadcastAllZones()
    end)
end
