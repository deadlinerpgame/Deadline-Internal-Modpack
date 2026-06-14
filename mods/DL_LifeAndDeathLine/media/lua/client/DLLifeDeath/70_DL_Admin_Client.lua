DL = DL or {}
DL.AdminUI = DL.AdminUI or {}

if ISCollapsableWindow == nil or ISScrollingListBox == nil or ISTextEntryBox == nil
   or ISButton == nil or ISRichTextPanel == nil then
    DL.warn("admin UI: required ISUI classes missing; panel not installed")
    return
end

local function request(cmd, args)
    local p = getPlayer()
    if p then sendClientCommand(p, "DLAdmin", cmd, args or {}) end
end
DL.AdminUI.request = request

local function withDates(line)
    line = tostring(line)
    return (line:gsub("ts=(%d+)", function(n)
        local d = DL.fmtTs and DL.fmtTs(n)
        if d then return "ts=" .. n .. "  (" .. d .. ")" end
        return "ts=" .. n
    end))
end

local PANEL = ISCollapsableWindow:derive("DLAdminPanel")

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

function DL.AdminUI.open()
    if DL.AdminUI._window then
        DL.AdminUI._window:setVisible(true); DL.AdminUI._window:bringToTop(); return
    end
    local w = PANEL:new(120, 100, 780, 540)
    DL.AdminUI._window = w
    w:initialise(); w:instantiate()
    w.title = "DL Admin Panel"
    w:addToUIManager()
    request("playerList", {})
end

Events.OnServerCommand.Add(function(module, command, args)
    if module ~= "DLAdmin" then return end
    local w = DL.AdminUI._window
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

local function clientIsAdmin()
    local p = getPlayer()
    if p == nil then return false end
    local lvl = p.getAccessLevel and p:getAccessLevel()
    if lvl ~= nil and lvl ~= "" and lvl ~= "None" then return true end
    return (isDebugEnabled and isDebugEnabled()) or false
end

Events.OnFillWorldObjectContextMenu.Add(function(playerIndex, context, worldobjects, test)
    if test then return end
    if not clientIsAdmin() then return end
    context:addOption("DL Admin Panel", nil, function() DL.AdminUI.open() end)
end)

local _registerTimes = {}
Events.OnCreatePlayer.Add(function(idx, player)
    if player ~= getPlayer() then return end
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

DL.log("admin client UI loaded")
