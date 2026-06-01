if isClient() and not isServer() then return end
DL = DL or {}
DL.Config = DL.Config or {}
local C = DL.Config
C.lootLockMs              = C.lootLockMs              or 5 * 60 * 1000
C.lootDeleteAfterUnlockMs = C.lootDeleteAfterUnlockMs or 5 * 60 * 1000
C.lootRegistryGiveUpMs    = C.lootRegistryGiveUpMs    or 24 * 60 * 60 * 1000

DL.LootLock = DL.LootLock or {}
local LL = DL.LootLock
LL._entries = LL._entries or {}

local function regPath()
    return C.dataRoot .. "/_lootlock.txt"
end

local function saveRegistry()
    local lines = {}
    for _, e in ipairs(LL._entries) do
        lines[#lines + 1] = e.owner .. "|" .. tostring(e.x) .. "|" .. tostring(e.y)
            .. "|" .. tostring(e.z) .. "|" .. tostring(e.deleteAt)
    end
    DL.Files.writeLines(regPath(), lines)
end

local function loadRegistry()
    LL._entries = {}
    local lines = DL.Files.readLines(regPath())
    if lines == nil then return end
    for _, ln in ipairs(lines) do

        local owner, x, y, z, del =
            string.match(ln, "^(.-)|(%-?%d+)|(%-?%d+)|(%-?%d+)|(%-?%d+)$")
        if owner ~= nil then
            LL._entries[#LL._entries + 1] = {
                owner = owner, x = tonumber(x), y = tonumber(y),
                z = tonumber(z), deleteAt = tonumber(del),
            }
        end
    end
    DL.log("lootlock: loaded " .. #LL._entries .. " pending death-bag entr(ies)")
end

function LL.onDrop(bag, owner, square)
    if bag == nil or owner == nil or square == nil then return end
    local now       = getTimestampMs()
    local lockUntil = now + (C.lootLockMs or 0)
    local deleteAt  = lockUntil + (C.lootDeleteAfterUnlockMs or 0)

    local md = bag:getModData()
    md.dl_deathBag  = true
    md.dl_owner     = owner
    md.dl_lockUntil = lockUntil
    md.dl_deleteAt  = deleteAt

    LL._entries[#LL._entries + 1] = {
        owner = owner, x = square:getX(), y = square:getY(), z = square:getZ(),
        deleteAt = deleteAt,
    }
    saveRegistry()
    DL.log("lootlock: '" .. owner .. "' bag locked "
        .. tostring((C.lootLockMs or 0) / 1000) .. "s, deletes in "
        .. tostring((deleteAt - now) / 1000) .. "s")
end

local function removeExpiredBagsOnSquare(sq, now)
    local objs = sq:getWorldObjects()
    if objs == nil then return end
    for i = objs:size() - 1, 0, -1 do
        local wio = objs:get(i)
        local it  = wio and wio:getItem()
        local md  = it and it:getModData()
        if md and md.dl_deathBag and md.dl_deleteAt and md.dl_deleteAt <= now then
            sq:transmitRemoveItemFromSquare(wio)
            DL.log("lootlock: deleted expired death bag of '" .. tostring(md.dl_owner)
                .. "' at " .. sq:getX() .. "," .. sq:getY() .. "," .. sq:getZ())
        end
    end
end

function LL.sweep()
    if #LL._entries == 0 then return end
    local now  = getTimestampMs()
    local cell = getCell()
    if cell == nil then return end

    local kept, changed = {}, false
    for _, e in ipairs(LL._entries) do
        if now < e.deleteAt then
            kept[#kept + 1] = e
        else
            local sq = cell:getGridSquare(e.x, e.y, e.z)
            if sq ~= nil then
                removeExpiredBagsOnSquare(sq, now)
                changed = true
            elseif now >= e.deleteAt + (C.lootRegistryGiveUpMs or 0) then
                changed = true
            else
                kept[#kept + 1] = e
            end
        end
    end
    if changed then
        LL._entries = kept
        saveRegistry()
    end
end

Events.OnServerStarted.Add(function() loadRegistry() end)
Events.OnGameStart.Add(function() loadRegistry() end)
Events.EveryOneMinute.Add(function() LL.sweep() end)

DL.log("lootlock server loaded (stamp + auto-delete sweep)")
