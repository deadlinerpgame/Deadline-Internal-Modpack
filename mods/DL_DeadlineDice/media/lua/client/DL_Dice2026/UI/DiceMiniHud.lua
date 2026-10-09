local Theme = require("ElyonLib/UI/Theme/Theme")
local TextUtils = require("ElyonLib/TextUtils/TextUtils")
local Core = require("DL_Dice2026/DiceCore")
local DicePanelBase = require("DL_Dice2026/UI/DicePanelBase")

local T = Theme.colors

local DiceMiniHud = DicePanelBase:derive("DiceMiniHud")

function DiceMiniHud:buildText()
	local me = Core.me()
	local hp = "HP " .. me.hp .. "/" .. me.maxHp
	if me.status == "ko" then
		hp = hp .. " (KO)"
	elseif me.status == "surrendered" then
		hp = hp .. " (surrendered)"
	end

	local phase = Core.state.phase
	if Core.state.paused then
		return "PAUSED by staff - " .. hp
	end
	if phase == "idle" then
		return "No combat - " .. hp
	end
	if phase == "announced" then
		return "Combat forming - " .. hp
	end
	local current = Core.findCombatant(Core.state.currentId)
	local who = current and current.name or "?"
	if Core.isMyTurn() then
		who = "YOUR TURN"
	end
	return "R" .. (Core.state.round or 1) .. " - " .. who .. " - " .. hp
end

function DiceMiniHud:render()
	if self.collapsed then
		return
	end
	local textA = self:textAlpha()
	local me = Core.me()
	local color = T.textMuted
	if Core.isMyTurn() then
		color = T.gold
	elseif me.status == "ko" then
		color = T.danger
	elseif me.status == "surrendered" then
		color = T.text
	end
	local text = TextUtils.trimToWidth(self.font, self:buildText(), self.width - Core.px(12), "..") or ""
	local y = self.headerH + math.floor((self.lineH - self.fontHgt) / 2)
	self:drawText(text, Core.px(6), y, color.r, color.g, color.b, textA, self.font)
end

function DiceMiniHud:onCoreEvent(event)
	if event == "opacity" then
		self:applyOpacity()
	end
end

function DiceMiniHud:new()
	local s = Core.panelScale("miniHud")
	local width = Core.px(240 * s)
	local o = DicePanelBase.new(self, "miniHud", "Dice", width, Core.px(40 * s), { xf = 0.40, yf = 0.005, visible = false })
	o.headerH = math.max(Core.px(16), o.fontHgt + Core.px(2))
	o.lineH = o.fontHgt + Core.px(6)
	o.fullH = o.headerH + o.lineH
	o:setHeight(o.fullH)
	return o
end

return DiceMiniHud
