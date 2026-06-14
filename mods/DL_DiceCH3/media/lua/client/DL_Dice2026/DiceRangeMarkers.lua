local Core = require("DL_Dice2026/DiceCore")

local DiceRangeMarkers = {}

DiceRangeMarkers.MOVE_RANGE = 7
DiceRangeMarkers.DASH_RANGE = 14
DiceRangeMarkers.THROW_RANGE = 10
DiceRangeMarkers.PISTOL_RANGE = 15
DiceRangeMarkers.RIFLE_RANGE = 20

local COLOR_MOVE = { r = 0.20, g = 0.85, b = 0.25 }
local COLOR_DASH = { r = 0.95, g = 0.55, b = 0.10 }
local COLOR_THROW = { r = 0.95, g = 0.76, b = 0.33 }
local COLOR_PISTOL = { r = 0.20, g = 0.85, b = 0.25 }
local COLOR_RIFLE = { r = 0.30, g = 0.55, b = 0.95 }
local COLOR_OUT = { r = 0.90, g = 0.20, b = 0.20 }

local function highlightSquare(cell, x, y, z, color, alpha)
	local square = cell:getGridSquare(x, y, z)
	if square then
		local floor = square:getFloor()
		if floor then
			floor:setHighlightColor(color.r, color.g, color.b, alpha)
			floor:setHighlighted(true)
		end
	end
end

local function drawRing(cell, cx, cy, z, r, color, alpha)
	for d = -r, r do
		highlightSquare(cell, cx + d, cy - r, z, color, alpha)
		highlightSquare(cell, cx + d, cy + r, z, color, alpha)
		if d > -r and d < r then
			highlightSquare(cell, cx - r, cy + d, z, color, alpha)
			highlightSquare(cell, cx + r, cy + d, z, color, alpha)
		end
	end
end

local function lineBetween(x0, y0, x1, y1)
	local tiles = {}
	local dx = math.abs(x1 - x0)
	local dy = math.abs(y1 - y0)
	local sx = x0 < x1 and 1 or -1
	local sy = y0 < y1 and 1 or -1
	local err = dx - dy
	while true do
		tiles[#tiles + 1] = { x = x0, y = y0 }
		if x0 == x1 and y0 == y1 then
			break
		end
		local e2 = 2 * err
		if e2 > -dy then
			err = err - dy
			x0 = x0 + sx
		end
		if e2 < dx then
			err = err + dx
			y0 = y0 + sy
		end
	end
	return tiles
end

local function chebyshev(ax, ay, bx, by)
	return math.max(math.abs(ax - bx), math.abs(ay - by))
end

local function lineBandColor(dist, moveOn, gunOn)
	if moveOn and dist <= DiceRangeMarkers.MOVE_RANGE then
		return COLOR_MOVE
	end
	if moveOn and dist <= DiceRangeMarkers.DASH_RANGE then
		return COLOR_DASH
	end
	if gunOn and dist <= DiceRangeMarkers.THROW_RANGE then
		return COLOR_THROW
	end
	if gunOn and dist <= DiceRangeMarkers.PISTOL_RANGE then
		return COLOR_PISTOL
	end
	if gunOn and dist <= DiceRangeMarkers.RIFLE_RANGE then
		return COLOR_RIFLE
	end
	return COLOR_OUT
end

local lastDistance = nil
local lastTile = nil

local function onRenderTick()
	local moveOn = Core.state.showMoveRange
	local gunOn = Core.state.showGunRange
	if not moveOn and not gunOn then
		lastDistance = nil
		lastTile = nil
		return
	end

	local player = getSpecificPlayer(0)
	if not player then
		return
	end

	local cell = getCell()
	local z = player:getZ()
	local px = math.floor(player:getX())
	local py = math.floor(player:getY())

	if moveOn then
		drawRing(cell, px, py, z, DiceRangeMarkers.MOVE_RANGE, COLOR_MOVE, 0.65)
		drawRing(cell, px, py, z, DiceRangeMarkers.DASH_RANGE, COLOR_DASH, 0.45)
	end
	if gunOn then
		drawRing(cell, px, py, z, DiceRangeMarkers.THROW_RANGE, COLOR_THROW, 0.45)
		drawRing(cell, px, py, z, DiceRangeMarkers.PISTOL_RANGE, COLOR_PISTOL, 0.55)
		drawRing(cell, px, py, z, DiceRangeMarkers.RIFLE_RANGE, COLOR_RIFLE, 0.55)
	end

	local mx, my = ISCoordConversion.ToWorld(getMouseXScaled(), getMouseYScaled(), z)
	local tx = math.floor(mx)
	local ty = math.floor(my)
	local line = lineBetween(px, py, tx, ty)
	for i = 1, #line do
		local tile = line[i]
		local dist = chebyshev(tile.x, tile.y, px, py)
		highlightSquare(cell, tile.x, tile.y, z, lineBandColor(dist, moveOn, gunOn), 0.55)
	end

	lastDistance = chebyshev(tx, ty, px, py)
	lastTile = { x = tx, y = ty, z = z }
end

local function onPostRender()
	if lastDistance == nil or lastTile == nil then
		return
	end
	if not Core.state.showMoveRange and not Core.state.showGunRange then
		return
	end

	local sx = isoToScreenX(0, lastTile.x + 0.5, lastTile.y + 0.5, lastTile.z)
	local sy = isoToScreenY(0, lastTile.x + 0.5, lastTile.y + 0.5, lastTile.z)

	local zoom = 1
	if getCore and getCore().getZoom then
		zoom = getCore():getZoom(0) or 1
	end
	local offset = (48 / zoom) + (3 * zoom)

	local color = lineBandColor(lastDistance, Core.state.showMoveRange, Core.state.showGunRange)
	local text = lastDistance .. " tile" .. (lastDistance == 1 and "" or "s")
	local tm = getTextManager()
	local halfW = math.floor(tm:MeasureStringX(UIFont.Medium, text) / 2)
	tm:DrawString(UIFont.Medium, sx - halfW + 1, sy - offset + 1, text, 0, 0, 0, 0.8)
	tm:DrawString(UIFont.Medium, sx - halfW, sy - offset, text, color.r, color.g, color.b, 1)
end

Events.OnRenderTick.Add(onRenderTick)
Events.OnPostRender.Add(onPostRender)

return DiceRangeMarkers
