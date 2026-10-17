require "ISUI/ISCollapsableWindow"
require "ISUI/ISButton"
require "ISUI/ISScrollingListBox"
require "ISUI/ISComboBox"
require "TimedActions/ISTimedActionQueue"

local Theme  = require("ElyonLib/UI/Theme/Theme")
local Layout = require("ElyonLib/UI/Layout/LayoutUtils")

DL = DL or {}
DL_CrucibleUI = ISCollapsableWindow:derive("DL_CrucibleUI")

local FONT  = UIFont.Small
local FH    = getTextManager():getFontHeight(FONT)
local PAD   = 10
local ROW_H = FH + 8
local C     = Theme.colors

local function box(el, x, y, w, h, c)       el:drawRect(x, y, w, h, c.a, c.r, c.g, c.b) end
local function boxBorder(el, x, y, w, h, c) el:drawRectBorder(x, y, w, h, c.a, c.r, c.g, c.b) end
local function txt(el, s, x, y, c, font)    el:drawText(s, x, y, c.r, c.g, c.b, c.a, font or FONT) end
local function strW(s)                       return getTextManager():MeasureStringX(FONT, s) end
local function tip(btn, text)                if btn and btn.setTooltip then btn:setTooltip(text) end end

local function limitingMetal(comp)
    local best, bt = nil, 0
    for m, u in pairs(comp or {}) do
        local md = DL.Metals[m]
        if md and not md.additive and (u or 0) > 0 then
            local t = DL.MeltTemp[md.tier or 1] or 30
            if t > bt then bt = t; best = md.name end
        end
    end
    return best
end

function DL_CrucibleUI:new(player, wobj)
    local w, h = 720, 430
    local x, y = Layout.centreOnScreen(w, h)
    local o = ISCollapsableWindow:new(x, y, w, h)
    setmetatable(o, self)
    self.__index = self
    o.player = player
    o.wobj   = wobj
    o.item   = wobj:getItem()
    local sq = wobj:getSquare()
    o.sx, o.sy, o.sz = sq:getX(), sq:getY(), sq:getZ()
    o.title = o.item:getDisplayName()
    o.resizable = false
    o:setWantKeyEvents(true)
    return o
end

function DL_CrucibleUI:state()
    return DL.Crucible.peek(DL.CrucibleClient.state(self.wobj)) or DL.Crucible.new()
end

function DL_CrucibleUI:capacity() return DL.Crucible.capacity(self.item) end

function DL_CrucibleUI:send(command, extra) DL.CrucibleClient.send(self.player, self.wobj, command, extra) end

function DL_CrucibleUI:createChildren()
    ISCollapsableWindow.createChildren(self)
    local th   = self:titleBarHeight()
    local colW = math.floor((self.width - PAD * 4) / 3)
    self.col1X, self.col2X, self.col3X = PAD, PAD * 2 + colW, PAD * 3 + colW * 2
    self.colW = colW

    local listY      = th + PAD + FH + 4
    local actionsTop = self.height - PAD - ROW_H
    local addRowY    = actionsTop - 6 - ROW_H
    self.statusTop, self.statusBottom = listY, actionsTop - 6
    local listH      = addRowY - 4 - listY

    self.list = ISScrollingListBox:new(self.col1X, listY, colW, listH)
    self.list:initialise(); self.list:instantiate()
    self.list.itemheight = ROW_H; self.list.font = FONT; self.list.drawBorder = true
    self.list.win = self
    self.list.doDrawItem = DL_CrucibleUI.drawAvailItem
    Theme.applyListStyle(self.list); self:addChild(self.list)

    local bw = (colW - 4) / 2
    self.btnAdd1 = ISButton:new(self.col1X, addRowY, bw, ROW_H, "Add", self, DL_CrucibleUI.onAdd)
    self.btnAdd5 = ISButton:new(self.col1X + bw + 4, addRowY, bw, ROW_H, "Add 5", self, DL_CrucibleUI.onAdd)
    self.btnAdd1.internal = "ADD1"; self.btnAdd5.internal = "ADD5"

    self.fuelList = ISScrollingListBox:new(self.col2X, listY, colW, listH)
    self.fuelList:initialise(); self.fuelList:instantiate()
    self.fuelList.itemheight = ROW_H; self.fuelList.font = FONT; self.fuelList.drawBorder = true
    self.fuelList.win = self
    self.fuelList.doDrawItem = DL_CrucibleUI.drawFuelItem
    Theme.applyListStyle(self.fuelList); self:addChild(self.fuelList)

    local fw = (colW - 8) / 3
    self.btnFuel   = ISButton:new(self.col2X,                addRowY, fw, ROW_H, "Add Fuel",   self, DL_CrucibleUI.onAddFuel)
    self.btnLight  = ISButton:new(self.col2X + fw + 4,       addRowY, fw, ROW_H, "Light",      self, DL_CrucibleUI.onLight)
    self.btnExting = ISButton:new(self.col2X + (fw + 4) * 2, addRowY, fw, ROW_H, "Extinguish", self, DL_CrucibleUI.onExtinguish)

    local n  = 4
    local aw = (self.width - PAD * 2 - (n - 1) * 4) / n
    local function ax(i) return PAD + (aw + 4) * (i - 1) end
    self.btnPour     = ISButton:new(ax(1), actionsTop, aw, ROW_H, "Pour",     self, DL_CrucibleUI.onPour)
    self.btnPourAll  = ISButton:new(ax(2), actionsTop, aw, ROW_H, "Pour All", self, DL_CrucibleUI.onPourAll)
    self.btnRetrieve = ISButton:new(ax(3), actionsTop, aw, ROW_H, "Retrieve", self, DL_CrucibleUI.onRetrieve)

    for _, b in ipairs({ self.btnAdd1, self.btnAdd5, self.btnFuel, self.btnLight, self.btnExting, self.btnPourAll, self.btnRetrieve }) do
        b:initialise(); Theme.applyButtonStyle(b); self:addChild(b)
    end
    self.btnPour:initialise(); Theme.applyButtonStyle(self.btnPour, "primary"); self:addChild(self.btnPour)

    self.moldCombo = ISComboBox:new(ax(4), actionsTop, aw, ROW_H, self, nil)
    self.moldCombo:initialise()
    self.moldCombo:addOption("Ingot Mold")
    Theme.applyComboStyle(self.moldCombo)
    self:addChild(self.moldCombo)

    self:refreshAvailable(); self:refreshFuel()
end

function DL_CrucibleUI:refreshAvailable()
    local items = self.player:getInventory():getItems()
    local agg = {}
    for i = 0, items:size() - 1 do
        local it  = items:get(i)
        local reg = DL.MetalContent[it:getFullType()]
        if reg then
            local e = agg[it:getFullType()]
            if not e then e = { fullType = it:getFullType(), name = it:getName(), count = 0, units = reg.units }; agg[it:getFullType()] = e end
            e.count = e.count + 1
        end
    end
    local prev = self.list.items[self.list.selected] and self.list.items[self.list.selected].item.fullType
    self.list:clear()
    local keys = {}
    for ft in pairs(agg) do keys[#keys + 1] = ft end
    table.sort(keys, function(a, b) return agg[a].name < agg[b].name end)
    for idx, ft in ipairs(keys) do
        self.list:addItem(agg[ft].name, agg[ft])
        if ft == prev then self.list.selected = idx end
    end
end

function DL_CrucibleUI:refreshFuel()
    local counts, items = {}, self.player:getInventory():getItems()
    for i = 0, items:size() - 1 do
        local it = items:get(i)
        local ft = it:getFullType()
        if DL.Fuel[ft] then
            local add = 1
            if instanceof(it, "DrainableComboItem") then add = math.max(1, it:getDrainableUsesInt()) end
            counts[ft] = (counts[ft] or 0) + add
        end
    end
    local prev = self.fuelList.items[self.fuelList.selected] and self.fuelList.items[self.fuelList.selected].item.type
    self.fuelList:clear()
    for idx, f in ipairs(DL.FuelList) do
        self.fuelList:addItem(f.name, { type = f.type, name = f.name, maxTemp = f.maxTemp, count = counts[f.type] or 0 })
        if f.type == prev then self.fuelList.selected = idx end
    end
end

function DL_CrucibleUI.drawAvailItem(list, y, item, alt)
    local data = item.item
    local sel  = list.items[list.selected] and list.items[list.selected].item.fullType == data.fullType
    if sel then box(list, 0, y, list:getWidth(), list.itemheight, C.selected)
    elseif alt then box(list, 0, y, list:getWidth(), list.itemheight, C.listAlt) end
    local ty = y + (list.itemheight - FH) / 2
    txt(list, data.name, 6, ty, C.text)
    local r = string.format("x%d  (%.2f)", data.count, data.units)
    txt(list, r, list:getWidth() - strW(r) - 6, ty, C.textMuted)
    return y + list.itemheight
end

function DL_CrucibleUI.drawFuelItem(list, y, item, alt)
    local data = item.item
    local has  = (data.count or 0) > 0
    local sel  = list.items[list.selected] and list.items[list.selected].item.type == data.type
    if sel and has then box(list, 0, y, list:getWidth(), list.itemheight, C.selected)
    elseif alt then box(list, 0, y, list:getWidth(), list.itemheight, C.listAlt) end
    local ty = y + (list.itemheight - FH) / 2
    txt(list, data.name, 6, ty, has and C.text or C.disabled)
    local r = "x" .. tostring(data.count or 0)
    txt(list, r, list:getWidth() - strW(r) - 6, ty, has and C.textMuted or C.disabled)
    return y + list.itemheight
end

function DL_CrucibleUI:selectedData()
    local sel = self.list.items[self.list.selected]
    return sel and sel.item
end
function DL_CrucibleUI:selectedFuel()
    local sel = self.fuelList.items[self.fuelList.selected]
    return sel and sel.item
end

function DL_CrucibleUI:onAdd(button)
    local st = self:state(); if st.phase ~= "loading" then return end
    local data = self:selectedData(); if not data then return end
    local reg = DL.MetalContent[data.fullType]; if not reg then return end
    local room = self:capacity() - (st.solidUnits or 0)
    local maxByCap = math.floor(room / reg.units + 1e-9)
    if maxByCap < 1 then return end
    local n = (button.internal == "ADD5") and 5 or 1
    if n > maxByCap then n = maxByCap end
    local inv = self.player:getInventory()
    local items, toRemove = inv:getItems(), {}
    for i = 0, items:size() - 1 do
        local it = items:get(i)
        if #toRemove < n and it:getFullType() == data.fullType then toRemove[#toRemove + 1] = it end
    end
    if #toRemove == 0 then return end
    for _, it in ipairs(toRemove) do inv:Remove(it) end
    self:send("AddScrap", { fullType = data.fullType, count = #toRemove })
    self:refreshAvailable()
end

function DL_CrucibleUI:onAddFuel()
    local st = self:state()
    if (st.fuelMin or 0) >= (DL.FUEL_CAP or 60) then return end
    local data = self:selectedFuel(); if not data or (data.count or 0) <= 0 then return end
    local inv = self.player:getInventory()
    local items, rem = inv:getItems(), nil
    for i = 0, items:size() - 1 do
        local it = items:get(i)
        if it:getFullType() == data.type then rem = it; break end
    end
    if not rem then return end
    if instanceof(rem, "DrainableComboItem") then rem:Use() else inv:Remove(rem) end
    self:send("AddFuel", { fullType = data.type })
    self:refreshFuel()
end

function DL_CrucibleUI:onLight()
    luautils.walkAdj(self.player, self.wobj:getSquare(), true)
    ISTimedActionQueue.add(ISDLLightCrucible:new(self.player, self.wobj))
end

function DL_CrucibleUI:onPour()
    luautils.walkAdj(self.player, self.wobj:getSquare(), true)
    ISTimedActionQueue.add(ISDLPourCrucible:new(self.player, self.wobj))
end

function DL_CrucibleUI:onPourAll()
    local st = self:state(); if st.phase ~= "molten" or not st.alloy then return end
    local count = math.floor((st.alloy.units or 0) + 1e-6)
    luautils.walkAdj(self.player, self.wobj:getSquare(), true)
    for _ = 1, count do ISTimedActionQueue.add(ISDLPourCrucible:new(self.player, self.wobj)) end
end

function DL_CrucibleUI:onRetrieve()
    local st = self:state(); if st.phase ~= "loading" or (st.solidUnits or 0) <= 0 then return end
    self:send("Retrieve")
end

function DL_CrucibleUI:onExtinguish()
    self:send("Extinguish")
end

function DL_CrucibleUI:update()
    ISCollapsableWindow.update(self)
    if not DL.CrucibleClient.isPlaced(self.wobj) or math.floor(self.player:getZ()) ~= self.sz
       or self.player:DistToSquared(self.sx + 0.5, self.sy + 0.5) > 9 then
        self:close(); return
    end
    local st = self:state()

    local now = getTimestampMs()
    if (not DL.CrucibleClient.state(self.wobj) or st.meltPending)
       and (not self.syncSent or now - self.syncSent > 2000) then
        self.syncSent = now
        self:send("Sync")
    end

    if st.phase ~= self.lastPhase then
        if self.lastPhase and st.phase == "molten" and st.alloy then
            local a = st.alloy
            local note = a.gated and ("Metalworking " .. tostring(a.gateLevel or 10) .. " needed for that alloy")
                or (tostring(a.name or "Metal") .. " is molten")
            if self.player then self.player:setHaloNote(note) end
        end
        self.lastPhase = st.phase
    end

    self.tickN = (self.tickN or 0) + 1
    if self.tickN % 30 == 0 then self:refreshAvailable(); self:refreshFuel() end

    local phase = st.phase or "loading"
    local fuel  = self:selectedFuel()

    local addReason
    if phase == "slug" then addReason = "Crucible holds a solid slug"
    elseif phase ~= "loading" then addReason = "Crucible is molten"
    elseif (st.solidUnits or 0) >= self:capacity() - 1e-9 then addReason = "Crucible is full" end
    self.btnAdd1.enable = addReason == nil; self.btnAdd5.enable = addReason == nil
    tip(self.btnAdd1, addReason); tip(self.btnAdd5, addReason)

    local fuelReason
    if (st.fuelMin or 0) >= (DL.FUEL_CAP or 60) then fuelReason = "Fuel is full"
    elseif not fuel or (fuel.count or 0) <= 0 then fuelReason = "Select a fuel you carry" end
    self.btnFuel.enable = fuelReason == nil
    tip(self.btnFuel, fuelReason)

    local lightReason
    if st.lit then lightReason = "Already lit"
    elseif (st.fuelMin or 0) <= 0 then lightReason = "No fuel loaded"
    elseif not DL.Crucible.hasFireSource(self.player) then lightReason = "Need a lighter or matches"
    elseif not DL.Crucible.findKindling(self.player) then lightReason = "Need kindling (twigs or a branch)" end
    self.btnLight.enable = lightReason == nil
    tip(self.btnLight, lightReason)

    self.btnExting.enable = st.lit == true
    tip(self.btnExting, st.lit and nil or "Not lit")

    local pourReason
    if phase ~= "molten" then pourReason = "Not molten yet"
    elseif not st.alloy or (st.alloy.units or 0) < 1 then pourReason = "Less than one unit"
    elseif not DL.Crucible.findIngotMold(self.player) then pourReason = "Need an ingot mold" end
    self.btnPour.enable = pourReason == nil; self.btnPourAll.enable = pourReason == nil
    tip(self.btnPour, pourReason); tip(self.btnPourAll, pourReason)

    local retReason
    if phase == "slug" then retReason = "Solid slugs can't be removed"
    elseif phase ~= "loading" then retReason = "Molten metal can't be removed"
    elseif (st.solidUnits or 0) <= 0 then retReason = "Nothing to retrieve" end
    self.btnRetrieve.enable = retReason == nil
    tip(self.btnRetrieve, retReason)
end

function DL_CrucibleUI:prerender()
    ISCollapsableWindow.prerender(self)
    local th = self:titleBarHeight()
    local st = self:state(); if not st then return end

    txt(self, "Materials", self.col1X, th + PAD, C.textMuted)
    txt(self, "Fuel", self.col2X, th + PAD, C.textMuted)
    txt(self, "Crucible", self.col3X, th + PAD, C.textMuted)

    box(self, self.col3X, self.statusTop, self.colW, self.statusBottom - self.statusTop, C.panelDark)
    boxBorder(self, self.col3X, self.statusTop, self.colW, self.statusBottom - self.statusTop, C.borderDim)
    local x, y, w = self.col3X + 8, self.statusTop + 8, self.colW - 16

    local temp = st.temp or 0
    txt(self, string.format("Temp %d/100 %s", math.floor(temp), st.lit and "(lit)" or ""), x, y, st.lit and C.warning or C.text)
    y = y + FH + 2
    box(self, x, y, w, 8, C.background)
    box(self, x, y, w * math.min(temp / 100, 1), 8, C.danger)
    local target = (st.phase == "loading") and DL.requiredTemp(st.comp) or (st.alloy and st.alloy.reTemp)
    if target and target > 0 then box(self, x + w * (target / 100) - 1, y - 2, 2, 12, C.focus) end
    y = y + 16

    local phase = st.phase or "loading"

    if (phase == "loading" or phase == "slug") and target and target > 0 then
        local cTgt    = (phase == "loading") and st.comp or (st.alloy and st.alloy.composition)
        local ceil    = st.fuelMaxTemp or 0
        local hasFuel = st.lit or (st.fuelMin or 0) > 0
        if hasFuel and ceil < target then
            txt(self, "Fire too weak for " .. tostring(limitingMetal(cTgt) or "this"), x, y, C.danger)
        elseif (st.temp or 0) < target then
            if st.lit and (st.fuelMin or 0) > 0 then
                txt(self, string.format("Needs %d, ~%d min", target, math.ceil((target - (st.temp or 0)) / DL.HEAT_RATE)), x, y, C.textMuted)
            else
                txt(self, "Needs " .. target, x, y, C.textDim)
            end
        elseif phase == "loading" and (st.solidUnits or 0) < 1.0 - 1e-9 then
            txt(self, "Hot enough. Add up to 1 unit to cast.", x, y, C.warning)
        else
            txt(self, "At temperature", x, y, C.success)
        end
        y = y + FH + 4
    end

    if phase == "loading" then
        txt(self, string.format("Unit %.2f / %d", st.solidUnits or 0, self:capacity()), x, y, C.textMuted); y = y + FH + 4
        if (st.solidUnits or 0) <= 0 then
            txt(self, "Empty. Add materials and fuel, then light.", x, y, C.textDim); y = y + FH + 2
        else
            local arr, tot = {}, st.solidUnits or 0
            for m, u in pairs(st.comp) do arr[#arr + 1] = { m = m, u = u } end
            table.sort(arr, function(a, b) return a.u > b.u end)
            for _, e in ipairs(arr) do
                local nm = (DL.Metals[e.m] and DL.Metals[e.m].name) or e.m
                txt(self, nm, x, y, C.text)
                local s = string.format("%d%%  %.2f", math.floor((tot > 0 and e.u / tot or 0) * 100 + 0.5), e.u)
                txt(self, s, x + w - strW(s), y, C.textMuted)
                y = y + FH + 2
            end
        end
    elseif phase == "molten" then
        txt(self, "Molten: " .. tostring(st.alloy and st.alloy.name or "?"), x, y, C.success); y = y + FH + 2
        local q  = math.floor((st.alloy and st.alloy.quality or 0) + 0.5)
        local mq = math.floor((st.alloy and st.alloy.maxQuality or q) + 0.5)
        local refining = (q < mq) and st.lit
        txt(self, string.format("Quality %d / %d%s   Ingots ready: %d", q, mq, refining and " (refining)" or "",
            math.floor((st.alloy and st.alloy.units or 0) + 1e-6)), x, y, C.textMuted)
        if st.alloy and st.alloy.gated then
            txt(self, "Metalworking " .. tostring(st.alloy.gateLevel or 10) .. " needed for the alloy", x, y + FH + 2, C.danger)
        end
    elseif phase == "slug" then
        txt(self, "Slug: " .. tostring(st.alloy and st.alloy.name or "?"), x, y, C.warning); y = y + FH + 2
        txt(self, "Reheat to melt.", x, y, C.textDim)
    end

    txt(self, "Metalworking " .. tostring(DL.MW.getLevel(self.player)),
        x, self.statusBottom - 8 - (FH + 2) * 2, C.accent)
    txt(self, string.format("Fuel %d/%d min, max %d", math.floor(st.fuelMin or 0), DL.FUEL_CAP or 60, math.floor(st.fuelMaxTemp or 0)),
        x, self.statusBottom - 8 - FH, C.textMuted)
end

function DL_CrucibleUI:onKeyRelease(key)
    if key == Keyboard.KEY_ESCAPE then self:close() end
end

function DL_CrucibleUI:close()
    self:setVisible(false)
    self:removeFromUIManager()
    DL_CrucibleUI.instance = nil
end

function DL.openCrucible(player, wobj)
    player = player or getPlayer()
    if not wobj or not DL.CrucibleClient.isPlaced(wobj) then return end
    luautils.walkAdj(player, wobj:getSquare())
    ISTimedActionQueue.add(ISDLOpenCrucible:new(player, wobj))
end

function DL.showCrucibleUI(player, wobj)
    if not wobj or not DL.CrucibleClient.isPlaced(wobj) then return end
    if DL_CrucibleUI.instance then DL_CrucibleUI.instance:close() end
    local ui = DL_CrucibleUI:new(player, wobj)
    ui:initialise()
    ui:addToUIManager()
    DL_CrucibleUI.instance = ui
    ui.syncSent = getTimestampMs()
    ui:send("Sync")
    return ui
end
