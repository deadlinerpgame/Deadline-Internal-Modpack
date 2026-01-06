local CorpseTicketID = "Base.CorpseTicket3"

local Radius = 50


local function removeCorpseOnSquareIfContainsItem(square, corpse, itemFullType)
    if not square or not corpse or not itemFullType then return end

    local container = corpse:getContainer()

    local count = container:getItemCount(itemFullType)
    if count and count > 0 then
            local args = {
                x = math.floor(corpse:getX()),
                y = math.floor(corpse:getY()),
                z = corpse:getZ()
            }
            --sendClientCommand("DeadlineCorpse", "requestDeleteCorpse", args)
            square:removeCorpse(corpse, false)
            corpse:removeFromWorld()
            corpse:removeFromSquare()

        return true
    end
    return false
end

local function scanAroundPlayer(player)
    if not player or not player:getSquare() then return 0 end
    local px, py, pz = player:getX(), player:getY(), player:getZ()
    local removedCount = 0

    local minX = math.floor(px - Radius)
    local maxX = math.floor(px + Radius)
    local minY = math.floor(py - Radius)
    local maxY = math.floor(py + Radius)
    local z = math.floor(pz)

    local cell = getWorld():getCell()
    for x = minX, maxX do
        for y = minY, maxY do
            local sq = cell:getGridSquare(x, y, z)
            if sq then
                local bodies = sq:getDeadBodys()
                if bodies then
                    for i = 0, bodies:size() - 1 do
                        local corpse = bodies:get(i)
                        if corpse then
                            local removed = removeCorpseOnSquareIfContainsItem(sq, corpse, CorpseTicketID)
                            if removed then removedCount = removedCount + 1 end
                        end
                    end
                end
            end
        end
    end

    return removedCount
end

local function onEveryTenMinutes()
    local player = getPlayer() 
    local totalRemoved = 0

    totalRemoved = totalRemoved + scanAroundPlayer(player)


    if totalRemoved > 0 then
        print("[CorpseItemRemover] Removed " .. tostring(totalRemoved) .. " corpses containing " .. CorpseTicketID)
    end
end

Events.EveryOneMinute.Add(onEveryTenMinutes)
