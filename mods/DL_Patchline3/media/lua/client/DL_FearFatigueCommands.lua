require "LogLineUtils"

local function showStats()
    local player = getPlayer()
    if not player then return end
    local stats = player:getStats()
    WL_Utils.addInfoToChat(string.format("[Stats] Fear: %.4f; fatigue: %.4f", stats:getFear(), stats:getFatigue()))
end

local function resetStats()
    local player = getPlayer()
    if not player then return end
    local stats = player:getStats()
    local fear, fatigue = stats:getFear(), stats:getFatigue()
    stats:setFear(0)
    stats:setFatigue(0)
    LogLineUtils.LogFromClient("InvalidStats", "Reset fear and fatigue for player "
        .. tostring(player:getUsername()) .. ": fear=" .. tostring(fear)
        .. "; fatigue=" .. tostring(fatigue))
    WL_Utils.addInfoToChat("[Stats] Fear and fatigue reset to 0.")
end

local function registerCommands()
    if not (WRC and WRC.Commands and WRC.SpecialCommands) then return end
    WRC.Commands.DL_ShowFearFatigue = showStats
    WRC.Commands.DL_ResetFearFatigue = resetStats
    WRC.SpecialCommands["/fearfatigue"] = {
        handler = "DL_ShowFearFatigue", tabHandlers = {}, usage = "/fearfatigue",
        help = "Show your fear and fatigue.", adminOnly = false,
    }
    WRC.SpecialCommands["/resetfearfatigue"] = {
        handler = "DL_ResetFearFatigue", tabHandlers = {}, usage = "/resetfearfatigue",
        help = "Reset your fear and fatigue.", adminOnly = false,
    }
end

Events.OnGameStart.Add(registerCommands)
