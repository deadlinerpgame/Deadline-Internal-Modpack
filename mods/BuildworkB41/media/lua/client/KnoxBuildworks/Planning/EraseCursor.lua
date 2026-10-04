local Blueprints = require("KnoxBuildworks/Planning/Blueprints")
local GhostRenderer = require("KnoxBuildworks/Planning/GhostRenderer")
local PlanCursor = require("KnoxBuildworks/Planning/PlanCursor")
local KBWB41 = require("KnoxBuildworks/Compat/B41")

local EraseCursor = {}

local function floorInt(value)
    return math.floor(tonumber(value) or 0)
end

local function defineClass()
    KBWEraseCursor = ISBuildingObject:derive("KBWEraseCursor")

    function KBWEraseCursor:new(player, blueprintId, onErased, mode)
        local o = {}
        setmetatable(o, self)
        self.__index = self
        o:init()
        o.character = player
        o.player = player:getPlayerNum()
        o.onErased = onErased
        o.mode = mode == "rooms" and "rooms" or "placements"
        o.skipBuildAction = true
        o.dragNilAfterPlace = false
        local blueprint = Blueprints.get(player, blueprintId) or Blueprints.activeOrCreate(player)
        o.blueprintId = blueprint.id
        o.planZ = floorInt(blueprint.level ~= nil and blueprint.level or player:getZ())
        return o
    end

    function KBWEraseCursor:walkTo(x, y, z)
        return true
    end

    function KBWEraseCursor:haveMaterial(square)
        return true
    end

    function KBWEraseCursor:rotateMouse(x, y)
    end

    function KBWEraseCursor:rotateKey(key)
    end

    function KBWEraseCursor:getSprite()
        return nil
    end

    function KBWEraseCursor:targetAt(x, y)
        local blueprint = Blueprints.get(self.character, self.blueprintId)
        if not blueprint then return nil end
        if self.mode == "rooms" then
            local rooms = Blueprints.roomsAt(blueprint, x, y, self.planZ)
            return rooms[#rooms]
        end
        local placements = Blueprints.placementsAt(blueprint, x, y, self.planZ)
        return placements[#placements]
    end

    function KBWEraseCursor:isValid(square)
        return self.target ~= nil
    end

    function KBWEraseCursor:render(x, y, z, square)
        local blueprint = Blueprints.get(self.character, self.blueprintId)
        if blueprint and blueprint.level ~= nil then self.planZ = floorInt(blueprint.level) end
        self.currentX, self.currentY = PlanCursor.pickTileAt(self.player, self.planZ)
        local key = self.currentX .. "|" .. self.currentY .. "|" .. self.planZ
        if self.targetKey ~= key then
            self.targetKey = key
            self.target = self:targetAt(self.currentX, self.currentY)
        end
        self.canBeBuild = self.target ~= nil
        local color = self.target and GhostRenderer.CONFLICT_COLOR or GhostRenderer.PLAN_COLOR_DIM
        GhostRenderer.renderTileHighlight(self.currentX, self.currentY, self.planZ, color, 0.55, self.player)
        if self.target then
            if self.mode == "rooms" then
                GhostRenderer.renderRoom(self.target, self.planZ, nil, self.target.id, self.player)
            else
                GhostRenderer.renderPlacementLayerAll(self.target, GhostRenderer.CONFLICT_COLOR)
            end
        end
    end

    function KBWEraseCursor:create(x, y, z, north, sprite)
        if self.currentX == nil then return end
        local removed
        if self.mode == "rooms" then
            removed = Blueprints.eraseRoomAt(self.character, self.blueprintId, self.currentX, self.currentY, self.planZ)
        else
            removed = Blueprints.erasePlacementAt(
                self.character, self.blueprintId, self.currentX, self.currentY, self.planZ
            )
        end
        self.targetKey = nil
        if removed then
            GhostRenderer.clearCache()
            if HaloTextHelper then
                KBWB41.halo(self.character, getText("IGUI_KBW_PlanErased"), false)
            end
            if self.onErased then self.onErased(removed) end
        end
    end
end

KBWB41.addEvent("OnGameStart", defineClass)

function EraseCursor.new(player, blueprintId, onErased, mode)
    return KBWEraseCursor:new(player, blueprintId, onErased, mode)
end

return EraseCursor
