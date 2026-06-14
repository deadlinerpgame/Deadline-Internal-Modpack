require("ISUI/ISContextMenu")
require("ISUI/ISToolTip")
require("ISUI/ISTextBox")

local Theme = require("ElyonLib/UI/Theme/Theme")
local TextUtils = require("ElyonLib/TextUtils/TextUtils")
local Core = require("DL_Dice2026/DiceCore")
local DicePanelBase = require("DL_Dice2026/UI/DicePanelBase")

local T = Theme.colors

local DiceTurnOrder = DicePanelBase:derive("DiceTurnOrder")

local MAX_ROWS = 12

function DiceTurnOrder:rowHeight()
	return self.fontHgt + Core.px(10)
end

function DiceTurnOrder:hasScroll()
	return #Core.state.combatants > MAX_ROWS
end

function DiceTurnOrder:visibleCount()
	return math.max(1, math.min(#Core.state.combatants, MAX_ROWS))
end

function DiceTurnOrder:maxScrollIndex()
	return math.max(1, #Core.state.combatants - MAX_ROWS + 1)
end

function DiceTurnOrder:recalcHeight()
	self.fullH = self.headerH + Core.px(3) + self:visibleCount() * self:rowHeight() + Core.px(3)
	if not self.collapsed then
		self:setHeight(self.fullH)
	end
	self.scrollIndex = math.min(self.scrollIndex or 1, self:maxScrollIndex())
end

function DiceTurnOrder:onMouseWheel(del)
	if not self:hasScroll() then
		return false
	end
	local step = del > 0 and 1 or -1
	self.scrollIndex = math.max(1, math.min((self.scrollIndex or 1) + step, self:maxScrollIndex()))
	return true
end

function DiceTurnOrder:followCurrent()
	if not self:hasScroll() or Core.state.phase ~= "active" then
		return
	end
	local list = Core.state.combatants
	for i = 1, #list do
		if list[i].id == Core.state.currentId then
			local first = self.scrollIndex or 1
			if i < first then
				self.scrollIndex = i
			elseif i > first + MAX_ROWS - 1 then
				self.scrollIndex = i - MAX_ROWS + 1
			end
			return
		end
	end
end

function DiceTurnOrder:columns(rowW, rowH)
	local pad = Core.px(4)
	local tm = getTextManager()
	local c = {}
	c.pad = pad
	c.dotSize = math.min(self:S(7), rowH - Core.px(4))
	c.iconSize = math.min(self:S(16), rowH - Core.px(4))
	c.stIcon = math.min(self:S(14), rowH - Core.px(6))
	c.dotX = pad
	c.wpnX = c.dotX + c.dotSize + pad
	c.nameX = c.wpnX + c.iconSize + pad
	c.initW = tm:MeasureStringX(self.font, "88") + Core.px(6)
	c.statusCols = self:activeStatusColumns()
	c.statusSlots = math.max(1, math.min(#c.statusCols, 8))
	c.statusStep = c.stIcon + Core.px(2)
	c.statusW = c.statusStep * c.statusSlots
	c.traitStep = c.iconSize + Core.px(2)
	c.traitsW = c.traitStep * 3 + pad
	c.hpW = tm:MeasureStringX(self.font, "88/88") + Core.px(10)
	c.nameW = math.max(Core.px(30), rowW - c.nameX - c.hpW - c.traitsW - c.statusW - c.initW - pad * 3)
	c.hpX = c.nameX + c.nameW + pad
	c.traitsX = c.hpX + c.hpW
	c.statusX = c.traitsX + c.traitsW
	c.initX = c.statusX + c.statusW + pad
	return c
end

local STATUS_DEFS = {
	{ icon = "st_ko", tip = "KO: unconscious - skips turns, cannot roll", has = function(c) return c.status == "ko" end },
	{ icon = "st_surrender", tip = "Surrendered: not a valid target, no actions, must comply", has = function(c) return c.status == "surrendered" end },
}
do
	local staffDefs = Core.STAFF_STATUSES
	for i = 1, #staffDefs do
		local field = staffDefs[i].field
		STATUS_DEFS[#STATUS_DEFS + 1] = {
			icon = staffDefs[i].icon,
			tip = staffDefs[i].tip,
			has = function(c) return c[field] == true end,
		}
	end
	STATUS_DEFS[#STATUS_DEFS + 1] = { icon = "st_cover", tip = "In cover: +2 Defense against ranged attacks", has = function(c) return c.inCover == true end }
	STATUS_DEFS[#STATUS_DEFS + 1] = { icon = "st_armor", tip = "Armored: reduces incoming damage, may penalize escape and sneak rolls", has = function(c) return c.armored == true end }
end

function DiceTurnOrder:activeStatusColumns()
	local cols = {}
	local list = Core.state.combatants
	for d = 1, #STATUS_DEFS do
		local def = STATUS_DEFS[d]
		for i = 1, #list do
			if def.has(list[i]) then
				cols[#cols + 1] = def
				break
			end
		end
	end
	return cols
end

function DiceTurnOrder:renderRow(c, y, rowH, rowW, textA, opacity)
	local col = self:columns(rowW, rowH)

	if c.id == Core.state.currentId and Core.state.phase == "active" then
		self:drawRect(1, y, rowW - 2, rowH, 0.55 * opacity, T.selected.r, T.selected.g, T.selected.b)
	elseif c.status == "ko" then
		self:drawRect(1, y, rowW - 2, rowH, T.dangerPanel.a * opacity, T.dangerPanel.r, T.dangerPanel.g, T.dangerPanel.b)
	end

	if c.id == Core.state.selectedTargetId then
		self:drawRectBorder(1, y, rowW - 2, rowH, textA, T.danger.r, T.danger.g, T.danger.b)
		self:drawRectBorder(2, y + 1, rowW - 4, rowH - 2, textA * 0.6, T.danger.r, T.danger.g, T.danger.b)
	end

	local dimmed = c.status == "ko" or c.status == "surrendered"
	local rowTextA = dimmed and textA * 0.6 or textA
	local midY = y + math.floor((rowH - self.fontHgt) / 2)

	local dotY = y + math.floor((rowH - col.dotSize) / 2)
	local dot = T.textDim
	if c.status == "surrendered" then
		dot = T.text
	elseif c.status == "ready" then
		dot = T.success
	elseif c.status == "ko" then
		dot = T.danger
	elseif Core.state.phase == "active" then
		dot = T.success
	end
	self:drawRect(col.dotX, dotY, col.dotSize, col.dotSize, rowTextA, dot.r, dot.g, dot.b)

	local wpnTex = Core.getIcon("wpn_" .. (c.weapon or "unarmed"))
	if wpnTex then
		local iconY = y + math.floor((rowH - col.iconSize) / 2)
		self:drawTextureScaled(wpnTex, col.wpnX, iconY, col.iconSize, col.iconSize, rowTextA, 1, 1, 1)
	end

	local displayName = c.name or "?"
	local nameAlpha = rowTextA
	if c.online == false and not c.isNpc then
		displayName = displayName .. " (offline)"
		nameAlpha = rowTextA * 0.55
	end
	local name = TextUtils.trimToWidth(self.font, displayName, col.nameW, "..") or ""
	self:drawText(name, col.nameX, midY, T.text.r, T.text.g, T.text.b, nameAlpha, self.font)

	local hpText = tostring(c.hp) .. "/" .. tostring(c.maxHp)
	self:drawText(hpText, col.hpX, y + Core.px(1), T.textMuted.r, T.textMuted.g, T.textMuted.b, rowTextA, self.font)
	local barH = Core.px(3)
	local barY = y + rowH - barH - Core.px(2)
	local frac = c.maxHp > 0 and (c.hp / c.maxHp) or 0
	local barColor = T.success
	if frac <= 0.25 then
		barColor = T.danger
	elseif frac <= 0.5 then
		barColor = T.warning
	end
	self:drawRect(col.hpX, barY, col.hpW - col.pad, barH, 0.35 * opacity, 0, 0, 0)
	self:drawRect(col.hpX, barY, math.floor((col.hpW - col.pad) * frac), barH, rowTextA, barColor.r, barColor.g, barColor.b)

	local iconY = y + math.floor((rowH - col.iconSize) / 2)
	local shown = 0
	if c.traits then
		for i = 1, #c.traits do
			if shown >= 3 then
				break
			end
			local tex = Core.getTraitTexture(c.traits[i])
			if tex then
				self:drawTextureScaled(tex, col.traitsX + shown * col.traitStep, iconY, col.iconSize, col.iconSize, rowTextA, 1, 1, 1)
				shown = shown + 1
			end
		end
	end

	local stY = y + math.floor((rowH - col.stIcon) / 2)
	for slot = 1, math.min(col.statusSlots, #col.statusCols) do
		local def = col.statusCols[slot]
		if def.has(c) then
			local tex = Core.getIcon(def.icon)
			if tex then
				self:drawTextureScaled(tex, col.statusX + (slot - 1) * col.statusStep, stY, col.stIcon, col.stIcon, textA, 1, 1, 1)
			end
		end
	end

	local initText = c.initiative and tostring(c.initiative) or "-"
	self:drawText(initText, col.initX, midY, T.gold.r, T.gold.g, T.gold.b, rowTextA, self.font)
end

function DiceTurnOrder:render()
	if self.collapsed then
		return
	end
	local opacity = Core.settings.opacity
	local textA = self:textAlpha()
	local rowH = self:rowHeight()
	local y = self.headerH + Core.px(3)

	local list = Core.state.combatants
	if #list == 0 then
		self:drawText("No combat in progress", Core.px(8), y + Core.px(4), T.textDim.r, T.textDim.g, T.textDim.b, textA, self.font)
		return
	end

	local scrolling = self:hasScroll()
	local trackW = Core.px(6)
	local rowW = scrolling and (self.width - trackW - Core.px(2)) or self.width

	local first = scrolling and (self.scrollIndex or 1) or 1
	local visible = self:visibleCount()
	local trackY = y
	for i = first, math.min(first + visible - 1, #list) do
		self:renderRow(list[i], y, rowH, rowW, textA, opacity)
		y = y + rowH
	end

	if scrolling then
		local trackH = visible * rowH
		local trackX = self.width - trackW - Core.px(1)
		self:drawRect(trackX, trackY, trackW, trackH, 0.35 * opacity, 0, 0, 0)
		local thumbH = math.max(Core.px(12), math.floor(trackH * visible / #list))
		local maxFirst = self:maxScrollIndex()
		local thumbY = trackY
		if maxFirst > 1 then
			thumbY = trackY + math.floor((trackH - thumbH) * (first - 1) / (maxFirst - 1))
		end
		self:drawRect(trackX, thumbY, trackW, thumbH, textA * 0.8, T.borderLight.r, T.borderLight.g, T.borderLight.b)
	end
end

function DiceTurnOrder:flash()
	self.flashTicks = 120
end

function DiceTurnOrder:prerender()
	DicePanelBase.prerender(self)
	if (self.flashTicks or 0) > 0 then
		self.flashTicks = self.flashTicks - 1
		local pulse = 0.35 + 0.65 * math.abs(math.sin(self.flashTicks / 9))
		local h = self.collapsed and self.headerH or self.height
		self:drawRectBorder(0, 0, self.width, h, pulse, T.gold.r, T.gold.g, T.gold.b)
		self:drawRectBorder(1, 1, self.width - 2, h - 2, pulse * 0.7, T.gold.r, T.gold.g, T.gold.b)
	end
end

function DiceTurnOrder:onMouseDown(x, y)
	DicePanelBase.onMouseDown(self, x, y)
	if self:isOnHeader(y) then
		return true
	end
	local index = self:rowAtY(y)
	local c = index and Core.state.combatants[index] or nil
	if c and Core.isParticipant() and not c.isMe
		and c.status ~= "ko" and c.status ~= "surrendered" then
		Core.selectTarget(c.id)
	end
	return true
end

function DiceTurnOrder:rowAtY(y)
	local listTop = self.headerH + Core.px(3)
	if self.collapsed or y < listTop then
		return nil
	end
	local offset = math.floor((y - listTop) / self:rowHeight())
	local first = self:hasScroll() and (self.scrollIndex or 1) or 1
	local index = first + offset
	if index >= 1 and index <= #Core.state.combatants and offset < self:visibleCount() then
		return index
	end
	return nil
end

------------------------------------------------------------------------------


function DiceTurnOrder:tipAt(x, y)
	local index = self:rowAtY(y)
	local c = index and Core.state.combatants[index] or nil
	if not c then
		return nil
	end
	local rowH = self:rowHeight()
	local scrolling = self:hasScroll()
	local rowW = scrolling and (self.width - Core.px(6) - Core.px(2)) or self.width
	local col = self:columns(rowW, rowH)

	if x >= col.wpnX and x <= col.wpnX + col.iconSize then
		local rule = Core.WEAPON_RULES[c.weapon or "unarmed"]
		return (rule and rule.name or "Weapon") .. " - " .. Core.weaponTip(c)
	end
	if x >= col.statusX and x <= col.statusX + col.statusW then
		local slot = math.floor((x - col.statusX) / col.statusStep) + 1
		local def = col.statusCols[slot]
		if def and def.has(c) then
			return def.tip
		end
	end
	return nil
end

function DiceTurnOrder:setTip(text)
	if text then
		if not self.tooltipUI then
			self.tooltipUI = ISToolTip:new()
			self.tooltipUI:setOwner(self)
			self.tooltipUI:setAlwaysOnTop(true)
			self.tooltipUI:setVisible(false)
		end
		if not self.tooltipUI:getIsVisible() then
			self.tooltipUI:addToUIManager()
			self.tooltipUI:setVisible(true)
		end
		self.tooltipUI.description = text
		self.tooltipUI:setDesiredPosition(getMouseX() + 20, getMouseY() + 20)
	elseif self.tooltipUI and self.tooltipUI:getIsVisible() then
		self.tooltipUI:setVisible(false)
		self.tooltipUI:removeFromUIManager()
	end
end

function DiceTurnOrder:onMouseMove(dx, dy)
	DicePanelBase.onMouseMove(self, dx, dy)
	if self.dragging then
		self:setTip(nil)
		return
	end
	self:setTip(self:tipAt(self:getMouseX(), self:getMouseY()))
end

function DiceTurnOrder:onMouseMoveOutside(dx, dy)
	DicePanelBase.onMouseMoveOutside(self, dx, dy)
	self:setTip(nil)
end

function DiceTurnOrder:removeFromUIManager()
	self:setTip(nil)
	DicePanelBase.removeFromUIManager(self)
end

------------------------------------------------------------------------------

function DiceTurnOrder:onRightMouseUp(x, y)
	if not Core.isStaff() then
		return false
	end
	local index = self:rowAtY(y)
	local c = index and Core.state.combatants[index] or nil
	if not c then
		return false
	end

	local context = ISContextMenu.get(0, self:getAbsoluteX() + x, self:getAbsoluteY() + y)
	if not context then
		return false
	end

	local header = context:addOption(c.name .. " (staff)", nil, nil)
	header.notAvailable = true

	if Core.state.phase == "active" and Core.state.currentId == c.id then
		if c.isNpc then
			context:addOption("Finish turn", nil, Core.adminFinishNpcTurn)
		else
			context:addOption("Skip turn", nil, Core.staffSkipTurn)
		end
	end

	if c.isNpc then
		local rollOption = context:addOption("Roll as " .. c.name, nil, nil)
		local rollMenu = ISContextMenu:getNew(context)
		context:addSubMenu(rollOption, rollMenu)
		local defs = Core.ROLLS
		for i = 1, #defs do
			local rollId = defs[i].id
			if rollId ~= "escape" then
				rollMenu:addOption(defs[i].label, c.id, function(id)
					Core.staffNpcRoll(id, rollId)
				end)
			end
		end

		local stateOption = context:addOption("Set state", nil, nil)
		local stateMenu = ISContextMenu:getNew(context)
		context:addSubMenu(stateOption, stateMenu)
		stateMenu:addOption((c.inCover and "* " or "") .. "Cover", c.id, function(id)
			local target = Core.findCombatant(id)
			Core.staffSetCover(id, not (target and target.inCover))
		end)
		stateMenu:addOption((c.armored and "* " or "") .. "Armored", c.id, function(id)
			local target = Core.findCombatant(id)
			Core.staffSetArmor(id, not (target and target.armored))
		end)
		stateMenu:addOption((c.advantage == 1 and "* " or "") .. "Advantage (next roll)", c.id, function(id)
			Core.staffSetNpcAdvantage(id, 1)
		end)
		stateMenu:addOption((c.advantage == -1 and "* " or "") .. "Disadvantage (next roll)", c.id, function(id)
			Core.staffSetNpcAdvantage(id, -1)
		end)

		local weaponOption = context:addOption("Set weapon", nil, nil)
		local weaponMenu = ISContextMenu:getNew(context)
		context:addSubMenu(weaponOption, weaponMenu)
		local order = Core.WEAPON_ORDER
		for i = 1, #order do
			local class = order[i]
			local rule = Core.WEAPON_RULES[class]
			local mark = c.weapon == class and "* " or ""
			weaponMenu:addOption(mark .. rule.name, c.id, function(id)
				Core.staffSetWeapon(id, class)
			end)
		end

		context:addOption("Dice with Death (d6)", c.id, function(id)
			Core.staffNpcDwd(id)
		end)
	end

	if c.isNpc then
		if Core.state.movingNpcId == c.id then
			context:addOption("Cancel move", nil, function()
				Core.staffCancelMoveNpc()
			end)
		else
			context:addOption("Move NPC (click a tile)", c.id, function(id)
				Core.staffBeginMoveNpc(id)
			end)
		end
	else
		context:addOption((c.showMarker and "Hide" or "Show") .. " tile marker", c.id, function(id)
			Core.staffToggleMarker(id)
		end)
	end

	local initOption = context:addOption("Set initiative", nil, nil)
	local initMenu = ISContextMenu:getNew(context)
	context:addSubMenu(initOption, initMenu)
	initMenu:addOption("Force re-roll", c.id, function(id)
		Core.staffSetInitiative(id, nil)
	end)
	initMenu:addOption("Enter value...", c.id, function(id)
		local target = Core.findCombatant(id)
		local sw = getCore():getScreenWidth()
		local sh = getCore():getScreenHeight()
		local modal = ISTextBox:new((sw - 280) / 2, (sh - 180) / 2, 280, 180,
			"Initiative for " .. (target and target.name or "?") .. ":",
			target and target.initiative and tostring(target.initiative) or "",
			nil, DiceTurnOrder.onInitiativeEntered, 0, id)
		modal:initialise()
		modal:addToUIManager()
		if modal.entry then
			modal.entry:setOnlyNumbers(true)
		end
	end)

	local statusOption = context:addOption("Set status", nil, nil)
	local statusMenu = ISContextMenu:getNew(context)
	context:addSubMenu(statusOption, statusMenu)
	local staffDefs = Core.STAFF_STATUSES
	for i = 1, #staffDefs do
		local field = staffDefs[i].field
		local mark = c[field] and "* " or ""
		statusMenu:addOption(mark .. staffDefs[i].label, c.id, function(id)
			Core.staffToggleStatus(id, field)
		end)
	end

	local hpOption = context:addOption("Adjust HP", nil, nil)
	local hpMenu = ISContextMenu:getNew(context)
	context:addSubMenu(hpOption, hpMenu)
	hpMenu:addOption("+1 HP", c.id, function(id) Core.staffAdjustHP(id, 1) end)
	hpMenu:addOption("-1 HP", c.id, function(id) Core.staffAdjustHP(id, -1) end)
	hpMenu:addOption("+5 HP", c.id, function(id) Core.staffAdjustHP(id, 5) end)
	hpMenu:addOption("-5 HP", c.id, function(id) Core.staffAdjustHP(id, -5) end)
	hpMenu:addOption("Full HP", c.id, function(id)
		local target = Core.findCombatant(id)
		if target then
			Core.staffAdjustHP(id, target.maxHp)
		end
	end)

	if c.status == "ko" then
		context:addOption("Revive", c.id, function(id) Core.staffSetKO(id, false) end)
	else
		context:addOption("Force KO", c.id, function(id) Core.staffSetKO(id, true) end)
	end

	context:addOption("Kick from combat", c.id, function(id) Core.staffKick(id) end)
	return true
end

function DiceTurnOrder.onInitiativeEntered(target, button, id)
	if button.internal == "OK" then
		local text = button.parent.entry:getText()
		if text and text ~= "" then
			Core.staffSetInitiative(id, text)
		end
	end
end

function DiceTurnOrder:onCoreEvent(event)
	if event == "state" then
		if Core.state.phase == "active" and (Core.state.round or 0) > 0 then
			self.title = "Turn order - round " .. Core.state.round
		else
			self.title = "Turn order"
		end
		if Core.state.spectating then
			self.title = self.title .. " (spectating)"
		end
		if Core.state.paused then
			self.title = self.title .. "  [PAUSED]"
		end
		self:recalcHeight()
		self:followCurrent()
	elseif event == "opacity" then
		self:applyOpacity()
	end
end

function DiceTurnOrder:new()
	local s = Core.panelScale("turnOrder")
	local width = Core.px(310 * s)
	local o = DicePanelBase.new(self, "turnOrder", "Turn order", width, Core.px(120 * s), { xf = 0.80, yf = 0.04, visible = false })
	o.headerH = math.max(Core.px(18), o.fontHgt + Core.px(4))
	o.scrollIndex = 1
	return o
end

return DiceTurnOrder
