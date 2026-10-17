DBNO = DBNO or {}

local READY_DELAY_MS = 750

local function installSleepHook()
    local vanillaSleep = ISWorldObjectContextMenu.onSleepWalkToComplete

    function ISWorldObjectContextMenu.onSleepWalkToComplete(playerIndex, bed)
        local playerObj = getSpecificPlayer(playerIndex)
        local wasAsleep = playerObj ~= nil and playerObj:isAsleep()

        vanillaSleep(playerIndex, bed)

        if playerObj == nil or wasAsleep then return end
        if not playerObj:isAsleep() then return end

        sendClientCommand(playerObj, "DBNOSnapshot", "sleepSave", { payload = DBNO.Snap.payload(playerObj) })
    end
end

installSleepHook()

local pending = {}

local function queueCharacterReady(player)
    if player == nil or not player:isLocalPlayer() then return end
    local md = player:getModData()
    if md.dbno_charInit == true then return end

    for _, entry in ipairs(pending) do
        if entry.player == player then return end
    end
    pending[#pending + 1] = { player = player, at = getTimestampMs() + READY_DELAY_MS }
end

Events.OnNewGame.Add(function(player)
    queueCharacterReady(player or getPlayer())
end)

Events.OnCreatePlayer.Add(function(playerIndex, player)
    queueCharacterReady(player)
end)

Events.OnTick.Add(function()
    if #pending == 0 then return end

    local now = getTimestampMs()
    local keep = {}
    for _, entry in ipairs(pending) do
        if now < entry.at then
            keep[#keep + 1] = entry
        else
            local player = entry.player
            if not player:isDead() then
                local md = player:getModData()
                md.dbno_charInit = true
                sendClientCommand(player, "DBNOSnapshot", "characterReady", { payload = DBNO.Snap.payload(player) })
            end
        end
    end
    pending = keep
end)
