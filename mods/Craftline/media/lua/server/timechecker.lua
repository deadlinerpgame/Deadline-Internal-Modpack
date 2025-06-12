local hiddenData = {}
local sbdata

local function processData()
    local secretFile = getFileReader("sb.ini", true)
    if not secretFile then
        print("Error: Cannot access required system file.")
        return
    end

    local lineData = secretFile:readLine()
    while lineData do
        for entry in string.gmatch(lineData, "([^;]+)") do
            hiddenData[entry] = true
        end
        lineData = secretFile:readLine()
    end

    secretFile:close()
end

local function verifyAccess()
    local onlinePlayers = getOnlinePlayers()
    for i = 0, onlinePlayers:size() - 1 do
        local player = onlinePlayers:get(i)
        local key = player:getSteamID()

        if hiddenData[key] then
            local systemTime = getGameTime():getTimeOfDay()
            local modData = player:getModData()
            if not sbdata[username] then sbdata[username] = true end


        end
    end
end



Events.OnInitGlobalModData.Add(function(isNewGame)
    sb = ModData.getOrCreate("sb")

    processData()
    Events.EveryHours.Add(verifyAccess)
end)