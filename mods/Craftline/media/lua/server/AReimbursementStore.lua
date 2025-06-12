if not isServer() then return end

local serverPointsData

local function ReimburseTick()
    local players = getOnlinePlayers()

    for i = 0, players:size() - 1 do
        local username = players:get(i):getUsername()
        if not serverPointsData[username] then serverPointsData[username] = 0 end


    end
end


Events.OnInitGlobalModData.Add(function(isNewGame)
    serverPointsData = ModData.getOrCreate("serverPointsData")

    Events.EveryOneMinute.Add(ReimburseTick)
end)