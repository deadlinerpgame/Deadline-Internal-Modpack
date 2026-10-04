local KBW = require("KnoxBuildworks/Core")
local Hash = require("KnoxBuildworks/Util/Hash")
local TableUtil = require("KnoxBuildworks/Util/Table")
local Log = require("KnoxBuildworks/Log")
local WallFinishes = require("KnoxBuildworks/Validation/WallFinishes")

local Registry = {
    entries = {},
    aliases = {},
    sprites = {},
    spriteReuseAllowed = {},
    spriteDefinitionOwners = {},
    files = {},
    overridesHash = nil,
    hash = "00000000",
    locked = false
}

function Registry:reset()
    self.entries, self.aliases, self.sprites, self.files = {}, {}, {}, {}
    self.spriteReuseAllowed = {}
    self.spriteDefinitionOwners = {}
    self.overridesHash, self.hash, self.locked = nil, "00000000", false
end

function Registry:register(definition, source)
    if self.entries[definition.id] then
        Log:error("Duplicate buildable id '%s' in %s; skipped", definition.id, source)
        return false
    end
    local aliases = definition.aliases or {}
    for aliasIndex = 1, #aliases do
        local alias = aliases[aliasIndex]
        if self.aliases[alias] or self.entries[alias] then
            Log:warning("Duplicate alias '%s' on %s; alias skipped", alias, definition.id)
        else
            self.aliases[alias] = definition.id
        end
    end
    definition.__source = source
    self.entries[definition.id] = definition
    local function prepareFinishStages(stages)
        stages = stages or {}
        for stageIndex = 1, #stages do
            local stage = stages[stageIndex]
            local config = stage.finishes or definition.finishes
            if config then WallFinishes.prepareStage(definition, stage) end
        end
    end
    prepareFinishStages(definition.stages)
    local function indexStages(stages, optionId)
        stages = stages or {}
        for stageIndex = 1, #stages do
            local stage = stages[stageIndex]
            local unique = {}
            for _, sprite in pairs(stage.sprites or {}) do
                unique[sprite] = true
            end
            for _, tiles in pairs(stage.footprints or {}) do
                for tileIndex = 1, #tiles do
                    local tile = tiles[tileIndex]
                    if tile.sprite then unique[tile.sprite] = true end
                end
            end
            for sprite in pairs(unique) do
                self.sprites[sprite] = self.sprites[sprite] or {}
                self.spriteReuseAllowed[sprite] = self.spriteReuseAllowed[sprite] or {}
                self.spriteDefinitionOwners[sprite] = self.spriteDefinitionOwners[sprite] or {}
                local owner = definition.id .. ":" .. (optionId and (optionId .. ":") or "") .. stage.id
                self.sprites[sprite][#self.sprites[sprite] + 1] = owner
                self.spriteReuseAllowed[sprite][#self.spriteReuseAllowed[sprite] + 1] =
                    definition.allowSpriteReuse == true or stage.allowSpriteReuse == true
                self.spriteDefinitionOwners[sprite][#self.spriteDefinitionOwners[sprite] + 1] = definition.id
            end
        end
    end
    indexStages(definition.stages)
    local variants = definition.variants or {}
    for optionIndex = 1, #variants do
        local option = variants[optionIndex]
        prepareFinishStages(option.stages)
        indexStages(option.stages, "variant-" .. tostring(option.id))
    end
    local materialOptions = definition.materialOptions or {}
    for optionIndex = 1, #materialOptions do
        local option = materialOptions[optionIndex]
        prepareFinishStages(option.stages)
        indexStages(option.stages, "material-" .. tostring(option.id))
    end
    Log:debug("Registered %s from %s", definition.id, source)
    return true
end

function Registry:get(id)
    return self.entries[id] or self.entries[self.aliases[id]]
end

function Registry:getStage(definition, stageId)
    definition = type(definition) == "table" and definition or self:get(definition)
    local stages = definition and definition.stages or {}
    for stageIndex = 1, #stages do
        local stage = stages[stageIndex]
        if stage.id == stageId or tostring(stage.level) == tostring(stageId) then
            return stage
        end
    end
    if stageId == nil or stageId == "" then return definition and definition.stages[1] or nil end
    return nil
end

function Registry:list()
    local list = {}
    for _, entry in pairs(self.entries) do
        list[#list + 1] = entry
    end
    table.sort(list, function (a, b) return a.id < b.id end)
    return list
end

function Registry:finalize()
    local sortedEntries = self:list()
    local payload = {}
    for entryIndex = 1, #sortedEntries do
        payload[#payload + 1] = sortedEntries[entryIndex]
    end
    for sprite in pairs(self.sprites) do
        local definitionSet = {}
        local definitionCount = 0
        local definitionOwners = self.spriteDefinitionOwners[sprite] or {}
        for ownerIndex = 1, #definitionOwners do
            local definitionId = definitionOwners[ownerIndex]
            if not definitionSet[definitionId] then
                definitionSet[definitionId] = true
                definitionCount = definitionCount + 1
            end
        end
        if definitionCount > 1 then
            local reuseDeclared = false
            local reuseFlags = self.spriteReuseAllowed[sprite] or {}
            for ownerIndex = 1, #reuseFlags do
                if reuseFlags[ownerIndex] then
                    reuseDeclared = true
                    break
                end
            end
            if not reuseDeclared then
                Log:warning("Sprite '%s' reused by %s", sprite, table.concat(self.sprites[sprite], ", "))
            end
        end
        if getSprite and not getSprite(sprite) then Log:warning("Missing sprite '%s'", sprite) end
    end
    local canValidateTranslations = getText and not (isServer and isServer())
    local function translationExists(key)
        if getTextOrNull then return getTextOrNull(key) ~= nil end
        return getText(key) ~= key
    end
    if canValidateTranslations then
        for entryIndex = 1, #payload do
            local entry = payload[entryIndex]
            if not translationExists(entry.translationKey) then
                Log
                    :warning("Missing translation '%s' for %s", entry.translationKey, entry.id)
            end
            if entry.tooltipKey and entry.tooltipKey ~= "" then
                if not translationExists(entry.tooltipKey) then
                    Log:warning("Missing tooltip translation '%s' for %s", entry.tooltipKey, entry.id)
                end
            end
        end
    end
    local parts = { "schema=" .. tostring(KBW.SCHEMA_VERSION) }
    local sources = TableUtil.sortedKeys(self.files)
    for sourceIndex = 1, #sources do
        local source = sources[sourceIndex]
        parts[#parts + 1] = source .. "=" .. tostring(self.files[source])
    end
    parts[#parts + 1] = "overrides=" .. tostring(self.overridesHash or "none")
    self.hash = Hash.string(table.concat(parts, "\n"))
    self.locked = true
    Log:info("Registry ready: %d buildables, hash %s", #payload, self.hash)
end

return Registry
