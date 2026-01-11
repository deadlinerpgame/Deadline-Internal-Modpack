local WEAPON_TABLE = {
    "Base.Pistol",               -- M9
    "Base.ColtAce",
    "Base.ColtAnaconda",
    "Base.Pistol2",              -- M1911
    "Base.ColtPython",
    "Base.ColtPythonHunter",
    "Base.ColtPythonStubby",
    "Base.ColtPeacemaker",
    "Base.ColtSingleAction22",   -- Single Action Scout
    "Base.Pistol3",              -- Desert Eagle
    "Base.Glock17",
    "Base.Pistol_M45A1",
    "Base.Revolver_Long",        -- S&W M27
    "Base.Revolver_M29",         -- S&W M29
    "Base.Revolver_Short",       -- S&W M36
    "Base.Revolver",             -- S&W M625
    "Base.Pistol_Compact",       -- SIG Sauer M11
}

local AMMO_TABLE = {
    "Base.Bullets9mmBoxZ",
    "Base.Bullets22BoxZ",
    "Base.Bullets44BoxZ",
    "Base.Bullets45BoxZ",
    "Base.Bullets357BoxZ",
}

local function getRandomItem(lootTable)
    return lootTable[ZombRand(#lootTable) + 1]
end

local function setTempOwner(item, player)
    if item then
        local itemModData = item:getModData()
        itemModData.TempOwner = player:getUsername()
    end
end

local function addWeaponWithRandomCondition(inv, player)
    local item = inv:AddItem(getRandomItem(WEAPON_TABLE))
    if item then
        local newCondition = ZombRand(3, item:getConditionMax() + 1)
        item:setCondition(newCondition)
        setTempOwner(item, player)
    end
    return item
end

local function addLootToZombie(zombie, player)
    local roll = ZombRand(100) + 1
    local inv = zombie:getInventory()
    
    if roll <= 15 then
        addWeaponWithRandomCondition(inv, player)
    elseif roll <= 95 then
        local item = inv:AddItem(getRandomItem(AMMO_TABLE))
        setTempOwner(item, player)
    else
        addWeaponWithRandomCondition(inv, player)
        local item = inv:AddItem(getRandomItem(AMMO_TABLE))
        setTempOwner(item, player)
    end
end

local function onZombieDead(zombie)
    local player = getPlayer()
    if not player then return end
    local currentTime = getGameTime():getWorldAgeHours()
    local killer = zombie:getAttackedBy()
    if killer ~= player then return end
    
    local modData = player:getModData()

    modData.lootcounter = modData.lootcounter or 0
    print(modData.lootcounter)
    if modData.lootcounter < 5 then
        local roll = ZombRand(100) + 1
        
        if roll == 1 then
            modData.lootcounter = modData.lootcounter + 1
            modData.lootcounter_timestamp = modData.lootcounter_timestamp or currentTime
            addLootToZombie(zombie, player)
            
            if not modData.lootcountertimer then
                modData.lootcountertimer = 0
            end
        end
    end
end

local function onEveryHour()
    local player = getPlayer()
    if not player then return end   
    local modData = player:getModData()
    if modData.lootcounter and modData.lootcountertimer and modData.lootcounter_timestamp then
    print("Loot Counter(of 5): " .. modData.lootcounter .. "|Timer: " .. modData.lootcountertimer .. "|Timestamp: " .. modData.lootcounter_timestamp)
    end

    local modData = player:getModData()
    if modData.lootcountertimer and modData.lootcounter_timestamp then
        local currentTime = getGameTime():getWorldAgeHours()
        modData.lootcountertimer = currentTime - modData.lootcounter_timestamp
        if modData.lootcountertimer >= 650 then
            modData.lootcounter = 0
            modData.lootcountertimer = nil
        end
    end
end

local originalIsValid = ISInventoryTransferAction.isValid
function ISInventoryTransferAction:isValid()
    local item = self.item
    if item then
        local itemModData = item:getModData()
        if itemModData.TempOwner then
            local player = self.character
            local username = player:getUsername()

            if itemModData.TempOwner ~= username then
                getPlayer():Say("This isn't mine.")
            end
            
            if itemModData.TempOwner ~= username then
                return false
            end
        end
    end
    return originalIsValid(self)
end



local originalPerform = ISInventoryTransferAction.perform
function ISInventoryTransferAction:perform()
    local item = self.item
    if item then
        local itemModData = item:getModData()
        if itemModData.TempOwner then
            local player = self.character
            local username = player:getUsername()

            if itemModData.TempOwner == username then
                itemModData.TempOwner = nil
            end
        end
    end
    originalPerform(self)
end

Events.OnZombieDead.Add(onZombieDead)
Events.EveryHours.Add(onEveryHour)