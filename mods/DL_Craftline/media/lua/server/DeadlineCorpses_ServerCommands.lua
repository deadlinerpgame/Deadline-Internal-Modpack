local DeadlineCorpsesServerCommands = {}
local CorpseTicketID = "Base.CorpseTicket3"


function DeadlineCorpsesServerCommands.doDeleteCorpse(args)
  
    local cell = getWorld():getCell()
    local sq = cell:getGridSquare(args.x, args.y, args.z)
    local bodies = sq:getDeadBodys()
    if bodies then
        for i = 0, bodies:size() - 1 do
            local corpse = bodies:get(i)
            if corpse then
                local container = corpse:getContainer()

                local count = container:getItemCount(CorpseTicketID)
                if count and count > 0 then
                        square:removeCorpse(corpse, false)
                        corpse:removeFromWorld()
                        corpse:removeFromSquare()
                end
            end
        end
    end
end


local function OnServerCommand(module, command, args)
    if module == 'DeadlineCorpse' then
        DeadlineCorpsesServerCommands[command](args)
    end
end



Events.OnServerCommand.Add(OnServerCommand)
