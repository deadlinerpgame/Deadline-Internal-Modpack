require "MF_ISMoodle"

local RadF1 = getTexture("media/textures/GUI/F1.png"); 
local RadF2 = getTexture("media/textures/GUI/F2.png"); 
local RadF3 = getTexture("media/textures/GUI/F3.png"); 
local RadOverlay = getTexture("media/textures/GUI/radnoise.png"); 

local moodlerad = MF.getMoodle("MoodleRad");
local moodleradres = MF.getMoodle("MoodleRadRes");
local moodlegasmask = MF.getMoodle("MoodleGasMask");
local moodlehazmat = MF.getMoodle("MoodleHazmat");


local SuitSets = {
    NBC = {
        required = {
            "Base.Hat_NBCMask",
        },
        optional = {
            "AuthenticZLite.NBHHazmatSuit",
            "AuthenticZLite.NBHHazmatSuitNoShoes",
        },
    },
    SpaceSuit = {
        required = {
            "Base.AstronautSuit",
        },
        optional = {
            "Base.SpaceHelmet",
            "Base.AstroHelmet",
        },
    },
}

function table.contains(tbl, item)
    for _, value in ipairs(tbl) do
        if value == item then
            return true
        end
    end
    return false
end

function IsSuitSetEquipped(suitSet)
    local player = getPlayer()
    local inv = player:getWornItems()

    local hasRequired = {}
    local hasOptional = false

    for _, reqItem in ipairs(suitSet.required) do
        hasRequired[reqItem] = false
    end

    for i = 0, inv:size() - 1 do
        local wornItem = inv:getItemByIndex(i)
        if wornItem then
            local Type = wornItem:getFullType()

            if hasRequired[Type] ~= nil then
                hasRequired[Type] = true
            end

            if suitSet.optional and table.contains(suitSet.optional, Type) then
                hasOptional = true
            end
        end
    end

    for _, isEquipped in pairs(hasRequired) do
        if not isEquipped then
            return false
        end
    end

    return true
end

function IsItemGasMask(item)
    if not item then return false end;
    local itemType = item:getFullType();

    if string.find(itemType, "Gas") then return true end;
    if string.find(itemType, "PrepperMask") or string.find(itemType, "StalkerMask") then return true end;
    if string.find(itemType, "Respirator") and (not string.find(itemType, "Neck")) then return true end;
    if string.find(itemType, "NBCMask") then return true end;
    if item:hasTag("GasMask") then return true end;
    return false;
end

function IsGasMaskEquipped()
    local player = getPlayer()
    local inv = player:getWornItems()

    for i = 0, inv:size() - 1 do
        local wornItem = inv:getItemByIndex(i)
        local Type = wornItem:getFullType()
        if wornItem and IsItemGasMask(wornItem) then
            MF.getMoodle("MoodleGasMask"):setValue(0.1);
            return true;
        end
    end

    return false
end

function IsHazmatEquipped()
    local player = getPlayer()
    local inv = player:getWornItems()

    for i = 0, inv:size() - 1 do
        local wornItem = inv:getItemByIndex(i)
        local Type = wornItem:getFullType()
        if wornItem and (string.find(Type, "Hazmat")) then
            MF.getMoodle("MoodleHazmat"):setValue(0.1)
            return true 
        end
        for setName, suitSet in pairs(SuitSets) do
            if IsSuitSetEquipped(suitSet) then
                MF.getMoodle("MoodleHazmat"):setValue(0.1)
                return true
            end
        end
    end

    return false
end

function RemoveProtection()
    if IsHazmatEquipped() == false then
        MF.getMoodle("MoodleHazmat"):setValue(0.00)
    end
    if IsGasMaskEquipped() == false then
        MF.getMoodle("MoodleGasMask"):setValue(0.00)
    end
end

local isToxic
Counter = 0
Severity = 0

function GeigerCounter()
    local player = getPlayer()
    local modData = player:getModData();
    local radData = modData.RadPlayerData;
    local primaryItem = player:getPrimaryHandItem()
    local secondaryItem = player:getSecondaryHandItem()

    if not modData or not radData then return end;

    if radData.GCountType == 1 then
        Counter = Counter + 1   
        if Counter >= Severity then
            if primaryItem and primaryItem:getType() == "GeigerCounter" or secondaryItem and secondaryItem:getType() == "GeigerCounter"   then
                if ZombRand(1,5) == 1 then
                    getSoundManager():PlaySound("geigershort", false, 0):setVolume(1)
                    elseif ZombRand(1,5) == 2 then
                    getSoundManager():PlaySound("geigershort2", false, 0):setVolume(1)
                    elseif ZombRand(1,5) == 3 then
                    getSoundManager():PlaySound("geigershort3", false, 0):setVolume(1)
                    else
                    getSoundManager():PlaySound("geigershort4", false, 0):setVolume(1)
                    end
            end
            Severity = ZombRand(120,200);
            Counter = 0
        end

    elseif radData.GCountType == 2 then
        Counter = Counter + 1   
        if Counter >= Severity then
            if primaryItem and primaryItem:getType() == "GeigerCounter" or secondaryItem and secondaryItem:getType() == "GeigerCounter"   then
                if ZombRand(1,5) == 1 then
                    getSoundManager():PlaySound("geigershort", false, 0):setVolume(1)
                    elseif ZombRand(1,5) == 2 then
                    getSoundManager():PlaySound("geigershort2", false, 0):setVolume(1)
                    elseif ZombRand(1,5) == 3 then
                    getSoundManager():PlaySound("geigershort3", false, 0):setVolume(1)
                    else
                    getSoundManager():PlaySound("geigershort4", false, 0):setVolume(1)
                    end
            end
            Severity = ZombRand(55,140);
            Counter = 0
        end

    elseif radData.GCountType == 3 then
        Counter = Counter + 1   
        if Counter >= Severity then
            if primaryItem and primaryItem:getType() == "GeigerCounter" or secondaryItem and secondaryItem:getType() == "GeigerCounter"   then
                if ZombRand(1,5) == 1 then
                    getSoundManager():PlaySound("geigershort", false, 0):setVolume(1)
                    elseif ZombRand(1,5) == 2 then
                    getSoundManager():PlaySound("geigershort2", false, 0):setVolume(1)
                    elseif ZombRand(1,5) == 3 then
                    getSoundManager():PlaySound("geigershort3", false, 0):setVolume(1)
                    else
                    getSoundManager():PlaySound("geigershort4", false, 0):setVolume(1)
                    end
            end
            Severity = ZombRand(10,45);
            Counter = 0
        end

    elseif radData.GCountType == 4 then
        Counter = Counter + 1   
        if Counter >= Severity then
            if primaryItem and primaryItem:getType() == "GeigerCounter" or secondaryItem and secondaryItem:getType() == "GeigerCounter"   then
                if ZombRand(1,5) == 1 then
                    getSoundManager():PlaySound("geigershort", false, 0):setVolume(1)
                    elseif ZombRand(1,5) == 2 then
                    getSoundManager():PlaySound("geigershort2", false, 0):setVolume(1)
                    elseif ZombRand(1,5) == 3 then
                    getSoundManager():PlaySound("geigershort3", false, 0):setVolume(1)
                    else
                    getSoundManager():PlaySound("geigershort4", false, 0):setVolume(1)
                    end
            end
            Severity = ZombRand(10,30);
            Counter = 0
        end
    end
end

function isInRadiationZone()
    RemoveProtection()


    local player = getPlayer()
    local modData = player:getModData();
    local radData = modData.RadPlayerData;
    local playerObj = getPlayer()
    local secondaryItem = playerObj:getPrimaryHandItem()
    RadValue = MF.getMoodle("MoodleRad"):getValue()
    RadResValue = MF.getMoodle("MoodleRadRes"):getValue()
    if player:isDead() or RadValue == nil then
        RadValueNoise = 0
    else
        RadValueNoise = 1 - RadValue
    end
    if radData.GCountType == nil then radData.GCountType = 0; end
    if modData.RadPlayerData == nil then
        modData.RadPlayerData = {};
        local radData = modData.RadPlayerData;
        radData.MRadValue = 1;
        radData.MRadResValue = 0;
        radData.GCountType = 0;
    end
	
    if RadValue < 1 then
        MF.getMoodle("MoodleRad"):setValue(RadValue + 0.005);
    end
    if RadValue < 0 then
        RadValue = 0
    end
    if RadValue > 1 then
        MF.getMoodle("MoodleRad"):setValue(1);
    end
    if RadResValue > 0 then
        MF.getMoodle("MoodleRad"):setValue(RadValue + 0.005);
    end

    if RadValue < 1 then
        player:getBodyDamage():ReduceGeneralHealth(RadValueNoise)
    end
    local radData = modData.RadPlayerData;
    radData.MRadValue = RadValue
    radData.MRadResValue = RadResValue
    local isWithinZone = false

	local RadiationZone = ModData.getOrCreate("RadiationZone")
	if RadiationZone == nil then 
		ModData.request("RadiationZone")
		RadiationZone = ModData.get("RadiationZone")
	end
    for i, w in pairs(RadiationZone) do
		local zone = i
		local startX = w.startX
		local startY = w.startY
		local endX = w.endX
		local endY = w.endY
        local radsLevel = w.radLevel

		if startX > endX then
			startX = w.endX
			endX = w.startX
		end
		if startY > endY then
			startY = w.endY
			endY = w.startY
		end

local minX = math.min(startX, endX)
local maxX = math.max(startX, endX)
local minY = math.min(startY, endY)
local maxY = math.max(startY, endY)

local expandedMinX_2 = minX - 2
local expandedMaxX_2 = maxX + 2
local expandedMinY_2 = minY - 2
local expandedMaxY_2 = maxY + 2

local expandedMinX_5 = minX - 5
local expandedMaxX_5 = maxX + 5
local expandedMinY_5 = minY - 5
local expandedMaxY_5 = maxY + 5

local playerX = player:getX()
local playerY = player:getY()

if playerX >= minX and playerX <= maxX and playerY >= minY and playerY <= maxY then
    isToxic = true
    isWithinZone = true

    local intensity = tonumber(radsLevel)
    if intensity == 1 then
        if IsHazmatEquipped() == true then
        elseif IsGasMaskEquipped() == true then
        else
            MF.getMoodle("MoodleRad"):setValue(RadValue - 0.00888889)
  
        end
        radData.GCountType = 1
    elseif intensity == 2 then
        if IsHazmatEquipped() == true then
            MF.getMoodle("MoodleRad"):setValue(RadValue - 0.00222222)
        elseif IsGasMaskEquipped() == true then
            MF.getMoodle("MoodleRad"):setValue(RadValue - 0.00666667)
        else
            MF.getMoodle("MoodleRad"):setValue(RadValue - 0.02666667)
        end
        radData.GCountType = 2

    elseif intensity == 3 then
        if IsHazmatEquipped() == true then
            MF.getMoodle("MoodleRad"):setValue(RadValue - 0.00666667)
        elseif IsGasMaskEquipped() == true then
            MF.getMoodle("MoodleRad"):setValue(RadValue - 0.02666667)
        else
            MF.getMoodle("MoodleRad"):setValue(RadValue - 0.13333333)
        end
        radData.GCountType = 3

    elseif intensity == 4 then
            MF.getMoodle("MoodleRad"):setValue(RadValue - 0.13333333)
            radData.GCountType = 4

    end
    break

elseif (playerX >= expandedMinX_2 and playerX <= expandedMaxX_2 and playerY >= expandedMinY_2 and playerY <= expandedMaxY_2) and
       not (playerX >= minX and playerX <= maxX and playerY >= minY and playerY <= maxY) then
    isToxic = true
    isWithinZone = true

    if intensity == 2 then
        if IsHazmatEquipped() == true then
        elseif IsGasMaskEquipped() == true then
        else
            MF.getMoodle("MoodleRad"):setValue(RadValue - 0.00888889)
        end
        radData.GCountType = 1

    elseif intensity == 3 then
        if IsHazmatEquipped() == true then
            MF.getMoodle("MoodleRad"):setValue(RadValue - 0.00222222)
        elseif IsGasMaskEquipped() == true then
            MF.getMoodle("MoodleRad"):setValue(RadValue - 0.00666667)
        else
            MF.getMoodle("MoodleRad"):setValue(RadValue - 0.02666667)
        end
        radData.GCountType = 2

    elseif intensity == 4 then
            MF.getMoodle("MoodleRad"):setValue(RadValue - 0.13333333)
            radData.GCountType = 4
    end
    break


elseif (playerX >= expandedMinX_5 and playerX <= expandedMaxX_5 and playerY >= expandedMinY_5 and playerY <= expandedMaxY_5) and
       not (playerX >= expandedMinX_2 and playerX <= expandedMaxX_2 and playerY >= expandedMinY_2 and playerY <= expandedMaxY_2) and
       not (playerX >= minX and playerX <= maxX and playerY >= minY and playerY <= maxY) then
        isToxic = true
        isWithinZone = true
if intensity == 3 then
    if IsHazmatEquipped() == true then
    elseif IsGasMaskEquipped() == true then
    else
        MF.getMoodle("MoodleRad"):setValue(RadValue - 0.00888889)
    end
    radData.GCountType = 1

elseif intensity == 4 then
    MF.getMoodle("MoodleRad"):setValue(RadValue - 0.02666667)
    radData.GCountType = 4
    end
    break

else

end

	end
    if not isWithinZone then
        radData.GCountType = 0
        isToxic = false
    end
	return isToxic
end
local frameCount = 0
local frameRate = 2
local texture

function UpFrame()
    frameRate = frameRate + 1
    if frameRate >= 2 then
        if texture == RadF1 then
            texture = RadF2
        elseif texture == RadF2 then
            texture = RadF3
        else
            texture = RadF1
        end
    frameRate = 0
    end
end

function drawSmoke()
    if RadValueNoise == nil then
        RadValueNoise = 0
    end
    if RadValueNoise > 0 then
        if getPlayer():isGodMod() then return end
        if RadValueNoise == 0.5 then
            lvl = 0
            local w   = getPlayerScreenWidth(1)
            local h   = getPlayerScreenHeight(1)
            UIManager.DrawTexture(texture, 0, 0, w, h, lvl)
        elseif IsGasMaskEquipped() == false then
            lvl = RadValueNoise / 10
            local w   = getPlayerScreenWidth(1)
            local h   = getPlayerScreenHeight(1)
            UIManager.DrawTexture(texture, 0, 0, w, h, lvl)
        elseif IsHazmatEquipped() == false then
            lvl = RadValueNoise / 10
            local w   = getPlayerScreenWidth(1)
            local h   = getPlayerScreenHeight(1)
            UIManager.DrawTexture(texture, 0, 0, w, h, lvl)
        else
            lvl = RadValueNoise / 20
            local w   = getPlayerScreenWidth(1)
            local h   = getPlayerScreenHeight(1)
            UIManager.DrawTexture(texture, 0, 0, w, h, lvl)
        end
        UpFrame();
    end
end

Events.OnPreUIDraw.Add(drawSmoke)

Events.EveryOneMinute.Add(isInRadiationZone)
Events.OnTick.Add(GeigerCounter)

function SyncZones()
    ModData.request("RadiationZone")
end

function createModData()
    local player = getPlayer()
    local modData = player:getModData();
    local radData = modData.RadPlayerData;
    if modData.RadPlayerData == nil then
        modData.RadPlayerData = {};

        radData.MRadValue = 1;
        radData.MRadResValue = 0;
        radData.GCountType = 0;
    end
    if radData.MRadValue == 0.5 then
        radData.MRadValue = 1;
        radData.MRadResValue = 0;
        radData.GCountType = 0;
    end
    MF.getMoodle("MoodleRad"):setValue(radData.MRadValue)
    MF.getMoodle("MoodleRadRes"):setValue(radData.MRadResValue)
end

function ResetRads()
    local player = getPlayer()
    local modData = player:getModData();
    local radData = modData.RadPlayerData;
    radData.MRadValue = 1;
    radData.MRadResValue = 0;
    radData.GCountType = 0;
    MF.getMoodle("MoodleRad"):setValue(radData.MRadValue)
    MF.getMoodle("MoodleRadRes"):setValue(radData.MRadResValue)
end

Events.OnConnected.Add(SyncZones)

Events.OnCreatePlayer.Remove(createModData);
Events.OnCreatePlayer.Add(createModData);
Events.OnPlayerDeath.Add(ResetRads);