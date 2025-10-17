BL_Funcs = {};

-- IsoDirections.E
local DIRECTION_DICT = 
{
    East = IsoDirections.E,
    North = IsoDirections.N,
    NorthEast = IsoDirections.NE,
    NorthWest = IsoDirections.NW,
    South = IsoDirections.S,
    SouthEast = IsoDirections.SE,
    SouthWest = IsoDirections.SW,
    West = IsoDirections.W,
};

function BL_Funcs.StartBuildLineCursor()
    if not isDebugEnabled() then return end;

    local playerObj = getPlayer();

    local blCursor = BuildLineCursor:new("", "", playerObj);
	getCell():setDrag(blCursor, playerObj:getPlayerNum());
end

function BL_Funcs.StopCursor()
    if not isDebugEnabled() then return end;

    local playerObj = getPlayer();
	getCell():setDrag(nil, playerObj:getPlayerNum());
end

function BL_Funcs.onClickTile(char, square)
    local squareObjs = square:getObjects();

    if not squareObjs then getPlayer():setHaloNote("No objects on this square to tilepick!"); return end;

    local outputString = "BUILDLINE OUTPUT:\n-----------------------------------\n";

    for i = 0, squareObjs:size() - 1 do
        local obj = squareObjs:get(i);

        if obj then
            local additionalStr = string.format("[%0d,%0d,%0d]", square:getX(), square:getY(), square:getZ());

            outputString = outputString .. additionalStr .. "\n";

            local textureDir = obj:getSprite():getName();
            outputString = outputString .. "      Direction: " .. tostring(obj:getDir()) .. " | Sprite: " .. textureDir .. "\n";
        end 
        outputString = outputString .. "\n\n";
    end

    writeLog("BuildLine_TilePick", outputString);
    getPlayer():setHaloNote("Tile saved.");
end
