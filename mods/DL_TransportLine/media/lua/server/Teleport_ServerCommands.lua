local DeadlineTeleportServerCommands = {}



function DeadlineTeleportServerCommands.doTileTeleport(args)
            pl = getPlayerByOnlineID(args.player)
            pl:setX(args.x)
            pl:setLx(args.x)
            pl:setY(args.y)
            pl:setLy(args.y)
            pl:setZ(args.z)
            print(pl)
            print(args.x)
            print(args.y)
end

local function OnServerCommand(module, command, args)
    if module == 'DeadlineTeleport' then
        DeadlineTeleportServerCommands[command](args)
    end
end

Events.OnServerCommand.Add(OnServerCommand)
