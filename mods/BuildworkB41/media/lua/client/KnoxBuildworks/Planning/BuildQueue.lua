require "TimedActions/ISInventoryTransferAction"
require "TimedActions/ISGrabItemAction"
require "ISUI/ISWorldObjectContextMenu"

local KBW = require("KnoxBuildworks/Core")
local Blueprints = require("KnoxBuildworks/Planning/Blueprints")
local BuildFromPlan = require("KnoxBuildworks/Planning/BuildFromPlan")
local Requirements = require("KnoxBuildworks/Validation/Requirements")
local Placement = require("KnoxBuildworks/Validation/Placement")
local WallFinishes = require("KnoxBuildworks/Validation/WallFinishes")
local BlueprintFiles = require("KnoxBuildworks/Planning/BlueprintFiles")
local EntityCompat = require("KnoxBuildworks/Entity/EntityCompat")
local KBWB41 = require("KnoxBuildworks/Compat/B41")

local BuildQueue = {}
local active = nil

local FETCH_LOOKAHEAD = 4
local PREPARE_PER_TICK = 12

local function placementKey(placement)
    return tostring(placement.id or placement)
end

local function say(player, text, bad)
    if bad then
        KBWB41.halo(player, text, true)
    else
        KBWB41.halo(player, text, false)
    end
end

local function hasBuildCheat(player)
    return player and player.isBuildCheat and player:isBuildCheat()
end

local function placementTier(placement)
    local definition, stage = Blueprints.resolvePlacement(placement)
    local kindRank = 3
    local kind = definition and (definition.placement or {}).kind or nil
    if kind == "floor" then
        kindRank = 1
    elseif kind == "wall" then
        kindRank = 2
    elseif kind == "wallCovering" then
        local compat = EntityCompat.metadata(stage)
        local config = compat.wallCoveringConfig or {}
        local action = config.type or (definition.placement or {}).wallCoveringType
        kindRank = WallFinishes.actionMode(action) == "plaster" and 20 or 21
    end
    if Placement.previousStageOf(stage) or Placement.optionalReplacementStageOf(stage) then
        kindRank = kindRank + 6
    end
    if Blueprints.requiresFrame(placement) then kindRank = kindRank + 6 end
    return (tonumber(placement.z) or 0) * 100 + kindRank
end

local function takeNextPlacement(state)
    local remaining = state.remaining
    if #remaining == 0 then return nil end
    local px, py, pz = state.player:getX(), state.player:getY(), state.player:getZ()
    local bestIndex, bestTier, bestDistance
    for index = 1, #remaining do
        local placement = remaining[index]
        local tier = state.tiers[placementKey(placement)] or placementTier(placement)
        local dx = (tonumber(placement.x) or 0) + 0.5 - px
        local dy = (tonumber(placement.y) or 0) + 0.5 - py
        local dz = math.abs((tonumber(placement.z) or 0) - pz)
        local distance = dx * dx + dy * dy + dz * 400
        if not bestIndex or tier < bestTier or (tier == bestTier and distance < bestDistance) then
            bestIndex, bestTier, bestDistance = index, tier, distance
        end
    end
    return table.remove(remaining, bestIndex)
end

local function prepareTiers(state)
    local processed = 0
    while state.prepareIndex <= #state.remaining and processed < PREPARE_PER_TICK do
        local placement = state.remaining[state.prepareIndex]
        state.tiers[placementKey(placement)] = placementTier(placement)
        state.prepareIndex = state.prepareIndex + 1
        processed = processed + 1
    end
    if state.prepareIndex > #state.remaining then state.phase = "select" end
end

local function normalizeTagName(name)
    if not name then return nil end
    local value = tostring(name)
    if not string.find(value, ":", 1, true) then
        local dotIndex = string.find(value, ".", 1, true)
        if dotIndex then
            local namespace = string.sub(value, 1, dotIndex - 1)
            local path = string.sub(value, dotIndex + 1)
            if namespace ~= "" and path ~= "" and not string.find(path, ".", 1, true) then
                value = namespace .. ":" .. path
            end
        end
    end
    return value
end

local function tagValue(name)
    local normalized = normalizeTagName(name)
    if normalized then return KBWB41.tagName(normalized) end
    return nil
end

local function addContainer(containers, seen, container)
    if not container then return end
    local key = tostring(container)
    if seen[key] then return end
    seen[key] = true
    containers[#containers + 1] = container
end

local function addOpenContainers(containers, seen, player)
    local available = ISInventoryPaneContextMenu.getContainers(player)
    if not available then return end
    local inventory = player:getInventory()
    for containerIndex = 0, available:size() - 1 do
        local container = available:get(containerIndex)
        if container and container ~= inventory then addContainer(containers, seen, container) end
    end
end

local function gatherContainers(area, player)
    local containers = {}
    local seen = {}
    if not area then
        addOpenContainers(containers, seen, player)
        return containers
    end
    local z = tonumber(area.z) or 0
    local seenVehicles = {}
    for x = area.x1, area.x2 do
        for y = area.y1, area.y2 do
            local square = getCell():getGridSquare(x, y, z)
            if square then
                for objectIndex = 0, square:getObjects():size() - 1 do
                    local object = square:getObjects():get(objectIndex)
                    if object and object.getContainer and object:getContainer() then
                        addContainer(containers, seen, object:getContainer())
                    end
                end
                local vehicle = square:getVehicleContainer()
                if vehicle and vehicle.getPartCount and not seenVehicles[tostring(vehicle)] then
                    seenVehicles[tostring(vehicle)] = true
                    for partIndex = 0, vehicle:getPartCount() - 1 do
                        local part = vehicle:getPartByIndex(partIndex)
                        if part and part:getItemContainer() then
                            addContainer(containers, seen, part:getItemContainer())
                        end
                    end
                elseif vehicle and vehicle.getItems then
                    addContainer(containers, seen, vehicle)
                end
            end
        end
    end
    return containers
end

local function gatherWorldItems(area)
    local result = {}
    local seen = {}
    if not area then return result end
    local z = tonumber(area.z) or 0
    for x = area.x1, area.x2 do
        for y = area.y1, area.y2 do
            local square = getCell():getGridSquare(x, y, z)
            local objects = square and square:getWorldObjects() or nil
            if objects then
                for objectIndex = 0, objects:size() - 1 do
                    local worldItem = objects:get(objectIndex)
                    local item = worldItem and worldItem.getItem and worldItem:getItem() or nil
                    local key = worldItem and tostring(worldItem) or nil
                    if item and key and not seen[key] then
                        seen[key] = true
                        result[#result + 1] = worldItem
                    end
                end
            end
        end
    end
    return result
end

local function itemMatchesRow(item, row)
    if not item then return false end
    local fullType = item:getFullType()
    if row.selectedFullType and row.selectedFullType ~= "" and fullType ~= row.selectedFullType then
        return false
    end
    if row.matchTag and item.hasTag and item:hasTag(row.matchTag) then return true end
    local possible = row.possibleItems or {}
    for itemIndex = 1, #possible do
        if possible[itemIndex] == fullType then return true end
    end
    local tags = row.possibleTags or {}
    for tagIndex = 1, #tags do
        local tag = tagValue(tags[tagIndex])
        if tag and item.hasTag and item:hasTag(tag) then return true end
    end
    return false
end

local function itemAmount(item, row)
    if row.mode == "drain" and instanceof(item, "DrainableComboItem") then
        return math.max(1, KBWB41.usesLeft(item))
    end
    return 1
end

local function addTransfersForRow(transfers, usedItems, container, row)
    local missing = (row.needed or 1) - (row.available or 0)
    if missing <= 0 then return end
    local items = container:getItems()
    for itemIndex = 0, items:size() - 1 do
        if missing <= 0 then break end
        local item = items:get(itemIndex)
        local key = tostring(item)
        if not usedItems[key] and itemMatchesRow(item, row) then
            usedItems[key] = true
            transfers[#transfers + 1] = item
            missing = missing - itemAmount(item, row)
        end
    end
end

local function collectContainerTransfers(container, rows)
    local transfers = {}
    local usedItems = {}
    for rowIndex = 1, #rows do
        local row = rows[rowIndex]
        if row.kind == "input" and not row.ok then
            addTransfersForRow(transfers, usedItems, container, row)
        end
    end
    return transfers
end

local function collectWorldTransfers(worldItems, rows)
    local transfers = {}
    local usedItems = {}
    for rowIndex = 1, #rows do
        local row = rows[rowIndex]
        local missing = (row.needed or 1) - (row.available or 0)
        if row.kind == "input" and not row.ok and missing > 0 then
            for worldIndex = 1, #worldItems do
                if missing <= 0 then break end
                local worldItem = worldItems[worldIndex]
                local item = worldItem and worldItem.getItem and worldItem:getItem() or nil
                local key = item and tostring(item) or nil
                if key and not usedItems[key] and worldItem:getSquare() and itemMatchesRow(item, row) then
                    usedItems[key] = true
                    transfers[#transfers + 1] = worldItem
                    missing = missing - itemAmount(item, row)
                end
            end
        end
    end
    return transfers
end

local function queueWorldItemTransfer(state, worldItem, playerInv)
    local item = worldItem:getItem()
    if isClient() and ISInventoryTransferUtil and ISInventoryTransferUtil.newInventoryTransferAction then
        ISTimedActionQueue.add(
            ISInventoryTransferUtil.newInventoryTransferAction(state.player, item, item:getContainer(), playerInv)
        )
    else
        local time = ISWorldObjectContextMenu.grabItemTime(state.player, worldItem)
        ISTimedActionQueue.add(ISGrabItemAction:new(state.player, worldItem, time))
    end
end

local function canTryContainer(player, container)
    if not player or not container then return false end
    local part = container.getVehiclePart and container:getVehiclePart()
    if part and part.getVehicle then
        local vehicle = part:getVehicle()
        if player:getVehicle() and player:getVehicle() ~= vehicle then return false end
        if not player:getVehicle() and not part:getArea() then return false end
    end
    local parent = container.getParent and container:getParent()
    if parent and instanceof(parent, "BaseVehicle") and player:getVehicle() and player:getVehicle() ~= parent then
        return false
    end
    return true
end

local function missingRowsFor(state, placement, rows)
    local definition, stage = Blueprints.resolvePlacement(placement)
    if not definition or not stage then return false end
    local anyMissing = false
    local status = Requirements.evaluate(state.player, definition, stage, nil, placement.inputChoices)
    local statusRows = status.rows or {}
    for rowIndex = 1, #statusRows do
        local row = statusRows[rowIndex]
        if row.kind == "input" and not row.ok then
            rows[#rows + 1] = row
            anyMissing = true
        end
    end
    local finishRows = WallFinishes.fetchRows(state.player, placement.finish, definition, stage)
    for rowIndex = 1, #finishRows do
        local row = finishRows[rowIndex]
        if not row.ok then
            rows[#rows + 1] = row
            anyMissing = true
        end
    end
    return anyMissing
end

local function queueFetchPass(state, placement)
    if hasBuildCheat(state.player) then return 0, false end
    local rows = {}
    if not missingRowsFor(state, placement, rows) then return 0, false end
    local containers = state.gatherContainers or {}
    for lookahead = 1, math.min(FETCH_LOOKAHEAD, #state.remaining) do
        missingRowsFor(state, state.remaining[lookahead], rows)
    end
    local playerInv = state.player:getInventory()
    local worldTransfers = collectWorldTransfers(state.gatherWorldItems or {}, rows)
    if #worldTransfers > 0 then
        local firstSquare = worldTransfers[1]:getSquare()
        if firstSquare and luautils.walkAdj(state.player, firstSquare, true) then
            local queued = 0
            for transferIndex = 1, #worldTransfers do
                local worldItem = worldTransfers[transferIndex]
                if worldItem:getSquare() == firstSquare then
                    queueWorldItemTransfer(state, worldItem, playerInv)
                    queued = queued + 1
                end
            end
            if queued > 0 then return queued, false end
        end
    end
    if #containers == 0 then return 0, true end
    for containerIndex = 1, #containers do
        local container = containers[containerIndex]
        local transfers = collectContainerTransfers(container, rows)
        if #transfers > 0 and canTryContainer(state.player, container)
            and luautils.walkToContainer(container, state.playerNum) then
            for transferIndex = 1, #transfers do
                ISTimedActionQueue.add(
                    ISInventoryTransferAction:new(state.player, transfers[transferIndex], container, playerInv)
                )
            end
            return #transfers, false
        end
    end
    return 0, true
end

local function finish(state, message, bad)
    if active == state then active = nil end
    KBWB41.removeEvent("OnTick", BuildQueue.onTick)
    if state.persistenceBatch then
        state.persistenceBatch = false
        BlueprintFiles.endBatch(state.blueprintId)
        if isClient() and sendClientCommand then
            sendClientCommand(state.player, KBW.NETWORK_MODULE, "BPBuildBatchEnd", { id = state.blueprintId })
        end
    end
    say(state.player, message, bad)
    if state.onFinished then state.onFinished(state.built, state.skipped) end
end

local function scheduleNext(state)
    if active ~= state then return end
    state.current = nil
    state.phase = "select"
end

local function startPlacement(state)
    if active ~= state then return end
    local placement = takeNextPlacement(state)
    if not placement then
        if #state.retry > 0 and state.pass == 1 then
            state.remaining = state.retry
            state.retry = {}
            state.pass = 2
            state.phase = "select"
            return
        end
        local doneText = getText("IGUI_KBW_BuildQueueDone", state.built, state.skipped)
        return finish(state, doneText, state.skipped > 0)
    end
    state.current = placement
    state.fetchAttempts = 0
    state.phase = "fetch"
    local queued, starved = queueFetchPass(state, placement)
    if queued > 0 then
        state.fetchAttempts = state.fetchAttempts + 1
        state.phase = "waitFetch"
    elseif starved then
        return finish(state, getText("IGUI_KBW_BuildQueueOutOfResources"), true)
    else
        state.phase = "build"
    end
end

local function tryBuildCurrent(state)
    local placement = state.current
    state.phase = "build"
    local ok, reason = BuildFromPlan.queue(state.player, state.blueprintId, placement, function ()
        state.built = state.built + 1
        scheduleNext(state)
    end)
    if not ok then
        if reason == "requirements not met" or reason == "finish materials missing" then
            return finish(state, getText("IGUI_KBW_BuildQueueOutOfResources"), true)
        end
        state.skipped = state.skipped + 1
        if state.pass == 1 then state.retry[#state.retry + 1] = placement end
        scheduleNext(state)
        return
    end
    state.phase = "waitBuild"
    state.buildStarted = getTimestampMs()
end

function BuildQueue.onTick()
    local state = active
    if not state then
        KBWB41.removeEvent("OnTick", BuildQueue.onTick)
        return
    end
    if state.player:isDead() then return finish(state, getText("IGUI_KBW_BuildQueueStopped"), true) end
    if state.phase == "prepare" then
        prepareTiers(state)
    elseif state.phase == "waitFetch" then
        if not ISTimedActionQueue.isPlayerDoingAction(state.player) then
            local queued = 0
            local starved = false
            if state.current and (state.fetchAttempts or 0) < 80 then
                queued, starved = queueFetchPass(state, state.current)
            end
            if queued > 0 then
                state.fetchAttempts = (state.fetchAttempts or 0) + 1
            elseif starved then
                return finish(state, getText("IGUI_KBW_BuildQueueOutOfResources"), true)
            else
                tryBuildCurrent(state)
            end
        end
    elseif state.phase == "select" then
        startPlacement(state)
    elseif state.phase == "build" then
        tryBuildCurrent(state)
    elseif state.phase == "waitBuild" then
        local waitTimeout = state.current and WallFinishes.isWallFinish(state.current.finish) and 30000 or 15000
        if not ISTimedActionQueue.isPlayerDoingAction(state.player)
            and (getTimestampMs() - (state.buildStarted or 0)) > waitTimeout then
            state.skipped = state.skipped + 1
            if state.pass == 1 and state.current then state.retry[#state.retry + 1] = state.current end
            scheduleNext(state)
        end
    end
end

function BuildQueue.isRunning()
    return active ~= nil
end

function BuildQueue.stop()
    if active then finish(active, getText("IGUI_KBW_BuildQueueStopped"), true) end
end

local function startWithPlacements(player, blueprintId, placements, onFinished)
    if active then
        say(player, getText("IGUI_KBW_BuildQueueRunning"), true)
        return false, "queue already running"
    end
    if #placements == 0 then
        say(player, getText("IGUI_KBW_BuildQueueEmpty"), true)
        return false, "no placements"
    end
    local blueprint = Blueprints.get(player, blueprintId)
    active = {
        player = player,
        playerNum = player:getPlayerNum(),
        blueprintId = blueprintId,
        gatherArea = blueprint and blueprint.gatherArea or nil,
        remaining = placements,
        retry = {},
        pass = 1,
        built = 0,
        skipped = 0,
        onFinished = onFinished,
        tiers = {},
        prepareIndex = 1
    }
    active.gatherContainers = gatherContainers(active.gatherArea, player)
    active.gatherWorldItems = gatherWorldItems(active.gatherArea)
    BlueprintFiles.beginBatch(blueprintId)
    if isClient() and sendClientCommand then
        sendClientCommand(player, KBW.NETWORK_MODULE, "BPBuildBatchStart", { id = blueprintId })
    end
    active.persistenceBatch = true
    KBWB41.addEvent("OnTick", BuildQueue.onTick)
    say(player, getText("IGUI_KBW_BuildQueueStarted"))
    active.phase = "prepare"
    return true
end

function BuildQueue.startSelected(player, blueprintId, placement, onFinished)
    if not placement then return false, "no placement" end
    return startWithPlacements(player, blueprintId, { placement }, onFinished)
end

function BuildQueue.start(player, blueprintId, onFinished)
    local blueprint = Blueprints.get(player, blueprintId)
    if not blueprint then return false, "no blueprint" end
    local placements = {}
    local source = blueprint.placements or {}
    for placementIndex = 1, #source do
        placements[#placements + 1] = source[placementIndex]
    end
    return startWithPlacements(player, blueprintId, placements, onFinished)
end

return BuildQueue
