local Theme = require("ElyonLib/UI/Theme/Theme")
local Core = require("DL_Dice2026/DiceCore")
local DicePanelBase = require("DL_Dice2026/UI/DicePanelBase")

local T = Theme.colors

local DiceCombat = DicePanelBase:derive("DiceCombat")

local BTN_H = 18
local PAD = 4

function DiceCombat:buttonHeight()
	return math.max(self:S(BTN_H), self.fontHgt + self:S(4))
end

function DiceCombat:addButton(label, callback, variant)
	local b = ISButton:new(0, 0, self:S(120), self:buttonHeight(), label, self, callback)
	b:initialise()
	b.font = self.font
	Theme.applyButtonStyle(b, variant)
	self:addChild(b)
	self:registerControl(b)
	return b
end

function DiceCombat:createChildren()
	DicePanelBase.createChildren(self)

	self.rollInitButton = self:addButton("Roll initiative", DiceCombat.onRollInit, "primary")
	self.rollInitButton:setTooltip("Creates a combat here, or joins one forming within 30 tiles")
	self.readyButton = self:addButton("Ready up", DiceCombat.onReady, "success")
	self.finishButton = self:addButton("Finish turn", DiceCombat.onFinish, "primary")
	self.surrenderButton = self:addButton("Surrender", DiceCombat.onSurrender, "warning")
	self.leaveButton = self:addButton("Leave combat", DiceCombat.onLeave, "danger")

	self.moveRangeButton = self:addButton("Move range", DiceCombat.onMoveRange, nil)
	self.gunRangeButton = self:addButton("Gun range", DiceCombat.onGunRange, nil)
	self.coverButton = self:addButton("In cover", DiceCombat.onCover, nil)
	self.armorButton = self:addButton("Armored", DiceCombat.onArmor, nil)

	self:refreshButtons()
end

function DiceCombat:onRollInit()
	Core.rollInitiative()
end

function DiceCombat:onReady()
	local me = Core.me()
	Core.setReady(me.status ~= "ready")
end

function DiceCombat:onFinish()
	Core.finishTurn()
end

function DiceCombat:onSurrender()
	local me = Core.me()
	Core.setSurrender(me.status ~= "surrendered")
end

function DiceCombat:onLeave()
	Core.leaveCombat()
end

function DiceCombat:onMoveRange()
	Core.toggleMoveRange()
end

function DiceCombat:onGunRange()
	Core.toggleGunRange()
end

function DiceCombat:onCover()
	local me = Core.me()
	Core.setCover(not me.inCover)
end

function DiceCombat:onArmor()
	local me = Core.me()
	Core.setArmor(not me.armored)
end

local function styleToggle(button, active)
	if active then
		button.backgroundColor = Theme.copy(T.primary)
		button.backgroundColorMouseOver = Theme.copy(T.primaryHover)
	else
		button.backgroundColor = Theme.copy(T.buttonBg)
		button.backgroundColorMouseOver = Theme.copy(T.buttonHover)
	end
end

function DiceCombat:refreshButtons()
	local s = Core.state
	local me = Core.me()
	local pad = self:S(PAD)
	local btnH = self:buttonHeight()
	local colW = math.floor((self.width - pad * 3) / 2)

	local participant = Core.isParticipant()
	local inCombat = s.combatId ~= nil
	local surrendered = me.status == "surrendered"

	self.rollInitButton:setVisible(not inCombat or (s.spectating and s.phase == "forming"))
	self.readyButton:setVisible(participant and s.phase == "forming" and me.status ~= "ko" and not surrendered)
	self.readyButton:setTitle(me.status == "ready" and "Unready" or "Ready up")
	self.finishButton:setVisible(Core.isMyTurn())
	self.surrenderButton:setVisible(participant and me.status ~= "ko")
	self.surrenderButton:setTitle(surrendered and "Withdraw surrender" or "Surrender")
	self.leaveButton:setVisible(participant)

	styleToggle(self.moveRangeButton, s.showMoveRange)
	styleToggle(self.gunRangeButton, s.showGunRange)
	styleToggle(self.coverButton, me.inCover)
	styleToggle(self.armorButton, me.armored)
	self.coverButton:setTitle(me.inCover and "In cover" or "No cover")
	self.armorButton:setTitle(me.armored and "Armored" or "No armor")

	local flow = {}
	local phaseButtons = { self.rollInitButton, self.readyButton, self.finishButton, self.surrenderButton, self.leaveButton }
	for i = 1, #phaseButtons do
		if phaseButtons[i]:getIsVisible() then
			flow[#flow + 1] = { phaseButtons[i] }
		end
	end

	local toggleFlow = {
		{ self.moveRangeButton, self.gunRangeButton },
		{ self.coverButton, self.armorButton },
	}

	local function placeRow(row, y)
		if #row == 1 then
			row[1]:setX(pad)
			row[1]:setY(y)
			row[1]:setWidth(self.width - pad * 2)
		else
			row[1]:setX(pad)
			row[1]:setY(y)
			row[1]:setWidth(colW)
			row[2]:setX(pad * 2 + colW)
			row[2]:setY(y)
			row[2]:setWidth(colW)
		end
		return y + btnH + pad
	end

	local y = self.headerH + pad
	self.noticeY = nil
	if s.spectating then
		self.noticeY = y
		y = y + self.fontHgt + pad
	end
	for i = 1, #flow do
		y = placeRow(flow[i], y)
	end

	self.dividerY = y + self:S(2)
	y = y + self.fontHgt + self:S(4)

	for i = 1, #toggleFlow do
		y = placeRow(toggleFlow[i], y)
	end

	self.fullH = y + pad
	if not self.collapsed then
		self:setHeight(self.fullH)
	end

	local paused = s.paused
	for i = 1, #self.contentControls do
		local control = self.contentControls[i].control
		if control.enable ~= nil then
			control.enable = not paused
		end
	end

	self:applyOpacity()
end

function DiceCombat:render()
	if self.collapsed then
		return
	end
	local pad = self:S(PAD)
	local textA = self:textAlpha()
	local opacity = Core.settings.opacity

	if self.noticeY then
		self:drawText("Spectating - combat in progress", pad, self.noticeY, T.warning.r, T.warning.g, T.warning.b, textA, self.font)
	end

	if (Core.errorTicks or 0) > 0 and Core.errorText then
		self:drawText(Core.errorText, pad, self.height + Core.px(2), T.danger.r, T.danger.g, T.danger.b, 1, self.font)
	end

	if self.dividerY then
		local label = "Toggles"
		local labelW = getTextManager():MeasureStringX(self.font, label)
		local lineY = self.dividerY + math.floor(self.fontHgt / 2)
		self:drawText(label, pad, self.dividerY - self:S(2), T.textDim.r, T.textDim.g, T.textDim.b, textA * 0.9, self.font)
		self:drawRect(pad + labelW + self:S(5), lineY, self.width - pad * 2 - labelW - self:S(5), 1, T.borderDim.a * opacity, T.borderDim.r, T.borderDim.g, T.borderDim.b)
	end
end

function DiceCombat:setCollapsed(collapsed)
	DicePanelBase.setCollapsed(self, collapsed)
	if not self.collapsed then
		self:refreshButtons()
	end
end

function DiceCombat:onCoreEvent(event)
	if event == "state" or event == "opacity" then
		self:refreshButtons()
	end
end

function DiceCombat:new()
	local s = Core.panelScale("combat")
	local width = Core.px(190 * s)
	local o = DicePanelBase.new(self, "combat", "Combat", width, Core.px(140 * s), { xf = 0.815, yf = 0.78, visible = false })
	return o
end

return DiceCombat
