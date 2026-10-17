local SafeJSON = {}

local byteAt = string.byte
local sub = string.sub
local find = string.find

local B_QUOTE = 34
local B_COMMA = 44
local B_MINUS = 45
local B_COLON = 58
local B_LBRACKET = 91
local B_RBRACKET = 93
local B_LBRACE = 123
local B_RBRACE = 125

local ESCAPES = {
    ['"'] = '"',
    ['\\'] = '\\',
    ['/'] = '/',
    b = '\b',
    f = '\f',
    n = '\n',
    r = '\r',
    t = '\t'
}

local function parseString(text, index, length)
    local pieces = nil
    local i = index + 1
    while true do
        local quotePos = find(text, '"', i, true)
        if not quotePos then return nil, "unterminated string", index end
        local segment = sub(text, i, quotePos - 1)
        local slash = find(segment, "\\", 1, true)
        if not slash then
            if not pieces then return segment, nil, quotePos + 1 end
            pieces[#pieces + 1] = segment
            return table.concat(pieces), nil, quotePos + 1
        end
        pieces = pieces or {}
        local slashPos = i + slash - 1
        if slashPos > i then pieces[#pieces + 1] = sub(text, i, slashPos - 1) end
        local escaped = sub(text, slashPos + 1, slashPos + 1)
        local simple = ESCAPES[escaped]
        if simple then
            pieces[#pieces + 1] = simple
            i = slashPos + 2
        elseif escaped == "u" then
            local hex = sub(text, slashPos + 2, slashPos + 5)
            local code = tonumber(hex, 16)
            if not code then return nil, "invalid unicode escape", slashPos end
            pieces[#pieces + 1] = code < 128 and string.char(code) or "?"
            i = slashPos + 6
        elseif escaped == "" then
            return nil, "unterminated string", slashPos
        else
            return nil, "invalid escape", slashPos
        end
    end
end

local function parseNumber(text, index, length)
    local start, stop = find(text, "^-?%d+%.?%d*[eE]?[+-]?%d*", index)
    if not start then return nil, index end
    return tonumber(sub(text, start, stop)), stop + 1
end

local E_VALUE = 1
local E_ARRAY_FIRST = 2
local E_ARRAY_SEP = 3
local E_OBJECT_FIRST = 4
local E_OBJECT_KEY = 5
local E_OBJECT_COLON = 6
local E_OBJECT_SEP = 7
local E_EOF = 8

function SafeJSON.newSession(text)
    return {
        text = text or "",
        length = #(text or ""),
        index = 1,
        values = {},
        isArray = {},
        keys = {},
        depth = 0,
        expect = E_VALUE,
        result = nil,
        done = false,
        err = nil
    }
end

function SafeJSON.stepSession(session, maxIterations)
    if session.done then return true end
    local text = session.text
    local length = session.length
    local index = session.index
    local expect = session.expect
    local depth = session.depth
    local values = session.values
    local isArray = session.isArray
    local keys = session.keys
    local result = session.result
    local remaining = maxIterations or 1000000000
    local failMessage = nil

    while remaining > 0 do
        remaining = remaining - 1
        while index <= length do
            local white = byteAt(text, index)
            if white == 32 or white == 9 or white == 13 or white == 10 then
                index = index + 1
            else
                break
            end
        end
        if expect == E_EOF then
            if index <= length then
                failMessage = "trailing data"
                break
            end
            session.index = index
            session.result = result
            session.done = true
            return true
        end
        if index > length then
            failMessage = (expect == E_VALUE and depth == 0) and "unexpected token" or "unexpected end of input"
            break
        end
        local byte = byteAt(text, index)
        if expect == E_VALUE or expect == E_ARRAY_FIRST then
            local value = nil
            local haveValue = false
            if expect == E_ARRAY_FIRST and byte == B_RBRACKET then
                index = index + 1
                value = values[depth]
                values[depth] = nil
                keys[depth] = nil
                depth = depth - 1
                haveValue = true
            elseif byte == B_QUOTE then
                local err, nextIndex
                value, err, nextIndex = parseString(text, index, length)
                index = nextIndex
                if err then
                    failMessage = err
                    break
                end
                haveValue = true
            elseif byte == B_LBRACE then
                depth = depth + 1
                values[depth] = {}
                isArray[depth] = false
                keys[depth] = nil
                expect = E_OBJECT_FIRST
                index = index + 1
            elseif byte == B_LBRACKET then
                depth = depth + 1
                values[depth] = {}
                isArray[depth] = true
                expect = E_ARRAY_FIRST
                index = index + 1
            elseif byte == 116 and sub(text, index, index + 3) == "true" then
                index = index + 4
                value = true
                haveValue = true
            elseif byte == 102 and sub(text, index, index + 4) == "false" then
                index = index + 5
                value = false
                haveValue = true
            elseif byte == 110 and sub(text, index, index + 3) == "null" then
                index = index + 4
                haveValue = true
            else
                local nextIndex
                value, nextIndex = parseNumber(text, index, length)
                if value == nil then
                    failMessage = "unexpected token"
                    break
                end
                index = nextIndex
                haveValue = true
            end
            if haveValue then
                if depth == 0 then
                    result = value
                    expect = E_EOF
                elseif isArray[depth] then
                    local container = values[depth]
                    container[#container + 1] = value
                    expect = E_ARRAY_SEP
                else
                    local key = keys[depth]
                    if key ~= nil then values[depth][key] = value end
                    keys[depth] = nil
                    expect = E_OBJECT_SEP
                end
            end
        elseif expect == E_ARRAY_SEP or expect == E_OBJECT_SEP then
            local closer = expect == E_ARRAY_SEP and B_RBRACKET or B_RBRACE
            if byte == closer then
                index = index + 1
                local value = values[depth]
                values[depth] = nil
                keys[depth] = nil
                depth = depth - 1
                if depth == 0 then
                    result = value
                    expect = E_EOF
                elseif isArray[depth] then
                    local container = values[depth]
                    container[#container + 1] = value
                    expect = E_ARRAY_SEP
                else
                    local key = keys[depth]
                    if key ~= nil then values[depth][key] = value end
                    keys[depth] = nil
                    expect = E_OBJECT_SEP
                end
            elseif byte == B_COMMA then
                index = index + 1
                expect = expect == E_ARRAY_SEP and E_VALUE or E_OBJECT_KEY
            else
                failMessage = expect == E_ARRAY_SEP and "expected comma or closing bracket"
                    or "expected comma or closing brace"
                break
            end
        elseif expect == E_OBJECT_FIRST or expect == E_OBJECT_KEY then
            if expect == E_OBJECT_FIRST and byte == B_RBRACE then
                index = index + 1
                local value = values[depth]
                values[depth] = nil
                keys[depth] = nil
                depth = depth - 1
                if depth == 0 then
                    result = value
                    expect = E_EOF
                elseif isArray[depth] then
                    local container = values[depth]
                    container[#container + 1] = value
                    expect = E_ARRAY_SEP
                else
                    local key = keys[depth]
                    if key ~= nil then values[depth][key] = value end
                    keys[depth] = nil
                    expect = E_OBJECT_SEP
                end
            elseif byte == B_QUOTE then
                local key, err, nextIndex = parseString(text, index, length)
                index = nextIndex
                if err then
                    failMessage = err
                    break
                end
                keys[depth] = key
                expect = E_OBJECT_COLON
            else
                failMessage = "expected object key"
                break
            end
        elseif expect == E_OBJECT_COLON then
            if byte ~= B_COLON then
                failMessage = "expected colon"
                break
            end
            index = index + 1
            expect = E_VALUE
        end
    end

    session.index = index
    session.expect = expect
    session.depth = depth
    session.result = result
    if failMessage then
        session.err = string.format("%s at byte %d", failMessage, index)
        session.done = true
        return true
    end
    return session.done
end

function SafeJSON.decode(text)
    local session = SafeJSON.newSession(text)
    SafeJSON.stepSession(session, nil)
    if session.err then return nil, session.err end
    return session.result
end

return SafeJSON
