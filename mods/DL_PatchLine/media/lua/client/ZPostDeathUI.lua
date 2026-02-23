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

    -- Go through all corpses in the square
    local playerSq = getPlayer():getSquare();
    local objects = playerSq:getDeadBodys();

    local playerCorpse = nil;

    if objects then
        for i = 0, objects:size() - 1 do
            local obj = objects:get(i);

            if instanceof(obj, "IsoDeadBody") and obj:isPlayer() then
                for j = 0, obj:getContainer():getItems() do
                    local bodyItem = obj:getContainer():getItems():get(j);
                    if bodyItem:getType() == "Base.CorpseTicket" and bodyItem:getModData().corpseOwner == getPlayer():getUsername() then
                        playerCorpse = obj;
                        break;
                    end
                end
            end
        end
    end

    if playerCorpse then
        getPlayer():setContainer(playerCorpse:getInventory());
        getPlayer():setWornItems(playerCorpse:getWornItems());
        getPlayer():setAttachedItems(playerCorpse:getAttachedItems());

        playerCorpse:removeFromWorld();
        playerCorpse:removeFromSquare();
    end

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