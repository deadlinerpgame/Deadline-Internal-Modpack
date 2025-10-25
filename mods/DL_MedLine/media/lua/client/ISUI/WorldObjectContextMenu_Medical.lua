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


function MedLine_Events.populateMedicalCheck_BloodDraw(player, context, subMenu, medicalCheckOpt, requiredSkillLevel)
    
    local newOpt = subMenu:addOption(getText("ContextMenu_MedLine_DrawBlood"), context, MedLine_Events.onClickDrawBlood, player, medicalCheckOpt);
    local tooltip = ISWorldObjectContextMenu.addToolTip();

    newOpt.toolTip = tooltip;

    tooltip:setName(getText("ContextMenu_MedLine_DrawBlood"));
    tooltip:setWidth(180);
    tooltip.description = "Draws blood from a player and leaves them temporarily suffering from the blood loss debuff. <LINE> <LINE>";
    tooltip.description = tooltip.description .. "This will produce 1x blood bag of that player's blood type. <LINE> <LINE>";
    tooltip.description = tooltip.description .. "This is a lengthy and time consuming action and will be cancelled by movement. <LINE> <LINE>";

     -- Check if the player has the required skill to give blood.
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
    local drawString = string.format("<RGB:1,1,1> Items: <LINE> %s <LINE> <RGB:1,1,1>", itemsString);

    tooltip.description = tooltip.description .. (drawString or "INVALID_DRAW_STRING");

    if MedLine_Client.doesPlayerHaveBloodLoss(medicalCheckOpt.param1) then
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

    -- Check if sufficient medical level.
    local requiredSkillLevel_Draw = SandboxVars.MedLine.LevelOpts_BloodDrawMedicalLevel or 10;
    local requiredSkillLevel_Transfusion = SandboxVars.MedLine.LevelOpts_BloodDrawMedicalLevel or 8;

    local subMenu = context:getNew(context);
    context:addSubMenu(medicalCheckOpt, subMenu);
    
    local drawOpt = MedLine_Events.populateMedicalCheck_BloodDraw(player, context, subMenu, medicalCheckOpt, requiredSkillLevel_Draw);
    local transfusionOpt = MedLine_Events.populateMedicalCheck_BloodTransfusion(player, context, subMenu, medicalCheckOpt, requiredSkillLevel_Transfusion);
end

Events.OnFillWorldObjectContextMenu.Add(MedLine_Events.OnFillWorldObjectContextMenu);