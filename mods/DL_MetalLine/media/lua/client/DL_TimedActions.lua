require "TimedActions/ISBaseTimedAction"

DL = DL or {}

local function near(character, wobj)
    local sq = wobj and wobj:getSquare()
    if not sq or not DL.CrucibleClient.isPlaced(wobj) then return false end
    return math.floor(character:getZ()) == sq:getZ()
        and character:DistToSquared(sq:getX() + 0.5, sq:getY() + 0.5) <= 4
end

local function peek(wobj)
    return DL.Crucible.peek(DL.CrucibleClient.state(wobj))
end

ISDLOpenCrucible = ISBaseTimedAction:derive("ISDLOpenCrucible")

function ISDLOpenCrucible:isValid() return near(self.character, self.wobj) end

function ISDLOpenCrucible:perform()
    DL.showCrucibleUI(self.character, self.wobj)
    ISBaseTimedAction.perform(self)
end

function ISDLOpenCrucible:new(character, wobj)
    local o = ISBaseTimedAction.new(self, character)
    o.wobj = wobj
    o.maxTime = 1
    return o
end

ISDLLightCrucible = ISBaseTimedAction:derive("ISDLLightCrucible")

function ISDLLightCrucible:isValid()
    if not near(self.character, self.wobj) then return false end
    local st = peek(self.wobj)
    if st and (st.lit or (st.fuelMin or 0) <= 0) then return false end
    return DL.Crucible.hasFireSource(self.character) and DL.Crucible.findKindling(self.character) ~= nil
end

function ISDLLightCrucible:waitToStart()
    self.character:faceThisObject(self.wobj)
    return self.character:shouldBeTurning()
end

function ISDLLightCrucible:update() self.character:faceThisObject(self.wobj) end

function ISDLLightCrucible:start()
    self:setActionAnim("Loot")
    self.character:SetVariable("LootPosition", "Low")
end

function ISDLLightCrucible:stop() ISBaseTimedAction.stop(self) end

function ISDLLightCrucible:perform()
    local k = DL.Crucible.findKindling(self.character)
    if k and k:getContainer() then k:getContainer():Remove(k) end
    DL.CrucibleClient.send(self.character, self.wobj, "Light", { mw = DL.MW.getLevel(self.character) })
    ISBaseTimedAction.perform(self)
end

function ISDLLightCrucible:new(character, wobj)
    local o = ISBaseTimedAction.new(self, character)
    o.wobj = wobj
    o.maxTime = DL.LIGHT_TIME or 250
    o.stopOnWalk = true
    o.stopOnRun = true
    return o
end

ISDLPourCrucible = ISBaseTimedAction:derive("ISDLPourCrucible")

function ISDLPourCrucible:isValid()
    if not near(self.character, self.wobj) then return false end
    local st = peek(self.wobj)
    return st ~= nil and st.phase == "molten" and st.alloy ~= nil and (st.alloy.units or 0) >= 1
        and DL.Crucible.findIngotMold(self.character) ~= nil
end

function ISDLPourCrucible:waitToStart()
    self.character:faceThisObject(self.wobj)
    return self.character:shouldBeTurning()
end

function ISDLPourCrucible:update() self.character:faceThisObject(self.wobj) end

function ISDLPourCrucible:start()
    self:setActionAnim("Loot")
    self.character:SetVariable("LootPosition", "Low")
end

function ISDLPourCrucible:stop() ISBaseTimedAction.stop(self) end

function ISDLPourCrucible:perform()
    DL.CrucibleClient.send(self.character, self.wobj, "Pour")
    ISBaseTimedAction.perform(self)
end

function ISDLPourCrucible:new(character, wobj)
    local o = ISBaseTimedAction.new(self, character)
    o.wobj = wobj
    o.maxTime = DL.POUR_TIME or 150
    o.stopOnWalk = true
    o.stopOnRun = true
    return o
end
