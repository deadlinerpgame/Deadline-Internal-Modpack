local KBW = require("KnoxBuildworks/Core")
local JSON = require("ElyonLib/FileUtils/JSON")
local SafeJSON = require("KnoxBuildworks/Util/SafeJSON")
local BuildableRules = require("KnoxBuildworks/Admin/BuildableRules")
local Log = require("KnoxBuildworks/Log")

local RulesFile = {}

local function saveKey()
    local world = getWorld and getWorld() or nil
    local name = world and world:getWorld() or nil
    if not name or name == "" then return "shared" end
    return string.gsub(tostring(name), "[^%w_%-]", "_")
end

function RulesFile.path()
    return KBW.BUILDABLE_RULES_ROOT .. "/" .. saveKey() .. "/rules.txt"
end

local function readText(path)
    local reader = getFileReader(path, false)
    if not reader then return nil end
    local lines = {}
    local line = reader:readLine()
    while line do
        lines[#lines + 1] = line
        line = reader:readLine()
    end
    reader:close()
    return table.concat(lines, "\n")
end

function RulesFile.load()
    local text = readText(RulesFile.path())
    if not text or text == "" then return { version = BuildableRules.VERSION, revision = 0 } end
    local decoded, decodeError = SafeJSON.decode(text)
    if not decoded then
        Log:error("Could not read buildable rules %s: %s", RulesFile.path(), tostring(decodeError))
        return nil
    end
    local normalized, errors = BuildableRules.validateDocument(decoded)
    if not normalized then
        Log:error("Rejected buildable rules %s: %s", RulesFile.path(), table.concat(errors, "; "))
        return nil
    end
    return normalized
end

function RulesFile.save(document)
    local writer = getFileWriter(RulesFile.path(), true, false)
    if not writer then
        Log:error("Could not write buildable rules %s", RulesFile.path())
        return false
    end
    writer:write(JSON.stringify(document))
    writer:close()
    return true
end

return RulesFile
