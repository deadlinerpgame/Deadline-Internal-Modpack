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
        elseif args.reason == "blank" then notify("Load your snapshot first.")
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

local Theme = require("ElyonLib/UI/Theme/Theme")
local TextUtils = require("ElyonLib/TextUtils/TextUtils")
local LayoutUtils = require("ElyonLib/UI/Layout/LayoutUtils")
local UIUtils = require("ElyonLib/UI/Utils/UIUtils")
local ISClippedScrollingListBox = require("ElyonLib/UI/Components/ISClippedScrollingListBox")

local FONT = UIFont.Small
local T = Theme.colors
local TAB_ORDER = { "state", "death", "snap" }
local TAB_LABELS = { state = "State", death = "Death Logs", snap = "Snapshots" }

local function drawListItem(list, y, item, alt)
    local h = list.itemheight
    if list.selectable and list.selected == item.index then
        list:drawRect(0, y, list:getWidth(), h - 1, T.selected.a, T.selected.r, T.selected.g, T.selected.b)
    elseif list.selectable and list.mouseoverselected == item.index then
        list:drawRect(0, y, list:getWidth(), h - 1, T.hovered.a, T.hovered.r, T.hovered.g, T.hovered.b)
    end
    local text = item.text
    if not list.wrapped then
        text = TextUtils.trimToWidth(FONT, text, list:getWidth() - list.textPad * 2 - list.vscroll:getWidth())
    end
    list:drawText(text, list.textPad, y + math.floor((h - list.fontHgt) / 2), T.text.r, T.text.g, T.text.b, 1, FONT)
    return y + h
end

local PANEL = ISCollapsableWindow:derive("DBNOAdminPanel")

function PANEL:makeList(selectable, onSelect)
    local list = ISClippedScrollingListBox:new(0, 0, 100, 100)
    list:initialise()
    list:instantiate()
    list:setFont(FONT, 3)
    list.textPad = self.pad
    list.selectable = selectable
    list.doDrawItem = drawListItem
    Theme.applyListStyle(list)
    list.drawBorder = true
    list.target = self
    list.onmousedown = onSelect
    self:addChild(list)
    return list
end

function PANEL:makeButton(label, onClick)
    local b = ISButton:new(0, 0, TextUtils.measureWidth(FONT, label) + self.pad * 4, self.btnH, label, self, onClick)
    b:initialise()
    b:instantiate()
    b.font = FONT
    Theme.applyButtonStyle(b, nil)
    self:addChild(b)
    return b
end

function PANEL:makeEntry(digits)
    local e = ISTextEntryBox:new("", 0, 0, TextUtils.measureWidth(FONT, string.rep("0", digits)) + self.pad * 2, self.entryH)
    e:initialise()
    e:instantiate()
    Theme.applyFieldStyle(e)
    self:addChild(e)
    return e
end

function PANEL:createChildren()
    ISCollapsableWindow.createChildren(self)
    self.fontHgt = getTextManager():getFontHeight(FONT)
    self.pad = math.floor(self.fontHgt / 2)
    self.btnH = self.fontHgt + 8
    self.entryH = self.fontHgt + 6

    self.playerList = self:makeList(true, function(target, item) target:onSelectPlayer(item) end)
    self.refreshBtn = self:makeButton("Refresh", function() request("playerList", {}) end)

    self.tabBtns = {}
    for _, key in ipairs(TAB_ORDER) do
        self.tabBtns[key] = self:makeButton(TAB_LABELS[key], function(panel) panel:setTab(key) end)
    end

    self.eStrikes = self:makeEntry(5)
    self.bStrikes = self:makeButton("Set", function(panel) panel:applyStrikes() end)
    self.eWounds = self:makeEntry(5)
    self.bWounds = self:makeButton("Set", function(panel) panel:applyWounds() end)
    self.eRx = self:makeEntry(7)
    self.eRy = self:makeEntry(7)
    self.eRz = self:makeEntry(4)
    self.bResp = self:makeButton("Set", function(panel) panel:applyRespawn() end)
    self.stateRows = {
        { label = "Knockdown strikes:", controls = { self.eStrikes, self.bStrikes } },
        { label = "Wounds:", controls = { self.eWounds, self.bWounds } },
        { label = "Respawn (x, y, z):", controls = { self.eRx, self.eRy, self.eRz, self.bResp } },
    }

    self.entryList = self:makeList(true, function(target, item) target:onSelectEntry(item) end)
    self.viewer = self:makeList(false, nil)
    self.viewer.wrapped = true
    self.viewerLines = {}

    self:layout()
    self:setTab("state")
end

function PANEL:layout()
    local th = self:titleBarHeight()
    local pad = self.pad
    local bottom = self.height - pad - self:resizeWidgetHeight()
    local leftW = self.fontHgt * 12
    local listH = bottom - (th + pad) - self.btnH - pad
    UIUtils.setListGeometry(self.playerList, pad, th + pad, leftW, listH)
    LayoutUtils.setBounds(self.refreshBtn, pad, th + pad + listH + pad, leftW, self.btnH)

    local cx = pad + leftW + pad
    local x = cx
    for _, key in ipairs(TAB_ORDER) do
        local b = self.tabBtns[key]
        LayoutUtils.setBounds(b, x, th + pad, b:getWidth(), self.btnH)
        x = x + b:getWidth() + pad
    end

    local cy = th + pad + self.btnH + pad
    self.contentX, self.contentY = cx, cy

    local labelW = 0
    for _, row in ipairs(self.stateRows) do
        labelW = math.max(labelW, TextUtils.measureWidth(FONT, row.label))
    end
    for i, row in ipairs(self.stateRows) do
        row.y = cy + (i - 1) * (self.entryH + pad)
        local ex = cx + labelW + pad * 2
        for _, control in ipairs(row.controls) do
            LayoutUtils.setBounds(control, ex, row.y, control:getWidth(), self.entryH)
            ex = ex + control:getWidth() + pad
        end
    end

    local entryW = TextUtils.measureWidth(FONT, "Death #00000") + pad * 2 + self.entryList.vscroll:getWidth()
    UIUtils.setListGeometry(self.entryList, cx, cy, entryW, bottom - cy)
    local vx = cx + entryW + pad
    UIUtils.setListGeometry(self.viewer, vx, cy, self.width - vx - pad, bottom - cy)
    self:wrapViewer()
end

function PANEL:onResize()
    ISCollapsableWindow.onResize(self)
    if self.viewer then self:layout() end
end

function PANEL:wrapViewer()
    local list = self.viewer
    local width = list:getWidth() - list.textPad * 2 - list.vscroll:getWidth()
    if width == self.viewerWrapWidth then return end
    self.viewerWrapWidth = width
    list:clear()
    for _, line in ipairs(self.viewerLines) do
        local indent = string.match(line, "^%s*")
        local room = math.max(self.fontHgt * 4, width - TextUtils.measureWidth(FONT, indent))
        for _, part in ipairs(TextUtils.wrapLines(string.sub(line, #indent + 1), FONT, room)) do
            list:addItem(indent .. part, nil)
        end
    end
end

function PANEL:setViewer(lines)
    self.viewerLines = lines
    self.viewerWrapWidth = nil
    self:wrapViewer()
    self.viewer:setYScroll(0)
end

function PANEL:setTab(tab)
    self.tab = tab
    for _, key in ipairs(TAB_ORDER) do
        Theme.applyButtonStyle(self.tabBtns[key], key == tab and "primary" or nil)
    end
    local hasPlayer = self.selected ~= nil
    local stateOn = hasPlayer and tab == "state"
    for _, row in ipairs(self.stateRows) do
        for _, control in ipairs(row.controls) do control:setVisible(stateOn) end
    end
    local listOn = hasPlayer and (tab == "death" or tab == "snap")
    self.entryList:setVisible(listOn)
    self.viewer:setVisible(listOn)
    if listOn then
        self.entryList:clear()
        self:setViewer({})
        if tab == "death" then request("deathLogList", { target = self.selected })
        else request("snapshotList", { target = self.selected }) end
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
    if self.isCollapsed then return end
    if self.selected == nil then
        self:drawText("Select a player on the left.", self.contentX, self.contentY, 0.8, 0.8, 0.8, 1, FONT)
        return
    end
    if self.tab == "state" then
        local offset = math.floor((self.entryH - self.fontHgt) / 2)
        for _, row in ipairs(self.stateRows) do
            self:drawText(row.label, self.contentX, row.y + offset, 1, 1, 1, 1, FONT)
        end
    end
end

function DBNO.AdminUI.open()
    if DBNO.AdminUI._window then
        DBNO.AdminUI._window:setVisible(true); DBNO.AdminUI._window:bringToTop(); return
    end
    local fontHgt = getTextManager():getFontHeight(FONT)
    local minW, minH = fontHgt * 40, fontHgt * 22
    local x, y, width, height = LayoutUtils.defaultWindowGeometry(fontHgt * 56, fontHgt * 38, minW, minH)
    local w = PANEL:new(x, y, width, height)
    DBNO.AdminUI._window = w
    w.minimumWidth, w.minimumHeight = minW, minH
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
        w:setViewer(out)
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
