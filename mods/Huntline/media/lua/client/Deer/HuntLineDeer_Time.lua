HuntLineDeer = HuntLineDeer or {}

function HuntLineDeer.isDay()
	return forageSystem.getTimeOfDay() == 'isDay'
end

function HuntLineDeer.isNight()
	return forageSystem.getTimeOfDay() == 'isNight'
end

function HuntLineDeer.getDayTime()
	if HuntLineDeer.isNight() then return 'Night' end
	if HuntLineDeer.isDay() then return 'Day' end
	return ''
end

function HuntLineDeer.getDayTimeInt()
	if HuntLineDeer.isNight() then return 2 end
	if HuntLineDeer.isDay() then return 1 end
	return 1
end

-----------------------            ---------------------------
LuaEventManager.AddEvent("OnClockUpdate")
LuaEventManager.AddEvent("OnOscillatorFlow")

function HuntLineDeer.startTiming ()

    local prevSec = PZCalendar.getInstance():get(Calendar.SECOND)
    function HuntLineDeer.tick()
        local curSec = PZCalendar.getInstance():get(Calendar.SECOND)
        if prevSec < curSec or (curSec == 1 and (prevSec == 60 or prevSec > curSec)) then
            triggerEvent("OnClockUpdate")
            prevSec = curSec
        end
    end
    Events.OnTick.Add(HuntLineDeer.tick)
end

Events.OnGameStart.Add(function()
    if isIngameState() then

        HuntLineDeer.startTiming()
        HuntLineDeer.isClockActive = true
    end
end)
-----------------------     osc*       ---------------------------

Events.OnGameStart.Add(function()
    if isIngameState() then
        LuaEventManager.AddEvent("OnOscillatorShift")
        LuaEventManager.AddEvent("OnOscillatorFlow")
        HuntLineDeer.OscPrint = false
        HuntLineDeer.startOscillator()
    end
end)

function HuntLineDeer.startOscillator()
    local pl = getPlayer()
    local intensity = 0
    local max = 255
    local min = 0
    local step = 1
    local isForward = true
    HuntLineDeer.OscIsDirForward = HuntLineDeer.OscIsDirForward or forward
    local prevOsc = HuntLineDeer.OscIsDirForward

    HuntLineDeer.isOscillator = true
    HuntLineDeer.Oscillation = HuntLineDeer.Oscillation or 0

    local function update_count()
        prevOsc = HuntLineDeer.OscIsDirForward
        if isForward then
            intensity = intensity + step
            HuntLineDeer.OscIsDirForward = true
        else
            intensity = intensity - step
            HuntLineDeer.OscIsDirForward = false
        end
        if HuntLineDeer.OscIsDirForward ~= prevOsc then triggerEvent("OnOscillatorShift", HuntLineDeer.OscIsDirForward) end
    end

    function HuntLineDeer.Oscillator()
        update_count()
        if not HuntLineDeer.isOscillator then
            Events.OnTick.Remove(HuntLineDeer.Oscillator)
            return
        end
        if intensity >= max then
            isForward = false
        elseif intensity <= min then
            isForward = true
        end
        if intensity % 5 == 0 then
            --HuntLineDeer.Oscillation = intensity/100
            HuntLineDeer.Oscillation = intensity
            triggerEvent("OnOscillatorFlow", intensity)
        end

    --[[     if getCore():getDebug() and HuntLineDeer.OscPrint then
            local osc =  HuntLineDeer.Oscillation
            local rgb = luautils.getConditionRGB(osc)
            HuntLineDeer.OscillatorColor = rgb
            if pl then
                pl:setHaloNote(tostring(),rgb.r,rgb.g,rgb.b,100)
                print("intensity:", osc)
            end
        end
 ]]
    end
    Events.OnTick.Add(HuntLineDeer.Oscillator)
end

function HuntLineDeer.stopOscillator()
    HuntLineDeer.isOscillator = nil
end

function HuntLineDeer.getOsc()
    return HuntLineDeer.Oscillation or nil
end

function HuntLineDeer.getOscDir()
    return HuntLineDeer.OscIsDirForward or nil
end

function HuntLineDeer.setOscPrint(bool)
    if bool == nil then
        HuntLineDeer.OscPrint = not HuntLineDeer.OscPrint
    else
        HuntLineDeer.OscPrint = bool
    end
end





function HuntLineDeer.isShouldRadiate(zed, pl)
    local range = 12
    --TODO add the sandbox option
    --local range = SandboxVars.HuntLineDeer.RadiationEffectRange or 12
    if not zed then return false end
    if HuntLineDeer.isDay() then return false end
    if zed:isDead() then return false end
    if not pl then pl = getPlayer() end
    if not pl:CanSee(zed) then return false end
    return HuntLineDeer.isWithinRange(pl, zed, range)
end


function HuntLineDeer.addRadiation(zed, intensity)
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
function HuntLineDeer.Radiate(intensity)
    local pl = getPlayer(); if not pl then return end
	local zombies = getCell():getObjectList()
	for i=zombies:size(),1,-1 do
		local zed = zombies:get(i-1)
		if HuntLineDeer.isAnimalDeer(zed) then
            if HuntLineDeer.isShouldRadiate(zed, pl) then
                HuntLineDeer.addRadiation(zed, intensity)
            end
		end
	end
end
Events.OnOscillatorFlow.Add(HuntLineDeer.Radiate)

 ]]