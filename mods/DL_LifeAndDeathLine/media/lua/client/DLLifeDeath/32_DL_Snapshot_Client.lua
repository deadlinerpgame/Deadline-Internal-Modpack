DL = DL or {}

local function notify(msg)
    local p = getPlayer()
    if p == nil then return end
    if HaloTextHelper and HaloTextHelper.addText then
        ;(function() HaloTextHelper.addText(p, msg) end)()
    else
        ;(function() p:Say(msg) end)()
    end
end

local function findRestTile(worldobjects)
    local sprites = DL.Config.restTileSprites or {}
    for _, o in ipairs(worldobjects) do
        local sq = o.getSquare and o:getSquare()
        if sq then
            local objs = sq:getObjects()
            for i = 0, objs:size() - 1 do
                local obj = objs:get(i)
                local spr = obj.getSprite and obj:getSprite()
                local name = spr and spr.getName and spr:getName()
                if name and sprites[name] then return obj end
            end
        end
    end
    return nil
end

local function onSave(player)
    sendClientCommand(player, "DLSnapshot", "save", {})
end
local function onRestore(player)
    sendClientCommand(player, "DLSnapshot", "restore", {})
end

local function onFillContextMenu(playerIndex, context, worldobjects, test)
    if test then return end
    if findRestTile(worldobjects) == nil then return end
    local player = getSpecificPlayer(playerIndex)
    if player == nil then return end

    local parent = context:addOption(getText and getText("ContextMenu_DL_Snapshot") or "Snapshot")
    if parent == nil then return end
    local sub = ISContextMenu:getNew(context)
    context:addSubMenu(parent, sub)
    sub:addOption("Save snapshot", player, onSave)
    sub:addOption("Restore most recent", player, onRestore)
end
Events.OnFillWorldObjectContextMenu.Add(onFillContextMenu)

Events.OnServerCommand.Add(function(module, command, args)
    if module ~= "DLSnapshot" then return end
    if command == "saveResult" then
        if args.ok then notify("Snapshot saved.")
        elseif args.reason == "cooldown" then notify("Wait " .. tostring(args.wait) .. "s before saving again.")
        else notify("Snapshot save failed.") end
    elseif command == "restoreResult" then
        if args.reason == "used" then notify("Already restored this life.")
        elseif args.reason == "none" then notify("No snapshot to restore.")
        else notify("Restore failed.") end
    elseif command == "applyRestore" then
        local snap = DL.Snap.decode(args.data)
        if snap then
            ;(function() DL.Snap.apply(getPlayer(), snap) end)()
            notify("Snapshot restored.")
        end
    end
end)

DL.log("snapshot client wiring loaded")
