local TableUtil = require("KnoxBuildworks/Util/Table")

local Hash = {}

local MOD = 4294967296

function Hash.begin()
    return { value = 5381 }
end

function Hash.update(state, text, from, to)
    from = from or 1
    to = to or #text
    local value = state.value
    local byteAt = string.byte
    for index = from, to do
        value = (value * 33 + byteAt(text, index)) % MOD
    end
    state.value = value
    return state
end

function Hash.finish(state)
    local low = state.value % 65536
    local high = (state.value - low) / 65536
    return string.format("%04x%04x", high, low)
end

function Hash.string(text)
    text = tostring(text or "")
    local state = Hash.begin()
    Hash.update(state, text, 1, #text)
    return Hash.finish(state)
end

local function canonical(value)
    local kind = type(value)
    if kind == "nil" then return "null" end
    if kind == "boolean" or kind == "number" then return tostring(value) end
    if kind == "string" then return string.format("%q", value) end
    if kind ~= "table" then return '"<' .. kind .. '>"' end
    if value[1] ~= nil then
        local values = {}
        for i = 1, #value do
            values[i] = canonical(value[i])
        end
        return "[" .. table.concat(values, ",") .. "]"
    end
    local values = {}
    local keys = TableUtil.sortedKeys(value)
    for keyIndex = 1, #keys do
        local key = keys[keyIndex]
        values[#values + 1] = canonical(tostring(key)) .. ":" .. canonical(value[key])
    end
    return "{" .. table.concat(values, ",") .. "}"
end

function Hash.table(value)
    return Hash.string(canonical(value))
end

function Hash.canonical(value)
    return canonical(value)
end

return Hash
