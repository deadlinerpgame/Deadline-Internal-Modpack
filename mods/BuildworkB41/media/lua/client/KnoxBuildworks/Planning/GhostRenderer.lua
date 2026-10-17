local Matrix = require("KnoxBuildworks/Geometry/Matrix")
local Blueprints = require("KnoxBuildworks/Planning/Blueprints")
local WallFinishes = require("KnoxBuildworks/Validation/WallFinishes")
local EntityCompat = require("KnoxBuildworks/Entity/EntityCompat")
local KBWB41 = require("KnoxBuildworks/Compat/B41")

local GhostRenderer = {}

GhostRenderer.PLAN_COLOR = { r = 0.55, g = 0.78, b = 1.00, a = 0.30 }
GhostRenderer.PLAN_COLOR_DIM = { r = 0.55, g = 0.78, b = 1.00, a = 0.12 }
GhostRenderer.CONFLICT_COLOR = { r = 0.80, g = 0.25, b = 0.20, a = 0.34 }
GhostRenderer.HIGHLIGHT_COLOR = { r = 0.95, g = 0.85, b = 0.35, a = 0.42 }
GhostRenderer.GATHER_COLOR = { r = 1.00, g = 1.00, b = 1.00, a = 0.13 }
GhostRenderer.RANGE_COLOR = { r = 0.90, g = 0.95, b = 1.00, a = 0.16 }
GhostRenderer.opacity = 0.14

local spriteCache = {}
local areaQueue = {}
local lastAreaQueue = {}
local lastAreaQueueTime = 0
local cellCache = {}
local cellCacheCount = 0
local CELL_CACHE_LIMIT = 4096
local orderCache = { source = nil, updated = nil, count = 0, order = {} }

function GhostRenderer.setOpacity(value)
    value = tonumber(value) or 0.14
    if value < 0.04 then value = 0.04 end
    if value > 0.55 then value = 0.55 end
    GhostRenderer.opacity = value
end

local function colorAlpha(color, fallback)
    local opacity = GhostRenderer.opacity or 0.14
    local requested = color and color.a or fallback or 0.14
    local alpha = requested * (opacity / 0.14)
    if alpha < 0.015 then return 0.015 end
    if alpha > 0.55 then return 0.55 end
    return alpha
end

function GhostRenderer.levelAlpha(cellZ, activeLevel, base)
    if activeLevel == nil then return base end
    local diff = math.abs((cellZ or 0) - activeLevel)
    if diff == 0 then return base end
    if diff == 1 then return base * 0.35 end
    return 0
end

function GhostRenderer.getSprite(spriteName)
    if not spriteName then return nil end
    local sprite = spriteCache[spriteName]
    if sprite then return sprite end
    sprite = getSprite(spriteName)
    if not sprite then
        sprite = IsoSprite.new()
        KBWB41.loadSpriteTexture(sprite, spriteName)
    end
    spriteCache[spriteName] = sprite
    return sprite
end

function GhostRenderer.getFloorCursorSprite()
    return KBWB41.floorCursorSprite()
end

local cellQueue = {}

local function drawCell(sprite, x, y, z, color, alpha)
    if not sprite or alpha <= 0 then return end
    cellQueue[#cellQueue + 1] = {
        sprite = sprite,
        x = x, y = y, z = z,
        r = color.r or 1, g = color.g or 1, b = color.b or 1,
        a = alpha
    }
end

local function queueAreaHighlight(playerIndex, x1, y1, x2, y2, z, color, alpha)
    if alpha <= 0 then return end
    areaQueue[#areaQueue + 1] = {
        playerIndex = playerIndex or 0,
        x1 = x1,
        y1 = y1,
        x2 = x2,
        y2 = y2,
        z = z,
        r = color.r or 0.25,
        g = color.g or 0.65,
        b = color.b or 0.95,
        a = alpha
    }
end

local lastCellQueue = {}

local function currentSources()
    local now = getTimestampMs and getTimestampMs() or 0
    if #areaQueue > 0 or #cellQueue > 0 then
        lastAreaQueue = areaQueue
        lastCellQueue = cellQueue
        lastAreaQueueTime = now
        return areaQueue, cellQueue
    end
    if now - (lastAreaQueueTime or 0) < 180 then return lastAreaQueue, lastCellQueue end
    return areaQueue, cellQueue
end

function GhostRenderer.drawAreaHighlightsForLayer(z)
    local areas, cells = currentSources()
    for areaIndex = 1, #areas do
        local area = areas[areaIndex]
        if area.z == z then
            KBWB41.addAreaHighlight(
                area.playerIndex, area.x1, area.y1, area.x2, area.y2, area.z, area.r, area.g, area.b, area.a
            )
        end
    end
    for cellIndex = 1, #cells do
        local cell = cells[cellIndex]
        if cell.z == z and cell.sprite then
            cell.sprite:RenderGhostTileColor(cell.x, cell.y, cell.z, cell.r, cell.g, cell.b, cell.a)
        end
    end
end

function GhostRenderer.flushAreaHighlights()
    currentSources()
    areaQueue = {}
    cellQueue = {}
end

local function finishSignature(finish)
    if type(finish) ~= "table" then return "" end
    return tostring(finish.actionType) .. ":" .. tostring(finish.plaster) .. ":" .. tostring(finish.paintType) .. ":"
        .. tostring(finish.wallpaperType) .. ":" .. tostring(finish.sign)
end

local function placementSignature(placement)
    return tostring(placement.id) .. "|" .. tostring(placement.buildableId) .. "|" .. tostring(placement.stageId) .. "|"
        .. tostring(placement.variantId) .. "|" .. tostring(placement.materialId) .. "|" .. tostring(placement.x) .. "|"
        .. tostring(placement.y) .. "|" .. tostring(placement.z) .. "|" .. tostring(placement.direction) .. "|"
        .. finishSignature(placement.finish) .. "|"
        .. tostring(placement.finishTarget and placement.finishTarget.wallType or "")
end

local function wallCoveringAction(definition, stage)
    if not definition or ((definition.placement or {}).kind ~= "wallCovering") then return nil end
    local compat = EntityCompat.metadata(stage)
    local config = compat.wallCoveringConfig or {}
    return config.type or (definition.placement or {}).wallCoveringType
end

function GhostRenderer.clearCache()
    cellCache = {}
    cellCacheCount = 0
    orderCache = { source = nil, updated = nil, count = 0, order = {} }
end

local function cacheCells(key, entry)
    if cellCacheCount >= CELL_CACHE_LIMIT then GhostRenderer.clearCache() end
    if cellCache[key] == nil then cellCacheCount = cellCacheCount + 1 end
    cellCache[key] = entry
end

local function cacheKeyFor(placement)
    if placement.id then return placement.id, true end
    return placementSignature(placement), false
end

local function cachedCellsFor(placement, key, byId)
    local cached = cellCache[key]
    if not cached then return nil end
    if not byId then return cached end
    if cached.placement == placement and cached.x == placement.x and cached.y == placement.y and cached.z == placement.z
        and cached.direction == placement.direction and cached.finish == placement.finish
        and cached.finishTarget == placement.finishTarget then
        return cached
    end
    return nil
end

function GhostRenderer.placementCells(placement)
    local key, byId = cacheKeyFor(placement)
    local cached = cachedCellsFor(placement, key, byId)
    if cached then return cached.cells end
    local entry = {
        placement = byId and placement or nil,
        x = placement.x,
        y = placement.y,
        z = placement.z,
        direction = placement.direction,
        finish = placement.finish,
        finishTarget = placement.finishTarget
    }
    local definition, stage = Blueprints.resolvePlacement(placement)
    if not stage then
        cacheCells(key, entry)
        return nil
    end
    local cells = Matrix.getFaceCells(stage, tonumber(placement.direction) or 1)
    if not cells then
        local sprite = Matrix.getFaceSprite(stage, tonumber(placement.direction) or 1)
        cells = { { dx = 0, dy = 0, dz = 0, sprite = sprite, blocks = true } }
    end
    local direction = tonumber(placement.direction) or 1
    local north = direction == 2 or direction == 4
    local coveringAction = wallCoveringAction(definition, stage)
    local targetWallType = placement.finishTarget and placement.finishTarget.wallType or nil
    local out = {}
    for cellIndex = 1, #cells do
        local cell = cells[cellIndex]
        local finishSprite = nil
        if cell.sprite and WallFinishes.isWallFinish(placement.finish) then
            finishSprite = WallFinishes.previewSprite(placement.finish, north, definition, stage, cell.sprite)
        elseif cell.sprite and coveringAction and targetWallType then
            finishSprite = WallFinishes.spriteForWallType(coveringAction, placement.finish, north, targetWallType)
        end
        out[#out + 1] = {
            x = (placement.x or 0) + (cell.dx or 0),
            y = (placement.y or 0) + (cell.dy or 0),
            z = (placement.z or 0) + (cell.dz or 0),
            sprite = (cell.sprite and finishSprite) or cell.sprite,
            blocks = cell.blocks
        }
    end
    entry.cells = out
    cacheCells(key, entry)
    return out
end

function GhostRenderer.renderPlacement(placement, activeLevel, color)
    local cells = GhostRenderer.placementCells(placement)
    if not cells then return end
    color = color or GhostRenderer.PLAN_COLOR
    local baseAlpha = colorAlpha(color, 0.25)
    for cellIndex = 1, #cells do
        local cell = cells[cellIndex]
        local alpha = GhostRenderer.levelAlpha(cell.z, activeLevel, baseAlpha)
        if cell.sprite then
            drawCell(GhostRenderer.getSprite(cell.sprite), cell.x, cell.y, cell.z, color, alpha)
        elseif cell.blocks then
            drawCell(GhostRenderer.getFloorCursorSprite(), cell.x, cell.y, cell.z, color, alpha * 0.7)
        end
    end
end

function GhostRenderer.renderPlacementLayerAll(placement, color)
    GhostRenderer.renderPlacement(placement, nil, color)
end

function GhostRenderer.renderRoom(room, defaultZ, activeLevel, highlightRoomId, playerIndex)
    local roomZ = tonumber(room.z)
    if roomZ == nil then roomZ = tonumber(defaultZ) or 0 end
    local color = room.color or { r = 0.25, g = 0.65, b = 0.95, a = 0.12 }
    local highlighted = highlightRoomId and room.id == highlightRoomId
    local base = colorAlpha(color, 0.12)
    if highlighted then base = math.min(0.34, base + 0.08) end
    local alpha = GhostRenderer.levelAlpha(roomZ, activeLevel, base)
    if alpha <= 0 then return end
    local width = room.w or room.width or 1
    local height = room.h or room.height or 1
    local originX = room.x or 0
    local originY = room.y or 0
    queueAreaHighlight(playerIndex, originX, originY, originX + width, originY + height, roomZ, color, alpha)
end

local function placementSortValue(placement)
    return (tonumber(placement.z) or 0) * 100000 + (tonumber(placement.y) or 0) * 100 + (tonumber(placement.x) or 0)
end

local function sortedPlacements(blueprint)
    local placements = blueprint.placements or {}
    if orderCache.source == placements and orderCache.updated == blueprint.updated and orderCache.count == #placements then
        return orderCache.order
    end
    if orderCache.source == placements and #placements == orderCache.count - 1 then
        local present = {}
        for placementIndex = 1, #placements do
            local placement = placements[placementIndex]
            if placement.id then present[tostring(placement.id)] = true end
        end
        local filtered = {}
        for orderIndex = 1, #orderCache.order do
            local placement = orderCache.order[orderIndex]
            if placement.id and present[tostring(placement.id)] then filtered[#filtered + 1] = placement end
        end
        if #filtered == #placements then
            orderCache = { source = placements, updated = blueprint.updated, count = #placements, order = filtered }
            return filtered
        end
    end
    local order = {}
    for placementIndex = 1, #placements do
        order[placementIndex] = placements[placementIndex]
    end
    table.sort(order, function (a, b) return placementSortValue(a) < placementSortValue(b) end)
    orderCache = { source = placements, updated = blueprint.updated, count = #placements, order = order }
    return order
end

local CULL_MARGIN = 12

local function finiteWorldValue(value)
    return type(value) == "number" and value == value and math.abs(value) < 10000000
end

local function fallbackTileBounds(playerIndex)
    local player = getSpecificPlayer(playerIndex or 0) or getPlayer()
    local centerX = player and tonumber(player:getX()) or 0
    local centerY = player and tonumber(player:getY()) or 0
    local radius = 96
    return centerX - radius, centerY - radius, centerX + radius, centerY + radius
end

local function visibleTileBounds(playerIndex, z)
    playerIndex = playerIndex or 0
    local left = getPlayerScreenLeft(playerIndex)
    local top = getPlayerScreenTop(playerIndex)
    local right = left + getPlayerScreenWidth(playerIndex)
    local bottom = top + getPlayerScreenHeight(playerIndex)
    z = tonumber(z) or 0
    local x1 = screenToIsoX(playerIndex, left, top, z)
    local y1 = screenToIsoY(playerIndex, left, top, z)
    local x2 = screenToIsoX(playerIndex, right, top, z)
    local y2 = screenToIsoY(playerIndex, right, top, z)
    local x3 = screenToIsoX(playerIndex, left, bottom, z)
    local y3 = screenToIsoY(playerIndex, left, bottom, z)
    local x4 = screenToIsoX(playerIndex, right, bottom, z)
    local y4 = screenToIsoY(playerIndex, right, bottom, z)
    if not finiteWorldValue(x1) or not finiteWorldValue(y1) or not finiteWorldValue(x2)
        or not finiteWorldValue(y2) or not finiteWorldValue(x3) or not finiteWorldValue(y3)
        or not finiteWorldValue(x4) or not finiteWorldValue(y4) then
        return fallbackTileBounds(playerIndex)
    end
    local minX = math.min(x1, x2, x3, x4) - CULL_MARGIN
    local minY = math.min(y1, y2, y3, y4) - CULL_MARGIN
    local maxX = math.max(x1, x2, x3, x4) + CULL_MARGIN
    local maxY = math.max(y1, y2, y3, y4) + CULL_MARGIN
    local player = getSpecificPlayer(playerIndex or 0) or getPlayer()
    local playerX = player and tonumber(player:getX()) or nil
    local playerY = player and tonumber(player:getY()) or nil
    if maxX <= minX or maxY <= minY or maxX - minX > 1000 or maxY - minY > 1000
        or (playerX and playerY
            and (playerX < minX - CULL_MARGIN or playerX > maxX + CULL_MARGIN
                or playerY < minY - CULL_MARGIN or playerY > maxY + CULL_MARGIN)) then
        return fallbackTileBounds(playerIndex)
    end
    return minX, minY, maxX, maxY
end

function GhostRenderer.renderBlueprint(blueprint, activeLevel, highlightId, highlightRoomId, playerIndex)
    local area = blueprint.gatherArea
    if area then
        queueAreaHighlight(
            playerIndex, area.x1 or 0, area.y1 or 0, (area.x2 or 0) + 1, (area.y2 or 0) + 1, area.z or 0,
            GhostRenderer.GATHER_COLOR, colorAlpha(GhostRenderer.GATHER_COLOR, 0.13)
        )
    end
    local rooms = blueprint.rooms or {}
    for roomIndex = 1, #rooms do
        GhostRenderer.renderRoom(rooms[roomIndex], blueprint.level, activeLevel, highlightRoomId, playerIndex)
    end
    local order = sortedPlacements(blueprint)
    local minX, minY, maxX, maxY = visibleTileBounds(playerIndex, activeLevel)
    for pass = 1, 2 do
        for placementIndex = 1, #order do
            local placement = order[placementIndex]
            local px = tonumber(placement.x) or 0
            local py = tonumber(placement.y) or 0
            if px >= minX and px <= maxX and py >= minY and py <= maxY then
                local onActive = (tonumber(placement.z) or 0) == activeLevel
                if (pass == 1 and not onActive) or (pass == 2 and onActive) then
                    local color = GhostRenderer.PLAN_COLOR
                    if highlightId and placement.id == highlightId then
                        color = GhostRenderer.HIGHLIGHT_COLOR
                    end
                    GhostRenderer.renderPlacement(placement, activeLevel, color)
                end
            end
        end
    end
end

function GhostRenderer.renderBlueprintOffset(blueprint, dx, dy, playerIndex)
    local color = GhostRenderer.HIGHLIGHT_COLOR
    local alpha = colorAlpha(color, 0.30)
    local placements = blueprint.placements or {}
    local minX, minY, maxX, maxY = visibleTileBounds(playerIndex, blueprint.level)
    for placementIndex = 1, #placements do
        local placement = placements[placementIndex]
        local px = (tonumber(placement.x) or 0) + dx
        local py = (tonumber(placement.y) or 0) + dy
        local cells = nil
        if px >= minX and px <= maxX and py >= minY and py <= maxY then
            cells = GhostRenderer.placementCells(placement)
        end
        if cells then
            for cellIndex = 1, #cells do
                local cell = cells[cellIndex]
                if cell.sprite then
                    drawCell(GhostRenderer.getSprite(cell.sprite), cell.x + dx, cell.y + dy, cell.z, color, alpha)
                elseif cell.blocks then
                    drawCell(GhostRenderer.getFloorCursorSprite(), cell.x + dx, cell.y + dy, cell.z, color, alpha * 0.7)
                end
            end
        end
    end
    local rooms = blueprint.rooms or {}
    for roomIndex = 1, #rooms do
        local room = rooms[roomIndex]
        local roomZ = tonumber(room.z) or tonumber(blueprint.level) or 0
        local roomColor = room.color or { r = 0.25, g = 0.65, b = 0.95, a = 0.12 }
        local originX = (room.x or 0) + dx
        local originY = (room.y or 0) + dy
        queueAreaHighlight(
            playerIndex, originX, originY, originX + (room.w or room.width or 1), originY + (room.h or room.height or 1),
            roomZ, roomColor, colorAlpha(roomColor, 0.12)
        )
    end
end

function GhostRenderer.renderRect(x1, y1, x2, y2, z, color, playerIndex)
    local minX, maxX = math.min(x1, x2), math.max(x1, x2)
    local minY, maxY = math.min(y1, y2), math.max(y1, y2)
    color = color or { r = 0.25, g = 0.65, b = 0.95, a = 0.12 }
    local alpha = colorAlpha(color, 0.12)
    queueAreaHighlight(playerIndex, minX, minY, maxX + 1, maxY + 1, z, color, alpha)
end

function GhostRenderer.renderRectBorder(x1, y1, x2, y2, z, color, playerIndex)
    local minX, maxX = math.min(x1, x2), math.max(x1, x2)
    local minY, maxY = math.min(y1, y2), math.max(y1, y2)
    color = color or GhostRenderer.RANGE_COLOR
    local alpha = colorAlpha(color, 0.14)
    local right = maxX + 1
    local bottom = maxY + 1
    queueAreaHighlight(playerIndex, minX, minY, right, minY + 1, z, color, alpha)
    if bottom > minY + 1 then
        queueAreaHighlight(playerIndex, minX, bottom - 1, right, bottom, z, color, alpha)
    end
    if bottom > minY + 2 then
        queueAreaHighlight(playerIndex, minX, minY + 1, minX + 1, bottom - 1, z, color, alpha)
        if right > minX + 1 then
            queueAreaHighlight(playerIndex, right - 1, minY + 1, right, bottom - 1, z, color, alpha)
        end
    end
end

function GhostRenderer.renderTileHighlight(x, y, z, color, alpha, playerIndex)
    queueAreaHighlight(
        playerIndex, x, y, x + 1, y + 1, z, color,
        colorAlpha({ r = color.r, g = color.g, b = color.b, a = alpha or 0.24 }, alpha or 0.24)
    )
end

KBWB41.addEvent("OnPostFloorLayerDraw", GhostRenderer.drawAreaHighlightsForLayer)
KBWB41.addEvent("OnPreUIDraw", GhostRenderer.flushAreaHighlights)

return GhostRenderer
