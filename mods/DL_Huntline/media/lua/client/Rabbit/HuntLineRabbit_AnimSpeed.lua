HuntLineRabbit = HuntLineRabbit or {}

function HuntLineRabbit.setAnimSpeed(zed, int)
    if not int then
        int = HuntLineRabbit.getAnimSpeed(zed)
    end
    if zed:getVariableString('AnimSpeed') ~= tostring(int) then
        zed:setVariable('AnimSpeed', tonumber(int))
    end
end


function HuntLineRabbit.isZedOwner(user)
	if not user then user = getPlayer():getUsername() end
	local zInfo = getZombieInfo(zed)
	return zInfo.owner == user
end
function HuntLineRabbit.isDataSender(zed)
    if HuntLineRabbit.isAggro(zed) then
        return zed:getTarget() == true
    end
end

-- zed:isTargetVisible()

function HuntLineRabbit.getAnimSpeed(zed)
    local min = 0.75
    local max = 0.75
    local AnimSpeed = min
    if HuntLineRabbit.isAggro(zed) then
        local num = HuntLineRabbit.getOutfitNum(zed)
        if num == 0 then
            AnimSpeed = 1
        end
    end
    local res =  math.max(min, math.min(max, AnimSpeed)) or min
    return tonumber(res)
end


-----------------------            ---------------------------
function HuntLineRabbit.getMinAnimSpeed()
    return 1
end

function HuntLineRabbit.getMaxAnimSpeed()
    return 1
end
