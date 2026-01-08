local DeadlineHorseServerCommands = {}


local function findWorldItemOnSquare(square, id)
    if not square then return nil end

    local worldItems = square:getWorldObjects()
    if not worldItems then return nil end

    for i = 0, worldItems:size() - 1 do
        local wi = worldItems:get(i)
        if wi and wi:getItem() and wi:getItem():getID() == id then
            return wi
        end
    end

    return nil
end

local function OnServerCommand(module, command, args)
    if module == 'DeadlineHorse' then
        DeadlineHorseServerCommands[command](args)
    end
end

function DeadlineHorseServerCommands.DoSyncHorseData(args)
        local square = getCell():getGridSquare(args.x, args.y, args.z)
        if not square then return end

        local wi = findWorldItemOnSquare(square, args.id)
        if not wi then return end

        local item = wi:getItem()
        if not item then return end

        local md = item:getModData()
        for k, v in pairs(args.data) do
            md[k] = v
        end

        local xoff = wi:getWorldPosX() - square:getX()
        local yoff = wi:getWorldPosY() - square:getY()
        local zoff = wi:getWorldPosZ() - square:getZ()
        square:transmitRemoveItemFromSquare(wi)
        square:removeWorldObject(wi)
        square:AddWorldInventoryItem(item, xoff, yoff, zoff)

        --wi:transmitCompleteItemToClients()
        sendServerCommand('DeadlineHorse', 'SyncHorseModData', args)

end


Events.OnServerCommand.Add(OnServerCommand)
