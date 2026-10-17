DL = DL or {}
DL.Forge = {}

local function trim(s) return (tostring(s):gsub("^%s*(.-)%s*$", "%1")) end

function DL.Forge.label(name)
    if not name then return nil end
    local s = trim(name)
    s = s:gsub("%s*Ingot%s*$", "")
    s = s:gsub("%s*Ingot%s+", " ")
    return trim(s)
end

local function fromIngotData(d)
    if not d then return nil end
    return {
        alloyId     = d.alloyId or d.id,
        name        = d.name,
        label       = DL.Forge.label(d.name),
        rgb         = d.rgb or d.color,
        quality     = d.quality,
        composition = d.composition,
        stats       = d.stats,
    }
end

local function fromLegacy(s)
    if type(s) ~= "string" or s == "" then return nil end
    local name = trim(s:gsub("^%s*Made from%s*", ""))
    if name == "" or name == "Unknown" then return nil end
    return { alloyId = nil, name = name, label = DL.Forge.label(name), legacy = true }
end

function DL.Forge.materialOf(item)
    if not item or not item.getModData then return nil end
    local md = item:getModData()
    if not md then return nil end
    return fromIngotData(md.DL) or (md.DLMade and fromIngotData(md.DLMade)) or fromLegacy(md.AlloyType)
end

function DL.Forge.stamp(item, mat)
    if not item or not mat or not item.getModData then return false end
    local md = item:getModData()
    md.DLMade = {
        alloyId     = mat.alloyId,
        name        = mat.name,
        rgb         = mat.rgb,
        quality     = mat.quality,
        composition = mat.composition,
        stats       = mat.stats,
    }
    if mat.label then md.AlloyType = "Made from " .. mat.label end
    if item.transmitModData then item:transmitModData() end
    return true
end

function DL.Forge.applyName(item, mat)
    if not item or not item.setName or not item.getName then return end
    mat = mat or DL.Forge.materialOf(item)
    if not mat or not mat.label or mat.label == "" then return end
    local current = item:getName() or ""
    if current:sub(1, #mat.label) == mat.label then return end
    item:setName(mat.label .. " " .. current)
end

function DL.Forge.sourceMaterial(items)
    if not items then return nil, nil end
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        local mat = DL.Forge.materialOf(item)
        if mat then return mat, item end
    end
    return nil, nil
end

function DL.Forge.transfer(items, result, rename)
    local mat = DL.Forge.sourceMaterial(items)
    if not mat or not result then return nil end
    DL.Forge.stamp(result, mat)
    if rename ~= false then DL.Forge.applyName(result, mat) end
    return mat
end

function DL.Forge.compositionLines(mat)
    local out = {}
    if not mat or type(mat.composition) ~= "table" then return out end
    local rows = {}
    for metal, frac in pairs(mat.composition) do
        if type(frac) == "number" and frac > 0 then
            local meta = DL.Metals and DL.Metals[metal] or nil
            rows[#rows + 1] = { name = meta and meta.name or metal, frac = frac }
        end
    end
    table.sort(rows, function (a, b) return a.frac > b.frac end)
    for i = 1, #rows do
        out[#out + 1] = string.format("%s %d%%", rows[i].name, math.floor(rows[i].frac * 100 + 0.5))
    end
    return out
end

function DL.Forge.describe(item)
    local mat = DL.Forge.materialOf(item)
    if not mat then return {}, nil end
    local lines = {}
    local head = mat.name or mat.label or "Unknown metal"
    if mat.quality then head = string.format("%s  (quality %d%%)", head, math.floor(mat.quality + 0.5)) end
    lines[#lines + 1] = head
    local comp = DL.Forge.compositionLines(mat)
    if #comp > 0 then lines[#lines + 1] = table.concat(comp, "   ") end
    return lines, mat
end
