DL = DL or {}
DL.Paths = DL.Paths or {}
DL.Files = DL.Files or {}

local Paths = DL.Paths
local Files = DL.Files

function Paths.safeName(username)
    if username == nil then return nil end
    local s = tostring(username)
    s = s:gsub("[^%a ]", "")
    s = s:gsub("^%s+", ""):gsub("%s+$", "")
    if s == "" then return nil end
    return s
end

function Paths.accountDir(username)
    local safe = Paths.safeName(username)
    if safe == nil then return nil end
    return DL.Config.dataRoot .. "/" .. safe
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

function Files.writeLines(path, lines)
    if path == nil then return false end
    return (function()
        local w = getFileWriter(path, true, false)
        if w == nil then error("getFileWriter returned nil") end
        for _, line in ipairs(lines) do
            w:write(tostring(line) .. "\n")
        end
        w:close()
        return true
    end)() == true
end

function Files.writeString(path, str)
    return Files.writeLines(path, { tostring(str) })
end

function Files.readLines(path)
    if path == nil then return nil end
    return (function()
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
    end)()
end

function Files.readString(path)
    local lines = Files.readLines(path)
    if lines == nil or #lines == 0 then return nil end
    return lines[1]
end

function Files.exists(path)
    if path == nil then return false end
    local r = (function()
        return getFileReader(path, false)
    end)()
    if r == nil then return false end
    local has = r:readLine() ~= nil
    r:close()
    return has
end

DL.log("files+paths loaded")
