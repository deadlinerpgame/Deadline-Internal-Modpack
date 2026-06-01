DL = DL or {}
DL.Caps = DL.Caps or {}

local _perkCache = {}
local function resolvePerk(name)
    if _perkCache[name] ~= nil then return _perkCache[name] or nil end
    local p = Perks[name]
    if p == nil and Perks.FromString then
        p = (function() return Perks.FromString(name) end)()
    end
    _perkCache[name] = p or false
    return p
end

function DL.Caps.computeBonuses(character)
    local bonus = {}
    local cb = DL.Config.capBonuses or {}

    local function add(skillName, amt)
        local p = resolvePerk(skillName)
        if p ~= nil then bonus[p] = (bonus[p] or 0) + amt
        else DL.warn("caps: unknown skill name in config: '" .. tostring(skillName) .. "'") end
    end

    if cb.traits then
        for traitId, skillMap in pairs(cb.traits) do
            if character:HasTrait(traitId) then
                for skillName, amt in pairs(skillMap) do add(skillName, amt) end
            end
        end
    end

    if cb.occupations then
        local desc = character:getDescriptor()
        local prof = desc and desc:getProfession()
        if prof and cb.occupations[prof] then
            for skillName, amt in pairs(cb.occupations[prof]) do add(skillName, amt) end
        end
    end

    return bonus
end

DL.Caps._cache = DL.Caps._cache or {}
function DL.Caps.computeBonusesCached(character)
    local key = (character.getUsername and character:getUsername()) or tostring(character)
    local now = getTimestamp()
    local e = DL.Caps._cache[key]
    if e and (now - e.t) < 2 then return e.bonus end
    local b = DL.Caps.computeBonuses(character)
    DL.Caps._cache[key] = { t = now, bonus = b }
    return b
end

function DL.Caps.capFor(character, perkType, bonusTbl)
    bonusTbl = bonusTbl or DL.Caps.computeBonuses(character)
    local cap = DL.Config.baseCap + (bonusTbl[perkType] or 0)
    if cap > DL.Config.engineMaxLevel then cap = DL.Config.engineMaxLevel end
    return cap
end

function DL.Caps.isExempt(character)
    if not DL.Config.capAdminExempt then return false end
    local al = character.getAccessLevel and character:getAccessLevel() or ""
    return al ~= nil and al ~= "" and al ~= "None"
end

local function toEnum(perk)
    if perk == nil then return nil end
    if perk.getType ~= nil then
        local t = (function() return perk:getType() end)()
        if t ~= nil then return t end
    end
    return perk
end

function DL.Caps.clampPerk(character, perk, bonusTbl)
    if DL.Caps.isExempt(character) then return false end
    local perkType = toEnum(perk)
    if perkType == nil or perkType == Perks.None then return false end
    local cap = DL.Caps.capFor(character, perkType, bonusTbl)
    if character:getPerkLevel(perkType) <= cap then return false end
    return (function()
        character:getXp():setXPToLevel(perkType, cap)
        character:setPerkLevelDebug(perkType, cap)
        return true
    end)() == true
end

function DL.Caps.clampAll(character)
    if character == nil then return 0 end
    if DL.Caps.isExempt(character) then return 0 end
    local bonus = DL.Caps.computeBonuses(character)
    local list = PerkFactory.PerkList
    if list == nil then return 0 end
    local clamped = 0
    for i = 0, list:size() - 1 do
        local perk = list:get(i)
        if perk:getParent() ~= Perks.None then
            if DL.Caps.clampPerk(character, perk:getType(), bonus) then
                clamped = clamped + 1
            end
        end
    end
    return clamped
end

function DL.Caps.pinAtCap(character)
    if character == nil or DL.Caps.isExempt(character) then return 0 end
    local bonus = DL.Caps.computeBonusesCached(character)
    local list = PerkFactory.PerkList
    if list == nil then return 0 end
    local xpObj = character:getXp()
    local overCap = 0
    for i = 0, list:size() - 1 do
        local perk = list:get(i)
        if perk:getParent() ~= Perks.None then
            local pt = perk:getType()
            local cap = DL.Caps.capFor(character, pt, bonus)
            if cap < DL.Config.engineMaxLevel then
                local lvl = character:getPerkLevel(pt)
                if lvl > cap then
                    ;(function()
                        xpObj:setXPToLevel(pt, cap)
                        character:setPerkLevelDebug(pt, cap)
                    end)()
                    overCap = overCap + 1
                elseif lvl == cap then
                    ;(function()
                        xpObj:setXPToLevel(pt, cap)
                    end)()
                end
            end
        end
    end
    return overCap
end

DL.log("caps logic loaded (shared)")
