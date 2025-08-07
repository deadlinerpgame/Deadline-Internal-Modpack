local UI
chosenpoint = 1
opened = 0

local spawnpointnames = {"Airport Camp", "Police Station Camp", "Beach Camp", "Boat Camp"}

local function mapa(button, args)
    UI["image1"]:setPath("media/ui/MapA.png")
    chosenpoint = 1
end

local function mapb(button, args)
    UI["image1"]:setPath("media/ui/MapB.png")
    chosenpoint = 2
end

local function mapc(button, args)
    UI["image1"]:setPath("media/ui/MapC.png")
    chosenpoint = 3
end

local function mapd(button, args)
    UI["image1"]:setPath("media/ui/MapD.png")
    chosenpoint = 4
end

local function spawn()
    local playerObj = getSpecificPlayer(0)
    if chosenpoint == 1 then
        playerObj:setX(13033);
        playerObj:setY(5423);
        playerObj:setZ(0);
    elseif chosenpoint == 2 then
        playerObj:setX(11167);
        playerObj:setY(2271);
        playerObj:setZ(1);
    elseif chosenpoint == 3 then
        playerObj:setX(10507);
        playerObj:setY(38966);
        playerObj:setZ(0);
    elseif chosenpoint == 4 then
        playerObj:setX(16477);
        playerObj:setY(5744);
        playerObj:setZ(0);
    end
	playerObj:setLx(playerObj:getX());
	playerObj:setLy(playerObj:getY());				
	playerObj:setLz(playerObj:getZ());	
    UI:close();
end

local function onCreateUI()
    UI = NewUI(0.15);
    UI:addText("title1", "Choose a Spawn Location", "Title", "Center");
    UI:setLineHeightPercent(0.04);    
    UI:setWidthPercent(0.55);
    UI["title1"]:setBorder(false);
    UI:nextLine();

    UI:addImage("image1", "media/ui/maptest.png")
    UI:nextLine();

    UI:addButton("button1", spawnpointnames[1], mapa);
    UI:addButton("button2", spawnpointnames[2], mapb);
    UI:addButton("button3", spawnpointnames[3], mapc);
    UI:addButton("button4", spawnpointnames[4], mapd);
    UI:setLineHeightPercent(0.02);    
    UI:nextLine();

    UI:addButton("", "Spawn", spawn);
    UI:setLineHeightPercent(0.02); 
    UI:saveLayout();
end


local TargetTileA = {
    ['aerx_testscifi_52']=true,
}

local TargetTileB = {
    ['aerx_testscifi_53']=true,
}


local function isTileA(spr)
    return TargetTileA[spr] or false
end

local function isTileB(spr)
    return TargetTileB[spr] or false
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
				if spr and isTileA(spr:getName())  then
                    if opened == 0 then 	
                    onCreateUI()
                    opened = 1
                    else return end
				end
				if spr and isTileB(spr:getName())  then
                    opened = 0
				end
			end
		end
    end
end



Events.OnPlayerUpdate.Add(steppedonTile) 