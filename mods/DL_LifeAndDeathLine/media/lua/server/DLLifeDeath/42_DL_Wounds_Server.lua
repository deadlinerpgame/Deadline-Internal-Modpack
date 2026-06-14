if isClient() and not isServer() then return end
DL = DL or {}

local function onDeath(character)
    if not (character and instanceof(character, "IsoPlayer")) then return end

    local username = (function() return character:getUsername() end)()
    if username == nil then return end

    if not DL.Death.firstFire("wound", character) then
        DL.log("wound: duplicate OnCharacterDeath for '" .. username .. "' ignored")
        return
    end

    local knockdownOn = not (DL.Config and DL.Config.knockdownEnable == false)
    local isReal = (DL.Rescue and DL.Rescue.isRealDeath(username)) or false
    if DL.Rescue then DL.Rescue.clearRealDeath(username) end
    if knockdownOn and not isReal then
        DL.log("wound: rescue (overkill) death for '" .. username .. "', no wound counted")
        return
    end

    local n = DL.Wounds.add(username, 1)
    if DL.Players then DL.Players.touch(username) end
    DL.log("wound: '" .. username .. "' -> " .. tostring(n) .. " (threshold " .. tostring(DL.Config.woundThreshold) .. ")")

    local hc = DL.Config.holdingCell or { x = 0, y = 0, z = 0 }
    local toCell = (n >= DL.Config.woundThreshold)
    if toCell then
        DL.log("wound >= threshold: '" .. username .. "' will enter purgatory at ("
            .. hc.x .. "," .. hc.y .. "," .. hc.z .. ") on respawn")
    end

    (function()
        local rp = (DL.RespawnPt and DL.RespawnPt.get) and DL.RespawnPt.get(username) or { x = 10010, y = 11000, z = 0 }
        sendServerCommand(character, "DLWounds", "deathState",
            { toCell = toCell, x = hc.x, y = hc.y, z = hc.z, rx = rp.x, ry = rp.y, rz = rp.z })
    end)()
end
Events.OnCharacterDeath.Add(function(c) local _ = (function() onDeath(c) end)() end)

local function findItem(container, itemType)
    if container == nil then return nil end
    local items = container:getItems()
    if items == nil then return nil end
    for i = 0, items:size() - 1 do
        local it = items:get(i)
        if it ~= nil then
            if it:getFullType() == itemType then return it, container end
            local sub = it.getInventory and it:getInventory()
            if sub ~= nil then
                local f, c = findItem(sub, itemType)
                if f then return f, c end
            end
        end
    end
    return nil
end

local function doResetItem(player)
    local username = player:getUsername()
    if username == nil then return end
    local itemType = DL.Config.woundResetItem
    local it, cont = findItem(player:getInventory(), itemType)
    if it == nil then
        sendServerCommand(player, "DLWounds", "resetResult", { ok = false, reason = "noitem" })
        return
    end
    local _ = (function() cont:Remove(it) end)()
    DL.Wounds.set(username, 0)
    sendServerCommand(player, "DLWounds", "resetResult", { ok = true })
    DL.log("wound reset: '" .. username .. "' consumed " .. tostring(itemType) .. " -> wounds 0")
end

Events.OnClientCommand.Add(function(module, command, player, args)
    if module ~= "DLWounds" or player == nil then return end
    if command == "useResetItem" then
        local _ = (function() doResetItem(player) end)()
    end
end)

DL.log("wounds server wiring loaded (death increment + holding-cell branch + reset item)")
