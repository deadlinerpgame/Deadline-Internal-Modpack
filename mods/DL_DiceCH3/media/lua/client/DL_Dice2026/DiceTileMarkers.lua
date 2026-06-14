local Core = require("DL_Dice2026/DiceCore")

local DiceTileMarkers = {}

local GOLD = { r = 0.95, g = 0.76, b = 0.33 }
local TEAL = { r = 0.30, g = 0.85, b = 0.75 }
local RED = { r = 0.95, g = 0.25, b = 0.20 }
local AMBER = { r = 0.95, g = 0.60, b = 0.20 }
local ZONE = { r = 0.85, g = 0.25, b = 0.25 }

local AOE_RADIUS = { molotov = 1, bomb = 2 }

local function resolvePos(c)
	if not c then
		return nil
	end
	if c.isMe then
		local p = getPlayer and getPlayer() or nil
		if p then
			return math.floor(p:getX()), math.floor(p:getY()), math.floor(p:getZ())
		end
		return nil
	end
	if not c.isNpc and getPlayerFromUsername then
		local ok, p = pcall(getPlayerFromUsername, c.name)
		if ok and p then
			return math.floor(p:getX()), math.floor(p:getY()), math.floor(p:getZ())
		end
	end
	if c.pos then
		return c.pos.x, c.pos.y, c.pos.z
	end
	return nil
end

DiceTileMarkers.resolvePos = resolvePos

local function highlight(cell, x, y, z, color, alpha)
	local square = cell:getGridSquare(x, y, z)
	if square then
		local floor = square:getFloor()
		if floor then
			floor:setHighlightColor(color.r, color.g, color.b, alpha)
			floor:setHighlighted(true)
		end
	end
end

local tick = 0

local function collectMarkers()
	local markers = {}
	local list = Core.state.combatants
	local currentId = Core.state.phase == "active" and Core.state.currentId or nil

	for i = 1, #list do
		local c = list[i]
		if c.id == currentId then
			local pulse = 0.35 + 0.35 * math.abs(math.sin(tick / 14))
			markers[#markers + 1] = { c = c, color = GOLD, alpha = pulse }
		elseif c.isNpc or c.showMarker then
			markers[#markers + 1] = { c = c, color = TEAL, alpha = 0.55 }
		end
	end
	return markers
end

local function hoveredTile()
	local p = getPlayer and getPlayer() or nil
	if not p then
		return nil
	end
	local z = math.floor(p:getZ())
	local mx, my = ISCoordConversion.ToWorld(getMouseXScaled(), getMouseYScaled(), z)
	return math.floor(mx), math.floor(my), z
end

local function drawAim(cell, aimer, targetId)
	local target = Core.findCombatant(targetId)
	if not target then
		return
	end
	local x, y, z = resolvePos(target)
	if not x then
		return
	end
	local aoe = aimer and AOE_RADIUS[aimer.weapon or ""] or nil
	if aoe then
		for dx = -aoe, aoe do
			for dy = -aoe, aoe do
				highlight(cell, x + dx, y + dy, z, AMBER, 0.35)
			end
		end
	end
	local pulse = 0.45 + 0.35 * math.abs(math.sin(tick / 8))
	highlight(cell, x, y, z, RED, pulse)
end

local function onRenderTick()
	local s = Core.state
	if #s.combatants == 0 and not s.combatId then
		return
	end
	tick = tick + 1
	local cell = getCell()
	if not cell then
		return
	end

	if s.combatId and s.anchor then
		local r = Core.RADIUS
		local a = s.anchor
		for d = -r, r, 2 do
			highlight(cell, a.x + d, a.y - r, a.z, ZONE, 0.30)
			highlight(cell, a.x + d, a.y + r, a.z, ZONE, 0.30)
			highlight(cell, a.x - r, a.y + d, a.z, ZONE, 0.30)
			highlight(cell, a.x + r, a.y + d, a.z, ZONE, 0.30)
		end
	end

	local markers = collectMarkers()
	for i = 1, #markers do
		local m = markers[i]
		local x, y, z = resolvePos(m.c)
		if x then
			highlight(cell, x, y, z, m.color, m.alpha)
		end
	end

	if s.phase == "active" and s.currentId then
		local actor = Core.findCombatant(s.currentId)
		if actor and actor.aimingAt then
			drawAim(cell, actor, actor.aimingAt)
		end
	end
	if s.selectedTargetId then
		drawAim(cell, Core.me(), s.selectedTargetId)
	end

	if s.movingNpcId then
		local x, y, z = hoveredTile()
		if x then
			local pulse = 0.45 + 0.35 * math.abs(math.sin(tick / 10))
			highlight(cell, x, y, z, { r = 1, g = 1, b = 1 }, pulse)
		end
	end
end

local function onPostRender()
	if #Core.state.combatants == 0 then
		return
	end
	local markers = collectMarkers()
	if #markers == 0 then
		return
	end

	local zoom = 1
	if getCore and getCore().getZoom then
		zoom = getCore():getZoom(0) or 1
	end
	local offset = (56 / zoom) + (3 * zoom)
	local tm = getTextManager()

	for i = 1, #markers do
		local m = markers[i]
		local x, y, z = resolvePos(m.c)
		if x then
			local sx = isoToScreenX(0, x + 0.5, y + 0.5, z)
			local sy = isoToScreenY(0, x + 0.5, y + 0.5, z)
			local halfW = math.floor(tm:MeasureStringX(UIFont.Small, m.c.name) / 2)
			tm:DrawString(UIFont.Small, sx - halfW + 1, sy - offset + 1, m.c.name, 0, 0, 0, 0.8)
			tm:DrawString(UIFont.Small, sx - halfW, sy - offset, m.c.name, m.color.r, m.color.g, m.color.b, 1)
		end
	end
end

local function onPostRenderPlacement()
	local moving = Core.findCombatant(Core.state.movingNpcId)
	if not moving then
		return
	end
	local x, y, z = hoveredTile()
	if not x then
		return
	end
	local zoom = 1
	if getCore and getCore().getZoom then
		zoom = getCore():getZoom(0) or 1
	end
	local offset = (56 / zoom) + (3 * zoom)
	local text = "Place " .. moving.name .. " here"
	local tm = getTextManager()
	local sx = isoToScreenX(0, x + 0.5, y + 0.5, z)
	local sy = isoToScreenY(0, x + 0.5, y + 0.5, z)
	local halfW = math.floor(tm:MeasureStringX(UIFont.Small, text) / 2)
	tm:DrawString(UIFont.Small, sx - halfW + 1, sy - offset + 1, text, 0, 0, 0, 0.8)
	tm:DrawString(UIFont.Small, sx - halfW, sy - offset, text, 1, 1, 1, 1)
end


local function onMouseDownPlace(mx, my)
	if not Core.state.movingNpcId then
		return
	end
	local x, y, z = hoveredTile()
	if x then
		Core.staffPlaceNpc(x, y, z)
	end
end

local function onKeyPressedPlace(key)
	if Core.state.movingNpcId and Keyboard and key == Keyboard.KEY_ESCAPE then
		Core.staffCancelMoveNpc()
	end
end

Events.OnRenderTick.Add(onRenderTick)
Events.OnPostRender.Add(onPostRender)
Events.OnPostRender.Add(onPostRenderPlacement)
Events.OnMouseDown.Add(onMouseDownPlace)
Events.OnKeyPressed.Add(onKeyPressedPlace)

return DiceTileMarkers
