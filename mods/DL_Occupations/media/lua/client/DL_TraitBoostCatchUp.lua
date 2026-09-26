local FLAG = "DLTraitBoostsV1"

local function applyTraitBoosts(player)
    local xp = player:getXp()
    for id, boosts in pairs(DL.TraitBoosts) do
        if player:HasTrait(id) then
            for perk, level in pairs(boosts) do
                if xp:getPerkBoost(perk) < level then
                    xp:setPerkBoost(perk, level)
                end
                if player:getPerkLevel(perk) < level then
                    player:setPerkLevelDebug(perk, level)
                    xp:setXPToLevel(perk, level)
                end
            end
        end
    end
    if isClient() then SyncXp(player) end
end

local function onCreatePlayer(playerIndex, player)
    if not player:isLocalPlayer() then return end
    local md = player:getModData()
    if md[FLAG] then return end
    if player:getHoursSurvived() > 0 then
        applyTraitBoosts(player)
    end
    md[FLAG] = true
end

Events.OnCreatePlayer.Add(onCreatePlayer)
