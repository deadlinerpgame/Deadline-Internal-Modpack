local TableUtil = require("KnoxBuildworks/Util/Table")
local I18n = require("KnoxBuildworks/I18n")

local Groups = {}

local function displayName(definition)
    return I18n.definitionName(definition)
end

local function safeId(value)
    value = string.lower(tostring(value or "group"))
    value = string.gsub(value, "[^%w]+", "_")
    value = string.gsub(value, "_+", "_")
    value = string.gsub(value, "^_+", "")
    value = string.gsub(value, "_+$", "")
    if value == "" then value = "group" end
    return value
end

local function groupInfo(definition)
    local group = definition and definition.group
    if type(group) ~= "table" or group.id == nil then return nil end
    return {
        key = tostring(group.id),
        id = "kbw.group." .. safeId(group.id),
        level = tonumber(group.level) or 1,
        baseName = group.name and tostring(group.name) or nil,
        translationKey = group.translationKey or I18n.groupKey(group.id)
    }
end

local function mergeStringList(target, values)
    values = values or {}
    for valueIndex = 1, #values do
        local value = values[valueIndex]
        local exists = false
        for targetIndex = 1, #target do
            if target[targetIndex] == value then exists = true end
        end
        if not exists then target[#target + 1] = value end
    end
end

local function buildGroup(info, members)
    table.sort(members, function (a, b)
        if a.level ~= b.level then return a.level < b.level end
        return tostring(a.definition.id) < tostring(b.definition.id)
    end)
    local first = members[1].definition
    local group = TableUtil.copy(first)
    group.id = info.id
    group.displayName = info.baseName or displayName(first)
    group.translationKey = info.translationKey
    group.group = nil
    group.__kbwGroup = true
    group.__kbwGroupKey = info.key
    group.__kbwMembers = {}
    group.tags = {}
    group.materialTags = {}
    group.stages = {}
    for memberIndex = 1, #members do
        local member = members[memberIndex].definition
        group.__kbwMembers[#group.__kbwMembers + 1] = member
        mergeStringList(group.tags, member.tags)
        mergeStringList(group.materialTags, member.materialTags)
        local stages = member.stages or {}
        for stageIndex = 1, #stages do
            local stage = TableUtil.copy(stages[stageIndex])
            stage.__kbwBuildableId = member.id
            stage.__kbwStageId = stages[stageIndex].id
            stage.__kbwDefinition = member
            stage.__kbwGroupIndex = #group.stages + 1
            stage.level = members[memberIndex].level or stage.level or #group.stages + 1
            stage.label = displayName(member)
            group.stages[#group.stages + 1] = stage
        end
    end
    group.icon = first.icon
    group.iconTexture = first.iconTexture
    group.iconName = first.iconName
    group.iconSprite = first.iconSprite
    group.iconItem = first.iconItem
    return group
end

function Groups.groupedList(definitions)
    local buckets = {}
    local bucketOrder = {}
    local ungrouped = {}
    definitions = definitions or {}
    for definitionIndex = 1, #definitions do
        local definition = definitions[definitionIndex]
        local info = groupInfo(definition)
        if info then
            local bucket = buckets[info.key]
            if not bucket then
                bucket = { info = info, members = {} }
                buckets[info.key] = bucket
                bucketOrder[#bucketOrder + 1] = info.key
            end
            bucket.members[#bucket.members + 1] = { definition = definition, level = info.level }
            if not bucket.info.baseName and info.baseName then bucket.info.baseName = info.baseName end
        else
            ungrouped[#ungrouped + 1] = definition
        end
    end

    local result = {}
    for ungroupedIndex = 1, #ungrouped do
        result[#result + 1] = ungrouped[ungroupedIndex]
    end
    for orderIndex = 1, #bucketOrder do
        local bucket = buckets[bucketOrder[orderIndex]]
        if #bucket.members > 1 then
            result[#result + 1] = buildGroup(bucket.info, bucket.members)
        else
            result[#result + 1] = bucket.members[1].definition
        end
    end
    local names = {}
    for resultIndex = 1, #result do
        local entry = result[resultIndex]
        names[entry] = displayName(entry)
    end
    table.sort(result, function (a, b)
        local nameA = names[a]
        local nameB = names[b]
        if nameA ~= nameB then return nameA < nameB end
        return tostring(a.id) < tostring(b.id)
    end)
    return result
end

function Groups.isGroup(definition)
    return definition and definition.__kbwGroup == true
end

function Groups.resolveDefinition(definition, stage)
    if stage and stage.__kbwDefinition then return stage.__kbwDefinition end
    return definition
end

function Groups.resolveBuildableId(definition, stage)
    if stage and stage.__kbwBuildableId then return stage.__kbwBuildableId end
    return definition and definition.id or nil
end

function Groups.resolveStageId(stage)
    if stage and stage.__kbwStageId then return stage.__kbwStageId end
    return stage and stage.id or nil
end

function Groups.anyMemberIn(definition, idSet)
    if not definition then return false end
    if not Groups.isGroup(definition) then return idSet[definition.id] == true end
    local members = definition.__kbwMembers or {}
    for memberIndex = 1, #members do
        if idSet[members[memberIndex].id] then return true end
    end
    return false
end

function Groups.memberIds(definition)
    local ids = {}
    if not Groups.isGroup(definition) then
        if definition and definition.id then ids[#ids + 1] = definition.id end
        return ids
    end
    local members = definition.__kbwMembers or {}
    for memberIndex = 1, #members do
        ids[#ids + 1] = members[memberIndex].id
    end
    return ids
end

return Groups
