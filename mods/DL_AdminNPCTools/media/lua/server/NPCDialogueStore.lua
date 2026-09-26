if isClient() then return end

require "NPCDialogueShared"

NPCDialogue.Store = NPCDialogue.Store or {}
local Store = NPCDialogue.Store

local DATA_ROOT  = "DL_AdminNPCTools"
local HEADER     = "NPCDialogue|1"
local LEGACY_KEY = "NPCDialogueZones_Server"
local MAX_DEPTH  = 32

local zones  = {}
local loaded = false

local function worldDir()
    local world = getWorld and getWorld()
    local name = tostring(world and world:getWorld() or ""):gsub("[^%w_%- ]", "_")
    if name == "" then name = "default" end
    return DATA_ROOT .. "/" .. name
end

local function path(file)
    return worldDir() .. "/" .. file
end

local function readLines(p)
    local r = getFileReader(p, false)
    if not r then return nil end
    local out = {}
    local line = r:readLine()
    while line do
        out[#out + 1] = line
        line = r:readLine()
    end
    r:close()
    return out
end

local function writeLines(p, lines, append)
    local w = getFileWriter(p, true, append == true)
    if not w then
        print("[NPCDialogue] could not write " .. p)
        return false
    end
    w:write(table.concat(lines, "\n") .. "\n")
    w:close()
    return true
end

local function now()
    return os.date("%Y-%m-%d %H:%M:%S")
end

local function esc(s)
    return (tostring(s):gsub("%%", "%%25"):gsub("|", "%%7C"):gsub("\r", "%%0D"):gsub("\n", "%%0A"))
end

local function unesc(s)
    return (s:gsub("%%0A", "\n"):gsub("%%0D", "\r"):gsub("%%7C", "|"):gsub("%%25", "%%"))
end

local function sortedKeys(t)
    local nums, strs = {}, {}
    for k in pairs(t) do
        local tk = type(k)
        if tk == "number" then
            nums[#nums + 1] = k
        elseif tk == "string" then
            strs[#strs + 1] = k
        end
    end
    table.sort(nums)
    table.sort(strs)
    for i = 1, #strs do nums[#nums + 1] = strs[i] end
    return nums
end

local function writeValue(out, key, v, depth)
    local pad  = string.rep("  ", depth)
    local head = ((type(key) == "number") and "N" or "S") .. "|" .. esc(key) .. "|"
    local tv = type(v)
    if tv == "string" then
        out[#out + 1] = pad .. "S" .. head .. esc(v)
    elseif tv == "number" then
        out[#out + 1] = pad .. "N" .. head .. tostring(v)
    elseif tv == "boolean" then
        out[#out + 1] = pad .. "B" .. head .. (v and "1" or "0")
    elseif tv == "table" and depth < MAX_DEPTH then
        out[#out + 1] = pad .. "T" .. head
        for _, k in ipairs(sortedKeys(v)) do writeValue(out, k, v[k], depth + 1) end
        out[#out + 1] = pad .. "E||"
    end
end

local function serialize(zs)
    local ids = sortedKeys(zs)
    local out = {
        HEADER,
        "# DL_AdminNPCTools: every placed NPC and its dialogue. Stop the server before editing by hand.",
    }
    for _, id in ipairs(ids) do
        local z = zs[id]
        out[#out + 1] = "# " .. esc(z.name or "?") .. " at " .. tostring(z.x) .. "," .. tostring(z.y) .. "," .. tostring(z.z)
        writeValue(out, id, z, 0)
    end
    out[#out + 1] = "END|" .. tostring(#ids)
    return out
end

local function parse(lines)
    if not (lines and lines[1] and lines[1]:find(HEADER, 1, true)) then
        return nil, "not an NPC file"
    end
    local root  = {}
    local stack = { root }
    for i = 2, #lines do
        local s = lines[i]:gsub("^%s+", "")
        if s:sub(1, 4) == "END|" then
            if #stack ~= 1 then return nil, "a table is not closed before END" end
            return root
        elseif s ~= "" and s:sub(1, 1) ~= "#" then
            local tag, rk, rv = s:match("^(%u%u?)|([^|]*)|(.*)$")
            if not tag then return nil, "unreadable line " .. i end
            if tag == "E" then
                if #stack == 1 then return nil, "unexpected E|| at line " .. i end
                stack[#stack] = nil
            else
                local vt, kt = tag:sub(1, 1), tag:sub(2, 2)
                local key = unesc(rk)
                if kt == "N" then
                    key = tonumber(key)
                elseif kt ~= "S" then
                    key = nil
                end
                if key == nil then return nil, "bad key at line " .. i end
                local top = stack[#stack]
                if vt == "S" then
                    top[key] = unesc(rv)
                elseif vt == "N" then
                    top[key] = tonumber(rv)
                elseif vt == "B" then
                    top[key] = (rv == "1")
                elseif vt == "T" then
                    local t = {}
                    top[key] = t
                    stack[#stack + 1] = t
                else
                    return nil, "unknown value type at line " .. i
                end
            end
        end
    end
    return nil, "no END line (the file was cut short)"
end

local function normalize(zone, id)
    if type(zone) ~= "table" then return nil end
    local x, y, z = tonumber(zone.x), tonumber(zone.y), tonumber(zone.z)
    if not (x and y and z) then return nil end
    zone.id = tostring(id or zone.id)
    zone.x, zone.y, zone.z = math.floor(x), math.floor(y), math.floor(z)
    zone.name = tostring(zone.name or "NPC")
    local r = tonumber(zone.radius)
    zone.radius = (r and r > 0) and r or NPCDialogue.DEFAULT_RADIUS
    if zone.concurrent == nil then zone.concurrent = NPCDialogue.DEFAULT_CONCURRENT end
    if type(zone.portrait) ~= "string" then zone.portrait = "" end
    if type(zone.dialogueTree) ~= "table" then zone.dialogueTree = {} end
    if type(zone.dialogueTree.nodes) ~= "table" then zone.dialogueTree.nodes = {} end
    if type(zone.dialogueTree.nodeOrder) ~= "table" then zone.dialogueTree.nodeOrder = {} end
    return zone
end

local function readStore(p)
    local lines = readLines(p)
    if not lines then return nil, "missing" end
    local zs, why = parse(lines)
    if not zs then return nil, why, lines end
    local out, dropped = {}, 0
    for id, zone in pairs(zs) do
        local ok = normalize(zone, id)
        if ok then out[ok.id] = ok else dropped = dropped + 1 end
    end
    if dropped > 0 then
        print("[NPCDialogue] skipped " .. dropped .. " entr" .. (dropped == 1 and "y" or "ies") .. " without a position in " .. p)
    end
    return out
end

local function importLegacy()
    local marker = path("legacy_imported.txt")
    if readLines(marker) then return 0 end
    local n = 0
    local gt = getGameTime and getGameTime()
    local md = gt and gt:getModData()
    local old = md and md[LEGACY_KEY]
    if type(old) == "table" then
        for id, zone in pairs(old) do
            local copy = normalize(NPCDialogue.deepCopy(zone), id)
            if copy and not zones[copy.id] then
                zones[copy.id] = copy
                n = n + 1
            end
        end
    end
    writeLines(marker, { now() .. ": imported " .. n .. " NPC(s) from GameTime modData key " .. LEGACY_KEY })
    return n
end

local function count(t)
    local n = 0
    for _ in pairs(t) do n = n + 1 end
    return n
end

function Store.save()
    local lines = serialize(zones)
    writeLines(path("npcs_backup.txt"), lines)
    return writeLines(path("npcs.txt"), lines)
end

function Store.load()
    if loaded then return end
    loaded = true
    zones = {}

    local main = path("npcs.txt")
    local zs, why, raw = readStore(main)
    if zs then
        zones = zs
    elseif why == "missing" then
        local n = importLegacy()
        if n > 0 then print("[NPCDialogue] imported " .. n .. " NPC(s) saved by the previous version") end
        Store.save()
    else
        print("[NPCDialogue] " .. main .. " is damaged (" .. tostring(why) .. ")")
        if raw then writeLines(path("npcs_damaged_" .. os.date("%Y%m%d_%H%M%S") .. ".txt"), raw) end
        local bz, bwhy = readStore(path("npcs_backup.txt"))
        if bz then
            zones = bz
            print("[NPCDialogue] recovered the NPCs from npcs_backup.txt")
            Store.save()
        else
            print("[NPCDialogue] npcs_backup.txt can't be used either (" .. tostring(bwhy)
                .. "). Starting without NPCs; the damaged file was kept next to it.")
        end
    end
    print("[NPCDialogue] " .. count(zones) .. " NPC(s) loaded from Zomboid/Lua/" .. main)
end

function Store.all()
    Store.load()
    return zones
end

function Store.get(id)
    Store.load()
    if id == nil then return nil end
    return zones[id]
end

function Store.findAt(x, y, z)
    Store.load()
    for _, zone in pairs(zones) do
        if zone.x == x and zone.y == y and zone.z == z then return zone end
    end
    return nil
end

function Store.put(zone)
    Store.load()
    zones[zone.id] = zone
    return Store.save()
end

function Store.remove(id, byWhom)
    Store.load()
    local zone = zones[id]
    if not zone then return nil end
    zones[id] = nil
    Store.save()
    local out = { "# removed " .. now() .. " by " .. tostring(byWhom or "?") }
    writeValue(out, id, zone, 0)
    writeLines(path("removed.txt"), out, true)
    return zone
end

function Store.log(line)
    writeLines(path("audit.txt"), { "[" .. now() .. "] " .. line }, true)
end

Store.normalize = normalize
