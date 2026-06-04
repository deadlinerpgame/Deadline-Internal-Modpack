DL = DL or {}
DL.Boosts = DL.Boosts or {}
local B = DL.Boosts
B._sig = B._sig or {}

local function nameOf(character)
    if character == nil or character.getUsername == nil then return nil end
    return character:getUsername()
end

local function signature(character)
    local occ = ""
    local d = character.getDescriptor and character:getDescriptor()
    if d and d.getProfession then occ = tostring(d:getProfession() or "") end
    local ids = {}
    local t = character.getTraits and character:getTraits()
    if t then for i = 0, t:size() - 1 do ids[#ids + 1] = tostring(t:get(i)) end end
    table.sort(ids)
    return occ .. "|" .. table.concat(ids, ",")
end

local function addBoostMap(acc, owner)
    if owner == nil or owner.getXPBoostMap == nil then return end
    local m = owner:getXPBoostMap()
    if m == nil then return end
    local kt = transformIntoKahluaTable(m)
    if kt == nil then return end
    for perk, level in pairs(kt) do
        local pt = perk
        if perk ~= nil and perk.getType ~= nil then pt = perk:getType() end
        local lv = 0
        if type(level) == "number" then lv = level
        elseif level ~= nil and level.intValue ~= nil then lv = level:intValue() end
        if pt ~= nil then acc[pt] = (acc[pt] or 0) + lv end
    end
end

function DL.Boosts.recompute(character)
    if character == nil then return end
    local ok, err = pcall(function()
        local xpObj = character:getXp()
        if xpObj == nil or xpObj.setPerkBoost == nil then return end

        local acc = {}
        local d = character.getDescriptor and character:getDescriptor()
        local profId = d and d.getProfession and d:getProfession()
        if profId and ProfessionFactory and ProfessionFactory.getProfession then
            addBoostMap(acc, ProfessionFactory.getProfession(profId))
        end
        local t = character.getTraits and character:getTraits()
        if t and TraitFactory and TraitFactory.getTrait then
            for i = 0, t:size() - 1 do
                addBoostMap(acc, TraitFactory.getTrait(t:get(i)))
            end
        end

        local list = PerkFactory.PerkList
        for i = 0, list:size() - 1 do
            local perk = list:get(i)
            if perk:getParent() ~= Perks.None then
                local pt = perk:getType()
                xpObj:setPerkBoost(pt, acc[pt] or 0)
            end
        end
    end)
    if not ok then DL.warn("boosts: recompute error: " .. tostring(err)) end
end

function DL.Boosts.syncSignature(character)
    local u = nameOf(character)
    if u then DL.Boosts._sig[u] = signature(character) end
end

function DL.Boosts.maybeRecompute(character)
    local u = nameOf(character)
    if u == nil then return end
    local sig = signature(character)
    local prev = DL.Boosts._sig[u]
    if prev == nil then
        DL.Boosts._sig[u] = sig
        return
    end
    if sig ~= prev then
        DL.Boosts._sig[u] = sig
        DL.Boosts.recompute(character)
        DL.log("boosts: profession/traits changed for '" .. u .. "' -> recomputed XP boosts")
    end
end

DL.log("boosts module loaded (shared)")
