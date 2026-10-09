DL = DL or {}
DL.MW = {}
DL.MW.MAX     = 10
DL.MW.XP_BASE = 60

local function thresh(level) return DL.MW.XP_BASE * level * (level + 1) / 2 end

function DL.MW.getXP(p) return (p and p:getModData().DL_MW_XP) or 0 end

function DL.MW.getLevel(p)
    local xp, lvl = DL.MW.getXP(p), 0
    for L = 1, DL.MW.MAX do
        if xp >= thresh(L) then lvl = L else break end
    end
    return lvl
end

function DL.MW.addXP(p, amount)
    if not p or not amount or amount <= 0 then return end
    local md = p:getModData()
    local before = DL.MW.getLevel(p)
    md.DL_MW_XP = (md.DL_MW_XP or 0) + amount
    local after = DL.MW.getLevel(p)
    if after > before and p.setHaloNote then
        p:setHaloNote("Metalworking " .. after)
    end
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
