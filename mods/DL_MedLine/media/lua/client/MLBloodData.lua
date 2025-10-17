require "ISBaseObject";
MLBloodData = ISBaseObject:derive("MLBloodData");

---Creates a new blood data object to store a player's medline blood data.
---@param player IsoPlayer The player to associate with the blood data. Used to cache so calls for getPlayer() are not costly as these typically run on the local client.
---@return table MLBloodData The created blood data object to be put into a player's getModData().Medline.BloodData;
function MLBloodData:new(player)
    local o = {};
    setmetatable(o, self);
    self.__index = self;

    o.character = player;
    return o;
end

function MLBloodData:allocateBloodType()
    MedLine_Logging.log("[allocateBloodType] Start");

    local playerModData = self.character:getModData();
    if not playerModData then return end;

    local weight = 0;
    local allocatedBloodType = nil;

    -- Calculate total value of all blood type chances.
    for _, bloodType in ipairs(MedLine_Dict.BLOOD_TYPES) do
        if bloodType and bloodType.chance then
            weight = weight + bloodType.chance;
        end
    end

    MedLine_Logging.log("[allocateBloodType] Weights calculated.");

    -- Get random num which is used to essentially determine the blood type.
    local randomNum = ZombRandFloat(0.0, weight);
    MedLine_Logging.log("[allocateBloodType] Random weight: " .. tostring(randomNum));

    local iteratedWeight = 0;
    for _, bloodType in ipairs(MedLine_Dict.BLOOD_TYPES) do
        if bloodType and not allocatedBloodType then
            iteratedWeight = iteratedWeight + bloodType.chance;

            MedLine_Logging.log("[allocateBloodType] " .. tostring(bloodType.type) .. " - iterated weight is " .. tostring(iteratedWeight) .. " vs random weight of " .. tostring(randomNum));

            if randomNum < iteratedWeight then
                allocatedBloodType = bloodType;
                MedLine_Logging.log("[allocateBloodType] Allocated blood type is " .. bloodType.type);
            end
        end
    end

    if not playerModData.MedLine then
        playerModData.MedLine = {};
    end

    self.bloodType = allocatedBloodType;
    self:save();

    MedLine_Logging.log("[allocateBloodType] Blood type allocated and stopping.\n");
end

function MLBloodData:getBloodData()
    return self.bloodType;
end

function MLBloodData:changeBloodType(newType, override)
    if not override and self:hasChangedBloodType() then return end;

    local matchingType = nil;
    for _, bloodType in pairs(MedLine_Dict.BLOOD_TYPES) do
        if bloodType.type == newType then
            matchingType = bloodType;
        end
    end

    -- Conceivably if something intercepts the ISChat options and prevents the full blood types dict being added, then this will error.
    -- Setting a player's blood type to an invalid one or nil could be disasterous.
    if not matchingType then return end;

    self.bloodType = matchingType;
    self.bloodTypeChanged = true;
    self:save();
end

function MLBloodData:hasChangedBloodType()
    return self.bloodTypeChanged or false;
end

--[[

--]]

function MLBloodData:setHasLapsedBelowThreshold()
    self.hasLapsedBelow = true;

     -- Get the number of IRL days until it's over.
    local days = SandboxVars.MedLine.BloodLoss_RecoveryTimeDays or 14;

    -- Multiply that by number of seconds in a day. 
    local daysAsSeconds = days * 86400;

    self.bloodLossStartedUnix = getTimestamp();
    self.bloodLossTimeoutUnix = getTimestamp() + daysAsSeconds;
    self:save();
end

function MLBloodData:hasLapsedBelowThreshold()
    return self.hasLapsedBelow or false;
end

function MLBloodData:setNowAboveThreshold()
    self.hasLapsedBelow = false;
end

--[[

--]]

function MLBloodData:save()
    if not self.character then return end;

    if not self.character:getModData().MedLine then
        local errorStr = "!!CRITICAL ERROR HAS OCCURED!! MLBloodData object created without modData MedLine client being valid."
        MedLine_Logging.log(errorStr);
        error(errorStr, 1)
        return;
    end

    self.character:getModData().MedLine.BloodData = self;
    self.character:transmitModData();
end

function MLBloodData:tostring()
    local outputString = string.format("Player: %s | Blood Type: %s | ", self.character:getUsername() or "INVALID_USER", self.bloodType.type or "NOT_SET");
    return outputString;
end

