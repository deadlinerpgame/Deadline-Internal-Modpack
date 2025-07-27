local TargetTileA = {
    ['aerx_tools_62']=true,
}

local TargetTileB = {
    ['aerx_tools_63']=true,
}

local TargetTileC = {
    ['aerx_tools_79']=true,
}

local function isTileA(spr)
    return TargetTileA[spr] or false
end

local function isTileB(spr)
    return TargetTileB[spr] or false
end

local function isTileC(spr)
    return TargetTileC[spr] or false
end

local function opa()
    local playerObj = getSpecificPlayer(0)
	playerObj:setX(13033);
	playerObj:setY(5423);
	playerObj:setZ(0);
	playerObj:setLx(playerObj:getX());
	playerObj:setLy(playerObj:getY());				
	playerObj:setLz(playerObj:getZ());	
end

local function opb()
    local playerObj = getSpecificPlayer(0)
	playerObj:setX(10507);
	playerObj:setY(3866);
	playerObj:setZ(0);
	playerObj:setLx(playerObj:getX());
	playerObj:setLy(playerObj:getY());				
	playerObj:setLz(playerObj:getZ());	
end

local function opc()
    local playerObj = getSpecificPlayer(0)
	playerObj:setX(11167);
	playerObj:setY(2271);
	playerObj:setZ(1);
	playerObj:setLx(playerObj:getX());
	playerObj:setLy(playerObj:getY());				
	playerObj:setLz(playerObj:getZ());	
end

local function onFillWorldObjectContextMenu(playerIndex, context, worldObjects, test)
    for _, obj in ipairs(worldObjects) do
        local square = obj:getSquare()
        if not square then end

        for i = 0, square:getObjects():size() - 1 do
            local tileObj = square:getObjects():get(i)
            local sprite = tileObj:getSprite()
            if sprite then
                local spriteName = sprite:getName()
                if isTileA(spriteName) then
                    context:addOption("Use Portal - Airfield Refugee Camp", worldObjects, opa, playerIndex)
                end
                if isTileB(spriteName) then
                    context:addOption("Use Portal - Beach Refugee Camp", worldObjects, opb, playerIndex)
                end
                if isTileC(spriteName) then
                    context:addOption("Use Portal - Police Station Refugee Camp", worldObjects, opc, playerIndex)
                end

            end
        end
    end
end

Events.OnFillWorldObjectContextMenu.Add(onFillWorldObjectContextMenu)



