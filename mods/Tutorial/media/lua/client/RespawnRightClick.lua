local TargetTileA = {
    ['aerx_tools_95']=true,
}
local function isTileA(spr)
    return TargetTileA[spr] or false
end

local function deathonoptionselect()
    local playerObj = getSpecificPlayer(0)
	playerObj:setX(15908);
	playerObj:setY(60);
	playerObj:setZ(0);
	playerObj:setLx(playerObj:getX());
	playerObj:setLy(playerObj:getY());				
	playerObj:setLz(playerObj:getZ());	

	playerObj:setHealth(0);
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
                    context:addOption("Respawn", worldObjects, deathonoptionselect, playerIndex)
                    return -- optional: only add once
                end
            end
        end
    end
end

Events.OnFillWorldObjectContextMenu.Add(onFillWorldObjectContextMenu)