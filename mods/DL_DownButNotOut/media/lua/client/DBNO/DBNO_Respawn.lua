DBNO = DBNO or {}

local RESTORE_FIRST_DELAY_MS = 1500
local RESTORE_RETRY_MS       = 1000
local RESTORE_GIVEUP_MS      = 120000
local REFRESH_WINDOW_MS      = 4000
local APPLY_WINDOW_MS        = 30000
local REFRESH_TICK_MS        = 500
local CORPSE_SWEEP_MS        = 500
local CORPSE_JOB_TTL_MS      = 15000
local CLAIM_RETRY_MS         = 500
local CLAIM_TTL_MS           = 20000

DBNO.DeathWounds = DBNO.DeathWounds or {}
local DW = DBNO.DeathWounds

local cfg = DBNO.cfg
local function partCount() return BodyPartType.ToIndex(BodyPartType.MAX) end

local function captureWounds(player)
    local out = {}
    local bd = player:getBodyDamage()
    local parts = bd:getBodyParts()
    for i = 0, partCount() - 1 do
        local bp = parts:get(i)
        local w = {}
        if bp:haveBullet() then w.bullet = true end
        if bp:haveGlass() then w.glass = true end
        if bp:getFractureTime() > 0 then w.fracture = bp:getFractureTime() end
        if bp:getBiteTime() > 0 then w.bite = true end
        if bp:isCut() then w.cut = true end
        if bp:isDeepWounded() then w.deep = true end
        if bp:getScratchTime() > 0 then w.scratch = bp:getScratchTime() end
        if bp:isBurnt() then w.burn = bp:getBurnTime() end
        if bp:getBleedingTime() > 0 then w.bleed = true end
        local any = false
        for _ in pairs(w) do any = true break end
        if any then out[i] = w end
    end
    return out
end



local function partName(i)
    return BodyPartType.getDisplayName(BodyPartType.FromIndex(i))
end

local function summaryLines(captured)
    local lines = {}
    for i, w in pairs(captured) do
        local inj = {}
        if w.bullet  then inj[#inj + 1] = "gunshot (bullet)" end
        if w.glass   then inj[#inj + 1] = "glass shard" end
        if w.fracture then inj[#inj + 1] = "fracture" end
        if w.bite    then inj[#inj + 1] = "bite" end
        if w.deep    then inj[#inj + 1] = "deep wound" end
        if w.cut     then inj[#inj + 1] = "laceration" end
        if w.scratch then inj[#inj + 1] = "scratch" end
        if w.burn    then inj[#inj + 1] = "burn" end
        if w.bleed   then inj[#inj + 1] = "bleeding" end
        lines[#lines + 1] = partName(i) .. ": " .. table.concat(inj, ", ")
    end
    return lines
end

function DBNO.DeathWounds.capture(player)
    DW._captured = captureWounds(player)
    if isClient() then
        sendClientCommand(player, "DBNODeathWounds", "set", { lines = summaryLines(DW._captured) })
    end
end
function DBNO.DeathWounds.clear()
    DW._captured = nil
    if isClient() then
        local p = getPlayer()
        if p then sendClientCommand(p, "DBNODeathWounds", "clear", {}) end
    end
end


Events.OnPlayerUpdate.Add(function(player)
    if player ~= getPlayer() then return end
    if DW._applyPending and DW._applyAt and getTimestampMs() >= DW._applyAt then
        DW._applyPending = false
        DW._applyAt = nil
        DBNO.DeathWounds.applyTreated(player, DW._captured)
        DW._captured = nil
    end
end)

local function isEmpty(t)
    if t == nil then return true end
    for _ in pairs(t) do return false end
    return true
end
DBNO.DeathWounds.isEmpty = isEmpty

Events.OnPlayerDeath.Add(function(player)
    if player ~= getPlayer() then return end

    if isEmpty(DW._captured) then DBNO.DeathWounds.capture(player) end
end)

Events.OnCreatePlayer.Add(function(playerNum, player)

    if not player:isLocalPlayer() then return end

    if cfg().respawnWithInjuries == false then
        DW._captured = nil
        return
    end

    if DW._captured and not (DBNO.Wounds.finalDeath) then
        DW._applyPending = true
        DW._applyAt = getTimestampMs() + 3000
    else
        DW._captured = nil
    end
end)

DBNO.Config = DBNO.Config or {}
DBNO.Wounds = DBNO.Wounds or {}

local _prerender = ISPostDeathUI.prerender
function ISPostDeathUI:prerender()
    _prerender(self)
    self.buttonExit:setVisible(false)
    local final = DBNO.Wounds.isFinalNow()
    local label = final
        and (DBNO.Config.deathFinalLabel   or getText("IGUI_DBNO_NewCharacter"))
        or  (DBNO.Config.deathRespawnLabel or getText("IGUI_DBNO_Revive"))
    self.buttonRespawn:setTitle(label)
end

DBNO.Wounds.finalDeath = DBNO.Wounds.finalDeath or false

function DBNO.Wounds.isFinalNow()
    if DBNO.Wounds.finalDeath then return true end

    if DBNO.OverkillRescue.pending then return false end
    if DBNO.Config.woundsEnable == false then return true end
    local threshold = DBNO.Config.woundThreshold
    if threshold <= 0 then return false end
    return (DBNO.Wounds.count or 0) > threshold
end

Events.OnServerCommand.Add(function(module, command, args)
    if module ~= "DBNOWounds" then return end
    if command == "deathState" then
        DBNO.Wounds.finalDeath = args.final and true or false

        if args.rx then DBNO.Respawn.point = { x = args.rx, y = args.ry, z = args.rz or 0 } end
    end
end)

Events.OnCreatePlayer.Add(function(idx, player)
    if not player:isLocalPlayer() then return end
    DBNO.Wounds.finalDeath = false
end)

DBNO.Respawn = DBNO.Respawn or {}
DBNO.Respawn._desc = DBNO.Respawn._desc or nil
DBNO.Respawn._md = DBNO.Respawn._md or nil
DBNO.Respawn._skin = DBNO.Respawn._skin or nil

local function captureTraits(player)
    return DBNO.getTraitNames(player)
end

local function copyDesc(player)
    local desc = player:getDescriptor()
    return SurvivorDesc.new(desc)
end

local function captureModData(player)
    local src = player:getModData()
    local out = {}
    for k, v in pairs(src) do
        if type(k) ~= "string" or string.sub(k, 1, 5) ~= "dbno_" then out[k] = v end
    end
    return out
end

local function captureSkin(player)
    local hv = player:getHumanVisual()
    return hv:getSkinTextureIndex()
end

local function restoreSkin(player, skin)
    if skin == nil then return end
    local hv = player:getHumanVisual()
    if hv:getSkinTextureIndex() == skin then return end
    hv:setSkinTextureIndex(skin)
    player:resetModelNextFrame()
end

local function restoreModData(player, md, overwrite)
    local dst = player:getModData()
    if md == nil then return end
    for k, v in pairs(md) do
        if overwrite or dst[k] == nil then dst[k] = v end
    end
end

local function syncVisualFromPlayer(player, desc)
    local lv = player:getHumanVisual()
    local dv = desc:getHumanVisual()
    dv:copyFrom(lv)
end

local function commitDeathToServer(player)
    if player == nil then return end

    if not player:isDead() then
        player:setInvincible(false)
        player:setGodMod(false)
        DBNO.setGeneralHealth(player, 0)
        player:setHealth(0)
    end

    if not player:isOnDeathDone() then
        player:setOnFloor(true)
        DBNO.Knockdown.forceDie(player)
    end

    if isClient() then
        sendClientCommand(player, "DBNOKnock", "forcedeath", {})
    end
end
DBNO.Respawn.commitDeathToServer = commitDeathToServer

local function stageSpawn(hc)
    local x, y, z = math.floor(hc.x or 0), math.floor(hc.y or 0), math.floor(hc.z or 0)
    local cellX, cellY = math.floor(x / 300), math.floor(y / 300)
    getWorld():setLuaSpawnCellX(cellX)
    getWorld():setLuaSpawnCellY(cellY)
    getWorld():setLuaPosX(x - cellX * 300)
    getWorld():setLuaPosY(y - cellY * 300)
    getWorld():setLuaPosZ(z)
end

local function moveTo(player, pt)
    local x, y, z = pt.x or 0, pt.y or 0, pt.z or 0

    player:setX(x + 0.5)
    player:setY(y + 0.5)
    player:setZ(z)
    player:setLx(player:getX())
    player:setLy(player:getY())
    player:setLz(player:getZ())

    local sq = getCell():getGridSquare(x, y, z)
    if sq == nil then return false end

    player:setSquare(sq)
    player:setCurrent(sq)
    return true
end

local function instantRespawn(coords, transferAll)
    local player = getPlayer()
    if player == nil then return false end

    local desc   = copyDesc(player)
    syncVisualFromPlayer(player, desc)
    local traits = transferAll and captureTraits(player) or {}
    local carried = captureModData(player)
    local skin = captureSkin(player)

    commitDeathToServer(player)

    if not transferAll then
        local prof = DBNO.toProfession("unemployed")
        if prof then desc:setProfession(prof) end
    end

    DBNO.Respawn._desc = desc
    DBNO.Respawn._md = carried
    DBNO.Respawn._skin = skin
    DBNO.Respawn._applyUntil = getTimestampMs() + APPLY_WINDOW_MS

    if coords ~= nil then
        if isClient() then
            sendClientCommand(player, "DBNORespawn", "spawnat",
                { x = coords.x, y = coords.y, z = coords.z or 0 })
        end
        DBNO.Respawn._pendingSpawn = { x = coords.x, y = coords.y, z = coords.z or 0 }
        DBNO.Respawn._pendingUntil = getTimestampMs() + 15000
    end

    local joypadData = JoypadState.players[player:getPlayerNum() + 1]
    if joypadData then
        CoopCharacterCreation.newPlayer(joypadData.id, joypadData)
    else
        CoopCharacterCreation:newPlayerMouse()
    end
    local inst = CoopCharacterCreation.instance
    if inst == nil then return false end

    MainScreen.instance.desc = desc

    local vanillaAccept1 = inst.accept1

    inst.initPlayer = function() end
    inst.accept1 = function(this)
        if coords ~= nil then
            stageSpawn(coords)
        else
            vanillaAccept1(this)
        end
        getWorld():setLuaPlayerDesc(MainScreen.instance.desc)
        local lt = getWorld():getLuaTraits()
        lt:clear()
        for _, tr in ipairs(traits) do
            local trait = DBNO.toTrait(tr)
            if trait then getWorld():addLuaTrait(trait) end
        end
        MainScreen.instance.avatar = nil
        return true
    end

    inst:accept()
    return true
end

Events.OnCreatePlayer.Add(function(playerIndex, player)
    if not player:isLocalPlayer() then return end

    DBNO.Respawn._lastRespawn = nil
    DBNO.Respawn._retryAt = nil
    DBNO.Respawn._retries = 0
    local d = DBNO.Respawn._desc
    if d == nil then return end
    DBNO.Respawn._desc = nil

    restoreSkin(player, DBNO.Respawn._skin)
    restoreModData(player, DBNO.Respawn._md)
    local nv = player:getHumanVisual()
    local dv = d:getHumanVisual()
    nv:copyFrom(dv)

    local ndesc = player:getDescriptor()
    ndesc:getHumanVisual():copyFrom(dv)
    player:resetModelNextFrame()
end)

DBNO.Respawn.MAX_RESPAWN_RETRIES = DBNO.Respawn.MAX_RESPAWN_RETRIES or 3

Events.OnCoopJoinFailed.Add(function(playerNum)
    if DBNO.Respawn._lastRespawn == nil then return end
    CoopCharacterCreation.setVisibleAllUI(true)
    local tries = (DBNO.Respawn._retries or 0) + 1
    DBNO.Respawn._retries = tries
    if tries > DBNO.Respawn.MAX_RESPAWN_RETRIES then
        DBNO.Respawn._lastRespawn = nil

        return
    end
    local p = getPlayer()
    if p then
        sendClientCommand(p, "DBNOKnock", "forcedeath", {})
    end
    DBNO.Respawn._retryAt = getTimestampMs() + 1500
end)

Events.OnTick.Add(function()
    local at = DBNO.Respawn._retryAt
    if at == nil or getTimestampMs() < at then return end
    DBNO.Respawn._retryAt = nil
    local args = DBNO.Respawn._lastRespawn
    if args == nil then return end
    instantRespawn(args.coords, args.transferAll)
end)

Events.OnTick.Add(function()
    local pt = DBNO.Respawn._pendingSpawn
    if pt == nil then return end

    local player = getPlayer()
    if player == nil or player:isDead() then return end

    if moveTo(player, pt) then
        DBNO.Respawn._pendingSpawn = nil

    elseif getTimestampMs() > (DBNO.Respawn._pendingUntil or 0) then
        DBNO.Respawn._pendingSpawn = nil
    end
end)

local _onRespawn = ISPostDeathUI.onRespawn
function ISPostDeathUI:onRespawn()

    if DBNO.Wounds.isFinalNow() then
        DBNO.Wounds.finalDeath = false
        DBNO.Respawn._lastRespawn = nil
        DBNO.Respawn._desc = nil
        DBNO.Respawn._md = nil
        DBNO.Respawn._skin = nil
        DBNO.Respawn.point = nil

        DBNO.DeathWounds._captured = nil
        commitDeathToServer(getPlayer())

        _onRespawn(self)
        return
    end

    local coords, transferAll
    if DBNO.OverkillRescue.pending then
        coords = DBNO.OverkillRescue.coords
        transferAll = true
    elseif DBNO.Respawn.point then
        coords = DBNO.Respawn.point
        transferAll = false
    end

    DBNO.Respawn._lastRespawn = { coords = coords, transferAll = transferAll }
    DBNO.Respawn._retries = 0
    local ok = instantRespawn(coords, transferAll)
    if ok then return end
    DBNO.Respawn._lastRespawn = nil

    _onRespawn(self)
end

local function isDeathCache(item)
    if item == nil then return false end
    local md = item:getModData()
    return md.dbno_deathBag == true
end

local function lockedAgainst(item, character)
    if item == nil then return false end
    local md = item:getModData()
    if not md.dbno_deathBag then return false end
    local lockUntil = md.dbno_lockUntil
    if lockUntil == nil or getTimestampMs() >= lockUntil then return false end
    if DBNO.Config.lootLockTestLockEveryone then return true end
    if DBNO.isAdmin(character) then return false end
    local owner, me = md.dbno_owner, character:getUsername()
    if owner ~= nil and me ~= nil and owner == me then return false end
    return true
end

local function owningItem(container)
    if container == nil then return nil end
    return container:getContainingItem()
end

local _lastNote = 0
local function deny(character, msg)
    local now = getTimestampMs()
    if (now - _lastNote) > 1500 then
        _lastNote = now
        character:setHaloNote(msg or "These aren't your belongings", 255, 70, 70, 250.0)
    end
    return false
end

local function transferBlocked(character, item, src, dest)
    if lockedAgainst(item, character) then return true end
    local sb = owningItem(src)
    if sb ~= nil and lockedAgainst(sb, character) then return true end
    local db = owningItem(dest)
    if db ~= nil and lockedAgainst(db, character) then return true end
    return false
end

local _valid = ISInventoryTransferAction.isValid
function ISInventoryTransferAction:isValid()

    if isDeathCache(self.item) then
        return deny(self.character, getText("IGUI_DBNO_RemainsStay"))
    end
    if transferBlocked(self.character, self.item, self.srcContainer, self.destContainer) then
        return deny(self.character)
    end
    return _valid(self)
end

local _gvalid = ISGrabItemAction.isValid
function ISGrabItemAction:isValid()
    local it = self.item:getItem()
    if isDeathCache(it) then
        return deny(self.character, getText("IGUI_DBNO_RemainsStay"))
    end
    if lockedAgainst(it, self.character) then
        return deny(self.character)
    end
    return _gvalid(self)
end

local function resolveItem(entry)
    if instanceof(entry, "InventoryItem") then return entry end
    if entry.items ~= nil and entry.items[1] ~= nil then return entry.items[1] end
    return nil
end

local function selectionTouchesLocked(character, items)
    for i = 1, #items do
        local it = resolveItem(items[i])
        if it ~= nil then
            if lockedAgainst(it, character) then return true end
            local cont = it:getContainer()
            local bag  = owningItem(cont)
            if bag ~= nil and lockedAgainst(bag, character) then return true end
        end
    end
    return false
end

Events.OnFillInventoryObjectContextMenu.Add(function(playerIdx, context, items)
    local character = getSpecificPlayer(playerIdx)
    if character == nil then return end
    if not selectionTouchesLocked(character, items) then return end
    for _, opt in ipairs(context.options) do
        opt.notAvailable = true
        opt.onSelect     = nil
    end
    local notice = context:addOption("Locked - not your belongings", nil, nil)
    notice.notAvailable = true
    deny(character)
end)

DBNO.OverkillRescue = DBNO.OverkillRescue or {}
local R = DBNO.OverkillRescue

R.pending = R.pending or false

local function isRescueDeath(player)
    if player == nil or player ~= getPlayer() then return false end
    if DBNO.Config.knockdownEnable == false then return false end
    local K = DBNO.Knockdown
    if K._dyingForReal then return false end
    if K._dragDeath then return false end
    if K.isDragDown(player) then return false end
    local md = player:getModData()
    if md.dbno_downed then return false end
    return true
end

Events.OnCharacterDeath.Add(function(character)
    if not isRescueDeath(character) then return end
    R.pending  = true
    R.coords   = { x = character:getX(), y = character:getY(), z = character:getZ() }
    R.snapshot = DBNO.Snap.build(character)
    R.knowledge = DBNO.Knowledge.capture(character)
    DBNO.DeathWounds.capture(character)
    R.wounds = DBNO.DeathWounds._captured
    R._awaitPanel = true
end)

function R.triggerRespawn()
    if not R.pending then return end
    local p = getPlayer()
    local pnum = (p and p:getPlayerNum()) or 0
    local panel = ISPostDeathUI.instance[pnum]
    if panel then
        panel:onRespawn()
    end
end

function R.requestRestore(player)
    local c = R.coords or { x = player:getX(), y = player:getY(), z = player:getZ() }
    local x, y, z = math.floor(c.x), math.floor(c.y), math.floor(c.z or 0)

    if isClient() then
        sendClientCommand(player, "DBNORescue", "restore", { x = x, y = y, z = z })

    else
        DBNO.Rescue.restoreFromBag(player, player:getUsername(), x, y, z)
    end
    return true
end

local function refreshAppearance(player)
    if player == nil then return end
    triggerEvent("OnClothingUpdated", player)
    player:resetModelNextFrame()
    player:getInventory():setDrawDirty(true)

    local pnum = player:getPlayerNum()
    local pdata = getPlayerData(pnum)
    if pdata and pdata.playerInventory then
        pdata.playerInventory:refreshBackpacks()
        if pdata.lootInventory then pdata.lootInventory:refreshBackpacks() end
    end
    ISInventoryPage.dirtyUI()
    ISInventoryPage.renderDirty = true
    triggerEvent("OnContainerUpdate")
    local hb = getPlayerHotbar(pnum)
    if hb then hb:refresh() end
end

local function onRestored()
    R._restoreNextAt = nil
    R._restoreGiveUpAt = nil
    local p = getPlayer()

    refreshAppearance(p)
    if p and R.wounds then
        DBNO.DeathWounds.applyRaw(p, R.wounds)
    end
    R.wounds = nil
    R._refreshUntil = getTimestampMs() + REFRESH_WINDOW_MS
    R._refreshNextAt = 0
    if p then
        DBNO.Snap.syncXp(p)
        DBNO.Knockdown._triggerGrace = nil
        DBNO.Knockdown._dyingForReal = false
        DBNO.Knockdown.enter(p)
    end
end

Events.OnServerCommand.Add(function(module, command, args)
    if module ~= "DBNORescue" then return end
    if command == "restored" then
        onRestored()
    end
end)

R._claims = R._claims or {}
R._claimNextAt = R._claimNextAt or 0

local function findWorldBag(x, y, z, id)
    local cell = getCell()
    if id == nil then return nil end
    for dx = -1, 1 do
        for dy = -1, 1 do
            local sq = cell:getGridSquare(x + dx, y + dy, z)
            local objs = sq and sq:getWorldObjects()
            if objs then
                for i = objs:size() - 1, 0, -1 do
                    local wio = objs:get(i)
                    local it = wio:getItem()
                    if it and it:getID() == id and instanceof(it, "InventoryContainer") then
                        return wio, it, sq
                    end
                end
            end
        end
    end
    return nil
end

local function tryClaim(p, c)
    local wio, bag, sq = findWorldBag(c.x, c.y, c.z, c.id)
    if wio == nil then return false end

    if c.strip then DBNO.Items.stripWorn(p) end
    if c.wipe then DBNO.Items.wipe(p) end
    DBNO.Items.take(p, bag:getInventory(), c.wear, nil, isClient())

    sq:transmitRemoveItemFromSquare(wio)
    wio:removeFromWorld()
    wio:removeFromSquare()
    wio:setSquare(nil)
    bag:setWorldItem(nil)

    refreshAppearance(p)
    return true
end

local function queueClaim(args)
    for _, c in ipairs(R._claims) do
        if c.id == args.id then return end
    end
    R._claims[#R._claims + 1] = {
        x = args.x, y = args.y, z = args.z or 0, id = args.id,
        strip = args.strip, wipe = args.wipe, wear = args.wear, done = args.done,
        until_ = getTimestampMs() + CLAIM_TTL_MS,
    }
    R._claimNextAt = 0
end

local function applyKit(p, args)
    if args.strip then DBNO.Items.stripWorn(p) end
    local inv = p:getInventory()
    for _, id in ipairs(args.items or {}) do
        local it = inv:AddItem(id)
        if it then DBNO.Items.wear(p, it) end
    end
    refreshAppearance(p)
end

Events.OnServerCommand.Add(function(module, command, args)
    if module ~= "DBNORescue" or args == nil then return end
    if command == "claim" then
        queueClaim(args)
    elseif command == "respawnKit" then
        local p = getPlayer()
        if p == nil or p:isDead() then return end
        if args.parcel then
            queueClaim({ x = args.parcel.x, y = args.parcel.y, z = args.parcel.z, id = args.parcel.id,
                strip = args.strip, wear = "any" })
            args.strip = false
        end
        applyKit(p, args)
    end
end)

Events.OnCreatePlayer.Add(function(idx, player)
    if not R.pending then return end

    if not player:isLocalPlayer() then return end
    R.pending = false
    DBNO.DeathWounds._applyPending = false
    if R.snapshot then
        DBNO.Snap.apply(player, R.snapshot, true)
    end
    if R.knowledge then
        DBNO.Knowledge.apply(player, R.knowledge)
    end
    R.snapshot = nil
    R.knowledge = nil
    DBNO.DeathWounds.applyRaw(player, R.wounds)
    DBNO.DeathWounds._captured = nil
    R._awaitSpawn = true
end)

local APPEARANCE_DONE = {
    { module = "SPNCC", command = "SetPlayerModData" },
}

local function disarmCarried()
    R._md = nil
    R._skin = nil
    R._applyUntil = nil
    R._applyNextFrame = nil
end

Events.OnServerCommand.Add(function(module, command)
    if R._md == nil and R._skin == nil then return end
    if R._applyUntil == nil or getTimestampMs() > R._applyUntil then
        disarmCarried()
        return
    end
    for _, sig in ipairs(APPEARANCE_DONE) do
        if module == sig.module and command == sig.command then
            R._applyNextFrame = true
            return
        end
    end
end)

Events.OnPlayerUpdate.Add(function(player)
    if R._applyNextFrame and player == getPlayer() then
        local md, skin = R._md, R._skin
        disarmCarried()
        restoreSkin(player, skin)
        restoreModData(player, md, true)
        player:resetModel()
        triggerEvent("OnClothingUpdated", player)

        local spn = player:getModData().SPNCharCustom
        if isClient() and type(spn) == "table" then
            sendClientCommand(player, "SPNCC", "SetCustomisation", { data = {
                face           = spn.face,
                bodyDetails    = spn.bodyDetails,
                muscleVisuals  = spn.muscleVisuals,
                bodyHairGrowth = spn.bodyHairGrowthEnabled,
            } })
        end
    end
    if R._applyUntil and player == getPlayer()
       and getTimestampMs() > R._applyUntil then disarmCarried() end
    if R._refreshUntil and player == getPlayer() then
        local now = getTimestampMs()
        if now >= (R._refreshNextAt or 0) then
            R._refreshNextAt = now + REFRESH_TICK_MS
            refreshAppearance(player)
        end
        if now >= R._refreshUntil then
            R._refreshUntil = nil
            R._refreshNextAt = nil
            refreshAppearance(player)
        end
    end
    if not R._awaitSpawn or player ~= getPlayer() then return end
    R._awaitSpawn = false
    R._restoreNextAt = getTimestampMs() + RESTORE_FIRST_DELAY_MS
    R._restoreGiveUpAt = getTimestampMs() + RESTORE_GIVEUP_MS
end)

local _lastCorpseSweep = 0

Events.OnTick.Add(function()
    if R._awaitPanel then
        local pnum = (getPlayer() and getPlayer():getPlayerNum()) or 0
        if ISPostDeathUI.instance[pnum] then
            R._awaitPanel = false
            R.triggerRespawn()
        end
    end
    if R._restoreNextAt and getTimestampMs() >= R._restoreNextAt then
        if getTimestampMs() >= (R._restoreGiveUpAt or 0) then
            R._restoreNextAt = nil
            R._restoreGiveUpAt = nil
        else
            R._restoreNextAt = getTimestampMs() + RESTORE_RETRY_MS
            local p = getPlayer()
            if p then R.requestRestore(p) end
        end
    end
    if #R._claims > 0 and getTimestampMs() >= R._claimNextAt then
        local now = getTimestampMs()
        R._claimNextAt = now + CLAIM_RETRY_MS
        local p = getPlayer()
        local kept = {}
        for _, c in ipairs(R._claims) do
            if p ~= nil and not p:isDead() and tryClaim(p, c) then
                if c.done == "restored" then onRestored() end
            elseif now < (c.until_ or 0) then
                kept[#kept + 1] = c
            end
        end
        R._claims = kept
    end
    if #R._corpseJobs > 0 and (getTimestampMs() - _lastCorpseSweep) >= CORPSE_SWEEP_MS then
        _lastCorpseSweep = getTimestampMs()
        local now = getTimestampMs()
        local kept = {}
        for _, job in ipairs(R._corpseJobs) do
            local removed = DBNO.Corpse.tryRemove(job.x, job.y, job.z, { id = job.id }, false, true)
            if (not removed) and now < (job.until_ or 0) then kept[#kept + 1] = job end
        end
        R._corpseJobs = kept
    end
end)

R._corpseJobs = R._corpseJobs or {}
Events.OnServerCommand.Add(function(module, command, args)
    if module ~= "DBNORescue" then return end
    if command == "removecorpse" and args and args.id ~= nil then
        R._corpseJobs[#R._corpseJobs + 1] = { x = args.x, y = args.y, z = args.z or 0,
            id = args.id, until_ = getTimestampMs() + CORPSE_JOB_TTL_MS }
    end
end)

local _create = ISPostDeathUI.createChildren
function ISPostDeathUI:createChildren()
    _create(self)
    local b = ISButton:new(0, -52, 250, 40, "KNOCKDOWN", self, ISPostDeathUI.onKnockdownRescue)
    self:configButton(b)
    self:addChild(b)
    self.buttonKnockdown = b
end

function ISPostDeathUI:onKnockdownRescue()
    DBNO.OverkillRescue.triggerRespawn()
end

local _prerender = ISPostDeathUI.prerender
function ISPostDeathUI:prerender()
    _prerender(self)
    self.buttonKnockdown:setVisible(DBNO.OverkillRescue.pending and true or false)
end
