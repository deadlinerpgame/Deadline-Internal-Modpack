
function Recipe.OnCreate.RedeemPoints(items, result, player)
    local md = items:get(0):getModData()
    local amount = tonumber(md.serverPoints) or 0
    local ptype = md.serverPointsType
    if amount > 0 then
        sendClientCommand("ServerPoints", "redeem", { ptype, amount })
        player:Say("Redeeming " .. amount .. " " .. (md.serverPointsTypeName or "points") .. "...")
    end
end

if not isServer() then return end

local TAG = "[ServerPoints] "
local function log(msg) print(TAG .. tostring(msg)) end

local function isStaff(player)
    if player == nil or player.getAccessLevel == nil then return false end
    local al = player:getAccessLevel()
    return al ~= nil and al ~= "" and al ~= "None"
end

local function countKeys(t)
    local n = 0
    if type(t) == "table" then for _ in pairs(t) do n = n + 1 end end
    return n
end

local function ymd(ts)
    ts = tonumber(ts) or 0
    local days = math.floor(ts / 86400)
    local sod  = ts - days * 86400
    local hh = math.floor(sod / 3600)
    local mm = math.floor((sod % 3600) / 60)
    local ss = math.floor(sod % 60)
    local y = 1970
    while true do
        local leap = (y % 4 == 0 and (y % 100 ~= 0 or y % 400 == 0))
        local diy = leap and 366 or 365
        if days >= diy then days = days - diy; y = y + 1 else break end
    end
    local leap = (y % 4 == 0 and (y % 100 ~= 0 or y % 400 == 0))
    local mlen = { 31, leap and 29 or 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }
    local mon = 1
    for i = 1, 12 do
        if days >= mlen[i] then days = days - mlen[i]; mon = mon + 1 else break end
    end
    return y, mon, days + 1, hh, mm, ss
end
local function monthKey(ts)
    local y, mon = ymd(ts or getTimestamp())
    return string.format("%04d-%02d", y, mon)
end
local function stampNow()
    local y, mo, d, hh, mm, ss = ymd(getTimestamp())
    return string.format("%04d-%02d-%02d %02d:%02d:%02d UTC", y, mo, d, hh, mm, ss)
end

local CONFIG_FILE  = "ServerPointsConfig.lua"
local PLAYERS_FILE = "ServerPointsPlayers.lua"
local LOG_FILE     = "ServerPoints_audit.txt"

local Config  = { pointTypes = {}, store = {}, presets = {} }
local Players = {}

local DEFAULT_CONFIG = [==[return {
    pointTypes = {
        vehicle  = { name = "Vehicle Points" },
        outfit   = { name = "Outfit Ticket Points" },
        cassette = { name = "Cassette Points" },
    },

    store = {
        Vehicles = {
            { type = "DIV",     target = "Vehicles" },
            { type = "VEHICLE", target = "Base.SpiffoVan", pointType = "vehicle", price = 1000, condition = 100 },
        },
        Outfits = {
            { type = "ITEM", target = "Base.Hat_Fedora", quantity = 1, pointType = "outfit", price = 50 },
        },
        Misc = {
            { type = "XP", target = "Strength", quantity = 1, pointType = "cassette", price = 200 },
        },
    },

    presets = {
        { name = "Tier 1 Supporter", grant = { vehicle = 100 } },
        { name = "Tier 2 Supporter", grant = { vehicle = 300, cassette = 200 } },
    },

    redeemMax = 0,
}
]==]

local DEFAULT_PLAYERS = [==[return {
}
]==]

local function readFile(name)
    local r = getFileReader(name, false)
    if r == nil then return nil end
    local lines, line = {}, r:readLine()
    while line do lines[#lines + 1] = line; line = r:readLine() end
    r:close()
    if #lines == 0 then return nil end
    return table.concat(lines, "\n")
end

local function writeFile(name, contents)
    local w = getFileWriter(name, true, false)
    if w == nil then return false end
    w:write(contents)
    w:close()
    return true
end

local function loadLua(name, default)
    local src = readFile(name)
    if src == nil then
        writeFile(name, default)
        src = default
        log("created default " .. name)
    end
    local fn = loadstring(src)
    if fn == nil then
        log("ERROR parsing " .. name .. " -- fix the file and reload (using empty)")
        return nil
    end
    local tbl = fn()
    if type(tbl) ~= "table" then
        log("ERROR running " .. name .. " -- fix the file and reload (using empty)")
        return nil
    end
    return tbl
end

local function LoadConfig()
    local cfg = loadLua(CONFIG_FILE, DEFAULT_CONFIG) or {}
    cfg.pointTypes = cfg.pointTypes or {}
    cfg.store      = cfg.store or {}
    cfg.presets    = cfg.presets or {}
    for tab, entries in pairs(cfg.store) do
        if type(entries) == "table" then
            for _, e in ipairs(entries) do
                if e.type ~= "DIV" and e.pointType and not cfg.pointTypes[e.pointType] then
                    log("WARN store '" .. tostring(tab) .. "' / '" .. tostring(e.target)
                        .. "' uses undefined pointType '" .. tostring(e.pointType) .. "'")
                end
            end
        end
    end
    Config = cfg
    log("config loaded: " .. countKeys(Config.pointTypes) .. " type(s), "
        .. countKeys(Config.store) .. " store tab(s), " .. #Config.presets .. " preset(s)")
end

local function LoadPlayers()
    Players = loadLua(PLAYERS_FILE, DEFAULT_PLAYERS) or {}
    log("players file loaded: " .. countKeys(Players) .. " entr(ies)")
end

local function defaultPointType()
    local keys = {}
    for k in pairs(Config.pointTypes) do keys[#keys + 1] = k end
    table.sort(keys)
    return keys[1]
end

local DATA

local function ensureData()
    DATA = ModData.getOrCreate("serverPointsData")
    if DATA._version == nil then
        local legacy = defaultPointType() or "points"
        local balances = {}
        for k, v in pairs(DATA) do
            if type(v) == "number" then balances[k] = { [legacy] = v } end
        end
        for k, v in pairs(DATA) do
            if type(v) == "number" then DATA[k] = nil end
        end
        DATA._version = 2
        DATA.balances = balances
        DATA.monthly  = {}
        DATA.known    = {}
        log("migrated legacy balances into pointType '" .. legacy .. "'")
    end
    DATA.balances = DATA.balances or {}
    DATA.monthly  = DATA.monthly or {}
    DATA.once     = DATA.once or {}
    DATA.known    = DATA.known or {}
end

local function getBal(user, ptype)
    local u = DATA.balances[user]
    return (u and tonumber(u[ptype])) or 0
end
local function setBal(user, ptype, n)
    DATA.balances[user] = DATA.balances[user] or {}
    DATA.balances[user][ptype] = math.floor(tonumber(n) or 0)
end
local function getAllBal(user)
    local out = {}
    local u = DATA.balances[user]
    if u then for k, v in pairs(u) do out[k] = v end end
    return out
end

local function audit(actor, target, ptype, delta, before, after, reason)
    local line = string.format(
        "[%s] actor=%s target=%s type=%s delta=%s before=%s after=%s reason=%s",
        stampNow(), tostring(actor), tostring(target), tostring(ptype),
        (delta >= 0 and ("+" .. delta) or tostring(delta)),
        tostring(before), tostring(after), tostring(reason))
    local w = getFileWriter(LOG_FILE, true, true)
    if w then w:write(line .. "\n"); w:close() end
    writeLog("ServerPoints", line)
    log("AUDIT " .. line)
end

local function applyDelta(actor, user, ptype, delta, reason)
    ptype = ptype or defaultPointType()
    if ptype == nil then return nil end
    delta = math.floor(tonumber(delta) or 0)
    if delta == 0 then return getBal(user, ptype) end
    local before = getBal(user, ptype)
    local after  = before + delta
    if after < 0 then after = 0 end
    setBal(user, ptype, after)
    audit(actor, user, ptype, after - before, before, after, reason)
    return after
end

local function rememberPlayer(user)
    if user and user ~= "" and DATA.known[user] == nil then DATA.known[user] = true end
end

local function pushBalancesTo(username)
    local p = getPlayerFromUsername and getPlayerFromUsername(username)
    if p then
        sendServerCommand(p, "ServerPoints", "balances", { username = username, balances = getAllBal(username) })
    end
end

local function grantMonthly(user)
    local entry = Players[user]
    if not entry or type(entry.monthly) ~= "table" then return false end
    local mk = monthKey()
    if DATA.monthly[user] == mk then return false end
    for ptype, amt in pairs(entry.monthly) do
        applyDelta("SYSTEM", user, ptype, amt, "monthly:" .. mk)
    end
    DATA.monthly[user] = mk
    pushBalancesTo(user)
    log("monthly granted to '" .. user .. "' for " .. mk)
    return true
end

local function grantOnce(user)
    local entry = Players[user]
    if not entry or type(entry.once) ~= "table" then return false end
    DATA.once[user] = DATA.once[user] or {}
    local given = DATA.once[user]
    local granted = false
    for ptype, amt in pairs(entry.once) do
        local owed = math.floor(tonumber(amt) or 0) - (given[ptype] or 0)
        if owed > 0 then
            applyDelta("SYSTEM", user, ptype, owed, "once")
            given[ptype] = (given[ptype] or 0) + owed
            granted = true
        end
    end
    if granted then
        pushBalancesTo(user)
        log("one-time grant applied to '" .. user .. "'")
    end
    return granted
end

local function grantSweep()
    local players = getOnlinePlayers()
    if players == nil then return end
    for i = 0, players:size() - 1 do
        local p = players:get(i)
        local u = p and p:getUsername()
        if u then rememberPlayer(u); grantMonthly(u); grantOnce(u) end
    end
end

local function spawnVehicle(player, scriptName, condition)
    local vehicle = addVehicleDebug(scriptName, IsoDirections.S, nil, player:getSquare())
    if vehicle == nil then return false end
    condition = tonumber(condition) or 100
    for i = 0, vehicle:getPartCount() - 1 do
        local part = vehicle:getPartByIndex(i)
        local container = part and part:getItemContainer()
        if container then container:removeAllItems() end
        if part and condition < 100 then part:setCondition(condition) end
    end
    if condition >= 100 then vehicle:repair() end
    player:sendObjectChange("addItem", { item = vehicle:createVehicleKey() })
    return true
end

local Cmd = {}

local function replyBalances(player, user)
    sendServerCommand(player, "ServerPoints", "balances", { username = user, balances = getAllBal(user) })
end
local function sendConfig(player)
    sendServerCommand(player, "ServerPoints", "config", { pointTypes = Config.pointTypes, store = Config.store })
end

function Cmd.checkin(module, command, player, args)
    local u = player:getUsername()
    rememberPlayer(u)
    grantMonthly(u)
    grantOnce(u)
    sendConfig(player)
    replyBalances(player, u)
end

function Cmd.get(module, command, player, args)
    local target = (args and args[1]) or player:getUsername()
    if target ~= player:getUsername() and not isStaff(player) then
        target = player:getUsername()
    end
    replyBalances(player, target)
end

function Cmd.load(module, command, player, args)
    sendConfig(player)
end

function Cmd.buy(module, command, player, args)
    local u = player:getUsername()
    local tab   = args and args[1]
    local index = tonumber(args and args[2])
    local entries = Config.store[tab]
    local e = (type(entries) == "table") and entries[index] or nil
    if e == nil or e.type == "DIV" then
        sendServerCommand(player, "ServerPoints", "bought", { ok = false, reason = "invalid", balances = getAllBal(u) })
        return
    end
    local ptype = e.pointType or defaultPointType()
    local price = math.floor(tonumber(e.price) or 0)
    if getBal(u, ptype) < price then
        sendServerCommand(player, "ServerPoints", "bought", { ok = false, reason = "funds", balances = getAllBal(u) })
        return
    end
    applyDelta(u, u, ptype, -price, "store:" .. tostring(e.type) .. ":" .. tostring(e.target))
    if e.type == "VEHICLE" then
        spawnVehicle(player, e.target, e.condition)
    elseif e.type == "ITEM" then
        sendServerCommand(player, "ServerPoints", "deliver", { kind = "ITEM", target = e.target, quantity = tonumber(e.quantity) or 1 })
    elseif e.type == "XP" then
        sendServerCommand(player, "ServerPoints", "deliver", { kind = "XP", target = e.target, quantity = tonumber(e.quantity) or 1 })
    end
    sendServerCommand(player, "ServerPoints", "bought", { ok = true, balances = getAllBal(u) })
end

function Cmd.redeem(module, command, player, args)
    local u = player:getUsername()
    local ptype  = (args and args[1]) or defaultPointType()
    local amount = math.floor(tonumber(args and args[2]) or 0)
    if amount <= 0 then return end
    local cap = tonumber(Config.redeemMax) or 0
    if cap > 0 and amount > cap then amount = cap end
    applyDelta(u, u, ptype, amount, "redeem")
    replyBalances(player, u)
end

function Cmd.grant(module, command, player, args)
    if not isStaff(player) then return end
    local target = args and args[1]
    local ptype  = args and args[2]
    local amount = math.floor(tonumber(args and args[3]) or 0)
    if not target or target == "" then return end
    rememberPlayer(target)
    applyDelta(player:getUsername(), target, ptype, amount, "grant")
    pushBalancesTo(target)
    replyBalances(player, target)
end

function Cmd.preset(module, command, player, args)
    if not isStaff(player) then return end
    local target = args and args[1]
    local idx    = tonumber(args and args[2])
    local preset = idx and Config.presets[idx]
    if not target or target == "" or not preset or type(preset.grant) ~= "table" then return end
    rememberPlayer(target)
    for ptype, amt in pairs(preset.grant) do
        applyDelta(player:getUsername(), target, ptype, amt, "preset:" .. tostring(preset.name or idx))
    end
    pushBalancesTo(target)
    replyBalances(player, target)
end

function Cmd.admincfg(module, command, player, args)
    if not isStaff(player) then return end
    local known = {}
    for u in pairs(DATA.known) do known[#known + 1] = u end
    for u in pairs(Players) do if DATA.known[u] == nil then known[#known + 1] = u end end
    sendServerCommand(player, "ServerPoints", "admincfg",
        { pointTypes = Config.pointTypes, presets = Config.presets, known = known })
end

function Cmd.reload(module, command, player, args)
    if not isStaff(player) then return end
    LoadConfig()
    LoadPlayers()
    grantSweep()
    sendServerCommand(player, "ServerPoints", "reloaded", { ok = true })
    sendConfig(player)
end

Events.OnClientCommand.Add(function(module, command, player, args)
    if module == "ServerPoints" and player ~= nil and Cmd[command] then
        Cmd[command](module, command, player, args)
    end
end)

Events.OnInitGlobalModData.Add(function(isNewGame)
    LoadConfig()
    LoadPlayers()
    ensureData()
    log("ready")
end)

Events.OnServerStarted.Add(function()
    if DATA == nil then ensureData() end
    grantSweep()
end)

Events.EveryHours.Add(grantSweep)

return Cmd
