HuntLinePig = HuntLinePig or {}

function HuntLinePig.setAnimSpeed(zed, int)
    if not int then
        int = HuntLinePig.getAnimSpeed(zed)
    end
    if zed:getVariableString('AnimSpeed') ~= tostring(int) then
        zed:setVariable('AnimSpeed', tonumber(int))
    end
end


function HuntLinePig.isZedOwner(user)
	if not user then user = getPlayer():getUsername() end
	local zInfo = getZombieInfo(zed)
	return zInfo.owner == user
end
function HuntLinePig.isDataSender(zed)
    if HuntLinePig.isAggro(zed) then
        return zed:getTarget() == true
    end
end

-- zed:isTargetVisible()

function HuntLinePig.getAnimSpeed(zed)
    local min = 0.75
    local max = 0.75
    local AnimSpeed = min
    if HuntLinePig.isAggro(zed) then
        local num = HuntLinePig.getOutfitNum(zed)
        if num == 0 then
            AnimSpeed = 1
        end
    end
    local res =  math.max(min, math.min(max, AnimSpeed)) or min
    return tonumber(res)
end


-----------------------            ---------------------------
function HuntLinePig.getMinAnimSpeed()
    return 1
end

function HuntLinePig.getMaxAnimSpeed()
    return 1
end
