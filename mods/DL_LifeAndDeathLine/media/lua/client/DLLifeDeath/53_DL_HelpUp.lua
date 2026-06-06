require "TimedActions/ISBaseTimedAction"

DL = DL or {}
DL.HelpUp = DL.HelpUp or {}

local function isDown(p)
    return p ~= nil and (p:getModData().dl_downed == true
        or p:getVariableBoolean("knockedd") or p:getVariableBoolean("knockedd_fall"))
end

local function displayName(p)
    local nm
    pcall(function()
        local d = p:getDescriptor()
        if d and d.getForename then nm = d:getForename() end
    end)
    if nm == nil or nm == "" then nm = tostring(p:getUsername()) end
    return nm
end

DLHelpUp = ISBaseTimedAction:derive("DLHelpUp")

function DLHelpUp:isValid()
    return isDown(self.target)
end

function DLHelpUp:waitToStart()
    self.character:faceThisObject(self.target)
    return self.character:shouldBeTurning()
end

function DLHelpUp:update()
    self.character:faceThisObject(self.target)
end

function DLHelpUp:start()
    self:setActionAnim("Loot")
    self.character:SetVariable("LootPosition", "Low")
    sendClientCommand(self.character, "DLKnock", "reviving", { targetId = self.target:getOnlineID() })
end

function DLHelpUp:stop()
    if not self._done then
        sendClientCommand(self.character, "DLKnock", "revivecancel", { targetId = self.target:getOnlineID() })
    end
    ISBaseTimedAction.stop(self)
end

function DLHelpUp:perform()
    self._done = true
    sendClientCommand(self.character, "DLKnock", "reviverequest", { targetId = self.target:getOnlineID() })
    ISBaseTimedAction.perform(self)
end

function DLHelpUp:new(character, target)
    local o = ISBaseTimedAction.new(self, character)
    o.target = target
    o.stopOnWalk = true
    o.stopOnRun = true
    o.maxTime = (DL.Config and DL.Config.knockdownReviveTime) or 200
    if character:isTimedActionInstant() then o.maxTime = 1 end
    return o
end

DLTestRevive = ISBaseTimedAction:derive("DLTestRevive")
function DLTestRevive:isValid() return self.character:getModData().dl_downed == true end
function DLTestRevive:update() end
function DLTestRevive:start()
    local nm = "Someone"
    pcall(function() local d=self.character:getDescriptor(); if d and d.getForename then nm = d:getForename() or nm end end)
    DL.Knockdown._reviverName = nm
end
function DLTestRevive:stop()
    if not self._done then DL.Knockdown._reviverName = nil end
    ISBaseTimedAction.stop(self)
end
function DLTestRevive:perform()
    self._done = true
    DL.Knockdown._reviverName = nil
    if DL.Knockdown and DL.Knockdown.getUp then DL.Knockdown.getUp(self.character) end
    ISBaseTimedAction.perform(self)
end
function DLTestRevive:new(character)
    local o = ISBaseTimedAction.new(self, character)
    o.maxTime = (DL.Config and DL.Config.knockdownReviveTime) or 200
    o.forceProgressBar = true
    o.dlBypassLockout = true
    o.stopOnWalk = true
    o.stopOnRun = true
    return o
end

function DL.HelpUp.onSelect(worldobjects, player, target)
    if luautils.walkAdj(player, target:getCurrentSquare()) then
        ISTimedActionQueue.add(DLHelpUp:new(player, target))
    end
end

function DL.HelpUp.onFillWorld(playerIndex, context, worldObjects)
    local player = getSpecificPlayer(playerIndex)
    if player == nil then return end
    if player:getModData().dl_downed then return end

    local square
    for _, v in ipairs(worldObjects) do
        square = v:getSquare()
        if square then break end
    end
    if square == nil then return end

    local target
    for dx = -1, 1 do
        for dy = -1, 1 do
            local sq = getCell():getGridSquare(square:getX() + dx, square:getY() + dy, square:getZ())
            if sq then
                local mos = sq:getMovingObjects()
                if mos then
                    for i = 0, mos:size() - 1 do
                        local o = mos:get(i)
                        if instanceof(o, "IsoPlayer") and o ~= player and isDown(o) then
                            target = o
                        end
                    end
                end
            end
        end
    end
    if target == nil then return end

    context:addOption("Help Up " .. displayName(target), worldObjects, DL.HelpUp.onSelect, player, target)
end
Events.OnFillWorldObjectContextMenu.Add(DL.HelpUp.onFillWorld)

DL.log("knockdown help-up loaded (revive by another player)")
