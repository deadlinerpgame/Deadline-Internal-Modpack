HuntLineCow = HuntLineCow or {}

function HuntLineCow.setAnimSpeed(zed, int)
    if not int then
        int = HuntLineCow.getAnimSpeed(zed)
    end
    if zed:getVariableString('AnimSpeed') ~= tostring(int) then
        zed:setVariable('AnimSpeed', tonumber(int))
    end
end


function HuntLineCow.isZedOwner(user)
	if not user then user = getPlayer():getUsername() end
	local zInfo = getZombieInfo(zed)
	return zInfo.owner == user
end
function HuntLineCow.isDataSender(zed)
    if HuntLineCow.isAggro(zed) then
        return zed:getTarget() == true
    end
end

-- zed:isTargetVisible()

function HuntLineCow.getAnimSpeed(zed)
    local min = 0.75
    local max = 0.75
    local AnimSpeed = min
    if HuntLineCow.isAggro(zed) then
        local num = HuntLineCow.getOutfitNum(zed)
        if num == 0 then
            AnimSpeed = 1
        end
    end
    local res =  math.max(min, math.min(max, AnimSpeed)) or min
    return tonumber(res)
end


-----------------------            ---------------------------
function HuntLineCow.getMinAnimSpeed()
    return 1
end

function HuntLineCow.getMaxAnimSpeed()
    return 1
end
