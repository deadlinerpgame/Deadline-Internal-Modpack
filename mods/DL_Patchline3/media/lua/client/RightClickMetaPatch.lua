PatchLine_RightClickMeta = {};

function PatchLine_RightClickMeta.OnFillWorldObjectContextMenu(player, context, worldobjects, test)
    if test then return end;

    if not context then return end;

    local accessLevel = getSpecificPlayer(player):getAccessLevel();
    local isStaff = accessLevel ~= nil and accessLevel ~= "" and accessLevel ~= "None";
    local hidden = {};

     for _, option in pairs(context.options) do
        if option and not isStaff
            and (option.onSelect == ISWorldObjectContextMenu.onTrade or option.onSelect == ISWorldObjectContextMenu.onMedicalCheck)
            and option.param2:isInvisible() then
            table.insert(hidden, option.name);
        elseif option and option.onSelect == ISWorldObjectContextMenu.onTrade then

            local targetPlayer = option.param2;
            local targetName = targetPlayer:getDescriptor():getForename();

            option.name = getText("ContextMenu_Trade", targetName);

            if option.notAvailable then
                option.toolTip.description = getText("ContextMenu_GetCloserToTrade", targetName);
            end
        end

        if option and option.onSelect == ISWorldObjectContextMenu.onMedicalCheck and not (not isStaff and option.param2:isInvisible()) then

            local targetPlayer = option.param2;
            local targetName = targetPlayer:getDescriptor():getForename();

            if option.notAvailable then
                option.toolTip.description = getText("ContextMenu_GetCloser", targetName);
            end
        end
    end

    for _, name in ipairs(hidden) do
        context:removeOptionByName(name);
    end
end


Events.OnFillWorldObjectContextMenu.Add(PatchLine_RightClickMeta.OnFillWorldObjectContextMenu);