if isServer() then return end;

ProstheticsCore = require("ProstheticsCore");

PAIN_LEVELS = {20, 50, 80};

function SchedulePhantomPains()
    local player = getPlayer();
    if not player or not player:getModData() then return end;
    
    -- Decide the duration and delay.
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

function GetTimeSinceLastDurationCheck()
    local player = getPlayer();
    if not player then return nil end;

    local painsData = player:getModData().ProstheticsLine_PhantomPain;
    return painsData.lastDurationTimestamp or -1;
end

function GetPainLevel()
    local severity = SandboxVars.ProstheticsLine.PhantomPainsSeverity or 1;
    return PAIN_LEVELS[severity] or 25;
end

-- Limb must be BodyPartType
function SetPainInLimb(limb)
    local limb = player:getBodyDamage():getBodyPart(limb);
    if not limb then return end;

    local currentPain = limb:getAdditionalPain();
    if currentPain < GetPainLevel() then
        limb:setAdditionalPain(GetPainLevel());
    end
end

function ApplyPains()
    local player = getPlayer();
    if not player then return end;

    -- Get amputations.
    local amputations = ProstheticsCore.GetAllAmputations();
    if not amputations or #amputations == 0 then return end; -- How we got here, I'll never know.

    for i, v in ipairs(amputations) do
        if string.find(amputations[i], "_L") then
            -- Left arm.
            if ProstheticsCore.IsArmLocation() then
                SetPainInLimb(BodyPartType.ForeArm_L);
            else
            -- Left leg.
                SetPainInLimb(BodyPartType.LowerLeg_L);
            end
        end

        if string.find(amputations[i], "_R") then
            -- Right arm.
            SetPainInLimb(BodyPartType.ForeArm_R);
        else
            -- Right leg.
            SetPainInLimb(BodyPartType.LowerLeg_R);
        end
    end
end

function StopPhantomPains()

    local player = getPlayer();
    if not player or not player:getModData() then return end;

    local painsData = player:getModData().ProstheticsLine_PhantomPain;
    if not painsData then return end;

    -- If there's still duration remaining on the pain or the scheduled time in the future (i.e. yet to come) don't cancel.
    if painsData.duration > 0 or painsData.scheduledTime > ProstheticsCore.GetCurrentTimeInMs() then
        return;
    end

    player:getModData().ProstheticsLine_PhantomPain = nil;
    player:transmitModData();
end

local function EveryTenMinutes()
    local amputations = ProstheticsCore.GetAmputationCount();
    if amputations == 0 then return end;

    local painChance = SandboxVars.ProstheticsLine.PhantomPainsChance;
    if not painChance or painChance == 0 then return end;

    local player = getPlayer();
    if not player or not player:getModData() then return end;

    if player:getModData().ProstheticsLine_PhantomPain then
        if 
            -- If a pain is scheduled
            player:getModData().ProstheticsLine_PhantomPain.scheduledTime and 
            -- And it's in the future.
            player:getModData().ProstheticsLine_PhantomPain.scheduledTime > ProstheticsCore.GetCurrentTimeInMs() 
        then
            -- STOP.
            return;
        end

        -- Now check we're within the cooldown grace period or not.
        if 
            player:getModData().ProstheticsLine_PhantomPain.cooldown and
            player:getModData.ProstheticsLine_PhantomPain.cooldown > 0 
        then
            return;
        end;
    end


    -- Otherwise, roll the dice.
    local random = ZombRand(100);
    if random < painChance then return end;

    SchedulePhantomPains();
end

-- Run this every one minute rather than on tick to save FPS.

--[[
    Check to see if pains are scheduled. If past schedule time and duration remaining,
    Apply pain.
--]]
local function EveryOneMinute()
    local player = getPlayer();
    if not player then return end;

    local painsData = player:getModData().ProstheticsLine_PhantomPain;

    -- Don't count down if there's not one checked.
    if 
        not painsData or
        not painsData.scheduledTime
    then
        return;
    end

    local scheduledTime = painsData.scheduledTime;

    -- 
    local currentTime = ProstheticsCore.GetCurrentTimeInMs();

    -- If the time is ahead of scheduled time, then we should be applying the pain if there's duration outstanding.
    if currentTime > scheduledTime then
        local duration = painsData.duration;
        if not duration then return end;

        -- This means that the pains should expire this frame.
        if duration <= 0 then
            StopPhantomPains();
            return;
        end

        -- Otherwise, set the pains and decrease duration by MS difference.
        if GetTimeSinceLastDurationCheck() == -1 then
            painsData.lastDurationTimestamp = ProstheticsCore.GetCurrentTimeInMs();
        end

        -- We want to ceil this so it doesn't go below zero, though if any of these numbers have turned into floats
        -- something has gone drastically wrong and that's probably the least of our concerns.
        -- But it is Lua.
        local difference = math.ceil(ProstheticsCore.GetCurrentTimeInMs() - GetTimeSinceLastDurationCheck());
        painsData.duration = painsData.duration - difference;

        ApplyPains();
    end
end

Events.EveryTenMinutes.Add(EveryTenMinutes);
Events.EveryOneMinute.Add(EveryOneMinute);