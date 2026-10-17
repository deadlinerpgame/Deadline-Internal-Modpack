local Blueprints = require("KnoxBuildworks/Planning/Blueprints")
local GhostRenderer = require("KnoxBuildworks/Planning/GhostRenderer")
local PlanCursor = require("KnoxBuildworks/Planning/PlanCursor")
local KBWB41 = require("KnoxBuildworks/Compat/B41")

local GatherAreaCursor = {}

local GATHER_COLOR = { r = 1.00, g = 1.00, b = 1.00, a = 0.13 }

local function floorInt(value)
    return math.floor(tonumber(value) or 0)
end

local function defineClass()
    KBWGatherAreaCursor = ISBuildingObject:derive("KBWGatherAreaCursor")

    function KBWGatherAreaCursor:new(player, blueprintId, onAreaSet)
        local o = {}
        setmetatable(o, self)
        self.__index = self
        o:init()
        o.character = player
        o.player = player:getPlayerNum()
        o.onAreaSet = onAreaSet
        o.skipBuildAction = true
        o.dragNilAfterPlace = false
        local blueprint = Blueprints.get(player, blueprintId) or Blueprints.activeOrCreate(player)
        o.blueprintId = blueprint.id
        o.planZ = floorInt(player:getZ())
        return o
    end

    function KBWGatherAreaCursor:walkTo(x, y, z)
        return true
    end

    function KBWGatherAreaCursor:haveMaterial(square)
        return true
    end

    function KBWGatherAreaCursor:rotateMouse(x, y)
    end

    function KBWGatherAreaCursor:rotateKey(key)
    end

    function KBWGatherAreaCursor:getSprite()
        return nil
    end

    function KBWGatherAreaCursor:isValid(square)
        return self.currentX ~= nil
    end

    function KBWGatherAreaCursor:render(x, y, z, square)
        self.currentX, self.currentY = PlanCursor.pickTileAt(self.player, self.planZ)
        if self.isLeftDown then
            if self.anchorX == nil then
                self.anchorX, self.anchorY = self.currentX, self.currentY
            end
        elseif not self.build then
            self.anchorX, self.anchorY = nil, nil
        end
        self.canBeBuild = true
        if self.anchorX then
            GhostRenderer.renderRect(
                self.anchorX, self.anchorY, self.currentX, self.currentY, self.planZ, GATHER_COLOR, self.player
            )
        else
            GhostRenderer.renderRect(
                self.currentX, self.currentY, self.currentX, self.currentY, self.planZ, GATHER_COLOR, self.player
            )
        end
    end

    function KBWGatherAreaCursor:create(x, y, z, north, sprite)
        local anchorX = self.anchorX or self.currentX
        local anchorY = self.anchorY or self.currentY
        if anchorX == nil or self.currentX == nil then return end
        local blueprint = Blueprints.get(self.character, self.blueprintId)
        if not blueprint then return end
        local area = {
            x1 = math.min(anchorX, self.currentX),
            y1 = math.min(anchorY, self.currentY),
            x2 = math.max(anchorX, self.currentX),
            y2 = math.max(anchorY, self.currentY),
            z = self.planZ
        }
        local ok, reason = Blueprints.setGatherArea(self.character, self.blueprintId, area)
        self.anchorX, self.anchorY = nil, nil
        if not ok then
            if HaloTextHelper then
                KBWB41.halo(self.character, Blueprints.planErrorText(reason, blueprint), true)
            end
            return
        end
        if HaloTextHelper then
            KBWB41.halo(self.character, getText("IGUI_KBW_GatherAreaSet"), false)
        end
        if self.onAreaSet then self.onAreaSet(area) end
    end
end

KBWB41.addEvent("OnGameStart", defineClass)

function GatherAreaCursor.new(player, blueprintId, onAreaSet)
    return KBWGatherAreaCursor:new(player, blueprintId, onAreaSet)
end

GatherAreaCursor.COLOR = GATHER_COLOR

return GatherAreaCursor
