local KBW = require("KnoxBuildworks/Core")
local TableUtil = require("KnoxBuildworks/Util/Table")
local Log = require("KnoxBuildworks/Log")
local NativeObjectTypes = require("KnoxBuildworks/World/NativeObjectTypes")
local KBWB41 = require("KnoxBuildworks/Compat/B41")

local Properties = {}

local handlers = {}
local sortedNames = {}
local namesDirty = false

local function handlerNames()
    if namesDirty then
        sortedNames = TableUtil.sortedKeys(handlers)
        namesDirty = false
    end
    return sortedNames
end

function Properties.register(name, handler)
    if type(name) ~= "string" or name == "" or type(handler) ~= "table" then
        Log:error("Properties.register: invalid handler registration for '%s'", tostring(name))
        return false
    end
    if handlers[name] then
        Log:warning("Properties.register: handler '%s' replaced", name)
    end
    handlers[name] = handler
    namesDirty = true
    return true
end

function Properties.get(name)
    return handlers[name]
end

function Properties.normalizeStage(stage, definition, errors)
    local names = handlerNames()
    for nameIndex = 1, #names do
        local name = names[nameIndex]
        local handler = handlers[name]
        if stage[name] ~= nil and handler.normalize then
            local function addError(message)
                errors[#errors + 1] = "stage " .. tostring(stage.id)
                    .. " property '" .. name
                    .. "': " .. tostring(message)
            end
            local replaced = handler.normalize(stage[name], stage, definition, addError)
            if replaced ~= nil then stage[name] = replaced end
        end
    end
end

function Properties.applyToCursor(buildObj)
    local stage = buildObj and buildObj.stage
    if not stage then return end
    local names = handlerNames()
    for nameIndex = 1, #names do
        local name = names[nameIndex]
        local handler = handlers[name]
        if stage[name] ~= nil and handler.applyToCursor then
            handler.applyToCursor(buildObj, stage, buildObj.definition)
        end
    end
end

function Properties.applyToObject(part, buildObj, context)
    local stage = buildObj and buildObj.stage
    if not part or not stage then return end
    local names = handlerNames()
    for nameIndex = 1, #names do
        local name = names[nameIndex]
        local handler = handlers[name]
        if stage[name] ~= nil and handler.applyToObject then
            handler.applyToObject(part, buildObj, stage, context or {})
        end
    end
end

Properties.register("container", {
    normalize = function (value, stage, definition, addError)
        if type(value) ~= "table" then
            addError("must be an object with optional 'type' and 'capacity'")
            return value
        end
        if value.type ~= nil and type(value.type) ~= "string" then addError("'type' must be a string") end
        if value.capacity ~= nil and type(value.capacity) ~= "number" then addError("'capacity' must be a number") end
        return value
    end,
    applyToCursor = function (buildObj, stage)
        buildObj.isContainer = true
        buildObj.containerType = stage.container.type or nil
    end,
    applyToObject = function (part, buildObj, stage, context)
        if not context.isFloor and part.getContainer and part:getContainer() then
            if stage.container.capacity ~= nil then
                KBWB41.call(part:getContainer(), "setCapacity", stage.container.capacity)
            end
        end
    end
})

Properties.register("nativeObject", {
    normalize = function (value, stage, definition, addError)
        return NativeObjectTypes.validate(value, addError)
    end,
    applyToCursor = function (buildObj, stage)
        buildObj.nativeObject = stage.nativeObject
    end
})

Properties.register("fluidContainer", {
    normalize = function (value, stage, definition, addError)
        if type(value) ~= "table" then
            addError("must be an options object")
            return value
        end
        local numericFields = {
            capacity = { minimum = 1, maximum = nil },
            initialPercent = { minimum = 0, maximum = 100 },
            rainFactor = { minimum = 0, maximum = nil }
        }
        local names = TableUtil.sortedKeys(numericFields)
        for index = 1, #names do
            local name = names[index]
            local field = value[name]
            local limits = numericFields[name]
            if field ~= nil and type(field) ~= "number" then
                addError("'" .. name .. "' must be a number")
            elseif type(field) == "number" and field < limits.minimum then
                addError("'" .. name .. "' must be at least " .. tostring(limits.minimum))
            elseif type(field) == "number" and limits.maximum and field > limits.maximum then
                addError("'" .. name .. "' must not exceed " .. tostring(limits.maximum))
            end
        end
        if value.containerName ~= nil and type(value.containerName) ~= "string" then
            addError("'containerName' must be a string")
        end
        local spriteFields = { "emptySprite", "filledSprite", "fireSprite" }
        for index = 1, #spriteFields do
            local name = spriteFields[index]
            if value[name] ~= nil and type(value[name]) ~= "string" then
                addError("'" .. name .. "' must be a sprite name")
            end
        end
        if (value.emptySprite ~= nil) ~= (value.filledSprite ~= nil) then
            addError("'emptySprite' and 'filledSprite' must be set together")
        end
        if value.filledPercent ~= nil and type(value.filledPercent) ~= "number" then
            addError("'filledPercent' must be a number")
        end
        if value.fireSprite ~= nil and value.emptySprite == nil then
            addError("'fireSprite' needs 'emptySprite' and 'filledSprite'")
        end
        return value
    end,
    applyToObject = function (part, buildObj, stage, context)
        if context.tileIndex ~= 1 then return end
        local FluidContainers = require("KnoxBuildworks/World/FluidContainers")
        FluidContainers.configureObject(part, stage.fluidContainer)
    end
})

Properties.register("well", {
    normalize = function (value, stage, definition, addError)
        if value ~= true and type(value) ~= "table" then
            addError("must be true or an options object")
            return value
        end
        if type(value) == "table" then
            local numericFields = {
                capacity = { minimum = 1, maximum = nil },
                initialPercent = { minimum = 0, maximum = 100 },
                refillPerHour = { minimum = 0, maximum = nil },
                rainFactor = { minimum = 0, maximum = nil }
            }
            local names = TableUtil.sortedKeys(numericFields)
            for index = 1, #names do
                local name = names[index]
                local field = value[name]
                local limits = numericFields[name]
                if field ~= nil and type(field) ~= "number" then
                    addError("'" .. name .. "' must be a number")
                elseif type(field) == "number" and field < limits.minimum then
                    addError("'" .. name .. "' must be at least " .. tostring(limits.minimum))
                elseif type(field) == "number" and limits.maximum and field > limits.maximum then
                    addError("'" .. name .. "' must not exceed " .. tostring(limits.maximum))
                end
            end
        end
        return value
    end,
    applyToObject = function (part, buildObj, stage, context)
        if context.tileIndex ~= 1 then return end
        local WellSystem = require("KnoxBuildworks/World/WellSystem")
        WellSystem.configureObject(part, stage.well, true)
    end
})

KBW.Properties = Properties

return Properties
