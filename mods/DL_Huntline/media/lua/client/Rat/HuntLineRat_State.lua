
HuntLineRat = HuntLineRat or {}


function HuntLineRat.isAggro(zed)
	local targ = zed:getTarget()
    local wornItems = zed:getWornItems()
    if (zed:getHealth() > 0.5) then
    for i = wornItems:size() - 1, 0, -1 do
        local item = wornItems:get(i)
        local location = item:getLocation()
        
        if location ~= "Animal" then
            wornItems:remove(item)
        end
    end
	    zed:resetModel()
end
    

	if not targ then return false end

	return instanceof(targ, "IsoPlayer") and not targ:isInvisible()
	
	
end

function HuntLineRat.isMoving(zed)
	if not zed then return false end
	return zed:getCurrentState() == WalkTowardState.instance() --or zed:isCurrentState(WalkTowardNetworkState.instance()) or zed:isCurrentState(PathFindState.instance())
end

-----------------------            ---------------------------


function HuntLineRat.getState(zed)
    return zed:getCurrentState()
end
