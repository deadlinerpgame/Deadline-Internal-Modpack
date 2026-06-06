DL = DL or {}
DL.Config = DL.Config or {}
local C = DL.Config

C.dataRoot        = C.dataRoot        or "LifeAndDeathLine"

C.baseCap         = C.baseCap         or 4
C.engineMaxLevel  = C.engineMaxLevel  or 10
C.capAdminExempt  = (C.capAdminExempt ~= false)
C.capPeriodicSec  = C.capPeriodicSec  or 15

C.capBonuses = C.capBonuses or {
    traits      = {},
    occupations = {},
}

C.snapshotKeep    = C.snapshotKeep    or 6
C.saveCooldownMs  = C.saveCooldownMs  or 5 * 60 * 1000

C.woundThreshold  = C.woundThreshold  or 3
C.holdingCell     = C.holdingCell     or { x = 10000, y = 11000, z = 0 }
C.respawnDefault  = C.respawnDefault  or { x = 10010, y = 11000, z = 0 }
C.woundResetItem  = C.woundResetItem  or "Base.Pills"

C.reviveWoundHpPenalty = C.reviveWoundHpPenalty or 5
C.reviveWoundHpFloor   = C.reviveWoundHpFloor   or 50
C.reviveCureInfection  = (C.reviveCureInfection ~= false)

C.lootLockMs              = C.lootLockMs              or 60 * 1000
C.lootDeleteAfterUnlockMs = C.lootDeleteAfterUnlockMs or 60 * 1000
C.lootRegistryGiveUpMs    = C.lootRegistryGiveUpMs    or 24 * 60 * 60 * 1000

C.knockdownEnable        = (C.knockdownEnable ~= false)
C.knockdownAutoTrigger   = (C.knockdownAutoTrigger ~= false)
C.knockdownThreshold     = C.knockdownThreshold     or 10
C.knockdownHoldHp        = C.knockdownHoldHp        or 5
C.knockdownReviveHp      = C.knockdownReviveHp      or 30
C.knockdownDurationSec   = C.knockdownDurationSec   or 300
C.knockdownDebugMenu     = (C.knockdownDebugMenu ~= false)
C.knockdownStrikeLimit   = C.knockdownStrikeLimit   or 3
C.knockdownWindowSec     = C.knockdownWindowSec     or 300
C.knockdownReviveTime    = C.knockdownReviveTime    or 200
C.lootLockTestLockEveryone = false

DL.LOGTAG = "[DL]"
function DL.log(msg)  print(DL.LOGTAG .. " " .. tostring(msg)) end
function DL.warn(msg) print(DL.LOGTAG .. " WARN: " .. tostring(msg)) end

function DL.fmtTs(ts)
    ts = tonumber(ts); if ts == nil then return nil end
    local days = math.floor(ts / 86400)
    local sod  = ts - days * 86400
    local hh = math.floor(sod / 3600)
    local mm = math.floor((sod % 3600) / 60)
    local ss = math.floor(sod % 60)
    local y = 1970
    while true do
        local leap = (y % 4 == 0 and (y % 100 ~= 0 or y % 400 == 0))
        local diy = leap and 366 or 365
        if days >= diy then days = days - diy; y = y + 1 else break end
    end
    local leap = (y % 4 == 0 and (y % 100 ~= 0 or y % 400 == 0))
    local md = { 31, leap and 29 or 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }
    local mon = 1
    for i = 1, 12 do
        if days >= md[i] then days = days - md[i]; mon = mon + 1 else break end
    end
    return string.format("%04d-%02d-%02d %02d:%02d:%02d UTC", y, mon, days + 1, hh, mm, ss)
end

DL.log("core loaded (shared) dataRoot='" .. C.dataRoot .. "' baseCap=" .. C.baseCap)
