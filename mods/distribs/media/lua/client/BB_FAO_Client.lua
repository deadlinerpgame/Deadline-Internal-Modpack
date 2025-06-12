-- **************************************************
-- ██████  ██████   █████  ██    ██ ███████ ███    ██ 
-- ██   ██ ██   ██ ██   ██ ██    ██ ██      ████   ██ 
-- ██████  ██████  ███████ ██    ██ █████   ██ ██  ██ 
-- ██   ██ ██   ██ ██   ██  ██  ██  ██      ██  ██ ██ 
-- ██████  ██   ██ ██   ██   ████   ███████ ██   ████
-- **************************************************

FirstAidOverhaul = {}
FirstAidOverhaul.practiceCooldown = 0

local function onInitGlobalModData()
    if not isClient() then return end
    FirstAidOverhaul = ModData.getOrCreate("FirstAidOverhaul")
    FirstAidOverhaul.practiceCooldown = FirstAidOverhaul.practiceCooldown or 0
end

-- Patched out the Cheat Button

local function everyMinute()
    if SandboxVars.FirstAidOverhaul.InfectionDiseaseLimit == 0 then return end
    if SandboxVars.FirstAidOverhaul.MaxDiseasePerWound == 0 then return end

    local playerObj = getPlayer(); if not playerObj then return end
    local bodyDamage = playerObj:getBodyDamage(); if not bodyDamage then return end
    local bodyParts = bodyDamage:getBodyParts()
    local infectedParts = 0
    local maxSickness = 0

    for i=0,BodyPartType.ToIndex(BodyPartType.MAX) - 1 do
        local bodyPart = bodyParts:get(i)

        if bodyPart:getWoundInfectionLevel() > 0 then
            infectedParts = infectedParts + 1
            maxSickness = maxSickness + SandboxVars.FirstAidOverhaul.MaxDiseasePerWound
        end
    end

    if maxSickness > SandboxVars.FirstAidOverhaul.InfectionDiseaseLimit then maxSickness = SandboxVars.FirstAidOverhaul.InfectionDiseaseLimit end

    local sicknessLevel = bodyDamage:getFoodSicknessLevel()
    if sicknessLevel < maxSickness and infectedParts > 0 then
        bodyDamage:setFoodSicknessLevel(sicknessLevel + (infectedParts / 4))
    end

    if not FirstAidOverhaul.practiceCooldown then return end
    if FirstAidOverhaul.practiceCooldown <= 0 then return end
    FirstAidOverhaul.practiceCooldown = FirstAidOverhaul.practiceCooldown - 1
end

Events.OnInitGlobalModData.Add(onInitGlobalModData)
Events.EveryOneMinute.Add(everyMinute)