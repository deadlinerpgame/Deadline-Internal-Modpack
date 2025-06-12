BSBook5Menu = {};


local TargetTile = {
    ['aerx_tools_94']=true,
}

local function isTile(spr)
    return TargetTile[spr] or false
end

local function steppedonTile(char)
    if not char then return end
    local sq = getCell():getGridSquare(char:getX(),char:getY(),char:getZ()) 
	if sq and sq:getObjects() then
		local objects = sq:getObjects()
		for i=1,sq:getObjects():size() do
			local obj = sq:getObjects():get(i-1)
			if obj then 
			
				local spr = obj:getSprite()
				local sq = getPlayer()
				if spr and isTile(spr:getName())  then 	
				BSBook5Manager.onKeyPressed();
				end
			end
		end
    end
end



Events.OnPlayerUpdate.Add(steppedonTile) 