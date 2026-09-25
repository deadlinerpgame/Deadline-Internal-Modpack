
local ServerPointsAdminPanel = ISPanel:derive("ServerPointsAdminPanel")

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
local FONT_SCALE = FONT_HGT_SMALL / 14

if not _ServerPoints_DBHandlersPatched then
    _ServerPoints_DBHandlersPatched = true
    if ISWhitelistViewer and ISWhitelistViewer.receiveDBSchema then
        local orig = ISWhitelistViewer.receiveDBSchema
        local safe = function(schema)
            if ISWhitelistViewer.instance == nil then return end
            return orig(schema)
        end
        pcall(function() Events.OnGetDBSchema.Remove(orig) end)
        Events.OnGetDBSchema.Add(safe)
        ISWhitelistViewer.receiveDBSchema = safe
    end
    if ISWhitelistTable and ISWhitelistTable.getTableResult then
        local orig = ISWhitelistTable.getTableResult
        local safe = function(datas, rowId, tableName)
            if ISWhitelistViewer.instance == nil then return end
            return orig(datas, rowId, tableName)
        end
        pcall(function() Events.OnGetTableResult.Remove(orig) end)
        Events.OnGetTableResult.Add(safe)
        ISWhitelistTable.getTableResult = safe
    end
end

local function onServerCommand(module, command, args)
    if module ~= "ServerPoints" then return end
    local inst = ServerPointsAdminPanel.instance
    if inst == nil then return end
    if command == "admincfg" and args then
        inst.pointTypes = args.pointTypes or {}
        inst.presets = args.presets or {}
        inst.knownSet = {}
        for _, u in ipairs(args.known or {}) do inst.knownSet[u] = true end
        inst:rebuildTypeCombo()
        inst:rebuildPresetList()
        inst:rebuildPlayerCombo()
    elseif command == "balances" and args then
        if args.username == inst.balanceUser then
            inst.balances = args.balances or {}
        end
    elseif command == "reloaded" then
        inst.status = "Config reloaded."
        inst.statusUntil = getTimestampMs() + 2500
        sendClientCommand("ServerPoints", "admincfg", nil)
    end
end

local function onDBSchema(schema)
    pcall(function() getTableResult("whitelist", 1000000) end)
end

local function onTableResult(datas, rowId, tableName)
    local inst = ServerPointsAdminPanel.instance
    if inst == nil or tableName ~= "whitelist" or datas == nil then return end
    if rowId == 0 then inst.accounts = {} end
    for i = 0, datas:size() - 1 do
        local r = datas:get(i)
        local ok, uname = pcall(function() return r:getValues():get("username") end)
        if ok and uname and uname ~= "" then inst.accounts[uname] = true end
    end
    inst:rebuildPlayerCombo()
end

function ServerPointsAdminPanel:targetUser()
    local typed = self.playerEntry and self.playerEntry:getText() or ""
    typed = typed:gsub("^%s+", ""):gsub("%s+$", "")
    if typed ~= "" then return typed end
    return nil
end

function ServerPointsAdminPanel:selectedType()
    if self.typeCombo and self.typeIds then
        return self.typeIds[self.typeCombo.selected]
    end
    return nil
end

function ServerPointsAdminPanel:requestBalances()
    local t = self:targetUser()
    if t then
        self.balanceUser = t
        self.balances = {}
        self.lastReqUser = t
        self.lastReqAt = getTimestampMs()
        sendClientCommand("ServerPoints", "get", { t })
    end
end

function ServerPointsAdminPanel:rebuildTypeCombo()
    if not self.typeCombo then return end
    local ids = {}
    for k in pairs(self.pointTypes or {}) do ids[#ids + 1] = k end
    table.sort(ids)
    self.typeIds = ids
    self.typeCombo:clear()
    for _, id in ipairs(ids) do
        self.typeCombo:addOption((self.pointTypes[id].name or id))
    end
    if #ids == 0 then self.typeCombo:addOption("(no currencies)") end
    self.typeCombo.selected = 1
end

function ServerPointsAdminPanel:rebuildPresetList()
    if not self.presetList then return end
    self.presetList:clear()
    for i, p in ipairs(self.presets or {}) do
        self.presetList:addItem(p.name or ("Preset " .. i), i)
    end
end

function ServerPointsAdminPanel:rebuildPlayerCombo()
    if not self.playerCombo then return end
    local set = {}
    local players = getOnlinePlayers()
    if players then
        for i = 0, players:size() - 1 do
            local u = players:get(i):getUsername()
            if u then set[u] = true end
        end
    end
    for u in pairs(self.knownSet or {}) do set[u] = true end
    for u in pairs(self.accounts or {}) do set[u] = true end
    local list = {}
    for u in pairs(set) do list[#list + 1] = u end
    table.sort(list)
    self.playerCombo:clear()
    for _, u in ipairs(list) do self.playerCombo:addOption(u) end
    if #list == 0 then self.playerCombo:addOption("(no accounts found)") end
    self.playerCombo.selected = 1
end

function ServerPointsAdminPanel:createChildren()
    local pad = 10 * FONT_SCALE
    local btnHgt = FONT_HGT_SMALL + 6 * FONT_SCALE
    local lblW = getTextManager():MeasureStringX(UIFont.Small, "Username:") + 6 * FONT_SCALE
    local fieldX = pad + lblW
    local fieldW = self.width - fieldX - pad
    local y = pad + FONT_HGT_MEDIUM + pad

    self.playerCombo = ISComboBox:new(fieldX, y, fieldW, btnHgt, self, function(target, combo)
        local name = combo:getSelectedText()
        if name and name ~= "(no accounts found)" then
            target.playerEntry:setText(name)
            target:requestBalances()
        end
    end)
    self.playerCombo:initialise()
    self:addChild(self.playerCombo)
    y = y + btnHgt + 4 * FONT_SCALE

    self.playerEntry = ISTextEntryBox:new("", fieldX, y, fieldW, btnHgt)
    self.playerEntry:initialise()
    self.playerEntry:instantiate()
    self.playerEntry.onTextChange = function() self:requestBalances() end
    self:addChild(self.playerEntry)
    y = y + btnHgt + 4 * FONT_SCALE

    self.balanceY = y
    y = y + FONT_HGT_SMALL * 3 + 6 * FONT_SCALE

    self.typeCombo = ISComboBox:new(pad, y, (self.width - pad * 3) * 0.55, btnHgt, self, function() self:requestBalances() end)
    self.typeCombo:initialise()
    self:addChild(self.typeCombo)
    self.amountEntry = ISTextEntryBox:new("100", pad + (self.width - pad * 3) * 0.55 + pad, y, (self.width - pad * 3) * 0.45, btnHgt)
    self.amountEntry:initialise()
    self.amountEntry:instantiate()
    self.amountEntry:setOnlyNumbers(true)
    self.amountEntry:setMaxTextLength(9)
    self:addChild(self.amountEntry)
    y = y + btnHgt + 4 * FONT_SCALE

    local halfW = (self.width - pad * 3) / 2
    self.giveBtn = ISButton:new(pad, y, halfW, btnHgt, "GIVE", self, function() self:onGive(1) end)
    self.giveBtn:initialise(); self:addChild(self.giveBtn)
    self.takeBtn = ISButton:new(pad * 2 + halfW, y, halfW, btnHgt, "TAKE", self, function() self:onGive(-1) end)
    self.takeBtn:initialise(); self:addChild(self.takeBtn)
    y = y + btnHgt + pad

    self.presetLabelY = y
    y = y + FONT_HGT_SMALL + 2 * FONT_SCALE
    local presetH = self.height - y - pad - (btnHgt + pad) * 3
    if presetH < btnHgt * 2 then presetH = btnHgt * 2 end
    self.presetList = ISScrollingListBox:new(pad, y, self.width - pad * 2, presetH)
    self.presetList:initialise()
    self.presetList.itemheight = FONT_HGT_SMALL + 6 * FONT_SCALE
    self.presetList.drawBorder = true
    self.presetList.font = UIFont.Small
    self:addChild(self.presetList)
    y = y + presetH + 4 * FONT_SCALE

    self.applyPresetBtn = ISButton:new(pad, y, self.width - pad * 2, btnHgt, "APPLY PRESET", self, function() self:onApplyPreset() end)
    self.applyPresetBtn:initialise(); self:addChild(self.applyPresetBtn)
    y = y + btnHgt + 4 * FONT_SCALE

    self.spawnBtn = ISButton:new(pad, y, self.width - pad * 2, btnHgt, "SPAWN REDEEM TOKEN", self, function() self:onSpawn() end)
    self.spawnBtn:initialise(); self:addChild(self.spawnBtn)
    y = y + btnHgt + 4 * FONT_SCALE

    local closeW = (self.width - pad * 3) / 2
    self.reloadBtn = ISButton:new(pad, y, closeW, btnHgt, "RELOAD CONFIG", self, function() self:onReload() end)
    self.reloadBtn:initialise(); self:addChild(self.reloadBtn)
    self.closeBtn = ISButton:new(pad * 2 + closeW, y, closeW, btnHgt, getText("UI_btn_close"), self, function() self:close() end)
    self.closeBtn:initialise(); self:addChild(self.closeBtn)

    Events.OnServerCommand.Add(onServerCommand)
    Events.OnGetDBSchema.Add(onDBSchema)
    Events.OnGetTableResult.Add(onTableResult)

    sendClientCommand("ServerPoints", "admincfg", nil)
    self:rebuildPlayerCombo()
    pcall(function() getDBSchema() end)
end

function ServerPointsAdminPanel:onGive(sign)
    local target = self:targetUser()
    local ptype = self:selectedType()
    local amount = (tonumber(self.amountEntry:getText()) or 0) * sign
    if not target then self:flash("Pick or type a player."); return end
    if not ptype then self:flash("No currency selected."); return end
    sendClientCommand("ServerPoints", "grant", { target, ptype, amount })
    self:flash((sign < 0 and "Took " or "Gave ") .. math.abs(amount) .. " " .. self:typeLabel(ptype))
end

function ServerPointsAdminPanel:onApplyPreset()
    local target = self:targetUser()
    if not target then self:flash("Pick or type a player."); return end
    local sel = self.presetList.selected
    local item = self.presetList.items[sel]
    if not item then self:flash("Select a preset."); return end
    sendClientCommand("ServerPoints", "preset", { target, item.item })
    self:flash("Applied '" .. tostring(item.text) .. "'.")
end

function ServerPointsAdminPanel:onSpawn()
    local ptype = self:selectedType()
    local amount = tonumber(self.amountEntry:getText()) or 0
    if not ptype or amount <= 0 then self:flash("Set a currency + amount."); return end
    local item = getPlayer():getInventory():AddItem("Base.ServerPoints")
    if item == nil then return end
    local md = item:getModData()
    md.serverPoints = amount
    md.serverPointsType = ptype
    md.serverPointsTypeName = self:typeLabel(ptype)
    item:setName(amount .. " " .. self:typeLabel(ptype))
    self:flash("Spawned token: " .. amount .. " " .. self:typeLabel(ptype))
end

function ServerPointsAdminPanel:onReload()
    sendClientCommand("ServerPoints", "reload", nil)
end

function ServerPointsAdminPanel:typeLabel(ptype)
    if self.pointTypes and ptype and self.pointTypes[ptype] then
        return self.pointTypes[ptype].name or ptype
    end
    return ptype or "Points"
end

function ServerPointsAdminPanel:flash(msg)
    self.status = msg
    self.statusUntil = getTimestampMs() + 2500
end

function ServerPointsAdminPanel:render()
    local pad = 10 * FONT_SCALE

    local t = self:targetUser()
    if t and t ~= self.lastReqUser and ((not self.lastReqAt) or (getTimestampMs() - self.lastReqAt) > 400) then
        self:requestBalances()
    end

    self:drawTextCentre("Server Points", self.width / 2, pad, 1, 1, 1, 1, UIFont.Medium)
    self:drawText("Player:", pad, self.playerCombo.y + (self.playerCombo.height - FONT_HGT_SMALL) / 2, 1, 1, 1, 1, UIFont.Small)
    self:drawText("Username:", pad, self.playerEntry.y + (self.playerEntry.height - FONT_HGT_SMALL) / 2, 1, 1, 1, 1, UIFont.Small)

    local y = self.balanceY
    local who = self.balanceUser or "(none)"
    self:drawText("Balances for " .. who .. ":", pad, y, 0.8, 0.9, 0.8, 1, UIFont.Small)
    y = y + FONT_HGT_SMALL
    local parts = {}
    for _, id in ipairs(self.typeIds or {}) do
        parts[#parts + 1] = self:typeLabel(id) .. ": " .. tostring((self.balances and self.balances[id]) or 0)
    end
    self:drawText(#parts > 0 and table.concat(parts, "   ") or "-", pad, y, 0.8, 0.8, 0.8, 1, UIFont.Small)

    if self.presetLabelY then
        self:drawText("Presets:", pad, self.presetLabelY, 1, 1, 1, 1, UIFont.Small)
    end

    if self.status and self.statusUntil and getTimestampMs() < self.statusUntil then
        self:drawTextCentre(self.status, self.width / 2, self.height - 4 * FONT_SCALE - FONT_HGT_SMALL, 1, 0.9, 0.5, 1, UIFont.Small)
    end
end

function ServerPointsAdminPanel:close()
    Events.OnServerCommand.Remove(onServerCommand)
    Events.OnGetDBSchema.Remove(onDBSchema)
    Events.OnGetTableResult.Remove(onTableResult)
    self:setVisible(false)
    self:removeFromUIManager()
    ServerPointsAdminPanel.instance = nil
end

function ServerPointsAdminPanel:new(x, y, width, height)
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.borderColor = { r = 0.4, g = 0.4, b = 0.4, a = 1 }
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0.85 }
    o.moveWithMouse = true
    o.pointTypes = {}
    o.presets = {}
    o.knownSet = {}
    o.accounts = {}
    o.balances = {}
    o.typeIds = {}
    ServerPointsAdminPanel.instance = o
    return o
end

local function openUI()
    if ServerPointsAdminPanel.instance then
        ServerPointsAdminPanel.instance:close()
    end
    local core = getCore()
    local width = 320 * FONT_SCALE
    local height = 520 * FONT_SCALE
    local ui = ServerPointsAdminPanel:new((core:getScreenWidth() - width) / 2, (core:getScreenHeight() - height) / 2, width, height)
    ui:initialise()
    ui:addToUIManager()
end

local oldISAdminPanelUI_create = ISAdminPanelUI.create
function ISAdminPanelUI:create()
    oldISAdminPanelUI_create(self)
    if getAccessLevel() == "admin" then
        local lastButton = self.children[self.IDMax - 1].internal == "CANCEL" and self.children[self.IDMax - 2] or self.children[self.IDMax - 1]
        self.serverPointsBtn = ISButton:new(lastButton.x, lastButton.y + 5 + lastButton.height, self.sandboxOptionsBtn.width, self.sandboxOptionsBtn.height, "Server Points", nil, openUI)
        self.serverPointsBtn.internal = "SERVERPOINTS"
        self.serverPointsBtn:initialise()
        self.serverPointsBtn:instantiate()
        self.serverPointsBtn.borderColor = self.buttonBorderColor
        self:addChild(self.serverPointsBtn)
    end
end
