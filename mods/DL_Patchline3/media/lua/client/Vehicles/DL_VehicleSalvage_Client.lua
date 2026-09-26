require "Vehicles/ISUI/ISVehicleMenu"

local DISASSEMBLY_OPTIONS = { "ContextMenu_SalvageVehicle", "ContextMenu_RemoveBurntVehicle" }

function DLSalvage.markSalvaged(character, vehicle)
    DLSalvage.setSalvaged(vehicle)
    sendClientCommand(character, "DLSalvage", "markSalvaged", { vehicle = vehicle:getId() })
end
// This is a bad idea, but it will work for now
local function onServerCommand(module, command, args)
    if module ~= "DLSalvage" or command ~= "salvaged" then return end
    local vehicle = getVehicleById(args.vehicle)
    if vehicle then
        DLSalvage.setSalvaged(vehicle)
    end
end

local function blockDisassembly(context)
    for _, key in ipairs(DISASSEMBLY_OPTIONS) do
        local option = context:getOptionFromName(getText(key))
        if option then
            option.notAvailable = true
            option.onSelect = nil
            local toolTip = ISToolTip:new()
            toolTip:initialise()
            toolTip:setVisible(false)
            toolTip:setName(option.name)
            toolTip.description = "<RGB:1,0,0> This vehicle has already been disassembled."
            option.toolTip = toolTip
        end
    end
end

local function wrapVehicleMenu()
    local fillMenu = ISVehicleMenu.FillMenuOutsideVehicle
    function ISVehicleMenu.FillMenuOutsideVehicle(player, context, vehicle, test)
        local result = fillMenu(player, context, vehicle, test)
        if DLSalvage.isSalvaged(vehicle) then
            blockDisassembly(context)
        end
        return result
    end
end

Events.OnServerCommand.Add(onServerCommand)
Events.OnGameStart.Add(wrapVehicleMenu)
