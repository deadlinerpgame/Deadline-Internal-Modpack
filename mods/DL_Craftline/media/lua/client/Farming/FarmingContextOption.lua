Craftline_Farming = {};

local function predicateDrainableUsesInt(item, count)
	return item:getDrainableUsesInt() >= count
end

function Craftline_Farming.onTreatFungi(worldObjects, uses, sq, playerObj, item)
    if not ISFarmingMenu.walkToPlant(playerObj, sq) then
		return;
	end
    local fungiCan = playerObj:getInventory():getFirstTypeEvalArgRecurse("GardeningSprayBonemeal", predicateDrainableUsesInt, 1);
    if not fungiCan then return end;
    ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), fungiCan, true);
    ISTimedActionQueue.add(DLTreatFungiAction:new(playerObj, item, uses, CFarmingSystem.instance:getLuaObjectOnSquare(sq), 10 * (uses * 5)));
end

function Craftline_Farming.OnFillWorldObjectContextMenu(playerNum, context, worldObjects, test)

    local player = getSpecificPlayer(playerNum) or getPlayer();

    if test then return end;

    local currentPlant = nil;
    local currentSquare = nil;

    for i, v in ipairs(worldObjects) do
        local plant = CFarmingSystem.instance:getLuaObjectOnSquare(v:getSquare());
    
        if plant then
            currentPlant = plant;
            currentSquare = v:getSquare();
        end
    end

    local fungiTreatmentItem = nil;

    if not handItem or handItem:getType() ~= "GardeningSprayBonemeal" or (handItem:getDrainableUsesInt() == 0) then
        fungiTreatmentItem = player:getInventory():getFirstTypeEvalArgRecurse("GardeningSprayBonemeal", predicateDrainableUsesInt, 1);
    else
        fungiTreatmentItem = handItem;
    end

    if not currentPlant then return end;

    if not currentPlant.aphidLvl or currentPlant.aphidLvl == 0 then return end;

    -- Does the context option exist.
    local treatProblemOption = context:getOptionFromName(getText("ContextMenu_Treat_Problem"));
    local treatSubMenu = (treatProblemOption and context:getSubMenu(treatProblemOption)) or nil;

    if not treatProblemOption then
        treatProblemOption = context:addOption(getText("ContextMenu_Treat_Problem"), worldObjects, nil);
        treatSubMenu = context:getNew(context);
        context:addSubMenu(treatProblemOption, treatSubMenu);
    end

    if not treatSubMenu then
        treatSubMenu = context:getNew(context);
        context:addSubMenu(treatProblemOption, treatSubMenu);
    end

    local dwfOption = treatSubMenu:addOption(getText("Farming_Devil_Water_Fungi"), worldObjects, nil);
    local subMenuDWF = context:getNew(context);
    local use = fungiTreatmentItem and fungiTreatmentItem:getDrainableUsesInt() or -1;

    if use > 0 then
        context:addSubMenu(dwfOption, subMenuDWF);
        if use > 10 then
            use = 10;
        end
        local aphidLvl = 0;
        for i=1, use do
            aphidLvl = i * 5;
            subMenuDWF:addOption(tostring(aphidLvl), worldobjects, Craftline_Farming.onTreatFungi, i, currentSquare, player, fungiTreatmentItem);
        end
        
    else
        dwfOption.notAvailable = true;
        local tooltip = ISWorldObjectContextMenu.addToolTip();
        local spray = InventoryItemFactory.CreateItem("farming.GardeningSprayBonemeal"):getDisplayName();
        tooltip.description = getText("Farming_MissingItem", spray);
        dwfOption.toolTip = tooltip;
    end


    -- Get the "Treat Problem context option menu."
    --[[
        local treatmentMenu = context:getOptionFromName(getText("ContextMenu_Treat_Problem"));
        local treatmentSubMenu = nil;
        if not treatmentMenu then
            treatmentMenu = context:addOption(getText("ContextMenu_Treat_Problem"), worldObjects, nil);
            treatmentSubMenu = context:addSubMenu(treatmentMenu, context:getNew(context));
        end

        treatmentSubMenu = treatmentSubMenu or treatmentMenu.subOption;

        treatmentSubMenu:addOption(getText("Farming_Devil_Water_Fungi"), worldObjects, nil);
        local subMenuDWF = context:getNew(treatmentSubMenu);
        local use = fungiTreatmentItem:getDrainableUsesInt();

        if use > 0 then
            if use > 10 then
                use = 10;
            end
            local aphidLvl = 0;
            for i=1, use do
                aphidLvl = i * 5;
                subMenuDWF:addOption(tostring(aphidLvl), worldobjects, Craftline_Farming.onTreatFungi, i, currentSquare, player);
            end
            context:addSubMenu(treatmentMenu.subOption, subMenuDWF);
        else
            subMenuDWF.notAvailable = true;
            local tooltip = ISWorldObjectContextMenu.addToolTip();
            local spray = fungiTreatmentItem:getDisplayName();
            tooltip.description = getText("Farming_MissingItem", spray);
            subMenuDWF.toolTip = tooltip;
        end
    --]]
end

Events.OnFillWorldObjectContextMenu.Add(Craftline_Farming.OnFillWorldObjectContextMenu);

return Craftline_Farming;