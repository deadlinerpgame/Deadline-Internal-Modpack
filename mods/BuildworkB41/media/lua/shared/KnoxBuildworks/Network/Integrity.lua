local KBW = require("KnoxBuildworks/Core")

local Integrity = { serverClients = {} }

function Integrity.setClient(status, message)
    KBW.Runtime.integrity, KBW.Runtime.integrityMessage = status, message
end

function Integrity.setServer(player, allowed, message)
    if player then
        Integrity.serverClients[player:getUsername()] = { allowed = allowed, message = message }
    end
end

function Integrity.isAllowed(player)
    if not isClient() and not isServer() then return true end
    if isServer() then
        local state = player and Integrity.serverClients[player:getUsername()]
        return state ~= nil and state.allowed == true
    end
    return KBW.Runtime.integrity == "ok"
end

return Integrity
