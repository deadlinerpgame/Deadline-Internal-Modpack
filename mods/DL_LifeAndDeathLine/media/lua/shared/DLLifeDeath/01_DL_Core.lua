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
C.woundResetItem  = C.woundResetItem  or "Base.Pills"

C.lootLockMs              = C.lootLockMs              or 60 * 1000
C.lootDeleteAfterUnlockMs = C.lootDeleteAfterUnlockMs or 60 * 1000
C.lootRegistryGiveUpMs    = C.lootRegistryGiveUpMs    or 24 * 60 * 60 * 1000
C.lootLockTestLockEveryone = false   -- TEST ONLY: true = lock against everyone (owner+admin too)

DL.LOGTAG = "[DL]"
function DL.log(msg)  print(DL.LOGTAG .. " " .. tostring(msg)) end
function DL.warn(msg) print(DL.LOGTAG .. " WARN: " .. tostring(msg)) end

DL.log("core loaded (shared) dataRoot='" .. C.dataRoot .. "' baseCap=" .. C.baseCap)
