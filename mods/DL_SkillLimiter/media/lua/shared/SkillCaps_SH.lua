DL = DL or {}
DL.Caps = DL.Caps or {}
DL.SkillCaps = DL.SkillCaps or {}

local warnedNames = {}

local function perkNamed(name)
    local perk = Perks[name]
    if perk == nil and not warnedNames[name] then
        warnedNames[name] = true
        DL.warn("caps: unknown skill name '" .. tostring(name) .. "'")
    end
    return perk
end

local function toPerk(perk)
    if perk == nil then return nil end
    if perk.getType ~= nil then
        local perkType = perk:getType()
        if perkType ~= nil then return perkType end
    end
    return perk
end

function DL.Caps.maxLevel()
    return DL.SkillCaps.maxLevel or 10
end

function DL.Caps.computeCaps(character)
    local settings = DL.SkillCaps
    local caps = {}
    for name, cap in pairs(settings.defaults or {}) do
        local perk = perkNamed(name)
        if perk ~= nil then
            caps[perk] = cap
        end
    end
    for traitId, traitCaps in pairs(settings.traits or {}) do
        if character:HasTrait(traitId) then
            for name, cap in pairs(traitCaps) do
                local perk = perkNamed(name)
                if perk ~= nil and caps[perk] ~= nil and cap > caps[perk] then
                    caps[perk] = cap
                end
            end
        end
    end
    return caps
end

DL.Caps._cache = DL.Caps._cache or {}

local function cacheKey(character)
    local name = character.getUsername ~= nil and character:getUsername() or nil
    if name ~= nil and name ~= "" then return name end
    return tostring(character)
end

function DL.Caps.computeCapsCached(character)
    local key = cacheKey(character)
    local now = getTimestamp()
    local entry = DL.Caps._cache[key]
    if entry ~= nil and (now - entry.t) < 2 then return entry.caps end
    local caps = DL.Caps.computeCaps(character)
    DL.Caps._cache[key] = { t = now, caps = caps }
    return caps
end

function DL.Caps.capFor(character, perk, caps)
    caps = caps or DL.Caps.computeCaps(character)
    local maxLevel = DL.Caps.maxLevel()
    local cap = caps[toPerk(perk)]
    if cap == nil or cap > maxLevel then return maxLevel end
    if cap < 0 then return 0 end
    return cap
end

function DL.Caps.isExempt(character)
    if character == nil then return true end
    local settings = DL.SkillCaps
    if settings.adminExempt and character.getAccessLevel ~= nil then
        local level = character:getAccessLevel()
        if level ~= nil and level ~= "" and level ~= "None" then return true end
    end
    if settings.legacyExempt then
        local modData = character:getModData()
        if modData == nil or modData[settings.markerKey or "DL_SkillCaps"] == nil then return true end
    end
    return false
end

function DL.Caps.markNewCharacter(character)
    if character == nil then return end
    character:getModData()[DL.SkillCaps.markerKey or "DL_SkillCaps"] = 1
    DL.Caps._cache[cacheKey(character)] = nil
end

function DL.Caps.clampPerk(character, perk, caps)
    if DL.Caps.isExempt(character) then return false end
    local perkType = toPerk(perk)
    if perkType == nil or perkType == Perks.None then return false end
    local cap = DL.Caps.capFor(character, perkType, caps)
    if character:getPerkLevel(perkType) <= cap then return false end
    character:getXp():setXPToLevel(perkType, cap)
    character:setPerkLevelDebug(perkType, cap)
    return true
end

function DL.Caps.clampAll(character)
    if character == nil or DL.Caps.isExempt(character) then return 0 end
    local caps = DL.Caps.computeCaps(character)
    local clamped = 0
    for perk, _ in pairs(caps) do
        if DL.Caps.clampPerk(character, perk, caps) then
            clamped = clamped + 1
        end
    end
    return clamped
end

function DL.Caps.pinAtCap(character)
    if character == nil or DL.Caps.isExempt(character) then return 0 end
    local caps = DL.Caps.computeCapsCached(character)
    local maxLevel = DL.Caps.maxLevel()
    local xp = character:getXp()
    local overCap = 0
    for perk, _ in pairs(caps) do
        local cap = DL.Caps.capFor(character, perk, caps)
        if cap < maxLevel then
            local level = character:getPerkLevel(perk)
            if level > cap then
                xp:setXPToLevel(perk, cap)
                character:setPerkLevelDebug(perk, cap)
                overCap = overCap + 1
            elseif level == cap then
                xp:setXPToLevel(perk, cap)
            end
        end
    end
    return overCap
end

function DL.Caps.overCap(character)
    local found = {}
    if character == nil or DL.Caps.isExempt(character) then return found end
    local caps = DL.Caps.computeCaps(character)
    for perk, _ in pairs(caps) do
        local cap = DL.Caps.capFor(character, perk, caps)
        local level = character:getPerkLevel(perk)
        if level > cap then
            table.insert(found, { perk = perk, level = level, cap = cap })
        end
    end
    return found
end

DL.log("caps logic loaded (shared)")
