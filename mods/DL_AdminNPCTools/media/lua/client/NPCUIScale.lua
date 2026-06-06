local Layout = require("ElyonLib/UI/Layout/LayoutUtils")

NPCUIScale = NPCUIScale or {}
NPCUIScale.Layout = Layout
local BASELINE_SMALL_H = 14

local function screenSize()
	local core = getCore and getCore() or nil
	local sw = (core and core:getScreenWidth()) or 1920
	local sh = (core and core:getScreenHeight()) or 1080
	return sw, sh
end

function NPCUIScale.fontFactor()
	local tm = getTextManager and getTextManager() or nil
	local h = (tm and tm.getFontHeight) and tm:getFontHeight(UIFont.Small) or BASELINE_SMALL_H
	local s = h / BASELINE_SMALL_H
	if s < 1.0 then
		s = 1.0
	end
	return s
end

function NPCUIScale.fittedFactor(baseW, baseH, margin)
	margin = margin or 20
	local s = NPCUIScale.fontFactor()
	local sw, sh = screenSize()
	local maxW = (sw - margin * 2) / baseW
	local maxH = (sh - margin * 2) / baseH
	if maxW < s then s = maxW end
	if maxH < s then s = maxH end
	if s < 0.5 then s = 0.5 end
	return s
end

function NPCUIScale.dim(base, factor)
	local v = math.floor((tonumber(base) or 0) * (factor or 1) + 0.5)
	if v < 1 then v = 1 end
	return v
end

function NPCUIScale.centre(width, height)
	local x, y = Layout.centreOnScreen(width, height)
	return Layout.clampToScreen(x, y, width, height)
end

function NPCUIScale.windowGeometry(baseW, baseH, margin)
	local s = NPCUIScale.fittedFactor(baseW, baseH, margin)
	local w = NPCUIScale.dim(baseW, s)
	local h = NPCUIScale.dim(baseH, s)
	local x, y = NPCUIScale.centre(w, h)
	return s, w, h, x, y
end

return NPCUIScale
