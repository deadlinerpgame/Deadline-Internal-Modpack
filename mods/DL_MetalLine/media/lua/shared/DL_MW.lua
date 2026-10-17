DL = DL or {}
DL.MW = {}
DL.MW.MAX     = 10

function DL.MW.getLevel(p)
    return p and p:getPerkLevel(Perks.MetalWelding) or 0
end

function DL.MW.addXP(p, amount)
    if not p or not amount or amount <= 0 then return end
    p:getXp():AddXP(Perks.MetalWelding, amount)
end

local function lvl(p) if type(p) == "number" then return p end return DL.MW.getLevel(p) end

function DL.MW.heatScale(p)   return 0.5 + 0.05 * lvl(p) end
function DL.MW.refineScale(p) return 0.5 + 0.05 * lvl(p) end

function DL.MW.startFrac(p)   return 0.05 * lvl(p) end

function DL.MW.capFrac(p)
    local sv = SandboxVars and SandboxVars.MetalLine
    local base = tonumber(sv and sv.QualityCapAtLevel0) or 50
    base = math.max(0, math.min(100, base)) / 100
    return base + (1 - base) * lvl(p) / DL.MW.MAX
end

DL.MW.COMPLEX_LEVEL = 10
