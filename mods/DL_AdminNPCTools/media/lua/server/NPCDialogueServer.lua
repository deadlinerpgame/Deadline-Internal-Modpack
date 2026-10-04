if isClient() then return end

require "NPCDialogueShared"
require "NPCDialogueStore"

local MODULE = NPCDialogue.MODULE
local CMD    = NPCDialogue.CMD
local Store  = NPCDialogue.Store

local Commands = {}
local activeSessions = {}

local function send(player, command, args)
    if isServer() then
        if player then
            sendServerCommand(player, MODULE, command, args)
        else
            sendServerCommand(MODULE, command, args)
        end
    else
        triggerEvent("OnServerCommand", MODULE, command, NPCDialogue.deepCopy(args))
    end
end

local function broadcast(command, args)
    send(nil, command, args)
end

local function isAdminOrDebug(player)
    if not player then return false end
    local lvl     = player:getAccessLevel()
    local isAdmin = lvl ~= nil and lvl ~= "" and lvl ~= "None"
    local isDebug = isDebugEnabled and isDebugEnabled()
    return isAdmin or isDebug
end

local function who(player)
    return player and tostring(player:getUsername()) or "?"
end

local function describe(zone)
    return zone.id .. " '" .. tostring(zone.name) .. "' at " .. zone.x .. "," .. zone.y .. "," .. zone.z
end

local function copyPlain(v, depth)
    local t = type(v)
    if t == "string" or t == "number" or t == "boolean" then return v end
    if t ~= "table" or depth > 24 then return nil end
    local out = {}
    for k, val in pairs(v) do
        local tk = type(k)
        if tk == "string" or tk == "number" then
            local c = copyPlain(val, depth + 1)
            if c ~= nil then out[k] = c end
        end
    end
    return out
end

local function newId()
    local id = NPCDialogue.generateId()
    while Store.get(id) do id = NPCDialogue.generateId() end
    return id
end

function Commands.RequestSync(player, args)
    local list = {}
    for _, zone in pairs(Store.all()) do
        list[#list + 1] = NPCDialogue.zoneSummary(zone)
    end
    send(player, CMD.SYNC_ALL, { zones = list })
end

function Commands.StartSession(player, args)
    local zoneId = args.zoneId
    local zone = Store.get(zoneId)
    if not zone then
        send(player, CMD.SESSION_DENIED, { zoneId = zoneId, message = "There's nobody here to talk to." })
        send(player, CMD.ZONE_REMOVED, { id = zoneId })
        return
    end

    local reach = (zone.radius or NPCDialogue.DEFAULT_RADIUS) + 3
    if math.floor(player:getZ()) ~= zone.z
       or NPCDialogue.distanceTo(player:getX(), player:getY(), zone.x, zone.y) > reach then
        send(player, CMD.SESSION_DENIED, { zoneId = zoneId, message = "You're too far away from " .. zone.name .. "." })
        return
    end

    local username = player:getUsername()
    local occupant = activeSessions[zoneId]
    if zone.concurrent == false and occupant and occupant ~= username then
        send(player, CMD.SESSION_DENIED, { zoneId = zoneId, message = zone.name .. " is already talking to someone." })
        return
    end
    activeSessions[zoneId] = username

    send(player, CMD.SESSION_GRANTED, {
        zoneId   = zoneId,
        name     = zone.name,
        portrait = zone.portrait,
        tree     = zone.dialogueTree,
    })
end

function Commands.EndSession(player, args)
    local zoneId = args.zoneId
    if zoneId and activeSessions[zoneId] == player:getUsername() then
        activeSessions[zoneId] = nil
    end
end

function Commands.RequestZone(player, args)
    if not isAdminOrDebug(player) then return end
    local zone = Store.get(args.id)
    if zone then
        send(player, CMD.ZONE_DATA, { zone = zone })
    else
        send(player, CMD.ZONE_REMOVED, { id = args.id })
    end
end

function Commands.PlaceZone(player, args)
    if not isAdminOrDebug(player) then return end
    local x, y, z = tonumber(args.x), tonumber(args.y), tonumber(args.z)
    if not (x and y and z) then return end
    x, y, z = math.floor(x), math.floor(y), math.floor(z)

    local existing = Store.findAt(x, y, z)
    if existing then
        send(player, CMD.ZONE_UPDATED, { zone = NPCDialogue.zoneSummary(existing) })
        return
    end

    local zone = NPCDialogue.newZone(newId(), tostring(args.name or "New NPC"), x, y, z)
    Store.put(zone)
    Store.log(who(player) .. " placed " .. describe(zone))
    broadcast(CMD.ZONE_UPDATED, { zone = NPCDialogue.zoneSummary(zone) })
end

function Commands.UpdateZone(player, args)
    if not isAdminOrDebug(player) then return end
    local incoming = args.zone
    local id = type(incoming) == "table" and incoming.id or nil
    local zone = Store.get(id)
    if not zone then
        send(player, CMD.SAVE_RESULT, { id = id, ok = false, message = "This NPC was removed; nothing was saved." })
        send(player, CMD.ZONE_REMOVED, { id = id })
        return
    end

    if incoming.name ~= nil then zone.name = tostring(incoming.name) end
    if incoming.portrait ~= nil then zone.portrait = tostring(incoming.portrait) end
    local r = tonumber(incoming.radius)
    if r and r > 0 then zone.radius = r end
    if incoming.concurrent ~= nil then zone.concurrent = incoming.concurrent and true or false end
    if type(incoming.dialogueTree) == "table" then
        local tree = copyPlain(incoming.dialogueTree, 0)
        if type(tree.nodes) ~= "table" then tree.nodes = {} end
        if type(tree.nodeOrder) ~= "table" then tree.nodeOrder = {} end
        zone.dialogueTree = tree
    end

    local ok = Store.save()
    Store.log(who(player) .. " edited " .. describe(zone))
    broadcast(CMD.ZONE_UPDATED, { zone = NPCDialogue.zoneSummary(zone) })
    send(player, CMD.SAVE_RESULT, {
        id      = id,
        ok      = ok,
        message = (not ok) and "The server could not write its NPC file; see the server console." or nil,
    })
end

function Commands.RemoveZone(player, args)
    if not isAdminOrDebug(player) then return end
    local id = args.id
    if not id then return end
    local zone = Store.remove(id, who(player))
    activeSessions[id] = nil
    if zone then
        Store.log(who(player) .. " removed " .. describe(zone))
        broadcast(CMD.ZONE_REMOVED, { id = id })
    else
        send(player, CMD.ZONE_REMOVED, { id = id })
    end
end

local function onClientCommand(module, command, player, args)
    if module ~= MODULE or not player then return end
    local fn = Commands[command]
    if fn then fn(player, args or {}) end
end

Events.OnClientCommand.Add(onClientCommand)

if Events.OnServerStarted then Events.OnServerStarted.Add(Store.load) end
if Events.OnGameStart then Events.OnGameStart.Add(Store.load) end

local function onPlayerDisconnect(player)
    local username = player and player:getUsername()
    if not username then return end
    for zoneId, occupant in pairs(activeSessions) do
        if occupant == username then activeSessions[zoneId] = nil end
    end
end

if Events.OnPlayerDisconnect then Events.OnPlayerDisconnect.Add(onPlayerDisconnect) end
if Events.OnClientDisconnect then Events.OnClientDisconnect.Add(onPlayerDisconnect) end

if Events.EveryTenMinutes then
    Events.EveryTenMinutes.Add(function()
        local players = getOnlinePlayers and getOnlinePlayers()
        if not players then return end
        local online = {}
        for i = 0, players:size() - 1 do
            local p = players:get(i)
            if p then online[p:getUsername()] = true end
        end
        for zoneId, occupant in pairs(activeSessions) do
            if not online[occupant] then activeSessions[zoneId] = nil end
        end
    end)
end
