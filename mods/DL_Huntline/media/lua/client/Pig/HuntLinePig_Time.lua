HuntLinePig = HuntLinePig or {}

function HuntLinePig.isDay()
	return forageSystem.getTimeOfDay() == 'isDay'
end

function HuntLinePig.isNight()
	return forageSystem.getTimeOfDay() == 'isNight'
end

function HuntLinePig.getDayTime()
	if HuntLinePig.isNight() then return 'Night' end
	if HuntLinePig.isDay() then return 'Day' end
	return ''
end

function HuntLinePig.getDayTimeInt()
	if HuntLinePig.isNight() then return 2 end
	if HuntLinePig.isDay() then return 1 end
	return 1
end

-----------------------            ---------------------------
LuaEventManager.AddEvent("OnClockUpdate")
LuaEventManager.AddEvent("OnOscillatorFlow")

function HuntLinePig.startTiming ()

    local prevSec = PZCalendar.getInstance():get(Calendar.SECOND)
    function HuntLinePig.tick()
        local curSec = PZCalendar.getInstance():get(Calendar.SECOND)
        if prevSec < curSec or (curSec == 1 and (prevSec == 60 or prevSec > curSec)) then
            triggerEvent("OnClockUpdate")
            prevSec = curSec
        end
    end
    Events.OnTick.Add(HuntLinePig.tick)
end

Events.OnGameStart.Add(function()
    if isIngameState() then

        HuntLinePig.startTiming()
        HuntLinePig.isClockActive = true
    end
end)
-----------------------     osc*       ---------------------------

Events.OnGameStart.Add(function()
    if isIngameState() then
        LuaEventManager.AddEvent("OnOscillatorShift")
        LuaEventManager.AddEvent("OnOscillatorFlow")
        HuntLinePig.OscPrint = false
        HuntLinePig.startOscillator()
    end
end)

function HuntLinePig.startOscillator()
    local pl = getPlayer()
    local intensity = 0
    local max = 255
    local min = 0
    local step = 1
    local isForward = true
    HuntLinePig.OscIsDirForward = HuntLinePig.OscIsDirForward or forward
    local prevOsc = HuntLinePig.OscIsDirForward

    HuntLinePig.isOscillator = true
    HuntLinePig.Oscillation = HuntLinePig.Oscillation or 0

    local function update_count()
        prevOsc = HuntLinePig.OscIsDirForward
        if isForward then
            intensity = intensity + step
            HuntLinePig.OscIsDirForward = true
        else
            intensity = intensity - step
            HuntLinePig.OscIsDirForward = false
        end
        if HuntLinePig.OscIsDirForward ~= prevOsc then triggerEvent("OnOscillatorShift", HuntLinePig.OscIsDirForward) end
    end

    function HuntLinePig.Oscillator()
        update_count()
        if not HuntLinePig.isOscillator then
            Events.OnTick.Remove(HuntLinePig.Oscillator)
            return
        end
        if intensity >= max then
            isForward = false
        elseif intensity <= min then
            isForward = true
        end
        if intensity % 5 == 0 then
            --HuntLinePig.Oscillation = intensity/100
            HuntLinePig.Oscillation = intensity
            triggerEvent("OnOscillatorFlow", intensity)
        end

    --[[     if getCore():getDebug() and HuntLinePig.OscPrint then
            local osc =  HuntLinePig.Oscillation
            local rgb = luautils.getConditionRGB(osc)
            HuntLinePig.OscillatorColor = rgb
            if pl then
                pl:setHaloNote(tostring(),rgb.r,rgb.g,rgb.b,100)
                print("intensity:", osc)
            end
        end
 ]]
    end
    Events.OnTick.Add(HuntLinePig.Oscillator)
end

function HuntLinePig.stopOscillator()
    HuntLinePig.isOscillator = nil
end

function HuntLinePig.getOsc()
    return HuntLinePig.Oscillation or nil
end

function HuntLinePig.getOscDir()
    return HuntLinePig.OscIsDirForward or nil
end

function HuntLinePig.setOscPrint(bool)
    if bool == nil then
        HuntLinePig.OscPrint = not HuntLinePig.OscPrint
    else
        HuntLinePig.OscPrint = bool
    end
end





function HuntLinePig.isShouldRadiate(zed, pl)
    local range = 12
    --TODO add the sandbox option
    --local range = SandboxVars.HuntLinePig.RadiationEffectRange or 12
    if not zed then return false end
    if HuntLinePig.isDay() then return false end
    if zed:isDead() then return false end
    if not pl then pl = getPlayer() end
    if not pl:CanSee(zed) then return false end
    return HuntLinePig.isWithinRange(pl, zed, range)
end


function HuntLinePig.addRadiation(zed, intensity)
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
function HuntLinePig.Radiate(intensity)
    local pl = getPlayer(); if not pl then return end
	local zombies = getCell():getObjectList()
	for i=zombies:size(),1,-1 do
		local zed = zombies:get(i-1)
		if HuntLinePig.isAnimalPig(zed) then
            if HuntLinePig.isShouldRadiate(zed, pl) then
                HuntLinePig.addRadiation(zed, intensity)
            end
		end
	end
end
Events.OnOscillatorFlow.Add(HuntLinePig.Radiate)

 ]]