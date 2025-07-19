ISDoubleTileTable = ISDoubleTileFurniture:derive("ISDoubleTileTable");

local directions = {
	north = "North",
	south = "South",
	west = "West",
	east = "East",
}

function ISDoubleTileTable:create(x, y, z, north, sprite)

	local direction = self:getDirection()


	if direction == directions.north then
		self.north = true

	elseif direction == directions.south then
		self.north = true

	elseif direction == directions.east then
		self.north = false

	end

	self.isContainer = false
	local cell = getWorld():getCell();
	self.sq = cell:getGridSquare(x, y, z);
	self:setInfo(self.sq, north, sprite, self);


	self.isContainer = false
	local secondarySprite = self:getSpriteSecondary();
	local x2, y2, z2 = self:getGridSquareSecondary(x, y, z)

	local secondarySquare = cell:getGridSquare(x2, y2, z2);

	local oldModData = self.modData
	self.modData = {}
	self:setInfo(secondarySquare, north, secondarySprite, self);

	self.modData = oldModData
	buildUtil.consumeMaterial(self);
end

function ISDoubleTileTable:new(name, sprite1, sprite2, northSprite1, northSprite2, eastSprite1, eastSprite2, southSprite1
                               ,
                               southSprite2)
	local o = {};
	setmetatable(o, self);
	self.__index = self;
	o:init();
	o:setSprite(sprite1);
	o:setNorthSprite(northSprite1);
	o:setEastSprite(eastSprite1)
	o:setSouthSprite(southSprite1)
	o.sprite2 = sprite2;
	o.northSprite2 = northSprite2;
	o.eastSprite2 = eastSprite2
	o.southSprite2 = southSprite2

	o.name = name;
	o.buildLow = true;
	o.canBeAlwaysPlaced = true;

	return o;
end

function ISDoubleTileTable:render(x, y, z, square)
	-- render the first part
	ISBuildingObject.render(self, x, y, z, square)

	local secondarySprite = self:getSpriteSecondary()

	local secondarySpriteFree = true;
	local x2, y2, z2 = self:getGridSquareSecondary(x, y, z)
	local secondarySquare = getCell():getGridSquare(x2, y2, z2);

	-- test if the square are free to add our furniture
	if not self.canBeAlwaysPlaced and (not secondarySquare or not secondarySquare:isFreeOrMidair(true)) then
		secondarySpriteFree = false;
	end

	if secondarySquare and secondarySquare:isVehicleIntersecting() then secondarySpriteFree = false end


	-- render our second tile object
	local secondarySpriteObject = IsoSprite.new();
	secondarySpriteObject:LoadFramesNoDirPageSimple(secondarySprite);
	if secondarySpriteFree then
		secondarySpriteObject:RenderGhostTile(x2, y2, z2);
	else
		secondarySpriteObject:RenderGhostTileRed(x2, y2, z2);
	end
end

function ISDoubleTileTable:isValid(square)

	if not ISBuildingObject.isValid(self, square) then
		return false
	end

	if buildUtil.stairIsBlockingPlacement(square, true) then return false; end

	if square:isVehicleIntersecting() then return false end

	local x2, y2, z2 = self:getGridSquareSecondary(square:getX(), square:getY(), square:getZ())
	local secondarySquare = getCell():getGridSquare(x2, y2, z2);
	if not secondarySquare or not secondarySquare:isFreeOrMidair(true) or
		buildUtil.stairIsBlockingPlacement(secondarySquare, true) then
		return false
	end
	if secondarySquare:isVehicleIntersecting() then return false end
	return true
end

function ISDoubleTileTable:getSpriteSecondary()

	local direction = self:getDirection()

	if direction == directions.north then
		return self.northSprite2
	end

	if direction == directions.south then
		return self.southSprite2
	end

	if direction == directions.east then
		return self.eastSprite2
	end

	return self.sprite2
end

function ISDoubleTileTable:getDirection()
	local sprite = self:getSprite()

	if sprite == self.northSprite then
		return directions.north
	elseif sprite == self.southSprite then
		return directions.south
	elseif sprite == self.eastSprite then
		return directions.east
	end

	return directions.west
end

function ISDoubleTileTable:getGridSquareSecondary(x, y, z)
	local direction = self:getDirection()
	local secondaryX = x + 1;
	local secondaryY = y;

	if direction == directions.north then
		secondaryX = x;
		secondaryY = y - 1;
	elseif direction == directions.south then
		secondaryX = x;
		secondaryY = y - 1;
	elseif direction == directions.east then
		secondaryX = x + 1;
	end

	return secondaryX, secondaryY, z;
end
