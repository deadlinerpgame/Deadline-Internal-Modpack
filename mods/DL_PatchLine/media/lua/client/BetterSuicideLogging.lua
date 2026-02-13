require "LogLineUtils";
LogLineUtils = LogLineUtils or {};
LogLineUtils.LogFromClient = LogLineUtils.LogFromClient or {};

local original_suicideAction = SuicideActionAnim.perform;

function SuicideActionAnim:perform()
	
    local logStr = string.format("%s is suiciding with current body health: %0d | ", getPlayer():getUsername(), getPlayer():getBodyDamage():getOverallBodyHealth());
    local bodyDamage = getPlayer():getBodyDamage();
    local bodyParts = bodyDamage:getBodyParts();

    for i = 0, bodyParts:size() - 1 do
        local part = bodyParts:get(i);

        local bodyPartStr = "[" .. tostring(part:getType()) .. " ";
        local addPart = false;

        if part then
            if part:bandaged() then
                addPart = true;
                bodyPartStr = bodyPartStr .. "|bandaged";
            end

            if part:bitten() then
                addPart = true;
                bodyPartStr = bodyPartStr .. "|bitten";
            end

            if part:bleeding() then
                addPart = true;
                bodyPartStr = bodyPartStr .. "|bleeding";
            end

            if part:deepWounded() then
                addPart = true;
                bodyPartStr = bodyPartStr .. "|deepWound";
            end

            if part:stitched() then
                addPart = true;
                bodyPartStr = bodyPartStr .. "|stitched";
            end

            if part:IsInfected() or part:IsFakeInfected() then
                addPart = true;
                bodyPartStr = bodyPartStr .. "|infection";
            end
        end

        if addPart then
            bodyPartStr = bodyPartStr .. "]";
            logStr = logStr .. " " .. bodyPartStr;
        end
    end

    LogLineUtils.LogFromClient("SuicideAction", logStr);
    original_suicideAction(self);
end