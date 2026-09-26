DBNO = DBNO or {}

DBNO.Config = DBNO.Config or {}
local C = DBNO.Config

C.dataRoot        = C.dataRoot        or "DownButNotOut_v2"
C.legacyDataRoot  = C.legacyDataRoot  or "DownButNotOut"

C.snapshotKeep    = C.snapshotKeep    or 6
C.saveCooldownMs  = C.saveCooldownMs  or 5 * 60 * 1000

C.woundThreshold  = C.woundThreshold  or 3

C.reviveWoundHpPenalty = C.reviveWoundHpPenalty or 5
C.reviveWoundHpFloor   = C.reviveWoundHpFloor   or 50
C.woundedPartHp        = C.woundedPartHp        or 50
C.reviveCureInfection  = (C.reviveCureInfection ~= false)

C.lootLockMs              = C.lootLockMs              or 60 * 1000
C.lootDeleteAfterUnlockMs = C.lootDeleteAfterUnlockMs or 60 * 1000
C.lootRegistryGiveUpMs    = C.lootRegistryGiveUpMs    or 24 * 60 * 60 * 1000

C.knockdownEnable        = (C.knockdownEnable ~= false)
C.knockdownAutoTrigger   = (C.knockdownAutoTrigger ~= false)
C.knockdownThreshold     = C.knockdownThreshold     or 10

C.knockdownHoldHp        = C.knockdownHoldHp        or 10
C.knockdownReviveHp      = C.knockdownReviveHp      or 30
C.knockdownDurationSec   = C.knockdownDurationSec   or 300
C.knockdownDebugMenu     = (C.knockdownDebugMenu ~= false)
C.knockdownCounters      = (C.knockdownCounters ~= false)
C.bleedoutTimer          = (C.bleedoutTimer ~= false)
C.moveWhileDowned        = (C.moveWhileDowned ~= false)
C.skillRecoveryPct       = C.skillRecoveryPct       or 100
C.knockdownStrikeLimit   = C.knockdownStrikeLimit   or 3
C.knockdownWindowSec     = C.knockdownWindowSec     or 300
C.knockdownReviveTime    = C.knockdownReviveTime    or 200
C.knockdownHoldMode      = C.knockdownHoldMode      or "on"
C.respawnClothesMode     = C.respawnClothesMode     or "off"
C.respawnClothesCustom   = C.respawnClothesCustom   or ""
C.knockdownDrainHpPerMin = C.knockdownDrainHpPerMin or 2
C.knockdownCrawlDrainMult = C.knockdownCrawlDrainMult or 2
C.deathCacheNoUnlock     = (C.deathCacheNoUnlock == true)
C.deathCacheNoDespawn    = (C.deathCacheNoDespawn == true)
C.downedPlayerKill       = (C.downedPlayerKill == true)
C.downedZombieKill       = (C.downedZombieKill == true)
C.lootLockTestLockEveryone = false

function DBNO.cfg() return DBNO.Config end

function DBNO.nowMs()
    return getTimestampMs()
end

function DBNO.displayName(ch)
    local nm = ch:getDescriptor():getForename()
    if nm == nil or nm == "" then nm = tostring(ch:getUsername()) end
    return nm
end

function DBNO.accountName(ch)
    if isClient() or isServer() then return ch:getUsername() end

    local d = ch:getDescriptor()
    local n = (d:getForename() or "") .. (d:getSurname() or "")
    if n ~= "" then return n end
    return ch:getUsername()
end

DBNO.Corpse = DBNO.Corpse or {}

function DBNO.Corpse.newTag(who)
    return tostring(who:getUsername()) .. "|" .. tostring(DBNO.nowMs())
end

function DBNO.Corpse.isEmpty(body)
    local w = body:getWornItems()
    if w ~= nil and w:size() > 0 then return false end
    local bc = body:getItemContainer()
    if bc ~= nil and bc:getItems():size() > 0 then return false end
    return true
end

local function corpseMatches(body, match)
    if match.tag ~= nil then
        return body:getModData().dbno_corpseTag == match.tag
    end
    return body:getOnlineID() == match.id
end

function DBNO.Corpse.tryRemove(x, y, z, match, requireEmpty, remote)
    local sq = getCell():getGridSquare(math.floor(x), math.floor(y), math.floor(z))
    if sq == nil then return false end
    local sobs = sq:getStaticMovingObjects()

    local removed = false
    for i = sobs:size() - 1, 0, -1 do
        local so = sobs:get(i)
        if instanceof(so, "IsoDeadBody")
           and not so:isZombie() and not so:isSkeleton()
           and corpseMatches(so, match)
           and ((not requireEmpty) or DBNO.Corpse.isEmpty(so)) then
            sq:removeCorpse(so, remote)
            removed = true
        end
    end
    return removed
end

function DBNO.isAdmin(ch)
    return ch:isAccessLevel("admin")
end

function DBNO.fmtTs(ts)
    ts = tonumber(ts); if ts == nil then return nil end
    return os.date("!%Y-%m-%d %H:%M:%S UTC", ts)
end

local traitsByName = nil
local professionsByName = nil

local function buildTraitLookup()
    if traitsByName then return traitsByName end
    local defs = TraitFactory.getTraits()
    if defs:size() == 0 then return {} end
    local out = {}
    for i = 0, defs:size() - 1 do
        local def = defs:get(i)
        local t = def:getType()
        out[string.lower(t)] = t
        local label = def:getLabel()
        if label and out[string.lower(label)] == nil then out[string.lower(label)] = t end
    end
    traitsByName = out
    return out
end

local function buildProfessionLookup()
    if professionsByName then return professionsByName end
    local defs = ProfessionFactory.getProfessions()
    if defs:size() == 0 then return {} end
    local out = {}
    for i = 0, defs:size() - 1 do
        local def = defs:get(i)
        local p = def:getType()
        out[string.lower(p)] = p
        local label = def:getName()
        if label and out[string.lower(label)] == nil then out[string.lower(label)] = p end
    end
    professionsByName = out
    return out
end

function DBNO.toTrait(id)
    id = tostring(id)
    if TraitFactory.getTrait(id) ~= nil then return id end
    local bare = id:match("[^:]+$") or id
    if bare ~= id and TraitFactory.getTrait(bare) ~= nil then return bare end
    return buildTraitLookup()[string.lower(bare)]
end

function DBNO.traitName(trait)
    return tostring(trait)
end

function DBNO.toProfession(id)
    id = tostring(id)
    if ProfessionFactory.getProfession(id) ~= nil then return id end
    local bare = id:match("[^:]+$") or id
    if bare ~= id and ProfessionFactory.getProfession(bare) ~= nil then return bare end
    return buildProfessionLookup()[string.lower(bare)]
end

function DBNO.professionName(prof)
    if prof == nil then return nil end
    return tostring(prof)
end

function DBNO.getProfessionName(character)
    return DBNO.professionName(character:getDescriptor():getProfession())
end

function DBNO.setProfessionName(character, name)
    if name == nil or name == "" then return end
    local prof = DBNO.toProfession(name)
    if prof then character:getDescriptor():setProfession(prof) end
end

function DBNO.getTraitNames(character)
    local out = {}
    local tr = character:getTraits()
    for i = 0, tr:size() - 1 do out[#out + 1] = DBNO.traitName(tr:get(i)) end
    return out
end

function DBNO.setTraitNames(character, names)
    local tr = character:getTraits()
    local existing = {}
    for i = 0, tr:size() - 1 do existing[#existing + 1] = tr:get(i) end
    for i = 1, #existing do tr:remove(existing[i]) end
    for _, id in ipairs(names) do
        local trait = DBNO.toTrait(id)
        if trait and not tr:contains(trait) then tr:add(trait) end
    end
end

function DBNO.setGeneralHealth(player, target)
    local parts = player:getBodyDamage():getBodyParts()
    local count = BodyPartType.ToIndex(BodyPartType.MAX)
    local totalMod = 0
    for i = 0, count - 1 do totalMod = totalMod + BodyPartType.getDamageModifyer(i) end
    local targetDamage = 100.0 - target
    if targetDamage < 0 then targetDamage = 0 end
    local h = 100.0 - (targetDamage / totalMod)
    if h < 0 then h = 0 end
    if h > 100 then h = 100 end
    for i = 0, count - 1 do
        parts:get(i):SetHealth(h)
    end
end

function DBNO.stopBleeding(player)
    local parts = player:getBodyDamage():getBodyParts()
    for i = 0, BodyPartType.ToIndex(BodyPartType.MAX) - 1 do
        local bp = parts:get(i)
        bp:setBleeding(false)
        bp:setBleedingTime(0)
    end
end

function DBNO.holdHealth(player, hp)
    DBNO.setGeneralHealth(player, hp)
    player:setHealth(hp)
end

function DBNO.releaseHealth(player)
    player:setInvincible(false)
end

function DBNO.enterDownedHealth(player)
    local C = DBNO.cfg()
    local hp = C.knockdownHoldHp
    if C.knockdownHoldMode == "off" then
        player:setInvincible(false)
        DBNO.setGeneralHealth(player, hp)
        player:setHealth(hp)
        DBNO.stopBleeding(player)
        return
    end
    DBNO.holdHealth(player, hp)
end

DBNO.Crawl = DBNO.Crawl or {}
DBNO.Crawl._at = DBNO.Crawl._at or {}

function DBNO.Crawl.track(player, startMs)
    local key = player:getUsername() or tostring(player:getOnlineID())
    local x, y = player:getX(), player:getY()
    local now = DBNO.nowMs()
    local st = DBNO.Crawl._at[key]
    if st == nil or st.start ~= startMs then
        DBNO.Crawl._at[key] = { start = startMs, x = x, y = y, t = now, ms = 0 }
        return 0
    end
    if math.abs(x - st.x) > 0.05 or math.abs(y - st.y) > 0.05 then
        st.ms = st.ms + (now - st.t)
    end
    st.x, st.y, st.t = x, y, now
    return st.ms
end

function DBNO.tickDownedHealth(player, startMs, crawledMs)
    local C = DBNO.cfg()
    local mode = C.knockdownHoldMode
    if mode == "off" then
        DBNO.stopBleeding(player)
        return true
    end
    local hp = C.knockdownHoldHp
    if mode == "drain" then
        local rate = C.knockdownDrainHpPerMin
        local mins = (DBNO.nowMs() - (startMs or DBNO.nowMs())) / 60000
        local bonus = (C.knockdownCrawlDrainMult - 1) * ((crawledMs or 0) / 60000)
        hp = hp - rate * (mins + bonus)
        if hp <= 0 then return false end
    end
    DBNO.holdHealth(player, hp)
    return true
end

DBNO.Sandbox = DBNO.Sandbox or {}

local MIN = 60 * 1000

local function vars()
    return SandboxVars.DownButNotOut
end

local function num(v, fallback)
    v = tonumber(v)
    if v == nil then return fallback end
    return v
end

local HOLD_MODES = { "off", "on", "drain" }
local CLOTHES_MODES = { "off", "worn", "everything", "custom" }
local SKILL_MODES = { "manual", "immersive", "off" }
local CACHE_LOCK_MODES = { "temporal", "on", "off" }

local function bool(v, fallback)
    if v == nil then return fallback end
    return v and true or false
end

function DBNO.Sandbox.parseTileList(raw)
    local out = {}
    for name in string.gmatch(raw, "[^;]+") do
        name = name:gsub("^%s+", ""):gsub("%s+$", "")
        if name ~= "" then out[name] = true end
    end
    return out
end

function DBNO.Config.applySandbox()
    local S = vars()
    local C = DBNO.Config

    C.knockdownEnable      = bool(S.KnockdownEnable, C.knockdownEnable)
    C.knockdownCounters    = bool(S.KnockdownCounters, C.knockdownCounters)
    C.bleedoutTimer        = bool(S.BleedoutTimer, C.bleedoutTimer)
    C.moveWhileDowned      = bool(S.MoveWhileDowned, C.moveWhileDowned)
    C.skillRecoveryPct     = num(S.SkillRecoveryPct, C.skillRecoveryPct)
    C.knockdownDurationSec = num(S.KnockdownDurationSec, C.knockdownDurationSec)

    C.knockdownWindowSec   = num(S.KnockdownHealingMin, 5) * 60
    C.knockdownThreshold   = num(S.KnockdownThreshold, C.knockdownThreshold)
    C.knockdownHoldHp      = num(S.KnockdownHoldHP, C.knockdownHoldHp)
    C.knockdownReviveHp    = num(S.KnockdownReviveHP, C.knockdownReviveHp)
    C.knockdownReviveTime  = num(S.KnockdownReviveTime, C.knockdownReviveTime)

    if C.knockdownHoldHp < C.knockdownThreshold then
        C.knockdownHoldHp = C.knockdownThreshold
    end
    if C.knockdownReviveHp <= C.knockdownThreshold then
        C.knockdownReviveHp = math.min(100, C.knockdownThreshold + 10)
    end

    C.knockdownHoldMode      = HOLD_MODES[math.floor(num(S.KnockdownHoldMode, 2))] or "on"
    C.knockdownDrainHpPerMin = num(S.KnockdownDrainHpPerMin, C.knockdownDrainHpPerMin)
    C.respawnClothesMode     = CLOTHES_MODES[math.floor(num(S.RespawnClothes, 1))] or "off"
    C.woundThreshold         = num(S.WoundAmount, C.woundThreshold)
    C.respawnClothesCustom   = S.RespawnClothesCustom or C.respawnClothesCustom
    C.deathCacheNoDespawn    = bool(S.DeathCacheNoDespawn, C.deathCacheNoDespawn)

    local clm = CACHE_LOCK_MODES[math.floor(num(S.CacheOwnerLock, 1))] or "temporal"
    if S.CacheOwnerLock == nil then
        if S.DeathCacheLock == false then clm = "off"
        elseif S.DeathCacheNoUnlock == true then clm = "on" end
    end
    C.cacheOwnerLock         = clm
    C.deathCacheLock         = (clm ~= "off")
    C.deathCacheNoUnlock     = (clm == "on")

    C.downedPlayerKill     = bool(S.DownedPlayerKill, C.downedPlayerKill)
    C.downedZombieKill     = bool(S.DownedZombieKill, C.downedZombieKill)

    C.woundsEnable         = bool(S.WoundsEnable, true)
    C.woundsWindowSec      = num(S.WoundsHealingMin, 60) * 60
    C.respawnWithInjuries  = bool(S.RespawnWithInjuries, true)
    C.reviveCureInfection  = bool(S.ReviveCureInfection, C.reviveCureInfection)

    C.skillRestoreMode     = SKILL_MODES[math.floor(num(S.SkillRestoreMode, 1))] or "manual"
    if S.SkillRestoreMode == nil and S.EnableSkillSaveAndRestore == false then
        C.skillRestoreMode = "off"
    end
    C.snapshotEnable       = (C.skillRestoreMode ~= "off")
    C.snapshotManual       = (C.skillRestoreMode == "manual")
    C.respawnPointEnable   = bool(S.EnableSetRespawnPoint, true)
    C.saveCooldownMs       = num(S.SaveCooldownMin, 5) * MIN

    C.useBedsAsSavePoint = bool(S.UseBedsAsSaveRestoreRespawn, true)

    local fx, fy = math.floor(num(S.FinalRespawnX, 19114)), math.floor(num(S.FinalRespawnY, 1391))
    C.finalRespawn = (fx > 0 and fy > 0) and { x = fx, y = fy, z = math.floor(num(S.FinalRespawnZ, 0)) } or nil

    C._baseRestTileSprites = C._baseRestTileSprites or C.restTileSprites
    local merged = {}
    for name in pairs(C._baseRestTileSprites) do merged[name] = true end
    for name in pairs(DBNO.Sandbox.parseTileList(S.CustomTiles)) do merged[name] = true end
    C.restTileSprites = merged

    C.lootLockMs              = num(S.LootLockMin, 1) * MIN
    C.lootDeleteAfterUnlockMs = num(S.LootDeleteAfterUnlockMin, 1) * MIN

    return true
end

DBNO.Config.woundsEnable        = (DBNO.Config.woundsEnable ~= false)
DBNO.Config.woundsWindowSec     = DBNO.Config.woundsWindowSec or 3600
DBNO.Config.respawnWithInjuries = (DBNO.Config.respawnWithInjuries ~= false)
DBNO.Config.snapshotEnable      = (DBNO.Config.snapshotEnable ~= false)
DBNO.Config.snapshotManual      = (DBNO.Config.snapshotManual ~= false)
DBNO.Config.skillRestoreMode    = DBNO.Config.skillRestoreMode    or "manual"
DBNO.Config.respawnPointEnable  = (DBNO.Config.respawnPointEnable ~= false)
DBNO.Config.deathCacheLock      = (DBNO.Config.deathCacheLock ~= false)
DBNO.Config.cacheOwnerLock      = DBNO.Config.cacheOwnerLock      or "temporal"

Events.OnGameStart.Add(DBNO.Config.applySandbox)
Events.OnServerStarted.Add(DBNO.Config.applySandbox)

DBNO.Snap = DBNO.Snap or {}

DBNO.Config.restTileSprites = DBNO.Config.restTileSprites or {
    ["furniture_bedding_01_32"] = true,
}

DBNO.Config.snapshotModDataKeys = DBNO.Config.snapshotModDataKeys or {

}

function DBNO.Snap.perkName(pt)
    local n = pt:getId()
    if n == nil or n == "" then n = pt:getName() end
    return tostring(n)
end

function DBNO.Snap.perkFromName(name)
    if name == nil or name == "" then return nil end
    local list = PerkFactory.PerkList
    for i = 0, list:size() - 1 do
        local p = list:get(i):getType()
        if DBNO.Snap.perkName(p) == name then return p end
    end
    local pt = PerkFactory.getPerkFromName(name)
    if pt ~= nil then return pt end
    return Perks[name]
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

DBNO.ModData = DBNO.ModData or {}

local MD_MAX_DEPTH = 8

local function mdWrite(out, key, v, depth, seen)
    local kt = (type(key) == "number") and "N" or "S"
    local ek = esc(tostring(key))
    local tv = type(v)

    if tv == "number" then
        out[#out + 1] = "N" .. kt .. "|" .. ek .. "|" .. tostring(v)
    elseif tv == "boolean" then
        out[#out + 1] = "B" .. kt .. "|" .. ek .. "|" .. (v and "1" or "0")
    elseif tv == "string" then
        out[#out + 1] = "S" .. kt .. "|" .. ek .. "|" .. esc(v)
    elseif tv == "table" and depth < MD_MAX_DEPTH and not seen[v] then
        seen[v] = true
        out[#out + 1] = "T" .. kt .. "|" .. ek .. "|"
        for k2, v2 in pairs(v) do mdWrite(out, k2, v2, depth + 1, seen) end
        out[#out + 1] = "E||"
        seen[v] = nil
    end
end

function DBNO.ModData.capture(character)
    local out = {}
    for k, v in pairs(character:getModData()) do
        if type(k) ~= "string" or string.sub(k, 1, 5) ~= "dbno_" then
            mdWrite(out, k, v, 0, {})
        end
    end
    return out
end

function DBNO.ModData.apply(character, lines)
    if lines == nil then return 0 end

    local stack = { character:getModData() }
    local n = 0
    for _, line in ipairs(lines) do
        local tag, rawKey, rawVal = string.match(line, "^(%a+)|([^|]*)|(.*)$")
        local top = stack[#stack]
        if tag == "E" then
            if #stack > 1 then stack[#stack] = nil end
        elseif tag ~= nil then
            local vt, kt = string.sub(tag, 1, 1), string.sub(tag, 2, 2)
            local key = unesc(rawKey)
            if kt == "N" then key = tonumber(key) end
            if key ~= nil then
                if vt == "N" then top[key] = tonumber(rawVal); n = n + 1
                elseif vt == "B" then top[key] = (rawVal == "1"); n = n + 1
                elseif vt == "S" then top[key] = unesc(rawVal); n = n + 1
                elseif vt == "T" then
                    local t = {}
                    top[key] = t
                    stack[#stack + 1] = t
                    n = n + 1
                end
            end
        end
    end
    return n
end

function DBNO.Snap.encode(s)
    local parts = {
        "v=2",
        "ts=" .. tostring(s.ts or 0),
        "occ=" .. esc(s.occ),
        "w=" .. tostring(s.weight),
        "kills=" .. tostring(s.kills),
        "hrs=" .. tostring(s.hours),
        "skin=" .. tostring(s.skin),
    }
    local tr = {}
    for _, id in ipairs(s.traits) do tr[#tr + 1] = esc(id) end
    parts[#parts + 1] = "traits=" .. table.concat(tr, ",")

    local md = {}
    for k, v in pairs(s.md) do
        local tag, val
        if type(v) == "number" then tag, val = "n", tostring(v)
        elseif type(v) == "boolean" then tag, val = "b", (v and "1" or "0")
        else tag, val = "s", esc(tostring(v)) end
        md[#md + 1] = esc(k) .. ":" .. tag .. val
    end
    parts[#parts + 1] = "md=" .. table.concat(md, ",")

    local xp = {}
    for name, x in pairs(s.xp) do
        xp[#xp + 1] = esc(name) .. ":" .. tostring(x)
    end
    parts[#parts + 1] = "xp=" .. table.concat(xp, ",")

    local lvl = {}
    for name, lv in pairs(s.lvl) do
        lvl[#lvl + 1] = esc(name) .. ":" .. tostring(lv)
    end
    parts[#parts + 1] = "lv=" .. table.concat(lvl, ",")

    local bo = {}
    for name, lv in pairs(s.boosts) do
        bo[#bo + 1] = esc(name) .. ":" .. tostring(lv)
    end
    parts[#parts + 1] = "bo=" .. table.concat(bo, ",")
    parts[#parts + 1] = "end=" .. tostring(#parts + 1)

    return table.concat(parts, "|")
end

function DBNO.Snap.decode(str)
    if str == nil or str == "" then return nil end
    local s = { traits = {}, md = {}, xp = {}, lvl = {}, boosts = {} }

    local count, expect, ver = 0, nil, nil
    s.ts = getTimestamp()
    for field in string.gmatch(str, "([^|]+)") do
        local key, val = field:match("^(%w+)=(.*)$")
        count = count + 1
        if key == "end" then expect = tonumber(val)
        elseif key == "v" then ver = tonumber(val)
        elseif key == "occ" then s.occ = unesc(val)
        elseif key == "ts" then s.ts = tonumber(val) or s.ts
        elseif key == "w" then s.weight = tonumber(val)
        elseif key == "kills" then s.kills = tonumber(val)
        elseif key == "hrs" then s.hours = tonumber(val)
        elseif key == "skin" then s.skin = tonumber(val)
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
        elseif key == "lv" then
            if val ~= "" then
                for pair in string.gmatch(val, "([^,]+)") do
                    local name, lv = pair:match("^(.-):(.*)$")
                    if name then s.lvl[unesc(name)] = tonumber(lv) end
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
    if (ver or 1) >= 2 and expect ~= count then return nil end
    if expect ~= nil and expect ~= count then return nil end
    return s
end

function DBNO.Snap.build(character)
    local s = { traits = {}, md = {}, xp = {}, lvl = {}, boosts = {} }

    s.occ = DBNO.getProfessionName(character) or ""
    s.weight = character:getNutrition():getWeight()
    s.kills  = character:getZombieKills()
    s.hours  = character:getHoursSurvived()

    s.traits = DBNO.getTraitNames(character)

    s.skin = character:getHumanVisual():getSkinTextureIndex()

    local md = character:getModData()
    for _, key in ipairs(DBNO.Config.snapshotModDataKeys) do
        local v = md[key]
        if v ~= nil then s.md[key] = v end
    end
    for k, v in pairs(md) do
        if type(k) == "string" and type(v) == "number" and string.find(k, "^Fav:") then
            s.md[k] = v
        end
    end

    local xpObj = character:getXp()
    local list = PerkFactory.PerkList
    for i = 0, list:size() - 1 do
        local perk = list:get(i)
        if perk:getParent() ~= Perks.None then
            local pt = perk:getType()
            local name = DBNO.Snap.perkName(pt)
            local x = xpObj:getXP(pt)
            if x > 0 then s.xp[name] = x end
            local lv = character:getPerkLevel(pt)
            if lv > 0 then s.lvl[name] = lv end
            local b = xpObj:getPerkBoost(pt)
            if b > 0 then s.boosts[name] = math.floor(b + 0.5) end
        end
    end

    return s
end

function DBNO.Snap.levelFromXp(pt, xp)
    local lvl = 0
    for n = 1, 10 do
        if xp >= pt:getTotalXpForLevel(n) then lvl = n else break end
    end
    return lvl
end

function DBNO.Snap.describe(character)
    local out = {}

    out[#out + 1] = "Profession: " .. tostring(DBNO.getProfessionName(character) or "none")
    local tr = DBNO.getTraitNames(character)
    out[#out + 1] = "Traits: " .. (#tr > 0 and table.concat(tr, ", ") or "none")
    out[#out + 1] = "Zombie kills: " .. tostring(character:getZombieKills())
    out[#out + 1] = "Hours survived: " .. tostring(math.floor(character:getHoursSurvived()))

    local fav, best = nil, 0
    for k, v in pairs(character:getModData()) do
        if type(k) == "string" and type(v) == "number" and string.find(k, "^Fav:") and v > best then
            fav, best = string.sub(k, 5), v
        end
    end
    out[#out + 1] = "Favourite weapon: " .. (fav and (fav .. " (" .. tostring(best) .. " swings)") or "none")

    out[#out + 1] = ""
    out[#out + 1] = "Skills:"
    local xpObj = character:getXp()
    local list = PerkFactory.PerkList
    local any = false
    for i = 0, list:size() - 1 do
        local perk = list:get(i)
        if perk:getParent() ~= Perks.None then
            local pt = perk:getType()
            local lv = character:getPerkLevel(pt)
            local x = xpObj:getXP(pt)
            if lv > 0 or x > 0 then
                any = true
                out[#out + 1] = "  " .. DBNO.Snap.perkName(pt)
                    .. ": level " .. tostring(lv) .. " (" .. tostring(x) .. " xp)"
            end
        end
    end
    if not any then out[#out + 1] = "  (none)" end
    return out
end

local function addExactXp(xpObj, pt, want)
    local cur = xpObj:getXP(pt)
    for _ = 1, 4 do
        local delta = want - cur
        if delta <= 0.01 then return end
        xpObj:AddXP(pt, delta, false, false, true)
        local after = xpObj:getXP(pt)
        if after <= cur then return end
        cur = after
    end
end

function DBNO.Snap.apply(character, s, lossless)
    if s.occ and s.occ ~= "" then DBNO.setProfessionName(character, s.occ) end

    DBNO.setTraitNames(character, s.traits)

    if s.skin and s.skin >= 0 then
        character:getHumanVisual():setSkinTextureIndex(math.floor(s.skin))
        character:resetModelNextFrame()
    end

    if s.weight then character:getNutrition():setWeight(s.weight) end
    if s.kills then character:setZombieKills(s.kills) end
    if s.hours then character:setHoursSurvived(s.hours) end
    local md = character:getModData()
    for k, v in pairs(s.md) do md[k] = v end

    local xpObj = character:getXp()
    local pct = lossless and 100 or DBNO.Config.skillRecoveryPct
    if pct < 1 then pct = 1 elseif pct > 100 then pct = 100 end
    local list = PerkFactory.PerkList
    for i = 0, list:size() - 1 do
        local perk = list:get(i)
        if perk:getParent() ~= Perks.None then
            local pt = perk:getType()
            local name = DBNO.Snap.perkName(pt)
            local alt = pt:getName()
            local want = s.xp[name] or s.xp[alt] or 0
            local lvl = s.lvl[name] or s.lvl[alt]
            if pct < 100 then
                want = want * pct * 0.01
                lvl = DBNO.Snap.levelFromXp(pt, want)
            elseif lvl == nil then
                lvl = DBNO.Snap.levelFromXp(pt, want)
            end
            lvl = math.floor(lvl)
            if lvl < 0 then lvl = 0 elseif lvl > 10 then lvl = 10 end
            character:setPerkLevelDebug(pt, lvl)
            xpObj:setXPToLevel(pt, lvl)
            if want > pt:getTotalXpForLevel(lvl) then addExactXp(xpObj, pt, want) end
            character:setPerkLevelDebug(pt, lvl)
            xpObj:setPerkBoost(pt, s.boosts[name] or s.boosts[alt] or 0)
        end
    end

    return true
end

function DBNO.Snap.syncXp(player)
    if isClient() then SyncXp(player) end
end

DBNO.Knowledge = DBNO.Knowledge or {}

local _bookTypes = nil
local function skillBookTypes()
    if _bookTypes then return _bookTypes end
    _bookTypes = {}
    local all = getScriptManager():getAllItems()
    for i = 0, all:size() - 1 do
        local si = all:get(i)
        if si:getNumberOfPages() > 0 then
            _bookTypes[#_bookTypes + 1] = si:getFullName()
        end
    end
    return _bookTypes
end

local function eachKnownMediaLine(character, fn)
    local rm = getZomboidRadio():getRecordedMedia()
    local cats = rm:getCategories()
    for c = 0, cats:size() - 1 do
        local mds = rm:getAllMediaForCategory(cats:get(c))
        for m = 0, mds:size() - 1 do
            local md = mds:get(m)
            for ln = 0, md:getLineCount() - 1 do
                local g = md:getLine(ln):getTextGuid()
                if g ~= nil and g ~= "" then fn(g) end
            end
        end
    end
end

local BOOK_VOL_KEY = { [1] = "maxMultiplier1", [3] = "maxMultiplier2", [5] = "maxMultiplier3", [7] = "maxMultiplier4", [9] = "maxMultiplier5" }

local function applyBookMultiplier(character, fullType, pages)
    if pages <= 0 then return end
    local si = getScriptManager():getItem(fullType)
    if si == nil then return end
    local total = si:getNumberOfPages()
    if total <= 0 then return end
    local sb = SkillBook[si:getSkillTrained()]
    if sb == nil or sb.perk == nil then return end

    local volKey = BOOK_VOL_KEY[si:getLevelSkillTrained()]
    if volKey == nil then return end
    local maxMult = sb[volKey]
    if maxMult == nil then return end

    local pct = (pages / total) * 100
    if pct > 100 then pct = 100 end
    local mult = math.floor(pct / 10) * (maxMult / 10)

    local xp = character:getXp()
    if mult > xp:getMultiplier(sb.perk) then
        xp:addXpMultiplier(sb.perk, mult, si:getLevelSkillTrained(), si:getMaxLevelTrained())
    end
end

function DBNO.Knowledge.capture(character)
    local out = {}

    for _, ft in ipairs(skillBookTypes()) do
        local n = character:getAlreadyReadPages(ft)
        if n > 0 then out[#out + 1] = "book|" .. ft .. "|" .. tostring(n) end
    end

    local recipes = character:getKnownRecipes()
    for i = 0, recipes:size() - 1 do
        local r = recipes:get(i)
        if r ~= nil and r ~= "" then out[#out + 1] = "rcp|" .. tostring(r) end
    end

    eachKnownMediaLine(character, function(g)
        if character:isKnownMediaLine(g) then out[#out + 1] = "media|" .. g end
    end)

    local read = character:getAlreadyReadBook()
    for i = 0, read:size() - 1 do out[#out + 1] = "read|" .. tostring(read:get(i)) end

    return out
end

function DBNO.Knowledge.apply(character, lines)
    if lines == nil then return 0 end
    local n = 0
    for _, line in ipairs(lines) do
        local f = {}
        for part in string.gmatch(line .. "|", "([^|]*)|") do f[#f + 1] = part end
        local kind, a, b = f[1], f[2], f[3]
        if kind == "read" then
            local read = character:getAlreadyReadBook()
            if a ~= nil and a ~= "" then
                if not read:contains(a) then read:add(a) end
                n = n + 1
            end
        elseif kind == "media" then
            character:addKnownMediaLine(a); n = n + 1
        elseif kind == "book" then
            local pages = math.floor(tonumber(b) or 0)
            character:setAlreadyReadPages(a, pages)
            applyBookMultiplier(character, a, pages)
            n = n + 1
        elseif kind == "rcp" then
            character:learnRecipe(a); n = n + 1
        end
    end
    return n
end

DBNO.ItemTree = DBNO.ItemTree or {}

local function describeItem(it)
    return tostring(it:getDisplayName()) .. " [" .. tostring(it:getFullType()) .. "]"
end

local function formatModData(it)
    local parts = {}
    for k, v in pairs(it:getModData()) do
        if type(v) == "table" then parts[#parts + 1] = tostring(k) .. "=<table>"
        else parts[#parts + 1] = tostring(k) .. "=" .. tostring(v) end
    end
    if #parts == 0 then return nil end
    return table.concat(parts, ", ")
end

local function appendItem(lines, it, indent, depth, seen)
    if it == nil or seen[it] or depth > 16 then return end
    seen[it] = true
    local isBag = instanceof(it, "InventoryContainer")
    lines[#lines + 1] = indent .. "* " .. describeItem(it) .. (isBag and "  (bag)" or "")
    local md = formatModData(it)
    if md then lines[#lines + 1] = indent .. "    {modData: " .. md .. "}" end
    if isBag then
        local items = it:getInventory():getItems()
        for i = 0, items:size() - 1 do
            appendItem(lines, items:get(i), indent .. "   ", depth + 1, seen)
        end
    end
end

function DBNO.ItemTree.containerLines(container)
    local lines, seen = {}, {}
    local items = container:getItems()
    for i = 0, items:size() - 1 do appendItem(lines, items:get(i), "", 0, seen) end
    return lines
end

function DBNO.ItemTree.characterLines(character)
    local lines, seen = {}, {}

    local w = character:getWornItems()
    for i = 0, w:size() - 1 do appendItem(lines, w:get(i):getItem(), "", 0, seen) end
    appendItem(lines, character:getPrimaryHandItem(), "", 0, seen)
    appendItem(lines, character:getSecondaryHandItem(), "", 0, seen)
    local items = character:getInventory():getItems()
    for i = 0, items:size() - 1 do appendItem(lines, items:get(i), "", 0, seen) end

    return lines
end

function DBNO.Snap.payload(character)
    return {
        snap  = DBNO.Snap.encode(DBNO.Snap.build(character)),
        know  = DBNO.Knowledge.capture(character),
        md    = DBNO.ModData.capture(character),
        items = DBNO.ItemTree.characterLines(character),
    }
end

DBNO.Items = DBNO.Items or {}

function DBNO.Items.validLocation(player, loc)
    if loc == nil or loc == "" then return nil end
    local group = player and player:getBodyLocationGroup() or BodyLocations.getGroup("Human")
    if group:getLocation(loc) == nil then return nil end
    return loc
end

function DBNO.Items.wearLocation(player, it)
    if instanceof(it, "InventoryContainer") then
        local loc = DBNO.Items.validLocation(player, it:canBeEquipped())
        if loc then return loc end
    end
    return DBNO.Items.validLocation(player, it:getBodyLocation())
end

function DBNO.Items.canWear(player, it)
    return DBNO.Items.wearLocation(player, it) ~= nil
end

function DBNO.Items.stripWorn(player)
    local inv = player:getInventory()
    local w = player:getWornItems()
    local drop = {}
    for i = 0, w:size() - 1 do drop[#drop + 1] = w:get(i):getItem() end
    for _, it in ipairs(drop) do
        player:removeWornItem(it, false)
        if inv:contains(it) then inv:DoRemoveItem(it) end
    end
end

function DBNO.Items.wipe(player)
    local inv = player:getInventory()
    player:setPrimaryHandItem(nil)
    player:setSecondaryHandItem(nil)
    local carried = inv:getItems()
    local list = {}
    for i = 0, carried:size() - 1 do list[#list + 1] = carried:get(i) end
    for _, it in ipairs(list) do inv:DoRemoveItem(it) end
end

function DBNO.Items.wear(player, it, loc)
    loc = DBNO.Items.validLocation(player, loc) or DBNO.Items.wearLocation(player, it)
    if loc ~= nil and player:getWornItem(loc) == nil then
        player:setWornItem(loc, it)
        return true
    end
    return false
end

function DBNO.Items.take(player, bagCont, wear, filter, remote)
    local inv = player:getInventory()
    local its = bagCont:getItems()
    local list = {}
    for i = 0, its:size() - 1 do list[#list + 1] = its:get(i) end

    local moved = 0
    for _, it in ipairs(list) do
        local md = it:getModData()
        if filter == nil or filter(it, md) then
            local wasWorn, loc = md.dbno_wasWorn, md.dbno_wornLoc
            md.dbno_wasWorn = nil
            md.dbno_wornLoc = nil
            bagCont:DoRemoveItem(it)
            if remote then bagCont:removeItemOnServer(it) end
            inv:AddItem(it)
            if wear == "any" or (wear == "worn" and wasWorn) then
                DBNO.Items.wear(player, it, loc)
            end
            moved = moved + 1
        end
    end
    return moved
end

function DBNO.Items.refresh(player)
    player:resetModelNextFrame()
    triggerEvent("OnClothingUpdated", player)
    player:getInventory():setDrawDirty(true)
end

DBNO.DeathWounds = DBNO.DeathWounds or {}

function DBNO.DeathWounds.pack(captured)
    local out = {}
    if captured == nil then return out end
    for i, w in pairs(captured) do
        out[#out + 1] = { i = i, w = w }
    end
    return out
end

function DBNO.DeathWounds.unpack(list)
    local out = {}
    if list == nil then return out end
    for _, e in ipairs(list) do
        local idx = tonumber(e.i)
        if idx ~= nil and e.w ~= nil then out[idx] = e.w end
    end
    return out
end

local function partCount() return BodyPartType.ToIndex(BodyPartType.MAX) end

local function countWounds(captured)
    local c = 0
    for _, w in pairs(captured) do
        for k, _ in pairs(w) do
            if k ~= "bleed" then c = c + 1 end
        end
    end
    return c
end

function DBNO.DeathWounds.applyTreated(player, captured)
    if captured == nil then return end
    local C = DBNO.cfg()
    local bd = player:getBodyDamage()
    local parts = bd:getBodyParts()

    if C.reviveCureInfection then
        bd:setInfected(false)
        bd:setInfectionMortalityDuration(-1)
    end

    for i, w in pairs(captured) do
        local bp = parts:get(i)

        if w.bullet then bp:setHaveBullet(false, 5) end
        if w.glass  then bp:setHaveGlass(false) end
        if w.bite then
            bd:SetBitten(i, false)
            bp:setCut(true)
        end
        if w.fracture then
            bp:setFractureTime(w.fracture)
            bp:setSplint(true, 1.0)
            bp:setSplintFactor(1.0)
        end
        if w.deep    then bp:setDeepWounded(true) end
        if w.cut     then bp:setCut(true) end
        if w.scratch then bp:setScratchTime(w.scratch) end
        if w.burn    then bp:setNeedBurnWash(false) end

        if w.bullet or w.glass or w.deep or w.cut or w.bite then
            bp:setStitched(true)
        end
        bp:setBandaged(true, 100.0, false, "Base.Bandage")
        bp:setBleeding(false)
        bp:setBleedingTime(0)
        bp:setWoundInfectionLevel(0)
        bp:setInfectedWound(false)
    end

    for i = 0, partCount() - 1 do
        local bp = parts:get(i)
        bp:setBleeding(false)
        bp:setBleedingTime(0)
    end

    local count = countWounds(captured)
    local hp = 100 - C.reviveWoundHpPenalty * count
    local floor = C.reviveWoundHpFloor
    if hp < floor then hp = floor end

    local hurt, totalMod = {}, 0
    for i in pairs(captured) do
        hurt[#hurt + 1] = i
        totalMod = totalMod + BodyPartType.getDamageModifyer(i)
    end
    if #hurt > 0 and totalMod > 0 then
        local h = C.woundedPartHp
        local safest = 100.0 - ((100.0 - floor) / totalMod)
        if h < safest then h = safest end
        if h < 1 then h = 1 end
        if h > 100 then h = 100 end
        for _, i in ipairs(hurt) do parts:get(i):SetHealth(h) end
        hp = 100.0 - ((100.0 - h) * totalMod)
        if hp < 1 then hp = 1 end
    end
    player:setHealth(hp)
end

function DBNO.DeathWounds.applyRaw(player, captured)
    captured = captured or DBNO.DeathWounds._captured
    if captured == nil then return end
    local bd = player:getBodyDamage()
    local parts = bd:getBodyParts()
    for i, w in pairs(captured) do
        local bp = parts:get(i)
        if w.bullet   then bp:setHaveBullet(true, 1) end
        if w.glass    then bp:setHaveGlass(true) end
        if w.fracture then bp:setFractureTime(w.fracture) end
        if w.bite     then bd:SetBitten(i, true) end
        if w.deep     then bp:setDeepWounded(true) end
        if w.cut      then bp:setCut(true) end
        if w.scratch  then bp:setScratchTime(w.scratch) end
        if w.burn     then bp:setBurnTime(w.burn) end
        if w.bleed then
            bp:setBleeding(true)
            bp:setBleedingTime(20)
        end
    end
end
