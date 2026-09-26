local function onUseBench(worldobjects, playerNum, bench)
    local player = getSpecificPlayer(playerNum)
    if not (player and bench) then return end
    local sq = bench:getSquare()
    if not sq then return end
    if luautils.walkAdj(player, sq, true) then
        ISTimedActionQueue.add(CULOpenBenchAction:new(player, bench))
    end
end

local function onFillWorldContext(playerNum, context, worldobjects, test)
    if test then return end
    local bench = ClothesUpgrade.Bench.findIn(worldobjects)
    if not bench then return end
    context:addOption("Use Clothing Bench", worldobjects, onUseBench, playerNum, bench)
end

Events.OnFillWorldObjectContextMenu.Add(onFillWorldContext)
