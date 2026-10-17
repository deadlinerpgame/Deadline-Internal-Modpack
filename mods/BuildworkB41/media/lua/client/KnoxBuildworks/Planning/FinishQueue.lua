local WallFinishes = require("KnoxBuildworks/Validation/WallFinishes")
local KBWFinishAction = require("KnoxBuildworks/TimedActions/KBWFinishAction")
local BuildableRules = require("KnoxBuildworks/Admin/BuildableRules")
local Log = require("KnoxBuildworks/Log")
local KBWB41 = require("KnoxBuildworks/Compat/B41")

local FinishQueue = {}

local pending = {}

local function matchesEntry(object, entry)
    if not object or not object.getModData then return false end
    local data = object:getModData()
    return data ~= nil and data.KBW ~= nil and data.KBW.buildableId == entry.buildableId
end

local function wallsAlreadyOnTile(buildableId, x, y, z)
    local existing = {}
    local square = getCell() and getCell():getGridSquare(x, y, z) or nil
    if not square then return existing end
    local probe = { buildableId = buildableId }
    local special = square:getSpecialObjects()
    for objectIndex = 0, special:size() - 1 do
        local object = special:get(objectIndex)
        if matchesEntry(object, probe) then existing[object] = true end
    end
    local objects = square:getObjects()
    for objectIndex = 0, objects:size() - 1 do
        local object = objects:get(objectIndex)
        if matchesEntry(object, probe) then existing[object] = true end
    end
    return existing
end

local function findBuiltWall(entry, preferUnfinished)
    if entry.wall and entry.wall.getSquare and entry.wall:getSquare() then return entry.wall end
    local square = getCell():getGridSquare(entry.x, entry.y, entry.z)
    if not square then return nil end
    local candidates = {}
    local edgeMatch = nil
    for i = 0, square:getSpecialObjects():size() - 1 do
        local object = square:getSpecialObjects():get(i)
        if instanceof(object, "IsoThumpable") and matchesEntry(object, entry)
            and not (entry.existing and entry.existing[object]) then
            candidates[#candidates + 1] = object
            if edgeMatch == nil and object:getNorth() == entry.north then edgeMatch = object end
        end
    end
    if #candidates == 0 then
        local objects = square:getObjects()
        for i = 0, objects:size() - 1 do
            local object = objects:get(i)
            if not instanceof(object, "IsoThumpable") and matchesEntry(object, entry)
                and not (entry.existing and entry.existing[object]) then
                candidates[#candidates + 1] = object
            end
        end
    end
    if preferUnfinished then
        if edgeMatch ~= nil and WallFinishes.objectFinishSignature(edgeMatch) == nil then
            return edgeMatch
        end
        local bare, bareCount = nil, 0
        for candidateIndex = 1, #candidates do
            if WallFinishes.objectFinishSignature(candidates[candidateIndex]) == nil then
                bare = candidates[candidateIndex]
                bareCount = bareCount + 1
            end
        end
        if bareCount == 1 then return bare end
    end
    if edgeMatch ~= nil then
        Log:info(
            "Finish for %s at %d,%d,%d took the edge match out of %d wall(s) on the tile",
            tostring(entry.buildableId), entry.x, entry.y, entry.z, #candidates
        )
        return edgeMatch
    end
    if #candidates == 1 then return candidates[1] end
    return nil
end

local function cheat(player)
    return player.isBuildCheat and player:isBuildCheat()
end

local function predicateNotBroken(item)
    if not item then return false end
    if item.isBroken and item:isBroken() then return false end
    if item.isDestroyed and item:isDestroyed() then return false end
    return true
end

local function predicateEnoughDrain(item)
    if not item then return false end
    if item.isDestroyed and item:isDestroyed() then return false end
    if KBWB41.isDrainable(item) then return KBWB41.usesLeftFloat(item) >= 0.1 end
    return true
end

local function finishSprite(entry, wall, mode)
    local wallType = WallFinishes.objectWallType(wall)
    local north = WallFinishes.objectNorth(wall)
    local sprite = wall and wall:getSprite() or nil
    local baseSprite = sprite and sprite:getName() or nil
    return WallFinishes.spriteForWallType(mode, entry.finish, north, wallType, baseSprite)
        or WallFinishes.spriteFor(mode, entry.finish, north, entry.definition, entry.stage, baseSprite)
end

local function queuePlaster(entry, wall)
    local player = entry.player
    local sprite = finishSprite(entry, wall, "plaster")
    if not sprite then
        Log:warning("No plaster sprite for %s at %d,%d,%d", entry.buildableId, entry.x, entry.y, entry.z)
        return false
    end
    local bucket = nil
    local trowel = nil
    local required = BuildableRules.wallFinishRequirement(entry.definition, entry.stage, "plaster")
    if required and not cheat(player) then
        trowel = KBWB41.findFinishItem(player:getInventory(), "plastertrowel", predicateNotBroken)
        bucket = KBWB41.findFinishItem(player:getInventory(), "plasterbucket", predicateEnoughDrain)
        if not trowel or not bucket then
            Log:warning("Plaster action lost its required tool/material for %s", entry.buildableId)
            return false
        end
        ISWorldObjectContextMenu.transferIfNeeded(player, trowel)
        ISWorldObjectContextMenu.transferIfNeeded(player, bucket)
    end
    Log:info("Queued plaster action for %s at %d,%d,%d", entry.buildableId, entry.x, entry.y, entry.z)
    ISTimedActionQueue.add(KBWFinishAction:new(
        player, "plaster", wall, sprite, bucket, trowel, nil, nil, entry.finish, true
    ))
    return true
end

local function queuePaint(entry, wall)
    local player = entry.player
    local sprite = finishSprite(entry, wall, "paint")
    if not sprite then
        Log:warning("No paint sprite for %s at %d,%d,%d", entry.buildableId, entry.x, entry.y, entry.z)
        return false
    end
    local paintCan, paintCans = nil, nil
    local required = BuildableRules.wallFinishRequirement(entry.definition, entry.stage, "paint")
    if required and not cheat(player) then
        local brush = KBWB41.findFinishItem(player:getInventory(), "paintbrush", predicateNotBroken)
        if not brush then
            Log:warning("No usable paintbrush left for %s at %d,%d,%d", entry.buildableId, entry.x, entry.y, entry.z)
            return false
        end
        ISWorldObjectContextMenu.transferIfNeeded(player, brush)
        paintCans = WallFinishes.paintItemsIn(player:getInventory(), entry.finish.paintType)
        if not paintCans then
            Log:warning(
                "No %s left for %s at %d,%d,%d", tostring(entry.finish.paintType),
                entry.buildableId, entry.x, entry.y, entry.z
            )
            return false
        end
        for canIndex = 1, #paintCans do
            ISWorldObjectContextMenu.transferIfNeeded(player, paintCans[canIndex].item)
        end
        paintCan = paintCans[1].item
    end
    Log:info("Queued paint action for %s at %d,%d,%d", entry.buildableId, entry.x, entry.y, entry.z)
    ISTimedActionQueue.add(KBWFinishAction:new(
        player, "paint", wall, sprite, paintCan, nil, nil, nil, entry.finish, true, paintCans
    ))
    return true
end

local function queueWallpaper(entry, wall)
    local player = entry.player
    local sprite = finishSprite(entry, wall, "wallpaper")
    if not sprite then
        Log:warning("No wallpaper sprite for %s at %d,%d,%d", entry.buildableId, entry.x, entry.y, entry.z)
        return false
    end
    local roll = nil
    local required = BuildableRules.wallFinishRequirement(entry.definition, entry.stage, "wallpaper")
    if required and not cheat(player) then
        roll = player:getInventory():getFirstTypeRecurse(entry.finish.wallpaperType)
        local brush = KBWB41.findFinishItem(player:getInventory(), "paintbrush", predicateNotBroken)
        local paste = player:getInventory():getFirstTagEvalRecurse("WallpaperPaste", predicateEnoughDrain)
        local scissors = player:getInventory():getFirstTagEvalRecurse("Scissors", predicateNotBroken)
        if not roll or not brush or not paste or not scissors then
            Log:warning(
                "Missing wallpaper tools or roll for %s at %d,%d,%d", entry.buildableId,
                entry.x, entry.y, entry.z
            )
            return false
        end
        ISWorldObjectContextMenu.transferIfNeeded(player, roll)
        ISWorldObjectContextMenu.transferIfNeeded(player, brush)
        ISWorldObjectContextMenu.transferIfNeeded(player, paste)
        ISWorldObjectContextMenu.transferIfNeeded(player, scissors)
    end
    Log:info("Queued wallpaper action for %s at %d,%d,%d", entry.buildableId, entry.x, entry.y, entry.z)
    ISTimedActionQueue.add(KBWFinishAction:new(
        player, "wallpaper", wall, sprite, roll, nil, nil, nil, entry.finish, true
    ))
    return true
end

local function step(entry)
    local now = getTimestampMs()
    if now > entry.deadline then
        local square = getCell():getGridSquare(entry.x, entry.y, entry.z)
        local total, matching = 0, 0
        if square then
            total = square:getSpecialObjects():size()
            for i = 0, total - 1 do
                if matchesEntry(square:getSpecialObjects():get(i), entry) then matching = matching + 1 end
            end
        end
        Log:warning(
            "Timed out applying selected finish to %s at %d,%d,%d in phase %s"
            .. " (%d object(s) on the tile, %d of this buildable)",
            entry.buildableId, entry.x, entry.y, entry.z, tostring(entry.phase), total, matching
        )
        return false
    end
    local wall = findBuiltWall(entry, entry.phase == "built")
    if entry.phase == "built" then
        if not wall then return true end
        entry.wall = wall
        if entry.finish.plaster == false then
            if entry.finish.paintType then
                queuePaint(entry, wall)
            elseif entry.finish.wallpaperType then
                queueWallpaper(entry, wall)
            end
            return false
        end
        if not queuePlaster(entry, wall) then return false end
        if entry.finish.paintType then
            queuePaint(entry, wall)
        elseif entry.finish.wallpaperType then
            queueWallpaper(entry, wall)
        end
        return false
    end
    return false
end

local function onTick()
    local remaining = {}
    for index = 1, #pending do
        local entry = pending[index]
        if step(entry) then remaining[#remaining + 1] = entry end
    end
    pending = remaining
    if #pending == 0 then KBWB41.removeEvent("OnTick", onTick) end
end

function FinishQueue.watch(player, buildableId, x, y, z, north, finish, definition, stage)
    if not WallFinishes.isWallFinish(finish) then return end
    Log:info(
        "Finish queued for %s at %d,%d,%d north=%s plaster=%s paint=%s wallpaper=%s",
        tostring(buildableId), x, y, z, tostring(north == true),
        tostring(finish.plaster), tostring(finish.paintType), tostring(finish.wallpaperType)
    )
    if #pending == 0 then KBWB41.addEvent("OnTick", onTick) end
    pending[#pending + 1] = {
        player = player,
        buildableId = buildableId,
        existing = wallsAlreadyOnTile(buildableId, x, y, z),
        x = x,
        y = y,
        z = z,
        north = north == true,
        finish = finish,
        definition = definition,
        stage = stage,
        phase = "built",
        deadline = getTimestampMs() + 30000
    }
end

return FinishQueue
