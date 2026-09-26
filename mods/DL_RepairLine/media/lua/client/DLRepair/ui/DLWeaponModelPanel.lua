require "Vehicles/ISUI/ISUI3DScene"

DLWeaponModelPanel = ISUI3DScene:derive("DLWeaponModelPanel")

local MODEL_ID = "weapon"

function DLWeaponModelPanel:instantiate()
    ISUI3DScene.instantiate(self)
    self:setView("UserDefined")
    local jo = self.javaObject
    jo:fromLua1("setMaxZoom", 32)
    jo:fromLua1("setZoom", 16)
    jo:fromLua3("setViewRotation", 25.0, 135.0, 0.0)
    jo:fromLua1("setDrawGrid", false)
    jo:fromLua1("setDrawGridAxes", false)
    jo:fromLua1("setDrawGridPlane", false)
    self.currentModel = nil
    if self.pendingType then
        self:setWeaponType(self.pendingType)
        self.pendingType = nil
    end
end

function DLWeaponModelPanel:setWeaponType(fullType)
    if not self.javaObject then
        self.pendingType = fullType
        return
    end
    if self.currentModel == fullType then return end
    local jo = self.javaObject
    if self.currentModel then
        jo:fromLua1("removeModel", MODEL_ID)
        self.currentModel = nil
    end
    if fullType then
        jo:fromLua2("createModel", MODEL_ID, fullType)
        jo:fromLua2("setModelUseWorldAttachment", MODEL_ID, true)
        jo:fromLua2("setModelWeaponRotationHack", MODEL_ID, true)
        self.currentModel = fullType
    end
end

function DLWeaponModelPanel:new(x, y, width, height)
    local o = ISUI3DScene.new(self, x, y, width, height)
    o.background = true
    o.backgroundColor = { r = 0.06, g = 0.06, b = 0.06, a = 1 }
    o.borderColor = { r = 0.40, g = 0.40, b = 0.40, a = 1 }
    return o
end
