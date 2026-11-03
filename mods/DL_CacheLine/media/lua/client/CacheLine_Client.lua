require "Foraging/ISForageAction"
require "CacheLine_Config"
local CacheLineLog = require "CacheLine_Log"

local C = DLCacheLine.Config

local function debugPrint(format, ...)
    if C.debugPrints then
        print("[DL_CacheLine] " .. string.format(format, ...))
    end
end

local function randomCount(low, high)
    return low + ZombRand(high - low + 1)
end

local function fillBag(inventory, spec)
    local total = 0
    for _, entry in ipairs(spec.pool) do
        total = total + entry[2]
    end
    for _ = 1, randomCount(spec.rolls[1], spec.rolls[2]) do
        local roll = ZombRand(total)
        for _, entry in ipairs(spec.pool) do
            roll = roll - entry[2]
            if roll < 0 then
                local low = entry[3] or 1
                local count = randomCount(low, entry[4] or low)
                debugPrint("Bag contents: %dx %s", count, entry[1])
                for _ = 1, count do
                    inventory:AddItem(entry[1])
                end
                break
            end
        end
    end
end

local function chooseBag(player)
    local group
    for _, specialty in ipairs(DLCacheLine.Groups) do
        if player:HasTrait(specialty.condition.trait) then
            group = specialty
            break
        end
    end
    if not group then
        debugPrint("Skipped: no supported specialization")
        return
    end
    local roll = ZombRand(100)
    debugPrint("Selection roll=%d; own specialization=%s", roll, group.condition.trait)
    if roll >= C.specialtyPercent + C.anySpecialtyPercent + C.uniquePercent then
        debugPrint("Category: animal tracks")
        return DLCacheLine.AnimalTracks
    elseif roll >= C.specialtyPercent + C.anySpecialtyPercent then
        debugPrint("Category: high-value cache")
        return DLCacheLine.UniqueCache
    elseif roll >= C.specialtyPercent then
        group = DLCacheLine.Groups[ZombRand(#DLCacheLine.Groups) + 1]
        debugPrint("Category: any specialization; selected=%s", group.condition.trait)
    else
        debugPrint("Category: own specialization")
    end
    return group.items[ZombRand(#group.items) + 1]
end

local function award(player, square, haloNotes)
    local level = player:getPerkLevel(Perks.PlantScavenging)
    debugPrint("Pickup: player=%s; find=(%d,%d,%d); level=%d",
        player:getUsername(), square:getX(), square:getY(), square:getZ(), level)
    if level < C.minimumLevel then
        debugPrint("Skipped: level below %d", C.minimumLevel)
        return
    end

    -- There might be no way to get cell so doing some math :(
    local cellX = math.floor(square:getX() / 300)
    local cellY = math.floor(square:getY() / 300)
    local excluded = C.excluded
    if cellX >= excluded.minX and cellX <= excluded.maxX
        and cellY >= excluded.minY and cellY <= excluded.maxY then
        debugPrint("Skipped: excluded cell %d_%d", cellX, cellY)
        return
    end

    local md = player:getModData()
    local now = getTimestamp()
    local state = md.DL_ForageCaches
    if not state or now - state.periodStart >= C.periodSeconds then
        state = { periodStart = now, awards = 0, cells = {} }
        md.DL_ForageCaches = state
        debugPrint("Started/reset 20-hour period at %d", now)
    end

    local key = cellX .. "_" .. cellY
    local cell = state.cells[key]
    if not cell then
        local activationRoll = ZombRand(100)
        cell = { active = activationRoll < C.activePercent, awards = 0 }
        state.cells[key] = cell
        debugPrint("Cell %s activation roll=%d; active=%s", key, activationRoll, tostring(cell.active))
    end
    cell.awards = cell.awards or (cell.claimed and 1 or 0) -- Preserve old one-bag saves.
    cell.claimed = nil
    local cap = level >= C.higherCapLevel and C.higherCap or C.normalCap
    debugPrint("Cell %s: active=%s; cell awards=%d/%d; awards=%d; normal allowance=%d; period age=%ds",
        key, tostring(cell.active), cell.awards, C.maxPerCell, state.awards, cap, now - state.periodStart)
    if not cell.active or cell.awards >= C.maxPerCell then
        debugPrint("Skipped: cell inactive or per-cell limit reached")
        return
    end
    local oneIn = state.awards < cap and C.rewardOneIn or C.extraRewardOneIn
    if oneIn == 0 then
        debugPrint("Skipped: extra rewards disabled")
        return
    end
    local rewardRoll = ZombRand(oneIn)
    local rate = state.awards < cap and "normal" or "extra"
    debugPrint("Reward roll=%d of 0..%d (%s); zero wins", rewardRoll, oneIn - 1,
        rate)
    if rewardRoll ~= 0 then return end

    local variant = chooseBag(player)
    if not variant then return end
    local bag = InventoryItemFactory.CreateItem(variant.type)
    debugPrint("Filling bag: theme=%s; type=%s", variant.theme, variant.type)
    if not variant.tracks then
        local inventory = bag:getInventory()
        if variant.extras then fillBag(inventory, variant.extras) end
        fillBag(inventory, variant.contents)
    end

    if square:AddWorldInventoryItem(bag, 0.5, 0.5, 0) then
        cell.awards = cell.awards + 1
        state.awards = state.awards + 1
        debugPrint("SPAWNED: player=%s; theme=%s; bag=%s; cell=%s; awards=%d",
            player:getUsername(), variant.theme, variant.type, key, state.awards)
        local theme = getText("IGUI_CacheLine_" .. variant.theme)
        table.insert(haloNotes, variant.tracks and getText("IGUI_CacheLine_TracksFound")
            or getText("IGUI_CacheLine_Found", theme))
        CacheLineLog.spawn(player, square, bag, variant.theme, key, level,
            rate, oneIn, state, cell.awards)
    else
        debugPrint("Placement failed: no reward consumed")
    end
end

local originalForage = ISForageAction.forage
function ISForageAction:forage()
    originalForage(self)
    if self.discardItems or self.cacheLineProcessed then
        debugPrint("Skipped action: discard=%s; already processed=%s",
            tostring(self.discardItems), tostring(self.cacheLineProcessed == true))
        return
    end
    self.cacheLineProcessed = true
    award(self.character, self.forageIcon.square, self.manager.haloNotes)
end
