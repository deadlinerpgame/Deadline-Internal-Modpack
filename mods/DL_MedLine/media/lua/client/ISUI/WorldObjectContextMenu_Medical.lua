require "MedLine_Events";
require "MedLine_Client";

MedLine_Events = MedLine_Events or {};
MedLine_Client = MedLine_Client or {};

function MedLine_Events.getPlayersFromWorldObjects(worldObjects)
    
    local playerList = {};
    local override = isDebugEnabled() or isAdmin();

    local possiblePlayersTable = {};

    for _, object in ipairs(worldObjects) do
        if object and object:getSquare() then
            local square = object:getSquare();

            local movingObjs = square:getMovingObjects();

            for i = 0, movingObjs:size() - 1 do
                local movObj = movingObjs:get(i);
                if instanceof(movObj, "IsoPlayer") and movObj ~= getPlayer() then
                    table.insert(possiblePlayersTable, movingObjs:get(i));
                end
            end
        end
    end

    print("Moving object iterable list:");
    for _, possiblePlayer in ipairs(possiblePlayersTable) do
        if (not possiblePlayer:isInvisible()) or override then

            local found = false;
            for i, v in ipairs(playerList) do
                if possiblePlayer == v then
                    found = true;
                end
            end

            if not found then
                table.insert(playerList, possiblePlayer);
            end
        end
    end

    return playerList;
end

function MedLine_Events.onClickDrawBlood(self, player, medicalCheckOpt)
    if not player or not medicalCheckOpt then return end;

    getPlayer():faceThisObject(target);
        
    getPlayer():setHaloNote(getText("IGUI_BloodDrawRequested"), 150, 150, 150, 200);
    sendClientCommand(medicalCheckOpt.param1, "MedLine", "RequestBloodAction", { target = medicalCheckOpt.param2:getUsername(), mode = MedLine_Dict.EventModes.BloodActions.draw });
end

function MedLine_Events.onClickGiveBlood(self, player, medicalCheckOpt, matchingBag)
    if not player or not medicalCheckOpt then return end;

    local target = medicalCheckOpt.param2;
    getPlayer():faceThisObject(target);

    ISTimedActionQueue.add(MLGiveBloodAction:new(player, medicalCheckOpt.param2, matchingBag));
end

function MedLine_Events.onClickGiveSaline(self, player, medicalCheckOpt, matchingBag)
    if not player or not medicalCheckOpt then return end;

    local target = medicalCheckOpt.param2;
    getPlayer():faceThisObject(target);

    ISTimedActionQueue.add(MLGiveSalineAction:new(player, medicalCheckOpt.param2, matchingBag));
end


function MedLine_Events.populateMedicalCheck_BloodDraw(player, context, subMenu, medicalCheckOpt, requiredSkillLevel)
    local newOpt = subMenu:addOption(getText("ContextMenu_MedLine_DrawBlood"), context, MedLine_Events.onClickDrawBlood, medicalCheckOpt.param1, medicalCheckOpt);
    local tooltip = ISWorldObjectContextMenu.addToolTip();

    newOpt.toolTip = tooltip;

    tooltip:setName(getText("ContextMenu_MedLine_DrawBlood"));
    tooltip:setWidth(180);
    tooltip.description = "Draws blood from a player and leaves them temporarily suffering from the blood loss debuff. <LINE> <LINE>";
    tooltip.description = tooltip.description .. "This will produce 1x blood bag of that player's blood type. <LINE> <LINE>";
    tooltip.description = tooltip.description .. "This is a lengthy and time consuming action and will be cancelled by movement. <LINE> <LINE>";

     -- Check if the player has the required skill to take blood.
    local currentSkill = medicalCheckOpt.param1:getPerkLevel(Perks.Doctor);
    local isValid = true;

    local meetsSkillLevel = currentSkill >= requiredSkillLevel;
    if not meetsSkillLevel then
        isValid = false;
    end

    local skillString = string.format("Medical:   %s %s / %s <LINE>", meetsSkillLevel and " <RGB:0,1,0> " or " <RGB:1,0,0> ", tostring(currentSkill), tostring(requiredSkillLevel));
    tooltip.description = tooltip.description .. skillString;

    if not MedLine_Client.hasItemsForBloodDraw(getPlayer()) then
        isValid = false;
    end

    local itemsString = MedLine_Client.procedureItemsToString(getPlayer(), MedLine_Client.bloodDrawItems);
    local drawString = string.format("<RGB:1,1,1> Items: %s <LINE> <RGB:1,1,1>", itemsString);

    tooltip.description = tooltip.description .. (drawString or "INVALID_DRAW_STRING");

    local targetModData = medicalCheckOpt.param2:getModData().MedLine.BloodData;
    if targetModData.bloodLossTimeoutUnix and targetModData.bloodLossTimeoutUnix > getTimestamp() then
        isValid = false;
        tooltip.description = tooltip.description .. ("<LINE> <LINE>");
        tooltip.description = tooltip.description .. "<RED> This player is already recovering from blood loss. You cannot draw more blood from them.<LINE>";
    end

    if not isValid then
        newOpt.notAvailable = true;
    end

    return newOpt;
end


function MedLine_Events.populateMedicalCheck_BloodTransfusion(player, context, subMenu, medicalCheckOpt, requiredSkillLevel)

    local targetBloodType = MedLine_Client.getBloodType(medicalCheckOpt.param2);
    local matchingBag = MedLine_Client.getBloodBagOfType(medicalCheckOpt.param1, targetBloodType);

    MedLine_Logging.log("Target blood type for player " .. medicalCheckOpt.param2:getUsername() .. " is " .. (targetBloodType.type or "NOT FOUND"));

    local newOpt = subMenu:addOption(getText("ContextMenu_MedLine_GiveBlood"), context, MedLine_Events.onClickGiveBlood, medicalCheckOpt.param1, medicalCheckOpt, matchingBag);
    local tooltip = ISWorldObjectContextMenu.addToolTip();

    newOpt.toolTip = tooltip;

    tooltip:setName(getText("ContextMenu_MedLine_GiveBlood"));
    tooltip:setWidth(180);
    tooltip.description = "Transfuses blood from a blood bag to speed up the recovery from blood loss. <LINE> <LINE>";
    tooltip.description = tooltip.description .. "This requires 1x bloodbag of the same blood type as the player. <LINE> <LINE>";

     -- Check if the player has the required skill to give blood.
    local currentSkill = medicalCheckOpt.param1:getPerkLevel(Perks.Doctor);
    local isValid = true;

    local meetsSkillLevel = currentSkill >= requiredSkillLevel;
    if not meetsSkillLevel then
        isValid = false;
    end

    local skillString = string.format("Medical:   %s %s / %s <LINE>", meetsSkillLevel and " <RGB:0,1,0> " or " <RGB:1,0,0> ", tostring(currentSkill), tostring(requiredSkillLevel));
    tooltip.description = tooltip.description .. skillString;

    if not matchingBag then
        isValid = false;
        tooltip.description = tooltip.description .. ("<LINE> <LINE>");
        tooltip.description = tooltip.description .. "<RED>Missing Item: 1x blood bag of type " .. tostring(targetBloodType.type or "INVALID_BLOOD_TYPE") .. ". <LINE>";
    end

    if not MedLine_Client.doesPlayerHaveBloodLoss(medicalCheckOpt.param2) then
        isValid = false;
        tooltip.description = tooltip.description .. ("<LINE> <LINE>");
        tooltip.description = tooltip.description .. "<RED> This player is not suffering from blood loss, a transfusion would not do anything to help. <LINE>";
    end

    if MedLine_Client.hasPlayerHadTransfusion(medicalCheckOpt.param2) then
        isValid = false;
        tooltip.description = tooltip.description .. ("<LINE> <LINE>");
        tooltip.description = tooltip.description .. "<RED> This player has already had a transfusion and will not benefit from another. <LINE> They will recover fully in time. <LINE>";
    end

    if not isValid then
        newOpt.notAvailable = true;
    end

    return newOpt;
end

function MedLine_Events.populateMedicalCheck_SalineTransfusion(player, context, subMenu, medicalCheckOpt, requiredSkillLevel)
    local matchingBag = MedLine_Client.getSalineBag(medicalCheckOpt.param1);

    local newOpt = subMenu:addOption(getText("ContextMenu_MedLine_GiveSaline"), context, MedLine_Events.onClickGiveSaline, medicalCheckOpt.param1, medicalCheckOpt, matchingBag);
    local tooltip = ISWorldObjectContextMenu.addToolTip();

    newOpt.toolTip = tooltip;

    tooltip:setName(getText("ContextMenu_MedLine_GiveSaline"));
    tooltip:setWidth(180);
    tooltip.description = "Transfuses normal saline to speed up the recovery from blood loss. <LINE> <LINE>";
    tooltip.description = tooltip.description .. "This requires 1x bag of normal saline. <LINE> <LINE>";

     -- Check if the player has the required skill to give blood.
    local currentSkill = medicalCheckOpt.param1:getPerkLevel(Perks.Doctor);
    local isValid = true;

    local meetsSkillLevel = currentSkill >= requiredSkillLevel;
    if not meetsSkillLevel then
        isValid = false;
    end

    local skillString = string.format("Medical:   %s %s / %s <LINE>", meetsSkillLevel and " <RGB:0,1,0> " or " <RGB:1,0,0> ", tostring(currentSkill), tostring(requiredSkillLevel));
    tooltip.description = tooltip.description .. skillString;

    if not matchingBag then
        isValid = false;
        tooltip.description = tooltip.description .. ("<LINE> <LINE>");
        tooltip.description = tooltip.description .. "<RED>Missing Item: 1x bag of normal saline. <LINE>";
    end

    if not MedLine_Client.doesPlayerHaveBloodLoss(medicalCheckOpt.param2) then
        isValid = false;
        tooltip.description = tooltip.description .. ("<LINE> <LINE>");
        tooltip.description = tooltip.description .. "<RED> This player is not suffering from blood loss, a transfusion would not do anything to help. <LINE>";
    end

    if MedLine_Client.hasPlayerHadTransfusion(medicalCheckOpt.param2) then
        isValid = false;
        tooltip.description = tooltip.description .. ("<LINE> <LINE>");
        tooltip.description = tooltip.description .. "<RED> This player has already had a transfusion and will not benefit from another. <LINE> They will recover fully in time. <LINE>";
    end

    if not isValid then
        newOpt.notAvailable = true;
    end

    return newOpt;
end

function MedLine_Events.prepareMedCheckLossTooltip(medicalCheckOpt)
    local targetMedicalData = medicalCheckOpt.param2:getModData().MedLine.BloodData;
    if targetMedicalData.bloodLossTimeoutUnix and targetMedicalData.bloodLossTimeoutUnix > getTimestamp() then
        
        local remainingTime = targetMedicalData.bloodLossTimeoutUnix - getTimestamp();
        local remainingTimeAsHours = Math.ceil(remainingTime / 3600);

        local remainingString = nil;
        local showExact = false;

        -- Determine whether player should see exact remaining time.
        local requiredSkillLevel_SeeExact = SandboxVars.MedLine.LevelOpts_SeeRemainingLossTime or 6;
        if medicalCheckOpt.param1:getPerkLevel(Perks.Doctor) >= requiredSkillLevel_SeeExact then
            showExact = true;
        end

        -- First, check if remaining time is less than a day.
        if remainingTimeAsHours > 24 then
            remainingString = (showExact and tostring(remainingTimeAsHours) .. "hrs remaining until recovery.") or tostring(Math.ceil(remainingTimeAsHours / 24)) .. " days remaining until recovery.";
        else -- If less than a day, show as hours.
            -- If less than 2 hrs (should be 1 but this is rounded so 2 is easier for clarity and rounding problems), show as minutes.
            if showExact and remainingTimeAsHours < 2 then
                remainingString = (showExact and tostring(remainingTime / 60) .. "min(s) remaining until recovery.");
            else
                remainingString = tostring(remainingTimeAsHours) .. "hrs remaining until recovery.";
            end
        end

        if not showExact then
            remainingString = "Approx. " .. remainingString;
        end

        return string.format("<RED> %s is suffering from blood loss. <LINE> %s <LINE> <LINE> Click on the player's name in the Medical Check sub-menu to perform a medical check.", medicalCheckOpt.param2:getDescriptor():getForename(), remainingString);
    else
        return "<GREEN> " .. medicalCheckOpt.param2:getDescriptor():getForename() .. " does not appear to be suffering from blood loss. <LINE> <LINE> Click on the player's name in the Medical Check sub-menu to perform a medical check.";
    end
end


function MedLine_Events.populatePlayerMedicalCheckOpt(player, context, subMenu, medicalCheckOpt)
    if not medicalCheckOpt.param2:getModData().MedLine or not medicalCheckOpt.param2:getModData().MedLine.BloodData then
        print("Unable to retrieve blood data for player " .. medicalCheckOpt.param2:getUsername() .. " so terminating MedicalCheck additions.");
        ModData.request(MedLine_Dict.ModDataKeys.UserData);
        return;
    end

    -- Check if sufficient medical level.
    local requiredSkillLevel_Draw = SandboxVars.MedLine.LevelOpts_BloodDrawMedicalLevel or 10;
    local requiredSkillLevel_Transfusion = SandboxVars.MedLine.LevelOpts_BloodTransfusionMedicalLevel or 8;
    local requiredSkillLevel_SalineTransfusion = SandboxVars.MedLine.LevelOpts_SalineTransfusionMedicalLevel or 6;

    local subMenu = context:getNew(context);
    context:addSubMenu(medicalCheckOpt, subMenu);

    -- Add name and blood loss details to medical check.
    local checkOptTooltip = ISWorldObjectContextMenu.addToolTip();
    checkOptTooltip:setName(medicalCheckOpt.param2:getDescriptor():getForename());
    checkOptTooltip.description = MedLine_Events.prepareMedCheckLossTooltip(medicalCheckOpt);
    
    local infoOpt = subMenu:addOption("-- INFO --", context, nil);
    infoOpt.toolTip = checkOptTooltip;
    
    local drawOpt = MedLine_Events.populateMedicalCheck_BloodDraw(player, context, subMenu, medicalCheckOpt, requiredSkillLevel_Draw);
    local transfusionOpt = MedLine_Events.populateMedicalCheck_BloodTransfusion(player, context, subMenu, medicalCheckOpt, requiredSkillLevel_Transfusion);
    local salineOpt = MedLine_Events.populateMedicalCheck_SalineTransfusion(player, context, subMenu, medicalCheckOpt, requiredSkillLevel_SalineTransfusion);
end

---1. Blood Draw (taking blood from somebody)
---2. Blood Transfusion (given previously packaged blood to somebody)
---@param playerNum integer The player online ID (or 0 if SP).
---@param context ISContextMenu The WorldObjectContextMenu.
---@param worldObjects ArrayList<IsoObject> Java array as Kahlua table.
---@param test boolean Is testing to check for items in square, if so the menu doesn't render.
function MedLine_Events.OnFillWorldObjectContextMenu(playerNum, context, worldObjects, test)
    if test then return end;
    if not worldObjects then return end;

    local player = getPlayerByOnlineID(playerNum) or getPlayer();
    if not player then return end;

    local medicalCheckOpt = context:getOptionFromName(getText("ContextMenu_Medical_Check"));
    if not medicalCheckOpt then return end;

    if medicalCheckOpt.notAvailable then return end;
    medicalCheckOpt.onSelect = nil;

    -- Get all players for the world objects.
    local playerList = MedLine_Events.getPlayersFromWorldObjects(worldObjects);

    local medicalCheckPlayerList = context:getNew(context);
    context:addSubMenu(medicalCheckOpt, medicalCheckPlayerList);

    for i, v in ipairs(playerList) do
        local playerOpt = medicalCheckPlayerList:addOption(playerList[i]:getDescriptor():getForename(), context, ISWorldObjectContextMenu.onMedicalCheck, medicalCheckOpt.param1, medicalCheckOpt.param2);

        local playerMedicalSubMenu = context:getNew(context);
        context:addSubMenu(playerOpt, playerMedicalSubMenu);
        MedLine_Events.populatePlayerMedicalCheckOpt(player, context, playerMedicalSubMenu, playerOpt);
    end
end

Events.OnFillWorldObjectContextMenu.Add(MedLine_Events.OnFillWorldObjectContextMenu);