require "LogLineUtils";
LogLineUtils = LogLineUtils or {};
LogLineUtils.LogFromClient = LogLineUtils.LogFromClient or {};

LOGLINE_INVALIDSTATSPREFIX = "InvalidStats"

ClothingCheckedAfterChange = false;

function IsNaN(val)
    return val ~= val;
end


function InvalidStats_IsNutritionInvalid(player)

    if not player then return false end;

    local playerNutrition = player:getNutrition();

    if not playerNutrition then return false end;

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

    local playerItems = player:getInventory():getItemsFromCategory("Clothing");
    if playerItems then
        for i = 0, playerItems:size() - 1 do
            local item = playerItems:get(i);

            if item and instanceof(item, "Clothing") then
                if IsNaN(item:getWetness()) then
                   return true;
                end
            end
        end
    end

    return false;
end

function ResetPlayerClothing(player)
    local items = player:getInventory():getItemsFromCategory("Clothing");
    if not items then return end;

    for i = 0, items:size() - 1 do
        local item = items:get(i);
        if item then
            if instanceof(item, "Clothing") then
                if IsNaN(item:getWetness()) then
                    item:setWetness(0);
                    item:setTemperature(37);
                end
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
    bodyDamage:setWetness(0);

    local bodyParts = bodyDamage:getBodyParts();
    for i = 0, bodyParts:size() - 1 do
        local part = bodyParts:get(i);
        if part then
            part:setWetness(0);
        end
    end
end

function ResetPlayerNutrition(player)
    local bodyDamage = player:getBodyDamage();
    if not bodyDamage then return end;

    local playerNutrition = player:getNutrition();
    if not playerNutrition then return end;

    local errorString = "Reset nutritional values for player" .. player:getUsername() .. ": ";

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

function InvalidStats_OnCreatePlayer(playerNum, player)
    if not player then return end;

    ClothingCheckedAfterChange = false;
end

function InvalidStats_OnClothingUpdated(player)
    if not player then return end;

    if player ~= getPlayer() then return end;

    ClothingCheckedAfterChange = false;
end

function InvalidStats_CheckPlayer(player)
    if not player then return end;

    if InvalidStats_IsNutritionInvalid(player) then
        ResetPlayerNutrition(player);
    end

    ClothingCheckedAfterChange = true;
end


function InvalidStats_RepairNeeds(player)
    if not player then return end;
    local stats = player:getStats();
    if not stats then return end;
    local repaired = {};
    if IsNaN(stats:getHunger()) then stats:setHunger(0); table.insert(repaired, "hunger"); end
    if IsNaN(stats:getThirst()) then stats:setThirst(0); table.insert(repaired, "thirst"); end
    if InvalidStats_IsTempInvalid(player) then
        ResetPlayerClothing(player);
        ResetPlayerTemperature(player);
        table.insert(repaired, "temperature/wetness (thermoregulator reset)");
    end
    return repaired;
end

function InvalidStats_EveryOneMinute() -- still called every 1 minute but it's 10
    local player = getPlayer();
    local repaired = InvalidStats_RepairNeeds(player);
    if repaired and #repaired > 0 then
        LogLineUtils.LogFromClient(LOGLINE_INVALIDSTATSPREFIX, "Automatic repair of " .. table.concat(repaired, ", ") .. " for player " .. tostring(player:getUsername()));
    end
    if (not ClothingCheckedAfterChange) then
        InvalidStats_CheckPlayer(getPlayer());
    end
end

Events.OnCreatePlayer.Add(InvalidStats_OnCreatePlayer);
Events.OnClothingUpdated.Add(InvalidStats_OnClothingUpdated);
Events.EveryTenMinutes.Add(InvalidStats_EveryOneMinute); -- switched to 10 minutes
