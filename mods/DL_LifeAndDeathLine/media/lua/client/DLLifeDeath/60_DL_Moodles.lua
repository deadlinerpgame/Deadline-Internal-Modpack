DL = DL or {}

local ok = pcall(function() require "MF_ISMoodle" end)
if not ok or MF == nil or MF.createMoodle == nil then
    if DL.warn then DL.warn("MoodleFramework not installed; DL moodles disabled") end
    return
end

local function countToValue(n)
    if n == nil or n <= 0 then return 0.5 end
    if n == 1 then return 0.35 end
    if n == 2 then return 0.25 end
    return 0.15
end

MF.createMoodle("DLWounds")
MF.createMoodle("DLKnockdowns")

local function configMoodle(m)
    if m == nil then return end
    m:setThresholds(nil, 0.2, 0.3, 0.4, nil, nil, nil, nil)
end

Events.OnCreatePlayer.Add(function(playerNum)
    configMoodle(MF.getMoodle("DLWounds", playerNum))
    configMoodle(MF.getMoodle("DLKnockdowns", playerNum))
end)

local _lastReq = 0
Events.OnTick.Add(function()
    local p = getPlayer()
    if p == nil then return end
    local now = getTimestampMs()
    if (now - _lastReq) < 2500 then return end
    _lastReq = now
    sendClientCommand(p, "DLMoodle", "statusrequest", {})
end)

Events.OnServerCommand.Add(function(module, command, args)
    if module ~= "DLMoodle" or command ~= "status" or args == nil then return end
    local mw = MF.getMoodle("DLWounds", 0)
    if mw then mw:setValue(countToValue(args.w)) end
    local mk = MF.getMoodle("DLKnockdowns", 0)
    if mk then mk:setValue(countToValue(args.k)) end
end)

DL.log("moodles loaded (wounds + knockdowns, 3 levels each)")
