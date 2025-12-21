HORSE_ITEM_TYPES = {
    ["2TK_models.2TK_Horse"] = true,
    ["2TK_models.2TK_Horse_01"] = true,
    ["2TK_models.2TK_Horse_02"] = true,
    ["2TK_models.2TK_Horse_03"] = true,
    ["2TK_models.2TK_Horse_04"] = true,
}

HORSE_FEED_TYPES = {
    "Base.Apple",
    "Base.Banana",
    "Base.Carrots",
    "Base.SugarBeet",
    "Base.BellPepper",
    "Base.Pear",
    "Sprout.Wheat",
    "DeadlineHorse.FoodHorseA",
    "DeadlineHorse.FoodHorseB",

}

HORSE_WATER_TYPES = {
    "Base.WaterBottleFull",
    "Base.WaterPopBottle",
    "aerx.ClayJarWater",
    "Base.BucketWaterFull",
    "Base.WaterPot",
}

local function initHorseStats(item)
    if not item then return end
    local data = item:getModData()

    if not data._initialized then
        data.health = ZombRand(300, 401)
        data.maxHealth = data.health
        data.speedModifier = ZombRandFloat(1.2, 1.7)
        data.horseSpeed = data.horseSpeed or 0.0
        data._coastTime = data._coastTime or 0
        data._coastDir = data._coastDir or nil
        data.maxHorseSpeed = 0
        data.hunger = 300
        data.maxHunger = 300
        data.thirst = 300
        data.maxThirst = 300
        data.stamina = 300
        data.maxStamina = 300
        data.owner = "THEREISNOCLAIMANT"
        data.riders = {}
        data.oldName = ""

        data._initialized = true


    end
end


local function onTickHorseInit()
    
    local player = getPlayer()
    if not player or player:isDead() then return end

    local inventory = player:getInventory()
    if not inventory then return end

    local items = inventory:getItems()
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if item and HORSE_ITEM_TYPES[item:getFullType()] then
            player:setIgnoreAutoVault(true);
            initHorseStats(item)
        else
        player:setIgnoreAutoVault(false);
        end
    end
end

Events.OnTick.Add(onTickHorseInit)


local function horseContextMenu(player, context, items)
    for _, entry in ipairs(items) do
        local item = entry
        if type(entry) == "table" and entry.items then
            item = entry.items[1]
        end

        if item and HORSE_ITEM_TYPES[item:getFullType()] then
            local data = item:getModData()
            if data and data._initialized then
                local player = getPlayer()
                local mounted = item:getContainer() == player:getInventory()
        if not mounted then
            
            if data.owner == "" or data.owner == "THEREISNOCLAIMANT" then
                context:addOption("Claim", player, claimHorse, item)
            elseif data.owner == player:getUsername() then
                context:addOption("Mount", item, doMount, player)
                context:addOption("Rename", player, renameHorse, item)
                context:addOption("Unclaim", player, unclaimHorse, item)
            end

            if player:getAccessLevel() == "admin" or isDebugEnabled() then
                context:addOption("ADMIN Mount", item, doMount, player)
                context:addOption("ADMIN Unclaim", player, unclaimHorseAdmin, item)
            end
            local menuOption = context:addOption("Feed", worldobjects); 
            local subMenu = ISContextMenu:getNew(context);
            context:addSubMenu(menuOption, subMenu);
            
        for _, foodType in ipairs(HORSE_FEED_TYPES) do
            local foodItem = player:getInventory():FindAndReturn(foodType)
            local scriptManager = getScriptManager()
            local name = scriptManager:getItem(foodType):getDisplayName()
            local opt
            local hunger    
            if foodItem and (not foodItem:IsFood() or not foodItem:isRotten()) then
                opt = subMenu:addOption(name, player, onFeedHorse, item, foodItem)
                hunger = (Math.abs(foodItem:getHungerChange() * 100))
                local tip = ISToolTip:new()
                tip:initialise()
                tip.description = "Will restore up to " .. hunger .. " hunger."
                opt.toolTip = tip
            else
                opt = subMenu:addOption(name)
                opt.notAvailable = true
            end

        end

             local menuOption = context:addOption("Give Water", worldobjects); 
             local subMenu = ISContextMenu:getNew(context);
             context:addSubMenu(menuOption, subMenu);
        for _, foodType in ipairs(HORSE_WATER_TYPES) do
            local foodItem = player:getInventory():FindAndReturn(foodType)
            local scriptManager = getScriptManager()
            local name = scriptManager:getItem(foodType):getDisplayName()
            if foodItem and (not foodItem:IsFood() or not foodItem:isRotten()) then
                subMenu:addOption(name, player, onFeedHorse, item, foodItem)
            else
                local i = subMenu:addOption(name)
                i.notAvailable = true
            end
        end
            
        elseif mounted then
            context:addOption("Dismount", item, doDismount, player)
        end
        local nearWater, X, Y, Z = checkWater(player)
        if nearWater then
            context:addOption("Drink", player, onDrinkGroundWater, item, x, y, z)
        end

                context:addOption("Horse Stats", nil, nil)

                context:addOption("Health: " .. math.floor(data.health) .. " / " .. math.floor(data.maxHealth), nil, nil)
                context:addOption("Stamina: " .. math.floor(data.stamina) .. " / " .. math.floor(data.maxStamina), nil, nil)
                context:addOption("Hunger: " .. math.floor(data.hunger) .. " / " .. math.floor(data.maxHunger), nil, nil)
                context:addOption("Thirst: " .. math.floor(data.thirst) .. " / " .. math.floor(data.maxThirst), nil, nil)
                context:addOption("Speed: " .. string.format("%.2f", data.speedModifier) .. "x", nil, nil)
            else
                context:addOption("Reassure Horse", player, reassureHorse, item)
            end
        end
    end
end

Events.OnFillInventoryObjectContextMenu.Add(horseContextMenu)

lastHorseUpdateTime = 0
lastHorseStepTime = 0


local function updateHorseStatsTick()
   
    local player = getPlayer()
    if not player or player:isDead() then return end

    local inventory = player:getInventory()
    if not inventory then return end

    local horse = player:getWornItem("Horse")
    if not horse then return end

    local data = horse:getModData()
    if not data or not data._initialized then return end

local now = getTimestampMs()

if lastHorseUpdateTime == 0 then
    lastHorseUpdateTime = now
    return
end

if now - lastHorseUpdateTime < 250 then return end

local delta = (now - lastHorseUpdateTime) / 1000.0
lastHorseUpdateTime = now

    local isSprinting = player:isSprinting()
    local isRunning = player:isRunning()
    local isMoving = player:isPlayerMoving()
    local stats = player:getStats()

-- Exhaustion trigger
if data.stamina <= 0 and not data._exhaustedDebuff then
    data._exhaustedDebuff = true
    data._exhaustedPhase = "stunned"      -- initial phase
    data._exhaustedStartTime = getTimestampMs()

    -- Play sound
    if isClient() then
        getSoundManager():PlayWorldSound("horse_stop_01", player:getSquare(), 0, 5, 5, false)
    else
        getSoundManager():playUISound("horse_stop_01")
    end
        player:setBlockMovement(true)


        data.maxHorseSpeed = 0
        data.horseSpeed = 0
    SpeedFramework.SetPlayerSpeed(player, 0.0)
end


if data._exhaustedDebuff and data._exhaustedPhase == "stunned" then
    local elapsed = getTimestampMs() - (data._exhaustedStartTime or 0)
    if elapsed >= 3000 then -- stunned for 1 second
        data._exhaustedPhase = "slowed"
        player:setBlockMovement(false)
        SpeedFramework.SetPlayerSpeed(player, 0.33)

    end
end

    if data.health <= 0 then
        
        if isClient() then
            getSoundManager():PlayWorldSound("horse_stop_01", player:getSquare(), 0, 5, 5, false)
        else
            getSoundManager():playUISound("horse_stop_01")
        end

        if inventory:contains("2TK_models.2TK_Horse") or inventory:contains("2TK_models.2TK_Horse_01") or inventory:contains("2TK_models.2TK_Horse_02") or inventory:contains("2TK_models.2TK_Horse_03") or inventory:contains("2TK_models.2TK_Horse_04") then
            if inventory:contains("2TK_models.2TK_Horse") then inventory:Remove("2TK_Horse") 
            elseif inventory:contains("2TK_models.2TK_Horse_01") then inventory:Remove("2TK_Horse_01") 
            elseif inventory:contains("2TK_models.2TK_Horse_02") then inventory:Remove("2TK_Horse_02") 
            elseif inventory:contains("2TK_models.2TK_Horse_03") then inventory:Remove("2TK_Horse_03") 
            elseif inventory:contains("2TK_models.2TK_Horse_04") then inventory:Remove("2TK_Horse_04") 
            end
            local square = player:getSquare()
            local x = square:getX()
            local y = square:getY()
            local z = square:getZ()
            print(x)
            local c = InventoryItemFactory.CreateItem("2TK_models.2TK_Horse_Carcass")
	        c:setAge(0)
            square:AddWorldInventoryItem(c, 0,0,0)

            player:setWornItem("Horse", nil, false)
            triggerEvent("OnClothingUpdated", player)
            ISInventoryPage.renderDirty = true
            player:getInventory():setDrawDirty(true)
        end
    end

if data.stamina > 15 and data._exhaustedDebuff then
    SpeedFramework.SetPlayerSpeed(player, nil)
    data._exhaustedDebuff = false
    data._exhaustedPhase = nil
    data._exhaustedStartTime = nil
    player:setBlockMovement(false)
end

    if isRunning or isSprinting then
        local currentEndurance = stats:getEndurance()
        stats:setEndurance(math.min(1.0, currentEndurance + 0.01))
    end

    if isSprinting and not data._exhaustedDebuff then
        data.hunger = data.hunger - (0.3 * delta)
        data.thirst = data.thirst - (0.5 * delta)
    elseif isRunning and not data._exhaustedDebuff then
        data.hunger = data.hunger - (0.2 * delta)
        data.thirst = data.thirst - (0.3 * delta)
    else
        data.hunger = data.hunger - (0.02 * delta)
        data.thirst = data.thirst - (0.05 * delta)
    end

    if data.hunger >= 300 and data.thirst >= 300 and not isMoving then
        data.health = math.max(0, data.health + (0.5 * delta))
    end

    if data.hunger <= 0 or data.thirst <= 0 and isMoving then
        data.health = math.max(0, data.health - (0.5 * delta))
    end

    if isSprinting and not data._exhaustedDebuff then
        data.stamina = math.max(0, data.stamina - (35 * delta))
    elseif isRunning and not data._exhaustedDebuff then
        data.stamina = math.max(0, data.stamina - (10 * delta))
    elseif data._exhaustedDebuff or not isSprinting and not isRunning and not isMoving then
        data.stamina = math.min(data.maxStamina, data.stamina + (15 * delta))
    else
        data.stamina = math.min(data.maxStamina, data.stamina + (5 * delta))
    end

local stepInterval = 500
local variants = nil

if isSprinting and not data._exhaustedDebuff then
    stepInterval = 400
    variants = { "horse_run_01", "horse_run_02", "horse_run_03", "horse_run_04" }
elseif isRunning and not data._exhaustedDebuff then
    stepInterval = 500
    variants = { "horse_run_01", "horse_run_02", "horse_run_03", "horse_run_04" }
elseif not isRunning and not isSprinting and isMoving then
    stepInterval = 500 
    variants = { "horse_walk_01", "horse_walk_02", "horse_walk_03" }
elseif data._exhaustedDebuff and isMoving then
    stepInterval = 500 
    variants = nil
end

if variants and  now - lastHorseStepTime >= stepInterval then
    lastHorseStepTime = now



      local sound = variants[ZombRand(#variants) + 1]      
      if isClient() and sound then
         getSoundManager():PlayWorldSound(sound, player:getSquare(), 0, 5, 5, false);  
      else
         getSoundManager():playUISound(tostring(sound))
      end
end
    if lastHorseUpdateTime == 0 then
        lastHorseUpdateTime = now
        return
    end



    local ACCELERATION_RATE = 1
    local DECELERATION_RATE = 0.7


        if isSprinting then
            data.maxHorseSpeed = 1.3 * data.speedModifier
        elseif isRunning then
            data.maxHorseSpeed = 1.1 * data.speedModifier
        elseif data._exhaustedDebuff then
            data.maxHorseSpeed = 0.0
        else
            data.maxHorseSpeed = 1.15
        end

    if isMoving then
        data.horseSpeed = math.min(data.maxHorseSpeed, data.horseSpeed + (ACCELERATION_RATE * delta))
    elseif data._exhaustedDebuff then
        data.horseSpeed = 0.0
    else
        data.horseSpeed = math.max(0.0, data.horseSpeed - (DECELERATION_RATE * delta))
    end

    if data.horseSpeed > 0.01 and not data._exhaustedDebuff then
        SpeedFramework.SetPlayerSpeed(player, data.horseSpeed)
    elseif not data._exhaustedDebuff then
        SpeedFramework.SetPlayerSpeed(player, nil)
    end

    

local isPressingMovement =
    isKeyDown(Keyboard.KEY_W) or
    isKeyDown(Keyboard.KEY_A) or
    isKeyDown(Keyboard.KEY_S) or
    isKeyDown(Keyboard.KEY_D)

if not isPressingMovement and data.horseSpeed > 0.5 and data.stamina <= 5 and not data._exhaustedDebuff  then
    player:setBlockMovement(true)
    local elapsed = getTimestampMs() - (data._exhaustedStartTime or 0)
    if elapsed >= 3000 then
        player:setBlockMovement(false)
    end   
end

data.stamina = math.max(0, data.stamina)
data.hunger = math.max(0, data.hunger)
data.thirst = math.max(0, data.thirst)
data.health = math.max(0, data.health)

end

Events.OnTick.Add(updateHorseStatsTick)


function doMount(item, player)

    localtext = player:getUsername() .. " has mounted a horse with name " .. item:getName() .. " at coordinates " .. math.floor(getPlayer():getX()) .. " " .. math.floor(getPlayer():getY()) .. " " .. math.floor(getPlayer():getZ()) .. " "
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Horses", logText = localtext})
    ISTimedActionQueue.add(HorseMount:new(player, item, true))

end


function doDismount(item, player)
    localtext = player:getUsername() .. " has dismounted a horse with name " .. item:getName() .. " at coordinates " .. math.floor(getPlayer():getX()) .. " " .. math.floor(getPlayer():getY()) .. " " .. math.floor(getPlayer():getZ()) .. " "
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Horses", logText = localtext})

    local sq = player:getSquare()
    local x, y, z = player:getX() - math.floor(sq:getX()), player:getY() - math.floor(sq:getY()), player:getZ() - math.floor(sq:getZ())
    local rot = player:getDirectionAngle() + 180
    if rot > 360 then
        rot = rot - 360
    end
    ISTimedActionQueue.add(HorseMount:new(player, item, false, sq, x, y, z, rot))
end


function cleanMenu(playerID, context, items)
    items = ISInventoryPane.getActualItems(items)
    local isHorse = false
    for i = 1, #items do
        local item = items[i]
        if HORSE_ITEM_TYPES[item:getFullType()] then
            isHorse = true
            break
        end
    end
    if not isHorse then
        return
    end
    local toRemove = {}
    for i = 1, #context.options do
        local option = context.options[i]
        if option.onSelect == ISInventoryPaneContextMenu.onWearItems
        or option.onSelect == ISInventoryPaneContextMenu.wearItem
        or option.onSelect == ISInventoryPaneContextMenu.onUnEquip
        or option.onSelect == ISInventoryPaneContextMenu.onDropItems
        or option.onSelect == ISInventoryPaneContextMenu.onGrabItems then
            table.insert(toRemove, option.name)
        end
    end
    for i = 1, #toRemove do
        local name = toRemove[i]
        context:removeOptionByName(name)
    end
end

Events.OnFillInventoryObjectContextMenu.Add(cleanMenu)

function checkWater(player)
    local playerX = math.floor(player:getX())
    local playerY = math.floor(player:getY())
    local playerZ = player:getZ()
    
    for x = playerX - 1, playerX + 1 do
        for y = playerY - 1, playerY + 1 do
            local square = getCell():getGridSquare(x, y, playerZ)
            if square and square:Is(IsoFlagType.water) then
                return true, x, y, playerZ
            end
        end
    end
    
    return false, nil, nil, nil
end

function onDrinkGroundWater(player, horse, X, Y, Z)    
    ISTimedActionQueue.add(DrinkWaterGround:new(player, horse, X, Y, Z))
end

function onFeedHorse(player, horse, food)
        ISTimedActionQueue.add(HorseFeed:new(player, horse, food))
end


function modifyModData(player, item, data)
    local md = item:getModData() or {}
    for k, v in pairs(data) do
        md[k] = v
    end
    local wi = item:getWorldItem()
    if not wi or not wi:getSquare() then
        return
    end
    local square = wi:getSquare()
    local x, y, z = math.floor(square:getX()), math.floor(square:getY()), math.floor(square:getZ())
    local args = {
        x = x,
        y = y,
        z = z,
        id = item:getID(),
        data = data
    }
    sendClientCommand("DeadlineHorse", "RequestSyncHorseData", args)
end

function getHunger(modData)
    local hunger = modData["hunger"] or 0
    
    if hunger > 300 then
        hunger = 300
    end

    return hunger
end

function getThirst(modData)
    local thirst = modData["thirst"] or 0

    if thirst > 300 then
        thirst = 300
    end

    return thirst
end


function claimHorse(player, item)
    player:Say("Horse claimed.")
    localtext = player:getUsername() .. " has claimed a horse with name " .. item:getName() .. " at coordinates " .. math.floor(getPlayer():getX()) .. " " .. math.floor(getPlayer():getY()) .. " " .. math.floor(getPlayer():getZ()) .. " "
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Horses", logText = localtext})
    modifyModData(player, item, {
        owner = player:getUsername(),
        riders = {},
    })
end

function unclaimHorse(player, item)
    player:Say("Horse unclaimed")
    localtext = player:getUsername() .. " has unclaimed a horse with name " .. item:getName() .. " at coordinates " .. math.floor(getPlayer():getX()) .. " " .. math.floor(getPlayer():getY()) .. " " .. math.floor(getPlayer():getZ()) .. " "
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Horses", logText = localtext})
    modifyModData(player, item, {
        owner = "THEREISNOCLAIMANT",
        riders = {},
    })
end

function unclaimHorseAdmin(player, item)
    player:Say("Horse unclaimed")
    localtext = player:getUsername() .. " has admin unclaimed a horse with name " .. item:getName() .. " at coordinates " .. math.floor(getPlayer():getX()) .. " " .. math.floor(getPlayer():getY()) .. " " .. math.floor(getPlayer():getZ()) .. " "
    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Horses", logText = localtext})
    modifyModData(player, item, {
        owner = "THEREISNOCLAIMANT",
        riders = {},
    })
end


function reassureHorse(player, item)
    print(item)
    if not item then return end
    local data = item:getModData()

    if not data._initialized then
        data.health = ZombRand(300, 401)
        data.maxHealth = data.health
        data.speedModifier = ZombRandFloat(1.2, 1.7)
        data.horseSpeed = data.horseSpeed or 0.0
        data._coastTime = data._coastTime or 0
        data._coastDir = data._coastDir or nil
        data.maxHorseSpeed = 0
        data.hunger = 300
        data.maxHunger = 300
        data.thirst = 300
        data.maxThirst = 300
        data.stamina = 300
        data.maxStamina = 300
        data.owner = ""
        data.riders = {}
        data.oldName = ""

        data._initialized = true


    end
end


function renameHorse(player, item)
    local prompt = "Enter a new name for your horse:"
    local defaultName = item:getName()
    local md = item:getModData()
    modifyModData(player, item, {
        oldName = item:getName(),
    })

    local function onRename(target, button)
        if button.internal ~= "OK" then
            return
        end

        local newName = button.target.entry:getText()
        if newName and newName ~= "" then
            item:setName(newName)
            player:Say("You have renamed your horse to " .. newName)
            localtext = player:getUsername() .. " has renamed a horse from " .. md.oldName .. " to " .. newName ..  " at coordinates " .. math.floor(getPlayer():getX()) .. " " .. math.floor(getPlayer():getY()) .. " " .. math.floor(getPlayer():getZ()) .. " "
            sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {loggerName = "Horses", logText = localtext})    
        end
    end

    local modal = ISTextBox:new(
        0, 0, 280, 180,
        prompt,
        defaultName,
        nil,
        onRename,
        player:getPlayerNum()
    )
    modal:initialise()
    modal:addToUIManager()
    item:setCustomName(true)

end


local o_ISUnequipAction_isValid = ISUnequipAction.isValid
function ISUnequipAction:isValid()
    if self.item and HORSE_ITEM_TYPES[self.item:getFullType()] then
        return false
    end
    return o_ISUnequipAction_isValid(self)
end

local original_ISEnterVehicle_isValid = ISEnterVehicle.isValid
function ISEnterVehicle:isValid()
    if getPlayer():getWornItem("Horse") then
        return false
    end
    return original_ISEnterVehicle_isValid(self)
end

local original_ISInventoryTransferAction_isValid = ISInventoryTransferAction.isValid
function ISInventoryTransferAction:isValid()
    local val = original_ISInventoryTransferAction_isValid(self)
    if not val then return false end
    if self.item and HORSE_ITEM_TYPES[self.item:getFullType()] then
        if self.destContainer:getType() == "floor" then
            return true
        end
        return false
    end
    return true
end



