local IconResolver = {}
local Matrix = require("KnoxBuildworks/Geometry/Matrix")
local StageConfig = require("KnoxBuildworks/Definitions/StageConfig")
local Profiler = require("KnoxBuildworks/Util/Profiler")
local KBWB41 = require("KnoxBuildworks/Compat/B41")

local textureNameCache = {}
local spriteTextureCache = {}
local tagItemCache = {}
local tagNameCache = {}
local itemTextureCache = {}
local definitionIconCache = {}

local function scriptFor(fullType)
    if not fullType then return nil end
    if getItem then
        local script = KBWB41.scriptItem(fullType)
        if script then return script end
    end
    return ScriptManager and ScriptManager.instance and ScriptManager.instance:FindItem(fullType) or nil
end

local function normalizeTagName(name)
    if not name then return nil end
    local value = tostring(name)
    if string.sub(value, 1, 1) == "#" then value = string.sub(value, 2) end
    if not string.find(value, ":", 1, true) then
        local dotIndex = string.find(value, ".", 1, true)
        if dotIndex then
            local namespace = string.sub(value, 1, dotIndex - 1)
            local path = string.sub(value, dotIndex + 1)
            if namespace ~= "" and path ~= "" and not string.find(path, ".", 1, true) then
                value = namespace .. ":" .. path
            end
        end
    end
    return value
end

local function tagValue(name)
    local normalized = normalizeTagName(name)
    local tag = nil
    if normalized and KBWB41 then tag = KBWB41.tagName(normalized) end
    if not tag and KBWB41 and normalized then
        local key = string.upper(string.gsub(normalized, "(%l)(%u)", "%1_%2"))
        key = string.gsub(key, "[^A-Z0-9]", "_")
        tag = KBWB41.tagName(key) or KBWB41.tagName(string.upper(normalized))
    end
    return tag, normalized
end

local function fullTypeFromScriptItem(scriptItem)
    if not scriptItem then return nil end
    if scriptItem.getFullName then return scriptItem:getFullName() end
    if scriptItem.getFullType then return scriptItem:getFullType() end
    if scriptItem.getName then return scriptItem:getName() end
    return nil
end

local function firstItemForTag(tagName)
    local tag = tagValue(tagName)
    if not tag or not getScriptManager then return nil end
    local manager = getScriptManager()
    if not manager or not manager.getItemsTag then return nil end
    local scriptItems = manager:getItemsTag(tag)
    if scriptItems and scriptItems:size() > 0 then return fullTypeFromScriptItem(scriptItems:get(0)) end
    return nil
end

local function textureFromItem(fullType)
    if not fullType then return nil, nil end
    local cached = itemTextureCache[fullType]
    if cached then
        if cached.texture == false then return nil, nil end
        return cached.texture, cached.color
    end
    Profiler.count("icons.itemLookups")
    local script = scriptFor(fullType)
    if script and script.getNormalTexture then
        local color = { r = 1, g = 1, b = 1, a = 1 }
        if script.getR then
            color.r = script:getR()
            color.g = script:getG()
            color.b = script:getB()
        end
        local texture = script:getNormalTexture()
        itemTextureCache[fullType] = { texture = texture or false, color = color }
        if texture then return texture, color end
        return nil, nil
    end
    itemTextureCache[fullType] = { texture = false }
    return nil, nil
end

local function textureFromTextureName(name)
    if type(name) ~= "string" or name == "" then return nil end
    local cached = textureNameCache[name]
    if cached ~= nil then
        if cached == false then return nil end
        return cached
    end
    Profiler.count("icons.textureLookups")
    local texture = getTexture(name)
        or getTexture("media/textures/" .. name .. ".png")
        or getTexture("media/ui/" .. name .. ".png")
        or getTexture("media/ui/Entity/" .. name .. ".png")
        or getTexture("media/ui/craftingMenus/" .. name .. ".png")
    textureNameCache[name] = texture or false
    return texture
end

function IconResolver.textureForItem(fullType)
    return textureFromItem(fullType)
end

local function firstItemForTagCached(tagName)
    if not tagName then return nil end
    local cached = tagItemCache[tagName]
    if cached ~= nil then
        if cached == false then return nil end
        return cached
    end
    Profiler.count("icons.tagLookups")
    local fullType = firstItemForTag(tagName)
    tagItemCache[tagName] = fullType or false
    return fullType
end

function IconResolver.firstItemForTag(tagName)
    return firstItemForTagCached(tagName)
end

function IconResolver.textureForTag(tagName)
    local fullType = firstItemForTagCached(tagName)
    if fullType then return textureFromItem(fullType) end
    return nil, nil
end

function IconResolver.displayNameForTag(tagName)
    local key = tostring(tagName or "?")
    local cached = tagNameCache[key]
    if cached then return cached end
    local result = nil
    local tag, normalized = tagValue(tagName)
    if tag and tag.getTranslationName then
        local translated = KBWB41.displayName(tag)
        if translated and translated ~= "" then result = translated end
    end
    if not result then
        local fullType = firstItemForTagCached(normalized or tagName)
        if fullType and getItemNameFromFullType then result = getItemNameFromFullType(fullType) end
    end
    result = result or normalized or key
    tagNameCache[key] = result
    return result
end

local function textureFromSprite(spriteName)
    if not spriteName then return nil end
    local cached = spriteTextureCache[spriteName]
    if cached ~= nil then
        if cached == false then return nil end
        return cached
    end
    Profiler.count("icons.spriteLookups")
    local sprite = getSprite(spriteName)
    local texture = sprite and KBWB41.call(sprite, "getTextureForCurrentFrame", IsoDirections.N) or nil
    spriteTextureCache[spriteName] = texture or false
    return texture
end

local function firstSprite(stage)
    local sprites = stage and stage.sprites or {}
    return sprites.S or sprites.W or sprites.N or sprites.E
end

function IconResolver.textureForSpriteName(spriteName)
    return textureFromSprite(spriteName)
end

local function resolveDefinitionTexture(definition, stage, direction)
    local recipe = StageConfig.recipe(definition, stage)
    local iconTexture = (stage and (stage.iconTexture or stage.icon)) or definition.iconTexture or definition.icon
    local texture = textureFromTextureName(iconTexture)
    if texture then return texture, { r = 1, g = 1, b = 1, a = 1 } end

    texture = textureFromTextureName((stage and stage.iconName) or definition.iconName or recipe.icon)
    if texture then return texture, { r = 1, g = 1, b = 1, a = 1 } end

    texture = textureFromSprite((stage and stage.iconSprite) or definition.iconSprite)
    if texture then return texture, { r = 1, g = 1, b = 1, a = 1 } end

    local itemTexture, color = textureFromItem((stage and stage.iconItem) or definition.iconItem)
    if itemTexture then return itemTexture, color end

    local face = direction or "S"
    texture = textureFromSprite(Matrix.getFaceSprite(stage, face) or firstSprite(stage))
    return texture, { r = 1, g = 1, b = 1, a = 1 }
end

function IconResolver.textureForDefinition(definition, stage, direction)
    if not definition and not stage then return nil, nil end
    local cacheable = direction == nil and stage ~= nil
    local cacheKey = definition and tostring(definition.id or "") or ""
    local stageCache = cacheable and definitionIconCache[stage] or nil
    local cached = stageCache and stageCache[cacheKey] or nil
    if cached then
        return cached.texture, cached.color
    end
    Profiler.count("icons.definitionResolves")
    local texture, color = resolveDefinitionTexture(definition, stage, direction)
    if cacheable then
        if not stageCache then
            stageCache = {}
            definitionIconCache[stage] = stageCache
        end
        stageCache[cacheKey] = { texture = texture, color = color }
    end
    return texture, color
end

return IconResolver
