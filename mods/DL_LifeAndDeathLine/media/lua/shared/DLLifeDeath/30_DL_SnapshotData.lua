DL = DL or {}
DL.Snap = DL.Snap or {}
DL.Config = DL.Config or {}

DL.Config.restTileSprites = DL.Config.restTileSprites or {
    ["furniture_bedding_01_32"] = true,
}

DL.Config.snapshotModDataKeys = DL.Config.snapshotModDataKeys or {

}

local _name2perk, _perk2name
local function buildPerkMaps()
    _name2perk, _perk2name = {}, {}
    local list = PerkFactory and PerkFactory.PerkList
    if list == nil then return end
    for i = 0, list:size() - 1 do
        local perk = list:get(i)
        local pt = perk:getType()
        local n = (function() if pt.name then return pt:name() end return nil end)()
        if n == nil or n == "" then n = tostring(pt) end
        _name2perk[n] = pt
        _perk2name[pt] = n
    end
end
function DL.Snap.perkName(pt)
    if _perk2name == nil then buildPerkMaps() end
    return (_perk2name and _perk2name[pt]) or tostring(pt)
end
function DL.Snap.perkFromName(name)
    if _name2perk == nil then buildPerkMaps() end
    return (_name2perk and _name2perk[name]) or (Perks and Perks[name]) or nil
end

local function esc(s)
    s = tostring(s)
    s = s:gsub("%%", "%%25"):gsub("|", "%%7C"):gsub(",", "%%2C")
         :gsub(":", "%%3A"):gsub("=", "%%3D"):gsub("\n", "%%0A")
    return s
end
local function unesc(s)
    s = tostring(s)
    s = s:gsub("%%0A", "\n"):gsub("%%3D", "="):gsub("%%3A", ":")
         :gsub("%%2C", ","):gsub("%%7C", "|"):gsub("%%25", "%%")
    return s
end

function DL.Snap.encode(s)
    local parts = {
        "v=1",
        "ts=" .. tostring(s.ts or 0),
        "occ=" .. esc(s.occ or ""),
        "w=" .. tostring(s.weight or 0),
        "kills=" .. tostring(s.kills or 0),
        "hrs=" .. tostring(s.hours or 0),
    }
    local tr = {}
    for _, id in ipairs(s.traits or {}) do tr[#tr + 1] = esc(id) end
    parts[#parts + 1] = "traits=" .. table.concat(tr, ",")

    local md = {}
    for k, v in pairs(s.md or {}) do
        local tag, val
        if type(v) == "number" then tag, val = "n", tostring(v)
        elseif type(v) == "boolean" then tag, val = "b", (v and "1" or "0")
        else tag, val = "s", esc(tostring(v)) end
        md[#md + 1] = esc(k) .. ":" .. tag .. val
    end
    parts[#parts + 1] = "md=" .. table.concat(md, ",")

    local xp = {}
    for name, x in pairs(s.xp or {}) do
        xp[#xp + 1] = esc(name) .. ":" .. tostring(x)
    end
    parts[#parts + 1] = "xp=" .. table.concat(xp, ",")

    local bo = {}
    for name, lv in pairs(s.boosts or {}) do
        bo[#bo + 1] = esc(name) .. ":" .. tostring(lv)
    end
    parts[#parts + 1] = "bo=" .. table.concat(bo, ",")

    return table.concat(parts, "|")
end

function DL.Snap.decode(str)
    if str == nil or str == "" then return nil end
    local s = { traits = {}, md = {}, xp = {}, boosts = {} }

    s.ts = (function() return getTimestamp() end)() or 0
    for field in string.gmatch(str, "([^|]+)") do
        local key, val = field:match("^(%w+)=(.*)$")
        if key == "occ" then s.occ = unesc(val)
        elseif key == "ts" then s.ts = tonumber(val)
        elseif key == "w" then s.weight = tonumber(val)
        elseif key == "kills" then s.kills = tonumber(val)
        elseif key == "hrs" then s.hours = tonumber(val)
        elseif key == "traits" then
            if val ~= "" then
                for id in string.gmatch(val, "([^,]+)") do s.traits[#s.traits + 1] = unesc(id) end
            end
        elseif key == "md" then
            if val ~= "" then
                for pair in string.gmatch(val, "([^,]+)") do
                    local k, tagval = pair:match("^(.-):(.*)$")
                    if k then
                        local tag, raw = tagval:sub(1, 1), tagval:sub(2)
                        k = unesc(k)
                        if tag == "n" then s.md[k] = tonumber(raw)
                        elseif tag == "b" then s.md[k] = (raw == "1")
                        else s.md[k] = unesc(raw) end
                    end
                end
            end
        elseif key == "xp" then
            if val ~= "" then
                for pair in string.gmatch(val, "([^,]+)") do
                    local name, x = pair:match("^(.-):(.*)$")
                    if name then s.xp[unesc(name)] = tonumber(x) end
                end
            end
        elseif key == "bo" then
            if val ~= "" then
                for pair in string.gmatch(val, "([^,]+)") do
                    local name, lv = pair:match("^(.-):(.*)$")
                    if name then s.boosts[unesc(name)] = tonumber(lv) end
                end
            end
        end
    end
    return s
end

function DL.Snap.build(character)
    local s = { traits = {}, md = {}, xp = {}, boosts = {} }

    s.occ = (function()
        local d = character:getDescriptor(); return d and d:getProfession() end)() or ""
    s.weight = (function() return character:getNutrition():getWeight() end)() or 0
    s.kills  = (function() return character:getZombieKills() end)() or 0
    s.hours  = (function() return character:getHoursSurvived() end)() or 0

    local _ = (function()
        local t = character:getTraits()
        if t then for i = 0, t:size() - 1 do s.traits[#s.traits + 1] = t:get(i) end end
    end)()

    local _ = (function()
        local md = character:getModData()
        if md then
            for _, key in ipairs(DL.Config.snapshotModDataKeys or {}) do
                local v = md[key]
                if v ~= nil then s.md[key] = v end
            end
        end
    end)()

    local _ = (function()
        local xpObj = character:getXp()
        local list = PerkFactory.PerkList
        for i = 0, list:size() - 1 do
            local perk = list:get(i)
            if perk:getParent() ~= Perks.None then
                local pt = perk:getType()
                local x = xpObj:getXP(pt)
                if x and x > 0 then s.xp[DL.Snap.perkName(pt)] = x end
            end
        end
    end)()

    local _ = (function()
        local xpObj = character:getXp()
        if xpObj == nil or xpObj.getPerkBoost == nil then return end
        local list = PerkFactory.PerkList
        for i = 0, list:size() - 1 do
            local perk = list:get(i)
            if perk:getParent() ~= Perks.None then
                local pt = perk:getType()
                local b = xpObj:getPerkBoost(pt)
                if b and b > 0 then s.boosts[DL.Snap.perkName(pt)] = math.floor(b + 0.5) end
            end
        end
    end)()

    return s
end

local _addMode = nil
local function addXpNoMult(xpObj, pt, amount)
    if amount == nil or amount <= 0 then return end
    if _addMode == "nomult" then xpObj:AddXPNoMultiplier(pt, amount); return end
    if _addMode == "bool3"  then xpObj:AddXP(pt, amount, true);        return end
    if _addMode == "plain"  then xpObj:AddXP(pt, amount);              return end

    if pcall(function() xpObj:AddXPNoMultiplier(pt, amount) end) then _addMode = "nomult"; return end
    if pcall(function() xpObj:AddXP(pt, amount, true) end)       then _addMode = "bool3";  return end
    xpObj:AddXP(pt, amount); _addMode = "plain"
end

function DL.Snap.apply(character, s)
    if character == nil or s == nil then return false end

    local _ = (function()
        if s.occ and s.occ ~= "" then character:getDescriptor():setProfession(s.occ) end
    end)()

    local _ = (function()
        local t = character:getTraits()
        if t then
            t:clear()
            for _, id in ipairs(s.traits or {}) do t:add(id) end
        end
    end)()

    local _ = (function() if s.weight then character:getNutrition():setWeight(s.weight) end end)()
    local _ = (function() if s.kills then character:setZombieKills(s.kills) end end)()
    local _ = (function()
        if s.hours and character.setHoursSurvived then character:setHoursSurvived(s.hours) end
    end)()
    local _ = (function()
        local md = character:getModData()
        if md then for k, v in pairs(s.md or {}) do md[k] = v end end
    end)()

    local _ = (function()
        local xpObj = character:getXp()
        local list = PerkFactory.PerkList
        for i = 0, list:size() - 1 do
            local perk = list:get(i)
            if perk:getParent() ~= Perks.None then
                local pt = perk:getType()
                local target = (s.xp and s.xp[DL.Snap.perkName(pt)]) or 0
                xpObj:setXPToLevel(pt, 0)
                if target > 0 then addXpNoMult(xpObj, pt, target) end
            end
        end
    end)()

    local _ = (function()
        local xpObj = character:getXp()
        if xpObj == nil or xpObj.setPerkBoost == nil then return end
        local list = PerkFactory.PerkList
        for i = 0, list:size() - 1 do
            local perk = list:get(i)
            if perk:getParent() ~= Perks.None then
                local pt = perk:getType()
                local lvl = (s.boosts and s.boosts[DL.Snap.perkName(pt)]) or 0
                xpObj:setPerkBoost(pt, lvl)
            end
        end
    end)()

    if DL.Boosts and DL.Boosts.syncSignature then DL.Boosts.syncSignature(character) end

    local _ = (function() DL.Caps.clampAll(character) end)()
    return true
end

DL.log("snapshot data layer loaded (shared)")
