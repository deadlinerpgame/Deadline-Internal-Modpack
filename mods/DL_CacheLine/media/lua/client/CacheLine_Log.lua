require "LogLineUtils"

local CacheLineLog = {}

-- Group identical items, keeping each nested container's contents with it.
local function contentsString(inventory)
    local counts, keys = {}, {}
    local items = inventory:getItems()
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        local key = item:getFullType()
        if instanceof(item, "InventoryContainer") then
            key = key .. " {" .. contentsString(item:getInventory()) .. "}"
        end
        if not counts[key] then keys[#keys + 1] = key end
        counts[key] = (counts[key] or 0) + 1
    end
    table.sort(keys)
    local entries = {}
    for _, key in ipairs(keys) do
        entries[#entries + 1] = counts[key] .. " x " .. key
    end
    return table.concat(entries, "; ")
end

function CacheLineLog.spawn(player, square, bag, theme, cellKey, level, rate, oneIn, state, cellAwards)
    if not isClient() then return end
    local tracks = bag:getFullType() == "DLCacheLine.AnimalTracks"
    local message = string.format(
        "player=%s | find=(%d,%d,%d) | cell=%s | level=%d | rate=%s:1/%d | periodStart=%d | awards=%d | cellAwards=%d | theme=%s | bag=%s | contents=[%s]",
        player:getUsername(), square:getX(), square:getY(), square:getZ(), cellKey,
        level, rate, oneIn, state.periodStart, state.awards, cellAwards, theme,
        bag:getFullType(), tracks and "" or contentsString(bag:getInventory()))
    if tracks then message = "event=TRACKS_FOUND | " .. message end
    LogLineUtils.LogFromClient("CacheLine", message)
end

function CacheLineLog.animal(player, square, animal)
    if not isClient() then return end
    LogLineUtils.LogFromClient("CacheLine", string.format(
        "event=TRACKS_REDEEMED | player=%s | find=(%d,%d,%d) | animal=%s",
        player:getUsername(), square:getX(), square:getY(), square:getZ(), animal:getFullType()))
end

return CacheLineLog
