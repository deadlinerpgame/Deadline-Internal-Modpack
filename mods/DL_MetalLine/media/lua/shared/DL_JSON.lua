DL = DL or {}
DL.JSON = {}

local function fail(idx, msg)
    return nil, nil, string.format("DL.JSON: %s at %d", msg, idx)
end

local function skip_ws(s, i)
    local _, e = string.find(s, "^[ \t\r\n]*", i)
    return e + 1
end

local parse_value

local function parse_string(s, i)
    local res, idx = {}, i + 1
    while true do
        local c = string.sub(s, idx, idx)
        if c == "" then return fail(idx, "unterminated string") end
        if c == '"' then return table.concat(res), idx + 1 end
        if c == "\\" then
            local n = string.sub(s, idx + 1, idx + 1)
            local map = { ['"']='"', ['\\']='\\', ['/']='/', b='\b', f='\f', n='\n', r='\r', t='\t' }
            if map[n] then res[#res+1] = map[n]; idx = idx + 2
            elseif n == 'u' then
                local cp = tonumber(string.sub(s, idx + 2, idx + 5), 16) or 0
                if cp < 0x80 then res[#res+1] = string.char(cp)
                elseif cp < 0x800 then res[#res+1] = string.char(0xC0 + math.floor(cp/0x40), 0x80 + cp%0x40)
                else res[#res+1] = string.char(0xE0 + math.floor(cp/0x1000), 0x80 + math.floor(cp/0x40)%0x40, 0x80 + cp%0x40) end
                idx = idx + 6
            else return fail(idx, "bad escape") end
        else
            res[#res+1] = c; idx = idx + 1
        end
    end
end

local function parse_number(s, i)
    local a, b = string.find(s, "^-?%d+%.?%d*[eE]?[+-]?%d*", i)
    if not a then return fail(i, "unexpected character") end
    return tonumber(string.sub(s, a, b)), b + 1
end

local function parse_array(s, i)
    local arr = {}
    i = skip_ws(s, i + 1)
    if string.sub(s, i, i) == ']' then return arr, i + 1 end
    while true do
        local v, ni, e = parse_value(s, i)
        if not ni then return nil, nil, e end
        arr[#arr+1] = v
        i = skip_ws(s, ni)
        local c = string.sub(s, i, i)
        if c == ']' then return arr, i + 1 end
        if c ~= ',' then return fail(i, "expected , or ]") end
        i = skip_ws(s, i + 1)
    end
end

local function parse_object(s, i)
    local obj = {}
    i = skip_ws(s, i + 1)
    if string.sub(s, i, i) == '}' then return obj, i + 1 end
    while true do
        if string.sub(s, i, i) ~= '"' then return fail(i, "expected key") end
        local k, ki, ke = parse_string(s, i)
        if not ki then return nil, nil, ke end
        i = skip_ws(s, ki)
        if string.sub(s, i, i) ~= ':' then return fail(i, "expected :") end
        local v, vi, ve = parse_value(s, skip_ws(s, i + 1))
        if not vi then return nil, nil, ve end
        obj[k] = v
        i = skip_ws(s, vi)
        local c = string.sub(s, i, i)
        if c == '}' then return obj, i + 1 end
        if c ~= ',' then return fail(i, "expected , or }") end
        i = skip_ws(s, i + 1)
    end
end

parse_value = function(s, i)
    i = skip_ws(s, i)
    local c = string.sub(s, i, i)
    if     c == '"' then return parse_string(s, i)
    elseif c == '{' then return parse_object(s, i)
    elseif c == '[' then return parse_array(s, i)
    elseif c == 't' then return true,  i + 4
    elseif c == 'f' then return false, i + 5
    elseif c == 'n' then return nil,   i + 4
    else                 return parse_number(s, i) end
end

function DL.JSON.decode(str)
    if type(str) ~= "string" then return nil, "DL.JSON: no text to parse" end
    local v, ni, e = parse_value(str, 1)
    if not ni then return nil, e end
    return v
end
