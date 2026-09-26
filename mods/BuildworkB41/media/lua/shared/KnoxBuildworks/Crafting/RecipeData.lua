local KBWB41 = require("KnoxBuildworks/Compat/B41")
local RecipeData = {}
RecipeData.__index = RecipeData

local function hasFlag(input, wanted)
    local flags = input and input.flags or {}
    for flagIndex = 1, #flags do
        if flags[flagIndex] == wanted then return true end
    end
    return false
end

local function javaList(values)
    local result = ArrayList.new()
    for valueIndex = 1, #values do result:add(values[valueIndex]) end
    return result
end

local function appendUnique(values, seen, item)
    if not item then return end
    local key = tostring(item)
    if seen[key] then return end
    seen[key] = true
    values[#values + 1] = item
end

function RecipeData.new(recipe, character)
    return setmetatable({
        recipe = recipe,
        character = character,
        inputs = {},
        allInputs = {},
        allInputSeen = {},
        consumed = {},
        consumedSeen = {},
        recordedConsumed = {},
        recordedConsumedSeen = {},
        kept = {},
        keptSeen = {}
    }, RecipeData)
end

function RecipeData:record(input, item, inputIndex)
    if not input or not item then return end
    inputIndex = tonumber(inputIndex) or 1
    local entry = self.inputs[inputIndex]
    if not entry then
        entry = { input = input, items = {}, seen = {} }
        self.inputs[inputIndex] = entry
    end
    appendUnique(entry.items, entry.seen, item)
    appendUnique(self.allInputs, self.allInputSeen, item)
    if input.mode == "keep" then
        appendUnique(self.kept, self.keptSeen, item)
        return
    end
    appendUnique(self.consumed, self.consumedSeen, item)
    if not hasFlag(input, "DontRecordInput") then
        appendUnique(self.recordedConsumed, self.recordedConsumedSeen, item)
    end
end

function RecipeData:getRecipe()
    return self.recipe
end

function RecipeData:getCharacter()
    return self.character
end

function RecipeData:getAllInputItems()
    return javaList(self.allInputs)
end

function RecipeData:getAllConsumedItems()
    return javaList(self.consumed)
end

function RecipeData:getAllRecordedConsumedItems()
    return javaList(self.recordedConsumed)
end

function RecipeData:getAllKeepInputItems()
    return javaList(self.kept)
end

function RecipeData:getInputItems(index)
    local entry = self.inputs[(tonumber(index) or 0) + 1]
    return entry and javaList(entry.items) or ArrayList.new()
end

function RecipeData:getAllInputItemsWithFlag(flag)
    local result = {}
    local seen = {}
    for inputIndex = 1, #self.inputs do
        local entry = self.inputs[inputIndex]
        if entry and hasFlag(entry.input, tostring(flag)) then
            for itemIndex = 1, #entry.items do appendUnique(result, seen, entry.items[itemIndex]) end
        end
    end
    return javaList(result)
end

function RecipeData:getFirstInputItemWithFlag(flag)
    local items = self:getAllInputItemsWithFlag(flag)
    return items:isEmpty() and nil or items:get(0)
end

function RecipeData:getFirstInputItemWithTag(tag)
    local resolved = tag
    if type(tag) == "string" and KBWB41 then
        resolved = KBWB41.tagName(tag)
    end
    if not resolved then return nil end
    for itemIndex = 1, #self.allInputs do
        local item = self.allInputs[itemIndex]
        if item and item.hasTag and item:hasTag(resolved) then return item end
    end
    return nil
end

function RecipeData:getAllDestroyInputItems()
    local result = {}
    local seen = {}
    for inputIndex = 1, #self.inputs do
        local entry = self.inputs[inputIndex]
        if entry and entry.input.mode == "destroy" then
            for itemIndex = 1, #entry.items do appendUnique(result, seen, entry.items[itemIndex]) end
        end
    end
    return javaList(result)
end

return RecipeData
