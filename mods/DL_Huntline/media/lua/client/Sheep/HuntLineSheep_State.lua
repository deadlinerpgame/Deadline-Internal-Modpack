
HuntLineSheep = HuntLineSheep or {}


function HuntLineSheep.isAggro(zed)
	local targ = zed:getTarget()
	if not targ then return false end
	return instanceof(targ, "IsoPlayer") and not targ:isInvisible()
end

function HuntLineSheep.isMoving(zed)
	if not zed then return false end
	return zed:getCurrentState() == WalkTowardState.instance() --or zed:isCurrentState(WalkTowardNetworkState.instance()) or zed:isCurrentState(PathFindState.instance())
end

-----------------------            ---------------------------


function HuntLineSheep.getState(zed)
    return zed:getCurrentState()
end
