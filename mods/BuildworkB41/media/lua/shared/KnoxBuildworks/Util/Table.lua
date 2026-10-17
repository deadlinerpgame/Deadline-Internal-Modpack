local TableUtil = {}

function TableUtil.copy(value, seen)
    if type(value) ~= "table" then return value end
    seen = seen or {}
    if seen[value] then return seen[value] end
    local result = {}
    seen[value] = result
    for key, child in pairs(value) do
        result[TableUtil.copy(key, seen)] = TableUtil.copy(child, seen)
    end
    return result
end

function TableUtil.merge(base, override)
    local result = TableUtil.copy(base or {})
    for key, value in pairs(override or {}) do
        if type(value) == "table" and type(result[key]) == "table" and value[1] == nil then
            result[key] = TableUtil.merge(result[key], value)
        else
            result[key] = TableUtil.copy(value)
        end
    end
    return result
end

function TableUtil.sortedKeys(value)
    local keys = {}
    for key in pairs(value or {}) do
        keys[#keys + 1] = key
    end
    table.sort(keys, function (a, b) return tostring(a) < tostring(b) end)
    return keys
end

function TableUtil.contains(list, needle)
    list = list or {}
    for index = 1, #list do
        local value = list[index]
        if value == needle then return true end
    end
    return false
end

return TableUtil
