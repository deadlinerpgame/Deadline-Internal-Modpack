if isClient() then return end
DBNO = DBNO or {}

DBNO.Config = DBNO.Config or {}

DBNO.Config.deathBagType = DBNO.Config.deathBagType or "Base.DBNO_DeathCache"

local CORPSE_SWEEP_MS = 500
local CORPSE_JOB_TTL_MS = 15000

local REAL_WINDOW_MS = 60000
local RESCUE_BAG_TTL_MS = 300000
local DEATH_INFO_TTL_MS = 60000
local DELIVERY_RETRY_MS = 1000
local DELIVERY_TTL_MS = 15000

local function newItem(fullType)
    return InventoryItemFactory.CreateItem(fullType)
end

local function writeDeathLog(username, lines, moved, woundLog, character)
    local dir = DBNO.Paths.accountDir(username) .. "/DeathItemLogs"
    local counterPath = dir .. "/next.txt"
    local n = tonumber(DBNO.Files.readString(counterPath)) or 1
    local out = {
        "Death drop: user '" .. username .. "', entry #" .. tostring(n),
        "ts=" .. tostring(getTimestamp()),
        "items moved=" .. tostring(moved),
        "",
    }
    for _, l in ipairs(lines) do out[#out + 1] = l end
    out[#out + 1] = ""
    out[#out + 1] = "Wounds at death:"
    if woundLog and #woundLog > 0 then
        for _, wl in ipairs(woundLog) do out[#out + 1] = "  " .. tostring(wl) end
    else
        out[#out + 1] = "  (none recorded)"
    end
    out[#out + 1] = ""
    out[#out + 1] = "Character at death:"
    local described = DBNO.Rescue.takeDeathInfo(username) or DBNO.Snap.describe(character)
    for _, l in ipairs(described) do out[#out + 1] = "  " .. tostring(l) end

    if DBNO.Files.writeLines(dir .. "/death_" .. tostring(n) .. ".txt", out) then
        DBNO.Files.writeString(counterPath, tostring(n + 1))

        DBNO.Players.touch(username)
    end
end

local function dumpOnDeath(character, isReal)
    local username = character:getUsername() or "?"

    if not DBNO.Death.firstFire("dump", character) then
        return
    end

    local sq = character:getCurrentSquare()
    if sq == nil then sq = character:getSquare() end
    if sq == nil then return end

    local rescue = (not (DBNO.Config.knockdownEnable == false)) and not isReal

    local bagType = DBNO.Config.deathBagType
    local bag = newItem(bagType)
    if bag == nil then return end
    local bagCont = bag:getInventory()
    if bagCont == nil then return end

    local seen, moved = {}, 0
    local function bagAdd(it)
        bagCont:AddItem(it)
        return true
    end
    local function moveInto(it)
        if it == nil or seen[it] then return end
        seen[it] = true
        local cont = it:getContainer()
        if cont then
            cont:DoRemoveItem(it)
        end
        if bagAdd(it) then moved = moved + 1 end
    end

    local function dropWorn()
        local w = character:getWornItems()
        if w == nil then return end
        local wlist = {}
        for i = 0, w:size() - 1 do
            local e = w:get(i)
            local it = e and e:getItem()
            if it then wlist[#wlist + 1] = { it = it, loc = e:getLocation() } end
        end
        for _, e in ipairs(wlist) do
            local md = e.it:getModData()
            md.dbno_wasWorn = true
            md.dbno_wornLoc = e.loc
            character:removeWornItem(e.it, false)
            moveInto(e.it)
        end
    end
    dropWorn()

    local ph = character:getPrimaryHandItem()
    local sh = character:getSecondaryHandItem()
    character:setPrimaryHandItem(nil)
    character:setSecondaryHandItem(nil)
    moveInto(ph)
    moveInto(sh)

    local function dropInventory()
        local inv = character:getInventory()
        if inv == nil then return end
        local src = inv:getItems()
        local tmp = {}
        for i = 0, src:size() - 1 do tmp[#tmp + 1] = src:get(i) end
        for _, it in ipairs(tmp) do moveInto(it) end
    end
    dropInventory()

    character:clearAttachedItems()

    local function sweepCorpses()
        local bodies = sq:getDeadBodys()
        if bodies == nil then return end
        for bi = bodies:size() - 1, 0, -1 do
            local body = bodies:get(bi)
            if body ~= nil and body:isPlayer() and not body:isZombie()
               and not body:isSkeleton() then
                local w = body:getWornItems()
                if w ~= nil then
                    local wlist = {}
                    for i = 0, w:size() - 1 do
                        local e = w:get(i)
                        local it = e and e:getItem()
                        if it then wlist[#wlist + 1] = { it = it, loc = e:getLocation() } end
                    end
                    for _, e in ipairs(wlist) do
                        local md = e.it:getModData()
                        md.dbno_wasWorn = true
                        md.dbno_wornLoc = e.loc
                        w:remove(e.it)
                        moveInto(e.it)
                    end
                end
                local bc = body:getItemContainer()
                if bc ~= nil then
                    local its = bc:getItems()
                    local tmp = {}
                    for i = 0, its:size() - 1 do tmp[#tmp + 1] = its:get(i) end
                    for _, it in ipairs(tmp) do
                        moveInto(it)
                    end
                end
            end
        end
    end
    sweepCorpses()

    local tag = DBNO.Corpse.newTag(character)
    character:getModData().dbno_corpseTag = tag
    local onlineId = character:getOnlineID()

    if rescue then
        local md = bag:getModData()
        md.dbno_rescueOwner = username
        md.dbno_rescueTs = getTimestamp()

        DBNO.LootLock.onDrop(bag, username, sq, RESCUE_BAG_TTL_MS)
        sq:AddWorldInventoryItem(bag, 0, 0, 0)

        DBNO.Rescue.broadcastCorpseRemoval(sq:getX(), sq:getY(), sq:getZ(), onlineId, tag)
        return
    end

    local lines = DBNO.ItemTree.containerLines(bagCont)
    writeDeathLog(username, lines, moved, character:getModData().dbno_deathWoundLog, character)

    DBNO.DeathSpot.set(username, sq:getX(), sq:getY(), sq:getZ())

    if DBNO.Config.respawnClothesMode == "everything" then
        DBNO.Rescue.holdBag(username, bag)
    else
        if DBNO.Config.respawnClothesMode == "worn" then
            DBNO.Rescue.holdWorn(username, bagCont)
        end
        DBNO.LootLock.onDrop(bag, username, sq)
        sq:AddWorldInventoryItem(bag, 0, 0, 0)
    end

    DBNO.Rescue.broadcastCorpseRemoval(sq:getX(), sq:getY(), sq:getZ(), onlineId, tag)
end

Events.OnClientCommand.Add(function(module, command, player, args)
    if module ~= "DBNODeathWounds" or player == nil then return end
    if command == "applyTreated" then
        DBNO.DeathWounds.applyTreated(player, DBNO.DeathWounds.unpack(args and args.w))
        return
    end
    if command == "applyRaw" then
        DBNO.DeathWounds.applyRaw(player, DBNO.DeathWounds.unpack(args and args.w))
        return
    end
    if command == "set" then
        player:getModData().dbno_deathWoundLog = (args and args.lines) or nil
    elseif command == "clear" then
        player:getModData().dbno_deathWoundLog = nil
    end
end)

DBNO.Rescue = DBNO.Rescue or {}
local R = DBNO.Rescue
R._realDeath = R._realDeath or {}
R._heldBags = R._heldBags or {}
R._heldSnaps = R._heldSnaps or {}
R._deathInfo = R._deathInfo or {}
R._deliveries = R._deliveries or {}

function R.holdBag(username, bag)
    if username then R._heldBags[username] = bag end
end

function R.holdSnapshot(username, snap, know)
    if username then R._heldSnaps[username] = { snap = snap, know = know } end
end

function R.restoreSnapshot(player, username)
    local held = username and R._heldSnaps[username]
    if held == nil then return end
    R._heldSnaps[username] = nil
    if held.snap then DBNO.Snap.apply(player, held.snap, true) end
    if held.know then DBNO.Knowledge.apply(player, held.know) end
end


function R.markRealDeath(username) if username then R._realDeath[username] = getTimestampMs() end end
function R.clearRealDeath(username) if username then R._realDeath[username] = nil end end
function R.isRealDeath(username)
    local t = username and R._realDeath[username]
    return t ~= nil and (getTimestampMs() - t) < REAL_WINDOW_MS
end

function R.noteDeathInfo(username, lines)
    if username == nil or type(lines) ~= "table" then return end
    R._deathInfo[username] = { t = getTimestampMs(), lines = lines }
end

function R.takeDeathInfo(username)
    local e = username and R._deathInfo[username]
    if e == nil then return nil end
    R._deathInfo[username] = nil
    if (getTimestampMs() - e.t) >= DEATH_INFO_TTL_MS then return nil end
    return e.lines
end

local function findBag(username, x, y, z)
    local cell = getCell(); if cell == nil then return nil end
    for dx = -2, 2 do
        for dy = -2, 2 do
            local sq = cell:getGridSquare(x + dx, y + dy, z)
            local objs = sq and sq:getWorldObjects()
            if objs then
                for i = objs:size() - 1, 0, -1 do
                    local wio = objs:get(i)
                    local it = wio and wio:getItem()
                    local md = it and it:getModData()
                    if md and (md.dbno_rescueOwner == username or md.dbno_parcelFor == username) then
                        return wio, it, sq
                    end
                end
            end
        end
    end
    return nil
end

DBNO.DeathSpot = DBNO.DeathSpot or {}

function DBNO.DeathSpot.set(username, x, y, z)
    local f = DBNO.Paths.deathSpotFile(username)
    if f then DBNO.Files.writeString(f, math.floor(x) .. "," .. math.floor(y) .. "," .. math.floor(z)) end
end

function DBNO.DeathSpot.get(username)
    local f = DBNO.Paths.deathSpotFile(username)
    if f then
        local raw = DBNO.Files.readString(f)
        if raw and raw ~= "" then
            local x, y, z = string.match(raw, "^(%-?%d+),(%-?%d+),(%-?%d+)$")
            if x then return { x = tonumber(x), y = tonumber(y), z = tonumber(z) } end
        end
    end
    return nil
end

function DBNO.DeathSpot.clear(username)
    local f = DBNO.Paths.deathSpotFile(username)
    if f then DBNO.Files.writeString(f, "") end
end

local function findDeathCache(username, x, y, z)
    local cell = getCell(); if cell == nil then return nil end
    for dx = -2, 2 do
        for dy = -2, 2 do
            local sq = cell:getGridSquare(x + dx, y + dy, z)
            local objs = sq and sq:getWorldObjects()
            if objs then
                for i = objs:size() - 1, 0, -1 do
                    local wio = objs:get(i)
                    local it = wio and wio:getItem()
                    local md = it and it:getModData()
                    if md and md.dbno_deathBag and md.dbno_owner == username
                       and md.dbno_rescueOwner == nil and md.dbno_parcelFor == nil then
                        return wio, it, sq
                    end
                end
            end
        end
    end
    return nil
end

function R.holdWorn(username, bagCont)
    if username == nil or bagCont == nil then return end
    local holder = newItem(DBNO.Config.deathBagType)
    local hc = holder and holder:getInventory()
    if hc == nil then return end

    local its = bagCont:getItems()
    local list = {}
    for i = 0, its:size() - 1 do list[#list + 1] = its:get(i) end

    local n = 0
    for _, it in ipairs(list) do
        if it:getModData().dbno_wasWorn and DBNO.Items.canWear(nil, it) then
            bagCont:DoRemoveItem(it)
            hc:AddItem(it)
            n = n + 1
        end
    end
    if n > 0 then R._heldBags[username] = holder end
end

local function dropParcel(player, username, parcel)
    local sq = player:getCurrentSquare()
    if sq == nil then
        local cell = getCell()
        sq = cell and cell:getGridSquare(math.floor(player:getX()), math.floor(player:getY()), math.floor(player:getZ()))
    end
    if sq == nil then return nil end
    local md = parcel:getModData()
    md.dbno_parcelFor = username
    md.dbno_rescueOwner = nil
    DBNO.LootLock.onDrop(parcel, username, sq, RESCUE_BAG_TTL_MS)
    sq:AddWorldInventoryItem(parcel, 0, 0, 0)
    return { x = sq:getX(), y = sq:getY(), z = sq:getZ(), id = parcel:getID() }
end

local function takeFromDeathCache(username, spot, takeAll)
    local wio, bag, sq = findDeathCache(username, spot.x, spot.y, spot.z)
    if wio == nil then return nil end
    local bc = bag:getInventory()
    if bc == nil then return nil end
    local parcel = newItem(DBNO.Config.deathBagType)
    local pc = parcel and parcel:getInventory()
    if pc == nil then return nil end

    local its = bc:getItems()
    local list = {}
    for i = 0, its:size() - 1 do list[#list + 1] = its:get(i) end
    local n = 0
    for _, it in ipairs(list) do
        if takeAll or (it:getModData().dbno_wasWorn and DBNO.Items.canWear(nil, it)) then
            bc:DoRemoveItem(it)
            pc:AddItem(it)
            n = n + 1
        end
    end
    if n == 0 then return nil end

    sq:transmitRemoveItemFromSquare(wio)
    bag:setWorldItem(nil)
    if not takeAll then sq:AddWorldInventoryItem(bag, 0, 0, 0) end
    return parcel
end

local function respawnClothesLocal(player, username, mode, spot)
    local C = DBNO.Config
    local inv = player:getInventory()
    if inv == nil then return end
    DBNO.Items.stripWorn(player)

    local worn = 0
    if mode == "custom" then
        for id in string.gmatch(C.respawnClothesCustom, "[^;]+") do
            id = id:gsub("^%s+", ""):gsub("%s+$", "")
            if id ~= "" then
                local it = newItem(id)
                if it ~= nil then
                    inv:AddItem(it)
                    DBNO.Items.wear(player, it)
                    worn = worn + 1
                end
            end
        end
    else
        local takeAll = (mode == "everything")
        local held = R._heldBags[username]
        R._heldBags[username] = nil

        local wio, bag, sq
        if held == nil then
            wio, bag, sq = findDeathCache(username, spot.x, spot.y, spot.z)
            if wio == nil then return end
        else
            bag = held
        end

        local bc = bag:getInventory()
        if bc == nil then return end
        worn = DBNO.Items.take(player, bc, "any", function(it, md)
            return takeAll or (md.dbno_wasWorn and DBNO.Items.canWear(player, it))
        end, false)
        if takeAll and wio ~= nil and sq ~= nil then sq:transmitRemoveItemFromSquare(wio) end
    end

    if worn > 0 then DBNO.Items.refresh(player) end
end

function R.respawnClothes(player, username)
    local C = DBNO.Config
    local mode = C.respawnClothesMode
    if mode == "off" or player == nil or username == nil then return end

    local spot = DBNO.DeathSpot.get(username)
    if spot == nil then return end
    DBNO.DeathSpot.clear(username)

    if not isServer() then
        respawnClothesLocal(player, username, mode, spot)
        return
    end

    if mode == "custom" then
        local ids = {}
        for id in string.gmatch(C.respawnClothesCustom, "[^;]+") do
            id = id:gsub("^%s+", ""):gsub("%s+$", "")
            if id ~= "" and getScriptManager():FindItem(id) ~= nil then ids[#ids + 1] = id end
        end
        sendServerCommand(player, "DBNORescue", "respawnKit", { strip = true, items = ids })
        return
    end

    local takeAll = (mode == "everything")
    local parcel = R._heldBags[username]
    R._heldBags[username] = nil
    if parcel == nil then
        parcel = takeFromDeathCache(username, spot, takeAll)
    end

    if parcel == nil or parcel:getInventory() == nil or parcel:getInventory():isEmpty() then
        sendServerCommand(player, "DBNORescue", "respawnKit", { strip = true })
        return
    end
    local drop = dropParcel(player, username, parcel)
    if drop ~= nil then
        sendServerCommand(player, "DBNORescue", "respawnKit", { strip = true, parcel = drop })
        return
    end
    local now = getTimestampMs()
    R._deliveries[#R._deliveries + 1] = { player = player, username = username, parcel = parcel,
        nextAt = now + DELIVERY_RETRY_MS, until_ = now + DELIVERY_TTL_MS }
end

local function restoreFromBagLocal(player, username, x, y, z)
    local wio, bag, sq = findBag(username, x, y, z)
    if wio == nil then
        local held = username and R._heldBags[username]
        if held == nil then return false end
        R._heldBags[username] = nil
        bag = held
    end
    local bc = bag:getInventory()
    if bc == nil then return false end

    DBNO.Items.stripWorn(player)
    DBNO.Items.wipe(player)
    DBNO.Items.take(player, bc, "worn", nil, false)

    DBNO.Items.refresh(player)
    if sq ~= nil and wio ~= nil then sq:transmitRemoveItemFromSquare(wio) end
    sendServerCommand(player, "DBNORescue", "restored", {})
    return true
end

function R.restoreFromBag(player, username, x, y, z)
    if not isServer() then return restoreFromBagLocal(player, username, x, y, z) end

    local wio, bag, sq = findBag(username, x, y, z)
    local drop
    if wio ~= nil then
        drop = { x = sq:getX(), y = sq:getY(), z = sq:getZ(), id = bag:getID() }
    else
        local held = username and R._heldBags[username]
        if held == nil then return false end
        drop = dropParcel(player, username, held)
        if drop == nil then return false end
        R._heldBags[username] = nil
    end
    sendServerCommand(player, "DBNORescue", "claim", {
        x = drop.x, y = drop.y, z = drop.z, id = drop.id,
        strip = true, wipe = true, wear = "worn", done = "restored",
    })
    return true
end

R._corpseJobs = R._corpseJobs or {}

function R.broadcastCorpseRemoval(x, y, z, id, tag)
    R._corpseJobs[#R._corpseJobs + 1] =
        { x = x, y = y, z = z, tag = tag, until_ = getTimestampMs() + CORPSE_JOB_TTL_MS }

    local players = getOnlinePlayers()
    if players == nil then return end
    for i = 0, players:size() - 1 do
        local p = players:get(i)
        if p then
            sendServerCommand(p, "DBNORescue", "removecorpse", { x = x, y = y, z = z, id = id })
        end
    end
end

local _lastCorpseSweep = 0
Events.OnTick.Add(function()
    if #R._corpseJobs == 0 then return end
    local now = getTimestampMs()
    if (now - _lastCorpseSweep) < CORPSE_SWEEP_MS then return end
    _lastCorpseSweep = now

    local kept = {}
    for _, job in ipairs(R._corpseJobs) do
        local removed = DBNO.Corpse.tryRemove(job.x, job.y, job.z, { tag = job.tag }, true, false)
        if (not removed) and now < job.until_ then kept[#kept + 1] = job end
    end
    R._corpseJobs = kept
end)

Events.OnTick.Add(function()
    if #R._deliveries == 0 then return end
    local now = getTimestampMs()
    local kept = {}
    for _, d in ipairs(R._deliveries) do
        if now < d.nextAt then
            kept[#kept + 1] = d
        else
            local drop = nil
            if not d.player:isDead() then
                drop = dropParcel(d.player, d.username, d.parcel)
            end
            if drop ~= nil then
                sendServerCommand(d.player, "DBNORescue", "respawnKit", { strip = true, parcel = drop })
            elseif now < d.until_ and not d.player:isDead() then
                d.nextAt = now + DELIVERY_RETRY_MS
                kept[#kept + 1] = d
            else
                R._heldBags[d.username] = d.parcel
                print("[DBNO] could not hand respawn items to '" .. tostring(d.username) .. "'; keeping them held.")
            end
        end
    end
    R._deliveries = kept
end)

Events.OnClientCommand.Add(function(module, command, player, args)
    if module ~= "DBNORescue" or player == nil then return end
    local u = player:getUsername()
    local x = (args and args.x) or math.floor(player:getX())
    local y = (args and args.y) or math.floor(player:getY())
    local z = (args and args.z) or player:getZ()
    x, y, z = math.floor(x), math.floor(y), math.floor(z)
    if command == "restore" then
        local px, py, pz = math.floor(player:getX()), math.floor(player:getY()), math.floor(player:getZ())

        local ok = R.restoreFromBag(player, u, x, y, z)
        if not ok then R.restoreFromBag(player, u, px, py, pz) end
        R.restoreSnapshot(player, u)
    end
end)

local function onDeath(character, isReal)
    local username = character:getUsername()
    if username == nil then return end

    local woundsOn    = (DBNO.Config.woundsEnable ~= false)
    local threshold   = DBNO.Config.woundThreshold
    local unlimited   = threshold <= 0
    local knockdownOn = not (DBNO.Config.knockdownEnable == false)
    local counts      = isReal or not knockdownOn

    if woundsOn and not unlimited and DBNO.Death.firstFire("wound", character) then
        if counts then
            DBNO.Wounds.add(username, 1)
            DBNO.Players.touch(username)
        end
    end

    local pending = DBNO.Life.isFinalPending(username)
    local count   = (woundsOn and not unlimited) and DBNO.Wounds.get(username) or 0
    local final
    if not woundsOn then
        final = pending or counts
    elseif unlimited then
        final = false
    else
        final = pending or count > threshold
    end

    local rp = DBNO.RespawnPt.get(username)
    sendServerCommand(character, "DBNOWounds", "deathState",
        { final = final, rx = rp and rp.x, ry = rp and rp.y, rz = rp and rp.z })

    if final and not pending then
        DBNO.Life.setFinalPending(username)
        DBNO.Life.wipe(username)
    end
end

Events.OnCharacterDeath.Add(function(character)
    if not (character and instanceof(character, "IsoPlayer")) then return end
    local username = character:getUsername()
    local isReal = username ~= nil
        and (DBNO.Rescue.isRealDeath(username)
             or character:getModData().dbno_downed == true)

    if username ~= nil and not isReal and DBNO.Config.knockdownEnable ~= false then
        DBNO.Rescue.holdSnapshot(username, DBNO.Snap.build(character),
            DBNO.Knowledge.capture(character))
    end

    dumpOnDeath(character, isReal)
    onDeath(character, isReal)

    if username ~= nil then DBNO.Rescue.clearRealDeath(username) end
end)

local _lastDecaySweep = 0
Events.EveryOneMinute.Add(function()
    if DBNO.Config.woundsEnable == false then return end
    local window = DBNO.Config.woundsWindowSec
    if window <= 0 then return end

    local now = getTimestamp()
    if (now - _lastDecaySweep) < 60 then return end
    _lastDecaySweep = now

    for _, user in ipairs(DBNO.Players.list()) do
        DBNO.Wounds.decayOne(user, now, window)
    end
end)

local C = DBNO.Config
C.lootLockMs              = C.lootLockMs              or 5 * 60 * 1000
C.lootDeleteAfterUnlockMs = C.lootDeleteAfterUnlockMs or 5 * 60 * 1000
C.lootRegistryGiveUpMs    = C.lootRegistryGiveUpMs    or 24 * 60 * 60 * 1000

DBNO.LootLock = DBNO.LootLock or {}
local LL = DBNO.LootLock
LL._entries = LL._entries or {}

local function regPath()
    return C.dataRoot .. "/_lootlock.txt"
end

local function saveRegistry()
    local lines = {}
    for _, e in ipairs(LL._entries) do
        lines[#lines + 1] = e.owner .. "|" .. tostring(e.x) .. "|" .. tostring(e.y)
            .. "|" .. tostring(e.z) .. "|" .. tostring(e.deleteAt)
    end
    DBNO.Files.writeLines(regPath(), lines)
end

local function migrateRegistry()
    if C.legacyDataRoot == nil then return end
    local marker = C.dataRoot .. "/_lootlock_migrated.txt"
    if DBNO.Files.exists(marker) then return end
    local legacy = DBNO.Files.readLines(C.legacyDataRoot .. "/_lootlock.txt")
    if legacy and #legacy > 0 and not DBNO.Files.exists(regPath()) then
        DBNO.Files.writeLines(regPath(), legacy)
        print("[DBNO] carried " .. tostring(#legacy) .. " death cache lock(s) over from "
            .. C.legacyDataRoot)
    end
    DBNO.Files.writeString(marker, "1")
end

local function loadRegistry()
    LL._entries = {}
    migrateRegistry()
    local lines = DBNO.Files.readLines(regPath())
    if lines == nil then return end
    for _, ln in ipairs(lines) do
        local owner, x, y, z, del =
            string.match(ln, "^(.-)|(%-?%d+)|(%-?%d+)|(%-?%d+)|(%-?%d+)$")
        if owner ~= nil then
            LL._entries[#LL._entries + 1] = {
                owner = owner, x = tonumber(x), y = tonumber(y),
                z = tonumber(z), deleteAt = tonumber(del),
            }
        end
    end
end

local NEVER_MS = 100 * 365 * 24 * 60 * 60 * 1000

function LL.onDrop(bag, owner, square, minTtlMs)
    if bag == nil or owner == nil or square == nil then return end
    local now = getTimestampMs()

    local keepForever = C.deathCacheNoDespawn

    local locked    = (C.deathCacheLock ~= false)
    local lockUntil = locked and (now + C.lootLockMs) or now
    if locked and C.deathCacheNoUnlock then lockUntil = now + NEVER_MS end
    local deleteAt  = lockUntil + C.lootDeleteAfterUnlockMs
    if keepForever then deleteAt = now + NEVER_MS end
    if minTtlMs and deleteAt < (now + minTtlMs) then deleteAt = now + minTtlMs end

    local md = bag:getModData()
    md.dbno_deathBag  = true
    md.dbno_owner     = owner
    md.dbno_lockUntil = lockUntil
    md.dbno_deleteAt  = deleteAt

    if keepForever then return end

    LL._entries[#LL._entries + 1] = {
        owner = owner, x = square:getX(), y = square:getY(), z = square:getZ(),
        deleteAt = deleteAt,
    }
    saveRegistry()
end

local function removeExpiredBagsOnSquare(sq, now)
    local objs = sq:getWorldObjects()
    if objs == nil then return end
    for i = objs:size() - 1, 0, -1 do
        local wio = objs:get(i)
        local it  = wio and wio:getItem()
        local md  = it and it:getModData()
        if md and md.dbno_deathBag and md.dbno_deleteAt and md.dbno_deleteAt <= now then
            sq:transmitRemoveItemFromSquare(wio)
        end
    end
end

local function sweepEmptyBagsOnSquare(sq, now)
    local objs = sq:getWorldObjects()
    if objs == nil then return false end
    local remaining = 0
    for i = objs:size() - 1, 0, -1 do
        local wio = objs:get(i)
        local it  = wio and wio:getItem()
        local md  = it and it:getModData()
        if md and md.dbno_deathBag then
            local c = it:getInventory()
            local empty    = c ~= nil and c:getItems():size() == 0
            local unlocked = md.dbno_lockUntil == nil or now >= md.dbno_lockUntil
            if empty and unlocked then
                sq:transmitRemoveItemFromSquare(wio)
            else
                remaining = remaining + 1
            end
        end
    end
    return remaining == 0
end

function LL.sweep()
    if #LL._entries == 0 then return end
    local now  = getTimestampMs()
    local cell = getCell()
    if cell == nil then return end

    local kept, changed = {}, false
    for _, e in ipairs(LL._entries) do
        if now < e.deleteAt then
            local sq = cell:getGridSquare(e.x, e.y, e.z)
            if sq ~= nil and sweepEmptyBagsOnSquare(sq, now) then
                changed = true
            else
                kept[#kept + 1] = e
            end
        else
            local sq = cell:getGridSquare(e.x, e.y, e.z)
            if sq ~= nil then
                removeExpiredBagsOnSquare(sq, now)
                changed = true
            elseif now >= e.deleteAt + C.lootRegistryGiveUpMs then
                changed = true
            else
                kept[#kept + 1] = e
            end
        end
    end
    if changed then
        LL._entries = kept
        saveRegistry()
    end
end

Events.OnServerStarted.Add(function() loadRegistry() end)
Events.OnGameStart.Add(function() loadRegistry() end)
Events.EveryOneMinute.Add(function() LL.sweep() end)
