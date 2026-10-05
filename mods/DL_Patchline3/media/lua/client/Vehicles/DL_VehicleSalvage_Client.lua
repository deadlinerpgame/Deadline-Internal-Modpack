require "Vehicles/ISUI/ISVehicleMenu"

local DISASSEMBLY_OPTIONS = { "ContextMenu_SalvageVehicle", "ContextMenu_RemoveBurntVehicle" }

function DLSalvage.markSalvaged(character, vehicle)
    DLSalvage.setSalvaged(vehicle)
    sendClientCommand(character, "DLSalvage", "markSalvaged", { vehicle = vehicle:getId() })
end
-- This is a bad idea, but it will work for now
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

local function applyRequirements(playerObj, context)
    local option = context:getOptionFromName(getText("ContextMenu_SalvageVehicle"))
    if not option then return end
    local need = DLSalvage.REQUIRE
    local available = true
    local description = getText("Tooltip_SalvageVehicle") .. " <LINE> <LINE> " .. getText("Tooltip_craft_Needs") .. " : <LINE> "
    local function add(ok, text)
        if not ok then available = false end
        description = description .. " <LINE> <RGB:1," .. (ok and "1,1" or "0,0") .. "> " .. text
    end
    if need.metalworking > 0 then
        local level = playerObj:getPerkLevel(Perks.MetalWelding)
        add(level >= need.metalworking, getText("IGUI_perks_MetalWelding") .. " " .. level .. "/" .. need.metalworking)
    end
    if need.mechanics > 0 then
        local level = playerObj:getPerkLevel(Perks.Mechanics)
        add(level >= need.mechanics, getText("IGUI_perks_Mechanics") .. " " .. level .. "/" .. need.mechanics)
    end
    if need.weldingMask then
        local has = playerObj:getInventory():containsEvalRecurse(DLSalvage.isMask)
        add(has, getItemNameFromFullType("Base.WeldingMask") .. " " .. (has and 1 or 0) .. "/1")
    end
    local torch = ISBlacksmithMenu.getBlowTorchWithMostUses(playerObj:getInventory())
    local uses = torch and torch:getDrainableUsesInt() or 0
    add(torch ~= nil and uses >= need.torchUses, getItemNameFromFullType("Base.BlowTorch") .. " " .. getText("ContextMenu_Uses") .. " " .. uses .. "/" .. need.torchUses)

    local toolTip = ISToolTip:new()
    toolTip:initialise()
    toolTip:setVisible(false)
    toolTip:setName(option.name)
    toolTip.description = description
    option.toolTip = toolTip
    option.notAvailable = not available
end

local function wrapVehicleMenu()
    function ISVehicleMenu.onVehicleSalvage(player, vehicle)
        if luautils.walkAdj(player, vehicle:getSquare()) then
            ISWorldObjectContextMenu.equip(player, player:getPrimaryHandItem(), DLSalvage.isTorch, true)
            local mask = player:getInventory():getFirstEvalRecurse(DLSalvage.isMask)
            if mask then
                ISInventoryPaneContextMenu.wearItem(mask, player:getPlayerNum())
            end
            ISTimedActionQueue.add(ISVehicleSalvage:new(player, vehicle))
        end
    end

    local fillMenu = ISVehicleMenu.FillMenuOutsideVehicle
    function ISVehicleMenu.FillMenuOutsideVehicle(player, context, vehicle, test)
        local result = fillMenu(player, context, vehicle, test)
        applyRequirements(getSpecificPlayer(player), context)
        if DLSalvage.isSalvaged(vehicle) then
            blockDisassembly(context)
        end
        return result
    end
end

Events.OnServerCommand.Add(onServerCommand)
Events.OnGameStart.Add(wrapVehicleMenu)
