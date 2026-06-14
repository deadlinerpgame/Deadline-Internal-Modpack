local Theme = require("ElyonLib/UI/Theme/Theme")
local Core = require("DL_Dice2026/DiceCore")
local DicePanelBase = require("DL_Dice2026/UI/DicePanelBase")

local T = Theme.colors

local DiceMyHP = DicePanelBase:derive("DiceMyHP")

function DiceMyHP:createChildren()
	DicePanelBase.createChildren(self)

	local pad = self:S(4)
	local btnH = math.max(self:S(18), self.fontHgt + self:S(4))
	local btnY = self.fullH - btnH - pad
	local small = self:S(24)
	local wide = self:S(48)
	local x = pad

	self.minusButton = ISButton:new(x, btnY, small, btnH, "-1", self, DiceMyHP.onMinus)
	x = x + small + pad
	self.plusButton = ISButton:new(x, btnY, small, btnH, "+1", self, DiceMyHP.onPlus)
	x = x + small + pad
	self.resetButton = ISButton:new(x, btnY, wide, btnH, "Reset", self, DiceMyHP.onReset)
	x = x + wide + pad
	self.koButton = ISButton:new(x, btnY, wide, btnH, "KO", self, DiceMyHP.onKO)

	local buttons = { self.minusButton, self.plusButton, self.resetButton, self.koButton }
	for i = 1, #buttons do
		local b = buttons[i]
		b:initialise()
		b.font = self.font
		Theme.applyButtonStyle(b, i == 4 and "danger" or nil)
		self:addChild(b)
		self:registerControl(b)
	end
end

function DiceMyHP:onMinus()
	Core.changeHP(-1)
end

function DiceMyHP:onPlus()
	Core.changeHP(1)
end

function DiceMyHP:onReset()
	Core.resetHP()
end

function DiceMyHP:onKO()
	local me = Core.me()
	Core.setKO(me.status ~= "ko")
end

function DiceMyHP:render()
	if self.collapsed then
		return
	end
	local opacity = Core.settings.opacity
	local textA = self:textAlpha()
	local me = Core.me()
	local pad = self:S(6)
	local y = self.headerH + self:S(4)

	local hpText = tostring(me.hp) .. " / " .. tostring(me.maxHp)
	if me.status == "ko" then
		hpText = hpText .. "  (KO)"
	end
	self:drawText(hpText, pad, y, T.text.r, T.text.g, T.text.b, textA, self.font)

	local barY = y + self.fontHgt + self:S(3)
	local barH = self:S(6)
	local barW = self.width - pad * 2
	local frac = me.maxHp > 0 and (me.hp / me.maxHp) or 0
	local barColor = T.success
	if me.status == "ko" or frac <= 0.25 then
		barColor = T.danger
	elseif frac <= 0.5 then
		barColor = T.warning
	end
	self:drawRect(pad, barY, barW, barH, 0.35 * opacity, 0, 0, 0)
	self:drawRect(pad, barY, math.floor(barW * frac), barH, textA, barColor.r, barColor.g, barColor.b)
	self:drawRectBorder(pad, barY, barW, barH, T.borderDim.a * opacity, T.borderDim.r, T.borderDim.g, T.borderDim.b)
end

function DiceMyHP:onCoreEvent(event)
	if event == "opacity" then
		self:applyOpacity()
	elseif event == "state" then
		local me = Core.me()
		if self.koButton then
			self.koButton:setTitle(me.status == "ko" and "Get up" or "KO")
		end
	end
end

function DiceMyHP:new()
	local s = Core.panelScale("myHp")
	local width = Core.px(170 * s)
	local o = DicePanelBase.new(self, "myHp", "My HP", width, Core.px(40 * s), { xf = 0.815, yf = 0.55, visible = false })
	local btnH = math.max(o:S(18), o.fontHgt + o:S(4))
	o.fullH = o.headerH + o:S(4) + o.fontHgt + o:S(3) + o:S(6) + o:S(6) + btnH + o:S(8)
	o:setHeight(o.fullH)
	return o
end

return DiceMyHP
