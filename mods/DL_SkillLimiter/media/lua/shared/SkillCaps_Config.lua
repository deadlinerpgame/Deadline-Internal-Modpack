DL = DL or {}

if DL.log == nil then
    DL.log = function(message)
        print("[DL] " .. tostring(message))
    end
end

if DL.warn == nil then
    DL.warn = function(message)
        print("[DL] WARNING: " .. tostring(message))
    end
end

DL.SkillCaps = DL.SkillCaps or {}
local S = DL.SkillCaps

S.maxLevel = 10
S.adminExempt = true
S.legacyExempt = true
S.markerKey = "DL_SkillCaps"
S.auditSeconds = 60

S.defaults = {
    Sprinting = 5,
    Lightfoot = 5,
    Nimble = 5,
    Sneak = 5,
    Axe = 5,
    Blunt = 5,
    SmallBlunt = 5,
    LongBlade = 5,
    SmallBlade = 5,
    Spear = 5,
    Aiming = 5,
    Maintenance = 2,
    Woodwork = 2,
    Cooking = 2,
    Farming = 2,
    Doctor = 2,
    Electricity = 2,
    MetalWelding = 2,
    Mechanics = 2,
    Tailoring = 2,
    Reloading = 2,
    Fishing = 2,
    Trapping = 2,
    PlantScavenging = 2,
}

S.traits = S.traits or {}
