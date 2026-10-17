local Registry = require("KnoxBuildworks/Definitions/Registry")
local Requirements = require("KnoxBuildworks/Validation/Requirements")
local TableUtil = require("KnoxBuildworks/Util/Table")
local BuildableRules = require("KnoxBuildworks/Admin/BuildableRules")

local Resolver = {}

local function findOption(options, optionId)
    options = options or {}
    for optionIndex = 1, #options do
        local option = options[optionIndex]
        if option.id == optionId then return option end
    end
    return nil
end

function Resolver.resolve(buildableId, variantId, materialId)
    local base = Registry:get(buildableId)
    if not base then return nil, "unknown buildable" end
    if base.materialRequired == true and (materialId == nil or materialId == "") then
        return nil, "material selection required"
    end
    local definition = base
    if variantId and variantId ~= "" then
        local variant = findOption(base.variants, variantId)
        if not variant then return nil, "unknown variant" end
        definition = TableUtil.merge(definition, variant)
    end
    if materialId and materialId ~= "" then
        local material = findOption(base.materialOptions, materialId)
        if not material then return nil, "unknown material" end
        definition = TableUtil.merge(definition, material)
    end
    if definition == base then definition = TableUtil.copy(base) end
    definition.id = buildableId
    return definition
end

function Resolver.resolveStage(buildableId, variantId, materialId, stageId)
    local definition, reason = Resolver.resolve(buildableId, variantId, materialId)
    if not definition then return nil, nil, reason end
    local stage = Registry:getStage(definition, stageId)
    if not stage then return definition, nil, "unknown stage" end
    stage = BuildableRules.effectiveStage(definition, stage)
    if not stage then return definition, nil, "buildable disabled by server" end
    return definition, stage
end

function Resolver.validateChoices(definition, stage, choices)
    if choices == nil then return true end
    if type(choices) ~= "table" then return false, "invalid ingredient choices" end
    local inputs = Requirements.getInputs(definition, stage)
    local byId = {}
    for inputIndex = 1, #inputs do
        local input = inputs[inputIndex]
        byId[input.id] = input
    end
    for inputId, fullType in pairs(choices) do
        local input = byId[inputId]
        if not input then return false, "unknown input id " .. tostring(inputId) end
        if type(fullType) ~= "string" then return false, "invalid choice for " .. tostring(inputId) end
        local accepted = Requirements.possibleItems(input)
        if not TableUtil.contains(accepted, fullType) then
            return false, "item " .. fullType .. " not accepted by " .. tostring(inputId)
        end
    end
    return true
end

return Resolver
