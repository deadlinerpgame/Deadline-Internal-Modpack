local JSON = require("ElyonLib/FileUtils/JSON")
local SafeJSON = require("KnoxBuildworks/Util/SafeJSON")
local BuildableRules = require("KnoxBuildworks/Admin/BuildableRules")
local Registry = require("KnoxBuildworks/Definitions/Registry")
local TableUtil = require("KnoxBuildworks/Util/Table")

local Presets = {
    VERSION = 1,
    FOLDER = "KnoxBuildworks/buildable-rule-presets",
    MAX_FILE_BYTES = 5 * 1024 * 1024,
    MAX_NAME_BYTES = 256
}
local detailsCache = {}

local function trim(value)
    return string.gsub(tostring(value or ""), "^%s*(.-)%s*$", "%1")
end

local function validName(value)
    local name = trim(value)
    return name ~= "" and #name <= Presets.MAX_NAME_BYTES and string.find(name, "%c") == nil
end

local function isPresetFile(fileName)
    local name = tostring(fileName or "")
    if name == "" or string.find(name, "[/\\]") then return false end
    return string.sub(string.lower(name), -4) == ".txt"
end

local function fileSlug(name)
    local slug = string.lower(tostring(name or ""))
    slug = string.gsub(slug, "[^A-Za-z0-9]+", "_")
    slug = string.gsub(slug, "^_+", "")
    slug = string.gsub(slug, "_+$", "")
    if #slug > 40 then slug = string.sub(slug, 1, 40) end
    if slug == "" then slug = "preset" end
    return slug
end

local function timestamp()
    if getTimestampMs then return tostring(getTimestampMs()) end
    if getTimestamp then return tostring(getTimestamp()) end
    return tostring(ZombRand(1000000000))
end

local function emptyDocument()
    return {
        version = BuildableRules.VERSION,
        revision = 0,
        categories = {},
        subcategories = {},
        wallFinishRequirements = {},
        buildables = {}
    }
end

function Presets.definitionDefaults()
    return emptyDocument()
end

function Presets.disableAll()
    local document = emptyDocument()
    local definitions = Registry:list()
    for definitionIndex = 1, #definitions do
        local category = tostring(definitions[definitionIndex].category or "General")
        if document.categories[category] == nil then
            document.categories[category] = { enabled = false }
        end
    end
    return document
end

function Presets.exportFileName(name)
    return "knox_buildable_rules_" .. fileSlug(name) .. "_" .. timestamp() .. ".txt"
end

local function writeValidated(name, normalized)
    name = trim(name)
    if not validName(name) then return nil, "invalid_name" end
    normalized = TableUtil.copy(normalized)
    normalized.revision = 0
    local payload = {
        presetSchema = Presets.VERSION,
        name = name,
        exportedAt = timestamp(),
        registryHash = tostring(Registry.hash or ""),
        rules = normalized
    }
    local fileName = Presets.exportFileName(name)
    local path = Presets.FOLDER .. "/" .. fileName
    local writer = getFileWriter(path, true, false)
    if not writer then return nil, "write_failed" end
    writer:write(JSON.stringify(payload))
    writer:close()
    detailsCache[fileName] = { name = name, registryMismatch = false, valid = true }
    return path, nil, fileName
end

function Presets.export(name, document)
    if not validName(name) then return nil, "invalid_name" end
    local normalized, errors = BuildableRules.validateDocument(document)
    if not normalized then return nil, "invalid_rules", errors end
    return writeValidated(name, normalized)
end

function Presets.exportValidated(name, normalized)
    return writeValidated(name, normalized)
end

local function readText(fileName)
    if not isPresetFile(fileName) then return nil, "invalid_file_name" end
    local reader = getFileReader(Presets.FOLDER .. "/" .. fileName, false)
    if not reader then return nil, "file_not_found" end
    local lines, total = {}, 0
    local line = reader:readLine()
    while line do
        total = total + #line + 1
        if total > Presets.MAX_FILE_BYTES then
            reader:close()
            return nil, "file_too_large"
        end
        lines[#lines + 1] = line
        line = reader:readLine()
    end
    reader:close()
    return table.concat(lines, "\n")
end

function Presets.read(fileName)
    local text, readError = readText(fileName)
    if not text then
        detailsCache[fileName] = { valid = false, errorCode = readError }
        return nil, readError
    end
    local decoded = SafeJSON.decode(text)
    if type(decoded) ~= "table" then
        detailsCache[fileName] = { valid = false, errorCode = "invalid_json" }
        return nil, "invalid_json"
    end

    local metadata = {
        fileName = fileName,
        name = fileName,
        registryHash = nil,
        registryMismatch = false,
        legacy = false
    }
    local source = decoded
    if decoded.presetSchema ~= nil then
        if tonumber(decoded.presetSchema) ~= Presets.VERSION then
            detailsCache[fileName] = { valid = false, errorCode = "unsupported_schema" }
            return nil, "unsupported_schema"
        end
        if not validName(decoded.name) or type(decoded.rules) ~= "table" then
            detailsCache[fileName] = { valid = false, errorCode = "invalid_preset" }
            return nil, "invalid_preset"
        end
        metadata.name = trim(decoded.name)
        metadata.registryHash = decoded.registryHash and tostring(decoded.registryHash) or nil
        source = decoded.rules
    else
        metadata.legacy = true
    end

    local normalized, errors = BuildableRules.validateDocument(source)
    if not normalized then
        detailsCache[fileName] = { valid = false, errorCode = "invalid_rules" }
        return nil, { code = "invalid_rules", errors = errors }
    end
    normalized.revision = 0
    metadata.registryMismatch = metadata.registryHash ~= nil and metadata.registryHash ~= ""
        and metadata.registryHash ~= tostring(Registry.hash or "")
    detailsCache[fileName] = { name = metadata.name, registryMismatch = metadata.registryMismatch, valid = true }
    return normalized, metadata
end

function Presets.list()
    local result = {}
    if not listFilesInZomboidLuaDirectory then return result end
    local files = listFilesInZomboidLuaDirectory(Presets.FOLDER)
    if not files then return result end
    for fileIndex = 0, files:size() - 1 do
        local fileName = tostring(files:get(fileIndex))
        if isPresetFile(fileName) then
            local cached = detailsCache[fileName] or {}
            result[#result + 1] = {
                kind = "file",
                fileName = fileName,
                name = cached.name or fileName,
                registryMismatch = cached.registryMismatch == true,
                errorCode = cached.errorCode,
                valid = cached.valid ~= false
            }
        end
    end
    table.sort(result, function (a, b)
        local nameA = string.lower(tostring(a.name or a.fileName))
        local nameB = string.lower(tostring(b.name or b.fileName))
        if nameA ~= nameB then return nameA < nameB end
        return tostring(a.fileName) < tostring(b.fileName)
    end)
    return result
end

function Presets.clearCache()
    detailsCache = {}
end

function Presets.copyForDraft(document, revision)
    local copy = TableUtil.copy(document or emptyDocument())
    copy.revision = math.max(0, math.floor(tonumber(revision) or 0))
    return copy
end

return Presets
