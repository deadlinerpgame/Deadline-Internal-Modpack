DL = DL or {}
DL.Wounds = DL.Wounds or {}
DL.Wounds.pendingToCell = DL.Wounds.pendingToCell or false
DL.Wounds.cell = DL.Wounds.cell or nil

local function notify(msg)
    local p = getPlayer()
    if p == nil then return end
    if HaloTextHelper and HaloTextHelper.addText then
        local _ = (function() HaloTextHelper.addText(p, msg) end)()
    else
        local _ = (function() p:Say(msg) end)()
    end
end

local function teleportTo(player, cell)
    local _ = (function()
        player:setX(cell.x);  player:setY(cell.y);  player:setZ(cell.z)
        player:setLx(cell.x); player:setLy(cell.y); player:setLz(cell.z)
        local sq = getCell() and getCell():getGridSquare(cell.x, cell.y, cell.z)
        if sq then player:setSquare(sq) end
    end)()
end

Events.OnCreatePlayer.Add(function(playerIndex, player)
    if not DL.Wounds.pendingToCell then return end
    player = player or getSpecificPlayer(playerIndex)
    if player == nil or not player:isLocalPlayer() then return end
    local cell = DL.Wounds.cell
    DL.Wounds.pendingToCell = false
    if cell then
        teleportTo(player, cell)
        DL.log("wounds: entered purgatory at " .. cell.x .. "," .. cell.y .. "," .. cell.z)
    end
end)

Events.OnServerCommand.Add(function(module, command, args)
    if module ~= "DLWounds" then return end
    if command == "deathState" then
        DL.Wounds.pendingToCell = args.toCell and true or false
        DL.Wounds.cell = { x = args.x, y = args.y, z = args.z or 0 }
        DL.Respawn = DL.Respawn or {}
        if args.rx then DL.Respawn.point = { x = args.rx, y = args.ry, z = args.rz or 0 } end
    elseif command == "resetResult" then
        if args.ok then notify("Wounds treated.")
        elseif args.reason == "noitem" then notify("You don't have the treatment item.")
        else notify("Wound treatment failed.") end
    end
end)

local function stackItem(v)
    if instanceof(v, "InventoryItem") then return v end
    if type(v) == "table" and v.items then return v.items[1] end
    return nil
end

Events.OnFillInventoryObjectContextMenu.Add(function(playerIndex, context, items)
    local player = getSpecificPlayer(playerIndex)
    if player == nil then return end
    local found = false
    for _, v in ipairs(items) do
        local it = stackItem(v)
        if it and it:getFullType() == DL.Config.woundResetItem then found = true; break end
    end
    if not found then return end
    context:addOption("Treat Wounds", player, function(p)
        sendClientCommand(p, "DLWounds", "useResetItem", {})
    end)
end)

DL.log("wounds client wiring loaded (purgatory routing + reset item menu)")
