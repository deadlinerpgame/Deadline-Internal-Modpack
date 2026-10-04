local EntityCompat = require("KnoxBuildworks/Entity/EntityCompat")
local TableUtil = require("KnoxBuildworks/Util/Table")

local StageConfig = {}

local function assign(target, key, value)
    if value ~= nil then target[key] = value end
end

local function shallowCopy(source)
    local result = {}
    for key, value in pairs(source or {}) do result[key] = value end
    return result
end

function StageConfig.placement(definition, stage)
    return TableUtil.merge((definition and definition.placement) or {}, (stage and stage.placement) or {})
end

function StageConfig.construction(definition, stage)
    return TableUtil.merge((definition and definition.construction) or {}, (stage and stage.construction) or {})
end

function StageConfig.sprite(definition, stage)
    local native = stage and EntityCompat.metadata(stage).spriteConfig or nil
    local result = shallowCopy(native)
    local placement = StageConfig.placement(definition, stage)
    local object = (stage and stage.object) or {}
    local callbacks = (stage and stage.callbacks) or {}
    local light = (stage and stage.lightSource) or {}

    assign(result, "health", stage and stage.health)
    assign(result, "skillBaseHealth", stage and stage.skillBaseHealth)
    assign(result, "bonusHealth", stage and stage.bonusHealth)
    assign(result, "previousStage", stage and stage.previousStage)

    assign(result, "isThumpable", object.isThumpable)
    assign(result, "isProp", object.isProp)
    assign(result, "canBePadlocked", object.canBePadlocked)
    assign(result, "breakSound", object.breakSound)
    assign(result, "corner", object.cornerSprite)
    assign(result, "pillar", object.pillarSprite)

    assign(result, "dontNeedFrame", placement.dontNeedFrame)
    assign(result, "needWindowFrame", placement.needWindowFrame)
    assign(result, "needToBeAgainstWall", placement.needToBeAgainstWall)
    assign(result, "isPole", placement.isPole)

    assign(result, "onCreate", callbacks.onCreate)
    assign(result, "onIsValid", callbacks.onIsValid)
    assign(result, "timedActionOnIsValid", callbacks.timedActionOnIsValid)

    if not (stage and stage.entityCompat) and placement.kind == "floor" then
        if result.onIsValid == nil then
            result.onIsValid = "KnoxBuildworks.JsonCallbacks.Floor.OnIsValid"
        end
        if result.onCreate == nil then
            result.onCreate = "KnoxBuildworks.JsonCallbacks.Floor.OnCreate"
        end
    end
    if not (stage and stage.entityCompat) and placement.kind == "stairs" then
        if result.onIsValid == nil then
            result.onIsValid = "BuildRecipeCode.stairs.OnIsValid"
        end
        if result.onCreate == nil then
            result.onCreate = "BuildRecipeCode.stairs.OnCreate"
        end
    end
    if not (stage and stage.entityCompat) and placement.needWindowFrame == true then
        if result.onCreate == nil then
            result.onCreate = "BuildRecipeCode.windowGlass.OnCreate"
        end
    end

    assign(result, "lightRadius", light.radius)
    assign(result, "lightsourceItem", light.item)
    assign(result, "lightsourceTags", light.tags)
    assign(result, "lightsourceFuel", light.fuel)
    assign(result, "debugItem", light.debugItem)
    assign(result, "lightOffsets", light.offsets)
    return result
end

function StageConfig.recipe(definition, stage)
    local native = stage and EntityCompat.metadata(stage).craftRecipe or nil
    local result = shallowCopy(native)
    local construction = StageConfig.construction(definition, stage)
    local requirements = (stage and stage.requirements) or {}
    local knowledge = requirements.knowledge or {}
    local callbacks = (stage and stage.callbacks) or {}

    assign(result, "time", construction.time)
    assign(result, "timedAction", construction.timedAction)
    assign(result, "category", construction.category)
    assign(result, "tags", construction.tags)
    assign(result, "canWalk", construction.canWalk)
    assign(result, "icon", (stage and stage.iconName) or (definition and definition.iconName))
    assign(result, "tooltip", definition and definition.tooltipKey)
    assign(result, "xpAward", (stage and stage.xp) or construction.xp)
    assign(result, "onAddToMenu", callbacks.onAddToMenu)
    if knowledge.needToBeLearned ~= nil then
        result.needToBeLearn = knowledge.needToBeLearned == true
    elseif #(knowledge.recipes or {}) > 0 or #(requirements.recipes or {}) > 0 then
        result.needToBeLearn = true
    end
    return result
end

return StageConfig
