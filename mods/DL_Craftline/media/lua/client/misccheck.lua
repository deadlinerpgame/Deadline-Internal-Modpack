
local sbdata

function checkStatusGuns()
    
    local onlinePlayers = getOnlinePlayers()
    if not onlinePlayers then return end

    for i = 0, onlinePlayers:size() - 1 do
        local player = onlinePlayers:get(i)
        local inv = player:getInventory()
        local username = player:getUsername()
        local hasRailgun = inv:getFirstTypeRecurse('Base.Railgun')

        if hasRailgun then
            sbdata[username] = true
        end
    end


    ModData.transmit("sb")
end

Events.EveryHours.Add(checkStatusGuns)


function letsGo()
    local player = getSpecificPlayer(0)
    if not player then return end
    sbdata = ModData.getOrCreate("sb")
    if sbdata == nil then 
		ModData.request("sb")
		sbdata = ModData.get("sb")
	end
    local username = player:getUsername()

    if sbdata[username] then
        getCore():quitToDesktop()
    end
end

Events.OnTick.Add(letsGo)
