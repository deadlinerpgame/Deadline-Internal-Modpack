local Registry = require("KnoxBuildworks/Definitions/Registry")
local Resolver = require("KnoxBuildworks/Definitions/Resolver")
local Requirements = require("KnoxBuildworks/Validation/Requirements")
local Integrity = require("KnoxBuildworks/Network/Integrity")
local I18n = require("KnoxBuildworks/I18n")
local KBWB41 = require("KnoxBuildworks/Compat/B41")

local BuildTestRunner = {}

local STATE_KEY = "KBWBuildTestRunner"
local STATE_VERSION = 1

local function optionIds(options, required)
    local result = {}
    if required ~= true then result[#result + 1] = "" end
    options = options or {}
    for optionIndex = 1, #options do
        local option = options[optionIndex]
        if option.id and option.id ~= "" then result[#result + 1] = tostring(option.id) end
    end
    return result
end

local function caseKey(buildableId, stageId, variantId, materialId)
    return table.concat({ buildableId or "", stageId or "", variantId or "", materialId or "" }, "|")
end

local function persist(player)
    if isClient() and player and player.transmitModData then player:transmitModData() end
end

function BuildTestRunner.state(player)
    local root = player:getModData()
    local state = root[STATE_KEY]
    if type(state) ~= "table" or state.version ~= STATE_VERSION then
        state = {
            version = STATE_VERSION,
            category = "All",
            subcategory = "All",
            resultFilter = "All",
            currentKey = "",
            results = {}
        }
        root[STATE_KEY] = state
    end
    state.results = state.results or {}
    return state
end

function BuildTestRunner.cases()
    local result = {}
    local definitions = Registry:list()
    for definitionIndex = 1, #definitions do
        local base = definitions[definitionIndex]
        local variants = optionIds(base.variants, false)
        local materials = optionIds(base.materialOptions, base.materialRequired == true)
        for variantIndex = 1, #variants do
            local variantId = variants[variantIndex]
            for materialIndex = 1, #materials do
                local materialId = materials[materialIndex]
                local definition = Resolver.resolve(base.id, variantId, materialId)
                local stages = definition and definition.stages or {}
                for stageIndex = 1, #stages do
                    local stage = stages[stageIndex]
                    local group = definition.group or {}
                    result[#result + 1] = {
                        key = caseKey(base.id, stage.id, variantId, materialId),
                        buildableId = base.id,
                        stageId = stage.id,
                        variantId = variantId,
                        materialId = materialId,
                        category = tostring(definition.category or "Other"),
                        subcategory = tostring(definition.subcategory or "General"),
                        groupId = tostring(group.id or ""),
                        groupLevel = tonumber(group.level) or 0,
                        stageLevel = tonumber(stage.level) or stageIndex,
                        definition = definition,
                        stage = stage
                    }
                end
            end
        end
    end
    table.sort(result, function (a, b)
        local left = table.concat({
            a.category,
            a.subcategory,
            a.groupId,
            string.format("%05d", a.groupLevel),
            a.buildableId,
            a.variantId,
            a.materialId,
            string.format("%05d", a.stageLevel)
        }, "|")
        local right = table.concat({
            b.category,
            b.subcategory,
            b.groupId,
            string.format("%05d", b.groupLevel),
            b.buildableId,
            b.variantId,
            b.materialId,
            string.format("%05d", b.stageLevel)
        }, "|")
        return left < right
    end)
    return result
end

function BuildTestRunner.caseName(testCase)
    local parts = { I18n.definitionName(testCase.definition) }
    local stages = testCase.definition.stages or {}
    if #stages > 1 then parts[#parts + 1] = I18n.optionName(testCase.stage, testCase.stageId) end
    if testCase.variantId ~= "" then parts[#parts + 1] = testCase.variantId end
    if testCase.materialId ~= "" then parts[#parts + 1] = testCase.materialId end
    return table.concat(parts, " / ")
end

function BuildTestRunner.categories(cases)
    local seen = {}
    local result = { "All" }
    for caseIndex = 1, #cases do
        local value = cases[caseIndex].category
        if not seen[value] then
            seen[value] = true
            result[#result + 1] = value
        end
    end
    table.sort(result, function (a, b)
        if a == "All" then return true end
        if b == "All" then return false end
        return a < b
    end)
    return result
end

function BuildTestRunner.subcategories(cases, category)
    local seen = {}
    local result = { "All" }
    for caseIndex = 1, #cases do
        local testCase = cases[caseIndex]
        local value = testCase.subcategory
        if (category == "All" or testCase.category == category) and not seen[value] then
            seen[value] = true
            result[#result + 1] = value
        end
    end
    table.sort(result, function (a, b)
        if a == "All" then return true end
        if b == "All" then return false end
        return a < b
    end)
    return result
end

function BuildTestRunner.filteredCases(player, cases)
    local state = BuildTestRunner.state(player)
    local result = {}
    for caseIndex = 1, #cases do
        local testCase = cases[caseIndex]
        local status = state.results[testCase.key] and state.results[testCase.key].status or "pending"
        local categoryMatches = state.category == "All" or testCase.category == state.category
        local subcategoryMatches = state.subcategory == "All" or testCase.subcategory == state.subcategory
        local resultMatches = state.resultFilter == "All" or string.lower(state.resultFilter) == status
        if categoryMatches and subcategoryMatches and resultMatches then result[#result + 1] = testCase end
    end
    return result
end

function BuildTestRunner.scopeCases(player, cases)
    local state = BuildTestRunner.state(player)
    local result = {}
    for caseIndex = 1, #cases do
        local testCase = cases[caseIndex]
        if (state.category == "All" or testCase.category == state.category)
            and (state.subcategory == "All" or testCase.subcategory == state.subcategory) then
            result[#result + 1] = testCase
        end
    end
    return result
end

local function grantSkillsAndKnowledge(player, testCase, changes)
    local requirements = testCase.stage.requirements or {}
    local skills = requirements.skills or {}
    for perkName, requiredLevel in pairs(skills) do
        local perk = Perks and Perks[perkName] or nil
        local level = tonumber(requiredLevel) or 0
        if perk and player:getPerkLevel(perk) < level then
            player:setPerkLevelDebug(perk, level)
            changes[#changes + 1] = tostring(perkName) .. " " .. tostring(level)
        end
    end
    local recipes = {}
    local directRecipes = requirements.recipes or {}
    for recipeIndex = 1, #directRecipes do
        recipes[#recipes + 1] = directRecipes[recipeIndex]
    end
    local knowledgeRecipes = (requirements.knowledge or {}).recipes or {}
    for recipeIndex = 1, #knowledgeRecipes do
        recipes[#recipes + 1] = knowledgeRecipes[recipeIndex]
    end
    for recipeIndex = 1, #recipes do
        local recipe = tostring(recipes[recipeIndex])
        if recipe ~= "" and not KBWB41.isRecipeKnown(player, recipe) then
            player:learnRecipe(recipe)
            changes[#changes + 1] = recipe
        end
    end
end

local function inputItemType(input)
    local items = input.items or {}
    if #items > 0 then return items[1] end
    local possible = Requirements.possibleItems(input)
    if #possible > 0 then return possible[1] end
    return nil
end

local function isSpawnedTestItem(item)
    local data = item and item.getModData and item:getModData() or nil
    return data and data.KBWDebugBuildTest ~= nil
end

local function cleanupSpawnedItems(player)
    local inventory = player:getInventory()
    local items = inventory:getAllEvalRecurse(isSpawnedTestItem, ArrayList.new())
    for itemIndex = items:size() - 1, 0, -1 do
        local item = items:get(itemIndex)
        player:removeFromHands(item)
        local container = item:getContainer()
        if container then container:Remove(item) end
    end
end

local function itemUnits(item, uses)
    if not item then return 0 end
    if uses and instanceof(item, "DrainableComboItem") then return math.max(0, KBWB41.usesLeft(item)) end
    return 1
end

local function spawnInput(player, input, choices, spawned)
    if tostring(input.resourceType or "Item") ~= "Item" then
        return false, getText("IGUI_KBW_DebugTestUnsupportedResource", tostring(input.resourceType))
    end
    local fullType = inputItemType(input)
    if not fullType then
        return false, getText("IGUI_KBW_DebugTestUnresolvedInput", tostring(input.id))
    end
    local needed = tonumber(input.uses or input.amount) or 1
    local uses = input.uses ~= nil or input.mode == "drain"
    local supplied = 0
    local guard = 0
    while supplied < needed and guard < math.max(needed + 8, 64) do
        guard = guard + 1
        local item = player:getInventory():AddItem(fullType)
        if not item then
            return false, getText("IGUI_KBW_DebugTestSpawnFailed", tostring(fullType))
        end
        local modData = item:getModData()
        modData.KBWDebugBuildTest = tostring(input.id or "input")
        local units = itemUnits(item, uses)
        if uses and instanceof(item, "DrainableComboItem") and units <= 0 then
            item:setUsedDelta(1.0)
            units = KBWB41.usesLeft(item)
        end
        supplied = supplied + units
        spawned[#spawned + 1] = {
            inputId = tostring(input.id or "input"),
            fullType = fullType,
            needed = needed,
            supplied = units,
            mode = tostring(input.mode or "consume")
        }
    end
    choices[tostring(input.id)] = fullType
    return supplied >= needed,
        supplied >= needed and nil or getText("IGUI_KBW_DebugTestSpawnFailed", tostring(fullType))
end

function BuildTestRunner.prepare(player, testCase)
    if not player or not testCase then return false, getText("IGUI_KBW_DebugTestNoSelection") end
    if isClient() then return false, getText("IGUI_KBW_DebugTestSingleplayerOnly") end
    if player:isBuildCheat() then return false, getText("IGUI_KBW_DebugTestDisableBuildCheat") end
    if not Integrity.isAllowed(player) then return false, getText("IGUI_KBW_IntegrityMismatchShort") end
    local placement = testCase.definition.placement or {}
    if placement.kind == "wallCovering" then
        return false, getText("IGUI_KBW_DebugTestWallCoveringManual")
    end

    cleanupSpawnedItems(player)
    local inputs = Requirements.getInputs(testCase.definition, testCase.stage)
    local choices = {}
    local spawned = {}
    for inputIndex = 1, #inputs do
        local ok, reason = spawnInput(player, inputs[inputIndex], choices, spawned)
        if not ok then return false, reason end
    end
    local changes = {}
    grantSkillsAndKnowledge(player, testCase, changes)

    if not KBWBuildingObject then require("KnoxBuildworks/BuildingObjects/KBWBuildingObject") end
    local cursor = KBWBuildingObject:new(
        player, testCase.buildableId, testCase.stageId, testCase.variantId, testCase.materialId, 1, choices
    )
    if not cursor or cursor.blockBuild then return false, getText("IGUI_KBW_DebugTestCursorFailed") end
    getCell():setDrag(cursor, player:getPlayerNum())

    local state = BuildTestRunner.state(player)
    state.currentKey = testCase.key
    state.prepared = {
        key = testCase.key,
        spawned = spawned,
        granted = changes,
        startedAt = getGameTime():getWorldAgeHours()
    }
    persist(player)
    triggerEvent("OnContainerUpdate")
    return true, nil
end

function BuildTestRunner.findCase(cases, key)
    for caseIndex = 1, #cases do
        if cases[caseIndex].key == key then return cases[caseIndex], caseIndex end
    end
    return nil, nil
end

function BuildTestRunner.firstPending(player, cases, afterKey)
    local state = BuildTestRunner.state(player)
    local startIndex = 1
    if afterKey and afterKey ~= "" then
        local _, foundIndex = BuildTestRunner.findCase(cases, afterKey)
        if foundIndex then startIndex = foundIndex + 1 end
    end
    for pass = 1, 2 do
        local first = pass == 1 and startIndex or 1
        local last = pass == 1 and #cases or math.max(0, startIndex - 1)
        for caseIndex = first, last do
            local testCase = cases[caseIndex]
            local result = state.results[testCase.key]
            if not result or result.status == "pending" then return testCase, caseIndex end
        end
    end
    return nil, nil
end

function BuildTestRunner.record(player, testCase, status, note)
    if not player or not testCase then return end
    getCell():setDrag(nil, player:getPlayerNum())
    local state = BuildTestRunner.state(player)
    state.results[testCase.key] = {
        status = status,
        note = tostring(note or ""),
        buildableId = testCase.buildableId,
        stageId = testCase.stageId,
        variantId = testCase.variantId,
        materialId = testCase.materialId,
        updatedAt = getGameTime():getWorldAgeHours()
    }
    state.currentKey = testCase.key
    state.prepared = nil
    persist(player)
end

function BuildTestRunner.resetScope(player, cases)
    local state = BuildTestRunner.state(player)
    for caseIndex = 1, #cases do
        state.results[cases[caseIndex].key] = nil
    end
    state.currentKey = ""
    state.prepared = nil
    persist(player)
end

return BuildTestRunner
