local Blueprints = require("KnoxBuildworks/Planning/Blueprints")
local GhostRenderer = require("KnoxBuildworks/Planning/GhostRenderer")
local PlanCursor = require("KnoxBuildworks/Planning/PlanCursor")
local KBWB41 = require("KnoxBuildworks/Compat/B41")

local MoveBlueprintCursor = {}

local function floorInt(value)
    return math.floor(tonumber(value) or 0)
end

local function defineClass()
    KBWMoveBlueprintCursor = ISBuildingObject:derive("KBWMoveBlueprintCursor")

    function KBWMoveBlueprintCursor:new(player, blueprintId, onMoved)
        local o = {}
        setmetatable(o, self)
        self.__index = self
        o:init()
        o.character = player
        o.player = player:getPlayerNum()
        o.onMoved = onMoved
        o.skipBuildAction = true
        o.dragNilAfterPlace = false
        local blueprint = Blueprints.get(player, blueprintId) or Blueprints.activeOrCreate(player)
        o.blueprintId = blueprint.id
        o.planZ = floorInt(blueprint.level ~= nil and blueprint.level or player:getZ())
        return o
    end

    function KBWMoveBlueprintCursor:walkTo(x, y, z)
        return true
    end

    function KBWMoveBlueprintCursor:haveMaterial(square)
        return true
    end

    function KBWMoveBlueprintCursor:rotateMouse(x, y)
    end

    function KBWMoveBlueprintCursor:rotateKey(key)
    end

    function KBWMoveBlueprintCursor:getSprite()
        return nil
    end

    function KBWMoveBlueprintCursor:isValid(square)
        return self.currentX ~= nil
    end

    function KBWMoveBlueprintCursor:render(x, y, z, square)
        local blueprint = Blueprints.get(self.character, self.blueprintId)
        if not blueprint then return end
        self.planZ = floorInt(blueprint.level ~= nil and blueprint.level or self.character:getZ())
        self.currentX, self.currentY = PlanCursor.pickTileAt(self.player, self.planZ)
        self.canBeBuild = true
        local origin = blueprint.origin or { x = 0, y = 0 }
        local dx = self.currentX - (origin.x or 0)
        local dy = self.currentY - (origin.y or 0)
        GhostRenderer.renderBlueprintOffset(blueprint, dx, dy, self.player)
        GhostRenderer.renderTileHighlight(
            self.currentX, self.currentY, self.planZ, GhostRenderer.HIGHLIGHT_COLOR, 0.5, self.player
        )
    end

    function KBWMoveBlueprintCursor:create(x, y, z, north, sprite)
        if self.currentX == nil then return end
        local blueprint = Blueprints.get(self.character, self.blueprintId)
        if not blueprint then return end
        Blueprints.moveTo(self.character, self.blueprintId, self.currentX, self.currentY, self.planZ)
        GhostRenderer.clearCache()
        if HaloTextHelper then
            KBWB41.halo(self.character, getText("IGUI_KBW_BlueprintMoved"), false)
        end
        if self.onMoved then self.onMoved(blueprint) end
        getCell():setDrag(nil, self.player)
    end
end

KBWB41.addEvent("OnGameStart", defineClass)

function MoveBlueprintCursor.new(player, blueprintId, onMoved)
    return KBWMoveBlueprintCursor:new(player, blueprintId, onMoved)
end

return MoveBlueprintCursor
