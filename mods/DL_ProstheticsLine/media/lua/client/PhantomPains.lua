if isServer() then return end;

ProstheticsCore = require("ProstheticsCore");
PhantomPains = {};

PAIN_LEVELS = {20, 50, 80};

function PhantomPains.SchedulePhantomPains()
    local player = getPlayer();
    if not player or not player:getModData() then return end;
    
    local maxDuration = SandboxVars.ProstheticsLine.PhantomPainsMaxDuration;
    local maxDelay = SandboxVars.ProstheticsLine.PhantomPainsMaxDelay;
    if not (maxDuration or maxDelay) then return end;

    local actualDuration = ZombRand(maxDuration);
    local actualDelay = ZombRand(maxDelay);

    local actualDurationMs = ProstheticsCore.MinutesToMs(actualDuration);
    local actualDelayMs = ProstheticsCore.MinutesToMs(actualDelay);

    player:getModData().ProstheticsLine_PhantomPain = {};
    player:getModData().ProstheticsLine_PhantomPain.scheduledTime = ProstheticsCore.GetCurrentTimeInMs() + actualDelayMs;
    player:getModData().ProstheticsLine_PhantomPain.duration = actualDurationMs;
    player:transmitModData();
end

function PhantomPains.GetTimeSinceLastDurationCheck()
    local player = getPlayer();
    if not player then return nil end;

    local painsData = player:getModData().ProstheticsLine_PhantomPain;
    return painsData.lastDurationTimestamp or -1;
end

function PhantomPains.GetPainLevel()
    local severity = SandboxVars.ProstheticsLine.PhantomPainsSeverity or 1;
    return PAIN_LEVELS[severity] or 25;
end

function PhantomPains.SetPainInLimb(limb)
    local limb = player:getBodyDamage():getBodyPart(limb);
    if not limb then return end;

    local currentPain = limb:getAdditionalPain();
    if currentPain < PhantomPains.GetPainLevel() then
        limb:setAdditionalPain(PhantomPains.GetPainLevel());
    end
end

function PhantomPains.ApplyPains()
    local player = getPlayer();
    if not player then return end;

    local amputations = ProstheticsCore.GetAllAmputations();
    if not amputations or #amputations == 0 then return end;

    for i, v in ipairs(amputations) do
        if string.find(amputations[i], "_L") then
            if ProstheticsCore.IsArmLocation() then
                PhantomPains.SetPainInLimb(BodyPartType.ForeArm_L);
            else
                PhantomPains.SetPainInLimb(BodyPartType.LowerLeg_L);
            end
        end

        if string.find(amputations[i], "_R") then
            PhantomPains.SetPainInLimb(BodyPartType.ForeArm_R);
        else
            PhantomPains.SetPainInLimb(BodyPartType.LowerLeg_R);
        end
    end
end

function PhantomPains.StopPhantomPains()

    local player = getPlayer();
    if not player or not player:getModData() then return end;

    local painsData = player:getModData().ProstheticsLine_PhantomPain;
    if not painsData then return end;

    if painsData.duration > 0 or painsData.scheduledTime > ProstheticsCore.GetCurrentTimeInMs() then
        return;
    end

    player:getModData().ProstheticsLine_PhantomPain = nil;
    player:transmitModData();
end

function PhantomPains.EveryTenMinutes()
    local amputations = ProstheticsCore.GetAmputationCount();
    if amputations == 0 then return end;

    local painChance = SandboxVars.ProstheticsLine.PhantomPainsChance;
    if not painChance or painChance == 0 then return end;

    local player = getPlayer();
    if not player or not player:getModData() then return end;

    if player:getModData().ProstheticsLine_PhantomPain then
        if 
            player:getModData().ProstheticsLine_PhantomPain.scheduledTime and 
            player:getModData().ProstheticsLine_PhantomPain.scheduledTime > ProstheticsCore.GetCurrentTimeInMs() 
        then
            return;
        end

        if 
            player:getModData().ProstheticsLine_PhantomPain.cooldown and
            player:getModData().ProstheticsLine_PhantomPain.cooldown > 0 
        then
            return;
        end;
    end


    local random = ZombRand(100);
    if random < painChance then return end;

    PhantomPains.SchedulePhantomPains();
end

function PhantomPains.EveryOneMinute()
    local player = getPlayer();
    if not player then return end;

    local painsData = player:getModData().ProstheticsLine_PhantomPain;

    if 
        not painsData or
        not painsData.scheduledTime
    then
        return;
    end

    local scheduledTime = painsData.scheduledTime;

    local currentTime = ProstheticsCore.GetCurrentTimeInMs();

    if currentTime > scheduledTime then
        local duration = painsData.duration;
        if not duration then return end;

        if duration <= 0 then
            PhantomPains.StopPhantomPains();
            return;
        end

        if GetTimeSinceLastDurationCheck() == -1 then
            painsData.lastDurationTimestamp = ProstheticsCore.GetCurrentTimeInMs();
        end

        local difference = math.ceil(ProstheticsCore.GetCurrentTimeInMs() - PhantomPains.GetTimeSinceLastDurationCheck());
        painsData.duration = painsData.duration - difference;

        PhantomPains.ApplyPains();
    end
end

Events.EveryTenMinutes.Add(PhantomPains.EveryTenMinutes);
Events.EveryOneMinute.Add(PhantomPains.EveryOneMinute);