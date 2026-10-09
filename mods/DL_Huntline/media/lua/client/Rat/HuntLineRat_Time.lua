HuntLineRat = HuntLineRat or {}

function HuntLineRat.isDay()
	return forageSystem.getTimeOfDay() == 'isDay'
end

function HuntLineRat.isNight()
	return forageSystem.getTimeOfDay() == 'isNight'
end

function HuntLineRat.getDayTime()
	if HuntLineRat.isNight() then return 'Night' end
	if HuntLineRat.isDay() then return 'Day' end
	return ''
end

function HuntLineRat.getDayTimeInt()
	if HuntLineRat.isNight() then return 2 end
	if HuntLineRat.isDay() then return 1 end
	return 1
end

-----------------------            ---------------------------
LuaEventManager.AddEvent("OnClockUpdate")
LuaEventManager.AddEvent("OnOscillatorFlow")

function HuntLineRat.startTiming ()

    local prevSec = PZCalendar.getInstance():get(Calendar.SECOND)
    function HuntLineRat.tick()
        local curSec = PZCalendar.getInstance():get(Calendar.SECOND)
        if prevSec < curSec or (curSec == 1 and (prevSec == 60 or prevSec > curSec)) then
            triggerEvent("OnClockUpdate")
            prevSec = curSec
        end
    end
    Events.OnTick.Add(HuntLineRat.tick)
end

Events.OnGameStart.Add(function()
    if isIngameState() then

        HuntLineRat.startTiming()
        HuntLineRat.isClockActive = true
    end
end)
-----------------------     osc*       ---------------------------

Events.OnGameStart.Add(function()
    if isIngameState() then
        LuaEventManager.AddEvent("OnOscillatorShift")
        LuaEventManager.AddEvent("OnOscillatorFlow")
        HuntLineRat.OscPrint = false
        HuntLineRat.startOscillator()
    end
end)

function HuntLineRat.startOscillator()
    local pl = getPlayer()
    local intensity = 0
    local max = 255
    local min = 0
    local step = 1
    local isForward = true
    HuntLineRat.OscIsDirForward = HuntLineRat.OscIsDirForward or forward
    local prevOsc = HuntLineRat.OscIsDirForward

    HuntLineRat.isOscillator = true
    HuntLineRat.Oscillation = HuntLineRat.Oscillation or 0

    local function update_count()
        prevOsc = HuntLineRat.OscIsDirForward
        if isForward then
            intensity = intensity + step
            HuntLineRat.OscIsDirForward = true
        else
            intensity = intensity - step
            HuntLineRat.OscIsDirForward = false
        end
        if HuntLineRat.OscIsDirForward ~= prevOsc then triggerEvent("OnOscillatorShift", HuntLineRat.OscIsDirForward) end
    end

    function HuntLineRat.Oscillator()
        update_count()
        if not HuntLineRat.isOscillator then
            Events.OnTick.Remove(HuntLineRat.Oscillator)
            return
        end
        if intensity >= max then
            isForward = false
        elseif intensity <= min then
            isForward = true
        end
        if intensity % 5 == 0 then
            --HuntLineRat.Oscillation = intensity/100
            HuntLineRat.Oscillation = intensity
            triggerEvent("OnOscillatorFlow", intensity)
        end

    --[[     if getCore():getDebug() and HuntLineRat.OscPrint then
            local osc =  HuntLineRat.Oscillation
            local rgb = luautils.getConditionRGB(osc)
            HuntLineRat.OscillatorColor = rgb
            if pl then
                pl:setHaloNote(tostring(),rgb.r,rgb.g,rgb.b,100)
                print("intensity:", osc)
            end
        end
 ]]
    end
    Events.OnTick.Add(HuntLineRat.Oscillator)
end

function HuntLineRat.stopOscillator()
    HuntLineRat.isOscillator = nil
end

function HuntLineRat.getOsc()
    return HuntLineRat.Oscillation or nil
end

function HuntLineRat.getOscDir()
    return HuntLineRat.OscIsDirForward or nil
end

function HuntLineRat.setOscPrint(bool)
    if bool == nil then
        HuntLineRat.OscPrint = not HuntLineRat.OscPrint
    else
        HuntLineRat.OscPrint = bool
    end
end





function HuntLineRat.isShouldRadiate(zed, pl)
    local range = 12
    --TODO add the sandbox option
    --local range = SandboxVars.HuntLineRat.RadiationEffectRange or 12
    if not zed then return false end
    if HuntLineRat.isDay() then return false end
    if zed:isDead() then return false end
    if not pl then pl = getPlayer() end
    if not pl:CanSee(zed) then return false end
    return HuntLineRat.isWithinRange(pl, zed, range)
end


function HuntLineRat.addRadiation(zed, intensity)
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
function HuntLineRat.Radiate(intensity)
    local pl = getPlayer(); if not pl then return end
	local zombies = getCell():getObjectList()
	for i=zombies:size(),1,-1 do
		local zed = zombies:get(i-1)
		if HuntLineRat.isAnimalRat(zed) then
            if HuntLineRat.isShouldRadiate(zed, pl) then
                HuntLineRat.addRadiation(zed, intensity)
            end
		end
	end
end
Events.OnOscillatorFlow.Add(HuntLineRat.Radiate)

 ]]