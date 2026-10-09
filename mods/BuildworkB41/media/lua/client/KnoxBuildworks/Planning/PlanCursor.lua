local Blueprints = require("KnoxBuildworks/Planning/Blueprints")
local GhostRenderer = require("KnoxBuildworks/Planning/GhostRenderer")
local Matrix = require("KnoxBuildworks/Geometry/Matrix")
local Placement = require("KnoxBuildworks/Validation/Placement")
local Theme = require("KnoxBuildworks/UI/Theme")
local KBWB41 = require("KnoxBuildworks/Compat/B41")

local PlanCursor = {}

local function floorInt(value)
    return math.floor(tonumber(value) or 0)
end

local function stepToward(fromValue, toValue)
    if toValue > fromValue then return 1 end
    if toValue < fromValue then return -1 end
    return 0
end

local function wallEdgeDirection(direction)
    direction = tonumber(direction) or 1
    return (direction == 2 or direction == 4) and 2 or 1
end

local function finishItemType(itemType)
    if not itemType then return nil end
    local WallFinishes = require("KnoxBuildworks/Validation/WallFinishes")
    local parts = WallFinishes.paintComponents(itemType)
    local value = tostring(#parts > 0 and parts[1].item or itemType)
    if string.find(value, ".", 1, true) then return value end
    return "Base." .. value
end

local function nonEmpty(map)
    for _ in pairs(map or {}) do
        return map
    end
    return nil
end

local function applyFinishChoices(cursor)
    local finish = cursor.finish
    if type(finish) ~= "table" then return end
    local inputs = ((cursor.stage or {}).requirements or {}).inputs or {}
    for inputIndex = 1, #inputs do
        local input = inputs[inputIndex]
        local tags = input.tags or {}
        for tagIndex = 1, #tags do
            local tag = string.lower(tostring(tags[tagIndex]))
            if finish.paintType and tag == "base:paint" then
                cursor.inputChoices[input.id or ("input-" .. inputIndex)] = finishItemType(finish.paintType)
            elseif finish.wallpaperType and tag == "base:wallpaper" then
                cursor.inputChoices[input.id or ("input-" .. inputIndex)] = finishItemType(finish.wallpaperType)
            end
        end
    end
end

local function dragKind(definition, stage, direction)
    local kind = ((definition or {}).placement or {}).kind
    if kind ~= "wall" and kind ~= "wallCovering" and kind ~= "floor" then return nil end
    local cells = Matrix.getFaceCells(stage, direction or 1)
    if cells then
        local active = 0
        for cellIndex = 1, #cells do
            local cell = cells[cellIndex]
            if cell.sprite or cell.blocks then active = active + 1 end
            if active > 1 then return nil end
        end
        local bounds = Matrix.getBounds(cells)
        if (bounds.width or 1) > 1 or (bounds.height or 1) > 1 or (bounds.depth or 1) > 1 then return nil end
    end
    if kind == "floor" then return "rect" end
    return "line"
end

local function scaledAlpha(color, fallback)
    local opacity = GhostRenderer.opacity or 0.14
    local alpha = (color and color.a or fallback or 0.24) * (opacity / 0.14)
    if alpha < 0.015 then return 0.015 end
    if alpha > 0.55 then return 0.55 end
    return alpha
end

local function mouseWorldAt(playerNum, z)
    return screenToIsoX(playerNum, getMouseX(), getMouseY(), z), screenToIsoY(playerNum, getMouseX(), getMouseY(), z)
end

PlanCursor.mouseWorldAt = mouseWorldAt

local function pickFloor(playerNum, buildZ)
    local player = getSpecificPlayer(playerNum)
    return player and floorInt(player:getZ()) or buildZ
end

function PlanCursor.pickTileAt(playerNum, buildZ)
    local wx, wy = mouseWorldAt(playerNum, pickFloor(playerNum, buildZ))
    return floorInt(wx), floorInt(wy)
end

local function defineClass()
    KBWPlanCursor = KBWBuildingObject:derive("KBWPlanCursor")

    function KBWPlanCursor:new(player, buildableId, stageId, variantId, materialId, direction, finish)
        local o = KBWBuildingObject.new(self, player, buildableId, stageId, variantId, materialId, direction)
        o.buildPanelLogic = nil
        o.containers = nil
        o.craftRecipeData = nil
        o.skipBuildAction = true
        o.dragNilAfterPlace = false
        o.blockAfterPlace = false
        o.finish = finish
        applyFinishChoices(o)
        o.isPlanCursor = true
        local blueprint = Blueprints.activeOrCreate(o.character)
        o.blueprintId = blueprint.id
        o.planZ = o:getPlanZ()
        o.planValid = false
        o.lineAnchorX = nil
        o.lineAnchorY = nil
        return o
    end

    function KBWPlanCursor:haveMaterial(square)
        return true
    end

    function KBWPlanCursor:walkTo(x, y, z)
        return true
    end

    function KBWPlanCursor:getPlanZ()
        local blueprint = Blueprints.get(self.character, self.blueprintId)
        local level = blueprint and blueprint.level
        if level == nil then level = self.character:getZ() end
        return floorInt(level)
    end

    function KBWPlanCursor:snapDirectionToPrevious()
        local previousStage = Placement.previousStageOf(self.stage) or Placement.optionalReplacementStageOf(self.stage)
        if not previousStage or self.planX == nil then return end
        local blueprint = Blueprints.get(self.character, self.blueprintId)
        local covering = blueprint and Blueprints.placementsAt(blueprint, self.planX, self.planY, self.planZ) or {}
        local preferredDirection = wallEdgeDirection(self.nSprite)
        for pass = 1, 2 do
            for coveringIndex = 1, #covering do
                local existing = covering[coveringIndex]
                local existingDirection = wallEdgeDirection(existing.direction)
                local directionMatches = existingDirection == preferredDirection
                if Blueprints.placementMatchesPrevious(previousStage, existing)
                    and ((pass == 1 and directionMatches) or (pass == 2 and not directionMatches)) then
                    self.nSprite = existingDirection
                    self.direction = self.nSprite
                    self:getSprite()
                    return
                end
            end
        end
        local square = getCell():getGridSquare(self.planX, self.planY, self.planZ)
        if square and self.definition then
            local previous = Placement.findPrevious(square, self.definition.id, previousStage, preferredDirection == 2)
                or Placement.findPrevious(square, self.definition.id, previousStage)
            if previous then
                self.nSprite = previous:getNorth() and 2 or 1
                self.direction = self.nSprite
                self:getSprite()
            end
        end
    end

    function KBWPlanCursor:snapDirectionToFinishTarget()
        if (((self.definition or {}).placement or {}).kind ~= "wallCovering") or self.planX == nil then return end
        local blueprint = Blueprints.get(self.character, self.blueprintId)
        if not blueprint then return end
        local current = self:candidatePlacementAt(self.planX, self.planY)
        if Blueprints.prepareFinishPlacement(self.character, blueprint, current) then return end
        local alternate = wallEdgeDirection(self.nSprite) == 1 and 2 or 1
        local candidate = self:candidatePlacementAt(self.planX, self.planY)
        candidate.direction = alternate
        if Blueprints.prepareFinishPlacement(self.character, blueprint, candidate) then
            self.nSprite = alternate
            self.direction = alternate
            self:getSprite()
        end
    end

    function KBWPlanCursor:updatePlanPosition(x, y, z)
        self.planZ = self:getPlanZ()
        self.planX, self.planY = PlanCursor.pickTileAt(self.player, self.planZ)
        self:snapDirectionToPrevious()
        self:snapDirectionToFinishTarget()
        local mode = dragKind(self.definition, self.stage, self.nSprite)
        if mode and self.isLeftDown and self.lineAnchorX == nil then
            self.lineAnchorX, self.lineAnchorY = self.planX, self.planY
        elseif not self.isLeftDown and not self.build then
            self.lineAnchorX, self.lineAnchorY = nil, nil
        elseif not mode then
            self.lineAnchorX, self.lineAnchorY = nil, nil
        end
    end

    function KBWPlanCursor:rotateMouse(x, y)
    end

    function KBWPlanCursor:candidatePlacementAt(x, y)
        local direction = self.nSprite
        local kind = ((self.definition or {}).placement or {}).kind
        if kind == "wall" or kind == "wallCovering" then
            direction = wallEdgeDirection(direction)
        end
        return {
            buildableId = self.buildableId,
            stageId = self.stage and self.stage.id or self.stageId,
            variantId = self.variantId,
            materialId = self.materialId,
            finish = self.finish,
            inputChoices = nonEmpty(self.inputChoices),
            x = x or self.planX or 0,
            y = y or self.planY or 0,
            z = self.planZ,
            direction = direction
        }
    end

    function KBWPlanCursor:candidatePlacement()
        return self:candidatePlacementAt(self.planX, self.planY)
    end

    function KBWPlanCursor:candidatePlacements()
        local candidates = {}
        local mode = dragKind(self.definition, self.stage, self.nSprite)
        if not mode then
            if self.planX ~= nil and self.planY ~= nil then
                candidates[#candidates + 1] = self:candidatePlacementAt(self.planX, self.planY)
            end
            return candidates
        end
        local startX = self.lineAnchorX or self.planX
        local startY = self.lineAnchorY or self.planY
        local endX = self.planX
        local endY = self.planY
        if startX == nil or startY == nil or endX == nil or endY == nil then return candidates end
        if mode == "rect" then
            local maxSpan = 23
            if endX > startX + maxSpan then endX = startX + maxSpan end
            if endX < startX - maxSpan then endX = startX - maxSpan end
            if endY > startY + maxSpan then endY = startY + maxSpan end
            if endY < startY - maxSpan then endY = startY - maxSpan end
            local minX, maxX = math.min(startX, endX), math.max(startX, endX)
            local minY, maxY = math.min(startY, endY), math.max(startY, endY)
            for yValue = minY, maxY do
                for xValue = minX, maxX do
                    candidates[#candidates + 1] = self:candidatePlacementAt(xValue, yValue)
                end
            end
            return candidates
        end
        local dx = endX - startX
        local dy = endY - startY
        if math.abs(dx) >= math.abs(dy) then
            local step = stepToward(startX, endX)
            if step == 0 then
                candidates[#candidates + 1] = self:candidatePlacementAt(startX, startY)
            else
                local xValue = startX
                while true do
                    candidates[#candidates + 1] = self:candidatePlacementAt(xValue, startY)
                    if xValue == endX then break end
                    xValue = xValue + step
                end
            end
        else
            local step = stepToward(startY, endY)
            if step == 0 then
                candidates[#candidates + 1] = self:candidatePlacementAt(startX, startY)
            else
                local yValue = startY
                while true do
                    candidates[#candidates + 1] = self:candidatePlacementAt(startX, yValue)
                    if yValue == endY then break end
                    yValue = yValue + step
                end
            end
        end
        return candidates
    end

    function KBWPlanCursor:isValid(square)
        if self.blockBuild or not self.definition or not self.stage then return false end
        if self.planX == nil or self.planY == nil then return false end
        local key = tostring(self.lineAnchorX) .. "|"
            .. tostring(self.lineAnchorY) .. "|"
            .. self.planX .. "|"
            .. self.planY .. "|"
            .. self.planZ .. "|"
            .. tostring(self.nSprite)
        if self.planValidKey == key and self.planValid ~= nil then return self.planValid end
        self.planValidKey = key
        self.planValid = false
        self.planInvalidReason = nil
        self.planInvalidDetail = nil
        local blueprint = Blueprints.get(self.character, self.blueprintId)
        if not blueprint then return false end
        local candidates = self:candidatePlacements()
        if #candidates == 0 then return false end
        if not Blueprints.canContribute(self.character, blueprint) then
            self.planInvalidReason = "no_permission"
            return false
        end
        if #(blueprint.placements or {}) + #candidates > Blueprints.maxPlacements() then
            self.planInvalidReason = "placement_limit"
            return false
        end
        local temporary = { placements = {} }
        local blueprintPlacements = blueprint.placements or {}
        for existingIndex = 1, #blueprintPlacements do
            temporary.placements[#temporary.placements + 1] = blueprintPlacements[existingIndex]
        end
        for candidateIndex = 1, #candidates do
            local candidate = candidates[candidateIndex]
            if blueprint.anchored and not Blueprints.withinRange(blueprint, candidate.x, candidate.y) then
                self.planInvalidReason = "out_of_range"
                return false
            end
            local finishOk, finishReason = Blueprints.prepareFinishPlacement(self.character, temporary, candidate)
            if not finishOk then
                self.planInvalidReason = "finish_target"
                self.planInvalidDetail = finishReason
                return false
            end
            local conflicts = Blueprints.findIntersections(temporary, candidate)
            if #conflicts > 0 then
                self.planInvalidReason = "plan_overlap"
                return false
            end
            if not Blueprints.hasPreviousStage(self.character, temporary, candidate) then
                if Placement.optionalReplacementStageOf(self.stage) then
                    self.planInvalidReason = "needs_wall_frame"
                else
                    self.planInvalidReason = "needs_previous_stage"
                end
                return false
            end
            if not Blueprints.hasRequiredFrame(self.character, temporary, candidate) then
                self.planInvalidReason = "needs_frame"
                return false
            end
            temporary.placements[#temporary.placements + 1] = candidate
        end
        self.planValid = true
        return self.planValid
    end

    function KBWPlanCursor:removeTooltip()
        if self.tooltip then
            self.tooltip:setVisible(false)
            self.tooltip:removeFromUIManager()
            self.tooltip = nil
        end
    end

    function KBWPlanCursor:deactivate()
        self:removeTooltip()
    end

    function KBWPlanCursor:updateReasonTooltip()
        if not self.planInvalidReason or not KBWBuildPlanTooltip then
            if self.tooltip then self.tooltip:setVisible(false) end
            return
        end
        if not self.tooltip then
            self.tooltip = KBWBuildPlanTooltip:new()
            self.tooltip:initialise()
            self.tooltip:addToUIManager()
        end
        local blueprint = Blueprints.get(self.character, self.blueprintId)
        local reason = self.planInvalidDetail and Blueprints.finishErrorText(self.planInvalidDetail)
            or Blueprints.planErrorText(self.planInvalidReason, blueprint)
        self.tooltip:setLines({ { text = reason, color = Theme.bad } })
        local mouseX = getMouseX() + 24
        local mouseY = getMouseY() + 12
        local screenW = getPlayerScreenLeft(self.player) + getPlayerScreenWidth(self.player)
        local screenH = getPlayerScreenTop(self.player) + getPlayerScreenHeight(self.player)
        if mouseX + self.tooltip.width > screenW then mouseX = screenW - self.tooltip.width - 4 end
        if mouseY + self.tooltip.height > screenH then mouseY = mouseY - self.tooltip.height - 28 end
        self.tooltip:setX(mouseX)
        self.tooltip:setY(mouseY)
        self.tooltip:setVisible(true)
        self.tooltip:bringToTop()
    end

    function KBWPlanCursor:render(x, y, z, square)
        self:updatePlanPosition(x, y, z)
        local valid = self:isValid(square)
        self.canBeBuild = valid
        self:updateReasonTooltip()
        local color = valid and GhostRenderer.PLAN_COLOR or GhostRenderer.CONFLICT_COLOR
        local alpha = scaledAlpha(color, 0.24)
        local floorSprite = GhostRenderer.getFloorCursorSprite()
        local groundZ = floorInt(self.character:getZ())
        if floorSprite and self.planX and groundZ ~= self.planZ then
            floorSprite:RenderGhostTileColor(self.planX, self.planY, groundZ, 1.0, 0.85, 0.25, 0.5)
        end
        local candidates = self:candidatePlacements()
        for candidateIndex = 1, #candidates do
            local blueprint = Blueprints.get(self.character, self.blueprintId)
            Blueprints.prepareFinishPlacement(self.character, blueprint, candidates[candidateIndex])
            local cells = GhostRenderer.placementCells(candidates[candidateIndex])
            if cells then
                for cellIndex = 1, #cells do
                    local cell = cells[cellIndex]
                    if cell.blocks and floorSprite then
                        floorSprite:RenderGhostTileColor(
                            cell.x, cell.y, cell.z, color.r, color.g, color.b, alpha * 0.72
                        )
                    end
                    if cell.sprite then
                        local sprite = GhostRenderer.getSprite(cell.sprite)
                        if sprite then
                            sprite:RenderGhostTileColor(cell.x, cell.y, cell.z, color.r, color.g, color.b, alpha)
                        end
                    end
                end
            end
        end
    end

    function KBWPlanCursor:create(x, y, z, north, sprite)
        if self.planX == nil or self.planY == nil then return end
        local candidates = self:candidatePlacements()
        local entries, lastReason = Blueprints.addPlacements(self.character, self.blueprintId, candidates)
        local added = #entries
        if added > 0 then
            Blueprints.setActive(self.character, self.blueprintId)
            GhostRenderer.clearCache()
        end
        self.planValidKey = nil
        self.lineAnchorX, self.lineAnchorY = nil, nil
        if added == 0 then
            if HaloTextHelper then
                local blueprint = Blueprints.get(self.character, self.blueprintId)
                KBWB41.halo(self.character, Blueprints.planErrorText(lastReason, blueprint), true)
            end
            return
        end
        if KBWPlanningMode and KBWPlanningMode.instance then
            KBWPlanningMode.instance:refreshBlueprints()
        end
        if HaloTextHelper then
            KBWB41.halo(self.character, getText("IGUI_KBW_PlanPlaced"), false)
        end
    end
end

KBWB41.addEvent("OnGameStart", defineClass)

function PlanCursor.new(player, buildableId, stageId, variantId, materialId, direction, finish)
    return KBWPlanCursor:new(player, buildableId, stageId, variantId, materialId, direction, finish)
end

return PlanCursor
