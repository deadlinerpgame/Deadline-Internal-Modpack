if isClient() and not isServer() then return end
DL = DL or {}

local function broadcast(initiator, state)
    local players = getOnlinePlayers()
    if players == nil then return end
    for i = 0, players:size() - 1 do
        local p = players:get(i)
        if p and p ~= initiator then
            sendServerCommand(p, "DLKnock", "setstate", { id = initiator:getOnlineID(), state = state })
        end
    end
end

local function setServerFlags(player, down)
    if player.setZombiesDontAttack then player:setZombiesDontAttack(down and true or false) end
    if player.setShootable then player:setShootable(not down) end
end

local function reviverName(player)
    local nm
    pcall(function()
        local d = player:getDescriptor()
        if d and d.getForename then nm = d:getForename() end
    end)
    if nm == nil or nm == "" then nm = tostring(player:getUsername()) end
    return nm
end

local function downFile(player)
    if DL.Paths and DL.Paths.knockdownFile then return DL.Paths.knockdownFile(player:getUsername()) end
    return nil
end
local function strikeFile(player)
    if DL.Paths and DL.Paths.knockStrikeFile then return DL.Paths.knockStrikeFile(player:getUsername()) end
    return nil
end

local function readStrikes(player, now)
    local sf = strikeFile(player)
    local windowMs = ((DL.Config and DL.Config.knockdownWindowSec) or 300) * 1000
    local out = {}
    if sf then
        local raw = DL.Files.readString(sf)
        if raw and raw ~= "" then
            for t in string.gmatch(raw, "[^,]+") do
                local n = tonumber(t)
                if n and (now - n) < windowMs then out[#out + 1] = n end
            end
        end
    end
    return out, sf
end

local function onClientCommand(module, command, player, args)
    if module ~= "DLKnock" or player == nil then return end
    local user = tostring(player:getUsername())

    if command == "requestdown" then
        local now = getTimestampMs()
        local limit = (DL.Config and DL.Config.knockdownStrikeLimit) or 3
        local recent, sf = readStrikes(player, now)
        if (#recent + 1) >= limit then
            sendServerCommand(player, "DLKnock", "downverdict", { ok = false, strike = #recent + 1, limit = limit })
            DL.log("knockdown(server): '" .. user .. "' strike " .. (#recent + 1) .. "/" .. limit .. " -> STRIKEOUT")
        else
            recent[#recent + 1] = now
            if sf then DL.Files.writeString(sf, table.concat(recent, ",")) end
            if DL.Players then DL.Players.touch(user) end
            local df = downFile(player); if df then DL.Files.writeString(df, tostring(now)) end
            player:getModData().dl_downed = true
            player:getModData().dl_downedStart = now
            setServerFlags(player, true)
            sendServerCommand(player, "DLKnock", "downverdict", { ok = true, strike = #recent, limit = limit })
            broadcast(player, "down")
            DL.log("knockdown(server): '" .. user .. "' DOWN @ " .. now .. " (strike " .. #recent .. "/" .. limit .. ")")
        end

    elseif command == "getup" then
        player:getModData().dl_downed = false
        player:getModData().dl_downedStart = nil
        setServerFlags(player, false)
        local df = downFile(player); if df then DL.Files.writeString(df, "0") end
        broadcast(player, "up")
        DL.log("knockdown(server): '" .. user .. "' UP/DEAD")

    elseif command == "resumed" then
        setServerFlags(player, true)
        broadcast(player, "down")

    elseif command == "reviving" then
        if not args or not args.targetId then return end
        local target = getPlayerByOnlineID(args.targetId)
        if target then sendServerCommand(target, "DLKnock", "revivenotice", { active = true, name = reviverName(player) }) end

    elseif command == "revivecancel" then
        if not args or not args.targetId then return end
        local target = getPlayerByOnlineID(args.targetId)
        if target then sendServerCommand(target, "DLKnock", "revivenotice", { active = false }) end

    elseif command == "reviverequest" then
        if not args or not args.targetId then return end
        local target = getPlayerByOnlineID(args.targetId)
        if target == nil then return end
        local down = target:getModData().dl_downed
        if not down then
            local df = downFile(target)
            if df then down = (tonumber(DL.Files.readString(df) or "0") or 0) > 0 end
        end
        if not down then return end
        if math.abs(player:getX() - target:getX()) > 3 or math.abs(player:getY() - target:getY()) > 3 then return end
        sendServerCommand(target, "DLKnock", "forcegetup", {})
        DL.log("knockdown(server): '" .. user .. "' helped up '" .. tostring(target:getUsername()) .. "'")

    elseif command == "realdeath" then
        if DL.Rescue then DL.Rescue.markRealDeath(user) end
        DL.log("knockdown(server): '" .. user .. "' flagged intended (real) death")
    end
end
Events.OnClientCommand.Add(onClientCommand)

Events.OnCharacterDeath.Add(function(character)
    if not (character and instanceof(character, "IsoPlayer")) then return end
    local u = character:getUsername()
    if u == nil then return end
    if DL.Paths and DL.Paths.knockStrikeFile then
        local f = DL.Paths.knockStrikeFile(u); if f then DL.Files.writeString(f, "") end
    end
    if DL.Paths and DL.Paths.knockdownFile then
        local f = DL.Paths.knockdownFile(u); if f then DL.Files.writeString(f, "0") end
    end
end)

DL.log("knockdown server loaded (file-backed strikes + down-state + resume)")
