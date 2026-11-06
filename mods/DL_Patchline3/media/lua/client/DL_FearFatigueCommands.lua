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
    LogLineUtils.LogFromClient("InvalidStats", "Player command /resetfearfatigue reset fear and fatigue for player "
        .. tostring(player:getUsername()) .. ": fear=" .. tostring(fear)
        .. "; fatigue=" .. tostring(fatigue))
    WL_Utils.addInfoToChat("[Stats] Fear and fatigue reset to 0.")
end

local function registerCommands()
    if not (WRC and WRC.Commands and WRC.SpecialCommands) then return end
    WRC.Commands.DL_ShowFearFatigue = showStats
    WRC.Commands.DL_ResetFearFatigue = resetStats
    WRC.Commands.DL_ResetInvalidNeeds = function()
        local player = getPlayer()
        if not player then return end
        local repaired = InvalidStats_RepairNeeds(player) or {}
        if InvalidStats_IsNutritionInvalid(player) then
            ResetPlayerNutrition(player)
            table.insert(repaired, "invalid nutrition")
        end
        local result = #repaired > 0 and table.concat(repaired, ", ") or "none"
        LogLineUtils.LogFromClient("InvalidStats", "Player command /resetinvalidneeds for " .. tostring(player:getUsername()) .. ": " .. result)
        WL_Utils.addInfoToChat("[InvalidStats] Repaired: " .. result)
    end
    WRC.SpecialCommands["/resetinvalidneeds"] = {
        handler = "DL_ResetInvalidNeeds", tabHandlers = {}, usage = "/resetinvalidneeds",
        help = "Repair invalid needs, temperature, wetness and nutrition.", adminOnly = false,
    }
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
