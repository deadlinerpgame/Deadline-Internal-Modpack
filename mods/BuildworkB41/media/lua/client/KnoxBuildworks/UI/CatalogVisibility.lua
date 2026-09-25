local EntityCompat = require("KnoxBuildworks/Entity/EntityCompat")
local StageConfig = require("KnoxBuildworks/Definitions/StageConfig")
local LuaCallback = require("KnoxBuildworks/Util/LuaCallback")
local BuildableRules = require("KnoxBuildworks/Admin/BuildableRules")

local CatalogVisibility = {}

local function uiData(player)
    local root = player:getModData()
    root.KBW_UI = root.KBW_UI or { favorites = {}, recent = {}, compact = false }
    return root.KBW_UI
end

function CatalogVisibility.shouldShowAll(player)
    return player ~= nil and uiData(player).showAllVersions == true
end

function CatalogVisibility.setShowAll(player, enabled)
    if player then uiData(player).showAllVersions = enabled == true end
end

local spriteAvailable = {}

local function stageSpritesExist(stage)
    if not getSprite then return true end
    local key = stage
    local cached = spriteAvailable[key]
    if cached ~= nil then return cached end

    local ok = true
    for _, spriteName in pairs(stage.sprites or {}) do
        if type(spriteName) == "string" and not getSprite(spriteName) then
            ok = false
            break
        end
    end
    if ok then
        for _, face in pairs((stage.geometry or {}).faces or {}) do
            for layerIndex = 1, #(face.layers or {}) do
                local rows = face.layers[layerIndex].rows or {}
                for rowIndex = 1, #rows do
                    for colIndex = 1, #rows[rowIndex] do
                        local value = rows[rowIndex][colIndex]
                        if type(value) == "string" and not getSprite(value) then
                            ok = false
                            break
                        end
                    end
                    if not ok then break end
                end
                if not ok then break end
            end
            if not ok then break end
        end
    end
    spriteAvailable[key] = ok
    return ok
end

function CatalogVisibility.clearSpriteCache()
    spriteAvailable = {}
end

function CatalogVisibility.stagePasses(player, definition, stage, shouldShowAll)
    if not stage then return false end
    stage = BuildableRules.effectiveStage(definition, stage)
    if not stage then return false end
    if not stageSpritesExist(stage) then return false end
    local recipe = StageConfig.recipe(definition, stage)
    if not recipe.onAddToMenu then return true end
    if shouldShowAll == nil then shouldShowAll = CatalogVisibility.shouldShowAll(player) end
    return LuaCallback.callBool(recipe.onAddToMenu, {
        player = player,
        recipe = EntityCompat.craftRecipeObject(stage),
        definition = definition,
        stage = stage,
        shouldShowAll = shouldShowAll == true
    }, true)
end

function CatalogVisibility.definitionPasses(player, definition, shouldShowAll)
    if not BuildableRules.isEnabled(definition) then return false end
    local stages = definition and definition.stages or {}
    for stageIndex = 1, #stages do
        if CatalogVisibility.stagePasses(player, definition, stages[stageIndex], shouldShowAll) then return true end
    end
    return #stages == 0
end

function CatalogVisibility.filteredStages(player, definition, shouldShowAll)
    local result = {}
    local stages = definition and definition.stages or {}
    for stageIndex = 1, #stages do
        local stage = stages[stageIndex]
        if CatalogVisibility.stagePasses(player, definition, stage, shouldShowAll) then
            result[#result + 1] = BuildableRules.effectiveStage(definition, stage)
        end
    end
    return result
end

function CatalogVisibility.definitionEnabled(definition)
    return BuildableRules.isEnabled(definition)
end

return CatalogVisibility
