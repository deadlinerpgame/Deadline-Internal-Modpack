if isClient() then return end
DBNO = DBNO or {}

DBNO.RespawnPt = DBNO.RespawnPt or {}

function DBNO.RespawnPt.get(username)
    local f = DBNO.Paths.respawnFile(username)
    if f then
        local raw = DBNO.Files.readString(f)
        if raw and raw ~= "" then
            local x, y, z = string.match(raw, "^(%-?%d+),(%-?%d+),(%-?%d+)$")
            if x then return { x = tonumber(x), y = tonumber(y), z = tonumber(z) } end
        end
    end
    return nil
end

function DBNO.RespawnPt.set(username, x, y, z)
    local f = DBNO.Paths.respawnFile(username)
    if f then DBNO.Files.writeString(f, math.floor(x) .. "," .. math.floor(y) .. "," .. math.floor(z)) end
end

DBNO.Respawn = DBNO.Respawn or {}
DBNO.Respawn._spawnAt = DBNO.Respawn._spawnAt or {}

Events.OnClientCommand.Add(function(module, command, player, args)
    if module ~= "DBNORespawn" or player == nil then return end
    if command == "setRespawn" then
        if DBNO.Config.respawnPointEnable == false then return end
        local x, y, z = math.floor(player:getX()), math.floor(player:getY()), math.floor(player:getZ())
        DBNO.RespawnPt.set(DBNO.accountName(player), x, y, z)
        DBNO.Players.touch(DBNO.accountName(player))
        sendServerCommand(player, "DBNORespawn", "setResult", { ok = true, x = x, y = y, z = z })

    elseif command == "spawnat" then
        if args and args.x and args.y then
            DBNO.Respawn._spawnAt[DBNO.accountName(player)] =
                { x = math.floor(args.x), y = math.floor(args.y), z = math.floor(args.z or 0) }
        end

    elseif command == "getRespawn" then
        local user = DBNO.accountName(player)

        if DBNO.Life.isFinalPending(user) then
            if player:isDead() then
                sendServerCommand(player, "DBNOWounds", "deathState", { final = true })
            else
                DBNO.Life.setFinalPending(user, false)
            end
        end

        if DBNO.Config.respawnPointEnable ~= false then
            local pt = DBNO.RespawnPt.get(user)
            if pt ~= nil then
                sendServerCommand(player, "DBNORespawn", "point", { x = pt.x, y = pt.y, z = pt.z })
            end
        end
    end
end)

DBNO.Snap = DBNO.Snap or {}
DBNO.Snap._lastSave = DBNO.Snap._lastSave or {}

local function lineList(t)
    if type(t) ~= "table" then return nil end
    local out = {}
    for _, l in ipairs(t) do out[#out + 1] = tostring(l) end
    return out
end

local function writeSnapshot(player, username, payload)
    local enc = type(payload) == "table" and payload.snap or nil
    if type(enc) ~= "string" or DBNO.Snap.decode(enc) == nil then
        enc = DBNO.Snap.encode(DBNO.Snap.build(player))
        payload = nil
    end
    local slot = DBNO.SnapStore.push(username, enc)
    if not slot then return false end

    DBNO.Players.touch(username)

    local path = DBNO.Paths.snapshotsDir(username) .. "/snapshot_" .. tostring(slot) .. "_items.txt"
    local out = {
        "Inventory at snapshot save: user '" .. username .. "', slot " .. tostring(slot),
        "ts=" .. tostring(getTimestamp()),
        "",
    }
    local items = (payload and lineList(payload.items)) or DBNO.ItemTree.characterLines(player)
    for _, l in ipairs(items) do out[#out + 1] = l end
    DBNO.Files.writeLines(path, out)

    local kp = DBNO.Paths.knowledgeSlot(username, slot)
    if kp then DBNO.Files.writeLines(kp, (payload and lineList(payload.know)) or DBNO.Knowledge.capture(player)) end

    local mdp = DBNO.Paths.modDataSlot(username, slot)
    if mdp then DBNO.Files.writeLines(mdp, (payload and lineList(payload.md)) or DBNO.ModData.capture(player)) end
    return true
end
DBNO.Snap.writeSnapshot = writeSnapshot

local function onCharacterReady(player, payload)
    if player == nil then return false end
    local user = DBNO.accountName(player)
    if user == nil then return false end

    local hadSnapshot = DBNO.SnapStore.newestSlot(user) ~= nil
    if DBNO.Config.snapshotEnable ~= false and not hadSnapshot then
        writeSnapshot(player, user, payload)
    end

    DBNO.Rescue.respawnClothes(player, user)

    local pt = DBNO.Respawn._spawnAt[user]
    if pt ~= nil then
        DBNO.Respawn._spawnAt[user] = nil

        player:setX(pt.x + 0.5)
        player:setY(pt.y + 0.5)
        player:setZ(pt.z)
        player:setLx(player:getX())
        player:setLy(player:getY())
        player:setLz(player:getZ())
    end

    return hadSnapshot
end

local function doSave(player, payload)
    local username = DBNO.accountName(player)
    if username == nil then return end
    local admin = DBNO.isAdmin(player)
    local now = DBNO.nowMs()
    if not admin then
        local last = DBNO.Snap._lastSave[username] or 0
        local cd = DBNO.Config.saveCooldownMs
        if (now - last) < cd then
            local wait = math.ceil((cd - (now - last)) / 1000)
            sendServerCommand(player, "DBNOSnapshot", "saveResult", { ok = false, reason = "cooldown", wait = wait })
            return
        end
    end
    local ok = writeSnapshot(player, username, payload)
    if ok and not admin then DBNO.Snap._lastSave[username] = now end
    sendServerCommand(player, "DBNOSnapshot", "saveResult", { ok = ok })
end

local function doRestore(player, silent)
    local username = DBNO.accountName(player)
    if username == nil then return end
    local admin = DBNO.isAdmin(player)
    if not admin and DBNO.Flags.isRestoreUsed(username) then
        if not silent then
            sendServerCommand(player, "DBNOSnapshot", "restoreResult", { ok = false, reason = "used" })
        end
        return
    end
    local enc, slot = DBNO.SnapStore.newestValid(username)
    if enc == nil then
        if not silent then
            sendServerCommand(player, "DBNOSnapshot", "restoreResult", { ok = false, reason = "none" })
        end
        return
    end
    local snap = DBNO.Snap.decode(enc)
    DBNO.Snap.apply(player, snap)

    local know, mdl = nil, nil
    local kp = DBNO.Paths.knowledgeSlot(username, slot)
    know = kp and DBNO.Files.readLines(kp) or nil
    local mdp = DBNO.Paths.modDataSlot(username, slot)
    mdl = mdp and DBNO.Files.readLines(mdp) or nil
    if know then DBNO.Knowledge.apply(player, know) end
    if mdl then DBNO.ModData.apply(player, mdl) end

    if not admin then DBNO.Flags.markRestoreUsed(username) end
    sendServerCommand(player, "DBNOSnapshot", "applyRestore", { data = enc, know = know, md = mdl })
end

Events.OnClientCommand.Add(function(module, command, player, args)
    if module ~= "DBNOSnapshot" or player == nil then return end

    DBNO.Config.applySandbox()

    local payload = args and args.payload

    if command == "characterReady" then
        local hadSnapshot = onCharacterReady(player, payload)
        if hadSnapshot and DBNO.Config.snapshotEnable ~= false
           and DBNO.Config.skillRestoreMode == "immersive" then
            doRestore(player, true)
        end
        return
    end

    if DBNO.Config.snapshotEnable == false then return end

    if command == "sleepSave" then
        if DBNO.Config.skillRestoreMode ~= "immersive" then return end
        local u = DBNO.accountName(player)
        if u ~= nil and writeSnapshot(player, u, payload) then DBNO.Flags.resetRestore(u) end
        return
    end

    if DBNO.Config.snapshotManual == false then return end
    if command == "save" then
        doSave(player, payload)
    elseif command == "restore" then
        doRestore(player)
    end
end)

Events.OnCharacterDeath.Add(function(character)
    if character and instanceof(character, "IsoPlayer") then
        local user = DBNO.accountName(character)
        if user ~= nil then DBNO.Flags.resetRestore(user) end
    end
end)

local function broadcast(initiator, state)
    local players = getOnlinePlayers()
    if players == nil then return end
    for i = 0, players:size() - 1 do
        local p = players:get(i)
        if p and p ~= initiator then
            sendServerCommand(p, "DBNOKnock", "setstate", { id = initiator:getOnlineID(), state = state })
        end
    end
end

local function setServerFlags(player, down)
    local C = DBNO.Config
    player:setZombiesDontAttack(down and C.downedZombieKill ~= true)
    player:setShootable((not down) or C.downedPlayerKill == true)
    if down then
        if C.downedZombieKill ~= true then player:setOnFloor(true) end
        DBNO.enterDownedHealth(player)
    else
        player:setOnFloor(false)
        DBNO.releaseHealth(player)
    end
end

local function downFile(player)
    return DBNO.Paths.knockdownFile(player:getUsername())
end
local function strikeFile(player)
    return DBNO.Paths.knockStrikeFile(player:getUsername())
end

local function readStrikes(player, now)
    local sf = strikeFile(player)
    local windowMs = DBNO.Config.knockdownWindowSec * 1000
    local out = {}
    if sf then
        local raw = DBNO.Files.readString(sf)
        if raw and raw ~= "" then
            for t in string.gmatch(raw, "[^,]+") do
                local n = tonumber(t)
                if n and (now - n) < windowMs then out[#out + 1] = n end
            end
        end
    end
    return out, sf
end

local knock = {}

function knock.requestdown(player, args, user)
    local now = getTimestampMs()
    local limit = DBNO.Config.knockdownStrikeLimit
    local counters = (DBNO.Config.knockdownCounters ~= false)
    local recent, sf = readStrikes(player, now)

    if counters then
        if (#recent + 1) > limit then
            sendServerCommand(player, "DBNOKnock", "downverdict", { ok = false, strike = #recent + 1, limit = limit })
            return
        end
        recent[#recent + 1] = now
        if sf then DBNO.Files.writeString(sf, table.concat(recent, ",")) end
    end
    DBNO.Players.touch(user)
    local df = downFile(player); if df then DBNO.Files.writeString(df, tostring(now)) end
    player:getModData().dbno_downed = true
    player:getModData().dbno_downedStart = now
    setServerFlags(player, true)
    sendServerCommand(player, "DBNOKnock", "downverdict",
        { ok = true, strike = counters and #recent or 0, limit = limit })
    broadcast(player, "down")
end

function knock.getup(player)
    player:getModData().dbno_downed = false
    player:getModData().dbno_downedStart = nil
    setServerFlags(player, false)
    local df = downFile(player); if df then DBNO.Files.writeString(df, "0") end
    broadcast(player, "up")
end

function knock.resumed(player)
    setServerFlags(player, true)
    broadcast(player, "down")
end

function knock.reviving(player, args)
    if not args or not args.targetId then return end
    local target = getPlayerByOnlineID(args.targetId)
    if target then sendServerCommand(target, "DBNOKnock", "revivenotice", { active = true, name = DBNO.displayName(player) }) end
end

function knock.revivecancel(player, args)
    if not args or not args.targetId then return end
    local target = getPlayerByOnlineID(args.targetId)
    if target then sendServerCommand(target, "DBNOKnock", "revivenotice", { active = false }) end
end

function knock.reviverequest(player, args)
    if not args or not args.targetId then return end
    local target = getPlayerByOnlineID(args.targetId)
    if target == nil then return end
    local down = target:getModData().dbno_downed
    if not down then
        local df = downFile(target)
        if df then down = (tonumber(DBNO.Files.readString(df) or "0") or 0) > 0 end
    end
    if not down then return end
    if math.abs(player:getX() - target:getX()) > 3 or math.abs(player:getY() - target:getY()) > 3 then return end
    sendServerCommand(target, "DBNOKnock", "forcegetup", {})
end

function knock.realdeath(player, args, user)
    DBNO.Rescue.markRealDeath(user)
    DBNO.Rescue.noteDeathInfo(user, args and args.describe)
end

function knock.forcedeath(player)
    local md = player:getModData()
    md.dbno_downed = false
    md.dbno_downedStart = nil
    local df = downFile(player); if df then DBNO.Files.writeString(df, "0") end

    local sf = strikeFile(player); if sf then DBNO.Files.writeString(sf, "") end
    DBNO.releaseHealth(player)
    player:setGodMod(false)
    DBNO.setGeneralHealth(player, 0)
    player:setHealth(0)
    broadcast(player, "up")

    if not player:isOnDeathDone() then
        player:die()
    end
end

Events.OnClientCommand.Add(function(module, command, player, args)
    if module ~= "DBNOKnock" or player == nil then return end
    local h = knock[command]
    if h then h(player, args, tostring(player:getUsername())) end
end)

Events.OnCharacterDeath.Add(function(character)
    if not (character and instanceof(character, "IsoPlayer")) then return end
    local u = character:getUsername()
    if u == nil then return end

    local sf = DBNO.Paths.knockStrikeFile(u); if sf then DBNO.Files.writeString(sf, "") end
    local df = DBNO.Paths.knockdownFile(u);  if df then DBNO.Files.writeString(df, "0") end
end)

local _lastDownSync = 0
local _lastHoldSync = 0
local _hadDowned = false
local function downedOnlineIds()
    local ids = {}
    local players = getOnlinePlayers()
    if players then
        for i = 0, players:size() - 1 do
            local p = players:get(i)
            if p and p:getModData().dbno_downed then ids[#ids + 1] = p:getOnlineID() end
        end
    end
    return ids
end

local function reassertHolds()
    local players = getOnlinePlayers()
    if players == nil then return end
    local C = DBNO.Config
    for i = 0, players:size() - 1 do
        local p = players:get(i)
        local md = p and p:getModData()
        if md and md.dbno_downed then
            if C.downedZombieKill ~= true then
                if not p:isZombiesDontAttack() then p:setZombiesDontAttack(true) end
                if not p:isOnFloor() then p:setOnFloor(true) end
                if p:isDeathDragDown() then p:setDeathDragDown(false) end
            end
            local crawled = DBNO.Crawl.track(p, md.dbno_downedStart)
            if not DBNO.tickDownedHealth(p, md.dbno_downedStart, crawled) then
                DBNO.releaseHealth(p)
            end
        end
    end
end
local function sendDownSet(ids)
    local players = getOnlinePlayers()
    if players == nil then return end
    for i = 0, players:size() - 1 do
        local p = players:get(i)
        if p then sendServerCommand(p, "DBNOKnock", "downset", { ids = ids }) end
    end
end
Events.OnTick.Add(function()
    local nowMs = getTimestampMs()
    if (nowMs - _lastHoldSync) >= 250 then
        _lastHoldSync = nowMs
        reassertHolds()
    end

    local now = getTimestamp()
    if (now - _lastDownSync) < 3 then return end
    _lastDownSync = now
    local ids = downedOnlineIds()
    if #ids > 0 then
        sendDownSet(ids)
        _hadDowned = true
    elseif _hadDowned then
        sendDownSet(ids)
        _hadDowned = false
    end
end)

Events.OnClientCommand.Add(function(module, command, player, args)
    if module ~= "DBNOMoodle" or player == nil then return end
    if command == "statusrequest" then
        local u = player:getUsername()
        local w = DBNO.Wounds.get(u)
        if DBNO.Config.woundsEnable == false or DBNO.Config.woundThreshold <= 0 then
            w = 0
        end
        local k = DBNO.Strikes.count(u, getTimestampMs())
        sendServerCommand(player, "DBNOMoodle", "status", { w = w, k = k })
    end
end)

local function setStrikeCount(username, n)
    local f = DBNO.Paths.knockStrikeFile(username)
    if f == nil then return end
    local now = getTimestampMs()
    local parts = {}
    for i = 1, n do parts[#parts + 1] = tostring(now) end
    DBNO.Files.writeString(f, table.concat(parts, ","))
end

local function sendState(player, target)
    local rp = (DBNO.RespawnPt.get(target)) or { x = 0, y = 0, z = 0 }
    sendServerCommand(player, "DBNOAdmin", "state", {
        target  = target,
        strikes = DBNO.Strikes.count(target, getTimestampMs()),
        wounds  = DBNO.Wounds.get(target),
        rx = rp.x, ry = rp.y, rz = rp.z,
    })
end

local function snapshotLines(raw)
    local out = {}
    local snap = DBNO.Snap.decode(raw)
    if snap == nil then out[1] = "(unreadable)"; return out end
    out[#out + 1] = "Occupation: " .. tostring(snap.occ or "")
    out[#out + 1] = "Traits: " .. table.concat(snap.traits, ", ")
    out[#out + 1] = "Weight: " .. tostring(snap.weight) .. "  Kills: " .. tostring(snap.kills) .. "  Hours: " .. tostring(snap.hours)
    out[#out + 1] = "Skills:"
    for name, xp in pairs(snap.xp) do out[#out + 1] = "  " .. name .. " = " .. tostring(xp) .. " xp" end
    return out
end

local function hasData(username)
    local dir = DBNO.Paths.accountDir(username)
    if dir == nil then return false end
    local n = tonumber(DBNO.Files.readString(dir .. "/DeathItemLogs/next.txt"))
    if n and n > 1 then return true end
    for slot = 1, DBNO.Config.snapshotKeep do
        local raw = DBNO.Files.readString(DBNO.Paths.snapshotSlot(username, slot))
        if raw and raw ~= "" and raw ~= "0" then return true end
    end
    local w = tonumber(DBNO.Files.readString(DBNO.Paths.woundsFile(username)))
    if w and w > 0 then return true end
    local sf = DBNO.Paths.knockStrikeFile(username)
    local sraw = sf and DBNO.Files.readString(sf)
    if sraw and sraw ~= "" then return true end
    local rf = DBNO.Paths.respawnFile(username)
    if rf and DBNO.Files.exists(rf) then return true end
    return false
end

local adm = {}

local function playerByOnlineId(id)
    local players = getOnlinePlayers()
    if players == nil or id == nil then return nil end
    for i = 0, players:size() - 1 do
        local p = players:get(i)
        if p and p:getOnlineID() == id then return p end
    end
    return nil
end

function adm.forceDown(player, args)
    if not DBNO.isAdmin(player) then return end
    local t = playerByOnlineId(args and args.id)
    if t == nil or t:getModData().dbno_downed then return end

    local now = getTimestampMs()
    local df = downFile(t); if df then DBNO.Files.writeString(df, tostring(now)) end
    t:getModData().dbno_downed = true
    t:getModData().dbno_downedStart = now
    setServerFlags(t, true)
    sendServerCommand(t, "DBNOKnock", "forcedown", {})
    broadcast(t, "down")
end

function adm.forceUp(player, args)
    if not DBNO.isAdmin(player) then return end
    local t = playerByOnlineId(args and args.id)
    if t == nil or not t:getModData().dbno_downed then return end

    knock.getup(t)
    sendServerCommand(t, "DBNOKnock", "forcegetup", {})
end

function adm.playerList(player)
    sendServerCommand(player, "DBNOAdmin", "playerList", { names = DBNO.Players.list() })
end

function adm.state(player, args, admin, target)
    sendState(player, target)
end

function adm.deathLogList(player, args, admin, target)
    local dir = DBNO.Paths.accountDir(target) .. "/DeathItemLogs"
    local n = tonumber(DBNO.Files.readString(dir .. "/next.txt")) or 1
    local ids = {}
    for i = 1, n - 1 do ids[#ids + 1] = i end
    sendServerCommand(player, "DBNOAdmin", "deathLogList", { target = target, ids = ids })
end

function adm.deathLogEntry(player, args, admin, target)
    local dir = DBNO.Paths.accountDir(target) .. "/DeathItemLogs"
    local lines = DBNO.Files.readLines(dir .. "/death_" .. tostring(args.id) .. ".txt") or {}
    sendServerCommand(player, "DBNOAdmin", "viewer", { title = "Death #" .. tostring(args.id), lines = lines })
end

function adm.snapshotList(player, args, admin, target)
    local slots = {}
    for slot = 1, DBNO.Config.snapshotKeep do
        local raw = DBNO.Files.readString(DBNO.Paths.snapshotSlot(target, slot))
        if raw and raw ~= "" and raw ~= "0" then slots[#slots + 1] = slot end
    end
    sendServerCommand(player, "DBNOAdmin", "snapshotList", { target = target, slots = slots })
end

function adm.snapshotEntry(player, args, admin, target)
    local raw   = DBNO.Files.readString(DBNO.Paths.snapshotSlot(target, args.slot)) or ""
    local lines = snapshotLines(raw)
    lines[#lines + 1] = ""
    lines[#lines + 1] = "--- Inventory at save ---"
    local items = DBNO.Files.readLines(DBNO.Paths.snapshotsDir(target) .. "/snapshot_" .. tostring(args.slot) .. "_items.txt") or {}
    for _, l in ipairs(items) do lines[#lines + 1] = l end

    local kp = DBNO.Paths.knowledgeSlot(target, args.slot)
    local know = kp and DBNO.Files.readLines(kp) or nil
    if know and #know > 0 then
        lines[#lines + 1] = ""
        lines[#lines + 1] = "-- Books / media / XP bonuses at save --"
        for _, l in ipairs(know) do lines[#lines + 1] = l end
    end
    sendServerCommand(player, "DBNOAdmin", "viewer", { title = "Snapshot slot " .. tostring(args.slot), lines = lines })
end

function adm.setStrikes(player, args, admin, target)
    local old = DBNO.Strikes.count(target, getTimestampMs())
    local new = math.max(0, math.floor(tonumber(args.value) or 0))
    setStrikeCount(target, new)
    DBNO.Audit.log(admin, target, "knockdown strikes", old, new)
    sendState(player, target)
end

function adm.setWounds(player, args, admin, target)
    local old = DBNO.Wounds.get(target)
    local new = math.max(0, math.floor(tonumber(args.value) or 0))
    DBNO.Wounds.set(target, new)
    DBNO.Audit.log(admin, target, "wounds", old, new)
    sendState(player, target)
end

function adm.setRespawn(player, args, admin, target)
    local o = (DBNO.RespawnPt.get(target)) or { x = 0, y = 0, z = 0 }
    local x = math.floor(tonumber(args.x) or 0)
    local y = math.floor(tonumber(args.y) or 0)
    local z = math.floor(tonumber(args.z) or 0)
    DBNO.RespawnPt.set(target, x, y, z)
    DBNO.Audit.log(admin, target, "respawn point",
        o.x .. "," .. o.y .. "," .. o.z, x .. "," .. y .. "," .. z)
    sendState(player, target)
end

Events.OnClientCommand.Add(function(module, command, player, args)
    if module ~= "DBNOAdmin" or player == nil then return end

    if command == "register" then
        local u = player:getUsername()
        if hasData(u) then DBNO.Players.touch(u) end
        return
    end

    if not DBNO.isAdmin(player) then return end

    local h = adm[command]
    if h then h(player, args, player:getUsername(), args and args.target) end
end)
