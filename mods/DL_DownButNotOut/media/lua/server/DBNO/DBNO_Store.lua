if isClient() then return end
DBNO = DBNO or {}

DBNO.Paths = DBNO.Paths or {}
DBNO.Files = DBNO.Files or {}

local Paths = DBNO.Paths
local Files = DBNO.Files

function Paths.safeName(username)
    if username == nil then return nil end
    local s = tostring(username)
    s = s:gsub("[^%w_%- ]", "")
    s = s:gsub("^%s+", ""):gsub("%s+$", "")
    if s == "" then return nil end
    return s
end

function Paths.legacyName(username)
    if username == nil then return nil end
    local s = tostring(username)
    s = s:gsub("[^%a ]", "")
    s = s:gsub("^%s+", ""):gsub("%s+$", "")
    if s == "" then return nil end
    return s
end

local migrationChecked = {}

function Paths.accountDir(username)
    local safe = Paths.safeName(username)
    if safe == nil then return nil end
    local dir = DBNO.Config.dataRoot .. "/" .. safe
    if not migrationChecked[safe] then
        migrationChecked[safe] = true
        Paths._migrateAccount(safe, Paths.legacyName(username), dir)
    end
    return dir
end

function Paths.snapshotsDir(username)
    local d = Paths.accountDir(username)
    if d == nil then return nil end
    return d .. "/snapshots"
end

function Paths.snapshotSlot(username, slot)
    local d = Paths.snapshotsDir(username)
    if d == nil then return nil end
    return d .. "/snapshot_" .. tostring(slot) .. ".txt"
end

function Paths.modDataSlot(username, slot)
    local d = Paths.snapshotsDir(username)
    if d == nil then return nil end
    return d .. "/snapshot_" .. tostring(slot) .. "_moddata.txt"
end

function Paths.knowledgeSlot(username, slot)
    local d = Paths.snapshotsDir(username)
    if d == nil then return nil end
    return d .. "/snapshot_" .. tostring(slot) .. "_knowledge.txt"
end

function Paths.snapshotMeta(username)
    local d = Paths.snapshotsDir(username)
    if d == nil then return nil end
    return d .. "/meta.txt"
end

function Paths.woundsFile(username)
    local d = Paths.accountDir(username)
    if d == nil then return nil end
    return d .. "/wounds.txt"
end

function Paths.woundTimeFile(username)
    local d = Paths.accountDir(username)
    if d == nil then return nil end
    return d .. "/wound_time.txt"
end

function Paths.deathSpotFile(username)
    local d = Paths.accountDir(username)
    if d == nil then return nil end
    return d .. "/deathspot.txt"
end

function Paths.respawnFile(username)
    local d = Paths.accountDir(username)
    if d == nil then return nil end
    return d .. "/respawn.txt"
end

function Paths.knockdownFile(username)
    local d = Paths.accountDir(username)
    if d == nil then return nil end
    return d .. "/knockdown.txt"
end

function Paths.knockStrikeFile(username)
    local d = Paths.accountDir(username)
    if d == nil then return nil end
    return d .. "/knockstrikes.txt"
end

function Files.writeLines(path, lines)
    if path == nil then return false end
    local w = getFileWriter(path, true, false)
    if w == nil then return false end
    for _, line in ipairs(lines) do
        w:write(tostring(line) .. "\n")
    end
    w:close()
    return true
end

function Files.writeString(path, str)
    return Files.writeLines(path, { tostring(str) })
end

function Files.appendString(path, str)
    if path == nil then return false end
    local w = getFileWriter(path, true, true)
    if w == nil then return false end
    w:write(tostring(str) .. "\n")
    w:close()
    return true
end

function Files.readLines(path)
    if path == nil then return nil end
    local r = getFileReader(path, false)
    if r == nil then return nil end
    local out = {}
    local line = r:readLine()
    while line ~= nil do
        out[#out + 1] = line
        line = r:readLine()
    end
    r:close()
    return out
end

function Files.readString(path)
    local lines = Files.readLines(path)
    if lines == nil or #lines == 0 then return nil end
    return lines[1]
end

function Files.exists(path)
    if path == nil then return false end
    local r = getFileReader(path, false)
    if r == nil then return false end
    local has = r:readLine() ~= nil
    r:close()
    return has
end

local MIGRATION_VERSION = 2
local ACCOUNT_FILES = {
    "wounds.txt", "wound_time.txt", "deathspot.txt",
    "respawn.txt", "knockdown.txt", "knockstrikes.txt",
    "final_death.txt", "restore_used.txt",
}
local SNAPSHOT_PARTS = { "", "_moddata", "_knowledge", "_items" }

local function claimsPath()
    return DBNO.Config.dataRoot .. "/_migrated.txt"
end

local function claimedBy(legacy)
    for _, line in ipairs(Files.readLines(claimsPath()) or {}) do
        local safe, from = line:match("^(.-)|(.*)$")
        if from == legacy then return safe end
    end
    return nil
end

local function copyOne(src, dst)
    if Files.exists(dst) then return false end
    local lines = Files.readLines(src)
    if lines == nil then return false end
    return Files.writeLines(dst, lines)
end

function Paths._migrateAccount(safe, legacy, newDir)
    if legacy == nil or DBNO.Config.legacyDataRoot == nil then return end

    local marker = newDir .. "/_migrated.txt"
    local done = Files.readString(marker)
    local dv = done and tonumber(done:match("^v(%d+)$"))
    if dv ~= nil and dv >= MIGRATION_VERSION then return end

    if safe ~= legacy and Files.exists(DBNO.Config.dataRoot .. "/" .. legacy .. "/_migrated.txt") then
        print("[DBNO] migration skipped for '" .. safe .. "': an account named '" .. legacy
            .. "' already exists, so the legacy folder is theirs.")
        return
    end

    local owner = claimedBy(legacy)
    if owner ~= nil and owner ~= safe then
        print("[DBNO] migration skipped for '" .. safe .. "': legacy folder '" .. legacy
            .. "' was already claimed by '" .. owner .. "'. Left in place for manual review.")
        return
    end

    local oldDir = DBNO.Config.legacyDataRoot .. "/" .. legacy
    local n = 0
    for _, f in ipairs(ACCOUNT_FILES) do
        if copyOne(oldDir .. "/" .. f, newDir .. "/" .. f) then n = n + 1 end
    end
    if copyOne(oldDir .. "/snapshots/meta.txt", newDir .. "/snapshots/meta.txt") then n = n + 1 end
    for slot = 1, DBNO.Config.snapshotKeep do
        for _, part in ipairs(SNAPSHOT_PARTS) do
            local rel = "/snapshots/snapshot_" .. tostring(slot) .. part .. ".txt"
            if copyOne(oldDir .. rel, newDir .. rel) then n = n + 1 end
        end
    end

    local logsOld = oldDir .. "/DeathItemLogs"
    local logsNew = newDir .. "/DeathItemLogs"
    if copyOne(logsOld .. "/next.txt", logsNew .. "/next.txt") then n = n + 1 end
    local last  = tonumber(Files.readString(logsOld .. "/next.txt")) or 0
    local limit = (last > 0) and last or 200
    local miss  = 0
    for i = 1, limit do
        local rel = "/death_" .. tostring(i) .. ".txt"
        if copyOne(logsOld .. rel, logsNew .. rel) then
            n = n + 1
            miss = 0
        else
            miss = miss + 1
            if last <= 0 and miss >= 10 then break end
        end
    end

    Files.writeString(marker, "v" .. tostring(MIGRATION_VERSION))
    if n > 0 then
        if owner == nil then Files.appendString(claimsPath(), safe .. "|" .. legacy) end
        DBNO.Players.touch(safe)
        print("[DBNO] migrated " .. tostring(n) .. " file(s) for '" .. safe .. "' from " .. oldDir)
    end
end

DBNO.SnapStore = DBNO.SnapStore or {}
DBNO.Wounds    = DBNO.Wounds    or {}
DBNO.Flags     = DBNO.Flags     or {}
DBNO.Strikes   = DBNO.Strikes   or {}


function DBNO.Strikes.count(username, now)
    local windowMs = DBNO.Config.knockdownWindowSec * 1000
    local f = Paths.knockStrikeFile(username)
    local c = 0
    if f then
        local raw = Files.readString(f)
        if raw and raw ~= "" then
            for t in string.gmatch(raw, "[^,]+") do
                local n = tonumber(t)
                if n and (now - n) < windowMs then c = c + 1 end
            end
        end
    end
    return c
end

local function readMeta(username)
    local lines = Files.readLines(Paths.snapshotMeta(username))
    local meta = { newest = 0, count = 0 }
    if lines == nil then return meta end
    for _, line in ipairs(lines) do
        local k, v = line:match("^(%w+)=(%-?%d+)$")
        if k == "newest" then meta.newest = tonumber(v) end
        if k == "count"  then meta.count  = tonumber(v) end
    end
    return meta
end

local function writeMeta(username, meta)
    return Files.writeLines(Paths.snapshotMeta(username), {
        "newest=" .. tostring(meta.newest),
        "count="  .. tostring(meta.count),
    })
end

function DBNO.SnapStore.push(username, record)
    local N = DBNO.Config.snapshotKeep
    if Paths.accountDir(username) == nil then
        return false
    end
    local meta = readMeta(username)
    local slot = (meta.newest % N) + 1
    if not Files.writeString(Paths.snapshotSlot(username, slot), record) then
        return false
    end
    meta.newest = slot
    meta.count  = math.min(meta.count + 1, N)
    if writeMeta(username, meta) then return slot end
    return false
end

function DBNO.SnapStore.newestSlot(username)
    local meta = readMeta(username)
    if meta.count == 0 or meta.newest == 0 then return nil end
    return meta.newest
end
function DBNO.SnapStore.newestValid(username)
    local meta = readMeta(username)
    if meta.count == 0 or meta.newest == 0 then return nil, nil end
    local N = DBNO.Config.snapshotKeep
    local slot = meta.newest
    for _ = 1, meta.count do
        local enc = Files.readString(Paths.snapshotSlot(username, slot))
        if enc ~= nil and DBNO.Snap.decode(enc) ~= nil then
            return enc, slot
        end
        slot = slot - 1
        if slot < 1 then slot = N end
    end
    return nil, nil
end

function DBNO.SnapStore.newest(username)
    local meta = readMeta(username)
    if meta.count == 0 or meta.newest == 0 then return nil end
    return Files.readString(Paths.snapshotSlot(username, meta.newest))
end

function DBNO.Wounds.get(username)
    local s = Files.readString(Paths.woundsFile(username))
    local n = tonumber(s)
    return n or 0
end

function DBNO.Wounds.stamp(username, when)
    local p = Paths.woundTimeFile(username)
    if p then Files.writeString(p, tostring(math.floor(when or getTimestamp()))) end
end

function DBNO.Wounds.stampedAt(username)
    return tonumber(Files.readString(Paths.woundTimeFile(username) or "")) or 0
end

function DBNO.Wounds.set(username, n)
    n = math.floor(tonumber(n) or 0)
    if n < 0 then n = 0 end
    if Paths.woundsFile(username) == nil then
        return false
    end
    local ok = Files.writeString(Paths.woundsFile(username), tostring(n))
    if ok then
        DBNO.Wounds.stamp(username)
    end
    return ok
end

function DBNO.Wounds.decayOne(username, now, windowSec)
    local n = DBNO.Wounds.get(username)
    if n <= 0 then return nil end
    local last = DBNO.Wounds.stampedAt(username)
    if last <= 0 then
        DBNO.Wounds.stamp(username, now)
        return nil
    end
    if (now - last) < windowSec then return nil end
    DBNO.Wounds.set(username, n - 1)

    return n - 1
end

function DBNO.Wounds.add(username, delta)
    local cur = DBNO.Wounds.get(username)
    local nv = cur + (tonumber(delta) or 0)
    DBNO.Wounds.set(username, nv)
    return nv
end

DBNO.Flags._restoreUsed = DBNO.Flags._restoreUsed or {}

local function restoreFlagPath(username)
    local d = DBNO.Paths.accountDir(username)
    if d == nil then return nil end
    return d .. "/restore_used.txt"
end

function DBNO.Flags.isRestoreUsed(username)
    local cached = DBNO.Flags._restoreUsed[username]
    if cached ~= nil then return cached end

    local v = DBNO.Files.readString(restoreFlagPath(username))
    local used = (v == "1")
    DBNO.Flags._restoreUsed[username] = used
    return used
end

function DBNO.Flags.markRestoreUsed(username)
    DBNO.Flags._restoreUsed[username] = true
    DBNO.Files.writeString(restoreFlagPath(username), "1")
end

function DBNO.Flags.resetRestore(username)
    DBNO.Flags._restoreUsed[username] = false
    DBNO.Files.writeString(restoreFlagPath(username), "0")
end

DBNO.Life = DBNO.Life or {}

local function finalFlagPath(username)
    local d = DBNO.Paths.accountDir(username)
    if d == nil then return nil end
    return d .. "/final_death.txt"
end

function DBNO.Life.isFinalPending(username)
    return DBNO.Files.readString(finalFlagPath(username)) == "1"
end

function DBNO.Life.setFinalPending(username, pending)
    local p = finalFlagPath(username)
    if p then DBNO.Files.writeString(p, pending and "1" or "0") end
end

function DBNO.Life.wipe(username)
    if DBNO.Paths.accountDir(username) == nil then
        return false
    end

    local N = DBNO.Config.snapshotKeep
    for slot = 1, N do
        local p = DBNO.Paths.snapshotSlot(username, slot)
        if p then DBNO.Files.writeString(p, "") end
        local k = DBNO.Paths.knowledgeSlot(username, slot)
        if k then DBNO.Files.writeString(k, "") end
        local mdp = DBNO.Paths.modDataSlot(username, slot)
        if mdp then DBNO.Files.writeString(mdp, "") end
    end
    local meta = DBNO.Paths.snapshotMeta(username)
    if meta then DBNO.Files.writeLines(meta, { "newest=0", "count=0" }) end

    DBNO.Wounds.set(username, 0)
    DBNO.Flags.resetRestore(username)

    local rf = DBNO.Paths.respawnFile(username)
    if rf then DBNO.Files.writeString(rf, "") end
    local kf = DBNO.Paths.knockdownFile(username)
    if kf then DBNO.Files.writeString(kf, "0") end
    local sf = DBNO.Paths.knockStrikeFile(username)
    if sf then DBNO.Files.writeString(sf, "") end

    DBNO.Snap._lastSave[username] = nil

    return true
end

DBNO.Players = DBNO.Players or {}
local function playersIndexPath() return DBNO.Config.dataRoot .. "/_players.txt" end
function DBNO.Players.list()
    return DBNO.Files.readLines(playersIndexPath()) or {}
end
function DBNO.Players.touch(username)
    local u = DBNO.Paths.safeName(username)
    if u == nil then return end
    local list = DBNO.Players.list()
    for _, n in ipairs(list) do if n == u then return end end
    list[#list + 1] = u
    DBNO.Files.writeLines(playersIndexPath(), list)
end

DBNO.Audit = DBNO.Audit or {}
function DBNO.Audit.log(admin, target, field, old, new)
    local now = getTimestamp()
    local stamp = DBNO.fmtTs(now)
    local line = "[" .. stamp .. "] " .. tostring(admin)
        .. " set " .. tostring(field) .. " of '" .. tostring(target) .. "': "
        .. tostring(old) .. " -> " .. tostring(new)
    DBNO.Files.appendString(DBNO.Config.dataRoot .. "/_admin_audit.txt", line)

    writeLog("DBNOAdmin", line)
end

DBNO.Death = DBNO.Death or {}
DBNO.Death._last = DBNO.Death._last or {}
local SAME_DEATH_MS = 1500

local function nameOf(character)
    local u = "?"
    if character then u = tostring(character:getUsername()) end
    return u
end

function DBNO.Death.firstFire(tag, character)
    local username = nameOf(character)
    local key = tostring(tag) .. "|" .. username

    local now = DBNO.nowMs()
    local last = DBNO.Death._last[key]
    if last ~= nil and last.char == character and (now - last.t) < SAME_DEATH_MS then
        return false
    end

    DBNO.Death._last[key] = { t = now, char = character }

    return true
end
