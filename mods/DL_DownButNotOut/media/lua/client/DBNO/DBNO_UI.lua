DBNO = DBNO or {}

local function notify(msg)
    local p = getPlayer()
    if p == nil then return end
    HaloTextHelper.addText(p, msg)
end

local function isSavePoint(obj)
    local C = DBNO.Config
    local spr = obj:getSprite()
    if spr == nil then return false end

    local name = spr:getName()
    if name and C.restTileSprites[name] then return true end

    if C.useBedsAsSavePoint ~= false then
        local props = obj:getProperties()
        if props and props:Is(IsoFlagType.bed) then
            local bedType = props:Val("BedType")
            if bedType ~= "badChair" then return true end
        end
    end

    return false
end

local function findRestTile(worldobjects)
    for _, o in ipairs(worldobjects) do
        local sq = o:getSquare()
        if sq then
            local objs = sq:getObjects()
            for i = 0, objs:size() - 1 do
                local obj = objs:get(i)
                if isSavePoint(obj) then return obj end
            end
        end
    end
    return nil
end

local function onSave(player)
    sendClientCommand(player, "DBNOSnapshot", "save", { payload = DBNO.Snap.payload(player) })
end
local function onRestore(player)
    sendClientCommand(player, "DBNOSnapshot", "restore", {})
end

local function onFillContextMenu(playerIndex, context, worldobjects, test)
    if test then return end
    local tile = findRestTile(worldobjects)
    if tile == nil then return end
    local player = getSpecificPlayer(playerIndex)
    if player == nil then return end
    local sq = tile:getSquare()
    if sq == nil then return end
    if player:getZ() ~= sq:getZ()
       or math.abs(math.floor(player:getX()) - sq:getX()) > 1
       or math.abs(math.floor(player:getY()) - sq:getY()) > 1 then
        return
    end

    local C = DBNO.Config
    local snapshots = (C.snapshotManual ~= false)
    local respawnPt = (C.respawnPointEnable ~= false)
    if not snapshots and not respawnPt then return end

    local parent = context:addOption(getText("ContextMenu_DBNO_Snapshot"))
    local sub = ISContextMenu:getNew(context)
    context:addSubMenu(parent, sub)
    if snapshots then
        sub:addOption("Save snapshot", player, onSave)
        sub:addOption("Restore most recent", player, onRestore)
    end
    if respawnPt then
        sub:addOption("Set respawn point", player, function(p)
            sendClientCommand(p, "DBNORespawn", "setRespawn", {})
        end)
    end
end
Events.OnFillWorldObjectContextMenu.Add(onFillContextMenu)

local function findOtherPlayer(worldobjects, me)
    for _, o in ipairs(worldobjects) do
        local sq = o:getSquare()
        local mos = sq and sq:getMovingObjects()
        if mos then
            for i = 0, mos:size() - 1 do
                local p = mos:get(i)
                if p ~= me and instanceof(p, "IsoPlayer")
                   and not p:isDead() then return p end
            end
        end
    end
    return nil
end

local function onFillPlayerContextMenu(playerIndex, context, worldobjects, test)
    if test then return end
    local me = getSpecificPlayer(playerIndex)
    if not DBNO.isAdmin(me) then return end
    if DBNO.Config.knockdownEnable == false then return end

    local target = findOtherPlayer(worldobjects, me)
    if target == nil then return end
    local id = target:getOnlineID()

    local parent = context:addOption("DBNO: " .. DBNO.displayName(target))
    local sub = ISContextMenu:getNew(context)
    context:addSubMenu(parent, sub)

    sub:addOption("Force knockdown", nil, function()
        sendClientCommand(me, "DBNOAdmin", "forceDown", { id = id })
    end)
    sub:addOption("Force get up", nil, function()
        sendClientCommand(me, "DBNOAdmin", "forceUp", { id = id })
    end)
end
Events.OnFillWorldObjectContextMenu.Add(onFillPlayerContextMenu)

Events.OnServerCommand.Add(function(module, command, args)
    if module ~= "DBNOSnapshot" then return end
    if command == "saveResult" then
        if args.ok then notify("Snapshot saved.")
        elseif args.reason == "cooldown" then notify("Wait " .. tostring(args.wait) .. "s before saving again.")
        else notify("Snapshot save failed.") end
    elseif command == "restoreResult" then
        if args.reason == "used" then notify("Already restored this life.")
        elseif args.reason == "none" then notify("No snapshot to restore.")
        else notify("Restore failed.") end
    elseif command == "applyRestore" then
        local snap = DBNO.Snap.decode(args.data)
        local p = getPlayer()
        if snap and p then
            DBNO.Snap.apply(p, snap)
            if args.know then DBNO.Knowledge.apply(p, args.know) end
            if args.md then
                DBNO.ModData.apply(p, args.md)
                p:resetModel()
                triggerEvent("OnClothingUpdated", p)
                if isClient() and p:getModData().SPNCharCustom ~= nil then
                    sendClientCommand(p, "SPNCC", "RefreshCustomisation", {})
                end
            end
            DBNO.Snap.syncXp(p)
            notify("Snapshot restored.")
        end
    end
end)

local function cacheRespawn(args)
    if args == nil or args.x == nil then return end
    DBNO.Respawn.point = { x = args.x, y = args.y, z = args.z or 0 }
end

Events.OnServerCommand.Add(function(module, command, args)
    if module ~= "DBNORespawn" then return end
    if command == "setResult" and args and args.ok then
        cacheRespawn(args)
        notify("Respawn point set (" .. tostring(args.x) .. ", " .. tostring(args.y) .. ").")
    elseif command == "point" then
        cacheRespawn(args)
    end
end)

Events.OnCreatePlayer.Add(function(idx, player)
    if not player:isLocalPlayer() then return end
    if isClient() then
        sendClientCommand(player, "DBNORespawn", "getRespawn", {})
    else
        cacheRespawn(DBNO.RespawnPt.get(player:getUsername()))
    end
end)

require "MF_ISMoodle"
local function countToValue(n)
    if n == nil or n <= 0 then return 0.5 end
    if n == 1 then return 0.35 end
    if n == 2 then return 0.25 end
    if n == 3 then return 0.15 end
    return 0.05
end

MF.createMoodle("DBNOWounds")
MF.createMoodle("DBNOKnockdowns")
MF.createMoodle("DBNOLastLife")

local function configMoodle(m)
    m:setThresholds(0.1, 0.2, 0.3, 0.4, nil, nil, nil, nil)
end

local MOODLE_NAMES = { "DBNOWounds", "DBNOKnockdowns", "DBNOLastLife" }
local _known = {}

local function retire(m)
    if m ~= nil and m.addedToUIManager then
        m:removeFromUIManager()
        m.addedToUIManager = false
    end
end

local function isUsable(m, player)
    if m == nil or m.char ~= player or m.disable then return false end
    local md = player:getModData().Moodles
    return md ~= nil and md[m.name] ~= nil
end

local function ensureMoodles()
    local player = getSpecificPlayer(0)
    if player == nil then return false end
    local ok = true
    for _, name in ipairs(MOODLE_NAMES) do
        local m = MF.getMoodle(name, 0)
        if _known[name] ~= nil and _known[name] ~= m then
            retire(_known[name])
            _known[name] = nil
        end
        if not isUsable(m, player) then
            retire(m)
            MF.ISMoodle:new(name, player)
            m = MF.getMoodle(name, 0)
            if not isUsable(m, player) then ok = false end
        end
        if m ~= nil and _known[name] ~= m then
            configMoodle(m)
            _known[name] = m
        end
    end
    return ok
end

local function applyStatus(w, k)
    if not ensureMoodles() then return end
    local mw = MF.getMoodle("DBNOWounds", 0)
    if mw then mw:setValue(countToValue(w)) end
    local mk = MF.getMoodle("DBNOKnockdowns", 0)
    if mk then mk:setValue(countToValue(k)) end

    local ml = MF.getMoodle("DBNOLastLife", 0)
    if ml then
        local limit = DBNO.Config.woundThreshold
        local last = limit > 0 and (tonumber(w) or 0) >= limit
        ml:setValue(last and 0.05 or 0.5)
    end

    DBNO.Wounds.count = tonumber(w) or DBNO.Wounds.count
    DBNO.Wounds.strikes = tonumber(k) or DBNO.Wounds.strikes
end

local _lastReq = 0
Events.OnTick.Add(function()
    local p = getPlayer()
    if p == nil then return end
    if not ensureMoodles() then return end
    local now = getTimestampMs()
    if (now - _lastReq) < 2500 then return end
    _lastReq = now
    if isClient() then
        sendClientCommand(p, "DBNOMoodle", "statusrequest", {})
    else
        local u = p:getUsername()
        local w = DBNO.Wounds.get(u)
        if DBNO.Config.woundsEnable == false or DBNO.Config.woundThreshold <= 0 then
            w = 0
        end
        local k = DBNO.Strikes.count(u, now)
        applyStatus(w, k)
    end
end)

Events.OnServerCommand.Add(function(module, command, args)
    if module ~= "DBNOMoodle" or command ~= "status" or args == nil then return end
    applyStatus(args.w, args.k)
end)

DBNO.AdminUI = DBNO.AdminUI or {}

local function request(cmd, args)
    local p = getPlayer()
    if p then sendClientCommand(p, "DBNOAdmin", cmd, args or {}) end
end
DBNO.AdminUI.request = request

local function withDates(line)
    line = tostring(line)
    return (line:gsub("ts=(%d+)", function(n)
        local d = DBNO.fmtTs(n)
        if d then return "ts=" .. n .. "  (" .. d .. ")" end
        return "ts=" .. n
    end))
end

local PANEL = ISCollapsableWindow:derive("DBNOAdminPanel")

function PANEL:createChildren()
    ISCollapsableWindow.createChildren(self)
    local th = self:titleBarHeight()
    local pad = 8
    local cx = pad + 180 + pad
    local cy = th + pad + 30

    local listH = self.height - th - pad * 2 - 28
    self.playerList = ISScrollingListBox:new(pad, th + pad, 180, listH)
    self.playerList:initialise(); self.playerList:instantiate()
    self.playerList.itemheight = 20; self.playerList.drawBorder = true
    self.playerList.font = UIFont.Small
    self.playerList.fontHgt = getTextManager():getFontHeight(UIFont.Small)
    self.playerList.target = self
    self.playerList.onmousedown = function(target, item) target:onSelectPlayer(item) end
    self:addChild(self.playerList)

    self.refreshBtn = ISButton:new(pad, th + pad + listH + 4, 180, 22, "Refresh", self,
        function(s_) request("playerList", {}) end)
    self.refreshBtn:initialise(); self.refreshBtn:instantiate()
    self:addChild(self.refreshBtn)

    self.tabBtns = {}
    local labels = { { "state", "State" }, { "death", "Death Logs" }, { "snap", "Snapshots" } }
    for i, t in ipairs(labels) do
        local key = t[1]
        local b = ISButton:new(cx + (i - 1) * 92, th + pad, 90, 22, t[2], self,
            function(self_) self_:setTab(key) end)
        b:initialise(); b:instantiate(); self:addChild(b)
        self.tabBtns[key] = b
    end

    local function entry(ex, ey, ew) local e = ISTextEntryBox:new("", ex, ey, ew, 20); e:initialise(); e:instantiate(); self:addChild(e); return e end
    local function setbtn(ex, ey, fn) local b = ISButton:new(ex, ey, 50, 20, "Set", self, fn); b:initialise(); self:addChild(b); return b end

    self.eStrikes = entry(cx + 130, cy, 50)
    self.bStrikes = setbtn(cx + 185, cy, function(s) s:applyStrikes() end)
    self.eWounds  = entry(cx + 130, cy + 28, 50)
    self.bWounds  = setbtn(cx + 185, cy + 28, function(s) s:applyWounds() end)
    self.eRx = entry(cx + 130, cy + 56, 70)
    self.eRy = entry(cx + 205, cy + 56, 70)
    self.eRz = entry(cx + 280, cy + 56, 40)
    self.bResp = setbtn(cx + 325, cy + 56, function(s) s:applyRespawn() end)

    self.entryList = ISScrollingListBox:new(cx, cy, 120, self.height - cy - pad)
    self.entryList:initialise(); self.entryList:instantiate()
    self.entryList.itemheight = 18; self.entryList.drawBorder = true
    self.entryList.font = UIFont.Small
    self.entryList.fontHgt = getTextManager():getFontHeight(UIFont.Small)
    self.entryList.target = self
    self.entryList.onmousedown = function(target, item) target:onSelectEntry(item) end
    self:addChild(self.entryList)

    self.viewer = ISTextEntryBox:new("", cx + 128, cy, self.width - (cx + 128) - pad, self.height - cy - pad)
    self.viewer:initialise(); self.viewer:instantiate()
    self.viewer:setMultipleLine(true)
    self.viewer.background = true
    self:addChild(self.viewer)

    self:setTab("state")
end

function PANEL:setTab(tab)
    self.tab = tab
    local stateOn = (tab == "state")
    for _, e in ipairs({ self.eStrikes, self.bStrikes, self.eWounds, self.bWounds,
                         self.eRx, self.eRy, self.eRz, self.bResp }) do e:setVisible(stateOn) end
    local listOn = (tab == "death" or tab == "snap")
    self.entryList:setVisible(listOn); self.viewer:setVisible(listOn)
    if listOn then self.entryList:clear(); self.viewer:setText("") end
    if self.selected then
        if tab == "death" then request("deathLogList", { target = self.selected })
        elseif tab == "snap" then request("snapshotList", { target = self.selected }) end
    end
end

function PANEL:onSelectPlayer(item)
    if item == nil then return end
    self.selected = item
    request("state", { target = item })
    self:setTab(self.tab or "state")
end

function PANEL:onSelectEntry(item)
    if item == nil or self.selected == nil then return end
    if self.tab == "death" then request("deathLogEntry", { target = self.selected, id = item })
    elseif self.tab == "snap" then request("snapshotEntry", { target = self.selected, slot = item }) end
end

function PANEL:applyStrikes() if self.selected then request("setStrikes", { target = self.selected, value = self.eStrikes:getText() }) end end
function PANEL:applyWounds()  if self.selected then request("setWounds",  { target = self.selected, value = self.eWounds:getText() }) end end
function PANEL:applyRespawn()
    if self.selected then
        request("setRespawn", { target = self.selected, x = self.eRx:getText(), y = self.eRy:getText(), z = self.eRz:getText() })
    end
end

function PANEL:render()
    ISCollapsableWindow.render(self)
    local cx = 8 + 180 + 8
    local cy = self:titleBarHeight() + 8 + 30
    if self.selected == nil then
        self:drawText("Select a player on the left.", cx, cy + 6, 0.8, 0.8, 0.8, 1, UIFont.Small)
        return
    end
    if self.tab == "state" then
        self:drawText("Knockdown strikes:", cx, cy + 2, 1, 1, 1, 1, UIFont.Small)
        self:drawText("Wounds:", cx, cy + 30, 1, 1, 1, 1, UIFont.Small)
        self:drawText("Respawn (x, y, z):", cx, cy + 58, 1, 1, 1, 1, UIFont.Small)
    end
end

function DBNO.AdminUI.open()
    if DBNO.AdminUI._window then
        DBNO.AdminUI._window:setVisible(true); DBNO.AdminUI._window:bringToTop(); return
    end
    local w = PANEL:new(120, 100, 780, 540)
    DBNO.AdminUI._window = w
    w:initialise(); w:instantiate()
    w.title = "DBNO Admin Panel"
    w:addToUIManager()
    request("playerList", {})
end

Events.OnServerCommand.Add(function(module, command, args)
    if module ~= "DBNOAdmin" then return end
    local w = DBNO.AdminUI._window
    if w == nil then return end
    if command == "playerList" then
        w.playerList:clear()
        for _, name in ipairs(args.names or {}) do w.playerList:addItem(name, name) end
    elseif command == "state" then
        if args.target == w.selected then
            w.eStrikes:setText(tostring(args.strikes or 0))
            w.eWounds:setText(tostring(args.wounds or 0))
            w.eRx:setText(tostring(args.rx or 0))
            w.eRy:setText(tostring(args.ry or 0))
            w.eRz:setText(tostring(args.rz or 0))
        end
    elseif command == "deathLogList" then
        if args.target == w.selected and w.tab == "death" then
            w.entryList:clear()
            for _, id in ipairs(args.ids or {}) do w.entryList:addItem("Death #" .. tostring(id), id) end
        end
    elseif command == "snapshotList" then
        if args.target == w.selected and w.tab == "snap" then
            w.entryList:clear()
            for _, slot in ipairs(args.slots or {}) do w.entryList:addItem("Slot " .. tostring(slot), slot) end
        end
    elseif command == "viewer" then
        local out = { tostring(args.title or ""), "" }
        for _, l in ipairs(args.lines or {}) do out[#out + 1] = withDates(l) end
        w.viewer:setText(table.concat(out, "\n"))
    end
end)

Events.OnFillWorldObjectContextMenu.Add(function(playerIndex, context, worldobjects, test)
    if test then return end
    if not (DBNO.isAdmin(getPlayer()) or isDebugEnabled()) then return end
    context:addOption("DBNO Admin Panel", nil, function() DBNO.AdminUI.open() end)
end)

local _registerTimes = {}
Events.OnCreatePlayer.Add(function(idx, player)
    if not player:isLocalPlayer() then return end
    local now = getTimestampMs()
    _registerTimes = { now + 4000, now + 9000 }
end)
Events.OnTick.Add(function()
    if #_registerTimes == 0 then return end
    if getTimestampMs() >= _registerTimes[1] then
        table.remove(_registerTimes, 1)
        if getPlayer() then request("register", {}) end
    end
end)
