local JSON = require("ElyonLib/FileUtils/JSON")
local SafeJSON = require("KnoxBuildworks/Util/SafeJSON")
local Log = require("KnoxBuildworks/Log")
local KBWB41 = require("KnoxBuildworks/Compat/B41")

local BlueprintFiles = {}

BlueprintFiles.ROOT = "KnoxBuildworks/blueprints"
BlueprintFiles.EXTENSION = ".txt"
BlueprintFiles.LEGACY_EXTENSION = ".json"

local function saveKey()
    local world = getWorld and getWorld() or nil
    local name = world and world:getWorld() or nil
    if not name or name == "" then return "shared" end
    return string.gsub(tostring(name), "[^%w_%-]", "_")
end

function BlueprintFiles.folder()
    return BlueprintFiles.ROOT .. "/" .. saveKey()
end

local function filePath(id)
    return BlueprintFiles.folder() .. "/" .. tostring(id) .. BlueprintFiles.EXTENSION
end

local function readText(path)
    local reader = getFileReader(path, false)
    if not reader then return nil end
    local lines, line = {}, reader:readLine()
    while line do
        lines[#lines + 1] = line
        line = reader:readLine()
    end
    reader:close()
    return table.concat(lines, "\n")
end

BlueprintFiles.INDEX = "index.txt"

local function indexPath()
    return BlueprintFiles.folder() .. "/" .. BlueprintFiles.INDEX
end

local function readIndex()
    local ids = {}
    local reader = getFileReader(indexPath(), false)
    if not reader then return ids end
    local line = reader:readLine()
    while line do
        local id = string.gsub(tostring(line), "^%s*(.-)%s*$", "%1")
        if id ~= "" then ids[#ids + 1] = id end
        line = reader:readLine()
    end
    reader:close()
    return ids
end

local function writeIndex(ids)
    local writer = getFileWriter(indexPath(), true, false)
    if not writer then
        Log:error("Could not write blueprint index %s", indexPath())
        return false
    end
    for index = 1, #ids do writer:write(tostring(ids[index]) .. "\r\n") end
    writer:close()
    return true
end

local function indexAdd(id)
    id = tostring(id)
    local ids = readIndex()
    for index = 1, #ids do
        if ids[index] == id then return end
    end
    ids[#ids + 1] = id
    writeIndex(ids)
end

local function indexRemove(id)
    id = tostring(id)
    local ids, kept, found = readIndex(), {}, false
    for index = 1, #ids do
        if ids[index] == id then found = true else kept[#kept + 1] = ids[index] end
    end
    if found then writeIndex(kept) end
end

function BlueprintFiles.loadAllFromIndex()
    local items, keep = {}, {}
    local ids = readIndex()
    for index = 1, #ids do
        local id = ids[index]
        local text = readText(filePath(id))
        if text and text ~= "" then
            local data, err = SafeJSON.decode(text)
            if type(data) == "table" and data.id then
                if data.deleted == true then
                    items[tostring(data.id)] = nil
                else
                    items[tostring(data.id)] = data
                    keep[#keep + 1] = id
                end
            elseif err then
                Log:warning("Skipped blueprint %s: %s", id, err)
            end
        end
    end
    if #keep ~= #ids then writeIndex(keep) end
    return items
end

function BlueprintFiles.loadAll()
    local items = {}
    if not listFilesInZomboidLuaDirectory then return BlueprintFiles.loadAllFromIndex() end
    local names = listFilesInZomboidLuaDirectory(BlueprintFiles.folder())
    if not names then return BlueprintFiles.loadAllFromIndex() end
    local currentIds = {}
    local function loadExtension(extension, current)
        for nameIndex = 0, names:size() - 1 do
            local name = tostring(names:get(nameIndex))
            if string.sub(string.lower(name), -#extension) == extension then
                local text = readText(BlueprintFiles.folder() .. "/" .. name)
                if text and text ~= "" then
                    local data, err = SafeJSON.decode(text)
                    if type(data) == "table" and data.id then
                        local id = tostring(data.id)
                        if current then currentIds[id] = true end
                        if data.deleted == true then
                            items[id] = nil
                        else
                            items[id] = data
                        end
                    elseif err then
                        Log:warning("Skipped blueprint file %s: %s", name, err)
                    end
                end
            end
        end
    end
    loadExtension(BlueprintFiles.LEGACY_EXTENSION, false)
    loadExtension(BlueprintFiles.EXTENSION, true)
    for id, blueprint in pairs(items) do
        if not currentIds[id] then BlueprintFiles.save(blueprint) end
    end
    return items
end

function BlueprintFiles.save(blueprint)
    if not blueprint or not blueprint.id then return false end
    local writer = getFileWriter(filePath(blueprint.id), true, false)
    if not writer then
        Log:error("Could not write blueprint file %s", filePath(blueprint.id))
        return false
    end
    writer:write(JSON.stringify(blueprint))
    writer:close()
    indexAdd(blueprint.id)
    return true
end

local dirty = {}
local flushHooked = false
local batches = {}

local function flush(force)
    local remaining = {}
    for id, blueprint in pairs(dirty) do
        if force == true or not batches[tostring(id)] then
            BlueprintFiles.save(blueprint)
        else
            remaining[tostring(id)] = blueprint
        end
    end
    dirty = remaining
end

local function flushForced()
    flush(true)
end

local function hookFlush()
    if flushHooked then return end
    flushHooked = true
    KBWB41.addEvent("OnTick", flush)
    KBWB41.addEvent("EveryOneMinute", flushForced)
    KBWB41.addEvent("OnSave", flushForced)
end

function BlueprintFiles.queueSave(blueprint)
    if not blueprint or not blueprint.id then return end
    dirty[tostring(blueprint.id)] = blueprint
    hookFlush()
end

function BlueprintFiles.beginBatch(id)
    id = tostring(id or "")
    if id == "" then return end
    batches[id] = (batches[id] or 0) + 1
end

function BlueprintFiles.endBatch(id)
    id = tostring(id or "")
    if id == "" then return end
    local depth = batches[id] or 0
    if depth > 1 then
        batches[id] = depth - 1
    else
        batches[id] = nil
    end
    flush(false)
end

function BlueprintFiles.remove(id)
    if not id then return end
    id = tostring(id)
    dirty[id] = nil
    local writer = getFileWriter(filePath(id), true, false)
    if not writer then
        Log:error("Could not write blueprint tombstone %s", filePath(id))
        return
    end
    writer:write(JSON.stringify({ id = id, deleted = true }))
    writer:close()
    indexRemove(id)
end

return BlueprintFiles
