require "LogLineUtils";
LogLineUtils = LogLineUtils or {};
LogLineUtils.LogFromClient = LogLineUtils.LogFromClient or {};

LOGLINE_INVALIDSTATSPREFIX = "InvalidStats"

--[[
https://stackoverflow.com/questions/37753694/lua-check-if-a-number-value-is-nan
"According to IEEE 754, a nan value is considered not equal to any value, including itself."
--]]

function IsNaN(val)
    return val ~= val;
end


function InvalidStats_IsNutritionInvalid(player)

    if not player then return false end;

    -- calories carbs protein and fat
    local playerNutrition = player:getNutrition();

    if not playerNutrition then return false end; -- I'm not quite sure what would cause this but it would be bad. This script can't fix that, they need a miracle.

    local playerCalories = playerNutrition:getCalories();
    local playerCarbs = playerNutrition:getCarbohydrates();
    local playerProtein = playerNutrition:getProteins();
    local playerFats = playerNutrition:getLipids();

    if  IsNaN(playerCalories) or IsNaN(playerCarbs)
        or
        IsNaN(playerProtein) or IsNaN(playerFats)
    then
        return true;
    end
    
    return false;
end

function InvalidStats_IsTempInvalid(player)

    local bodyDamage = player:getBodyDamage();
    if not bodyDamage then return false end;

    local playerTemp = bodyDamage:getTemperature();
    local playerWetness = bodyDamage:getWetness();

    if (not playerTemp) or (not playerWetness) then return true end;

    if IsNaN(playerTemp) or IsNaN(playerWetness) then return true end;
    return false;
end

------------------
function CheckAndLogBuggedClothing(player, clothingItem)
    if not player then return end;
    if not instanceof(clothingItem, "Clothing") then return end;

    if IsNaN(clothingItem:getTemperature()) then
        local logStr = string.format("[CHECKANDLOG] Player %s: %s [%s] has IsNaN temperature, val: ", player:getUsername(), clothingItem:getName(), clothingItem:getFullType(), clothingItem:getTemperature());
        LogLineUtils.LogFromClient(LOGLINE_INVALIDSTATSPREFIX, logStr);
    end
end


--- Iterates through each worn item of clothing and resets the wetness of it. This should be done AFTER ResetPlayerTemperature as the player's thermoregulator will just be broken again if the clothing items are bugged.
function ResetPlayerClothing(player)
    local wornItems = player:getWornItems();
    if not wornItems then return end;

    for i = 0, wornItems:size() - 1 do
        local item = wornItems:get(i):getItem();
        if item then
            if instanceof(item, "Clothing") then
                -- This is for purely logging purposes to try and find out how it is caused.
                CheckAndLogBuggedClothing(player, item);

                -- Actual resetting.
                item:flushWetness();
                item:setWetness(0.0);
            end
        end
    end
end

function ResetPlayerTemperature(player)
    local bodyDamage = player:getBodyDamage();
    if not bodyDamage then return end;

    local thermoReg = bodyDamage:getThermoregulator();
    if not thermoReg then return end;

    thermoReg:reset();
    bodyDamage:setWetness(0.0);

    -- Set invidiual body parts as well just in case there's a modded clothing item that the main thermo regulator doesn't catch.
    local bodyParts = bodyDamage:getBodyParts();
    for i = 0, bodyParts:size() - 1 do
        local part = bodyParts:get(i);
        if part then
            part:setWetness(0.0);
        end
    end
end

function ResetPlayerNutrition(player)
    local bodyDamage = player:getBodyDamage();
    if not bodyDamage then return end;

    local playerNutrition = player:getNutrition();
    if not playerNutrition then return end;

    local errorString = "Reset nutritional values for player" .. player:getUsername() .. ": ";

    -- These values are entirely arbitrary but shouldn't cause players to balloon in weight after respawning.
    if IsNaN(playerNutrition:getCalories()) then
        playerNutrition:setCalories(1000);
        errorString = errorString .. " calories;";
    end
    
    if IsNaN(playerNutrition:getCarbohydrates()) then
        playerNutrition:setCarbohydrates(250);
        errorString = errorString .. " carbohydrates;";
    end

    if IsNaN(playerNutrition:getProteins()) then
        playerNutrition:setProteins(250);
        errorString = errorString .. " proteins;";
    end
    
    if IsNaN(playerNutrition:getLipids()) then
        playerNutrition:setLipids(250);
        errorString = errorString .. " fats (lipids);";
    end

    LogLineUtils.LogFromClient(LOGLINE_INVALIDSTATSPREFIX, errorString);
end

------------------

function InvalidStats_OnCreatePlayer(playerNum, player)

    if InvalidStats_IsTempInvalid(player) then
        LogLineUtils.LogFromClient(LOGLINE_INVALIDSTATSPREFIX, "Player " .. player:getUsername() .. " temperature is invalid, resetting player and clothing...");
        ResetPlayerTemperature(player);
        ResetPlayerClothing(player);
    end

    if InvalidStats_IsNutritionInvalid(player) then
        ResetPlayerNutrition(player);
    end

end

Events.OnCreatePlayer.Add(InvalidStats_OnCreatePlayer);