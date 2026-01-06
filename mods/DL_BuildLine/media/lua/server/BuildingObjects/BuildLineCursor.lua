require("BuildingObjects/ISBuildingObject");

BuildLineCursor = ISBuildingObject:derive("BuildLineCursor");



function BuildLineCursor:create(x, y, z, north, sprite)
	local square = getWorld():getCell():getGridSquare(x, y, z);
	BL_Funcs.onClickTile(self.character, square);
end

function BuildLineCursor:isValid(square)
	return square:getObjects() and square:getObjects():size() > 0
end

function BuildLineCursor:render(x, y, z, square)
	if not BuildLineCursor.floorSprite then
		BuildLineCursor.floorSprite = IsoSprite.new();
		BuildLineCursor.floorSprite:LoadFramesNoDirPageSimple('media/ui/FloorTileCursor.png');
	end

	local hc = getCore():getBadHighlitedColor()
	if self:isValid(square) then
		hc = getCore():getGoodHighlitedColor()

        local objs = square:getObjects();
        for i = 0, objs:size() - 1 do
            local iteratedObj = objs:get(i);
            if iteratedObj then
                iteratedObj:setHighlighted(true);
            end
        end 
	end
	BuildLineCursor.floorSprite:RenderGhostTileColor(x, y, z, hc:getR(), hc:getG(), hc:getB(), 0.8)
end

function BuildLineCursor:new(sprite, northSprite, character)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o:init()
	o:setSprite(sprite)
	o:setNorthSprite(northSprite)
	o.character = character
	o.player = character:getPlayerNum()
	o.noNeedHammer = true
	o.skipBuildAction = true
	return o
end

