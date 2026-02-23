require "ISPostDeathUI";
local original_PostDeathUI_createChildren = ISPostDeathUI.createChildren;

LastX = nil;
LastY = nil;
LastZ = nil;
LastDesc = nil;
LastInv = nil;
LastName = { first = "", last = "" };
LastProfession = nil;
LastTraits = {};
LastCorpse = nil;

CheckPostRespawn = false;
local function OnPlayerDeath_CheckPostRespawn()
    if not CheckPostRespawn then return end;
    if not getPlayer():getInventory() then return end;

    -- Go through all corpses in the square
    local inventory = getPlayer():getInventory();
    if not inventory then return end;

    if getPlayer():getSquare() then
        local objects = getPlayer():getSquare():getDeadBodys();

        if objects then
            for i = 0, objects:size() - 1 do
                local obj = objects:get(i);

                if instanceof(obj, "IsoDeadBody") then
                    local objId = obj:getOnlineID();
                    if objId and objId == getPlayer():getOnlineID() then
                        LastCorpse = obj;
                    end
                end
                
            end
        end
    end

    

    if LastCorpse and getPlayer():getModData().JaxeRevival_Incapacitated then
        local items = inventory:getItems();
        for i = 0, items:size() - 1 do
            local item = items:get(i);
            if item and item:getType() ~= "KI5.PODCardGray" then
                print("Removing item " .. item:getType() .. " from player inventory!");
                inventory:DoRemoveItem(item);
            end
        end
        print("Player corpse is not nil.");
        getPlayer():setWornItems(LastCorpse:getWornItems());
        getPlayer():setAttachedItems(LastCorpse:getAttachedItems());

        LastCorpse:removeFromWorld();
        LastCorpse:removeFromSquare();
        CheckPostRespawn = false;
    end
end

function ISPostDeathUI:onContinueIncap()

    ProfessionFactory.Reset();
    BaseGameCharacterDetails.DoProfessions();
	if CoopCharacterCreation.instance then return end
	if UIManager.getSpeedControls() and not IsoPlayer.allPlayersDead() then
		setShowPausedMessage(false)
		UIManager.getSpeedControls():SetCurrentGameSpeed(0)
	end

	CoopCharacterCreation.setVisibleAllUI(false)
	local w = CoopCharacterCreation:new(nil, nil, 0)
	w:initialise()
	w:addToUIManager()

	w.mapSpawnSelect:useDefaultSpawnRegion()
    w.charCreationProfession.onSelectProf(ProfessionFactory.getProfessions():get(0));
    w.charCreationMain:initClothing();
    w.charCreationMain:initPlayer();

    w:accept();

    getPlayer():setX(LastX);
    getPlayer():setY(LastY);
    getPlayer():setZ(LastZ or 0);

    getPlayer():getVisual():copyFrom(LastDesc);
    getPlayer():getBodyDamage():setOverallBodyHealth(25);
    
    getPlayer():getDescriptor():setForename(LastName.first or string.split(getPlayer():getUsername(), " ")[1]);
    getPlayer():getDescriptor():setSurname(LastName.last or string.split(getPlayer():getUsername(), " ")[2]);

    -- Clear traits.
    getPlayer():getTraits():clear();
    for i, _ in ipairs(LastTraits) do
        getPlayer():getTraits():add(LastTraits[i]);
    end

    CheckPostRespawn = true;
end

function ISPostDeathUI:createChildren()
    original_PostDeathUI_createChildren(self);

    LastName =
    {
        first = getPlayer():getDescriptor():getForename(),
        last = getPlayer():getDescriptor():getSurname()
    }

    LastX = getPlayer():getX();
    LastY = getPlayer():getY();
    LastZ = getPlayer():getZ();

    LastTraits = {};
    local playerTraits = getPlayer():getTraits();
    for i = 0, playerTraits:size() - 1 do
        table.insert(LastTraits, playerTraits:get(i));
    end

    LastDesc = getPlayer():getVisual();

    LastProfession = getPlayer():getDescriptor():getProfession();

    LastInv = {};
    local playerItems = getPlayer():getInventory():getItems();

    for i = 0, playerItems:size() - 1 do
        table.insert(LastInv, playerItems:get(i));
    end

    self.buttonRespawn.onclick = self.onContinueIncap;

end

-- function CoopCharacterCreation:accept1()
-- function CoopCharacterCreation:accept()
-- function CharacterCreationProfession.initWorld()

local function OnPlayerDeath_SaveData(player)

    if player ~= getPlayer() then return end;

    MainScreen.instance.desc = player:getDescriptor();

    local forename = player:getDescriptor():getForename();
    local surname = player:getDescriptor():getSurname();

    local cachedPlayerData =
    {
        forename = forename,
        surname = surname,
        desc = MainScreen.instance.desc,
        traits = {},
        spawnData = {
            xCell = math.floor(player:getX() / 300),
            yCell = math.floor(player:getY() / 300),
            xPos = player:getX(),
            yPos = player:getY(),
            zPos = player:getZ()
        },
    };


    player:getModData().CachedDeathData = cachedPlayerData;
end


--[[
print(#spawn..' possible spawn points')
		local randSpawnPoint = spawn[(ZombRand(#spawn) + 1)]
		getWorld():setLuaSpawnCellX(randSpawnPoint.worldX)
		getWorld():setLuaSpawnCellY(randSpawnPoint.worldY)
		getWorld():setLuaPosX(randSpawnPoint.posX)
		getWorld():setLuaPosY(randSpawnPoint.posY)
		getWorld():setLuaPosZ(randSpawnPoint.posZ or 0)
	elseif getCore():isChallenge() then
		-- This shouldn't happen. See LastStandData.getSpawnRegion()
		getWorld():setLuaSpawnCellX(globalChallenge.xcell);
		getWorld():setLuaSpawnCellY(globalChallenge.ycell);
		getWorld():setLuaPosX(globalChallenge.x);
		getWorld():setLuaPosY(globalChallenge.y);
		getWorld():setLuaPosZ(globalChallenge.z);
	end
	getWorld():setLuaPlayerDesc(MainScreen.instance.desc)
	getWorld():getLuaTraits():clear()
	for i,v in pairs(self.charCreationProfession.listboxTraitSelected.items) do
		getWorld():addLuaTrait(v.item:getType())
	end
	MainScreen.instance.avatar = nil

    if ISPostDeathUI.instance[self.playerIndex] then
		ISPostDeathUI.instance[self.playerIndex]:removeFromUIManager()
		ISPostDeathUI.instance[self.playerIndex] = nil
	end

    CoopCharacterCreation.setVisibleAllUI(true)
--]]

Events.OnPlayerDeath.Add(OnPlayerDeath_SaveData);
Events.EveryOneMinute.Add(OnPlayerDeath_CheckPostRespawn);