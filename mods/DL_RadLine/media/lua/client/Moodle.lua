require "MF_ISMoodle"
MF.createMoodle("MoodleRad");
MF.createMoodle("MoodleRadRes");
MF.createMoodle("MoodleGasMask");
MF.createMoodle("MoodleHazmat");

local function MoodleInit()
    local moodlerad = MF.getMoodle("MoodleRad");
    local moodleradres = MF.getMoodle("MoodleRadRes");
    local moodlegasmask = MF.getMoodle("MoodleGasMask");
    local moodlehazmat = MF.getMoodle("MoodleHazmat");
    moodlerad:setThresholds(0.01, 0.25, 0.5, 0.99999,   nil, nil, nil, nil)--floats
    moodleradres:setThresholds(nil, nil, nil, nil,   0.01, 0.25, 0.5, 0.75);
    moodlegasmask:setThresholds(nil, nil, nil, nil,   0.01, 0.25, 0.5, 0.75);
    moodlehazmat:setThresholds(nil, nil, nil, nil,   0.01, 0.25, 0.5, 0.75);
    MF.getMoodle("MoodleRad"):setValue(1);
    MF.getMoodle("MoodleRadRes"):setValue(0);
    MF.getMoodle("MoodleGasMask"):setValue(0);
    MF.getMoodle("MoodleHazmat"):setValue(0);
end

--local function UpdatePl()
--    local moodlerad = MF.getMoodle("MoodleRad");
--    local moodleradres = MF.getMoodle("MoodleRadRes");
--end

Events.OnCreatePlayer.Add(MoodleInit);
--Events.OnPlayerUpdate.Add(UpdatePl);