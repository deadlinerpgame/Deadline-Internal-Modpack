local FLAG = "DLTraitBoostsV3"
local DELAY_MS = 5000

local pending = {}

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

local function catchUp(player)
    local md = player:getModData()
    if md[FLAG] then return end
    if player:getHoursSurvived() > 0 then
        applyTraitBoosts(player)
    end
    md[FLAG] = true
end

local function onCreatePlayer(playerIndex, player)
    if not player:isLocalPlayer() then return end
    pending[#pending + 1] = { player = player, at = getTimestampMs() + DELAY_MS }
end

local function onTick()
    if #pending == 0 then return end
    local now = getTimestampMs()
    local keep = {}
    for _, entry in ipairs(pending) do
        if now < entry.at then
            keep[#keep + 1] = entry
        elseif not entry.player:isDead() then
            catchUp(entry.player)
        end
    end
    pending = keep
end

Events.OnCreatePlayer.Add(onCreatePlayer)
Events.OnTick.Add(onTick)
