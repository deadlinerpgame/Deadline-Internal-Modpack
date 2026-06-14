require("ISUI/ISPanel")
require("ISUI/ISButton")

local Theme = require("ElyonLib/UI/Theme/Theme")
local LayoutUtils = require("ElyonLib/UI/Layout/LayoutUtils")
local Core = require("DL_Dice2026/DiceCore")

local T = Theme.colors

local function fontForScale(scale)
	if scale >= 4 then
		local ok, massive = pcall(function()
			return UIFont.Massive
		end)
		if ok and massive then
			return massive
		end
		return UIFont.Large
	end
	if scale >= 2 then
		return UIFont.Medium
	end
	return UIFont.Small
end

DicePanelBase = ISPanel:derive("DicePanelBase")

function DicePanelBase:S(n)
	return Core.px(n * (self.scale or 1))
end

function DicePanelBase:textAlpha()
	return math.max(0.75, Core.settings.opacity)
end

function DicePanelBase:bgAlpha(base)
	return (base or 0.92) * Core.settings.opacity
end

function DicePanelBase:headerButtonSize()
	return math.max(Core.px(12), self.headerH - Core.px(4))
end

function DicePanelBase:createChildren()
	local size = self:headerButtonSize()
	local scaleW = size + Core.px(12)
	local pad = Core.px(2)

	self.closeButton = ISButton:new(self.width - size - pad, pad, size, size, "X", self, DicePanelBase.onHeaderClose)
	self.collapseButton = ISButton:new(self.width - (size * 2) - (pad * 2), pad, size, size, "-", self, DicePanelBase.onHeaderCollapse)
	self.scaleButton = ISButton:new(self.width - (size * 2) - scaleW - (pad * 3), pad, scaleW, size, tostring(self.scale) .. "x", self, DicePanelBase.onHeaderScale)
	self.scaleButton:setTooltip("Panel scale (1x / 2x / 4x)")

	local headerButtons = { self.closeButton, self.collapseButton, self.scaleButton }
	for i = 1, #headerButtons do
		local b = headerButtons[i]
		b:initialise()
		b:setDisplayBackground(false)
		b.borderColor = { r = 0, g = 0, b = 0, a = 0 }
		b.textColor = Theme.copy(T.textMuted)
		b.font = self.font
		self:addChild(b)
	end
end

function DicePanelBase:repositionHeaderButtons()
	local size = self:headerButtonSize()
	local scaleW = size + Core.px(12)
	local pad = Core.px(2)
	if self.closeButton then
		self.closeButton:setX(self.width - size - pad)
	end
	if self.collapseButton then
		self.collapseButton:setX(self.width - (size * 2) - (pad * 2))
	end
	if self.scaleButton then
		self.scaleButton:setX(self.width - (size * 2) - scaleW - (pad * 3))
	end
end

function DicePanelBase:onHeaderClose()
	self:setPanelVisible(false)
end

function DicePanelBase:onHeaderCollapse()
	self:setCollapsed(not self.collapsed)
end

function DicePanelBase:onHeaderScale()
	Core.cyclePanelScale(self.panelId)
end

function DicePanelBase:registerControl(control)
	if not control then
		return nil
	end
	local entry = { control = control }
	if control.backgroundColor then
		entry.bgA = control.backgroundColor.a or 1
	end
	if control.backgroundColorMouseOver then
		entry.bgHoverA = control.backgroundColorMouseOver.a or 1
	end
	if control.borderColor then
		entry.borderA = control.borderColor.a or 1
	end
	self.contentControls[#self.contentControls + 1] = entry
	return control
end

function DicePanelBase:applyOpacity()
	local opacity = Core.settings.opacity
	local textA = self:textAlpha()
	for i = 1, #self.contentControls do
		local entry = self.contentControls[i]
		local c = entry.control
		if c.backgroundColor and entry.bgA then
			c.backgroundColor.a = entry.bgA * opacity
		end
		if c.backgroundColorMouseOver and entry.bgHoverA then
			c.backgroundColorMouseOver.a = entry.bgHoverA * opacity
		end
		if c.borderColor and entry.borderA then
			c.borderColor.a = entry.borderA * opacity
		end
		if c.textColor then
			c.textColor.a = textA
		end
	end
end

function DicePanelBase:setCollapsed(collapsed)
	self.collapsed = collapsed == true
	if self.collapsed then
		self:setHeight(self.headerH)
	else
		self:setHeight(self.fullH)
	end
	for i = 1, #self.contentControls do
		self.contentControls[i].control:setVisible(not self.collapsed)
	end
	if self.collapseButton then
		self.collapseButton:setTitle(self.collapsed and "+" or "-")
	end
	self:saveState()
end

function DicePanelBase:setPanelVisible(visible)
	self:setVisible(visible == true)
	self:saveState()
	Core.notify("ui")
end

function DicePanelBase:isOnHeader(y)
	return y <= self.headerH
end

function DicePanelBase:onMouseDown(x, y)
	self:bringToTop()
	if not self:isOnHeader(y) then
		return true
	end
	self.dragMouseDown = true
	self.dragging = false
	self.dragStartX = getMouseX()
	self.dragStartY = getMouseY()
	self.dragOffsetX = getMouseX() - self:getX()
	self.dragOffsetY = getMouseY() - self:getY()
	self:setCapture(true)
	return true
end

function DicePanelBase:onMouseMove(dx, dy)
	self:updateDrag()
end

function DicePanelBase:onMouseMoveOutside(dx, dy)
	self:updateDrag()
end

function DicePanelBase:updateDrag()
	if not self.dragMouseDown then
		return
	end
	local moved = math.abs(getMouseX() - self.dragStartX) + math.abs(getMouseY() - self.dragStartY)
	if not self.dragging and moved >= 4 then
		self.dragging = true
	end
	if self.dragging then
		local x, y = LayoutUtils.clampToScreen(getMouseX() - self.dragOffsetX, getMouseY() - self.dragOffsetY, self.width, self.height)
		self:setX(x)
		self:setY(y)
	end
end

function DicePanelBase:onMouseUp(x, y)
	return self:endDrag()
end

function DicePanelBase:onMouseUpOutside(x, y)
	return self:endDrag()
end

function DicePanelBase:endDrag()
	if not self.dragMouseDown then
		return true
	end
	self:setCapture(false)
	self.dragMouseDown = false
	if self.dragging then
		self.dragging = false
		self:saveState()
	end
	return true
end

function DicePanelBase:saveState()
	local sw = getCore():getScreenWidth()
	local sh = getCore():getScreenHeight()
	local st = Core.panelState(self.panelId)
	st.xf = sw > 0 and (self:getX() / sw) or 0
	st.yf = sh > 0 and (self:getY() / sh) or 0
	st.visible = self:getIsVisible()
	st.collapsed = self.collapsed == true
	Core.saveSettings()
end

function DicePanelBase:restoreState()
	local st = Core.panelState(self.panelId, self.defaults)
	local sw = getCore():getScreenWidth()
	local sh = getCore():getScreenHeight()
	local x, y = LayoutUtils.clampToScreen(math.floor(st.xf * sw + 0.5), math.floor(st.yf * sh + 0.5), self.width, self.fullH)
	self:setX(x)
	self:setY(y)
	self:setVisible(st.visible == true)
	if st.collapsed then
		self:setCollapsed(true)
	end
	self:applyOpacity()
end

function DicePanelBase:onResolutionChange()
	local st = Core.panelState(self.panelId, self.defaults)
	local sw = getCore():getScreenWidth()
	local sh = getCore():getScreenHeight()
	local x, y = LayoutUtils.clampToScreen(math.floor(st.xf * sw + 0.5), math.floor(st.yf * sh + 0.5), self.width, self.height)
	self:setX(x)
	self:setY(y)
end

function DicePanelBase:prerender()
	local opacity = Core.settings.opacity
	local textA = self:textAlpha()
	local h = self.collapsed and self.headerH or self.height

	self:drawRect(0, 0, self.width, h, self:bgAlpha(T.background.a), T.background.r, T.background.g, T.background.b)
	self:drawRect(0, 0, self.width, self.headerH, self:bgAlpha(T.panelDark.a), T.panelDark.r, T.panelDark.g, T.panelDark.b)
	self:drawRectBorder(0, 0, self.width, h, T.border.a * opacity, T.border.r, T.border.g, T.border.b)

	local titleY = math.floor((self.headerH - self.fontHgt) / 2)
	self:drawText(self.title, self:S(6), titleY, T.text.r, T.text.g, T.text.b, textA, self.font)
end

function DicePanelBase:new(panelId, title, width, height, defaults)
	local o = ISPanel:new(0, 0, width, height)
	setmetatable(o, self)
	self.__index = self
	o.panelId = panelId
	o.title = title
	o.scale = Core.panelScale(panelId)
	o.font = fontForScale(o.scale)
	o.fontHgt = getTextManager():getFontHeight(o.font)
	o.fullH = height
	o.headerH = math.max(Core.px(18 * o.scale), o.fontHgt + Core.px(4))
	o.defaults = defaults or {}
	o.background = false
	o.keepOnScreen = false
	o.collapsed = false
	o.contentControls = {}
	o.dragMouseDown = false
	o.dragging = false
	return o
end

return DicePanelBase
