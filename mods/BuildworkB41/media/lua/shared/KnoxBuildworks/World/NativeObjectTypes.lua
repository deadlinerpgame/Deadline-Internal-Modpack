local Mannequins = require("KnoxBuildworks/World/Mannequins")
local KBWB41 = require("KnoxBuildworks/Compat/B41")

local NativeObjectTypes = {}

local SUPPORTED_TYPES = {
    barbecue = true,
    clothingDryer = true,
    clothingWasher = true,
    combinationWasherDryer = true,
    fireplace = true,
    generator = true,
    lightSwitch = true,
    mannequin = true,
    stove = true
}

local SUPPORTED_TYPE_MESSAGE = table.concat({
    "'barbecue'", "'clothingDryer'", "'clothingWasher'", "'combinationWasherDryer'",
    "'fireplace'", "'generator'", "'lightSwitch'", "'mannequin'", "'stove'"
}, ", ")

local ISO_TYPE_MAP = {
    IsoBarbecue = "barbecue",
    IsoClothingDryer = "clothingDryer",
    IsoClothingWasher = "clothingWasher",
    IsoCombinationWasherDryer = "combinationWasherDryer",
    IsoFireplace = "fireplace",
    IsoLightSwitch = "lightSwitch",
    IsoMannequin = "mannequin",
    IsoStove = "stove"
}

function NativeObjectTypes.isSupported(objectType)
    return SUPPORTED_TYPES[objectType] == true
end

function NativeObjectTypes.validate(config, addError)
    if type(config) ~= "table" then
        addError("must be an object")
        return config
    end

    local objectType = config.type
    if not NativeObjectTypes.isSupported(objectType) then
        addError("'type' must be one of " .. SUPPORTED_TYPE_MESSAGE)
        return config
    end

    if objectType == "generator" then
        if type(config.item) ~= "string" or config.item == "" then
            addError("'item' must be a non-empty item full type for a generator")
        elseif ScriptManager and not ScriptManager.instance:FindItem(config.item) then
            addError("references missing item " .. tostring(config.item))
        end
    elseif config.item ~= nil then
        addError("'item' is only valid for a generator")
    end

    if config.script ~= nil then
        if objectType ~= "mannequin" then
            addError("'script' is only valid for a mannequin")
        elseif type(config.script) ~= "string" or config.script == "" then
            addError("'script' must be a non-empty mannequin script name")
        elseif getScriptManager and getScriptManager()
            and getScriptManager().getMannequinScript
            and not getScriptManager():getMannequinScript(config.script) then
            addError("references missing mannequin script " .. tostring(config.script))
        end
    end

    return config
end

function NativeObjectTypes.detectFromSprite(spriteName)
    if type(spriteName) ~= "string" or spriteName == "" then return nil end
    local sprite = getSprite(spriteName)
    local properties = sprite and sprite:getProperties() or nil
    if not properties then return nil end

    local isoType = KBWB41.propIs(properties, "IsoType") and KBWB41.propVal(properties, "IsoType") or nil
    local containerType = KBWB41.propIs(properties, "container") and KBWB41.propVal(properties, "container") or nil
    local detected = ISO_TYPE_MAP[isoType]
    if detected then return detected end
    if Mannequins.detect(spriteName) then return "mannequin" end
    if sprite:getType() == IsoObjectType.lightswitch then return "lightSwitch" end
    if containerType == "fireplace" then return "fireplace" end
    return nil
end

function NativeObjectTypes.resolve(config, spriteName)
    if type(config) == "table" and NativeObjectTypes.isSupported(config.type) then
        return config.type, false
    end
    return NativeObjectTypes.detectFromSprite(spriteName), true
end

return NativeObjectTypes
