local Blueprints = require("KnoxBuildworks/Planning/Blueprints")
local Requirements = require("KnoxBuildworks/Validation/Requirements")
local Placement = require("KnoxBuildworks/Validation/Placement")
local WallFinishes = require("KnoxBuildworks/Validation/WallFinishes")
local FinishActions = require("KnoxBuildworks/Validation/FinishActions")
local Integrity = require("KnoxBuildworks/Network/Integrity")
local EntityCompat = require("KnoxBuildworks/Entity/EntityCompat")
local KBWB41 = require("KnoxBuildworks/Compat/B41")

local BuildFromPlan = {}

local pendingChecks = {}

local function wallCoveringAction(definition, stage)
    if not definition or ((definition.placement or {}).kind ~= "wallCovering") then return nil end
    local compat = EntityCompat.metadata(stage)
    local config = compat.wallCoveringConfig or {}
    return config.type or (definition.placement or {}).wallCoveringType
end

local function say(player, text, bad)
    if bad then
        KBWB41.halo(player, text, true)
    else
        KBWB41.halo(player, text, false)
    end
end

local function findBuiltObject(placement)
    local square = getCell():getGridSquare(placement.x, placement.y, placement.z)
    if not square then return nil end
    local definition = Blueprints.resolvePlacement(placement)
    local isWall = definition and (definition.placement or {}).kind == "wall"
    local direction = tonumber(placement.direction) or 1
    if isWall then direction = (direction == 2 or direction == 4) and 2 or 1 end
    local expectedNorth = direction == 2 or direction == 4
    local function matches(object, data)
        if not data or not data.KBW or data.KBW.buildableId ~= placement.buildableId then return false end
        if data.KBW.stageId ~= placement.stageId then return false end
        if data.KBW.direction ~= nil then return tonumber(data.KBW.direction) == direction end
        if isWall and object.getNorth then return object:getNorth() == expectedNorth end
        return true
    end
    for i = 0, square:getSpecialObjects():size() - 1 do
        local object = square:getSpecialObjects():get(i)
        local data = object:getModData()
        if matches(object, data) then return object end
    end
    for i = 0, square:getObjects():size() - 1 do
        local object = square:getObjects():get(i)
        local data = object:getModData()
        if matches(object, data) then return object end
    end
    return nil
end

local function squareHasBuilt(placement)
    return findBuiltObject(placement) ~= nil
end

local function onTick()
    local remaining = {}
    local now = getTimestampMs()
    for index = 1, #pendingChecks do
        local check = pendingChecks[index]
        local complete = false
        if check.expectedSprite then
            local target = check.target
            if not target or not target:getSquare() then target = findBuiltObject(check.placement) end
            local sprite = target and target:getSprite() or nil
            complete = sprite ~= nil and sprite:getName() == check.expectedSprite
        else
            complete = squareHasBuilt(check.placement)
        end
        if complete then
            Blueprints.removePlacement(check.player, check.blueprintId, check.placement.id, true)
            if check.onBuilt then check.onBuilt(check.placement) end
        elseif now < check.deadline then
            remaining[#remaining + 1] = check
        end
    end
    pendingChecks = remaining
    if #pendingChecks == 0 then KBWB41.removeEvent("OnTick", onTick) end
end

local function watchPlacement(player, blueprintId, placement, onBuilt, expectedSprite)
    if #pendingChecks == 0 then KBWB41.addEvent("OnTick", onTick) end
    pendingChecks[#pendingChecks + 1] = {
        player = player,
        blueprintId = blueprintId,
        placement = placement,
        onBuilt = onBuilt,
        expectedSprite = expectedSprite,
        deadline = getTimestampMs() + (expectedSprite and 30000 or 15000)
    }
end

local function watchFinish(player, blueprintId, placement, target, expectedSprite, onBuilt)
    if #pendingChecks == 0 then KBWB41.addEvent("OnTick", onTick) end
    pendingChecks[#pendingChecks + 1] = {
        player = player,
        blueprintId = blueprintId,
        placement = placement,
        target = target,
        expectedSprite = expectedSprite,
        onBuilt = onBuilt,
        deadline = getTimestampMs() + 30000
    }
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

local function transfer(player, item)
    if item then
        ISWorldObjectContextMenu.transferIfNeeded(player, item)
    end
end

local function queueWallCovering(player, blueprintId, blueprint, placement, definition, stage, onBuilt)
    if not Blueprints.canBuild(player, blueprint) then return false, "no build access on blueprint" end
    local prepared, prepareReason = Blueprints.prepareFinishPlacement(player, blueprint, placement)
    if not prepared then return false, prepareReason end
    local target = Blueprints.findFinishObject(placement)
    if not target then return false, "no compatible wall on this edge" end
    local requirements = Requirements.evaluate(
        player, definition, stage, target and target:getSquare() or nil, placement.inputChoices
    )
    if not requirements.ok then return false, "finish requirements not met" end
    local action = wallCoveringAction(definition, stage)
    local valid, validReason = FinishActions.validate(player, definition, stage, placement.finish, true)
    if not valid then return false, validReason end
    local mode = WallFinishes.actionMode(action)
    local wallType = WallFinishes.objectWallType(target)
    local north = WallFinishes.objectNorth(target)
    local currentSprite = target:getSprite()
    local baseSprite = currentSprite and currentSprite:getName() or nil
    local sprite = WallFinishes.spriteForWallType(mode, placement.finish, north, wallType, baseSprite)
    if not sprite then return false, "finish sprite is unavailable for target wall" end
    local inventory = player:getInventory()
    local item = nil
    local tool = nil
    local paintCans = nil
    if not (player.isBuildCheat and player:isBuildCheat()) then
        if mode == "plaster" then
            tool = KBWB41.findFinishItem(inventory, "plastertrowel", predicateNotBroken)
            item = KBWB41.findFinishItem(inventory, "plasterbucket", predicateEnoughDrain)
            transfer(player, tool)
            transfer(player, item)
        elseif mode == "paint" then
            tool = KBWB41.findFinishItem(inventory, "paintbrush", predicateNotBroken)
            paintCans = WallFinishes.paintItemsIn(inventory, placement.finish and placement.finish.paintType)
            item = paintCans and paintCans[1] and paintCans[1].item or nil
            transfer(player, tool)
            for canIndex = 1, #(paintCans or {}) do
                transfer(player, paintCans[canIndex].item)
            end
        elseif mode == "wallpaper" then
            tool = KBWB41.findFinishItem(inventory, "paintbrush", predicateNotBroken)
            item = inventory:getFirstTypeRecurse(placement.finish and placement.finish.wallpaperType)
            local paste = inventory:getFirstTagEvalRecurse("WallpaperPaste", predicateEnoughDrain)
            local scissors = inventory:getFirstTagEvalRecurse("Scissors", predicateNotBroken)
            transfer(player, tool)
            transfer(player, item)
            transfer(player, paste)
            transfer(player, scissors)
        end
    end
    local square = target:getSquare()
    if not square or not luautils.walkAdjWall(player, square, north) then return false, "cannot reach wall face" end
    local KBWFinishAction = require("KnoxBuildworks/TimedActions/KBWFinishAction")
    ISTimedActionQueue.add(
        KBWFinishAction:new(
            player, mode, target, sprite, item, mode == "plaster" and tool or nil, blueprintId, placement.id,
            placement.finish, nil, paintCans
        )
    )
    watchFinish(player, blueprintId, placement, target, sprite, onBuilt)
    return true
end

function BuildFromPlan.queue(player, blueprintId, placement, onBuilt)
    if not placement then return false, "no placement" end
    if not Integrity.isAllowed(player) then
        say(player, getText("IGUI_KBW_CannotBuild"), true)
        return false, "integrity mismatch"
    end
    if ISBuildMenu and player and player.isBuildCheat then ISBuildMenu.cheat = player:isBuildCheat() end
    local blueprint = Blueprints.get(player, blueprintId)
    local definition, stage = Blueprints.resolvePlacement(placement)
    if not blueprint or not definition or not stage then return false, "unknown blueprint or placement" end
    if (definition.placement or {}).kind == "wallCovering" then
        local ok, reason = queueWallCovering(player, blueprintId, blueprint, placement, definition, stage, onBuilt)
        if not ok then
            say(player, getText("IGUI_KBW_PlanBuildBlocked") .. " - " .. Blueprints.finishErrorText(reason), true)
        end
        return ok, reason
    end
    local cursor = KBWBuildingObject:new(
        player, placement.buildableId, placement.stageId, placement.variantId, placement.materialId,
        tonumber(placement.direction) or 1, placement.inputChoices
    )
    if cursor.blockBuild then
        say(player, getText("IGUI_KBW_CannotBuild"), true)
        return false, "unknown buildable/stage/variant/material"
    end
    cursor.finish = placement.finish
    cursor.blueprintId = blueprintId
    cursor.dragNilAfterPlace = false
    cursor.blockAfterPlace = false
    cursor:getSprite()
    cursor:ensureSquaresExist(placement.x, placement.y, placement.z)
    local square = getCell():getGridSquare(placement.x, placement.y, placement.z)
    local ok, reason = Placement.validate(cursor, square)
    if not ok then
        say(player, getText("IGUI_KBW_PlanBuildBlocked") .. " - " .. Placement.reasonText(reason), true)
        return false, reason
    end
    if not Requirements.evaluate(player, cursor.definition, cursor.stage, square, cursor.inputChoices).ok then
        say(player, getText("IGUI_KBW_CannotBuild"), true)
        return false, "requirements not met"
    end
    if WallFinishes.isWallFinish(placement.finish)
        and WallFinishes.validateItems(player, placement.finish, cursor.definition, cursor.stage) ~= true then
        say(player, getText("IGUI_KBW_CannotBuild"), true)
        return false, "finish materials missing"
    end
    cursor:tryBuild(placement.x, placement.y, placement.z)
    local expectedSprite = nil
    if WallFinishes.isWallFinish(placement.finish) then
        local direction = tonumber(placement.direction) or 1
        local north = direction == 2 or direction == 4
        local face = north and "N" or "W"
        local baseSprite = (stage.sprites or {})[face]
        expectedSprite = WallFinishes.previewSprite(placement.finish, north, definition, stage, baseSprite)
    end
    watchPlacement(player, blueprintId, placement, onBuilt, expectedSprite)
    return true
end

return BuildFromPlan
