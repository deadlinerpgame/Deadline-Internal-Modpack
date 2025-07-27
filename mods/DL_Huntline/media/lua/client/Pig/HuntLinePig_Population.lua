
HuntLinePig = HuntLinePig or {}



HuntLinePig.CorpseCheck = {
    ['Base.AnimalPig']={["isAnimalCorpse"]=true, ["drop"]="Base.Pig_Dead"},
}






function HuntLinePig.getCorpseFtype(zed)
    local visuals = zed:getItemVisuals()
    local fType
    local textures = {}
    for i = 0, visuals:size() - 1 do
        local visual = visuals:get(i)
        local clo = visual:getClothingItem()
        local cloName = visual:getClothingItemName()

        if cloName == "AnimalPig" then
            local choice = visual:getTextureChoice()
            local textureChoicesStr = tostring(clo:getTextureChoices())  --  userdata
            local searchStr = tostring(cloName).."_Texture_[A-F]"
            for texture in string.gmatch(textureChoicesStr, searchStr) do
                table.insert(textures, texture)
            end
            local textName = textures[choice + 1]
            if textName then
				local pose = ZombRand(1,4)
                local letter = string.upper(string.sub(textName, -1))  -- last letter
                fType = tostring(cloName).."_Dead_"..tostring(letter)..tostring(pose)
            end
        end
    end
    return fType
end

--print(getCorpseToSpawn(dbgZed))

function HuntLinePig.handleCorpse(corpse)
    if  HuntLinePig.isDeadAnimal(corpse) or corpse:getModData()['Animal_fType']  then
        local tab = HuntLinePig.CorpseCheck
        local w = corpse:getWornItems()
        for i = 0, w:size() - 1 do
            local item = w:getItemByIndex(i)
            if item then
                local fType = item:getName()
                if fType and tab[fType] then
                    local isAnimalCorpse = tab[fType].isAnimalCorpse
                    if isAnimalCorpse then
                        --local drop = tostring(tab[fType].drop)..tostring(ZombRand(1,5))
                        local drop = corpse:getModData()['Animal_fType']
                        local sq = corpse:getSquare()
                        if sq then


                                sq:removeCorpse(corpse, isClient())



                        end
                    end
                end
            end
        end
    end
end

function HuntLinePig.CorpseCleaner()
    local rad = 8
    local pl = getPlayer(); if not pl then return end
    local cell = pl:getCell()
    local x, y, z = pl:getX(), pl:getY(), pl:getZ()
    for xDelta = -rad, rad do
        for yDelta = -rad, rad do
            local sq = cell:getOrCreateGridSquare(x + xDelta, y + yDelta, z)
            if sq then
                local corpse = IsoObjectPicker.Instance:PickCorpse(sq:getX(), sq:getY()) or sq:getDeadBody()
                if corpse and instanceof(corpse, "IsoDeadBody") then

                        HuntLinePig.handleCorpse(corpse)

                end
            end
        end
    end
end
Events.EveryOneMinute.Remove(HuntLinePig.CorpseCleaner)
Events.EveryOneMinute.Add(HuntLinePig.CorpseCleaner)


function HuntLinePig.isDeadAnimal(corpse)
	if not corpse or not instanceof(corpse, "IsoDeadBody") then return false end
    if corpse:getModData()['PigAnimal_Init'] then return true end
    local fit = tostring(corpse:getOutfitName())
    if fit == HuntLinePig.outfit1 then return true end
    if fit == HuntLinePig.outfit2 then return true end
    if fit == HuntLinePig.outfit0 then return true end
    
	return false
end

-----------------------            ---------------------------

function HuntLinePig.getSpawnRandomZedInfo(fit)
    local maleOutfits = getAllOutfits(false)
    local femaleOutfits = getAllOutfits(true)
    local allOutfits = {}

    for i = 0, maleOutfits:size() - 1 do
        table.insert(allOutfits, maleOutfits:get(i))
    end
    for i = 0, femaleOutfits:size() - 1 do
        table.insert(allOutfits, femaleOutfits:get(i))
    end

    if not fit or fit == '' then
        fit = allOutfits[ZombRand(#allOutfits) + 1]
    end

    local outfitExists = false
    for _, outfit in ipairs(allOutfits) do
        if outfit == fit then
            outfitExists = true
            break
        end
    end

    if not outfitExists then
        fit = allOutfits[ZombRand(#allOutfits) + 1]
    end

    if maleOutfits:contains(fit) and femaleOutfits:contains(fit) then
        return fit, 0
    elseif femaleOutfits:contains(fit) then
        return fit, 100
    else
        return fit, 0
    end
end

function HuntLinePig.doDespawn(zed)
    if zed:isAlive() then
        zed:setAvoidDamage(false)
        zed:changeState(ZombieOnGroundState.instance())
        zed:setAttackedBy(getCell():getFakeZombieForHit())
        zed:becomeCorpse()

         zed:removeFromWorld();
        zed:removeFromSquare(); 
     else
        local sq = zed:getSquare()
        sq:removeCorpse(zed, isClient());
    end
end

function HuntLinePig.doSpawn(sq, isDown, outfit)
    if sq then
        local x, y, z = sq:getX(), sq:getY(), sq:getZ()
        if isClient() then

            local fit, fChance = HuntLinePig.getSpawnRandomZedInfo()

            if outfit and outfit ~= '' then
                fit, fChance = HuntLinePig.getSpawnRandomZedInfo(outfit)
            end
            sendClientCommand('HuntLinePig', 'doSpawn', {x = x, y = y, z = z, count = 1, fit = fit, fChance = fChance, isDown = isDown})
        else
            addZombiesInOutfit(x, y, z, 1, tostring(fit), 100, false, false, false, false, 2);
        end
    end
end

function HuntLinePig.doLocalSpawn(sq, outfit)
	local pl = getPlayer()
	local sq = pl:getSquare():getAdjacentSquare(pl:getDir());

    if sq then
        if isClient() then
            SendCommandToServer(string.format("/createhorde2 -x %d -y %d -z %d -count %d -radius %d -crawler %s -isFallOnFront %s -isFakeDead %s -knockedDown %s -health %s -outfit %s ", sq:getX(), sq:getY(), sq:getZ(), 1, 4, tostring(true), tostring(true), tostring(false), tostring(true), tostring(2), "Overgrown"))
            return
        end
	end
    addZombiesInOutfit(x, y, z, 1, tostring(fit), 100, false, false, false, false, 2);
end
