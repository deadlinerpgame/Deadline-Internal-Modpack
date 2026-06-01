DL = DL or {}
DL.ItemTree = DL.ItemTree or {}

local function describeItem(it)
    local disp = (function() return it:getDisplayName() end)()
    local ftype = (function() return it:getFullType() end)()
    local s = tostring(disp or "?")
    if ftype then s = s .. " [" .. tostring(ftype) .. "]" end
    return s
end

local function formatModData(it)
    local md = (function() return it:getModData() end)()
    if md == nil then return nil end
    local parts = {}
    pcall(function()
        for k, v in pairs(md) do
            if type(v) == "table" then parts[#parts + 1] = tostring(k) .. "=<table>"
            else parts[#parts + 1] = tostring(k) .. "=" .. tostring(v) end
        end
    end)
    if #parts == 0 then return nil end
    return table.concat(parts, ", ")
end

local function appendItem(lines, it, indent, depth, seen)
    if it == nil or seen[it] or depth > 16 then return end
    seen[it] = true
    local sub = it.getInventory and (function() return it:getInventory() end)()
    local isBag = sub ~= nil
    lines[#lines + 1] = indent .. "* " .. describeItem(it) .. (isBag and "  (bag)" or "")
    local md = formatModData(it)
    if md then lines[#lines + 1] = indent .. "    {modData: " .. md .. "}" end
    if isBag then
        local items = (function() return sub:getItems() end)()
        if items then
            for i = 0, items:size() - 1 do
                appendItem(lines, items:get(i), indent .. "   ", depth + 1, seen)
            end
        end
    end
end

function DL.ItemTree.containerLines(container)
    local lines, seen = {}, {}
    if container == nil then return lines end
    local items = (function() return container:getItems() end)()
    if items then
        for i = 0, items:size() - 1 do appendItem(lines, items:get(i), "", 0, seen) end
    end
    return lines
end

function DL.ItemTree.characterLines(character)
    local lines, seen = {}, {}
    if character == nil then return lines end

    ;(function()
        local w = character:getWornItems()
        if w then for i = 0, w:size() - 1 do local e = w:get(i); appendItem(lines, e and e:getItem(), "", 0, seen) end end
    end)()
    ;(function()
        appendItem(lines, character:getPrimaryHandItem(), "", 0, seen)
        appendItem(lines, character:getSecondaryHandItem(), "", 0, seen)
    end)()
    ;(function()
        local inv = character:getInventory()
        if inv then
            local items = inv:getItems()
            if items then for i = 0, items:size() - 1 do appendItem(lines, items:get(i), "", 0, seen) end end
        end
    end)()

    return lines
end

DL.log("item tree helper loaded")
