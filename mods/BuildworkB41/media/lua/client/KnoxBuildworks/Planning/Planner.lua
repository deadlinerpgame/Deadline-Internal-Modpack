local Blueprints = require("KnoxBuildworks/Planning/Blueprints")
local GhostRenderer = require("KnoxBuildworks/Planning/GhostRenderer")
local PlanCursor = require("KnoxBuildworks/Planning/PlanCursor")
local RoomCursor = require("KnoxBuildworks/Planning/RoomCursor")
local EraseCursor = require("KnoxBuildworks/Planning/EraseCursor")
local BuildPlanCursor = require("KnoxBuildworks/Planning/BuildPlanCursor")
local GatherAreaCursor = require("KnoxBuildworks/Planning/GatherAreaCursor")
local MoveBlueprintCursor = require("KnoxBuildworks/Planning/MoveBlueprintCursor")
local KBWB41 = require("KnoxBuildworks/Compat/B41")

local Planner = { highlightPlacementId = nil, highlightRoomId = nil }

function Planner.begin(player, buildableId, stageId, variantId, materialId, direction, finish)
    local cursor = PlanCursor.new(player, buildableId, stageId, variantId, materialId, direction or 1, finish)
    getCell():setDrag(cursor, player:getPlayerNum())
    return cursor
end

function Planner.beginRoom(player, blueprintId, roomTemplate, onRoomAdded)
    local cursor = RoomCursor.new(player, blueprintId, roomTemplate, onRoomAdded)
    getCell():setDrag(cursor, player:getPlayerNum())
    return cursor
end

function Planner.beginErase(player, blueprintId, onErased, mode)
    local cursor = EraseCursor.new(player, blueprintId, onErased, mode)
    getCell():setDrag(cursor, player:getPlayerNum())
    return cursor
end

function Planner.beginBuildTool(player, blueprintId, onBuilt)
    local cursor = BuildPlanCursor.new(player, blueprintId, onBuilt)
    getCell():setDrag(cursor, player:getPlayerNum())
    return cursor
end

function Planner.beginGatherArea(player, blueprintId, onAreaSet)
    local cursor = GatherAreaCursor.new(player, blueprintId, onAreaSet)
    getCell():setDrag(cursor, player:getPlayerNum())
    return cursor
end

function Planner.beginMoveBlueprint(player, blueprintId, onMoved)
    local cursor = MoveBlueprintCursor.new(player, blueprintId, onMoved)
    getCell():setDrag(cursor, player:getPlayerNum())
    return cursor
end

function Planner.cancelCursor(player)
    local playerNum = player and player:getPlayerNum() or 0
    local drag = getCell():getDrag(playerNum)
    if drag
        and (drag.Type == "KBWPlanCursor" or drag.Type == "KBWRoomCursor" or drag.Type == "KBWEraseCursor"
            or drag.Type == "KBWBuildPlanCursor" or drag.Type == "KBWGatherAreaCursor"
            or drag.Type == "KBWMoveBlueprintCursor") then
        getCell():setDrag(nil, playerNum)
    end
end

function Planner.setHighlight(placementId)
    Planner.highlightPlacementId = placementId
end

function Planner.setHighlightRoom(roomId)
    Planner.highlightRoomId = roomId
end

function Planner.renderWorldPreview(playerIndex, x, y, z, square)
    local player = getSpecificPlayer(playerIndex or 0) or getPlayer()
    if not player then return end
    local activeBlueprint = Blueprints.active(player)
    if not activeBlueprint then
        Planner.highlightPlacementId = nil
        Planner.highlightRoomId = nil
        return
    end
    local activeLevel = tonumber(activeBlueprint.level) or math.floor(player:getZ())
    GhostRenderer.renderBlueprint(
        activeBlueprint, activeLevel, Planner.highlightPlacementId, Planner.highlightRoomId, playerIndex
    )
    if activeBlueprint.anchored and activeBlueprint.anchor then
        local radius = tonumber(activeBlueprint.radius) or 200
        GhostRenderer.renderRectBorder(
            activeBlueprint.anchor.x - radius, activeBlueprint.anchor.y - radius, activeBlueprint.anchor.x + radius,
            activeBlueprint.anchor.y + radius, activeLevel, GhostRenderer.RANGE_COLOR, playerIndex
        )
    end
end

KBWB41.addEvent("OnPostRender", Planner.renderWorldPreview)

return Planner
