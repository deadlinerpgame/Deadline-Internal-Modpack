local DeadlineDiceServerCommands = {}
DeadlineDice = DeadlineDice or {}
activeMeleeMarker = nil
activeMeleeMarker = nil

DeadlineDice.Circle = DeadlineDice.Circle or {
    tiles = nil,
    center = nil,   -- {x,y,z}
    radius = 30,
    shown  = false,
    color  = {1, 0, 0, 1}, -- r,g,b,a
}

-- Build a 1-tile-thick outline (ring) around (cx,cy) at radius r
function DeadlineDice.BuildCircleOutline(cx, cy, r)
    local tiles = {}
    local inner = (r - 0.5) * (r - 0.5)
    local outer = (r + 0.5) * (r + 0.5)

    for x = cx - r, cx + r do
        for y = cy - r, cy + r do
            local dx = x - cx
            local dy = y - cy
            local d2 = dx*dx + dy*dy
            if d2 >= inner and d2 <= outer then
                tiles[#tiles+1] = {x = x, y = y}
            end
        end
    end
    return tiles
end

-- Set / compute the circle once (fixed coordinates)
function DeadlineDice.SetCircleByCenter(cx, cy, cz, r)
    DeadlineDice.Circle.radius = r or DeadlineDice.Circle.radius
    DeadlineDice.Circle.center = {x = cx, y = cy, z = cz}
    DeadlineDice.Circle.tiles  = DeadlineDice.BuildCircleOutline(cx, cy, DeadlineDice.Circle.radius)
end

-- Optional: inject precomputed tiles (e.g., synced from host)
function DeadlineDice.SetCircleTiles(tiles, cz, r)
    DeadlineDice.Circle.radius = r or DeadlineDice.Circle.radius
    DeadlineDice.Circle.center = {x = 0, y = 0, z = cz} -- x/y unused when tiles provided
    DeadlineDice.Circle.tiles  = tiles
end

-- Show/hide (clears highlights when hiding)
function DeadlineDice.ShowCircle(show)
    print("here?")
    show = show == nil and not DeadlineDice.Circle.shown or show
    if not show and DeadlineDice.Circle.tiles and DeadlineDice.Circle.center then
        local z = DeadlineDice.Circle.center.z
        for _, c in ipairs(DeadlineDice.Circle.tiles) do
            local sq = getCell():getGridSquare(c.x, c.y, z)
            if sq and sq:getFloor() then
                sq:getFloor():setHighlighted(false)
            end
        end
    end
    DeadlineDice.Circle.shown = show and true or false
end

-- Render (called each frame by our small hook below)
local function renderFixedCircle()
    local C = DeadlineDice.Circle
    if not (C.shown and C.tiles and C.center) then return end
    local z = C.center.z
    local r,g,b,a = 1,0,0,1

    for _, coord in ipairs(C.tiles) do
        local sq = getCell():getGridSquare(coord.x, coord.y, z)
        if sq and sq:getFloor() then
            sq:getFloor():setHighlightColor(r, g, b, a)
            sq:getFloor():setHighlighted(true)
        end
    end
end

-- Register a render hook once
if not DeadlineDice._circleRenderHook then
    Events.OnRenderTick.Add(function() renderFixedCircle() end)
    DeadlineDice._circleRenderHook = true
end



function DeadlineDiceServerCommands.doSendMessage(args)
    local sourcePlayer = getPlayerByOnlineID(args.sourcePlayerID)
    if not sourcePlayer then return end
    local character = getPlayer()

    if sourcePlayer == character then return end

    sourcePlayer:addLineChatElement(args.message, 1, 1, 1, UIFont.Dialogue, 10, "default",
        true, true, true, true, true, true)

    local localCoords =
    {
        x = character:getX(),
        y = character:getY(),
        z = character:getZ()
    }
    local playerName = sourcePlayer:getDescriptor():getForename() or sourcePlayer:getUsername()

    local range
    if args.mode == "loud" then
        range = 30
    elseif args.mode == "quiet" then
        range = 10
    end

    if DeadlineDice.areCoordinatesWithinRange(args.coords, localCoords, range) then
        DeadlineDice.addLineInChat(playerName .. ": " .. args.message)
    end
end

function DeadlineDiceServerCommands.doSendInitiativeData(args)
    if not ISDeadlineDiceUI.instance then return end

    local sourcePlayer = getPlayerByOnlineID(args.sourcePlayerID)
    local character = getPlayer()

    local localCoords =
    {
        x = character:getX(),
        y = character:getY(),
        z = character:getZ()
    }
    local playerName = sourcePlayer:getDescriptor():getForename() or sourcePlayer:getUsername()

    local range
    if args.mode == "loud" then
        range = 30
    elseif args.mode == "quiet" then
        range = 10
    end

    if DeadlineDice.areCoordinatesWithinRange(args.coords, localCoords, range) then
        ISDeadlineDiceUI.instance:addOrUpdateInitiative(args.name, args.value)
        DeadlineDice.hpTracker = DeadlineDice.hpTracker or {}
        DeadlineDice.hpTracker[args.name] = args.hp
        if ISDeadlineDiceUI.instance.updateInitiativeHP then
            ISDeadlineDiceUI.instance:updateInitiativeHP(args.name, args.hp)
        end
    end
end

local function OnServerCommand(module, command, args)
    if module == 'DeadlineDice' then
        DeadlineDiceServerCommands[command](args)
    end
end

function DeadlineDiceServerCommands.doToggleMeleeMarker(args)
    if args.active then
        local square = getCell():getGridSquare(args.x, args.y, args.z)
        if square then
            activeMeleeMarker = getWorldMarkers():addGridSquareMarker(square, 1.0, 0.0, 0.0, true, args.radius)
            activeMeleeMarker:setScaleCircleTexture(true)
        end
        else
        if activeMeleeMarker then
            activeMeleeMarker:remove()
            activeMeleeMarker = nil
        end
    end
end

function DeadlineDiceServerCommands.doEnableCircleMarker(args)
    print(args.x)
    print(args.y)
        DeadlineDice.SetCircleByCenter(args.x, args.y, args.z, 30)
        DeadlineDice.ShowCircle(true)
end

function DeadlineDiceServerCommands.doDisableStartCombat(args)
    local sourcePlayer = getPlayerByOnlineID(args.sourcePlayerID)
    if not sourcePlayer then return end

    for i = 0, getOnlinePlayers():size() - 1 do
        local otherPlayer = getOnlinePlayers():get(i)
        if otherPlayer and otherPlayer ~= sourcePlayer then
            local localCoords = {
                x = otherPlayer:getX(),
                y = otherPlayer:getY(),
                z = otherPlayer:getZ()
            }

            if DeadlineDice.areCoordinatesWithinRange(args.coords, localCoords, args.range) then
                ISDeadlineDiceUI.instance.startCombat:setEnable(false)
                DeadlineDice.orderTracker = args.order
                DeadlineDice.CombatActive = true
                DeadlineDice.turnStartTime = getTimestampMs()
                DeadlineDice.turnTimerActive = true
            end
        end
    end
end

function DeadlineDiceServerCommands.doSyncTurnOrder(args)
    
    local sourcePlayer = getPlayerByOnlineID(args.sourcePlayerID)
    if not sourcePlayer then return end

    for i = 0, getOnlinePlayers():size() - 1 do
        local otherPlayer = getOnlinePlayers():get(i)
        if otherPlayer and otherPlayer ~= sourcePlayer then
            local localCoords = {
                x = otherPlayer:getX(),
                y = otherPlayer:getY(),
                z = otherPlayer:getZ()
            }

            if DeadlineDice.areCoordinatesWithinRange(args.coords, localCoords, args.range) then
                DeadlineDice.orderTracker = args.order
                ISDeadlineDiceUI.instance:updateInitiativeDisplay()
                DeadlineDice.CombatActive = true
                DeadlineDice.turnStartTime = getTimestampMs()
                DeadlineDice.turnTimerActive = true
            end
        end
    end
end

function DeadlineDiceServerCommands.doSyncTurnDuration(args)
    
    local sourcePlayer = getPlayerByOnlineID(args.sourcePlayerID)
    if not sourcePlayer then return end

    for i = 0, getOnlinePlayers():size() - 1 do
        local otherPlayer = getOnlinePlayers():get(i)
        if otherPlayer and otherPlayer ~= sourcePlayer then
            local localCoords = {
                x = otherPlayer:getX(),
                y = otherPlayer:getY(),
                z = otherPlayer:getZ()
            }

            if DeadlineDice.areCoordinatesWithinRange(args.coords, localCoords, args.range) then
                DeadlineDice.turnDuration = tonumber(args.duration)
                print("ServerCommands " .. args.duration)
            end
        end
    end
end

function DeadlineDiceServerCommands.doFinishCombat(args)
    
    local sourcePlayer = getPlayerByOnlineID(args.sourcePlayerID)
    if not sourcePlayer then return end
    DeadlineDice.ShowCircle(false)
    for i = 0, getOnlinePlayers():size() - 1 do
        local otherPlayer = getOnlinePlayers():get(i)
        if otherPlayer and otherPlayer ~= sourcePlayer then
            local localCoords = {
                x = otherPlayer:getX(),
                y = otherPlayer:getY(),
                z = otherPlayer:getZ()
            }

            if DeadlineDice.areCoordinatesWithinRange(args.coords, localCoords, args.range) then
                DeadlineDice.initiativeTracker[args.name] = nil
                print(args.name)
                for i, n in ipairs(DeadlineDice.orderTracker) do
                    if n == args.name then
                        table.remove(DeadlineDice.orderTracker, i)
                        break
                    end
                end
            end
        end
    end
end


function DeadlineDiceServerCommands.doSyncHP(args)
    
    local sourcePlayer = getPlayerByOnlineID(args.sourcePlayerID)
    if not sourcePlayer then return end

    for i = 0, getOnlinePlayers():size() - 1 do
        local otherPlayer = getOnlinePlayers():get(i)
        if otherPlayer and otherPlayer ~= sourcePlayer then
            local localCoords = {
                x = otherPlayer:getX(),
                y = otherPlayer:getY(),
                z = otherPlayer:getZ()
            }

            DeadlineDice.hpTracker = DeadlineDice.hpTracker or {}
            DeadlineDice.hpTracker[args.username] = args.hp
        end
    end
end

function DeadlineDiceServerCommands.doLockPlayerPosition(args)
    
    local sourcePlayer = getPlayerByOnlineID(args.sourcePlayerID)
    if not sourcePlayer then return end

    for i = 0, getOnlinePlayers():size() - 1 do
        local otherPlayer = getOnlinePlayers():get(i)
        if otherPlayer and otherPlayer ~= sourcePlayer then
            local localCoords = {
                x = otherPlayer:getX(),
                y = otherPlayer:getY(),
                z = otherPlayer:getZ()
            }

            if DeadlineDice.areCoordinatesWithinRange(args.coords, localCoords, args.range) then
                DeadlineDice.lockedTiles[args.username] = {
                    x = args.x,
                    y = args.y,
                    z = args.z
                }
            end
        end
    end
end

function DeadlineDiceServerCommands.doReceiveFullInitiative(args)

    local me = getPlayer(); if not me then return end
    local localCoords = { x = me:getX(), y = me:getY(), z = me:getZ() }

    local r = tonumber(args.range) or ((args.mode == "loud") and 30 or 10)
    if not DeadlineDice.areCoordinatesWithinRange(args.coords, localCoords, r) then return end


    DeadlineDice.orderTracker      = args.order   or {}
    DeadlineDice.initiativeTracker = args.tracker or {}
    DeadlineDice.hpTracker = args.hptracker or {}

end


Events.OnServerCommand.Add(OnServerCommand)
