if isClient() and not isServer() then return end
DL = DL or {}
DL.SnapStore = DL.SnapStore or {}
DL.Wounds    = DL.Wounds    or {}
DL.Flags     = DL.Flags     or {}

local Paths = DL.Paths
local Files = DL.Files

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

function DL.SnapStore.push(username, record)
    local N = DL.Config.snapshotKeep
    if Paths.accountDir(username) == nil then
        DL.warn("SnapStore.push: invalid username")
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

function DL.SnapStore.newest(username)
    local meta = readMeta(username)
    if meta.count == 0 or meta.newest == 0 then return nil end
    return Files.readString(Paths.snapshotSlot(username, meta.newest))
end

function DL.SnapStore.count(username)
    return readMeta(username).count
end

function DL.Wounds.get(username)
    local s = Files.readString(Paths.woundsFile(username))
    local n = tonumber(s)
    return n or 0
end

function DL.Wounds.set(username, n)
    n = math.floor(tonumber(n) or 0)
    if n < 0 then n = 0 end
    if Paths.woundsFile(username) == nil then
        DL.warn("Wounds.set: invalid username")
        return false
    end
    local ok = Files.writeString(Paths.woundsFile(username), tostring(n))
    if ok then DL.log("wounds[" .. tostring(username) .. "] = " .. n) end
    return ok
end

function DL.Wounds.add(username, delta)
    local cur = DL.Wounds.get(username)
    local nv = cur + (tonumber(delta) or 0)
    DL.Wounds.set(username, nv)
    return nv
end

function DL.Wounds.reset(username)
    return DL.Wounds.set(username, 0)
end

DL.Flags._restoreUsed = DL.Flags._restoreUsed or {}

local function restoreFlagPath(username)
    local d = DL.Paths.accountDir(username)
    if d == nil then return nil end
    return d .. "/restore_used.txt"
end

function DL.Flags.isRestoreUsed(username)
    local cached = DL.Flags._restoreUsed[username]
    if cached ~= nil then return cached end

    local v = DL.Files.readString(restoreFlagPath(username))
    local used = (v == "1")
    DL.Flags._restoreUsed[username] = used
    return used
end

function DL.Flags.markRestoreUsed(username)
    DL.Flags._restoreUsed[username] = true
    DL.Files.writeString(restoreFlagPath(username), "1")
end

function DL.Flags.resetRestore(username)
    DL.Flags._restoreUsed[username] = false
    DL.Files.writeString(restoreFlagPath(username), "0")
end

DL.log("stores loaded (SnapStore, Wounds, Flags)")
