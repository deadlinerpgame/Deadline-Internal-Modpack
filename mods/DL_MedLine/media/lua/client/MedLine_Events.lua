require "MedLine_Client";

MedLine_Events = {};
MedLine_Client = MedLine_Client or {};

function MedLine_Events.EveryOneMinute()
    local player = getPlayer();
    if not player then return end;

    local bloodData = MedLine_Client.getBloodData();
    if not bloodData or bloodData == {} then
        MedLine_Client.initialiseMedicalData();
    end;

    local bodyDamage = player:getBodyDamage();
    local threshhold = SandboxVars.MedLine.BloodLoss_HealthThreshold or 25;

    local health = bodyDamage:getOverallBodyHealth();
    
    -- If the health is over the threshhold and their blood data does not show they have lapsed below
    if health > threshhold and bloodData and (not bloodData:hasLapsedBelowThreshold()) then return end;

    if health > threshhold and bloodData and bloodData:hasLapsedBelowThreshold() then
        bloodData:setNowAboveThreshold();
    end;

    if health <= threshhold and bloodData and not bloodData:hasLapsedBelowThreshold() then
        MedLine_Client.initiateBloodLossStart();
    end
end

function MedLine_Events.EveryTenMinutes()
    local player = getPlayer();
    if not player then return end;

    if not MedLine_Client.getBloodData() then return end;

    if not MedLine_Client.isRecoveringFromBloodLoss() then return end;

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

    if not MedLine_Client.isRecoveringFromBloodLossEx(player) then return end;

    -- If it's not a weapon (somehow) this will go horribly, so exit out.
    -- Potentially if player has something without a hand model equipped for farming etc? No idea. Better safe than sorry due to PZ jank.
    if not instanceof(weapon, "HandWeapon") or not weapon:IsWeapon() or weapon:isRanged() then return end;

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

    if not MedLine_Client.isRecoveringFromBloodLoss() then
        Events.OnPlayerUpdate.Remove(MedLine_Events.OnPlayerUpdate);
        MedLine_Client.setBloodLossStopped();
        return;
    end

    -- Set stats to cap endurance at max of 80.
    local stats = player:getStats();
    stats:setEndurancelast(0.8);
    if stats:getEndurance() > 0.8 then
        stats:setEndurance(0.8);
    end

end

Events.EveryOneMinute.Add(MedLine_Events.EveryOneMinute);
Events.EveryTenMinutes.Add(MedLine_Events.EveryTenMinutes);
Events.OnWeaponSwing.Add(MedLine_Events.OnWeaponSwing);


return MedLine_Events;