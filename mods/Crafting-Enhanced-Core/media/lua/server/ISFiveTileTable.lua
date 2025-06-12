ISFiveTileFurniture = ISDoubleTileFurniture:derive("ISFiveTileFurniture")

local directions = {
	north = "North",
	south = "South",
	west = "West",
	east = "East",
}

function ISFiveTileFurniture:create(x, y, z, north, sprite)
	local direction = self:getDirection()
	local cell = getWorld():getCell()

	self.sq = cell:getGridSquare(x, y, z)
	self:setInfo(self.sq, north, sprite, self)

	local sprites = self:getAllSprites()
	local offsets = self:getOffsets(x, y, z)

	local oldModData = self.modData
	self.modData = {}
	
	for i = 1, #offsets do
		local sq = cell:getGridSquare(offsets[i].x, offsets[i].y, offsets[i].z)
		self:setInfo(sq, north, sprites[i], self)
	end

	self.modData = oldModData
	buildUtil.consumeMaterial(self)
end

function ISFiveTileFurniture:new(name, spriteLayout)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o:init()

	o.name = name
	o.sprites = spriteLayout
	
	o.buildLow = true
	o.canBeAlwaysPlaced = true

	return o
end

function ISFiveTileFurniture:getDirection()
	local sprite = self:getSprite()
	if sprite == self.sprites.north[1] then return directions.north
	elseif sprite == self.sprites.east[1] then return directions.east
	elseif sprite == self.sprites.south[1] then return directions.south
	elseif sprite == self.sprites.west[1] then return directions.west
	else return directions.north end
end

function ISFiveTileFurniture:getAllSprites()
	local dir = self:getDirection()
	return self.sprites[dir:lower()]
end

function ISFiveTileFurniture:getOffsets(x, y, z)
	local dir = self:getDirection()
	if dir == directions.north or dir == directions.south then
		return {
			{x = x, y = y, z = z},
			{x = x + 1, y = y, z = z},
			{x = x + 2, y = y, z = z},
			{x = x, y = y + 1, z = z},
			{x = x, y = y + 2, z = z},
		}
	else
		return {
			{x = x, y = y, z = z},
			{x = x + 1, y = y, z = z},
			{x = x + 2, y = y, z = z},
			{x = x, y = y + 1, z = z},
			{x = x, y = y + 2, z = z},
		}
	end
end

function ISFiveTileFurniture:isValid(square)
	if not ISBuildingObject.isValid(self, square) then return false end
	if square:isVehicleIntersecting() then return false end

	local x, y, z = square:getX(), square:getY(), square:getZ()
	local offsets = self:getOffsets(x, y, z)
	for _, coord in ipairs(offsets) do
		local sq = getCell():getGridSquare(coord.x, coord.y, coord.z)
		if not sq or not sq:isFreeOrMidair(true) or sq:isVehicleIntersecting() then
			return false
		end
	end

	return true
end

function ISFiveTileFurniture:render(x, y, z, square)
	ISBuildingObject.render(self, x, y, z, square)

	local sprites = self:getAllSprites()
	local offsets = self:getOffsets(x, y, z)

	for i, coord in ipairs(offsets) do
		local sq = getCell():getGridSquare(coord.x, coord.y, 0)
		local ghostSprite = IsoSprite.new()
		ghostSprite:LoadFramesNoDirPageSimple(sprites[i])

		if sq and sq:isFreeOrMidair(true) and not sq:isVehicleIntersecting() then
			ghostSprite:RenderGhostTile(coord.x, coord.y, 0)
		else
			ghostSprite:RenderGhostTileRed(coord.x, coord.y, 0)
		end
	end
end
