require "ISUI/ISPanel"

local Blueprints = require("KnoxBuildworks/Planning/Blueprints")
local GhostRenderer = require("KnoxBuildworks/Planning/GhostRenderer")
local PlanCursor = require("KnoxBuildworks/Planning/PlanCursor")
local BuildQueue = require("KnoxBuildworks/Planning/BuildQueue")
local Requirements = require("KnoxBuildworks/Validation/Requirements")
local Registry = require("KnoxBuildworks/Definitions/Registry")
local Theme = require("KnoxBuildworks/UI/Theme")
local I18n = require("KnoxBuildworks/I18n")
local KBWB41 = require("KnoxBuildworks/Compat/B41")

local BuildPlanCursor = {}

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)

local function floorInt(value)
    return math.floor(tonumber(value) or 0)
end

local function placementLabel(placement)
    local definition = Registry:get(placement.buildableId)
    if not definition then return tostring(placement.buildableId) end
    return I18n.definitionName(definition)
end

local function itemName(fullType)
    if getItemNameFromFullType then return getItemNameFromFullType(fullType) end
    local item = getScriptManager() and getScriptManager():getItem(fullType)
    if item then return item:getDisplayName() end
    return tostring(fullType)
end

local function rowItemType(row)
    if row.selectedFullType then return row.selectedFullType end
    local availableItems = row.availableItems or {}
    for itemIndex = 1, #availableItems do
        local entry = availableItems[itemIndex]
        if (entry.available or 0) > 0 then return entry.fullType end
    end
    return (row.possibleItems or {})[1]
end

local function rowLabel(row)
    local displayType = rowItemType(row)
    if displayType then return itemName(displayType) end
    if row.labelKey and row.labelKey ~= "" then return I18n.text(row.labelKey, row.label) end
    if row.label and row.label ~= "" then
        local translated = getText(row.label)
        if translated ~= row.label then return translated end
        return row.label
    end
    if row.name then return tostring(row.name) end
    local tags = row.possibleTags or {}
    if tags[1] then return "#" .. tostring(tags[1]) end
    return tostring(row.id or "?")
end

KBWBuildPlanTooltip = ISPanel:derive("KBWBuildPlanTooltip")

function KBWBuildPlanTooltip:new()
    local o = ISPanel:new(0, 0, 240, 60)
    setmetatable(o, self)
    self.__index = self
    o.background = true
    o.backgroundColor = { r = Theme.backdrop.r, g = Theme.backdrop.g, b = Theme.backdrop.b, a = 0.92 }
    o.borderColor = Theme.border
    o.lines = {}
    return o
end

local TOOLTIP_MAX_TEXT = 334

local function wrapTooltipLine(manager, line, out)
    local text = tostring(line.text or "")
    local maxWidth = TOOLTIP_MAX_TEXT - (line.indent and 26 or 12)
    if manager:MeasureStringX(UIFont.Small, text) <= maxWidth then
        out[#out + 1] = line
        return
    end
    local current = ""
    for word in string.gmatch(text, "%S+") do
        local candidate = current == "" and word or (current .. " " .. word)
        if current ~= "" and manager:MeasureStringX(UIFont.Small, candidate) > maxWidth then
            out[#out + 1] = { text = current, color = line.color, indent = line.indent, header = line.header }
            current = word
        else
            current = candidate
        end
    end
    if current ~= "" then
        out[#out + 1] = { text = current, color = line.color, indent = line.indent, header = line.header }
    end
end

function KBWBuildPlanTooltip:setLines(lines)
    local manager = getTextManager()
    local wrapped = {}
    for lineIndex = 1, #(lines or {}) do
        wrapTooltipLine(manager, lines[lineIndex], wrapped)
    end
    self.lines = wrapped
    local width = 160
    for lineIndex = 1, #self.lines do
        local line = self.lines[lineIndex]
        local w = manager:MeasureStringX(UIFont.Small, line.text or "") + (line.indent and 26 or 12)
        if w > width then width = w end
    end
    self:setWidth(math.min(360, width + 8))
    self:setHeight(#self.lines * (FONT_HGT_SMALL + 2) + 10)
end

function KBWBuildPlanTooltip:prerender()
    ISPanel.prerender(self)
    local y = 5
    for lineIndex = 1, #self.lines do
        local line = self.lines[lineIndex]
        local color = line.color or Theme.text
        self:drawText(line.text or "", line.indent and 22 or 8, y, color.r, color.g, color.b, 1, UIFont.Small)
        y = y + FONT_HGT_SMALL + 2
    end
end

local function defineClass()
    KBWBuildPlanCursor = ISBuildingObject:derive("KBWBuildPlanCursor")

    function KBWBuildPlanCursor:new(player, blueprintId, onBuilt)
        local o = {}
        setmetatable(o, self)
        self.__index = self
        o:init()
        o.character = player
        o.player = player:getPlayerNum()
        o.onBuilt = onBuilt
        o.skipBuildAction = true
        o.dragNilAfterPlace = false
        local blueprint = Blueprints.get(player, blueprintId) or Blueprints.activeOrCreate(player)
        o.blueprintId = blueprint.id
        o.planZ = floorInt(blueprint.level ~= nil and blueprint.level or player:getZ())
        o.cycleIndex = 1
        o.statusCache = {}
        return o
    end

    function KBWBuildPlanCursor:walkTo(x, y, z)
        return true
    end

    function KBWBuildPlanCursor:haveMaterial(square)
        return true
    end

    function KBWBuildPlanCursor:rotateMouse(x, y)
    end

    function KBWBuildPlanCursor:rotateKey(key)
        if KBWB41.isKey("Rotate building", key) then
            self.cycleIndex = self.cycleIndex + 1
            local targets = self.targets or {}
            if self.cycleIndex > math.max(1, #targets) then self.cycleIndex = 1 end
        end
    end

    function KBWBuildPlanCursor:getSprite()
        return nil
    end

    function KBWBuildPlanCursor:isValid(square)
        return self.targets ~= nil and #self.targets > 0
    end

    function KBWBuildPlanCursor:statusFor(placement)
        local now = getTimestampMs()
        local cached = self.statusCache[placement.id]
        if cached and (now - cached.time) < 900 then return cached.status end
        local definition, stage = Blueprints.resolvePlacement(placement)
        local status = nil
        if definition and stage then
            status = Requirements.evaluate(self.character, definition, stage, nil, placement.inputChoices)
        end
        self.statusCache[placement.id] = { status = status, time = now }
        return status
    end

    function KBWBuildPlanCursor:ensureTooltip()
        if not self.tooltip then
            self.tooltip = KBWBuildPlanTooltip:new()
            self.tooltip:initialise()
            self.tooltip:addToUIManager()
        end
        return self.tooltip
    end

    function KBWBuildPlanCursor:removeTooltip()
        if self.tooltip then
            self.tooltip:setVisible(false)
            self.tooltip:removeFromUIManager()
            self.tooltip = nil
        end
    end

    function KBWBuildPlanCursor:deactivate()
        self:removeTooltip()
    end

    function KBWBuildPlanCursor:tooltipLines()
        local lines = {}
        local targets = self.targets or {}
        for targetIndex = 1, #targets do
            local placement = targets[targetIndex]
            local chosen = targetIndex == self.cycleIndex
            local status = self:statusFor(placement)
            local headerColor = chosen and Theme.accent or Theme.textMuted
            local marker = chosen and "> " or "  "
            local ready = status and status.ok
            lines[#lines + 1] = {
                text = marker .. placementLabel(placement)
                    .. (ready and ("  [" .. getText("IGUI_KBW_Ready") .. "]") or ""),
                color = headerColor,
                header = true
            }
            if chosen and status then
                local rows = status.rows or {}
                for rowIndex = 1, #rows do
                    local row = rows[rowIndex]
                    local text
                    if row.kind == "skill" then
                        text = tostring(row.name) .. "  " .. tostring(row.available) .. "/" .. tostring(row.needed)
                    elseif row.kind == "knowledge" then
                        text = tostring(row.name)
                    else
                        text = rowLabel(row) .. "  " .. tostring(row.available or 0) .. "/" .. tostring(row.needed or 1)
                    end
                    lines[#lines + 1] = { text = text, color = row.ok and Theme.good or Theme.bad, indent = true }
                end
            end
        end
        if #targets > 1 then
            lines[#lines + 1] = { text = getText("IGUI_KBW_CyclePlansHint"), color = Theme.textMuted }
        end
        return lines
    end

    function KBWBuildPlanCursor:render(x, y, z, square)
        local blueprint = Blueprints.get(self.character, self.blueprintId)
        if blueprint and blueprint.level ~= nil then self.planZ = floorInt(blueprint.level) end
        self.currentX, self.currentY = PlanCursor.pickTileAt(self.player, self.planZ)
        local key = self.currentX .. "|" .. self.currentY .. "|" .. self.planZ
        if self.targetKey ~= key then
            self.targetKey = key
            self.cycleIndex = 1
            local blueprint = Blueprints.get(self.character, self.blueprintId)
            self.targets = blueprint and Blueprints.placementsAt(blueprint, self.currentX, self.currentY, self.planZ)
                or {}
        end
        local targets = self.targets or {}
        self.canBeBuild = #targets > 0
        local color = #targets > 0 and GhostRenderer.PLAN_COLOR or GhostRenderer.PLAN_COLOR_DIM
        GhostRenderer.renderTileHighlight(self.currentX, self.currentY, self.planZ, color, 0.55, self.player)
        local chosen = targets[math.min(self.cycleIndex, #targets)]
        if chosen then
            GhostRenderer.renderPlacementLayerAll(chosen, GhostRenderer.HIGHLIGHT_COLOR)
        end
        if #targets > 0 then
            local tooltip = self:ensureTooltip()
            tooltip:setLines(self:tooltipLines())
            local mouseX = getMouseX() + 24
            local mouseY = getMouseY() + 12
            local screenW = getPlayerScreenLeft(self.player) + getPlayerScreenWidth(self.player)
            local screenH = getPlayerScreenTop(self.player) + getPlayerScreenHeight(self.player)
            if mouseX + tooltip.width > screenW then mouseX = screenW - tooltip.width - 4 end
            if mouseY + tooltip.height > screenH then mouseY = mouseY - tooltip.height - 28 end
            tooltip:setX(mouseX)
            tooltip:setY(mouseY)
            tooltip:setVisible(true)
            tooltip:bringToTop()
        elseif self.tooltip then
            self.tooltip:setVisible(false)
        end
    end

    function KBWBuildPlanCursor:create(x, y, z, north, sprite)
        local targets = self.targets or {}
        local chosen = targets[math.min(self.cycleIndex, math.max(1, #targets))]
        if not chosen then return end
        local owner = self
        BuildQueue.startSelected(self.character, self.blueprintId, chosen, function ()
            owner.targetKey = nil
            owner.statusCache = {}
            if owner.onBuilt then owner.onBuilt(chosen) end
        end)
    end
end

KBWB41.addEvent("OnGameStart", defineClass)

function BuildPlanCursor.new(player, blueprintId, onBuilt)
    return KBWBuildPlanCursor:new(player, blueprintId, onBuilt)
end

return BuildPlanCursor
