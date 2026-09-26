local Log = require("KnoxBuildworks/Log")
local KBWB41 = require("KnoxBuildworks/Compat/B41")

local FluidContainers = {}

local tracked = {}

local DEFAULT_CAPACITY = 400
local DEFAULT_RAIN_FACTOR = 0.3
local BARREL_NAME = "Rain Collector Barrel"

local function safeCapacity(capacity)
    if not RainCollectorBarrel then return capacity end
    if capacity == RainCollectorBarrel.smallWaterMax
        or capacity == RainCollectorBarrel.largeWaterMax then
        return capacity + 1
    end
    return capacity
end

local function waterMaxOf(object)
    local modData = object:getModData()
    return tonumber(modData.waterMax) or tonumber(modData.KBWFluidCapacity) or DEFAULT_CAPACITY
end

local function adopt(object)
    if isClient() then return true end
    if not SRainBarrelSystem or not SRainBarrelSystem.instance then return false end
    local system = SRainBarrelSystem.instance
    if not system.isValidIsoObject or not system:isValidIsoObject(object) then return false end
    if not system.addFromIsoObject then return false end
    system:addFromIsoObject(object)
    return true
end

local function markSpriteAsWaterSource(object, capacity)
    local sprite = object.getSprite and object:getSprite() or nil
    local properties = sprite and sprite:getProperties() or nil
    if not properties then return end
    if not KBWB41.propIs(properties, "waterMaxAmount") then
        KBWB41.propSet(properties, "waterMaxAmount", tostring(capacity))
    end
end

function FluidContainers.configureObject(object, config)
    if not object then return false end
    config = type(config) == "table" and config or {}

    if not object.setWaterAmount or not instanceof(object, "IsoThumpable") then
        Log:error(
            "Buildable at %s,%s,%s cannot hold water in Build 41: only an IsoThumpable "
            .. "adopted by SRainBarrelSystem is a real water source",
            tostring(object:getX()), tostring(object:getY()), tostring(object:getZ())
        )
        return false
    end

    local capacity = safeCapacity(math.max(1, tonumber(config.capacity) or DEFAULT_CAPACITY))
    local modData = object:getModData()

    modData.waterMax = capacity
    modData.KBWFluidCapacity = capacity
    modData.KBWFluidRain = math.max(0, tonumber(config.rainFactor) or DEFAULT_RAIN_FACTOR)

    if object.setName and modData.KBWFluidRain > 0 then object:setName(BARREL_NAME) end

    if config.emptySprite and config.filledSprite then
        modData.KBWFluidSprites = {
            empty = tostring(config.emptySprite),
            filled = tostring(config.filledSprite),
            percent = math.max(0, math.min(100, tonumber(config.filledPercent) or 1)),
            fire = config.fireSprite and tostring(config.fireSprite) or nil
        }
    end
    if modData.KBWFluidSprites and modData.KBWFluidSprites.fire and modData.KBWDrumMode == nil then
        modData.KBWDrumMode = "water"
    end

    if modData.KBWFluidInitialized ~= true then
        local initialPercent = math.max(0, math.min(100, tonumber(config.initialPercent) or 0))
        local initial = math.floor(capacity * initialPercent / 100)
        object:setWaterAmount(initial)
        if object.setTaintedWater then object:setTaintedWater(initial > 0) end
        modData.KBWFluidInitialized = true
    end

    markSpriteAsWaterSource(object, capacity)

    local adopted = adopt(object)
    if not adopted and not isClient() then
        Log:warning(
            "Rain collector at %s,%s,%s was not adopted by SRainBarrelSystem; "
            .. "its water will not persist or refill",
            tostring(object:getX()), tostring(object:getY()), tostring(object:getZ())
        )
    end

    FluidContainers.track(object)
    FluidContainers.refreshSprite(object)
    if object.transmitModData then object:transmitModData() end
    return true
end

function FluidContainers.track(object)
    if not object or not object.hasModData or not object:hasModData() then return end
    if object:getModData().KBWFluidSprites ~= nil then tracked[object] = true end
end

function FluidContainers.refreshSprite(object)
    if not object or not object.hasModData or not object:hasModData() then return false end
    local modData = object:getModData()
    local sprites = modData.KBWFluidSprites
    if not sprites or not sprites.empty or not sprites.filled then return false end
    if not object.getWaterAmount then return false end
    local wanted
    if modData.KBWDrumMode == "fire" and sprites.fire then
        wanted = sprites.fire
    else
        local capacity = waterMaxOf(object)
        local amount = tonumber(object:getWaterAmount()) or 0
        local percent = capacity > 0 and amount / capacity * 100 or 0
        wanted = percent >= (tonumber(sprites.percent) or 1) and sprites.filled or sprites.empty
    end
    if object:getSpriteName() == wanted then return false end
    if not getSprite(wanted) then return false end
    object:setSprite(wanted)
    object:transmitUpdatedSpriteToClients()
    return true
end

function FluidContainers.isDualMode(object)
    if not object or not object.hasModData or not object:hasModData() then return false end
    local sprites = object:getModData().KBWFluidSprites
    return sprites ~= nil and sprites.fire ~= nil
end

function FluidContainers.getMode(object)
    if not FluidContainers.isDualMode(object) then return nil end
    return object:getModData().KBWDrumMode or "water"
end

function FluidContainers.setMode(object, mode)
    if not FluidContainers.isDualMode(object) then return false, "not a drum" end
    mode = mode == "fire" and "fire" or "water"
    local modData = object:getModData()
    if (modData.KBWDrumMode or "water") == mode then return true end
    local square = object:getSquare()
    if not square then return false, "no square" end

    local isFireplace = instanceof(object, "IsoFireplace")
    if mode == "fire" then
        if object.getWaterAmount and (tonumber(object:getWaterAmount()) or 0) > 0 then
            return false, "drain first"
        end
    elseif isFireplace and (object:isLit() or object:isSmouldering()) then
        return false, "put out first"
    end

    local sprites = modData.KBWFluidSprites
    local spriteName = mode == "fire" and sprites.fire or sprites.empty
    if not getSprite(spriteName) then return false, "missing sprite" end

    local carried = copyTable(modData)
    carried.KBWDrumMode = mode
    carried.KBWFluidInitialized = nil
    if object.getMaxHealth then
        carried.KBWDrumMaxHealth = tonumber(object:getMaxHealth())
        carried.KBWDrumHealth = tonumber(object:getHealth())
    end

    local replacement
    if mode == "fire" then
        replacement = IsoFireplace.new(getCell(), square, getSprite(spriteName))
    else
        replacement = IsoThumpable.new(getCell(), square, spriteName, false, nil)
        local maxHealth = math.max(1, tonumber(carried.KBWDrumMaxHealth) or 100)
        replacement:setMaxHealth(maxHealth)
        replacement:setHealth(math.min(maxHealth, tonumber(carried.KBWDrumHealth) or maxHealth))
        replacement:setIsThumpable(true)
        replacement:setIsDismantable(true)
        replacement:setBlockAllTheSquare(true)
    end
    if not replacement then return false, "replace failed" end

    local index = square:transmitRemoveItemFromSquare(object) or -1
    tracked[object] = nil
    local newModData = replacement:getModData()
    for key, value in pairs(carried) do newModData[key] = value end
    if index >= 0 then square:AddSpecialObject(replacement, index) else square:AddSpecialObject(replacement) end

    if mode == "water" then
        FluidContainers.configureObject(replacement, {
            capacity = tonumber(carried.KBWFluidCapacity),
            rainFactor = tonumber(carried.KBWFluidRain),
            emptySprite = sprites.empty, filledSprite = sprites.filled,
            filledPercent = sprites.percent, fireSprite = sprites.fire
        })
    else
        if replacement.setName then replacement:setName("Burn Barrel") end
    end
    FluidContainers.track(replacement)
    square:RecalcAllWithNeighbours(true)
    if replacement.transmitCompleteItemToClients then replacement:transmitCompleteItemToClients() end
    return true
end

function FluidContainers.dumpFuel(object)
    if not instanceof(object, "IsoFireplace") then return false, "not a drum" end
    if object:isLit() or object:isSmouldering() then return false, "put out first" end
    if (tonumber(object:getFuelAmount()) or 0) <= 0 then return false, "no fuel" end
    object:setFuelAmount(0)
    if object.sync then object:sync() end
    return true
end

local function reconcileMode(object)
    if not FluidContainers.isDualMode(object) then return end
    if not instanceof(object, "IsoFireplace") then return end
    local burning = object:isLit() or object:isSmouldering()
        or (tonumber(object:getFuelAmount()) or 0) > 0
    if not burning then return end
    local modData = object:getModData()
    if modData.KBWDrumMode == "fire" then return end
    modData.KBWDrumMode = "fire"
    if object.setName then object:setName("Burn Barrel") end
    if object.transmitModData then object:transmitModData() end
end

local function refreshTracked()
    if isClient() then return end
    for object in pairs(tracked) do
        local square = object and object:getSquare() or nil
        if not square or object:getObjectIndex() < 0 then
            tracked[object] = nil
        else
            reconcileMode(object)
            FluidContainers.refreshSprite(object)
        end
    end
end

local function onLoadGridsquare(square)
    if not square then return end
    local objects = square:getObjects()
    for objectIndex = 0, objects:size() - 1 do
        FluidContainers.track(objects:get(objectIndex))
    end
end

if Events then
    KBWB41.addEvent("LoadGridsquare", onLoadGridsquare)
    KBWB41.addEvent("OnObjectAdded", FluidContainers.track)
    KBWB41.addEvent("EveryOneMinute", refreshTracked)
end

return FluidContainers
