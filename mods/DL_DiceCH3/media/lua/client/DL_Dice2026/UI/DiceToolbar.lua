local Theme = require("ElyonLib/UI/Theme/Theme")
local Core = require("DL_Dice2026/DiceCore")
local DicePanelBase = require("DL_Dice2026/UI/DicePanelBase")

local T = Theme.colors

local DiceToolbar = DicePanelBase:derive("DiceToolbar")

function DiceToolbar:createChildren()
	DicePanelBase.createChildren(self)
	if self.closeButton then
		self.closeButton:setVisible(false)
	end

	local pad = self:S(3)
	local btnH = math.max(self:S(16), self.fontHgt + self:S(2))
	local y = self.headerH + pad
	local x = pad

	self.toggleDefs = {
		{ label = "Turn", panelId = "turnOrder" },
		{ label = "HP", panelId = "myHp" },
		{ label = "Dice", panelId = "diceRolls" },
		{ label = "Cmbt", panelId = "combat" },
		{ label = "Log", panelId = "rollLog" },
		{ label = "Rules", panelId = "rules" },
	}

	if Core.isLocalAdmin() then
		self.toggleDefs[#self.toggleDefs + 1] = { label = "Adm", panelId = "admin" }
	end

	self.toggleButtons = {}
	for i = 1, #self.toggleDefs do
		local def = self.toggleDefs[i]
		local w = self:S(36)
		local b = ISButton:new(x, y, w, btnH, def.label, self, DiceToolbar.onToggle)
		b:initialise()
		b.font = self.font
		b.panelId = def.panelId
		b:setTooltip("Show/hide " .. def.label)
		Theme.applyButtonStyle(b, nil)
		self:addChild(b)
		self:registerControl(b)
		self.toggleButtons[#self.toggleButtons + 1] = b
		x = x + w + pad
	end

	self.opacityButton = ISButton:new(x, y, self:S(40), btnH, Core.opacityLabel(), self, DiceToolbar.onOpacity)
	self.opacityButton:initialise()
	self.opacityButton.font = self.font
	self.opacityButton:setTooltip("Cycle UI opacity (20/50/75/100%)")
	Theme.applyButtonStyle(self.opacityButton, nil)
	self:addChild(self.opacityButton)
	self:registerControl(self.opacityButton)
	x = x + self:S(40) + pad

	self:setWidth(x)
	self.fullH = y + btnH + pad
	self:setHeight(self.fullH)
	self:repositionHeaderButtons()
	self:refreshButtons()
end

function DiceToolbar:onToggle(button)
	local panel = self.getPanelById and self.getPanelById(button.panelId) or nil
	if panel then
		panel:setPanelVisible(not panel:getIsVisible())
	end
end

function DiceToolbar:onOpacity()
	Core.cycleOpacity()
	if self.opacityButton then
		self.opacityButton:setTitle(Core.opacityLabel())
	end
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

function DiceToolbar:refreshButtons()
	for i = 1, #self.toggleButtons do
		local b = self.toggleButtons[i]
		local panel = self.getPanelById and self.getPanelById(b.panelId) or nil
		styleToggle(b, panel ~= nil and panel:getIsVisible())
	end
	self:applyOpacity()
end

function DiceToolbar:onCoreEvent(event)
	if event == "ui" or event == "opacity" then
		self:refreshButtons()
		if self.opacityButton then
			self.opacityButton:setTitle(Core.opacityLabel())
		end
	end
end

function DiceToolbar:new()
	local s = Core.panelScale("toolbar")
	local o = DicePanelBase.new(self, "toolbar", "Dice 2026", Core.px(280 * s), Core.px(40 * s), { xf = 0.78, yf = 0.005, visible = true })
	return o
end

return DiceToolbar
