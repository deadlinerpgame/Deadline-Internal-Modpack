local NativeObjectTypes = require("KnoxBuildworks/World/NativeObjectTypes")
local Mannequins = require("KnoxBuildworks/World/Mannequins")
local KBWB41 = require("KnoxBuildworks/Compat/B41")

local NativeObjectFactory = {}

local handlers = {}

local function register(objectType, handler)
    handlers[objectType] = handler
end

local function applyTableTopOffset(object, sprite, square)
    local properties = sprite and sprite:getProperties() or nil
    if not properties or not KBWB41.propIs(properties, "IsTableTop") then return end
    local moveable = ISMoveableSpriteProps.new(sprite)
    local surface = moveable:getTotalTableHeight(square)
    if moveable.surface and moveable.surfaceIsOffset then
        surface = surface - moveable.surface
    end
    object:setRenderYOffset(surface)
end

local function initializeSpriteContainers(object, sprite, markMoved)
    if markMoved ~= false and object.setMovedThumpable then object:setMovedThumpable(true) end
    if object.createContainersFromSpriteProperties then
        object:createContainersFromSpriteProperties()
        if object.getContainerCount and object.getContainerByIndex then
            for index = 0, object:getContainerCount() - 1 do
                local container = object:getContainerByIndex(index)
                if container then KBWB41.setExplored(container) end
            end
        end
    end
    local properties = sprite and sprite:getProperties() or nil
    if properties and KBWB41.propIs(properties, IsoFlagType.waterPiped) then
        object:getModData().canBeWaterPiped = true
    end
end

local function registerSpriteObject(objectType, constructor)
    register(objectType, {
        create = function (config, square, spriteName)
            local sprite = spriteName and getSprite(spriteName) or nil
            if not sprite then
                return nil, "could not resolve " .. objectType .. " sprite " .. tostring(spriteName)
            end
            local object = constructor(getCell(), square, sprite)
            if not object then
                return nil, "could not initialize native " .. objectType .. " from " .. tostring(spriteName)
            end
            initializeSpriteContainers(object, sprite)
            return object, {
                alreadyAdded = false,
                alreadyTransmitted = false
            }
        end,
        finalize = function (object, square)
            square:RecalcAllWithNeighbours(true)
        end
    })
end

register("generator", {
    create = function (config, square, spriteName)
        local item = config and instanceItem(config.item) or nil
        local object = item and IsoGenerator.new(item, getCell(), square) or nil
        if not object then
            return nil, "could not initialize IsoGenerator from " .. tostring(config and config.item)
        end
        if spriteName then object:setSprite(getSprite(spriteName)) end
        return object, {
            alreadyAdded = true,
            alreadyTransmitted = isServer()
        }
    end,
    finalize = function (object, square)
        square:RecalcAllWithNeighbours(true)
        IsoGenerator.updateGenerator(square)
    end
})

register("fireplace", {
    create = function (config, square, spriteName)
        local sprite = spriteName and getSprite(spriteName) or nil
        if not sprite then
            return nil, "could not resolve fireplace sprite " .. tostring(spriteName)
        end
        local object = IsoFireplace.new(getCell(), square, sprite)
        initializeSpriteContainers(object, sprite, false)
        return object, {
            alreadyAdded = false,
            alreadyTransmitted = false
        }
    end,
    finalize = function (object, square)
        square:RecalcAllWithNeighbours(true)
    end
})

register("lightSwitch", {
    create = function (config, square, spriteName)
        local sprite = spriteName and getSprite(spriteName) or nil
        if not sprite then
            return nil, "could not resolve light-switch sprite " .. tostring(spriteName)
        end
        local object = IsoLightSwitch.new(getCell(), square, sprite, square:getRoomID())
        if not object then
            return nil, "could not initialize IsoLightSwitch from " .. tostring(spriteName)
        end

        object:addLightSourceFromSprite()

        applyTableTopOffset(object, sprite, square)

        return object, {
            alreadyAdded = false,
            alreadyTransmitted = false
        }
    end,
    finalize = function (object, square)
        square:RecalcAllWithNeighbours(true)
        IsoGenerator.updateGenerator(square)
    end
})

register("mannequin", {
    create = function (config, square, spriteName, context)
        local sprite = spriteName and getSprite(spriteName) or nil
        if not sprite then
            return nil, "could not resolve mannequin sprite " .. tostring(spriteName)
        end
        local object = IsoMannequin.new(getCell(), square, sprite)
        if not object then
            return nil, "could not initialize IsoMannequin from " .. tostring(spriteName)
        end
        object:setSquare(square)
        Mannequins.applyScript(object, spriteName, config and config.script)
        KBWB41.setObjectFacing(object, Mannequins.directionIndex(spriteName, context and context.direction))
        applyTableTopOffset(object, sprite, square)
        return object, {
            alreadyAdded = false,
            alreadyTransmitted = false
        }
    end,
    finalize = function (object, square)
        Mannequins.strip(object)
        square:RecalcAllWithNeighbours(true)
    end
})

registerSpriteObject("barbecue", function (cell, square, sprite)
    return IsoBarbecue.new(cell, square, sprite)
end)

registerSpriteObject("clothingDryer", function (cell, square, sprite)
    return IsoClothingDryer.new(cell, square, sprite)
end)

registerSpriteObject("clothingWasher", function (cell, square, sprite)
    return IsoClothingWasher.new(cell, square, sprite)
end)

registerSpriteObject("combinationWasherDryer", function (cell, square, sprite)
    return IsoCombinationWasherDryer.new(cell, square, sprite)
end)

registerSpriteObject("stove", function (cell, square, sprite)
    return IsoStove.new(cell, square, sprite)
end)

function NativeObjectFactory.resolve(config, spriteName)
    return NativeObjectTypes.resolve(config, spriteName)
end

function NativeObjectFactory.create(objectType, config, square, spriteName, context)
    local handler = handlers[objectType]
    if not handler then return nil, nil, "unsupported native object type " .. tostring(objectType) end
    local object, stateOrReason = handler.create(config or {}, square, spriteName, context)
    if not object then return nil, nil, stateOrReason end
    local state = stateOrReason or {}
    state.type = objectType
    return object, state, nil
end

function NativeObjectFactory.insert(object, state, square, insertIndex)
    if state and state.alreadyAdded then return end
    if insertIndex and insertIndex >= 0 then
        square:AddSpecialObject(object, insertIndex)
    else
        square:AddSpecialObject(object)
    end
end

function NativeObjectFactory.finalize(object, state, square)
    local handler = state and handlers[state.type] or nil
    if handler and handler.finalize then handler.finalize(object, square) end
end

return NativeObjectFactory
