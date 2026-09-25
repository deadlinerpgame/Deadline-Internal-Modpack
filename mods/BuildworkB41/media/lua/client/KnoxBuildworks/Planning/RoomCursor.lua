local Blueprints = require("KnoxBuildworks/Planning/Blueprints")
local GhostRenderer = require("KnoxBuildworks/Planning/GhostRenderer")
local PlanCursor = require("KnoxBuildworks/Planning/PlanCursor")
local KBWB41 = require("KnoxBuildworks/Compat/B41")
local RoomCursor = {}

local function floorInt(value)
    return math.floor(tonumber(value) or 0)
end

local function defineClass()
    KBWRoomCursor = ISBuildingObject:derive("KBWRoomCursor")

    function KBWRoomCursor:new(player, blueprintId, roomTemplate, onRoomAdded)
        local o = {}
        setmetatable(o, self)
        self.__index = self
        o:init()
        o.character = player
        o.player = player:getPlayerNum()
        o.roomTemplate = roomTemplate or {}
        o.onRoomAdded = onRoomAdded
        o.skipBuildAction = true
        o.dragNilAfterPlace = false
        o.canBeAlwaysPlaced = false
        local blueprint = Blueprints.get(player, blueprintId) or Blueprints.activeOrCreate(player)
        o.blueprintId = blueprint.id
        o.planZ = floorInt(blueprint.level ~= nil and blueprint.level or player:getZ())
        return o
    end

    function KBWRoomCursor:walkTo(x, y, z)
        return true
    end

    function KBWRoomCursor:haveMaterial(square)
        return true
    end

    function KBWRoomCursor:rotateMouse(x, y)
    end

    function KBWRoomCursor:rotateKey(key)
    end

    function KBWRoomCursor:getSprite()
        return nil
    end

    function KBWRoomCursor:isValid(square)
        return self.currentX ~= nil
    end

    function KBWRoomCursor:render(x, y, z, square)
        local blueprint = Blueprints.get(self.character, self.blueprintId)
        if blueprint and blueprint.level ~= nil then self.planZ = floorInt(blueprint.level) end
        self.currentX, self.currentY = PlanCursor.pickTileAt(self.player, self.planZ)
        if self.isLeftDown then
            if self.anchorX == nil then
                self.anchorX, self.anchorY = self.currentX, self.currentY
            end
        else
            if not self.build then
                self.anchorX, self.anchorY = nil, nil
            end
        end
        self.canBeBuild = true
        local color = self.roomTemplate.color or { r = 0.25, g = 0.65, b = 0.95, a = 0.12 }
        if self.anchorX then
            GhostRenderer.renderRect(
                self.anchorX, self.anchorY, self.currentX, self.currentY, self.planZ, color, self.player
            )
        else
            GhostRenderer.renderRect(
                self.currentX, self.currentY, self.currentX, self.currentY, self.planZ, color, self.player
            )
        end
    end

    function KBWRoomCursor:create(x, y, z, north, sprite)
        local anchorX = self.anchorX or self.currentX
        local anchorY = self.anchorY or self.currentY
        if anchorX == nil or self.currentX == nil then return end
        local minX, maxX = math.min(anchorX, self.currentX), math.max(anchorX, self.currentX)
        local minY, maxY = math.min(anchorY, self.currentY), math.max(anchorY, self.currentY)
        local room, reason = Blueprints.addRoom(self.character, self.blueprintId, {
            name = self.roomTemplate.name,
            type = self.roomTemplate.type,
            color = self.roomTemplate.color,
            x = minX,
            y = minY,
            z = self.planZ,
            w = maxX - minX + 1,
            h = maxY - minY + 1
        })
        self.anchorX, self.anchorY = nil, nil
        if room and self.onRoomAdded then self.onRoomAdded(room) end
        if room and HaloTextHelper then
            KBWB41.halo(self.character, getText("IGUI_KBW_RoomPlaced"), false)
        elseif not room and HaloTextHelper then
            KBWB41.halo(self.character, Blueprints.planErrorText(reason, Blueprints.get(self.character, self.blueprintId)), true)
        end
    end
end

KBWB41.addEvent("OnGameStart", defineClass)

function RoomCursor.new(player, blueprintId, roomTemplate, onRoomAdded)
    return KBWRoomCursor:new(player, blueprintId, roomTemplate, onRoomAdded)
end

return RoomCursor
