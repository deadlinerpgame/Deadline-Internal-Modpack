local Theme = require("ElyonLib/UI/Theme/Theme")
local Core = require("DL_Dice2026/DiceCore")
local DicePanelBase = require("DL_Dice2026/UI/DicePanelBase")

local T = Theme.colors

local DiceRolls = DicePanelBase:derive("DiceRolls")

local BTN_H = 18
local PAD = 4

function DiceRolls:createChildren()
	DicePanelBase.createChildren(self)

	local pad = self:S(PAD)
	local btnH = math.max(self:S(BTN_H), self.fontHgt + self:S(4))
	local colW = math.floor((self.width - pad * 3) / 2)
	local y = self.headerH + pad

	self.rollButtons = {}
	local defs = Core.ROLLS
	local col = 0
	for i = 1, #defs do
		local def = defs[i]
		local x = pad + col * (colW + pad)
		local b = ISButton:new(x, y, colW, btnH, def.label, self, DiceRolls.onRoll)
		b:initialise()
		b.font = self.font
		b.rollId = def.id
		Theme.applyButtonStyle(b, nil)
		b:setTooltip(def.tip or (def.label .. " (d" .. Core.DICE_SIDES .. ")"))
		self:addChild(b)
		self:registerControl(b)
		self.rollButtons[#self.rollButtons + 1] = b
		col = col + 1
		if col >= 2 then
			col = 0
			y = y + btnH + pad
		end
	end
	if col ~= 0 then
		y = y + btnH + pad
	end

	self.dividerY = y + self:S(2)
	y = y + self.fontHgt + self:S(4)

	self.advButton = ISButton:new(pad, y, colW, btnH, "Advantage", self, DiceRolls.onAdvantage)
	self.disButton = ISButton:new(pad * 2 + colW, y, colW, btnH, "Disadvantage", self, DiceRolls.onDisadvantage)
	local mods = { self.advButton, self.disButton }
	for i = 1, #mods do
		mods[i]:initialise()
		mods[i].font = self.font
		Theme.applyButtonStyle(mods[i], nil)
		mods[i]:setTooltip("Applies to your next roll only, then resets")
		self:addChild(mods[i])
		self:registerControl(mods[i])
	end
	y = y + btnH + pad

	self.dwdButton = ISButton:new(pad, y, self.width - pad * 2, btnH, "Dice with Death (d6)", self, DiceRolls.onDiceWithDeath)
	self.dwdButton:initialise()
	self.dwdButton.font = self.font
	Theme.applyButtonStyle(self.dwdButton, "danger")
	self.dwdButton:setTooltip("1-2: dead | 3-4: needs First Aid 6+ within 60 min | 5-6: unconscious")
	self:addChild(self.dwdButton)
	self:registerControl(self.dwdButton)
	y = y + btnH + pad

	self.fullH = y + pad
	self:setHeight(self.fullH)
	self:refreshButtons()
end

function DiceRolls:onDiceWithDeath()
	Core.diceWithDeath()
end

function DiceRolls:render()
	if self.collapsed or not self.dividerY then
		return
	end
	local pad = self:S(PAD)
	local textA = self:textAlpha()
	local opacity = Core.settings.opacity
	local label = "Toggles - next roll only"
	local labelW = getTextManager():MeasureStringX(self.font, label)
	local lineY = self.dividerY + math.floor(self.fontHgt / 2)
	self:drawText(label, pad, self.dividerY - self:S(2), T.textDim.r, T.textDim.g, T.textDim.b, textA * 0.9, self.font)
	self:drawRect(pad + labelW + self:S(5), lineY, self.width - pad * 2 - labelW - self:S(5), 1, T.borderDim.a * opacity, T.borderDim.r, T.borderDim.g, T.borderDim.b)
end

function DiceRolls:onAdvantage()
	Core.setAdvantage(1)
end

function DiceRolls:onDisadvantage()
	Core.setAdvantage(-1)
end

function DiceRolls:onRoll(button)
	if button and button.rollId then
		Core.roll(button.rollId)
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

function DiceRolls:refreshButtons()
	local adv = Core.state.advantage
	local paused = Core.state.paused
	styleToggle(self.advButton, adv == 1)
	styleToggle(self.disButton, adv == -1)
	self.advButton.enable = not paused
	self.disButton.enable = not paused
	self.dwdButton.enable = not paused

	for i = 1, #self.rollButtons do
		local b = self.rollButtons[i]
		local def = Core.getRollDef(b.rollId)
		b.enable = Core.canRoll(def)
		if b.rollId == "attack" then
			local target = Core.findCombatant(Core.state.selectedTargetId)
			b:setTitle(target and ("Attack: " .. target.name) or "Attack / Throw")
		end
	end
	self:applyOpacity()
	for i = 1, #self.rollButtons do
		local b = self.rollButtons[i]
		if not b.enable and b.textColor then
			b.textColor.a = 0.35
		end
	end
end

function DiceRolls:onCoreEvent(event)
	if event == "state" or event == "opacity" then
		self:refreshButtons()
	end
end

function DiceRolls:new()
	local s = Core.panelScale("diceRolls")
	local width = Core.px(230 * s)
	local o = DicePanelBase.new(self, "diceRolls", "Dice rolls", width, Core.px(160 * s), { xf = 0.69, yf = 0.62, visible = false })
	return o
end

return DiceRolls
