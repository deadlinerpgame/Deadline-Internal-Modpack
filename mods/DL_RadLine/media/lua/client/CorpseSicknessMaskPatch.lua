require "MF_ISMoodle";

local function CorpseSicknessMaskCheck(player)
    local gasMaskMoodle = MF.getMoodle("MoodleGasMask");
    local hazMatMoodle = MF.getMoodle("MoodleHazmat");

    if gasMaskMoodle:getValue() == 0.1 or hazMatMoodle:getValue() == 0.1 then
        if player:getStats():getSickness() > 0 then
            player:getStats():setSickness(0.0);
        end
    end
end

Events.OnPlayerUpdate.Add(CorpseSicknessMaskCheck);