require "MedLine_Client";
require "MedLine_Dict";
require "WL"

MedLine_Events = {};
MedLine_Client = MedLine_Client or {};
MedLine_Dict = MedLine_Dict or {};

local HasCheckedForCachedMedicalData = false;
local MinutesSinceRetrievedMedicalData = 0;
local HasSentOwnMedicalDataAfterDelay = false;


function MedLine_Events.EveryOneMinute()
    local player = getPlayer();
    if not player then return end;

    if not HasCheckedForCachedMedicalData then
        ModData.request(MedLine_Dict.ModDataKeys.UserData);
        HasCheckedForCachedMedicalData = true;
    end

    -- Save after 1 IG minutes, this should be sufficient to allow for back and forth transmission without causing too much of a delay or initial spam.
    -- This is done because there's a lot of back and forth communication with the server on initial connect.
    if HasCheckedForCachedMedicalData and MinutesSinceRetrievedMedicalData < 1 then
        MinutesSinceRetrievedMedicalData = MinutesSinceRetrievedMedicalData + 1;
    elseif HasCheckedForCachedMedicalData and MinutesSinceRetrievedMedicalData == 1 and not HasSentOwnMedicalDataAfterDelay then
        MedLine_Client.saveMedicalData();
        HasSentOwnMedicalDataAfterDelay = true;
    end

    local bloodData = MedLine_Client.getBloodData();
    if not bloodData or bloodData == {} then
        MedLine_Client.initialiseMedicalData();
    end;

    local bodyDamage = player:getBodyDamage();
    local threshhold = SandboxVars.MedLine.BloodLoss_HealthThreshold or 25;

    local health = bodyDamage:getOverallBodyHealth();
    
    -- If the health is over the threshhold and their blood data does not show they have lapsed below
    if health > threshhold and bloodData and (not MedLine_Client.hasLapsedBelowThreshold()) then return end;

    if health > threshhold and bloodData and MedLine_Client.hasLapsedBelowThreshold() then
        MedLine_Client.setNowAboveThreshold();
    end;

    if health <= threshhold and bloodData and not MedLine_Client.hasLapsedBelowThreshold() then
        MedLine_Client.initiateBloodLossStart(SandboxVars.MedLine.BloodLoss_RecoveryTimeDays or 7);
    end
end

function MedLine_Events.EveryTenMinutes()
    local player = getPlayer();
    if not player then return end;

    if not MedLine_Client.doesPlayerHaveBloodLoss(player) then return end;

    MedLine_Client.checkBloodLossRecovery();

    -- Check remaining duration and update Moodle level accordingly.
    --local daysRemaining = MedLine_Client.getBloodData():getRecoveryDaysRemainingAsString();
    --local lossMoodle = MF.getMoodle("BloodLoss");
end

-- This this is not a moodle and may affect sync, more checks have to be done.
-- Otherwise there is a risk that zombies take different damage if weapon damage is synced differently across clients.
-- (this is because endurance affects damage AFAIK as of 19/10/25).
function MedLine_Events.OnWeaponSwing(player, weapon)
    if not player then return end;
    if not weapon then return end;

    if not MedLine_Client.doesPlayerHaveBloodLoss(player) then return end;

    -- If it's not a weapon (somehow) this will go horribly, so exit out.
    -- Potentially if player has something without a hand model equipped for farming etc? No idea. Better safe than sorry due to PZ jank.
    if not instanceof(weapon, "HandWeapon") or not weapon:IsWeapon() or weapon:isRanged() then return end;

    -- Quick sync check to make sure max stamina is set properly.
    local enduranceCap = SandboxVars.MedLine.BloodLoss_MaxBloodLossEndurance or 0.8;

    -- Set stats to cap endurance at max of 80.
    local stats = player:getStats();
    stats:setEndurancelast(enduranceCap);
    if stats:getEndurance() > enduranceCap then
        stats:setEndurance(enduranceCap);
    end

    local sandboxEnduranceMult = SandboxVars.MedLine.BloodLoss_WeaponSwingEnduranceAffected;

    -- No point multiplying a base value!
    if not sandboxEnduranceMult or sandboxEnduranceMult == 1.0 then return end;

    local stats = player:getStats();
    if not stats then return end;

    --[[
        This is the base game Java code for calculating endurance loss on weapon swing, replicated to then be multiplied.
            float float0 = 0.0F;
            if (weapon.isTwoHandWeapon() && (owner.getPrimaryHandItem() != weapon || owner.getSecondaryHandItem() != weapon)) {
                float0 = weapon.getWeight() / 1.5F / 10.0F;
            }
            
             float float1 = (weapon.getWeight() * 0.18F * weapon.getFatigueMod(owner) * owner.getFatigueMod() * weapon.getEnduranceMod() * 0.3F + float0)
                    * 0.04F;

            float float2 = 1.0F;
            if (owner.Traits.Asthmatic.isSet()) {
                float2 = 1.3F;
            }

            owner.getStats().endurance -= float1 * float2;
    --]]
    local weightContribution = 0.0;
    if weapon:isTwoHandWeapon() and (player:getPrimaryHandItem() ~= weapon or player:getSecondaryHandItem() ~= weapon) then
        weightContribution = weapon:getWeight() / 1.5 / 10;
    end 

    local enduranceUse = (weapon:getWeight() * 0.18 * weapon:getFatigueMod(player) * player:getFatigueMod() * weapon:getEnduranceMod() * 0.3 + weightContribution) * 0.04;

    -- We don't want to take the base value off again, we just want to subtract the additional endurance cost.
    -- Since the multiplied endurance use is higher than the base endurance use, get the difference.
    local modifiedEndurance = (enduranceUse * sandboxEnduranceMult) - enduranceUse;
    MedLine_Logging.log("Current endurance: " .. tostring(stats:getEndurance()) .. " to be changed to " .. tostring(modifiedEndurance));

    stats:setEndurance(stats:getEndurance() - modifiedEndurance);
end

function MedLine_Events.OnPlayerUpdate()
    local player = getPlayer();
    if not player then return end;

    if not player:getModData().MedLine.BloodData.bloodLossTimeoutUnix then return end;

    local enduranceCap = SandboxVars.MedLine.BloodLoss_MaxBloodLossEndurance or 0.8;

    -- Set stats to cap endurance at max of 80.
    local stats = player:getStats();
    stats:setEndurancelast(enduranceCap);
    if stats:getEndurance() > enduranceCap then
        stats:setEndurance(enduranceCap);
    end
end

function MedLine_Events.onClickBloodActionModal(otherPlayer, btn, src, mode)
    if not src or not mode then return end;

    if btn.internal == "NO" then return end;

    if not otherPlayer then return end;

    if mode == MedLine_Dict.EventModes.BloodActions.draw then
        WL_Utils.addInfoToChat("You have accepted the blood draw. " .. tostring(otherPlayer:getDescriptor():getForename()) .. " is now drawing blood.");
    end

    sendClientCommand(getPlayer(), "MedLine", "AcceptBloodAction", { src = src, mode = mode });
    getSoundManager():playUISound("UISelectListItem");
end

function MedLine_Events.onClickDiceHpModal(player, btn)

    local message = "";
    if btn.internal == "NO" then
        message = getPlayer():getDescriptor():getForename() .. " has cancelled the dice HP blood loss dialog.";
    else
        message = getPlayer():getDescriptor():getForename() .. " is now suffering from blood loss.";
        MedLine_Client.initiateBloodLossStart(SandboxVars.MedLine.BloodLoss_RecoveryTimeDaysPVP or 5);
    end;

    local args =
    {
        sourcePlayerID = getPlayer():getOnlineID(),
        message = message,
        coords =
        {
            x = getPlayer():getX(),
            y = getPlayer():getY(),
            z = getPlayer():getZ()
        },
        mode = "loud",
    };

    sendClientCommand('DeadlineDice', 'requestSendMessage', args);

    sendClientCommand(getPlayer(), 'ISLogSystem', 'writeLog', {
        loggerName = "Dice",
        logText = message
    });
end


function MedLine_Events.OnServerCommand(module, command, args)
    if module ~= "MedLine" then return end;

    MedLine_Logging.log("MedLine Server Event Received: " .. command);

    if command == "DICE_ShowCriticalHealthPopup" then
        local posX = (getCore():getScreenWidth() / 2) - (350 / 2);
        local posY = (getCore():getScreenHeight() / 2) - (200 / 2);
        local modal = ISModalDialog:new(posX, posY, 350, 200, getText("IGUI_CriticalDiceHpModal"), true, getPlayer(), MedLine_Events.onClickDiceHpModal, getPlayer():getPlayerNum());
        modal:initialise();
        modal:addToUIManager();
    end

    if command == "ADMIN_OverrideBloodLoss_ForceClientEvents" then
        MedLine_Logging.log("Received admin override for blood loss, forcing client event start.");
        Events.OnPlayerUpdate.Add(MedLine_Events.OnPlayerUpdate);
    end
    
    if command == "ShowBloodActionModal" then
        -- src = player:getOnlineID(), srcName = player:getDescriptor():getForename(), mode = mode
        local mode = args.mode;

        MedLine_Logging.log("ShowBloodActionModal called from " .. args.src .. " with mode " .. tostring(mode) .. " for " .. getPlayer():getUsername());

        if mode == MedLine_Dict.EventModes.BloodActions.draw then
            
            local srcPlayer = getPlayerByOnlineID(args.src);
            if not srcPlayer then
                MedLine_Logging.log("ShowBloodActionModal but player with online ID does not exist - " .. tostring(args.src));
                return;
            end

            local posX = (getCore():getScreenWidth() / 2) - (350 / 2);
            local posY = (getCore():getScreenHeight() / 2) - (200 / 2);
            local modal = ISModalDialog:new(posX, posY, 350, 200, getText("IGUI_ConfirmBloodDraw", args.srcName), true, srcPlayer, MedLine_Events.onClickBloodActionModal, srcPlayer:getPlayerNum(), srcPlayer:getUsername(), mode);
            modal:initialise();
            modal:addToUIManager();
        end
    end

    if command == "OnReceiveAcceptedBloodAction" then
        print("OnReceiveAcceptedBloodAction");
        local target = args.target;
        local mode = args.mode;

        if not target or not mode then return end;

        if mode == MedLine_Dict.EventModes.BloodActions.draw then
            local targetPlayer = getPlayerFromUsername(target);
            if not targetPlayer then return end;

            MedLine_Client.waitingForBloodActionPerms = false;
            ISTimedActionQueue.add(MLDrawBloodAction:new(getPlayer(), targetPlayer));
        end
    end

    if command == "StartBloodDrawBloodLoss" then
        local bloodDrawDays = SandboxVars.MedLine.BloodLoss_RecoveryTimeDaysDonation or 2;
        MedLine_Client.initiateBloodLossStart(bloodDrawDays);
    end

    if command == "ReduceBloodLossDuration" then
        if not args.efficiency then
            print("Efficiency not set for ReduceBloodLossDuration");
            return;
        end

        MedLine_Client.reduceBloodLossByPercentage(args.efficiency);
    end

    if command == "SyncMedicalDataFromServer" then
        local targetPlayer = getPlayerFromUsername(args.target);
        if not targetPlayer then
            MedLine_Logging.log("[SyncMedicalDataFromServer] Received sync request but could not find player " .. args.target);
            return;
        end

        if not targetPlayer:getModData().MedLine then
            targetPlayer:getModData().MedLine = {};
        end

        targetPlayer:getModData().MedLine.BloodData = args.medicalData;
    end
end

Events.EveryOneMinute.Add(MedLine_Events.EveryOneMinute);
Events.EveryTenMinutes.Add(MedLine_Events.EveryTenMinutes);
Events.OnWeaponSwing.Add(MedLine_Events.OnWeaponSwing);
Events.OnServerCommand.Add(MedLine_Events.OnServerCommand);

function MedLine_Events.OnReceiveGlobalModData(key, data)
    if key == MedLine_Dict.ModDataKeys.UserData then
        print("OnReceiveGlobalModData for MedLine UserData");

        for username, medicalData in pairs(data) do
            local matchingPlayer = getPlayerFromUsername(username);
            if matchingPlayer then
                print("Updating medical data for player " .. matchingPlayer:getUsername());
                if not matchingPlayer:getModData().MedLine then
                    matchingPlayer:getModData().MedLine = {};
                end

                matchingPlayer:getModData().MedLine.BloodData = medicalData;

                if matchingPlayer == getPlayer() then
                    -- Check for blood loss once it has synced.
                    MedLine_Client.checkBloodLossRecovery();
                end
            end
        end

        -- At the end, if no of own bloodData.
        if not getPlayer():getModData().MedLine or not getPlayer():getModData().MedLine.BloodData then
            print("Player does not have blood data or medline table, initialising medical data.");
            MedLine_Client.initialiseMedicalData(getPlayer());
        end

        if not MedLine_Client.getBloodType(getPlayer()) then
            print("Unable to find blood type trait for player, giving it.");
            local bloodType = getPlayer():getModData().MedLine.BloodData.bloodType;
            if not bloodType then
                print("Unable to find blood type mod data.");
                return;
            end

            getPlayer():getTraits():add(bloodType.traitStr);
            print("Blood type trait added.");
        end
    end
end

function MedLine_Events.OnInitGlobalModData(newGame)
    ModData.request(MedLine_Dict.ModDataKeys.UserData);
end

Events.OnReceiveGlobalModData.Add(MedLine_Events.OnReceiveGlobalModData);
Events.OnInitGlobalModData.Add(MedLine_Events.OnInitGlobalModData);

--[[function MedLine_Events.OnGameBoot()
    for _, bloodType in ipairs(MedLine_Dict.BLOOD_TYPES) do
        local typeString = bloodType.traitStr;
        local traitTitle = "Blood Type: " .. tostring(bloodType.type);
        TraitFactory.addTrait(getText(typeString), traitTitle, 0, "Your character's blood type.", false);
        print("Adding trait " .. typeString);
    end
end


Events.OnGameBoot.Add(MedLine_Events.OnGameBoot);--]]

return MedLine_Events;