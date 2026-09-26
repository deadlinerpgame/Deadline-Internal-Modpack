local KBW = require("KnoxBuildworks/Core")
local KBWB41 = require("KnoxBuildworks/Compat/B41")

KBW.JsonCallbacks = KBW.JsonCallbacks or {}
KBW.JsonCallbacks.Floor = KBW.JsonCallbacks.Floor or {}
KBW.JsonCallbacks.DoorFrame = KBW.JsonCallbacks.DoorFrame or {}
KBW.JsonCallbacks.Surface = KBW.JsonCallbacks.Surface or {}
KBW.JsonCallbacks.Visibility = KBW.JsonCallbacks.Visibility or {}

local Floor = KBW.JsonCallbacks.Floor
local DoorFrame = KBW.JsonCallbacks.DoorFrame
local Surface = KBW.JsonCallbacks.Surface
local Visibility = KBW.JsonCallbacks.Visibility

function Floor.OnIsValid(params)
    if not params or not params.square or not params.tileInfo then return false end
    if KBWB41.call(params.square, "HasStairsBelow") then return false end
    local spriteName = params.tileInfo:getSpriteName()
    for objectIndex = 0, params.square:getObjects():size() - 1 do
        local object = params.square:getObjects():get(objectIndex)
        local textureName = object:getTextureName()
        local objectSpriteName = object:getSpriteName()
        if (textureName and luautils.stringStarts(textureName, "vegetation_farming"))
            or (objectSpriteName and luautils.stringStarts(objectSpriteName, "vegetation_farming")) then
            return false
        end
        if (textureName and textureName == spriteName) or (objectSpriteName and objectSpriteName == spriteName) then
            return false
        end
    end
    if not params.square:connectedWithFloor() then return false end
    params.testCollisions = false
    return true
end

function Floor.OnCreate(params)
    local floor = params and params.thumpable
    local square = floor and floor:getSquare()
    if not square then return nil end
    local objects = square:getObjects()
    local rug = nil
    for objectIndex = objects:size() - 1, 0, -1 do
        local object = objects:get(objectIndex)
        if object and object ~= floor then
            local properties = object:getProperties()
            local shouldRemove = properties and (KBWB41.propIs(properties, IsoFlagType.canBeRemoved)
                or KBWB41.propIs(properties, IsoFlagType.solidfloor) or KBWB41.propIs(properties, IsoFlagType.noStart)
                or (KBWB41.propIs(properties, IsoFlagType.vegitation) and object:getType() ~= IsoObjectType.tree)
                or KBWB41.propIs(properties, IsoFlagType.taintedWater))
            local textureName = object:getTextureName()
            shouldRemove = shouldRemove or (textureName and string.contains(textureName, "blends_grassoverlays"))
            if textureName and string.contains(textureName, "floors_rugs") then
                rug = object
                shouldRemove = false
            end
            if shouldRemove then
                square:transmitRemoveItemFromSquare(object)
                square:RemoveTileObject(object)
            end
        end
    end
    if rug then
        local rugIndex = objects:indexOf(rug)
        local floorIndex = objects:indexOf(floor)
        if rugIndex >= 0 and floorIndex >= 0 and rugIndex < floorIndex then
            objects:set(rugIndex, floor)
            objects:set(floorIndex, rug)
        end
    end
    KBWB41.call(square, "EnsureSurroundNotNull")
    square:RecalcProperties()
    if DesignationZoneAnimal then
        DesignationZoneAnimal.addNewRoof(square:getX(), square:getY(), square:getZ())
    end
    KBWB41.call(square:getCell(), "checkHaveRoof", square:getX(), square:getY())
    for z = square:getZ() - 1, 0, -1 do
        local below = getCell():getGridSquare(square:getX(), square:getY(), z)
        if not below then
            below = IsoGridSquare.getNew(getCell(), nil, square:getX(), square:getY(), z)
            getCell():ConnectNewSquare(below, false)
        end
        KBWB41.call(below, "EnsureSurroundNotNull")
        below:RecalcAllWithNeighbours(true)
    end
    KBWB41.call(square, "clearWater")
    square:disableErosion()
    sendServerCommand("erosion", "disableForSquare", {
        x = square:getX(), y = square:getY(), z = square:getZ()
    })
    KBWB41.invalidateLighting()
    KBWB41.call(square, "setSquareChanged")
    KBWB41.call(floor, "invalidateRenderChunkLevel", FBORenderChunk.DIRTY_OBJECT_ADD)
    return nil
end

function DoorFrame.OnIsValid(params)
    if not params or not params.square then return false end
    local adjacent = params.north and params.square:getN() or params.square:getW()
    if adjacent and adjacent:getModData()["ConnectedToStairs" .. tostring(params.north)] then return false end
    return true
end

function Surface.EnablePlaster(params)
    local object = params and params.thumpable
    if not object or not instanceof(object, "IsoThumpable") then return nil end
    object:setCanBePlastered(true)
    return nil
end

function Visibility.BrickWallLvl2(params)
    if params and params.shouldShowAll then return true end
    local player = params and params.player or nil
    if not player then return false end
    return player:getPerkLevel(Perks.Masonry) >= 5
end

return KBW.JsonCallbacks
