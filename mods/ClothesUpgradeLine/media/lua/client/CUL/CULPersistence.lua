local reapplying = false

local function safeReapply(character)
    if not character or reapplying then return end
    reapplying = true
    ClothesUpgrade.reapplyForCharacter(character)
    reapplying = false
end

local function onLoadCharacter(character)
    if not character then return end
    ClothesUpgrade.revertStalePreviews(character)
    safeReapply(character)
end

local function reapplyAllPlayers()
    for i = 0, 3 do
        local plr = getSpecificPlayer(i)
        if plr then onLoadCharacter(plr) end
    end
end

local function onCreatePlayer(playerIndex, player)
    onLoadCharacter(player)
end

local function onEquipOrWear(character, item)
    if character then safeReapply(character) end
end

local function onClothingUpdated(character)
    if instanceof(character, "IsoPlayer") and character:isLocalPlayer() then safeReapply(character) end
end

local function reapplyLocalPlayers()
    for i = 0, 3 do
        local plr = getSpecificPlayer(i)
        if plr then safeReapply(plr) end
    end
end

local function addEvent(name, fn)
    if Events[name] then Events[name].Add(fn) end
end

addEvent("OnGameStart", reapplyAllPlayers)
addEvent("OnCreatePlayer", onCreatePlayer)
addEvent("OnEquipPrimary", onEquipOrWear)
addEvent("OnEquipSecondary", onEquipOrWear)
addEvent("OnClothingUpdated", onClothingUpdated)
addEvent("EveryTenMinutes", reapplyLocalPlayers)
