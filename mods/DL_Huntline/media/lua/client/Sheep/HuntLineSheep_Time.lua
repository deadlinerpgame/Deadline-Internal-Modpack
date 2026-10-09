HuntLineSheep = HuntLineSheep or {}

function HuntLineSheep.isDay()
	return forageSystem.getTimeOfDay() == 'isDay'
end

function HuntLineSheep.isNight()
	return forageSystem.getTimeOfDay() == 'isNight'
end

function HuntLineSheep.getDayTime()
	if HuntLineSheep.isNight() then return 'Night' end
	if HuntLineSheep.isDay() then return 'Day' end
	return ''
end

function HuntLineSheep.getDayTimeInt()
	if HuntLineSheep.isNight() then return 2 end
	if HuntLineSheep.isDay() then return 1 end
	return 1
end

-----------------------            ---------------------------
LuaEventManager.AddEvent("OnClockUpdate")
LuaEventManager.AddEvent("OnOscillatorFlow")

function HuntLineSheep.startTiming ()

    local prevSec = PZCalendar.getInstance():get(Calendar.SECOND)
    function HuntLineSheep.tick()
        local curSec = PZCalendar.getInstance():get(Calendar.SECOND)
        if prevSec < curSec or (curSec == 1 and (prevSec == 60 or prevSec > curSec)) then
            triggerEvent("OnClockUpdate")
            prevSec = curSec
        end
    end
    Events.OnTick.Add(HuntLineSheep.tick)
end

Events.OnGameStart.Add(function()
    if isIngameState() then

        HuntLineSheep.startTiming()
        HuntLineSheep.isClockActive = true
    end
end)
-----------------------     osc*       ---------------------------

Events.OnGameStart.Add(function()
    if isIngameState() then
        LuaEventManager.AddEvent("OnOscillatorShift")
        LuaEventManager.AddEvent("OnOscillatorFlow")
        HuntLineSheep.OscPrint = false
        HuntLineSheep.startOscillator()
    end
end)

function HuntLineSheep.startOscillator()
    local pl = getPlayer()
    local intensity = 0
    local max = 255
    local min = 0
    local step = 1
    local isForward = true
    HuntLineSheep.OscIsDirForward = HuntLineSheep.OscIsDirForward or forward
    local prevOsc = HuntLineSheep.OscIsDirForward

    HuntLineSheep.isOscillator = true
    HuntLineSheep.Oscillation = HuntLineSheep.Oscillation or 0

    local function update_count()
        prevOsc = HuntLineSheep.OscIsDirForward
        if isForward then
            intensity = intensity + step
            HuntLineSheep.OscIsDirForward = true
        else
            intensity = intensity - step
            HuntLineSheep.OscIsDirForward = false
        end
        if HuntLineSheep.OscIsDirForward ~= prevOsc then triggerEvent("OnOscillatorShift", HuntLineSheep.OscIsDirForward) end
    end

    function HuntLineSheep.Oscillator()
        update_count()
        if not HuntLineSheep.isOscillator then
            Events.OnTick.Remove(HuntLineSheep.Oscillator)
            return
        end
        if intensity >= max then
            isForward = false
        elseif intensity <= min then
            isForward = true
        end
        if intensity % 5 == 0 then
            --HuntLineSheep.Oscillation = intensity/100
            HuntLineSheep.Oscillation = intensity
            triggerEvent("OnOscillatorFlow", intensity)
        end

    --[[     if getCore():getDebug() and HuntLineSheep.OscPrint then
            local osc =  HuntLineSheep.Oscillation
            local rgb = luautils.getConditionRGB(osc)
            HuntLineSheep.OscillatorColor = rgb
            if pl then
                pl:setHaloNote(tostring(),rgb.r,rgb.g,rgb.b,100)
                print("intensity:", osc)
            end
        end
 ]]
    end
    Events.OnTick.Add(HuntLineSheep.Oscillator)
end

function HuntLineSheep.stopOscillator()
    HuntLineSheep.isOscillator = nil
end

function HuntLineSheep.getOsc()
    return HuntLineSheep.Oscillation or nil
end

function HuntLineSheep.getOscDir()
    return HuntLineSheep.OscIsDirForward or nil
end

function HuntLineSheep.setOscPrint(bool)
    if bool == nil then
        HuntLineSheep.OscPrint = not HuntLineSheep.OscPrint
    else
        HuntLineSheep.OscPrint = bool
    end
end





function HuntLineSheep.isShouldRadiate(zed, pl)
    local range = 12
    --TODO add the sandbox option
    --local range = SandboxVars.HuntLineSheep.RadiationEffectRange or 12
    if not zed then return false end
    if HuntLineSheep.isDay() then return false end
    if zed:isDead() then return false end
    if not pl then pl = getPlayer() end
    if not pl:CanSee(zed) then return false end
    return HuntLineSheep.isWithinRange(pl, zed, range)
end


function HuntLineSheep.addRadiation(zed, intensity)
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
function HuntLineSheep.Radiate(intensity)
    local pl = getPlayer(); if not pl then return end
	local zombies = getCell():getObjectList()
	for i=zombies:size(),1,-1 do
		local zed = zombies:get(i-1)
		if HuntLineSheep.isAnimalSheep(zed) then
            if HuntLineSheep.isShouldRadiate(zed, pl) then
                HuntLineSheep.addRadiation(zed, intensity)
            end
		end
	end
end
Events.OnOscillatorFlow.Add(HuntLineSheep.Radiate)

 ]]