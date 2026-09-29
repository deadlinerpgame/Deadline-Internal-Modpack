HuntLineRabbit = HuntLineRabbit or {}

function HuntLineRabbit.isDay()
	return forageSystem.getTimeOfDay() == 'isDay'
end

function HuntLineRabbit.isNight()
	return forageSystem.getTimeOfDay() == 'isNight'
end

function HuntLineRabbit.getDayTime()
	if HuntLineRabbit.isNight() then return 'Night' end
	if HuntLineRabbit.isDay() then return 'Day' end
	return ''
end

function HuntLineRabbit.getDayTimeInt()
	if HuntLineRabbit.isNight() then return 2 end
	if HuntLineRabbit.isDay() then return 1 end
	return 1
end

-----------------------            ---------------------------
LuaEventManager.AddEvent("OnClockUpdate")
LuaEventManager.AddEvent("OnOscillatorFlow")

function HuntLineRabbit.startTiming ()

    local prevSec = PZCalendar.getInstance():get(Calendar.SECOND)
    function HuntLineRabbit.tick()
        local curSec = PZCalendar.getInstance():get(Calendar.SECOND)
        if prevSec < curSec or (curSec == 1 and (prevSec == 60 or prevSec > curSec)) then
            triggerEvent("OnClockUpdate")
            prevSec = curSec
        end
    end
    Events.OnTick.Add(HuntLineRabbit.tick)
end

Events.OnGameStart.Add(function()
    if isIngameState() then

        HuntLineRabbit.startTiming()
        HuntLineRabbit.isClockActive = true
    end
end)
-----------------------     osc*       ---------------------------

Events.OnGameStart.Add(function()
    if isIngameState() then
        LuaEventManager.AddEvent("OnOscillatorShift")
        LuaEventManager.AddEvent("OnOscillatorFlow")
        HuntLineRabbit.OscPrint = false
        HuntLineRabbit.startOscillator()
    end
end)

function HuntLineRabbit.startOscillator()
    local pl = getPlayer()
    local intensity = 0
    local max = 255
    local min = 0
    local step = 1
    local isForward = true
    HuntLineRabbit.OscIsDirForward = HuntLineRabbit.OscIsDirForward or forward
    local prevOsc = HuntLineRabbit.OscIsDirForward

    HuntLineRabbit.isOscillator = true
    HuntLineRabbit.Oscillation = HuntLineRabbit.Oscillation or 0

    local function update_count()
        prevOsc = HuntLineRabbit.OscIsDirForward
        if isForward then
            intensity = intensity + step
            HuntLineRabbit.OscIsDirForward = true
        else
            intensity = intensity - step
            HuntLineRabbit.OscIsDirForward = false
        end
        if HuntLineRabbit.OscIsDirForward ~= prevOsc then triggerEvent("OnOscillatorShift", HuntLineRabbit.OscIsDirForward) end
    end

    function HuntLineRabbit.Oscillator()
        update_count()
        if not HuntLineRabbit.isOscillator then
            Events.OnTick.Remove(HuntLineRabbit.Oscillator)
            return
        end
        if intensity >= max then
            isForward = false
        elseif intensity <= min then
            isForward = true
        end
        if intensity % 5 == 0 then
            --HuntLineRabbit.Oscillation = intensity/100
            HuntLineRabbit.Oscillation = intensity
            triggerEvent("OnOscillatorFlow", intensity)
        end

    --[[     if getCore():getDebug() and HuntLineRabbit.OscPrint then
            local osc =  HuntLineRabbit.Oscillation
            local rgb = luautils.getConditionRGB(osc)
            HuntLineRabbit.OscillatorColor = rgb
            if pl then
                pl:setHaloNote(tostring(),rgb.r,rgb.g,rgb.b,100)
                print("intensity:", osc)
            end
        end
 ]]
    end
    Events.OnTick.Add(HuntLineRabbit.Oscillator)
end

function HuntLineRabbit.stopOscillator()
    HuntLineRabbit.isOscillator = nil
end

function HuntLineRabbit.getOsc()
    return HuntLineRabbit.Oscillation or nil
end

function HuntLineRabbit.getOscDir()
    return HuntLineRabbit.OscIsDirForward or nil
end

function HuntLineRabbit.setOscPrint(bool)
    if bool == nil then
        HuntLineRabbit.OscPrint = not HuntLineRabbit.OscPrint
    else
        HuntLineRabbit.OscPrint = bool
    end
end





function HuntLineRabbit.isShouldRadiate(zed, pl)
    local range = 12
    --TODO add the sandbox option
    --local range = SandboxVars.HuntLineRabbit.RadiationEffectRange or 12
    if not zed then return false end
    if HuntLineRabbit.isDay() then return false end
    if zed:isDead() then return false end
    if not pl then pl = getPlayer() end
    if not pl:CanSee(zed) then return false end
    return HuntLineRabbit.isWithinRange(pl, zed, range)
end


function HuntLineRabbit.addRadiation(zed, intensity)
    if not zed then return end
    local cell = getCell()
    local radiation
    local lastGlow = zed:getModData()['radiation']

    local x, y, z = zed:getX(), zed:getY(), zed:getZ()
    if lastGlow then
        cell:removeLamppost(lastGlow)
    end
    if x and y and z  then
        lastGlow = IsoLightSource.new(x, y, z, 25, 255, 110, intensity)
        cell:addLamppost(lastGlow)
        zed:getModData()['radiation'] = lastGlow
    end
end



--[[
function HuntLineRabbit.Radiate(intensity)
    local pl = getPlayer(); if not pl then return end
	local zombies = getCell():getObjectList()
	for i=zombies:size(),1,-1 do
		local zed = zombies:get(i-1)
		if HuntLineRabbit.isAnimalRabbit(zed) then
            if HuntLineRabbit.isShouldRadiate(zed, pl) then
                HuntLineRabbit.addRadiation(zed, intensity)
            end
		end
	end
end
Events.OnOscillatorFlow.Add(HuntLineRabbit.Radiate)

 ]]