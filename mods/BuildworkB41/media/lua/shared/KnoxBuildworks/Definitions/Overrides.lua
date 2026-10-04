local KBW = require("KnoxBuildworks/Core")
local SafeJSON = require("KnoxBuildworks/Util/SafeJSON")
local TableUtil = require("KnoxBuildworks/Util/Table")
local Hash = require("KnoxBuildworks/Util/Hash")
local Log = require("KnoxBuildworks/Log")

local Overrides = {}

function Overrides.load()
    local reader = getFileReader(KBW.OVERRIDE_PATH, false)
    if not reader then return {}, nil end
    local lines, line = {}, reader:readLine()
    while line do
        lines[#lines + 1] = line
        line = reader:readLine()
    end
    reader:close()
    local text = table.concat(lines, "\n")
    if text == "" then return {}, nil end
    local data, err = SafeJSON.decode(text)
    if not data then
        Log:error("Invalid override file: %s", err)
        return {}, nil
    end
    return data.buildables or data, Hash.string(text)
end

function Overrides.apply(definition, all)
    local override = all[definition.id]
    return override and TableUtil.merge(definition, override) or definition
end

function Overrides.collect(patches, bundle, source)
    for id, patch in pairs(bundle.patches or {}) do
        if type(patch) ~= "table" then
            Log:error("Patch for '%s' in %s must be an object; skipped", tostring(id), tostring(source))
        elseif patches[id] then
            patches[id] = TableUtil.merge(patches[id], patch)
        else
            patches[id] = patch
        end
    end
end

function Overrides.applyPatch(definition, patches)
    local patch = patches[definition.id]
    return patch and TableUtil.merge(definition, patch) or definition
end

return Overrides
