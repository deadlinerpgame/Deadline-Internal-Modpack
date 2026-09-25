SearchPlayer = SearchPlayer or {}


function SearchPlayer.getContextOptionText(otherPlayer)
    return getText("UI_SearchStub", otherPlayer:getDescriptor():getForename())
end

function SearchPlayer.onContextSelected(worldobjects, playerObj, otherPlayer)
    print(playerObj:getDescriptor():getForename() .. " is searching " .. otherPlayer:getDescriptor():getForename());
    print(playerObj:getDescriptor():getForename() .. " : " .. playerObj:getOnlineID())
    print(otherPlayer:getDescriptor():getForename() .. " : " .. otherPlayer:getOnlineID())
    if luautils.walkAdj(playerObj, otherPlayer:getCurrentSquare()) then
        ISTimedActionQueue.add(SearchPlayerAction:new(playerObj, otherPlayer))
    end
end

function SearchPlayer.createContextOption(player, context, worldObjects)
    local playerObj = getSpecificPlayer(player);

    local otherPlayer;

    local square;

    for _, v in ipairs(worldObjects) do
        square = v:getSquare();
        local movingObjects = square:getMovingObjects()
        for i = 0, movingObjects:size() - 1 do
            local o = movingObjects:get(i)
            if instanceof(o, "IsoPlayer") and o ~= playerObj then
                otherPlayer = o;
                break
            end
        end
    end

    if square and not otherPlayer then
        local squareX = square:getX()
        local squareY = square:getY()
        local squareZ = square:getZ()
        for x=squareX-1,squareX+1 do
            for y=squareY-1,squareY+1 do
                local sq = getCell():getGridSquare(x,y,squareZ);
                if sq then
                    local movingObjects = sq:getMovingObjects()
                    for i=0,movingObjects:size()-1 do
                        local o = movingObjects:get(i)
                        if instanceof(o, "IsoPlayer") and (o ~= playerObj) then
                            otherPlayer = o
                        end
                    end
                end
            end
        end
    end

    if otherPlayer and not otherPlayer:isAsleep() and isClient() and not getPlayer():isInvisible() then

        local text = SearchPlayer.getContextOptionText(otherPlayer)
        local option = context:addOption(text, worldObjects, SearchPlayer.onContextSelected, playerObj, otherPlayer)
        if math.abs(playerObj:getX() - otherPlayer:getX()) > 2 or math.abs(playerObj:getY() - otherPlayer:getY()) > 2 then
            local tooltip = ISWorldObjectContextMenu.addToolTip();
            option.notAvailable = true;
            tooltip.description = getText("UI_SearchingGetCloser");
            option.toolTip = tooltip;
        end
    end
end


Events.OnFillWorldObjectContextMenu.Add(SearchPlayer.createContextOption)