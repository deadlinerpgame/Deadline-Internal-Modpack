

DeadlineDice.frozenHighlightTiles = nil
DeadlineDice.moveTarget = nil
    local enabled = true
    local highlightsSquares = {}
    
Events.OnFillWorldObjectContextMenu.Add(function(playerIndex, context, worldObjects, test)
    
    if not (DeadlineDice.GunRangeMode or DeadlineDice.MovementRangeMode) then return end

    local player = getSpecificPlayer(playerIndex)
    if not player then return end

    -- Get the square under the mouse
    local square = nil
    for _, obj in ipairs(worldObjects) do
        if obj and obj:getSquare() then
            square = obj:getSquare()
            break
        end
    end

    if not square then return end

    local tx = square:getX()
    local ty = square:getY()
    local tz = square:getZ()

    context:addOption("Show Distance", square, function()
        local px = math.floor(player:getX())
        local py = math.floor(player:getY())

        local dx = math.abs(tx - px)
        local dy = math.abs(ty - py)
        local distance = math.max(dx, dy)

        player:Say("Distance: " .. distance .. " tile(s)")

        DeadlineDice.GunRangeMode = false
        DeadlineDice.MovementRangeMode = false
        DeadlineDice.frozenHighlightTiles = nil
    end)
    if DeadlineDice.MovementRangeMode then
    local px = math.floor(player:getX())
    local py = math.floor(player:getY())
    local dx = math.abs(tx - px)
    local dy = math.abs(ty - py)
    local distance = math.max(dx, dy)
    --[[
    if distance <= DeadlineDice.tileSteps then
        context:addOption("Move to", square, function()
            local username = player:getUsername()
            DeadlineDice.lockedTiles = DeadlineDice.lockedTiles or {}
            DeadlineDice.lockedTiles[username] = nil
            DeadlineDice.moveTarget = {x = tx, y = ty, z = tz}
            local square = getCell():getGridSquare(tx, ty, tz)
            if square then
                DeadlineDice.GunRangeMode = false
                DeadlineDice.MovementRangeMode = false
                DeadlineDice.frozenHighlightTiles = nil
                ISTimedActionQueue.add(ISWalkToTimedAction:new(player, square))

                DeadlineDice.tileSteps = DeadlineDice.tileSteps - distance
                DeadlineDice.tileStepsTaken = DeadlineDice.tileStepsTaken + distance
                print(DeadlineDice.tileSteps)

                end
            DeadlineDice.GunRangeMode = false
            DeadlineDice.MovementRangeMode = false
            DeadlineDice.frozenHighlightTiles = nil
        end)
    end 
    ]]  
    end
end)

Events.OnMouseDown.Add(function(x, y)
    --[[
    if not (DeadlineDice.GunRangeMode or DeadlineDice.MovementRangeMode) then return end

    local player = getSpecificPlayer(0)
    if not player then return end
    local z = player:getZ()

    local mx, my = ISCoordConversion.ToWorld(getMouseXScaled(), getMouseYScaled(), z)
    local tx = math.floor(mx + 0.5)
    local ty = math.floor(my + 0.5)

    local px = math.floor(player:getX() + 0.5)
    local py = math.floor(player:getY() + 0.5)

    DeadlineDice.frozenHighlightTiles = getLineBetween(px, py, tx, ty)
]]

    local player = getSpecificPlayer(0)
    if not player then return end
    local z = player:getZ()

    if DeadlineDice.GunRangeMode or DeadlineDice.MovementRangeMode then
        local mx, my = ISCoordConversion.ToWorld(getMouseXScaled(), getMouseYScaled(), z)
        local tx = math.floor(mx)
        local ty = math.floor(my)

        local px = math.floor(player:getX())
        local py = math.floor(player:getY())

        local dx = math.abs(tx - px)
        local dy = math.abs(ty - py)
        local distance = math.max(dx, dy)
            player:Say("") 
            player:Say("")
            player:Say("") 
            player:Say("")
            player:Say("Distance: " .. distance .. " tile(s)")
            print(px .. " - " .. py)

            DeadlineDice.lastSpokenDistance = distance
        end
end)

function AddHighlightSquare(square, ISColors)
    if not square or not ISColors then return end
    table.insert(highlightsSquares, {square = square, color = ISColors})
end

local highlightImages = {
    'media/ui/FloorTileCursor0.png',
    'media/ui/FloorTileCursor1.png',
    'media/ui/FloorTileCursor2.png',
    'media/ui/FloorTileCursor3.png',
    'media/ui/FloorTileCursor4.png',
    'media/ui/FloorTileCursor5.png',
    'media/ui/FloorTileCursor6.png',
    'media/ui/FloorTileCursor7.png',
    'media/ui/FloorTileCursor8.png',
    'media/ui/FloorTileCursor9.png',
    'media/ui/FloorTileCursor10.png',
    'media/ui/FloorTileCursor11.png',
    'media/ui/FloorTileCursor12.png',
    'media/ui/FloorTileCursor13.png',
    'media/ui/FloorTileCursor14.png',
    'media/ui/FloorTileCursor15.png',
    'media/ui/FloorTileCursor16.png',
    'media/ui/FloorTileCursor17.png',
    'media/ui/FloorTileCursor18.png',
    'media/ui/FloorTileCursor19.png',
    'media/ui/FloorTileCursor20.png',
    'media/ui/FloorTileCursor21.png',
    'media/ui/FloorTileCursor22.png',
    'media/ui/FloorTileCursor23.png',
    'media/ui/FloorTileCursor24.png',
    'media/ui/FloorTileCursor25.png',
    'media/ui/FloorTileCursor26.png',
}

function RenderHighLights()
    if not (DeadlineDice.GunRangeMode or DeadlineDice.MovementRangeMode) then return end
    if not enabled then return end
    if #highlightsSquares == 0 then return end

    for i, highlight in ipairs(highlightsSquares) do
        if highlight.square ~= nil and instanceof(highlight.square, "IsoGridSquare") then
            local x, y, z = highlight.square:getX(), highlight.square:getY(), highlight.square:getZ()
            local r, g, b, a = highlight.color.r, highlight.color.g, highlight.color.b, 0.8

            -- pick the image based on index (loop back if too many)
            local imageIndex = ((i - 1) % #highlightImages) + 1
            local imagePath = highlightImages[imageIndex]

            local floorSprite = IsoSprite.new()
            floorSprite:LoadFramesNoDirPageSimple(imagePath)
            floorSprite:RenderGhostTileColor(x, y, z, r, g, b, a)
        else
            print("Invalid square")
        end
    end

    highlightsSquares = {}
end


Events.OnRenderTick.Add(function()
    local player = getSpecificPlayer(0)
    if not player then return end
    local z = player:getZ()
if DeadlineDice.GunRangeMode or DeadlineDice.MovementRangeMode then
    local mx, my = ISCoordConversion.ToWorld(getMouseXScaled(), getMouseYScaled(), z)
    local tx = math.floor(mx)
    local ty = math.floor(my)

    local px = math.floor(player:getX())
    local py = math.floor(player:getY())

    local line = getLineBetween(px, py, tx, ty)

    for _, coord in ipairs(line) do
        local square = getCell():getGridSquare(coord.x, coord.y, z)
        if square and square:getFloor() then
            
            local dx = math.abs(coord.x - px)
            local dy = math.abs(coord.y - py)
            local dist = math.max(dx, dy)

            local r, g, b, a = 0, 0, 0, 0

            if DeadlineDice.GunRangeMode then
                if dist <= 25 then
                    r, g, b, a = 0, 1, 0, 0.5
                    AddHighlightSquare(square,{r=0.75, g=0.75, b=0.5, a=1})
                else

                end
            elseif DeadlineDice.MovementRangeMode then
                local purpleStepsRemaining = math.max(0, 7 - DeadlineDice.tileStepsTaken)
                if dist <= math.min(purpleStepsRemaining, DeadlineDice.tileSteps) then
                    r, g, b, a = 0, 1, 0, 0.5
                    AddHighlightSquare(square,{r=0.75, g=0.00, b=0.25, a=1})
                elseif dist <= DeadlineDice.tileSteps then
                    r, g, b, a = 1, 0.5, 0, 0.5
                    AddHighlightSquare(square,{r=0.75, g=0.00, b=0.25, a=1})
                else

                end
            end

            square:getFloor():setHighlightColor(r, g, b, a)
            square:getFloor():setHighlighted(true)

        end
    end
    
end




if DeadlineDice.frozenHighlightTiles then
    for _, coord in ipairs(DeadlineDice.frozenHighlightTiles) do
        local square = getCell():getGridSquare(coord.x, coord.y, z)
        if square and square:getFloor() then
            local px = math.floor(player:getX())
            local py = math.floor(player:getY())

            local dx = math.abs(coord.x - px)
            local dy = math.abs(coord.y - py)
            local dist = math.max(dx, dy)

            local r, g, b, a = 0, 0, 0, 0

            if DeadlineDice.GunRangeMode then
                if dist <= 25 then
                    r, g, b, a = 0, 1, 0, 0.5
                else

                end
            elseif DeadlineDice.MovementRangeMode then
                local purpleStepsRemaining = math.max(0, 7 - DeadlineDice.tileStepsTaken)
                if dist <= math.min(purpleStepsRemaining, DeadlineDice.tileSteps) then
                    r, g, b, a = 0, 1, 0, 0.5
                elseif dist <= DeadlineDice.tileSteps then
                    r, g, b, a = 1, 0.5, 0, 0.5
                else
                    
                end
            end

            square:getFloor():setHighlightColor(r, g, b, a)
            square:getFloor():setHighlighted(true)

        end
    end
end

end)


function getLineBetween(x0, y0, x1, y1)
    local tiles = {}
    local dx = math.abs(x1 - x0)
    local dy = math.abs(y1 - y0)
    local sx = x0 < x1 and 1 or -1
    local sy = y0 < y1 and 1 or -1
    local err = dx - dy

    while true do
        table.insert(tiles, { x = x0, y = y0 })
        if x0 == x1 and y0 == y1 then break end
        local e2 = 2 * err
        if e2 > -dy then
            err = err - dy
            x0 = x0 + sx
        end
        if e2 < dx then
            err = err + dx
            y0 = y0 + sy
        end
    end

    return tiles
end


Events.OnPlayerUpdate.Add(function(player)
    if not DeadlineDice.moveTarget then return end
            print("Player: " ..  player:getX() .. " " .. player:getY())
        print("Target: " .. DeadlineDice.moveTarget.x .. " " .. DeadlineDice.moveTarget.y)
        local px = math.floor(player:getX())
        local py = math.floor(player:getY())
    if px == DeadlineDice.moveTarget.x and py == DeadlineDice.moveTarget.y then

        -- Arrived at target, lock locally
        local username = player:getUsername()
        DeadlineDice.lockedTiles = DeadlineDice.lockedTiles or {}
        DeadlineDice.lockedTiles[username] = DeadlineDice.moveTarget
        DeadlineDice.moveTarget = nil
    end
end)

DeadlineDice.lastSpokenDistance = nil

Events.OnRenderTick.Add(function()
--[[
    local player = getSpecificPlayer(0)
    if not player then return end
    local z = player:getZ()

    if DeadlineDice.GunRangeMode or DeadlineDice.MovementRangeMode then
        local mx, my = ISCoordConversion.ToWorld(getMouseXScaled(), getMouseYScaled(), z)
        local tx = math.floor(mx + 0.5)
        local ty = math.floor(my + 0.5)

        local px = math.floor(player:getX())
        local py = math.floor(player:getY())

        local dx = math.abs(tx - px)
        local dy = math.abs(ty - py)
        local distance = math.max(dx, dy)
        if DeadlineDice.lastSpokenDistance ~= distance then
            player:Say("") 
            player:Say("")
            player:Say("") 
            player:Say("")
            player:Say("Distance: " .. distance .. " tile(s)")
            print(px .. " - " .. py)

            DeadlineDice.lastSpokenDistance = distance
        end
    else
        DeadlineDice.lastSpokenDistance = nil 
    end


]]
end)

Events.OnPostRender.Add(RenderHighLights)