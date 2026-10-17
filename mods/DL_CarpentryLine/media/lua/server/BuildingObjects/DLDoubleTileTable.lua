DLDoubleTileTable = ISDoubleTileFurniture:derive("DLDoubleTileTable")

function DLDoubleTileTable:create(x, y, z, north, sprite)
	local cell = getWorld():getCell()
	self.sq = cell:getGridSquare(x, y, z)
	self:setInfo(self.sq, north, sprite)

	local x2, y2, z2 = self:getGridSquareSecondary(x, y, z)
	local oldModData = self.modData
	self.modData = {}
	self:setInfo(cell:getGridSquare(x2, y2, z2), north, self:getSpriteSecondary())
	self.modData = oldModData
	buildUtil.consumeMaterial(self)
end

function DLDoubleTileTable:new(name, sprite1, sprite2, northSprite1, northSprite2, eastSprite1, eastSprite2, southSprite1, southSprite2)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o:init()
	o:setSprite(sprite1)
	o:setNorthSprite(northSprite1)
	o:setEastSprite(eastSprite1)
	o:setSouthSprite(southSprite1)
	o.sprite2 = sprite2
	o.northSprite2 = northSprite2
	o.eastSprite2 = eastSprite2
	o.southSprite2 = southSprite2
	o.name = name
	o.buildLow = true
	o.canBeAlwaysPlaced = true
	return o
end

function DLDoubleTileTable:render(x, y, z, square)
	ISBuildingObject.render(self, x, y, z, square)

	local x2, y2, z2 = self:getGridSquareSecondary(x, y, z)
	local secondarySquare = getCell():getGridSquare(x2, y2, z2)
	local free = secondarySquare ~= nil and secondarySquare:isFreeOrMidair(true) and not secondarySquare:isVehicleIntersecting()

	local sprite = IsoSprite.new()
	sprite:LoadFramesNoDirPageSimple(self:getSpriteSecondary())
	if free then
		sprite:RenderGhostTile(x2, y2, z2)
	else
		sprite:RenderGhostTileRed(x2, y2, z2)
	end
end

function DLDoubleTileTable:isValid(square)
	if not ISBuildingObject.isValid(self, square) then return false end
	if buildUtil.stairIsBlockingPlacement(square, true) then return false end
	if square:isVehicleIntersecting() then return false end

	local x2, y2, z2 = self:getGridSquareSecondary(square:getX(), square:getY(), square:getZ())
	local secondarySquare = getCell():getGridSquare(x2, y2, z2)
	if not secondarySquare or not secondarySquare:isFreeOrMidair(true) then return false end
	if buildUtil.stairIsBlockingPlacement(secondarySquare, true) then return false end
	return not secondarySquare:isVehicleIntersecting()
end

function DLDoubleTileTable:getDirection()
	local sprite = self:getSprite()
	if sprite == self.northSprite then return "north" end
	if sprite == self.southSprite then return "south" end
	if sprite == self.eastSprite then return "east" end
	return "west"
end

function DLDoubleTileTable:getSpriteSecondary()
	local direction = self:getDirection()
	if direction == "north" then return self.northSprite2 end
	if direction == "south" then return self.southSprite2 end
	if direction == "east" then return self.eastSprite2 end
	return self.sprite2
end

function DLDoubleTileTable:getGridSquareSecondary(x, y, z)
	local direction = self:getDirection()
	if direction == "north" or direction == "south" then
		return x, y - 1, z
	end
	return x + 1, y, z
end
