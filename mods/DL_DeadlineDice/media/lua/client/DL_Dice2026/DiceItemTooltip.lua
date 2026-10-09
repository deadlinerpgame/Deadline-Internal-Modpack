require "ISUI/ISToolTipInv"

local Core = require("DL_Dice2026/DiceCore")
local DiceTraits = require("DL_Dice2026/DiceTraits")

local previousRender = ISToolTipInv.render

local function rangeLine(item)
	if not instanceof(item, "HandWeapon") then
		return nil
	end
	local class = Core.classifyWeapon(item)
	local range = DiceTraits.gunRangeOf(item, class)
	if range == nil then
		return nil
	end
	return "Dice: " .. range .. " range weapon"
end

function ISToolTipInv:render()
	local line = self.item and rangeLine(self.item) or nil
	if line == nil then
		return previousRender(self)
	end

	local font = UIFont[getCore():getOptionTooltipFont()]
	local lineSpacing = self.tooltip:getLineSpacing() + 0.5
	local lineWidth = getTextManager():MeasureStringX(font, line) + 16
	local stage, topY = 1, 0

	local oldSetWidth = self.setWidth
	self.setWidth = function(panel, width, ...)
		return oldSetWidth(panel, math.max(width, lineWidth), ...)
	end

	local oldSetHeight = self.setHeight
	self.setHeight = function(panel, height, ...)
		if stage == 1 then
			stage = 2
			topY = height
			height = height + lineSpacing
		else
			stage = -1
		end
		return oldSetHeight(panel, height, ...)
	end

	local oldDrawRectBorder = self.drawRectBorder
	self.drawRectBorder = function(panel, ...)
		if stage == 2 then
			panel.tooltip:DrawText(font, line, 5, topY - 3, 0.7, 0.85, 1, 1)
			stage = 3
		end
		return oldDrawRectBorder(panel, ...)
	end

	previousRender(self)

	self.setWidth = oldSetWidth
	self.setHeight = oldSetHeight
	self.drawRectBorder = oldDrawRectBorder
end
