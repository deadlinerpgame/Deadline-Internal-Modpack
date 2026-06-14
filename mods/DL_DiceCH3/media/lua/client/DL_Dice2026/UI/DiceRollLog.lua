local Theme = require("ElyonLib/UI/Theme/Theme")
local TextUtils = require("ElyonLib/TextUtils/TextUtils")
local Core = require("DL_Dice2026/DiceCore")
local DicePanelBase = require("DL_Dice2026/UI/DicePanelBase")

local T = Theme.colors

local DiceRollLog = DicePanelBase:derive("DiceRollLog")

local VISIBLE_LINES = 9

function DiceRollLog:lineHeight()
	return self.fontHgt + self:S(2)
end

function DiceRollLog:createChildren()
	DicePanelBase.createChildren(self)

	local pad = self:S(4)
	local btnH = math.max(self:S(16), self.fontHgt + self:S(2))
	local btnW = self:S(48)
	self.clearButton = ISButton:new(self.width - btnW - pad, self.fullH - btnH - pad, btnW, btnH, "Clear", self, DiceRollLog.onClear)
	self.clearButton:initialise()
	self.clearButton.font = self.font
	Theme.applyButtonStyle(self.clearButton, nil)
	self:addChild(self.clearButton)
	self:registerControl(self.clearButton)
end

function DiceRollLog:onClear()
	Core.log = {}
	self.scrollOffset = 0
	Core.notify("log")
end

function DiceRollLog:buildLines()
	local lines = {}
	local maxW = self.width - self:S(10)
	for i = 1, #Core.log do
		local wrapped = TextUtils.wrapLines(Core.log[i], self.font, maxW, 4)
		for j = 1, #wrapped do
			lines[#lines + 1] = wrapped[j]
		end
	end
	return lines
end

function DiceRollLog:onMouseWheel(del)
	local lines = self:buildLines()
	local maxOffset = math.max(0, #lines - VISIBLE_LINES)
	self.scrollOffset = math.max(0, math.min((self.scrollOffset or 0) + (del > 0 and 2 or -2), maxOffset))
	return true
end

function DiceRollLog:render()
	if self.collapsed then
		return
	end
	local textA = self:textAlpha()
	local pad = self:S(5)
	local lineH = self:lineHeight()
	local lines = self:buildLines()

	local maxOffset = math.max(0, #lines - VISIBLE_LINES)
	local offset = math.min(self.scrollOffset or 0, maxOffset)
	local startIndex = math.max(1, #lines - VISIBLE_LINES + 1 - offset)

	local y = self.headerH + self:S(3)
	local drawn = 0
	local i = startIndex
	while i <= #lines and drawn < VISIBLE_LINES do
		self:drawText(lines[i], pad, y, T.textMuted.r, T.textMuted.g, T.textMuted.b, textA, self.font)
		y = y + lineH
		drawn = drawn + 1
		i = i + 1
	end

	if #lines == 0 then
		self:drawText("Roll results appear here.", pad, y, T.textDim.r, T.textDim.g, T.textDim.b, textA, self.font)
	end

	if offset > 0 then
		self:drawText("v " .. offset .. " newer", pad, self.fullH - self:lineHeight() - self:S(4), T.accent.r, T.accent.g, T.accent.b, textA, self.font)
	end
end

function DiceRollLog:onCoreEvent(event)
	if event == "opacity" then
		self:applyOpacity()
	end
end

function DiceRollLog:new()
	local s = Core.panelScale("rollLog")
	local width = Core.px(280 * s)
	local o = DicePanelBase.new(self, "rollLog", "Roll log", width, Core.px(100 * s), { xf = 0.50, yf = 0.74, visible = false })
	local btnH = math.max(o:S(16), o.fontHgt + o:S(2))
	o.fullH = o.headerH + o:S(6) + VISIBLE_LINES * (o.fontHgt + o:S(2)) + btnH + o:S(10)
	o:setHeight(o.fullH)
	o.scrollOffset = 0
	return o
end

return DiceRollLog
