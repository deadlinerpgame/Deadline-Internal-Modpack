DBNO = DBNO or {}

DBNO.Knockdown = DBNO.Knockdown or {}
local K = DBNO.Knockdown
K._localHolding = K._localHolding or false
K._awaitingEnter = K._awaitingEnter or false
K._dyingForReal = K._dyingForReal or false

local cfg = DBNO.cfg

local TRIGGER_GRACE_MS         = 3000
local ENTER_VERDICT_TIMEOUT_MS = 5000
local REAL_KILL_DELAY_MS       = 1000

local function setUntargetable(player, down)
    local C = cfg()
    player:setShootable((not down) or C.downedPlayerKill == true)
    player:setZombiesDontAttack(down and C.downedZombieKill ~= true)
end

local function sendRealDeath(player)
    sendClientCommand(player, "DBNOKnock", "realdeath", { describe = DBNO.Snap.describe(player) })
end

local function forceDie(player)
    player:die()
end
DBNO.Knockdown.forceDie = forceDie

local function isDragDown(player)
    return player:isDeathDragDown() or player:getHitReaction() == "EndDeath"
end
DBNO.Knockdown.isDragDown = isDragDown

local function markDragDeath(player)
    if K._dragDeath then return end
    K._dragDeath = true
    if isClient() then
        sendRealDeath(player)
    end
end
DBNO.Knockdown.markDragDeath = markDragDeath

local function clearDeathResidue(player, keepOnFloor)
    player:setHitReaction("")
    player:setDeathDragDown(false)
    player:setPlayingDeathSound(false)
    if not keepOnFloor then player:setOnFloor(false) end
    player:setOnKillDone(false)
    player:setOnDeathDone(false)
    player:setReanimateTimer(0)
end
DBNO.Knockdown.clearDeathResidue = clearDeathResidue

function K.enter(player)
    local md = player:getModData()
    if md.dbno_downed or player:isDead() then return end
    if getTimestampMs() < (K._triggerGrace or 0) then return end
    if isDragDown(player) then markDragDeath(player); return end
    if K._awaitingEnter then
        if getTimestampMs() < (K._awaitEnterUntil or 0) then return end
        K._awaitingEnter = false
    end
    DBNO.DeathWounds.capture(player)
    clearDeathResidue(player, true)
    DBNO.enterDownedHealth(player)
    K._awaitingEnter = true
    K._awaitEnterUntil = getTimestampMs() + ENTER_VERDICT_TIMEOUT_MS
    if isClient() then
        sendClientCommand(player, "DBNOKnock", "requestdown", {})
    else
        K._awaitingEnter = false
        K.enterConfirmed(player)
    end
end

local function enterDownedState(player, startMs)
    local md = player:getModData()
    md.dbno_downed = true
    md.dbno_downedStart = startMs
    K._localHolding = true

    clearDeathResidue(player, true)
    player:setVariable("knockedd_getup", false)
    player:setVariable("knockedd", false)
    player:setVariable("knockedd_fall", true)

    player:setPrimaryHandItem(nil)
    player:setSecondaryHandItem(nil)
    player:setIsAiming(false)
    player:setBannedAttacking(true)
    player:setIgnoreAimingInput(true)
    player:setAllowRun(false)
    player:setAllowSprint(false)
    player:setRunning(false)
    player:setSprinting(false)
    setUntargetable(player, true)

    DBNO.enterDownedHealth(player)
    ISTimedActionQueue.clear(player)
    K.uiShow()
end

function K.enterConfirmed(player, strike, limit)
    local md = player:getModData()
    if md.dbno_downed or player:isDead() then return end
    enterDownedState(player, getTimestampMs())
    md.dbno_strike = strike
    md.dbno_strikeLimit = limit
end

function K.getUp(player)
    local md = player:getModData()
    if not md.dbno_downed then return end
    md.dbno_downed = false
    md.dbno_downedStart = nil
    K._localHolding = false
    K._reviverName = nil
    DBNO.DeathWounds.clear()
    clearDeathResidue(player)
    player:setVariable("knockedd_fall", false)
    player:setVariable("knockedd_getup", true)

    DBNO.releaseHealth(player)
    player:setBannedAttacking(false)
    player:setIgnoreAimingInput(false)
    player:setAllowRun(true)
    player:setAllowSprint(true)
    player:setBlockMovement(false)
    setUntargetable(player, false)

    local hp = cfg().knockdownReviveHp
    DBNO.stopBleeding(player)
    DBNO.setGeneralHealth(player, hp)
    player:setHealth(hp)

    K._triggerGrace = getTimestampMs() + TRIGGER_GRACE_MS

    K.uiHide()
    if isClient() then
        sendClientCommand(player, "DBNOKnock", "getup", {})
    end
end

function K.finalKill(player)
    K._dyingForReal = true

    if isClient() then
        sendRealDeath(player)
    end
    K._localHolding = false
    K._reviverName = nil
    K._awaitingEnter = false
    K._realKillAt = nil

    local md = player:getModData()
    md.dbno_downed = false
    md.dbno_downedStart = nil

    player:setVariable("knockedd", false)
    player:setVariable("knockedd_fall", false)
    player:setVariable("knockedd_getup", false)

    if DBNO.DeathWounds.isEmpty(DBNO.DeathWounds._captured) then
        DBNO.DeathWounds.capture(player)
    end

    clearDeathResidue(player)
    DBNO.releaseHealth(player)
    player:setGodMod(false)
    player:setBannedAttacking(false)
    player:setIgnoreAimingInput(false)
    player:setAllowRun(true)
    player:setAllowSprint(true)
    player:setBlockMovement(false)
    player:setIgnoreMovement(false)
    setUntargetable(player, false)
    K.uiHide()

    DBNO.setGeneralHealth(player, 0)
    player:setHealth(0)

    if isClient() then
        sendClientCommand(player, "DBNOKnock", "forcedeath", {})
    end

    K._deathWatchAt = getTimestampMs()
end

function K.deathWatchdog(player)
    local at = K._deathWatchAt
    if at == nil then return end
    if player:isOnDeathDone() then
        K._deathWatchAt = nil
        return
    end
    if not player:isDead() then
        DBNO.releaseHealth(player)
        player:setGodMod(false)
        DBNO.setGeneralHealth(player, 0)
        player:setHealth(0)
    end

    local since = getTimestampMs() - at

    if since >= 1200 and not player:isOnFloor() then
        player:setOnFloor(true)
    end
    if since >= 2200 then
        K._deathWatchAt = nil
        forceDie(player)
    end
end

function K.realDeath(player)
    K._dyingForReal = true

    if isClient() then sendRealDeath(player) end
    local md = player:getModData()
    md.dbno_downed = false
    md.dbno_downedStart = nil
    K._localHolding = false
    player:setVariable("knockedd", false)
    player:setVariable("knockedd_fall", false)
    player:setVariable("knockedd_getup", false)
    player:setBlockMovement(false)
    setUntargetable(player, false)
    K.uiHide()
    if isClient() then
        sendClientCommand(player, "DBNOKnock", "getup", {})
    end
    K._realKillAt = getTimestampMs() + REAL_KILL_DELAY_MS
end

function K.resume(player, start)
    enterDownedState(player, start)

    if isClient() then
        sendClientCommand(player, "DBNOKnock", "resumed", {})
    end
end

function K.onPlayerUpdate(player)
    if player ~= getPlayer() then return end
    if K._deathWatchAt then K.deathWatchdog(player) end
    if K._realKillAt then
        if getTimestampMs() >= K._realKillAt then
            K.finalKill(player)
        end
        return
    end
    if player:isDead() then
        K.uiHide()
        return
    end
    local C = cfg()
    if C.knockdownEnable == false then return end

    if K._dyingForReal and not player:isDead() then
        K._dyingForReal = false
    end
    if K._dyingForReal then return end
    local md = player:getModData()

    if md.dbno_downed and not K._localHolding then
        if getTimestampMs() < (K._triggerGrace or 0) then return end
        local start = md.dbno_downedStart or getTimestampMs()
        local dur = (C.bleedoutTimer ~= false) and C.knockdownDurationSec * 1000 or 0
        if dur > 0 and (getTimestampMs() - start) >= dur then
            K.realDeath(player)
        else
            K.resume(player, start)
        end
        return
    end

    if md.dbno_downed then
        setUntargetable(player, true)
        local crawled = DBNO.Crawl.track(player, md.dbno_downedStart)
        if not DBNO.tickDownedHealth(player, md.dbno_downedStart, crawled) then
            K.realDeath(player)
            return
        end

        if player:isOnKillDone() or player:isOnDeathDone()
           or player:isDeathDragDown()
           or (player:getHitReaction() == "EndDeath") then
            clearDeathResidue(player, true)
        end
        if not player:isOnFloor() then player:setOnFloor(true) end
        if player:isSneaking() then player:setSneaking(false) end
        if player:isRunning() then player:setRunning(false) end
        if player:isSprinting() then player:setSprinting(false) end

        if C.moveWhileDowned == false
           or player:getVariableBoolean("knockedd_fall")
           or player:getVariableBoolean("knockedd_getup") then
            player:setBlockMovement(true)
        else
            player:setBlockMovement(false)
        end

        local dur = (C.bleedoutTimer ~= false) and C.knockdownDurationSec * 1000 or 0
        if dur > 0 and md.dbno_downedStart and (getTimestampMs() - md.dbno_downedStart) >= dur then
            K.realDeath(player)
        end
        return
    end

    if K._awaitingEnter then
        if getTimestampMs() < (K._awaitEnterUntil or 0) then
            clearDeathResidue(player, true)
            DBNO.enterDownedHealth(player)
            return
        end
        K._awaitingEnter = false
        player:setInvincible(false)
    end

    if isDragDown(player) then
        markDragDeath(player)
        return
    end

    if getTimestampMs() < (K._triggerGrace or 0) then return end

    if C.knockdownAutoTrigger ~= false then
        local hp = player:getBodyDamage():getOverallBodyHealth()
        if hp < C.knockdownThreshold and not player:isDead() then
            K.enter(player)
        end
    end
end
Events.OnPlayerUpdate.Add(K.onPlayerUpdate)

function K.onPlayerGetDamage(player)
    if player ~= getPlayer() then return end
    if cfg().knockdownEnable == false then return end
    local md = player:getModData()

    if md.dbno_downed and not K._dyingForReal then
        DBNO.tickDownedHealth(player, md.dbno_downedStart, DBNO.Crawl.track(player, md.dbno_downedStart))
    end
end
Events.OnPlayerGetDamage.Add(K.onPlayerGetDamage)

function K.onWeaponHit(attacker, victim)
    local p = getPlayer()
    if victim ~= p or attacker == p then return end
    if K._dyingForReal or K._realKillAt then return end
    local C = cfg()
    if C.knockdownEnable == false then return end
    if not p:getModData().dbno_downed then return end

    if attacker:isZombie() then
        if C.downedZombieKill ~= true then return end
    elseif instanceof(attacker, "IsoPlayer") then
        if C.downedPlayerKill ~= true then return end
    else
        return
    end

    K.realDeath(p)
end
Events.OnWeaponHitCharacter.Add(K.onWeaponHit)

function K.onCreatePlayer(idx, player)
    if not player:isLocalPlayer() then return end
    K._localHolding = false
    K._awaitingEnter = false
    K._dyingForReal = false
    K._reviverName = nil
    K._dragDeath = false
    K._realKillAt = nil
    K._deathWatchAt = nil
    K._triggerGrace = getTimestampMs() + TRIGGER_GRACE_MS

    clearDeathResidue(player)
    DBNO.releaseHealth(player)
    player:setBannedAttacking(false)
    player:setIgnoreAimingInput(false)
    player:setAllowRun(true)
    player:setAllowSprint(true)
    player:setBlockMovement(false)
    player:setVariable("knockedd", false)
    player:setVariable("knockedd_fall", false)
    player:setVariable("knockedd_getup", false)
    setUntargetable(player, false)
    K.uiHide()
end
Events.OnCreatePlayer.Add(K.onCreatePlayer)

function K.onLocalDeath(player)
    if player ~= getPlayer() then return end
    local md = player:getModData()
    md.dbno_downed = false
    md.dbno_downedStart = nil
    K._localHolding = false
    K._awaitingEnter = false
    K._reviverName = nil
    K.uiHide()
end
Events.OnPlayerDeath.Add(K.onLocalDeath)

function K.onFillContext(playerIndex, context, worldObjects)
    if cfg().knockdownDebugMenu == false then return end
    local player = getSpecificPlayer(playerIndex)
    if not (DBNO.isAdmin(player) or isDebugEnabled()) then return end
    if player:getModData().dbno_downed then
        context:addOption("Get up (DEBUG)", player, function(p) K.getUp(p) end)
        context:addOption("Get up - slow/revive timer (DEBUG)", player,
            function(p) ISTimedActionQueue.add(DBNOTestRevive:new(p)) end)
    else
        context:addOption("Knock down (DEBUG)", player, function(p) K.enter(p) end)
    end
end
Events.OnFillWorldObjectContextMenu.Add(K.onFillContext)

local function onServerCommand(module, command, args)
    if module ~= "DBNOKnock" then return end
    if command == "setstate" and args and args.id then
        local p = getPlayerByOnlineID(args.id)
        if p and p ~= getPlayer() then
            p:getModData().dbno_remoteState = args.state
        end

        if K._downSet == nil then K._downSet = {} end
        if args.state == "down" then K._downSet[args.id] = true
        elseif args.state == "up" then K._downSet[args.id] = nil end
    elseif command == "downset" and args then
        local set = {}
        for _, id in ipairs(args.ids or {}) do set[id] = true end
        K._downSet = set
    elseif command == "revivenotice" and args then
        K._reviverName = (args.active and args.name) or nil
    elseif command == "forcedown" then
        local me = getPlayer()
        if not me:getModData().dbno_downed then
            K._triggerGrace = nil
            K.enterConfirmed(me, 0, 0)
        end
    elseif command == "forcegetup" then
        K._reviverName = nil
        local me = getPlayer()
        if me:getModData().dbno_downed then
            K.getUp(me)
        end
    elseif command == "downverdict" and args then
        K._awaitingEnter = false
        local player = getPlayer()
        if player:isDead() then return end
        if args.ok then
            K.enterConfirmed(player, args.strike, args.limit)
        else
            K.finalKill(player)
        end
    end
end
Events.OnServerCommand.Add(onServerCommand)

function K.onTick()
    local me = getPlayer()
    if me == nil then return end
    local players = getOnlinePlayers()
    local downSet = K._downSet
    local zombiesSpare = cfg().downedZombieKill ~= true
    for i = 0, players:size() - 1 do
        local p = players:get(i)
        if p ~= me then
            local md = p:getModData()

            local down
            if downSet ~= nil then
                down = (downSet[p:getOnlineID()] == true)
                md.dbno_downed = down
            else
                down = (md.dbno_downed == true) or (md.dbno_remoteState == "down")
                if md.dbno_remoteState == "up" then down = false end
            end
            local showing = p:getVariableBoolean("knockedd") or p:getVariableBoolean("knockedd_fall")
            if down and not showing then
                p:setVariable("knockedd_fall", true)
                p:setShootable(false)
            elseif (not down) and showing and not p:getVariableBoolean("knockedd_getup") then
                p:setVariable("knockedd_getup", true)
                p:setShootable(true)
                md.dbno_downed = false
                md.dbno_remoteState = nil
            end
            if down and zombiesSpare then
                if not p:isZombiesDontAttack() then p:setZombiesDontAttack(true) end
                md.dbno_spared = true
            elseif md.dbno_spared then
                p:setZombiesDontAttack(false)
                md.dbno_spared = nil
            end
        end
    end
end
if isClient() then Events.OnTick.Add(K.onTick) end

local FONT_HGT_SMALL  = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
local UI_BORDER_SPACING = 10
local BUTTON_HGT = FONT_HGT_SMALL + 6
local BAR_HGT = 14

local DBNOKnockPanel = ISPanel:derive("DBNOKnockPanel")

local function timerShown()
    return DBNO.Config.bleedoutTimer ~= false
end

function DBNOKnockPanel:new()
    local w = 340
    local h = UI_BORDER_SPACING
        + FONT_HGT_MEDIUM
        + UI_BORDER_SPACING
        + (timerShown() and (BAR_HGT + 4 + FONT_HGT_SMALL + UI_BORDER_SPACING) or 0)
        + FONT_HGT_SMALL
        + UI_BORDER_SPACING
        + BUTTON_HGT
        + UI_BORDER_SPACING
    local x = (getCore():getScreenWidth() - w) / 2
    local y = getCore():getScreenHeight() * 0.70
    local o = ISPanel:new(x, y, w, h)
    setmetatable(o, self)
    self.__index = self

    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0.8 }
    o.borderColor     = { r = 0.4, g = 0.4, b = 0.4, a = 1 }
    o.moveWithMouse   = false
    o.anchorLeft      = false
    o.anchorTop       = false
    return o
end

function DBNOKnockPanel:createChildren()
    local bw = 130
    self.giveUpBtn = ISButton:new((self.width - bw) / 2, self.height - BUTTON_HGT - UI_BORDER_SPACING,
        bw, BUTTON_HGT, getText("IGUI_DBNO_GiveUp"), self, DBNOKnockPanel.onGiveUp)
    self.giveUpBtn.anchorLeft = false
    self.giveUpBtn.anchorTop = false
    self.giveUpBtn:initialise()
    self.giveUpBtn:instantiate()
    self.giveUpBtn.borderColor = { r = 0.7, g = 0.2, b = 0.2, a = 1 }
    self:addChild(self.giveUpBtn)
end

function DBNOKnockPanel:onGiveUp()
    local p = getPlayer()
    if p:getModData().dbno_downed then
        K.realDeath(p)
    end
end

local function remaining()
    local md = getPlayer():getModData()
    local dur = (DBNO.Config.bleedoutTimer ~= false)
        and DBNO.Config.knockdownDurationSec * 1000 or 0
    if md.dbno_downedStart == nil or dur <= 0 then return 0, 0 end
    local left = dur - (getTimestampMs() - md.dbno_downedStart)
    if left < 0 then left = 0 end
    return left / dur, left
end

function DBNOKnockPanel:render()
    local BHC = getCore():getBadHighlitedColor()
    local y = UI_BORDER_SPACING

    self:drawTextCentre(getText("IGUI_DBNO_YouAreDown"), self.width / 2, y,
        BHC:getR(), BHC:getG(), BHC:getB(), 1, UIFont.Medium)
    y = y + FONT_HGT_MEDIUM + UI_BORDER_SPACING

    if timerShown() then
        local frac, left = remaining()
        local barX, barW = UI_BORDER_SPACING, self.width - UI_BORDER_SPACING * 2
        self:drawRect(barX, y, barW, BAR_HGT, 0.6, 0.0, 0.0, 0.0)
        self:drawRect(barX, y, barW * frac, BAR_HGT, 0.9, 0.65 - 0.35 * frac, 0.12 + 0.30 * frac, 0.10)
        self:drawRectBorder(barX, y, barW, BAR_HGT, 0.5, 0.4, 0.4, 0.4)
        y = y + BAR_HGT + 4

        local secs = math.floor(left / 1000)
        self:drawTextCentre(string.format("%d:%02d", math.floor(secs / 60), secs % 60),
            self.width / 2, y, 1, 1, 1, 1, UIFont.Small)
        y = y + FONT_HGT_SMALL + UI_BORDER_SPACING
    end

    local rn = K._reviverName
    local md = getPlayer():getModData()
    if rn then
        self:drawTextCentre(getText("IGUI_DBNO_PickingYouUp", tostring(rn)),
            self.width / 2, y, 0.40, 0.90, 0.45, 1, UIFont.Small)
    elseif type(md.dbno_strike) == "number" and type(md.dbno_strikeLimit) == "number"
           and md.dbno_strike >= md.dbno_strikeLimit then
        self:drawTextCentre(getText("IGUI_DBNO_LastChance"),
            self.width / 2, y, 1.0, 0.55, 0.12, 1, UIFont.Small)
    end
end

function K.uiShow()
    if K._panel == nil then
        K._panel = DBNOKnockPanel:new()
        K._panel:initialise()
        K._panel:instantiate()
        K._panel:addToUIManager()
    end
    K._panel:setVisible(true)
end

function K.uiHide()
    if K._panel then
        K._panel:setVisible(false)
        K._panel:removeFromUIManager()
        K._panel = nil
    end
end

local _origAdd = ISTimedActionQueue.add
ISTimedActionQueue.add = function(action)
    if getPlayer():getModData().dbno_downed and not action.dbnoBypassLockout then
        return
    end
    return _origAdd(action)
end

require "TimedActions/ISBaseTimedAction"
DBNO.HelpUp = DBNO.HelpUp or {}

local function isDown(p)
    return p:getModData().dbno_downed == true
        or p:getVariableBoolean("knockedd") or p:getVariableBoolean("knockedd_fall")
end

DBNOHelpUp = ISBaseTimedAction:derive("DBNOHelpUp")

function DBNOHelpUp:isValid()
    return isDown(self.target)
end

function DBNOHelpUp:waitToStart()
    self.character:faceThisObject(self.target)
    return self.character:shouldBeTurning()
end

function DBNOHelpUp:update()
    self.character:faceThisObject(self.target)
end

function DBNOHelpUp:start()
    self:setActionAnim("Loot")
    self.character:SetVariable("LootPosition", "Low")
    sendClientCommand(self.character, "DBNOKnock", "reviving", { targetId = self.target:getOnlineID() })
end

function DBNOHelpUp:stop()
    if not self._done then
        sendClientCommand(self.character, "DBNOKnock", "revivecancel", { targetId = self.target:getOnlineID() })
    end
    ISBaseTimedAction.stop(self)
end

function DBNOHelpUp:perform()
    self._done = true
    sendClientCommand(self.character, "DBNOKnock", "reviverequest", { targetId = self.target:getOnlineID() })
    ISBaseTimedAction.perform(self)
end

function DBNOHelpUp:new(character, target)
    local o = ISBaseTimedAction.new(self, character)
    o.target = target
    o.stopOnWalk = true
    o.stopOnRun = true
    o.maxTime = DBNO.Config.knockdownReviveTime
    if character:isTimedActionInstant() then o.maxTime = 1 end
    return o
end

DBNOTestRevive = ISBaseTimedAction:derive("DBNOTestRevive")
function DBNOTestRevive:isValid() return self.character:getModData().dbno_downed == true end
function DBNOTestRevive:update() end
function DBNOTestRevive:start()
    K._reviverName = self.character:getDescriptor():getForename() or "Someone"
end
function DBNOTestRevive:stop()
    if not self._done then K._reviverName = nil end
    ISBaseTimedAction.stop(self)
end
function DBNOTestRevive:perform()
    self._done = true
    K._reviverName = nil
    K.getUp(self.character)
    ISBaseTimedAction.perform(self)
end
function DBNOTestRevive:new(character)
    local o = ISBaseTimedAction.new(self, character)
    o.maxTime = DBNO.Config.knockdownReviveTime
    o.forceProgressBar = true
    o.dbnoBypassLockout = true
    o.stopOnWalk = true
    o.stopOnRun = true
    return o
end

function DBNO.HelpUp.onSelect(worldobjects, player, target)
    if luautils.walkAdj(player, target:getCurrentSquare()) then
        ISTimedActionQueue.add(DBNOHelpUp:new(player, target))
    end
end

function DBNO.HelpUp.onFillWorld(playerIndex, context, worldObjects)
    local player = getSpecificPlayer(playerIndex)
    if player:getModData().dbno_downed then return end

    local square
    for _, v in ipairs(worldObjects) do
        square = v:getSquare()
        if square then break end
    end
    if square == nil then return end

    local target
    for dx = -1, 1 do
        for dy = -1, 1 do
            local sq = getCell():getGridSquare(square:getX() + dx, square:getY() + dy, square:getZ())
            if sq then
                local mos = sq:getMovingObjects()
                for i = 0, mos:size() - 1 do
                    local o = mos:get(i)
                    if instanceof(o, "IsoPlayer")
                       and o ~= player and isDown(o) then
                        target = o
                    end
                end
            end
        end
    end
    if target == nil then return end

    context:addOption("Help Up " .. DBNO.displayName(target), worldObjects, DBNO.HelpUp.onSelect, player, target)
end
Events.OnFillWorldObjectContextMenu.Add(DBNO.HelpUp.onFillWorld)
