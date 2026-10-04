require "TimedActions/ISBaseTimedAction"

ClothesUpgrade = ClothesUpgrade or {}
ClothesUpgrade.Bench = {
    objectName  = "Clothing Bench",
    buildableId = "kbw.deadline.workbench.clothingbench",
    maxDistance = 3,
}
local Bench = ClothesUpgrade.Bench

function Bench.isBench(obj)
    if not (obj and obj.getName) then return false end
    if obj:getName() == Bench.objectName then return true end
    if not (obj.hasModData and obj:hasModData()) then return false end
    local kbw = obj:getModData().KBW
    return type(kbw) == "table" and kbw.buildableId == Bench.buildableId
end

function Bench.findIn(worldobjects)
    for _, obj in ipairs(worldobjects or {}) do
        if Bench.isBench(obj) then return obj end
        local sq = obj.getSquare and obj:getSquare()
        if sq then
            local objs = sq:getObjects()
            for i = 0, objs:size() - 1 do
                local o = objs:get(i)
                if Bench.isBench(o) then return o end
            end
        end
    end
    return nil
end

function Bench.isNear(character, bench)
    if not (character and bench) then return false end
    local sq = bench:getSquare()
    if not (sq and sq:getObjects():contains(bench)) then return false end
    if math.floor(character:getZ()) ~= sq:getZ() then return false end
    local dx = character:getX() - (sq:getX() + 0.5)
    local dy = character:getY() - (sq:getY() + 0.5)
    return dx * dx + dy * dy <= Bench.maxDistance * Bench.maxDistance
end

CULOpenBenchAction = ISBaseTimedAction:derive("CULOpenBenchAction")

function CULOpenBenchAction:isValid()
    return Bench.isNear(self.character, self.bench)
end

function CULOpenBenchAction:perform()
    CULBenchWindow.OpenBench(self.character:getPlayerNum(), self.bench)
    ISBaseTimedAction.perform(self)
end

function CULOpenBenchAction:new(character, bench)
    local o = ISBaseTimedAction.new(self, character)
    o.character = character
    o.bench = bench
    o.maxTime = 1
    o.stopOnWalk = false
    o.stopOnRun = false
    return o
end
