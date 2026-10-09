local KBW = require("KnoxBuildworks/Core")
local BuildableRules = require("KnoxBuildworks/Admin/BuildableRules")
local RulesFile = require("KnoxBuildworks/Admin/BuildableRulesFile")
local AccessLevelUtils = require("ElyonLib/PlayerUtils/AccessLevelUtils")
local Log = require("KnoxBuildworks/Log")

local RulesServer = {}

local function isAdmin(player)
    return AccessLevelUtils.hasAdminAccess(player)
end

function RulesServer.syncTo(player, saved, message)
    if not player or not sendServerCommand then return end
    sendServerCommand(player, KBW.NETWORK_MODULE, "BuildableRulesSync", {
        document = BuildableRules.getDocument(),
        revision = BuildableRules.revision,
        saved = saved == true,
        message = message
    })
end

function RulesServer.broadcast(savedBy)
    if not getOnlinePlayers or not sendServerCommand then return end
    local players = getOnlinePlayers()
    if not players then return end
    for playerIndex = 0, players:size() - 1 do
        local player = players:get(playerIndex)
        RulesServer.syncTo(player, savedBy ~= nil and player:getUsername() == savedBy, nil)
    end
end

local function reject(player, code, errors)
    if not player or not sendServerCommand then return false end
    sendServerCommand(player, KBW.NETWORK_MODULE, "BuildableRulesError", {
        code = code,
        revision = BuildableRules.revision,
        errors = errors or {}
    })
    return false
end

function RulesServer.load()
    local document = RulesFile.load()
    if not document then
        BuildableRules.applySync({ version = BuildableRules.VERSION, revision = 0 })
        return false
    end
    local applied, errors = BuildableRules.applySync(document, document.revision)
    if not applied then
        Log:error("Could not activate buildable rules: %s", table.concat(errors or {}, "; "))
        return false
    end
    Log:info("Loaded buildable rules revision %d from %s", BuildableRules.revision, RulesFile.path())
    return true
end

function RulesServer.saveFromAdmin(player, source, baseRevision)
    if not isAdmin(player) then return reject(player, "permission", {}) end
    if tonumber(baseRevision) ~= BuildableRules.revision then return reject(player, "conflict", {}) end
    local normalized, errors = BuildableRules.validateDocument(source)
    if not normalized then return reject(player, "validation", errors) end
    normalized.revision = BuildableRules.revision + 1
    if not RulesFile.save(normalized) then return reject(player, "write", {}) end
    local applied, applyErrors = BuildableRules.applySync(normalized, normalized.revision)
    if not applied then return reject(player, "validation", applyErrors) end
    local username = tostring(player and player:getUsername() or "singleplayer")
    Log:info("Buildable rules revision %d saved by %s", BuildableRules.revision, username)
    RulesServer.broadcast(username)
    return true
end

function RulesServer.onClientCommand(player, command, args)
    args = args or {}
    if command == "BuildableRulesRequest" then
        if not isAdmin(player) then return reject(player, "permission", {}) end
        RulesServer.syncTo(player, false, nil)
        return true
    end
    if command == "BuildableRulesSave" then
        return RulesServer.saveFromAdmin(player, args.document, args.baseRevision)
    end
    return false
end

return RulesServer
