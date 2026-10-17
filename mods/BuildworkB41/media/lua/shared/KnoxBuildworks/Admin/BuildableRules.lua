local TableUtil = require("KnoxBuildworks/Util/Table")
local KBW = require("KnoxBuildworks/Core")
local Registry = require("KnoxBuildworks/Definitions/Registry")
local StageConfig = require("KnoxBuildworks/Definitions/StageConfig")
local EntityCompat = require("KnoxBuildworks/Entity/EntityCompat")
local LuaCallback = require("KnoxBuildworks/Util/LuaCallback")
local KBWB41 = require("KnoxBuildworks/Compat/B41")

local Rules = {
    VERSION = 1,
    revision = 0,
    ready = false,
    document = nil,
    listeners = {}
}

local MAX_TEXT = 256
local MAX_INPUTS = 64
local MAX_SKILLS = 64
local MAX_RECIPES = 64
local MAX_STAGES = 64
local MAX_NUMBER = 1000000

local VALID_ROLES = { material = true, tool = true, consumable = true, component = true, resource = true }
local VALID_MODES = { consume = true, keep = true, drain = true, destroy = true }
local VALID_FINISH_REQUIREMENTS = { plaster = true, paint = true, wallpaper = true }
local VALID_FLAGS = {
    Prop1 = true,
    Prop2 = true,
    MayDegradeHeavy = true,
    MayDegrade = true,
    MayDegradeLight = true,
    MayDegradeVeryLight = true
}

local function emptyDocument()
    return {
        version = Rules.VERSION,
        revision = 0,
        categories = {},
        subcategories = {},
        wallFinishRequirements = {},
        buildables = {}
    }
end

Rules.document = emptyDocument()

local function addError(errors, path, message)
    if #errors < 100 then errors[#errors + 1] = tostring(path) .. ": " .. tostring(message) end
end

local function validateKnownKeys(source, allowed, path, errors)
    if type(source) ~= "table" then return end
    local keys = TableUtil.sortedKeys(source)
    for keyIndex = 1, #keys do
        local key = keys[keyIndex]
        if not allowed[key] then addError(errors, path .. "." .. tostring(key), "is not a supported setting") end
    end
end

local function shortString(value)
    return type(value) == "string" and value ~= "" and #value <= MAX_TEXT
end

local function boundedNumber(value, minimum, maximum)
    return type(value) == "number" and value == value and value >= minimum and value <= maximum
end

local function copyBooleanRule(source)
    if type(source) ~= "table" or source.enabled == nil then return nil end
    if type(source.enabled) ~= "boolean" then return false end
    return { enabled = source.enabled }
end

local function validateFinishRequirements(source, path, errors)
    if source == nil then return nil end
    if type(source) ~= "table" then
        addError(errors, path, "must be an object")
        return nil
    end
    validateKnownKeys(source, VALID_FINISH_REQUIREMENTS, path, errors)
    local result = {}
    for requirement in pairs(VALID_FINISH_REQUIREMENTS) do
        if source[requirement] ~= nil then
            if type(source[requirement]) ~= "boolean" then
                addError(errors, path .. "." .. requirement, "must be true or false")
            else
                result[requirement] = source[requirement]
            end
        end
    end
    return result
end

local function knownScopes()
    local categories, subcategories = {}, {}
    local list = Registry:list()
    for definitionIndex = 1, #list do
        local definition = list[definitionIndex]
        local category = tostring(definition.category or "General")
        local subcategory = tostring(definition.subcategory or "General")
        categories[category] = true
        subcategories[category] = subcategories[category] or {}
        subcategories[category][subcategory] = true
    end
    return categories, subcategories
end

local function knownStageIds(definition)
    local ids = {}
    local function addStages(stages)
        stages = stages or {}
        for stageIndex = 1, #stages do
            local stage = stages[stageIndex]
            local id = tostring(stage.id or "")
            ids[id] = ids[id] or {}
            ids[id][#ids[id] + 1] = stage
        end
    end
    addStages(definition and definition.stages)
    local variants = (definition and definition.variants) or {}
    for variantIndex = 1, #variants do addStages(variants[variantIndex].stages) end
    local materials = (definition and definition.materialOptions) or {}
    for materialIndex = 1, #materials do addStages(materials[materialIndex].stages) end
    return ids
end

local function validScriptItem(fullType)
    if not shortString(fullType) then return false end
    local manager = getScriptManager and getScriptManager() or nil
    return manager ~= nil and manager:getItem(fullType) ~= nil
end

local function validTag(tagName)
    if not shortString(tagName) or not string.find(tagName, ":", 1, true) then return false end
    if string.find(tagName, "[^%w_:%-%.]", 1) then return false end
    if not KBWB41 then return false end
    local tag = KBWB41.tagName(tagName)
    return tag ~= nil
end

local function validRecipe(recipeName)
    if not shortString(recipeName) then return false end
    local manager = getScriptManager and getScriptManager() or nil
    if not manager then return false end
    return KBWB41.call(manager, "getCraftRecipe", recipeName) ~= nil
        or manager:getRecipe(recipeName) ~= nil
end

local function validateStringArray(source, path, maximum, validator, errors)
    if type(source) ~= "table" then
        addError(errors, path, "must be a list")
        return nil
    end
    if #source > maximum then addError(errors, path, "contains too many entries") end
    local result, seen = {}, {}
    for valueIndex = 1, math.min(#source, maximum) do
        local value = source[valueIndex]
        if not validator(value) then
            addError(errors, path .. "[" .. tostring(valueIndex) .. "]", "is unknown or invalid")
        elseif seen[value] then
            addError(errors, path .. "[" .. tostring(valueIndex) .. "]", "is duplicated")
        else
            seen[value] = true
            result[#result + 1] = value
        end
    end
    return result
end

local function validateInput(source, path, ids, errors)
    if type(source) ~= "table" then
        addError(errors, path, "must be an input")
        return nil
    end
    validateKnownKeys(source, {
        id = true, role = true, mode = true, resourceType = true, items = true, tags = true,
        amount = true, amountMax = true, uses = true, flags = true, label = true, labelKey = true,
        icon = true, materialTags = true
    }, path, errors)
    local id = source.id
    if not shortString(id) then
        addError(errors, path .. ".id", "must be a non-empty id")
        return nil
    end
    if ids[id] then addError(errors, path .. ".id", "must be unique") end
    ids[id] = true
    local role = source.role or "material"
    local mode = source.mode or (role == "tool" and "keep" or "consume")
    if not VALID_ROLES[role] then addError(errors, path .. ".role", "is invalid") end
    if not VALID_MODES[mode] then addError(errors, path .. ".mode", "is invalid") end
    if source.resourceType ~= nil and source.resourceType ~= "Item" then
        addError(errors, path .. ".resourceType", "custom requirements currently support Item resources only")
    end
    local items = source.items and validateStringArray(source.items, path .. ".items", 64, validScriptItem, errors) or {}
    local tags = source.tags and validateStringArray(source.tags, path .. ".tags", 64, validTag, errors) or {}
    if #items == 0 and #tags == 0 then addError(errors, path, "must accept at least one item or tag") end
    local amount = source.amount
    local amountMax = source.amountMax
    local uses = source.uses
    if amount ~= nil and not boundedNumber(amount, 0.01, MAX_NUMBER) then
        addError(errors, path .. ".amount", "must be greater than zero")
    end
    if uses ~= nil and not boundedNumber(uses, 0.01, MAX_NUMBER) then
        addError(errors, path .. ".uses", "must be greater than zero")
    end
    if amountMax ~= nil and not boundedNumber(amountMax, 0.01, MAX_NUMBER) then
        addError(errors, path .. ".amountMax", "must be greater than zero")
    end
    if amount == nil and uses == nil then amount = 1 end
    local flags = {}
    local sourceFlags = source.flags or {}
    if type(sourceFlags) ~= "table" then
        addError(errors, path .. ".flags", "must be a list")
    else
        local seenFlags = {}
        for flagIndex = 1, #sourceFlags do
            local flag = sourceFlags[flagIndex]
            if not VALID_FLAGS[flag] then
                addError(errors, path .. ".flags[" .. tostring(flagIndex) .. "]", "is unsupported")
            elseif not seenFlags[flag] then
                seenFlags[flag] = true
                flags[#flags + 1] = flag
            end
        end
    end
    local result = {
        id = id,
        role = VALID_ROLES[role] and role or "material",
        mode = VALID_MODES[mode] and mode or "consume",
        resourceType = "Item",
        items = items,
        tags = tags,
        amount = amount,
        amountMax = amountMax,
        uses = uses,
        flags = flags
    }
    local optionalStrings = { "label", "labelKey", "icon" }
    for keyIndex = 1, #optionalStrings do
        local key = optionalStrings[keyIndex]
        if source[key] ~= nil then
            if shortString(source[key]) then
                result[key] = source[key]
            else
                addError(errors, path .. "." .. key, "is invalid")
            end
        end
    end
    if source.materialTags ~= nil then
        result.materialTags = validateStringArray(
            source.materialTags, path .. ".materialTags", 64, shortString, errors
        )
    end
    return result
end

local function validatePerkMap(source, path, maximumValue, errors)
    if type(source) ~= "table" then
        addError(errors, path, "must be a perk map")
        return nil
    end
    local result, count = {}, 0
    local keys = TableUtil.sortedKeys(source)
    if #keys > MAX_SKILLS then addError(errors, path, "contains too many perks") end
    for keyIndex = 1, math.min(#keys, MAX_SKILLS) do
        local perkName = keys[keyIndex]
        local amount = source[perkName]
        count = count + 1
        if not shortString(perkName) or not Perks[perkName] then
            addError(errors, path .. "." .. tostring(perkName), "is an unknown perk")
        elseif not boundedNumber(amount, 0, maximumValue) then
            addError(errors, path .. "." .. tostring(perkName), "is outside the allowed range")
        else
            result[perkName] = amount
        end
    end
    return result
end

function Rules.canOverrideRequirements(definition, stage)
    if not definition or not stage then return true end
    local stageId = tostring(stage.__kbwStageId or stage.id or "")
    local matchingStages = knownStageIds(definition)[stageId] or { stage }
    for stageIndex = 1, #matchingStages do
        local candidate = matchingStages[stageIndex]
        if EntityCompat.usesNativeRecipeInputs(candidate) then
            local callback = StageConfig.sprite(definition, candidate).onCreate
            if LuaCallback.requiresNativeRecipe(callback) then return false end
        end
    end
    return true
end

function Rules.canOverrideInputs(definition, stage)
    return Rules.canOverrideRequirements(definition, stage)
end

local function validateStageRule(source, path, definition, stages, errors)
    if type(source) ~= "table" then
        addError(errors, path, "must be a stage rule")
        return nil
    end
    validateKnownKeys(source, {
        inputs = true, skills = true, xp = true, recipes = true, needToBeLearned = true, time = true
    }, path, errors)
    local result = {}
    local overridesRequirements = source.inputs ~= nil or source.skills ~= nil
        or source.recipes ~= nil or source.needToBeLearned ~= nil
    local canOverrideRequirements = true
    if overridesRequirements then
        for stageIndex = 1, #(stages or {}) do
            if not Rules.canOverrideRequirements(definition, stages[stageIndex]) then
                canOverrideRequirements = false
                break
            end
        end
        if not canOverrideRequirements then
            addError(
                errors, path,
                "cannot replace inputs, skills, or recipe knowledge because this buildable requires its native recipe"
            )
        end
    end
    if source.inputs ~= nil then
        if not canOverrideRequirements then
        elseif type(source.inputs) ~= "table" then
            addError(errors, path .. ".inputs", "must be a list")
        else
            if #source.inputs > MAX_INPUTS then addError(errors, path .. ".inputs", "contains too many inputs") end
            result.inputs = {}
            local ids = {}
            for inputIndex = 1, math.min(#source.inputs, MAX_INPUTS) do
                local input = validateInput(source.inputs[inputIndex], path .. ".inputs[" .. tostring(inputIndex) .. "]", ids, errors)
                if input then result.inputs[#result.inputs + 1] = input end
            end
        end
    end
    if source.skills ~= nil and canOverrideRequirements then
        result.skills = validatePerkMap(source.skills, path .. ".skills", 10, errors)
    end
    if source.xp ~= nil then result.xp = validatePerkMap(source.xp, path .. ".xp", MAX_NUMBER, errors) end
    if source.recipes ~= nil and canOverrideRequirements then
        result.recipes = validateStringArray(source.recipes, path .. ".recipes", MAX_RECIPES, validRecipe, errors)
    end
    if source.needToBeLearned ~= nil and canOverrideRequirements then
        if type(source.needToBeLearned) ~= "boolean" then
            addError(errors, path .. ".needToBeLearned", "must be true or false")
        else
            result.needToBeLearned = source.needToBeLearned
        end
    end
    if source.time ~= nil then
        if not boundedNumber(source.time, 1, MAX_NUMBER) then
            addError(errors, path .. ".time", "must be between 1 and " .. tostring(MAX_NUMBER))
        else
            result.time = source.time
        end
    end
    return result
end

function Rules.validateDocument(source)
    local errors = {}
    if type(source) ~= "table" then return nil, { "document: must be an object" } end
    validateKnownKeys(source, {
        version = true, revision = true, categories = true, subcategories = true,
        wallFinishRequirements = true, buildables = true
    }, "document", errors)
    if source.version ~= nil and tonumber(source.version) ~= Rules.VERSION then
        addError(errors, "version", "is unsupported")
    end
    local result = emptyDocument()
    result.revision = math.max(0, math.floor(tonumber(source.revision) or 0))
    result.wallFinishRequirements = validateFinishRequirements(
        source.wallFinishRequirements or {}, "wallFinishRequirements", errors
    ) or {}
    local categories, subcategories = knownScopes()
    local categorySource = source.categories or {}
    if type(categorySource) ~= "table" then
        addError(errors, "categories", "must be an object")
    else
        local categoryKeys = TableUtil.sortedKeys(categorySource)
        for categoryIndex = 1, #categoryKeys do
            local category = categoryKeys[categoryIndex]
            if not categories[category] then
                addError(errors, "categories." .. tostring(category), "is unknown")
            else
                validateKnownKeys(categorySource[category], { enabled = true }, "categories." .. category, errors)
                local rule = copyBooleanRule(categorySource[category])
                if rule == false then
                    addError(errors, "categories." .. category .. ".enabled", "must be true or false")
                elseif rule then
                    result.categories[category] = rule
                end
            end
        end
    end
    local subcategorySource = source.subcategories or {}
    if type(subcategorySource) ~= "table" then
        addError(errors, "subcategories", "must be an object")
    else
        local categoryKeys = TableUtil.sortedKeys(subcategorySource)
        for categoryIndex = 1, #categoryKeys do
            local category = categoryKeys[categoryIndex]
            local scoped = subcategorySource[category]
            if not subcategories[category] or type(scoped) ~= "table" then
                addError(errors, "subcategories." .. tostring(category), "is unknown")
            else
                local subcategoryKeys = TableUtil.sortedKeys(scoped)
                for subcategoryIndex = 1, #subcategoryKeys do
                    local subcategory = subcategoryKeys[subcategoryIndex]
                    if not subcategories[category][subcategory] then
                        addError(errors, "subcategories." .. category .. "." .. tostring(subcategory), "is unknown")
                    else
                        validateKnownKeys(
                            scoped[subcategory], { enabled = true },
                            "subcategories." .. category .. "." .. subcategory, errors
                        )
                        local rule = copyBooleanRule(scoped[subcategory])
                        if rule == false then
                            addError(errors, "subcategories." .. category .. "." .. subcategory .. ".enabled", "must be true or false")
                        elseif rule then
                            result.subcategories[category] = result.subcategories[category] or {}
                            result.subcategories[category][subcategory] = rule
                        end
                    end
                end
            end
        end
    end
    local buildableSource = source.buildables or {}
    if type(buildableSource) ~= "table" then
        addError(errors, "buildables", "must be an object")
    else
        local buildableIds = TableUtil.sortedKeys(buildableSource)
        for buildableIndex = 1, #buildableIds do
            local buildableId = buildableIds[buildableIndex]
            local definition = Registry:get(buildableId)
            local rawRule = buildableSource[buildableId]
            if not definition then
                addError(errors, "buildables." .. tostring(buildableId), "is unknown")
            elseif type(rawRule) ~= "table" then
                addError(errors, "buildables." .. buildableId, "must be an object")
            else
                validateKnownKeys(
                    rawRule, { enabled = true, finishRequirements = true, stages = true },
                    "buildables." .. buildableId, errors
                )
                local cleanRule = { stages = {} }
                if rawRule.enabled ~= nil then
                    if type(rawRule.enabled) ~= "boolean" then
                        addError(errors, "buildables." .. buildableId .. ".enabled", "must be true or false")
                    else
                        cleanRule.enabled = rawRule.enabled
                    end
                end
                local finishRequirements = validateFinishRequirements(
                    rawRule.finishRequirements, "buildables." .. buildableId .. ".finishRequirements", errors
                )
                if finishRequirements and #TableUtil.sortedKeys(finishRequirements) > 0 then
                    local wallStage = false
                    for _, stages in pairs(knownStageIds(definition)) do
                        for stageIndex = 1, #stages do
                            if Rules.isWallBuildable(definition, stages[stageIndex]) then
                                wallStage = true
                                break
                            end
                        end
                        if wallStage then break end
                    end
                    if wallStage then
                        cleanRule.finishRequirements = finishRequirements
                    else
                        addError(
                            errors, "buildables." .. buildableId .. ".finishRequirements",
                            "can only override wall buildables"
                        )
                    end
                end
                local rawStages = rawRule.stages or {}
                if type(rawStages) ~= "table" then
                    addError(errors, "buildables." .. buildableId .. ".stages", "must be an object")
                else
                    local stageIds = knownStageIds(definition)
                    local ruleStageIds = TableUtil.sortedKeys(rawStages)
                    if #ruleStageIds > MAX_STAGES then
                        addError(errors, "buildables." .. buildableId .. ".stages", "contains too many stages")
                    end
                    for stageIndex = 1, math.min(#ruleStageIds, MAX_STAGES) do
                        local stageId = ruleStageIds[stageIndex]
                        local stages = stageIds[stageId]
                        if not stages then
                            addError(errors, "buildables." .. buildableId .. ".stages." .. tostring(stageId), "is unknown")
                        else
                            cleanRule.stages[stageId] = validateStageRule(
                                rawStages[stageId], "buildables." .. buildableId .. ".stages." .. stageId,
                                definition, stages, errors
                            )
                        end
                    end
                end
                result.buildables[buildableId] = cleanRule
            end
        end
    end
    if #errors > 0 then return nil, errors end
    return result, errors
end

local function definitionFor(definition, stage)
    return (stage and stage.__kbwDefinition) or definition
end

function Rules.isEnabledIn(document, definition, stage)
    if not definition then return false end
    if definition.__kbwGroup == true and stage == nil then
        local members = definition.__kbwMembers or {}
        for memberIndex = 1, #members do
            if Rules.isEnabledIn(document, members[memberIndex], nil) then return true end
        end
        return false
    end
    document = document or emptyDocument()
    local actual = definitionFor(definition, stage)
    local category = tostring((actual and actual.category) or "General")
    local subcategory = tostring((actual and actual.subcategory) or "General")
    local enabled = true
    local categoryRule = (document.categories or {})[category]
    if categoryRule and categoryRule.enabled ~= nil then enabled = categoryRule.enabled end
    local subcategoryRules = (document.subcategories or {})[category]
    local subcategoryRule = subcategoryRules and subcategoryRules[subcategory] or nil
    if subcategoryRule and subcategoryRule.enabled ~= nil then enabled = subcategoryRule.enabled end
    local buildableRule = actual and (document.buildables or {})[actual.id] or nil
    if buildableRule and buildableRule.enabled ~= nil then enabled = buildableRule.enabled end
    return enabled == true
end

function Rules.isEnabled(definition, stage)
    return Rules.isEnabledIn(Rules.document, definition, stage)
end

function Rules.isWallBuildable(definition, stage)
    if not definition then return false end
    local actual = definitionFor(definition, stage)
    return tostring(StageConfig.placement(actual, stage).kind or "") == "wall"
end

function Rules.wallFinishRequirementIn(document, definition, stage, requirement)
    if not VALID_FINISH_REQUIREMENTS[requirement] or not Rules.isWallBuildable(definition, stage) then return true end
    document = document or emptyDocument()
    local actual = definitionFor(definition, stage)
    local buildableRule = actual and (document.buildables or {})[actual.id] or nil
    local overrides = buildableRule and buildableRule.finishRequirements or nil
    if overrides and overrides[requirement] ~= nil then return overrides[requirement] == true end
    local defaults = document.wallFinishRequirements or {}
    if defaults[requirement] ~= nil then return defaults[requirement] == true end
    return true
end

function Rules.wallFinishRequirement(definition, stage, requirement)
    return Rules.wallFinishRequirementIn(Rules.document, definition, stage, requirement)
end

function Rules.effectiveStage(definition, stage)
    if not Rules.isEnabled(definition, stage) then return nil end
    local actual = definitionFor(definition, stage)
    local buildableRule = actual and Rules.document.buildables[actual.id] or nil
    local stageId = tostring((stage and (stage.__kbwStageId or stage.id)) or "")
    local rule = buildableRule and buildableRule.stages and buildableRule.stages[stageId] or nil
    if not rule then return stage end
    local effective = TableUtil.copy(stage)
    local requirements = TableUtil.copy(effective.requirements or {})
    local overridesRequirements = rule.inputs ~= nil or rule.skills ~= nil
        or rule.recipes ~= nil or rule.needToBeLearned ~= nil
    if rule.inputs ~= nil then
        requirements.inputs = TableUtil.copy(rule.inputs)
        requirements.materials = nil
        requirements.tools = nil
    end
    if rule.skills ~= nil then requirements.skills = TableUtil.copy(rule.skills) end
    if rule.recipes ~= nil then
        requirements.recipes = TableUtil.copy(rule.recipes)
        requirements.knowledge = TableUtil.copy(requirements.knowledge or {})
        requirements.knowledge.recipes = {}
    end
    if rule.needToBeLearned ~= nil then
        requirements.knowledge = TableUtil.copy(requirements.knowledge or {})
        requirements.knowledge.needToBeLearned = rule.needToBeLearned
    end
    if overridesRequirements then effective._kbwNativeRecipeInputs = false end
    effective.requirements = requirements
    if rule.xp ~= nil then
        effective.xp = TableUtil.copy(rule.xp)
        effective._kbwAdminXpOverride = true
    end
    if rule.time ~= nil then
        effective.construction = TableUtil.copy(effective.construction or {})
        effective.construction.time = rule.time
    end
    return effective
end

function Rules.getDocument()
    return TableUtil.copy(Rules.document)
end

function Rules.addListener(listener)
    if type(listener) ~= "function" then return end
    Rules.listeners[#Rules.listeners + 1] = listener
end

function Rules.applySync(document, revision)
    local normalized, errors = Rules.validateDocument(document or {})
    if not normalized then return false, errors end
    normalized.revision = math.max(0, math.floor(tonumber(revision) or tonumber(normalized.revision) or 0))
    Rules.document = normalized
    Rules.revision = normalized.revision
    Rules.ready = true
    for listenerIndex = 1, #Rules.listeners do Rules.listeners[listenerIndex](Rules.getDocument(), Rules.revision) end
    return true, {}
end

function Rules.reset()
    Rules.document = emptyDocument()
    Rules.revision = 0
    Rules.ready = false
end

function Rules.request(player)
    if isClient and isClient() and sendClientCommand then
        sendClientCommand(player, KBW.NETWORK_MODULE, "BuildableRulesRequest", {})
        return
    end
    for listenerIndex = 1, #Rules.listeners do Rules.listeners[listenerIndex](Rules.getDocument(), Rules.revision) end
end

function Rules.submit(player, document, baseRevision)
    if isClient and isClient() and sendClientCommand then
        sendClientCommand(player, KBW.NETWORK_MODULE, "BuildableRulesSave", {
            document = document,
            baseRevision = baseRevision
        })
        return true
    end
    local RulesServer = require("KnoxBuildworks/Admin/BuildableRulesServer")
    return RulesServer.saveFromAdmin(player, document, baseRevision)
end

return Rules
