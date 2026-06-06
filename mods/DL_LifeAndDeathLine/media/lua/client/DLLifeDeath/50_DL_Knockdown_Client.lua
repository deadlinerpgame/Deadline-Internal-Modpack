DL = DL or {}
DL.Knockdown = DL.Knockdown or {}
local K = DL.Knockdown
K._localHolding = K._localHolding or false
K._awaitingEnter = K._awaitingEnter or false
K._dyingForReal = K._dyingForReal or false

local function cfg() return DL.Config or {} end

local function setGeneralHealth(player, target)
    local parts = player:getBodyDamage():getBodyParts()
    local count = BodyPartType.ToIndex(BodyPartType.MAX)
    local totalMod = 0
    for i = 0, count - 1 do totalMod = totalMod + BodyPartType.getDamageModifyer(i) end
    if totalMod <= 0 then return end
    local targetDamage = 100.0 - target
    if targetDamage < 0 then targetDamage = 0 end
    for i = 0, count - 1 do
        local mod = BodyPartType.getDamageModifyer(i)
        local share = (mod / totalMod) * targetDamage
        local h = 100.0 - (share / mod)
        if h < 0 then h = 0 end
        if h > 100 then h = 100 end
        parts:get(i):SetHealth(h)
    end
end

local function holdHealth(player, hp)
    player:setInvincible(true)
    setGeneralHealth(player, hp)
    player:setHealth(hp)
    player:setGodMod(player:isGodMod())
end

local function setUntargetable(player, down)
    if player.setShootable then player:setShootable(not down) end
    if player.setZombiesDontAttack then player:setZombiesDontAttack(down and true or false) end
end

function K.enter(player, reason)
    local md = player:getModData()
    if md.dl_downed or player:isDead() then return end
    if K._awaitingEnter then
        if getTimestampMs() < (K._awaitEnterUntil or 0) then return end
        K._awaitingEnter = false
    end
    if DL.DeathWounds and DL.DeathWounds.capture then DL.DeathWounds.capture(player) end
    player:setDeathDragDown(false)
    player:setPlayingDeathSound(false)
    holdHealth(player, cfg().knockdownHoldHp or 5)
    K._awaitingEnter = true
    K._awaitEnterUntil = getTimestampMs() + 5000
    if isClient() then
        sendClientCommand(player, "DLKnock", "requestdown", { id = player:getOnlineID(), reason = tostring(reason) })
    else
        K._awaitingEnter = false
        K.enterConfirmed(player)
    end
end

function K.enterConfirmed(player, strike, limit)
    local md = player:getModData()
    if md.dl_downed or player:isDead() then return end
    md.dl_downed = true
    md.dl_downedStart = getTimestampMs()
    md.dl_strike = strike
    md.dl_strikeLimit = limit
    K._localHolding = true

    player:setVariable("knockedd_getup", false)
    player:setVariable("knockedd", false)
    player:setVariable("knockedd_fall", true)

    player:setPrimaryHandItem(nil)
    player:setSecondaryHandItem(nil)
    player:setIsAiming(false)
    player:setBannedAttacking(true)
    player:setIgnoreAimingInput(true)
    setUntargetable(player, true)

    holdHealth(player, cfg().knockdownHoldHp or 5)
    if ISTimedActionQueue ~= nil then ISTimedActionQueue.clear(player) end
    if DL.Knockdown.uiShow then DL.Knockdown.uiShow() end
    DL.log("knockdown: DOWN (strike " .. tostring(strike) .. "/" .. tostring(limit) .. ")")
end

function K.getUp(player)
    local md = player:getModData()
    if not md.dl_downed then return end
    md.dl_downed = false
    md.dl_downedStart = nil
    K._localHolding = false
    K._reviverName = nil
    if DL.DeathWounds and DL.DeathWounds.clear then DL.DeathWounds.clear() end

    player:setVariable("knockedd_fall", false)
    player:setVariable("knockedd_getup", true)

    player:setInvincible(false)
    player:setBannedAttacking(false)
    player:setIgnoreAimingInput(false)
    player:setBlockMovement(false)
    setUntargetable(player, false)

    local hp = cfg().knockdownReviveHp or 30
    setGeneralHealth(player, hp)
    player:setHealth(hp)

    if DL.Knockdown.uiHide then DL.Knockdown.uiHide() end
    if isClient() then
        sendClientCommand(player, "DLKnock", "getup", { id = player:getOnlineID() })
    end
    DL.log("knockdown: GET UP (hp=" .. tostring(hp) .. ")")
end

function K.realDeath(player)
    K._dyingForReal = true

    if isClient() then sendClientCommand(player, "DLKnock", "realdeath", {}) end
    local md = player:getModData()
    md.dl_downed = false
    md.dl_downedStart = nil
    K._localHolding = false
    player:setVariable("knockedd", false)
    player:setVariable("knockedd_fall", false)
    player:setVariable("knockedd_getup", false)
    player:setBlockMovement(false)
    setUntargetable(player, false)
    if DL.Knockdown.uiHide then DL.Knockdown.uiHide() end
    if isClient() then
        sendClientCommand(player, "DLKnock", "getup", { id = player:getOnlineID() })
    end
    player:setInvincible(true)
    K._realKillAt = getTimestampMs() + 400
    DL.log("knockdown: REAL DEATH (intent sent; killing in 400ms)")
end

function K.resume(player, start)
    local md = player:getModData()
    md.dl_downed = true
    md.dl_downedStart = start
    K._localHolding = true

    player:setVariable("knockedd_getup", false)
    player:setVariable("knockedd", false)
    player:setVariable("knockedd_fall", true)

    player:setPrimaryHandItem(nil)
    player:setSecondaryHandItem(nil)
    player:setIsAiming(false)
    player:setBannedAttacking(true)
    player:setIgnoreAimingInput(true)
    setUntargetable(player, true)

    holdHealth(player, cfg().knockdownHoldHp or 5)
    if ISTimedActionQueue ~= nil then ISTimedActionQueue.clear(player) end
    if DL.Knockdown.uiShow then DL.Knockdown.uiShow() end

    if isClient() then
        sendClientCommand(player, "DLKnock", "resumed", { id = player:getOnlineID() })
    end
    DL.log("knockdown: RESUMED after relog")
end

function K.onPlayerUpdate(player)
    if player ~= getPlayer() then return end
    if K._realKillAt then
        if getTimestampMs() >= K._realKillAt then
            K._realKillAt = nil
            player:setInvincible(false)
            player:setGodMod(false)
            setGeneralHealth(player, 0)
            player:setHealth(0)
        end
        return
    end
    local C = cfg()
    if C.knockdownEnable == false then return end
    if K._dyingForReal then return end
    local md = player:getModData()

    if md.dl_downed and not K._localHolding then
        local start = md.dl_downedStart or getTimestampMs()
        local dur = (C.knockdownDurationSec or 300) * 1000
        if (getTimestampMs() - start) >= dur then
            K.realDeath(player)
        else
            K.resume(player, start)
        end
        return
    end

    if md.dl_downed then
        holdHealth(player, C.knockdownHoldHp or 5)
        setUntargetable(player, true)

        if player:isDeathDragDown() then
            player:setPlayingDeathSound(false)
            player:setDeathDragDown(false)
        end
        if player:isSneaking() then player:setSneaking(false) end

        if player:getVariableBoolean("knockedd_fall") or player:getVariableBoolean("knockedd_getup") then
            player:setBlockMovement(true)
        else
            player:setBlockMovement(false)
        end

        local dur = (C.knockdownDurationSec or 300) * 1000
        if md.dl_downedStart and (getTimestampMs() - md.dl_downedStart) >= dur then
            K.realDeath(player)
        end
        return
    end

    if K._awaitingEnter then
        if getTimestampMs() < (K._awaitEnterUntil or 0) then
            player:setPlayingDeathSound(false)
            player:setDeathDragDown(false)
            holdHealth(player, C.knockdownHoldHp or 5)
            return
        end
        K._awaitingEnter = false
        player:setInvincible(false)
    end

    if player:isDeathDragDown() and not player:isDead() then
        K.enter(player, "overkill")
        return
    end

    if getTimestampMs() < (K._spawnGrace or 0) then return end

    if C.knockdownAutoTrigger ~= false then
        local hp = player:getBodyDamage():getOverallBodyHealth()
        if hp < (C.knockdownThreshold or 5) and not player:isDead() then
            K.enter(player, "near-death")
        end
    end
end
Events.OnPlayerUpdate.Add(K.onPlayerUpdate)

function K.onPlayerGetDamage(player)
    local p = getPlayer()
    if p == nil or (player ~= nil and player ~= p) then return end
    local C = cfg()
    if C.knockdownEnable == false or C.knockdownAutoTrigger == false then return end
    if K._dyingForReal or K._awaitingEnter then return end
    if getTimestampMs() < (K._spawnGrace or 0) then return end
    local md = p:getModData()
    if md.dl_downed or p:isDead() then return end
    if p:getBodyDamage():getOverallBodyHealth() <= (C.knockdownThreshold or 10) then
        K.enter(p, "hit")
    end
end
if Events.OnPlayerGetDamage then Events.OnPlayerGetDamage.Add(K.onPlayerGetDamage) end

function K.onCreatePlayer(idx, player)
    if player ~= getPlayer() then return end
    K._localHolding = false
    K._awaitingEnter = false
    K._dyingForReal = false
    K._reviverName = nil
    K._spawnGrace = getTimestampMs() + 3000

    player:setInvincible(false)
    player:setBannedAttacking(false)
    player:setIgnoreAimingInput(false)
    player:setBlockMovement(false)
    player:setVariable("knockedd", false)
    player:setVariable("knockedd_fall", false)
    player:setVariable("knockedd_getup", false)
    setUntargetable(player, false)
    if DL.Knockdown.uiHide then DL.Knockdown.uiHide() end
end
Events.OnCreatePlayer.Add(K.onCreatePlayer)

function K.onFillContext(playerIndex, context, worldObjects)
    if cfg().knockdownDebugMenu == false then return end
    local player = getSpecificPlayer(playerIndex)
    if player == nil then return end
    if player:getModData().dl_downed then
        context:addOption("Get up (DEBUG)", player, function(p) K.getUp(p) end)
        if DLTestRevive then
            context:addOption("Get up - slow/revive timer (DEBUG)", player,
                function(p) ISTimedActionQueue.add(DLTestRevive:new(p)) end)
        end
    else
        context:addOption("Knock down (DEBUG)", player, function(p) K.enter(p, "debug") end)
    end
end
Events.OnFillWorldObjectContextMenu.Add(K.onFillContext)

local function onServerCommand(module, command, args)
    if module ~= "DLKnock" then return end
    if command == "setstate" and args and args.id then
        local p = getPlayerByOnlineID(args.id)
        if p and p ~= getPlayer() then
            p:getModData().dl_remoteState = args.state
        end
    elseif command == "revivenotice" and args then
        K._reviverName = (args.active and args.name) or nil
    elseif command == "forcegetup" then
        K._reviverName = nil
        local me = getPlayer()
        if me and me:getModData().dl_downed then
            K.getUp(me)
        end
    elseif command == "downverdict" and args then
        K._awaitingEnter = false
        local player = getPlayer()
        if player == nil or player:isDead() then return end
        if args.ok then
            K.enterConfirmed(player, args.strike, args.limit)
        else
            DL.log("knockdown: strike " .. tostring(args.strike) .. "/" .. tostring(args.limit) .. " -> IMMEDIATE DEATH")
            K._dyingForReal = true
            player:setInvincible(false)
            player:setGodMod(false)
            setGeneralHealth(player, 0)
            player:setHealth(0)
        end
    end
end
Events.OnServerCommand.Add(onServerCommand)

function K.onTick()
    local me = getPlayer()
    if me == nil then return end
    local players = getOnlinePlayers()
    if players == nil then return end
    for i = 0, players:size() - 1 do
        local p = players:get(i)
        if p and p ~= me then
            local md = p:getModData()

            local down = (md.dl_downed == true) or (md.dl_remoteState == "down")
            if md.dl_remoteState == "up" then down = false end
            local showing = p:getVariableBoolean("knockedd") or p:getVariableBoolean("knockedd_fall")
            if down and not showing then
                p:setVariable("knockedd_fall", true)
                if p.setShootable then p:setShootable(false) end
            elseif (not down) and showing and not p:getVariableBoolean("knockedd_getup") then
                p:setVariable("knockedd_getup", true)
                if p.setShootable then p:setShootable(true) end
                md.dl_downed = false
                md.dl_remoteState = nil
            end
        end
    end
end
if isClient() then Events.OnTick.Add(K.onTick) end

DL.log("knockdown client loaded (Phase 1: detect/hold/timer/crawl + debug self-revive)")
