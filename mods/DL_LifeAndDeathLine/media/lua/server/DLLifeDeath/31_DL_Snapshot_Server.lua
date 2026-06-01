DL = DL or {}
DL.Snap = DL.Snap or {}
DL.Snap._lastSave = DL.Snap._lastSave or {}

local function nowMs()
    if getTimestampMs then return getTimestampMs() end
    return (getTimestamp() or 0) * 1000
end

local function isStaff(player)
    local al = player.getAccessLevel and player:getAccessLevel() or ""
    return al ~= nil and al ~= "" and al ~= "None"
end

local function doSave(player)
    local username = player:getUsername()
    if username == nil then return end
    local staff = isStaff(player)
    local now = nowMs()
    if not staff then
        local last = DL.Snap._lastSave[username] or 0
        local cd = DL.Config.saveCooldownMs or (5 * 60 * 1000)
        if (now - last) < cd then
            local wait = math.ceil((cd - (now - last)) / 1000)
            sendServerCommand(player, "DLSnapshot", "saveResult", { ok = false, reason = "cooldown", wait = wait })
            return
        end
    end
    local enc = DL.Snap.encode(DL.Snap.build(player))
    local slot = DL.SnapStore.push(username, enc)
    local ok = slot and true or false
    if ok then
        if not staff then DL.Snap._lastSave[username] = now end

        ;(function()
            local path = DL.Paths.snapshotsDir(username) .. "/snapshot_" .. tostring(slot) .. "_items.txt"
            local out = {
                "Inventory at snapshot save -- user '" .. username .. "', slot " .. tostring(slot),
                "ts=" .. tostring(getTimestamp()),
                "",
            }
            for _, l in ipairs(DL.ItemTree.characterLines(player)) do out[#out + 1] = l end
            DL.Files.writeLines(path, out)
        end)()
    end
    sendServerCommand(player, "DLSnapshot", "saveResult", { ok = ok, staff = staff })
    DL.log("snapshot save for '" .. tostring(username) .. "' ok=" .. tostring(ok)
        .. (staff and " [staff bypass]" or "")
        .. " (slot " .. tostring(slot) .. ", kept " .. tostring(DL.SnapStore.count(username)) .. ")")
end

local function doRestore(player)
    local username = player:getUsername()
    if username == nil then return end
    local staff = isStaff(player)
    if not staff and DL.Flags.isRestoreUsed(username) then
        sendServerCommand(player, "DLSnapshot", "restoreResult", { ok = false, reason = "used" })
        return
    end
    local enc = DL.SnapStore.newest(username)
    if enc == nil then
        sendServerCommand(player, "DLSnapshot", "restoreResult", { ok = false, reason = "none" })
        return
    end
    local snap = DL.Snap.decode(enc)
    DL.Snap.apply(player, snap)
    if not staff then DL.Flags.markRestoreUsed(username) end
    sendServerCommand(player, "DLSnapshot", "applyRestore", { data = enc })
    DL.log("snapshot restored for '" .. tostring(username) .. "'" .. (staff and " [staff bypass]" or ""))
end

Events.OnClientCommand.Add(function(module, command, player, args)
    if module ~= "DLSnapshot" or player == nil then return end
    if command == "save" then
        ;(function() doSave(player) end)()
    elseif command == "restore" then
        ;(function() doRestore(player) end)()
    end
end)

Events.OnCharacterDeath.Add(function(character)
    if character and instanceof(character, "IsoPlayer") and character.getUsername then
        DL.Flags.resetRestore(character:getUsername())
    end
end)

DL.log("snapshot server wiring loaded")
