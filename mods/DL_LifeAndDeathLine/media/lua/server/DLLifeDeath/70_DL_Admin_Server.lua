if isClient() and not isServer() then return end
DL = DL or {}

local function isAdmin(player)
    if player == nil or player.getAccessLevel == nil then return false end
    local lvl = player:getAccessLevel()
    return lvl ~= nil and lvl ~= "" and lvl ~= "None"
end

local function strikeCount(username, now)
    local windowMs = ((DL.Config and DL.Config.knockdownWindowSec) or 300) * 1000
    local f = DL.Paths.knockStrikeFile and DL.Paths.knockStrikeFile(username) or nil
    local c = 0
    if f then
        local raw = DL.Files.readString(f)
        if raw and raw ~= "" then
            for t in string.gmatch(raw, "[^,]+") do
                local n = tonumber(t); if n and (now - n) < windowMs then c = c + 1 end
            end
        end
    end
    return c
end

local function setStrikeCount(username, n)
    local f = DL.Paths.knockStrikeFile and DL.Paths.knockStrikeFile(username) or nil
    if f == nil then return end
    local now = getTimestampMs()
    local parts = {}
    for i = 1, n do parts[#parts + 1] = tostring(now) end
    DL.Files.writeString(f, table.concat(parts, ","))
end

local function sendState(player, target)
    local rp = (DL.RespawnPt and DL.RespawnPt.get and DL.RespawnPt.get(target)) or { x = 0, y = 0, z = 0 }
    sendServerCommand(player, "DLAdmin", "state", {
        target  = target,
        strikes = strikeCount(target, getTimestampMs()),
        wounds  = (DL.Wounds and DL.Wounds.get and DL.Wounds.get(target)) or 0,
        rx = rp.x, ry = rp.y, rz = rp.z,
    })
end

local function snapshotLines(raw)
    local out = {}
    local snap = DL.Snap and DL.Snap.decode and DL.Snap.decode(raw)
    if snap == nil then out[1] = "(unreadable)"; return out end
    out[#out + 1] = "Occupation: " .. tostring(snap.occ or "")
    out[#out + 1] = "Traits: " .. table.concat(snap.traits or {}, ", ")
    out[#out + 1] = "Weight: " .. tostring(snap.weight) .. "  Kills: " .. tostring(snap.kills) .. "  Hours: " .. tostring(snap.hours)
    out[#out + 1] = "Skills:"
    for name, xp in pairs(snap.xp or {}) do out[#out + 1] = "  " .. name .. " = " .. tostring(xp) .. " xp" end
    return out
end

local function hasData(username)
    local dir = DL.Paths.accountDir(username)
    if dir == nil then return false end
    local n = tonumber(DL.Files.readString(dir .. "/DeathItemLogs/next.txt"))
    if n and n > 1 then return true end
    for slot = 1, (DL.Config.snapshotKeep or 6) do
        local raw = DL.Files.readString(DL.Paths.snapshotSlot(username, slot))
        if raw and raw ~= "" and raw ~= "0" then return true end
    end
    local w = tonumber(DL.Files.readString(DL.Paths.woundsFile(username)))
    if w and w > 0 then return true end
    local sf = DL.Paths.knockStrikeFile(username)
    local sraw = sf and DL.Files.readString(sf)
    if sraw and sraw ~= "" then return true end
    local rf = DL.Paths.respawnFile(username)
    if rf and DL.Files.exists(rf) then return true end
    return false
end

Events.OnClientCommand.Add(function(module, command, player, args)
    if module ~= "DLAdmin" or player == nil then return end
    if command == "register" then
        local u = player:getUsername()
        if DL.Players and hasData(u) then
            DL.Players.touch(u)
            DL.log("admin index: registered '" .. tostring(u) .. "' (has data)")
        end
        return
    end
    if not (isAdmin(player) or (isDebugEnabled and isDebugEnabled())) then
        DL.log("admin: command '" .. tostring(command) .. "' rejected for '" .. tostring(player:getUsername()) .. "' (not admin/debug)")
        return
    end
    local admin  = player:getUsername()
    local target = args and args.target

    if command == "playerList" then
        local names = DL.Players.list()
        DL.log("admin: playerList -> " .. tostring(#names) .. " name(s) for '" .. tostring(admin) .. "'")
        sendServerCommand(player, "DLAdmin", "playerList", { names = names })

    elseif command == "state" then
        sendState(player, target)

    elseif command == "deathLogList" then
        local dir = DL.Paths.accountDir(target) .. "/DeathItemLogs"
        local n = tonumber(DL.Files.readString(dir .. "/next.txt")) or 1
        local ids = {}
        for i = 1, n - 1 do ids[#ids + 1] = i end
        sendServerCommand(player, "DLAdmin", "deathLogList", { target = target, ids = ids })

    elseif command == "deathLogEntry" then
        local dir = DL.Paths.accountDir(target) .. "/DeathItemLogs"
        local lines = DL.Files.readLines(dir .. "/death_" .. tostring(args.id) .. ".txt") or {}
        sendServerCommand(player, "DLAdmin", "viewer", { title = "Death #" .. tostring(args.id), lines = lines })

    elseif command == "snapshotList" then
        local slots = {}
        for slot = 1, (DL.Config.snapshotKeep or 6) do
            local raw = DL.Files.readString(DL.Paths.snapshotSlot(target, slot))
            if raw and raw ~= "" and raw ~= "0" then slots[#slots + 1] = slot end
        end
        sendServerCommand(player, "DLAdmin", "snapshotList", { target = target, slots = slots })

    elseif command == "snapshotEntry" then
        local raw   = DL.Files.readString(DL.Paths.snapshotSlot(target, args.slot)) or ""
        local lines = snapshotLines(raw)
        lines[#lines + 1] = ""
        lines[#lines + 1] = "-- Inventory at save --"
        local items = DL.Files.readLines(DL.Paths.snapshotsDir(target) .. "/snapshot_" .. tostring(args.slot) .. "_items.txt") or {}
        for _, l in ipairs(items) do lines[#lines + 1] = l end
        sendServerCommand(player, "DLAdmin", "viewer", { title = "Snapshot slot " .. tostring(args.slot), lines = lines })

    elseif command == "setStrikes" then
        local old = strikeCount(target, getTimestampMs())
        local new = math.max(0, math.floor(tonumber(args.value) or 0))
        setStrikeCount(target, new)
        DL.Audit.log(admin, target, "knockdown strikes", old, new)
        sendState(player, target)

    elseif command == "setWounds" then
        local old = (DL.Wounds and DL.Wounds.get and DL.Wounds.get(target)) or 0
        local new = math.max(0, math.floor(tonumber(args.value) or 0))
        if DL.Wounds and DL.Wounds.set then DL.Wounds.set(target, new) end
        DL.Audit.log(admin, target, "wounds", old, new)
        sendState(player, target)

    elseif command == "setRespawn" then
        local o = (DL.RespawnPt and DL.RespawnPt.get and DL.RespawnPt.get(target)) or { x = 0, y = 0, z = 0 }
        local x = math.floor(tonumber(args.x) or 0)
        local y = math.floor(tonumber(args.y) or 0)
        local z = math.floor(tonumber(args.z) or 0)
        if DL.RespawnPt and DL.RespawnPt.set then DL.RespawnPt.set(target, x, y, z) end
        DL.Audit.log(admin, target, "respawn point",
            o.x .. "," .. o.y .. "," .. o.z, x .. "," .. y .. "," .. z)
        sendState(player, target)
    end
end)

DL.log("admin server loaded")
