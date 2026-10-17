local KBW = require("KnoxBuildworks/Core")
local Loader = require("KnoxBuildworks/Definitions/Loader")
local Registry = require("KnoxBuildworks/Definitions/Registry")
local Integrity = require("KnoxBuildworks/Network/Integrity")
local Blueprints = require("KnoxBuildworks/Planning/Blueprints")
local BlueprintFiles = require("KnoxBuildworks/Planning/BlueprintFiles")
local BuildableRulesServer = require("KnoxBuildworks/Admin/BuildableRulesServer")
local Log = require("KnoxBuildworks/Log")
require("KnoxBuildworks/World/WellSystem")
require "KnoxBuildworks/BuildingObjects/KBWBuildingObject"
local KBWB41 = require("KnoxBuildworks/Compat/B41")

local Server = {}
local buildBatches = {}
local blueprintRequestTimes = {}
local BLUEPRINT_REQUEST_INTERVAL_MS = 10000

local function planningEnabled()
    return KBW.sandboxValue("KnoxBuildworks.EnablePlanningMode", true) == true
end

local function allowBlueprintRequest(player)
    local username = tostring(player and player:getUsername() or "?")
    local now = getTimestampMs()
    local previous = blueprintRequestTimes[username]
    if previous and now - previous < BLUEPRINT_REQUEST_INTERVAL_MS then return false end
    blueprintRequestTimes[username] = now
    return true
end

local function batchKey(player, blueprintId)
    return tostring(player and player:getUsername() or "?") .. "|" .. tostring(blueprintId or "")
end

local function closePlayerBatches(player)
    local username = tostring(player and player:getUsername() or "?")
    for key, batch in pairs(buildBatches) do
        if batch.username == username then
            BlueprintFiles.endBatch(batch.id)
            buildBatches[key] = nil
        end
    end
end

local function handleBuildBatch(player, command, args)
    local blueprint = Blueprints.get(player, args.id)
    if not blueprint or not Blueprints.canBuild(player, blueprint) then return end
    local key = batchKey(player, args.id)
    if command == "BPBuildBatchStart" then
        if not buildBatches[key] then
            buildBatches[key] = { username = player:getUsername(), id = tostring(args.id) }
            BlueprintFiles.beginBatch(args.id)
        end
    elseif buildBatches[key] then
        BlueprintFiles.endBatch(args.id)
        buildBatches[key] = nil
    end
end

local BLUEPRINT_COMMANDS = {
    BPCreate = true,
    BPDelete = true,
    BPAddPlacement = true,
    BPAddPlacements = true,
    BPRemovePlacement = true,
    BPAddRoom = true,
    BPRemoveRoom = true,
    BPUpdateRoom = true,
    BPSetGatherArea = true,
    BPMove = true,
    BPRename = true,
    BPSetLevel = true,
    BPSetAccess = true
}

local BLUEPRINT_CLEANUP_COMMANDS = {
    BPDelete = true,
    BPRemovePlacement = true,
    BPRemoveRoom = true
}

local function handleBlueprintCommand(player, command, args)
    local viewersBefore = nil
    if command == "BPSetAccess" or command == "BPDelete" or command == "BPMove" then
        viewersBefore = Blueprints.onlineViewers(Blueprints.get(player, args.id))
    end
    local blueprint, applied = Blueprints.applyServerCommand(player, command, args)
    if not applied then
        if blueprint then
            Blueprints.serverSyncTo(player, blueprint)
        elseif args.id then
            Blueprints.serverForgetTo(player, args.id)
        end
        return
    end
    if command == "BPCreate" then
        Blueprints.serverBroadcastFull(blueprint, player)
    elseif command == "BPDelete" then
        local sender = player:getUsername()
        for username, target in pairs(viewersBefore or {}) do
            if username ~= sender then Blueprints.serverForgetTo(target, args.id) end
        end
    elseif command == "BPSetAccess" or command == "BPMove" then
        Blueprints.serverBroadcastAccessChange(blueprint, viewersBefore or {}, player)
    else
        args.updated = blueprint.updated
        local rejected = command == "BPAddPlacements" and tonumber(args.rejected) or 0
        args.rejected = nil
        Blueprints.serverBroadcastDelta(blueprint, command, args, player)
        if rejected > 0 then Blueprints.serverSyncTo(player, blueprint) end
    end
end

local function handleDrumMode(player, args)
    local x, y, z = tonumber(args.x), tonumber(args.y), tonumber(args.z)
    local index = tonumber(args.index)
    if not player or not x or not y or not z or not index then return end
    local square = getCell() and getCell():getGridSquare(x, y, z) or nil
    if not square then return end
    if math.abs(player:getX() - x) > 3 or math.abs(player:getY() - y) > 3
        or math.abs(player:getZ() - z) > 0.5 then
        Log:warning("%s requested a drum mode change out of range", tostring(player:getUsername()))
        return
    end
    local objects = square:getObjects()
    if index < 0 or index >= objects:size() then return end
    local object = objects:get(index)
    local FluidContainers = require("KnoxBuildworks/World/FluidContainers")
    if not FluidContainers.isDualMode(object) then return end
    if args.mode == "dumpFuel" then
        FluidContainers.dumpFuel(object)
    else
        FluidContainers.setMode(object, args.mode)
    end
end

function Server.onClientCommand(module, command, player, args)
    if module ~= KBW.NETWORK_MODULE then return end
    args = args or {}
    if command == "Hello" then
        closePlayerBatches(player)
        blueprintRequestTimes[tostring(player and player:getUsername() or "?")] = nil
        local allowed = args.hash == Registry.hash
        local logMessage = allowed and "Definitions match server"
            or string.format("Definition mismatch: server %s, client %s", Registry.hash, tostring(args.hash))
        Integrity.setServer(player, allowed, logMessage)
        sendServerCommand(
            player, KBW.NETWORK_MODULE, "Integrity",
            { allowed = allowed, reason = allowed and "match" or "mismatch", serverHash = Registry.hash }
        )
        Log[allowed and "info" or "warning"](Log, "%s: %s", player:getUsername(), logMessage)
        Blueprints.serverSyncAll(player)
        BuildableRulesServer.syncTo(player, false, nil)
    elseif command == "BuildableRulesRequest" or command == "BuildableRulesSave" then
        if not Integrity.isAllowed(player) then return end
        BuildableRulesServer.onClientCommand(player, command, args)
    elseif command == "BPRequest" then
        if not Integrity.isAllowed(player) then return end
        if not planningEnabled() then return end
        if allowBlueprintRequest(player) then Blueprints.serverSyncAll(player) end
    elseif command == "BPBuildBatchStart" or command == "BPBuildBatchEnd" then
        if not Integrity.isAllowed(player) then return end
        if not planningEnabled() then return end
        handleBuildBatch(player, command, args)
    elseif command == "DrumMode" then
        if not Integrity.isAllowed(player) then return end
        handleDrumMode(player, args)
    elseif BLUEPRINT_COMMANDS[command] then
        if not Integrity.isAllowed(player) then return end
        if not planningEnabled() and not BLUEPRINT_CLEANUP_COMMANDS[command] then return end
        handleBlueprintCommand(player, command, args)
    end
end

KBWB41.addEvent("OnServerStarted", function ()
    Loader.loadAll()
    BuildableRulesServer.load()
end)
KBWB41.addEvent("OnClientCommand", Server.onClientCommand)
return Server
