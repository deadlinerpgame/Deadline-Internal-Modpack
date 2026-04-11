require "ISUI/ISPanel"
require "ISUI/ISButton"
require "ISUI/ISTextEntryBox"
require "ISUI/ISLabel"

JsonIOWindow = ISPanel:derive("JsonIOWindow")

local json = {}

local function encodeString(s)
    return '"' .. s
        :gsub('\\', '\\\\')
        :gsub('"',  '\\"')
        :gsub('\n', '\\n')
        :gsub('\r', '\\r')
        :gsub('\t', '\\t')
        :gsub('[%z\1-\8\11\12\14-\31]', function(c)
            return string.format('\\u%04x', string.byte(c))
        end) .. '"'
end

local function isArray(t)
    local n = 0
    for k in pairs(t) do
        if type(k) ~= "number" then return false end
        n = n + 1
    end
    for i = 1, n do if t[i] == nil then return false end end
    return true, n
end

local encodeValue
local function encodeTable(t, indent, depth)
    local pad  = string.rep("  ", depth)
    local pad2 = string.rep("  ", depth + 1)
    local arr, n = isArray(t)
    if arr then
        if n == 0 then return "[]" end
        local parts = {}
        for i = 1, n do parts[i] = pad2 .. encodeValue(t[i], indent, depth + 1) end
        return "[\n" .. table.concat(parts, ",\n") .. "\n" .. pad .. "]"
    end
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = tostring(k) end
    table.sort(keys)
    if #keys == 0 then return "{}" end
    local parts = {}
    for _, k in ipairs(keys) do
        parts[#parts+1] = pad2 .. encodeString(k) .. ": " .. encodeValue(t[k], indent, depth + 1)
    end
    return "{\n" .. table.concat(parts, ",\n") .. "\n" .. pad .. "}"
end

encodeValue = function(v, indent, depth)
    local tv = type(v)
    if v == nil then return "null" end
    if tv == "boolean" then return v and "true" or "false" end
    if tv == "number" then
        if v ~= v or v == math.huge or v == -math.huge then return "null" end
        return tostring(v)
    end
    if tv == "string" then return encodeString(v) end
    if tv == "table"  then return encodeTable(v, indent, depth) end
    return "null"
end

function json.encode(v) return encodeValue(v, true, 0) end

local function skipWS(s, i)
    while i <= #s do
        local c = s:sub(i, i)
        if c == " " or c == "\t" or c == "\n" or c == "\r" then i = i + 1
        else return i end
    end
    return i
end

local parseValue
local function parseString(s, i)
    assert(s:sub(i, i) == '"', "expected string at " .. i)
    i = i + 1
    local out = {}
    while i <= #s do
        local c = s:sub(i, i)
        if c == '"' then return table.concat(out), i + 1
        elseif c == '\\' then
            local n = s:sub(i+1, i+1)
            if     n == '"'  then out[#out+1] = '"'
            elseif n == '\\' then out[#out+1] = '\\'
            elseif n == '/'  then out[#out+1] = '/'
            elseif n == 'n'  then out[#out+1] = '\n'
            elseif n == 'r'  then out[#out+1] = '\r'
            elseif n == 't'  then out[#out+1] = '\t'
            elseif n == 'b'  then out[#out+1] = '\b'
            elseif n == 'f'  then out[#out+1] = '\f'
            elseif n == 'u'  then
                local hex = s:sub(i+2, i+5)
                local cp  = tonumber(hex, 16) or 63
                if cp < 128 then out[#out+1] = string.char(cp)
                else out[#out+1] = "?" end
                i = i + 4
            else error("bad escape \\" .. n) end
            i = i + 2
        else out[#out+1] = c; i = i + 1 end
    end
    error("unterminated string")
end

local function parseNumber(s, i)
    local j = i
    while j <= #s do
        local c = s:sub(j, j)
        if c:match("[%-%+%.0-9eE]") then j = j + 1 else break end
    end
    return tonumber(s:sub(i, j - 1)), j
end

local function parseArray(s, i)
    i = i + 1
    local arr = {}
    i = skipWS(s, i)
    if s:sub(i, i) == "]" then return arr, i + 1 end
    while true do
        local v; v, i = parseValue(s, i)
        arr[#arr+1] = v
        i = skipWS(s, i)
        local c = s:sub(i, i)
        if c == "]" then return arr, i + 1 end
        assert(c == ",", "expected , or ] at " .. i)
        i = skipWS(s, i + 1)
    end
end

local function parseObject(s, i)
    i = i + 1
    local obj = {}
    i = skipWS(s, i)
    if s:sub(i, i) == "}" then return obj, i + 1 end
    while true do
        i = skipWS(s, i)
        local k; k, i = parseString(s, i)
        i = skipWS(s, i)
        assert(s:sub(i, i) == ":", "expected : at " .. i)
        i = skipWS(s, i + 1)
        local v; v, i = parseValue(s, i)
        obj[k] = v
        i = skipWS(s, i)
        local c = s:sub(i, i)
        if c == "}" then return obj, i + 1 end
        assert(c == ",", "expected , or } at " .. i)
        i = i + 1
    end
end

parseValue = function(s, i)
    i = skipWS(s, i)
    local c = s:sub(i, i)
    if c == '"' then return parseString(s, i) end
    if c == "{" then return parseObject(s, i) end
    if c == "[" then return parseArray(s, i) end
    if c == "t" and s:sub(i, i+3) == "true"  then return true,  i + 4 end
    if c == "f" and s:sub(i, i+4) == "false" then return false, i + 5 end
    if c == "n" and s:sub(i, i+3) == "null"  then return nil,   i + 4 end
    if c:match("[%-0-9]") then return parseNumber(s, i) end
    error("unexpected char '" .. c .. "' at " .. i)
end

function json.decode(s)
    local ok, val = pcall(function()
        local v, i = parseValue(s, 1)
        return v
    end)
    if not ok then return nil, val end
    return val
end

JsonIOWindow.json = json

local W, H = 640, 480
local PAD  = 10
local BTN_H, BTN_W = 24, 90
local HEADER_H = 28

function JsonIOWindow:new(mode, title, initialText, onAccept)
    local sw = getCore():getScreenWidth()
    local sh = getCore():getScreenHeight()
    local o  = ISPanel.new(self,
        math.floor((sw - W) / 2), math.floor((sh - H) / 2), W, H)
    o.moveWithMouse = false
    o.mode          = mode
    o.titleText     = title or (mode == "export" and "Export" or "Import")
    o.initialText   = initialText or ""
    o.onAccept      = onAccept
    o.errorMsg      = nil
    o.backgroundColor = { r = 0.05, g = 0.05, b = 0.05, a = 0.92 }
    o.borderColor     = { r = 0.5,  g = 0.5,  b = 0.5,  a = 1 }
    return o
end

function JsonIOWindow:createChildren()
    ISPanel.createChildren(self)

    local taY = HEADER_H + PAD
    local taH = H - HEADER_H - BTN_H - PAD * 3
    self.entry = ISTextEntryBox:new(self.initialText, PAD, taY, W - PAD * 2, taH)
    self.entry:initialise()
    self.entry:instantiate()
    self.entry:setMultipleLine(true)
    self.entry:setMaxLines(10000)

    self:addChild(self.entry)

    local btnY = H - PAD - BTN_H
    if self.mode == "export" then
        self.btnOK = ISButton:new(W - PAD - BTN_W, btnY, BTN_W, BTN_H,
            "Done", self, JsonIOWindow.onClose)
        self.btnOK:initialise(); self.btnOK:instantiate()
        self:addChild(self.btnOK)
    else
        self.btnCancel = ISButton:new(W - PAD - BTN_W * 2 - 6, btnY, BTN_W, BTN_H,
            "Cancel", self, JsonIOWindow.onClose)
        self.btnCancel:initialise(); self.btnCancel:instantiate()
        self:addChild(self.btnCancel)

        self.btnOK = ISButton:new(W - PAD - BTN_W, btnY, BTN_W, BTN_H,
            "Import", self, JsonIOWindow.onImport)
        self.btnOK:initialise(); self.btnOK:instantiate()
        self:addChild(self.btnOK)
    end
end

function JsonIOWindow:prerender()
    ISPanel.prerender(self)
    self:drawText(self.titleText, PAD, 8, 1, 1, 1, 1, UIFont.Medium)
    if self.errorMsg then
        local tm = getTextManager()
        local fh = tm:getFontHeight(UIFont.Small)
        self:drawText(self.errorMsg, PAD, H - PAD - BTN_H - fh - 4,
            1, 0.5, 0.5, 1, UIFont.Small)
    end
end

function JsonIOWindow:onClose()
    self:setVisible(false)
    self:removeFromUIManager()
end

function JsonIOWindow:onImport()
    local text = self.entry:getInternalText() or ""
    local data, err = json.decode(text)
    if not data then
        self.errorMsg = "Parse error: " .. tostring(err)
        return
    end
    if type(data) ~= "table" then
        self.errorMsg = "Expected a JSON object at top level."
        return
    end
    local ok, accErr = pcall(self.onAccept, data)
    if not ok then
        self.errorMsg = "Import failed: " .. tostring(accErr)
        return
    end
    self:onClose()
end

function JsonIOWindow.openExport(title, text)
    local w = JsonIOWindow:new("export", title, text, nil)
    w:initialise()
    w:addToUIManager()
    w:setVisible(true)
    return w
end

function JsonIOWindow.openImport(title, onAccept)
    local w = JsonIOWindow:new("import", title, "", onAccept)
    w:initialise()
    w:addToUIManager()
    w:setVisible(true)
    return w
end
