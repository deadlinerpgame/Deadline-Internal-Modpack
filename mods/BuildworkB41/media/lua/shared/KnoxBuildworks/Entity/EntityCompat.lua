local Log = require("KnoxBuildworks/Log")

local EntityCompat = {}

local warnedStages = {}

local function referenceFor(stage)
    return (stage and stage.entityCompat) or {}
end

function EntityCompat.scriptName(stage)
    local reference = referenceFor(stage)
    local entity = tostring(reference.entity or "")
    if entity == "" then return nil end
    if string.find(entity, ".", 1, true) then return entity end
    local module = tostring(reference.module or "Base")
    if module == "" then module = "Base" end
    return module .. "." .. entity
end

function EntityCompat.resolveScript(stage)
    return nil, EntityCompat.scriptName(stage)
end

function EntityCompat.component()
    return nil
end

function EntityCompat.craftRecipeObject()
    return nil
end

function EntityCompat.xpAwards()
    return {}
end

function EntityCompat.metadata(stage)
    local reference = referenceFor(stage)
    local scriptName = EntityCompat.scriptName(stage)
    if scriptName and stage and stage.sprites == nil and stage.geometry == nil
        and not warnedStages[scriptName] then
        warnedStages[scriptName] = true
        Log:warning(
            "Definition references entity %s but declares no sprites or geometry; "
            .. "B41 cannot derive them from an entity script", tostring(scriptName)
        )
    end
    return {
        module = reference.module or "Base",
        entity = reference.entity,
        scriptName = scriptName
    }
end

EntityCompat.config = EntityCompat.metadata

function EntityCompat.hydrateStage(stage)
    if stage and stage._kbwNativeRecipeInputs == nil then
        stage._kbwNativeRecipeInputs = false
    end
    return stage
end

function EntityCompat.usesNativeRecipeInputs()
    return false
end

function EntityCompat.clearCache()
    warnedStages = {}
end

function EntityCompat.attach()
    return true
end

return EntityCompat
