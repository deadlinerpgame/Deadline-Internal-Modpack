local TableUtil = require("KnoxBuildworks/Util/Table")

local Matrix = {}

local fallbackFaces = {
    W = { "W", "E", "S", "N" },
    E = { "E", "W", "S", "N" },
    N = { "N", "S", "W", "E" },
    S = { "S", "N", "W", "E" }
}

local function normalizeFace(face)
    if type(face) == "number" then return ({ "W", "N", "E", "S" })[face] or "W" end
    return face or "W"
end

local function hasEntries(values)
    for _ in pairs(values or {}) do
        return true
    end
    return false
end

local function cellFromToken(token, x, y, z)
    if token == false then return nil end
    if token == true then return { dx = x, dy = y, dz = z, empty = true, blocks = true } end
    if type(token) == "string" then return { dx = x, dy = y, dz = z, sprite = token, blocks = true } end
    if type(token) ~= "table" then return nil end
    if token.empty == true and token.blocks ~= true then return nil end
    return {
        dx = (token.dx or 0) + x,
        dy = (token.dy or 0) + y,
        dz = (token.dz or 0) + z,
        sprite = token.sprite,
        empty = token.empty == true or token.sprite == nil,
        blocks = token.blocks ~= false,
        kind = token.kind,
        properties = TableUtil.copy(token.properties or {})
    }
end

function Matrix.expandFace(face)
    local cells = {}
    local layers = face and face.layers or {}
    for layerIndex = 1, #layers do
        local layer = layers[layerIndex]
        local z = layer.z or (layerIndex - 1)
        local rows = layer.rows or {}
        for rowIndex = 1, #rows do
            local row = rows[rowIndex]
            local y = (layer.y or 0) + (rowIndex - 1)
            for columnIndex = 1, #row do
                local token = row[columnIndex]
                local cell = cellFromToken(token, (layer.x or 0) + (columnIndex - 1), y, z)
                if cell then cells[#cells + 1] = cell end
            end
        end
    end
    return cells
end

function Matrix.normalizeStage(stage)
    stage.cellsByFace = stage.cellsByFace or {}
    local faces = stage.geometry and stage.geometry.faces
    for direction, face in pairs(faces or {}) do
        stage.cellsByFace[direction] = Matrix.expandFace(face)
    end
    for direction, cells in pairs(stage.footprints or {}) do
        if not stage.cellsByFace[direction] then
            stage.cellsByFace[direction] = {}
            for i = 1, #cells do
                stage.cellsByFace[direction][#stage.cellsByFace[direction] + 1] = TableUtil.copy(cells
                    [i])
            end
        end
    end
    if not hasEntries(stage.cellsByFace) and stage.sprites then
        for direction, sprite in pairs(stage.sprites) do
            stage.cellsByFace[direction] = {
                {
                    dx = 0,
                    dy = 0,
                    dz = 0,
                    sprite = sprite,
                    blocks = true
                }
            }
        end
    end
    stage.footprints = stage.cellsByFace
    stage.sprites = stage.sprites or {}
    for direction, cells in pairs(stage.cellsByFace) do
        if not stage.sprites[direction] then
            for i = 1, #cells do
                local cell = cells[i]
                if cell.sprite then
                    stage.sprites[direction] = cell.sprite
                    break
                end
            end
        end
    end
    return stage
end

function Matrix.getFaceCells(stage, face)
    local cellsByFace = stage and stage.cellsByFace or nil
    if not cellsByFace then return nil end
    local key = normalizeFace(face)
    if cellsByFace[key] then return cellsByFace[key], key end
    local fallbacks = fallbackFaces[key] or { "W", "N", "E", "S" }
    for i = 1, #fallbacks do
        local fallback = fallbacks[i]
        if cellsByFace[fallback] then return cellsByFace[fallback], fallback end
    end
    return nil, key
end

function Matrix.getFaceSprite(stage, face)
    local sprites = stage and stage.sprites or nil
    if not sprites then return nil end
    local key = normalizeFace(face)
    if sprites[key] then return sprites[key], key end
    local fallbacks = fallbackFaces[key] or { "W", "N", "E", "S" }
    for i = 1, #fallbacks do
        local fallback = fallbacks[i]
        if sprites[fallback] then return sprites[fallback], fallback end
    end
    return nil, key
end

function Matrix.getBounds(cells)
    local bounds = { minX = 0, maxX = 0, minY = 0, maxY = 0, minZ = 0, maxZ = 0 }
    cells = cells or {}
    for i = 1, #cells do
        local cell = cells[i]
        bounds.minX = math.min(bounds.minX, cell.dx)
        bounds.maxX = math.max(bounds.maxX, cell.dx)
        bounds.minY = math.min(bounds.minY, cell.dy)
        bounds.maxY = math.max(bounds.maxY, cell.dy)
        bounds.minZ = math.min(bounds.minZ, cell.dz or 0)
        bounds.maxZ = math.max(bounds.maxZ, cell.dz or 0)
    end
    bounds.width = bounds.maxX - bounds.minX + 1
    bounds.height = bounds.maxY - bounds.minY + 1
    bounds.depth = bounds
        .maxZ
        - bounds.minZ
        + 1
    return bounds
end

return Matrix
