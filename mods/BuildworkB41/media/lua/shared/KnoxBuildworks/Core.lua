KnoxBuildworks = KnoxBuildworks or {}

local KBW = KnoxBuildworks
KBW.ID = "KnoxBuildworks"
KBW.VERSION = "0.1.0"
KBW.SCHEMA_VERSION = 1
KBW.NETWORK_MODULE = "KnoxBuildworks"
KBW.MANIFEST_PATH = "media/KnoxBuildworks/manifest.json"
KBW.OVERRIDE_PATH = "KnoxBuildworks/overrides.json"
KBW.BUILDABLE_RULES_ROOT = "KnoxBuildworks/buildable-rules"
KBW.Runtime = KBW.Runtime or { loaded = false, integrity = "unknown", integrityMessage = nil, debug = false }

function KBW.sandboxValue(name, default)
    if not getSandboxOptions then return default end
    local options = getSandboxOptions()
    local option = options and options:getOptionByName(name) or nil
    if not option then return default end
    local value = option:getValue()
    if value == nil then return default end
    return value
end

return KBW
