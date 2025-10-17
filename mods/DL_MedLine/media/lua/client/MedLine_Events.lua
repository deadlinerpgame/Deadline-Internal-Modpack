require "MedLine_Client";

MedLine_Events = {};
MedLine_Client = MedLine_Client or {};

function MedLine_Events.EveryOneMinute()
    local player = getPlayer();
    if not player then return end;

    local bloodData = MedLine_Client.getBloodData();
    if not bloodData then return end;

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


Events.EveryOneMinute.Add(MedLine_Events.EveryOneMinute);

return MedLine_Events;