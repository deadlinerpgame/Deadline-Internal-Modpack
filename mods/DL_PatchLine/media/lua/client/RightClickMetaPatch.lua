PatchLine_RightClickMeta = {};

function PatchLine_RightClickMeta.OnFillWorldObjectContextMenu(player, context, worldobjects, test)
    if test then return end;

    if not context then return end;

    -- 1. Find trade options.
     for _, option in pairs(context.options) do
        if option and option.onSelect == ISWorldObjectContextMenu.onTrade then

            local targetPlayer = option.param2;
            local targetName = targetPlayer:getDescriptor():getForename(); -- Includes /name.

            option.name = getText("ContextMenu_Trade", targetName);

            if option.notAvailable then
                option.toolTip.description = getText("ContextMenu_GetCloserToTrade", targetName);
            end
        end

        if option and option.onSelect == ISWorldObjectContextMenu.onMedicalCheck then

            local targetPlayer = option.param2;
            local targetName = targetPlayer:getDescriptor():getForename(); -- Includes /name.

            if option.notAvailable then
                option.toolTip.description = getText("ContextMenu_GetCloser", targetName);
            end
        end
    end
    
end


Events.OnFillWorldObjectContextMenu.Add(PatchLine_RightClickMeta.OnFillWorldObjectContextMenu);