ISTripleTileFurniture = ISDoubleTileFurniture:derive("ISTripleTileFurniture")

local directions = {
	north = "North",
	south = "South",
	west = "West",
	east = "East",
}

function ISTripleTileFurniture:create(x, y, z, north, sprite)
	local direction = self:getDirection()

	if direction == directions.north or direction == directions.south then
		self.north = true
	else
		self.north = false
	end

	local cell = getWorld():getCell()
	self.sq = cell:getGridSquare(x, y, z)

	-- Place the main sprite
	self:setInfo(self.sq, north, sprite, self)

	-- Place the secondary and tertiary tiles
	local secondarySprite = self:getSpriteSecondary()
	local tertiarySprite = self:getSpriteTertiary()
	local x2, y2, z2 = self:getGridSquareOffset(x, y, z, 1)
	local x3, y3, z3 = self:getGridSquareOffset(x, y, z, 2)

	local square2 = cell:getGridSquare(x2, y2, z2)
	local square3 = cell:getGridSquare(x3, y3, z3)

	local oldModData = self.modData
	self.modData = {}
	self:setInfo(square2, north, secondarySprite, self)
	self:setInfo(square3, north, tertiarySprite, self)
	self.modData = oldModData

	buildUtil.consumeMaterial(self)
end

function ISTripleTileFurniture:new(name, sprite1, sprite2, sprite3, northSprites, eastSprites, southSprites)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o:init()

	o.name = name
	o:setSprite(northSprites[1])
	o.northSprite = northSprites[1]
	o.northSprite2 = northSprites[2]
	o.northSprite3 = northSprites[3]

	o.eastSprite = eastSprites[1]
	o.eastSprite2 = eastSprites[2]
	o.eastSprite3 = eastSprites[3]

	o.southSprite = southSprites[1]
	o.southSprite2 = southSprites[2]
	o.southSprite3 = southSprites[3]

	o.sprite2 = sprite2
	o.sprite3 = sprite3

	o.buildLow = true
	o.canBeAlwaysPlaced = true

	return o
end

function ISTripleTileFurniture:getDirection()
	local sprite = self:getSprite()
	if sprite == self.northSprite then return directions.north
	elseif sprite == self.southSprite then return directions.south
	elseif sprite == self.eastSprite then return directions.east
	elseif sprite == self.westSprite then return directions.west
	else return directions.west end

end

function ISTripleTileFurniture:getSpriteSecondary()
	local dir = self:getDirection()
	if dir == directions.north then return self.northSprite2
	elseif dir == directions.south then return self.southSprite2
	elseif dir == directions.east then return self.eastSprite2
	else return self.sprite2 end
end

function ISTripleTileFurniture:getSpriteTertiary()
	local dir = self:getDirection()
	if dir == directions.north then return self.northSprite3
	elseif dir == directions.south then return self.southSprite3
	elseif dir == directions.east then return self.eastSprite3
	else return self.sprite3 end
end

function ISTripleTileFurniture:getGridSquareOffset(x, y, z, offset)
	local dir = self:getDirection()
	if dir == directions.north then return x, y + offset, z
	elseif dir == directions.south then return x, y + offset, z
	elseif dir == directions.east then return x + offset, y, z
	else return x - offset, y, z
	end
end

function ISTripleTileFurniture:isValid(square)
	if not ISBuildingObject.isValid(self, square) then return false end
	if square:isVehicleIntersecting() then return false end

	for i = 1, 2 do
		local x, y, z = self:getGridSquareOffset(square:getX(), square:getY(), square:getZ(), i)
		local sq = getCell():getGridSquare(x, y, z)
		if not sq or not sq:isFreeOrMidair(true) or buildUtil.stairIsBlockingPlacement(sq, true) or sq:isVehicleIntersecting() then
			return false
		end
	end

	return true
end

function ISTripleTileFurniture:render(x, y, z, square)
	ISBuildingObject.render(self, x, y, z, square)

	local sprite2 = self:getSpriteSecondary()
	local sprite3 = self:getSpriteTertiary()

	for i, sprite in ipairs({sprite2, sprite3}) do
		local x2, y2, z2 = self:getGridSquareOffset(x, y, z, i)
		local sq = getCell():getGridSquare(x2, y2, z2)
		local valid = sq and sq:isFreeOrMidair(true) and not sq:isVehicleIntersecting()

		local ghostSprite = IsoSprite.new()
		ghostSprite:LoadFramesNoDirPageSimple(sprite)
		if valid then
			ghostSprite:RenderGhostTile(x2, y2, z2)
		else
			ghostSprite:RenderGhostTileRed(x2, y2, z2)
		end
	end
end
