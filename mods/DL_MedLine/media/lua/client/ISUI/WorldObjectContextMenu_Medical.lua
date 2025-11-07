require "MedLine_Events";
require "MedLine_Client";

MedLine_Events = MedLine_Events or {};
MedLine_Client = MedLine_Client or {};

local function getPlayersFromWorldObjects(worldObjects)
    
    local playerList = {};

    local localPlayer = getPlayer();

    for _, object in ipairs(worldObjects) do
        if object and object:getSquare() then
            local square = object:getSquare();

            local movingObjs = square:getMovingObjects();

            for i = 0, movingObjs:size() - 1 do
                local movObj = movingObjs:get(i);

                if movObj and instanceof(movObj, "IsoPlayer") then
                    if movObj ~= localPlayer and not movObj:isInvisible() then
                        table.insert(playerList, movObj);
                    end
                end
            end
        end
    end

    return playerList;
end

function MedLine_Events.onClickDrawBlood(self, player, medicalCheckOpt)
    if not player or not medicalCheckOpt then return end;

    local target = medicalCheckOpt.param2;

    getPlayer():faceThisObject(target);
        
    getPlayer():setHaloNote(getText("IGUI_BloodDrawRequested"), 150, 150, 150, 200);
    sendClientCommand(player, "MedLine", "RequestBloodAction", { target = target:getUsername(), mode = MedLine_Dict.EventModes.BloodActions.draw });
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
    
    MedLine_Logging.log("populateMedicalCheck_BloodDraw");
    MedLine_Logging.log("Param 1 - " .. medicalCheckOpt.param1:getUsername());
    MedLine_Logging.log("Param 2 - " .. medicalCheckOpt.param2:getUsername());

    local newOpt = subMenu:addOption(getText("ContextMenu_MedLine_DrawBlood"), context, MedLine_Events.onClickDrawBlood, player, medicalCheckOpt);
    local tooltip = ISWorldObjectContextMenu.addToolTip();

    newOpt.toolTip = tooltip;

    tooltip:setName(getText("ContextMenu_MedLine_DrawBlood"));
    tooltip:setWidth(180);
    tooltip.description = "Draws blood from a player and leaves them temporarily suffering from the blood loss debuff. <LINE> <LINE>";
    tooltip.description = tooltip.description .. "This will produce 1x blood bag of that player's blood type. <LINE> <LINE>";
    tooltip.description = tooltip.description .. "This is a lengthy and time consuming action and will be cancelled by movement. <LINE> <LINE>";

     -- Check if the player has the required skill to take blood.
    local currentSkill = player:getPerkLevel(Perks.Doctor);
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

    MedLine_Logging.log("populateMedicalCheck_BloodTransfusion");
    MedLine_Logging.log("Param 1 - " .. medicalCheckOpt.param1:getUsername());
    MedLine_Logging.log("Param 2 - " .. medicalCheckOpt.param2:getUsername());

    local targetBloodType = MedLine_Client.getBloodType(medicalCheckOpt.param2);
    local matchingBag = MedLine_Client.getBloodBagOfType(medicalCheckOpt.param1, targetBloodType);

    print("Target blood type for player " .. medicalCheckOpt.param2:getUsername() .. " is " .. (targetBloodType.type or "NOT FOUND"));

    local newOpt = subMenu:addOption(getText("ContextMenu_MedLine_GiveBlood"), context, MedLine_Events.onClickGiveBlood, player, medicalCheckOpt, matchingBag);
    local tooltip = ISWorldObjectContextMenu.addToolTip();

    newOpt.toolTip = tooltip;

    tooltip:setName(getText("ContextMenu_MedLine_GiveBlood"));
    tooltip:setWidth(180);
    tooltip.description = "Transfuses blood from a blood bag to speed up the recovery from blood loss. <LINE> <LINE>";
    tooltip.description = tooltip.description .. "This requires 1x bloodbag of the same blood type as the player. <LINE> <LINE>";

     -- Check if the player has the required skill to give blood.
    local currentSkill = player:getPerkLevel(Perks.Doctor);
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
        tooltip.description = tooltip.description .. "<RED>Missing Item: 1x blood bag of type " .. tostring(targetBloodType.type or "INVALID_BLOOD_TYPE") .. ".<LINE>";
    end

    if not MedLine_Client.doesPlayerHaveBloodLoss(medicalCheckOpt.param2) then
        isValid = false;
        tooltip.description = tooltip.description .. ("<LINE> <LINE>");
        tooltip.description = tooltip.description .. "<RED> This player is not suffering from blood loss, a transfusion would not do anything to help.<LINE>";
    end

    if not isValid then
        newOpt.notAvailable = true;
    end

    return newOpt;
end

function MedLine_Events.populateMedicalCheck_SalineTransfusion(player, context, subMenu, medicalCheckOpt, requiredSkillLevel)
    MedLine_Logging.log("populateMedicalCheck_SalineTransfusion");
    MedLine_Logging.log("Param 1 - " .. medicalCheckOpt.param1:getUsername());
    MedLine_Logging.log("Param 2 - " .. medicalCheckOpt.param2:getUsername());

    local matchingBag = MedLine_Client.getSalineBag(medicalCheckOpt.param1);

    local newOpt = subMenu:addOption(getText("ContextMenu_MedLine_GiveSaline"), context, MedLine_Events.onClickGiveSaline, player, medicalCheckOpt, matchingBag);
    local tooltip = ISWorldObjectContextMenu.addToolTip();

    newOpt.toolTip = tooltip;

    tooltip:setName(getText("ContextMenu_MedLine_GiveSaline"));
    tooltip:setWidth(180);
    tooltip.description = "Transfuses normal saline to speed up the recovery from blood loss. <LINE> <LINE>";
    tooltip.description = tooltip.description .. "This requires 1x bag of normal saline. <LINE> <LINE>";

     -- Check if the player has the required skill to give blood.
    local currentSkill = player:getPerkLevel(Perks.Doctor);
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
        tooltip.description = tooltip.description .. "<RED>Missing Item: 1x bag of normal saline.<LINE>";
    end

    if not MedLine_Client.doesPlayerHaveBloodLoss(medicalCheckOpt.param2) then
        isValid = false;
        tooltip.description = tooltip.description .. ("<LINE> <LINE>");
        tooltip.description = tooltip.description .. "<RED> This player is not suffering from blood loss, a transfusion would not do anything to help.<LINE>";
    end

    if not isValid then
        newOpt.notAvailable = true;
    end

    return newOpt;
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
    
    local drawOpt = MedLine_Events.populateMedicalCheck_BloodDraw(player, context, subMenu, medicalCheckOpt, requiredSkillLevel_Draw);
    local transfusionOpt = MedLine_Events.populateMedicalCheck_BloodTransfusion(player, context, subMenu, medicalCheckOpt, requiredSkillLevel_Transfusion);
    local salineOpt = MedLine_Events.populateMedicalCheck_SalineTransfusion(player, context, subMenu, medicalCheckOpt, requiredSkillLevel_SalineTransfusion);
end

Events.OnFillWorldObjectContextMenu.Add(MedLine_Events.OnFillWorldObjectContextMenu);