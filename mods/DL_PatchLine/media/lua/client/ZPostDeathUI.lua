require "ISPostDeathUI";
local original_PostDeathUI_createChildren = ISPostDeathUI.createChildren;

LastX = nil;
LastY = nil;
LastZ = nil;
LastDesc = nil;
LastVisual = nil;
LastInv = nil;
LastWorn = nil;
LastName = { first = "", last = "" };
LastWRCName = nil;
LastGenderFemale = false;
LastProfession = nil;
LastTraits = {};
LastCorpse = nil;
LastBodyDamage = {};
LastAngle = nil;
LastXP = nil;

CheckPostRespawn = false;
local function OnPlayerDeath_CheckPostRespawn()
    
    if not CheckPostRespawn then return end;
    
    if not getPlayer():getInventory() then return end;

    print("Check Post Respawn");
    -- Go through all corpses in the square
    local inventory = getPlayer():getInventory();
    if not inventory then return end;

    -- Step 1, remove all items that aren't the KI5.PODCardGray.
    print("1 - removing player items except respawn pod.");
    local playerPrevItems = getPlayer():getInventory();
    local itemsToRemove = {};
    for prevItemNo = 0, playerPrevItems:getItems():size() - 1 do
        local item = playerPrevItems:getItems():get(prevItemNo);
        if item and item:getFullType() ~= "KI5.PODCardGray" then
            table.insert(itemsToRemove, item);
        end
    end

    print("2 - Finding player corpse.");

    LastCorpse = nil;
    if getPlayer():getSquare() then
        local objects = getPlayer():getSquare():getDeadBodys();

        if objects then
            for i = 0, objects:size() - 1 do
                local obj = objects:get(i);

                if instanceof(obj, "IsoDeadBody") then
                    local bodyContainer = obj:getContainer();
                    if bodyContainer then
                        local corpseTicket = bodyContainer:getItemFromType("Base.CorpseTicket");
                        if corpseTicket and corpseTicket:getModData().corpseOwner then
                            if corpseTicket:getModData().corpseOwner == getPlayer():getUsername() then
                                print("Found last corpse!");
                                print(corpseTicket:getFullType());
                                LastCorpse = obj;
                                break;
                            end
                        end
                    end
                end
            end
        end
    end

    if not LastCorpse then
        error("Unable to find player corpse. Something went wrong, submit a bug report.");
        CheckPostRespawn = false;
        return;
    end

    if LastCorpse and getPlayer():getModData().JaxeRevival_Incapacitated then
        print("Player corpse is not nil.");

        for i, _ in ipairs(itemsToRemove) do
            local itemToRemove = itemsToRemove[i];
            itemToRemove:getContainer():DoRemoveItem(itemToRemove);
        end

        print("Adding items from prev inventory.");
        local corpseContainer = LastCorpse:getContainer();
        for i, v in ipairs(LastInv) do
            print("Item " .. LastInv[i]:getFullType());
            getPlayer():getInventory():DoAddItem(LastInv[i]);
        end

        print("Drawing dirty");
        getPlayer():getInventory():setDrawDirty(true);
        corpseContainer:setDrawDirty(true);
        ISInventoryPage.renderDirty = true;

        print("Setting visual from");
        print(LastDesc)
        getPlayer():getVisual():clear();
        getPlayer():getVisual():copyFrom(LastVisual);
        getPlayer():getDescriptor():getHumanVisual():clear();
        getPlayer():getDescriptor():getHumanVisual():copyFrom(LastVisual);

        local wornItems = getPlayer():getWornItems();

        print("Player worn items setting...");
        for _, wornItem in ipairs(LastWorn) do
            if not getPlayer():getInventory():contains(wornItem:getItem()) then
                print("Worn item " .. wornItem:getItem():getFullType() .. " is not in inv, adding.");
                getPlayer():getInventory():DoAddItem(wornItem:getItem());
            end
            wornItems:setItem(wornItem:getLocation(), wornItem:getItem());
            getPlayer():getDescriptor():setWornItem(wornItem:getLocation(), wornItem:getItem());
            print("Set item " .. wornItem:getItem():getFullType() .. " as worn item in location " .. wornItem:getLocation());
        end

        print("Setting attached items.");
        getPlayer():setAttachedItems(LastCorpse:getAttachedItems());

        print("Trigger on clothing updated.");
        getPlayer():resetModel();
        triggerEvent("OnClothingUpdated", getPlayer());

        --print("Setting XP");
        --getPlayer():setXp(LastXP);

        print("Removing corpse from world!");
        LastCorpse:getSquare():removeCorpse(LastCorpse, false);
        LastCorpse = nil;

        print("Applying body damage.");
        if LastBodyDamage then
            local newBodyParts = getPlayer():getBodyDamage():getBodyParts();

            --getPlayer():setGodMod(false);

            for partNum = 0, newBodyParts:size() - 1 do
                local part = newBodyParts:get(partNum);
                local partType = tostring(part:getType());

                local savedPart = LastBodyDamage[partType];
                if savedPart then
                    part:setBleeding(savedPart.bleeding);
                    part:setBleedingTime(savedPart.bleedingTime);
                    part:SetBleedingStemmed(savedPart.bleedingStemmed);

                    part:setBandaged(savedPart.bandaged, savedPart.bandageLife);
                    part:setBandageType(savedPart.bandageType);

                    part:setHaveBullet(savedPart.bullet, 0);
                    part:setHaveGlass(savedPart.glass);

                    part:setDeepWounded(savedPart.deepWounded);
                    part:setDeepWoundTime(savedPart.deepWoundTime);

                    part:setStitched(savedPart.stitched);
                    part:setStitchTime(savedPart.stitchTime);
                end
            end
        end

        CheckPostRespawn = false;
    else
        print("No body damage saved!");
    end

    print("Syncing!");
    SyncXp(getPlayer());
    sendPlayerExtraInfo(getPlayer());

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

    w.charCreationHeader.genderCombo.selected = LastGenderFemale;
    if LastGenderFemale then
        MainScreen.instance.avatar:setFemale(true);
		MainScreen.instance.desc:setFemale(true);
		MainScreen.instance.desc:getHumanVisual():removeBodyVisualFromItemType("Base.M_Hair_Stubble")
		MainScreen.instance.desc:getHumanVisual():removeBodyVisualFromItemType("Base.M_Beard_Stubble")
	else
		MainScreen.instance.avatar:setFemale(false);
		MainScreen.instance.desc:setFemale(false);
		MainScreen.instance.desc:getHumanVisual():removeBodyVisualFromItemType("Base.F_Hair_Stubble")
	end

	w.charCreationHeader:randomGenericOutfit();
	w.charCreationHeader:setAvatarFromUI();
	w.charCreationProfession.instance:changeClothes();

    w.charCreationMain:initClothing();
    MainScreen.instance.desc:getHumanVisual():copyFrom(LastVisual);
    w.charCreationMain:initPlayer();

    w:accept();

    getPlayer():setX(LastX);
    getPlayer():setY(LastY);
    getPlayer():setZ(LastZ or 0);

    getPlayer():getDescriptor():getHumanVisual():copyFrom(LastVisual);
    getPlayer():getBodyDamage():setOverallBodyHealth(25);
    
    getPlayer():getDescriptor():setForename(LastName.first or string.split(getPlayer():getUsername(), " ")[1]);
    getPlayer():getDescriptor():setSurname(LastName.last or string.split(getPlayer():getUsername(), " ")[2]);
    WRC.Meta.SetName(LastWRCName or getPlayer():getDescriptor():getForename());

    -- Clear traits.
    getPlayer():getDescriptor():setProfession(LastProfession);

    getPlayer():getTraits():clear();
    for i, _ in ipairs(LastTraits) do
        getPlayer():getTraits():add(LastTraits[i]);
    end
    -- Set body damage.
    
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
    LastXP = getPlayer():getXp();

    LastDesc = getPlayer():getDescriptor();
    LastVisual = getPlayer():getHumanVisual();

    LastProfession = getPlayer():getDescriptor():getProfession();

    LastInv = {};
    local playerItems = getPlayer():getInventory():getItems();

    for i = 0, playerItems:size() - 1 do
        table.insert(LastInv, playerItems:get(i));
    end

    LastWorn = {};
    for i = 0, getPlayer():getWornItems():size() - 1 do
        local wornItem = getPlayer():getWornItems():get(i);

        table.insert(LastWorn, wornItem);
    end

    LastGenderFemale = getPlayer():isFemale();

    LastBodyDamage = {};
    LastCorpse = nil;
    local bodyParts = getPlayer():getBodyDamage():getBodyParts();
    for i = 0, bodyParts:size() - 1 do
        local part = bodyParts:get(i);

        if part then
            local savedDamage =
            {
                bleeding = part:bleeding(),
                bleedingTime = part:getBleedingTime(),
                bleedingStemmed = part:IsBleedingStemmed(),
                bandaged = part:bandaged(),
                bandageLife = part:getBandageLife(),
                bandageType = part:getBandageType(),
                bandageDirty = part:isBandageDirty(),
                bullet = part:haveBullet(),
                glass = part:haveGlass(),
                deepWounded = part:deepWounded(),
                deepWoundTime = part:getDeepWoundTime(),
                stitched = part:stitched(),
                stitchTime = part:getStitchTime()
            };

            local partType = tostring(part:getType());
            print("Saving body damage for part type " .. partType);

            LastBodyDamage[partType] = savedDamage;
        end
    end

    LastWRCName = WRC.Meta.GetName(getPlayer():getUsername()) or "";

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