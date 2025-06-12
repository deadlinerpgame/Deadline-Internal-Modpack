HuntLineCow = HuntLineCow or {}

function HuntLineCow.isDay()
	return forageSystem.getTimeOfDay() == 'isDay'
end

function HuntLineCow.isNight()
	return forageSystem.getTimeOfDay() == 'isNight'
end

function HuntLineCow.getDayTime()
	if HuntLineCow.isNight() then return 'Night' end
	if HuntLineCow.isDay() then return 'Day' end
	return ''
end

function HuntLineCow.getDayTimeInt()
	if HuntLineCow.isNight() then return 2 end
	if HuntLineCow.isDay() then return 1 end
	return 1
end

-----------------------            ---------------------------
LuaEventManager.AddEvent("OnClockUpdate")
LuaEventManager.AddEvent("OnOscillatorFlow")

function HuntLineCow.startTiming ()

    local prevSec = PZCalendar.getInstance():get(Calendar.SECOND)
    function HuntLineCow.tick()
        local curSec = PZCalendar.getInstance():get(Calendar.SECOND)
        if prevSec < curSec or (curSec == 1 and (prevSec == 60 or prevSec > curSec)) then
            triggerEvent("OnClockUpdate")
            prevSec = curSec
        end
    end
    Events.OnTick.Add(HuntLineCow.tick)
end

Events.OnGameStart.Add(function()
    if isIngameState() then

        HuntLineCow.startTiming()
        HuntLineCow.isClockActive = true
    end
end)
-----------------------     osc*       ---------------------------

Events.OnGameStart.Add(function()
    if isIngameState() then
        LuaEventManager.AddEvent("OnOscillatorShift")
        LuaEventManager.AddEvent("OnOscillatorFlow")
        HuntLineCow.OscPrint = false
        HuntLineCow.startOscillator()
    end
end)

function HuntLineCow.startOscillator()
    local pl = getPlayer()
    local intensity = 0
    local max = 255
    local min = 0
    local step = 1
    local isForward = true
    HuntLineCow.OscIsDirForward = HuntLineCow.OscIsDirForward or forward
    local prevOsc = HuntLineCow.OscIsDirForward

    HuntLineCow.isOscillator = true
    HuntLineCow.Oscillation = HuntLineCow.Oscillation or 0

    local function update_count()
        prevOsc = HuntLineCow.OscIsDirForward
        if isForward then
            intensity = intensity + step
            HuntLineCow.OscIsDirForward = true
        else
            intensity = intensity - step
            HuntLineCow.OscIsDirForward = false
        end
        if HuntLineCow.OscIsDirForward ~= prevOsc then triggerEvent("OnOscillatorShift", HuntLineCow.OscIsDirForward) end
    end

    function HuntLineCow.Oscillator()
        update_count()
        if not HuntLineCow.isOscillator then
            Events.OnTick.Remove(HuntLineCow.Oscillator)
            return
        end
        if intensity >= max then
            isForward = false
        elseif intensity <= min then
            isForward = true
        end
        if intensity % 5 == 0 then
            --HuntLineCow.Oscillation = intensity/100
            HuntLineCow.Oscillation = intensity
            triggerEvent("OnOscillatorFlow", intensity)
        end

    --[[     if getCore():getDebug() and HuntLineCow.OscPrint then
            local osc =  HuntLineCow.Oscillation
            local rgb = luautils.getConditionRGB(osc)
            HuntLineCow.OscillatorColor = rgb
            if pl then
                pl:setHaloNote(tostring(),rgb.r,rgb.g,rgb.b,100)
                print("intensity:", osc)
            end
        end
 ]]
    end
    Events.OnTick.Add(HuntLineCow.Oscillator)
end

function HuntLineCow.stopOscillator()
    HuntLineCow.isOscillator = nil
end

function HuntLineCow.getOsc()
    return HuntLineCow.Oscillation or nil
end

function HuntLineCow.getOscDir()
    return HuntLineCow.OscIsDirForward or nil
end

function HuntLineCow.setOscPrint(bool)
    if bool == nil then
        HuntLineCow.OscPrint = not HuntLineCow.OscPrint
    else
        HuntLineCow.OscPrint = bool
    end
end





function HuntLineCow.isShouldRadiate(zed, pl)
    local range = 12
    --TODO add the sandbox option
    --local range = SandboxVars.HuntLineCow.RadiationEffectRange or 12
    if not zed then return false end
    if HuntLineCow.isDay() then return false end
    if zed:isDead() then return false end
    if not pl then pl = getPlayer() end
    if not pl:CanSee(zed) then return false end
    return HuntLineCow.isWithinRange(pl, zed, range)
end


function HuntLineCow.addRadiation(zed, intensity)
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
function HuntLineCow.Radiate(intensity)
    local pl = getPlayer(); if not pl then return end
	local zombies = getCell():getObjectList()
	for i=zombies:size(),1,-1 do
		local zed = zombies:get(i-1)
		if HuntLineCow.isAnimalCow(zed) then
            if HuntLineCow.isShouldRadiate(zed, pl) then
                HuntLineCow.addRadiation(zed, intensity)
            end
		end
	end
end
Events.OnOscillatorFlow.Add(HuntLineCow.Radiate)

 ]]