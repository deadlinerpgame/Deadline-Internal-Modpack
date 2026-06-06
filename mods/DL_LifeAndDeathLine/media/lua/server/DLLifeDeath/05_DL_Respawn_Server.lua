if isClient() and not isServer() then return end
DL = DL or {}
DL.RespawnPt = DL.RespawnPt or {}

local function defaultPt()
    local d = (DL.Config and DL.Config.respawnDefault) or { x = 10010, y = 11000, z = 0 }
    return { x = d.x, y = d.y, z = d.z }
end

function DL.RespawnPt.get(username)
    local f = (DL.Paths and DL.Paths.respawnFile) and DL.Paths.respawnFile(username) or nil
    if f then
        local raw = DL.Files.readString(f)
        if raw and raw ~= "" then
            local x, y, z = string.match(raw, "^(%-?%d+),(%-?%d+),(%-?%d+)$")
            if x then return { x = tonumber(x), y = tonumber(y), z = tonumber(z) } end
        end
    end
    return defaultPt()
end

function DL.RespawnPt.set(username, x, y, z)
    local f = (DL.Paths and DL.Paths.respawnFile) and DL.Paths.respawnFile(username) or nil
    if f then DL.Files.writeString(f, math.floor(x) .. "," .. math.floor(y) .. "," .. math.floor(z)) end
end

Events.OnClientCommand.Add(function(module, command, player, args)
    if module ~= "DLRespawn" or player == nil then return end
    if command == "setRespawn" then
        local x, y, z = math.floor(player:getX()), math.floor(player:getY()), math.floor(player:getZ())
        DL.RespawnPt.set(player:getUsername(), x, y, z)
        if DL.Players then DL.Players.touch(player:getUsername()) end
        sendServerCommand(player, "DLRespawn", "setResult", { ok = true, x = x, y = y, z = z })
        DL.log("respawn: '" .. tostring(player:getUsername()) .. "' set respawn point -> " .. x .. "," .. y .. "," .. z)
    end
end)

DL.log("respawn point server loaded")
