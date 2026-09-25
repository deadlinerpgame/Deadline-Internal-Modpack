DL = DL or {}
DL.TutorialKit = DL.TutorialKit or {}
local T = DL.TutorialKit

T.spawnItems = {
    ["Base.CannedSardines"] = 3,
    ["Base.Garbagebag"] = 1,
    ["Base.Mirror"] = 1,
    ["Base.WaterBottleFull"] = 4,
    ["ElliesTattooParlor.FilledTattooNeedle"] = 1,
    ["KeksTat.CharacterTatNeedle"] = 1,
    ["Radio.WalkieTalkie2"] = 1,
    ["SPolishItems.CharacterSheet"] = 1,
    ["aerx.TreeBranch_Nails"] = 1,
    ["aerx.BowlingPin"] = 1,
    ["Bicycle.Bicycle"] = 1,
    ["Base.HandTorch"] = 1,
    ["Base.Lighter"] = 1,
    ["Base.Matches"] = 1,
}

T.removeItems = {
    ["Base.Mirror"] = 1,
    ["ElliesTattooParlor.FilledTattooNeedle"] = 1,
    ["KeksTat.CharacterTatNeedle"] = 1,
    ["SPolishItems.CharacterSheet"] = 1,
}

T.pickerTiles = {
    ["deadline_respawnpoints_02"] = true,
}

T.newCharacterHours = 0.05
T.giveDelayMs = 1000
T.rekitDelayMs = 5000
T.teleportDistance = 50

local STATE = "DLTutorialKit"
local REMOVED = "DLTutorialKitRemoved"

local queue = {}
local watching = {}

local function schedule(player, delay)
    queue[#queue + 1] = { player = player, dueAt = getTimestampMs() + delay }
end

local function topUp(player)
    local inv = player:getInventory()
    for fullType, count in pairs(T.spawnItems) do
        local missing = count - inv:getCountTypeRecurse(fullType)
        if missing > 0 then
            inv:AddItems(fullType, missing)
        end
    end
    ISInventoryPage.dirtyUI()
end

local function takeAway(player, item)
    player:removeFromHands(item)
    player:removeWornItem(item)
    player:removeAttachedItem(item)
    item:getContainer():DoRemoveItem(item)
end

local function strip(player)
    local removed = player:getModData()[REMOVED]
    for fullType, limit in pairs(T.removeItems) do
        local count = removed[fullType] or 0
        local items = player:getInventory():getAllTypeRecurse(fullType)
        for i = 0, items:size() - 1 do
            if count >= limit then break end
            takeAway(player, items:get(i))
            count = count + 1
        end
        removed[fullType] = count
    end
    ISInventoryPage.dirtyUI()
end

local function onPicker(square)
    local objects = square:getObjects()
    for i = 0, objects:size() - 1 do
        local sprite = objects:get(i):getSprite()
        if sprite and T.pickerTiles[sprite:getName()] then
            return true
        end
    end
    return false
end

Events.OnCreatePlayer.Add(function(playerIndex, player)
    if not player:isLocalPlayer() then return end
    watching[playerIndex] = nil
    local md = player:getModData()
    if md[STATE] == nil then
        if DBNO.Respawn._md ~= nil or player:getHoursSurvived() > T.newCharacterHours then
            md[STATE] = "done"
            return
        end
        md[STATE] = "pending"
        md[REMOVED] = {}
    end
    if md[STATE] == "pending" then
        schedule(player, T.giveDelayMs)
    end
end)

Events.OnTick.Add(function()
    if #queue == 0 then return end
    local now = getTimestampMs()
    local keep = {}
    for _, job in ipairs(queue) do
        if now < job.dueAt then
            keep[#keep + 1] = job
        elseif not job.player:isDead() then
            local md = job.player:getModData()
            if md[STATE] == "pending" or md[STATE] == "given" then
                topUp(job.player)
                md[STATE] = "given"
            end
        end
    end
    queue = keep
end)

Events.OnServerCommand.Add(function(module, command)
    if module ~= "DBNORescue" or command ~= "respawnKit" then return end
    local player = getPlayer()
    if player == nil then return end
    local state = player:getModData()[STATE]
    if state == "pending" or state == "given" then
        schedule(player, T.rekitDelayMs)
    end
end)

Events.OnPlayerUpdate.Add(function(player)
    if not player:isLocalPlayer() then return end
    local md = player:getModData()
    local state = md[STATE]
    if state ~= "given" and state ~= "picking" then return end

    local index = player:getPlayerNum()
    local x, y = player:getX(), player:getY()
    local w = watching[index]
    if w == nil then
        w = { x = x, y = y }
        watching[index] = w
    end
    local jumped = math.abs(x - w.x) + math.abs(y - w.y) > T.teleportDistance
    w.x, w.y = x, y

    if state == "picking" and jumped then
        strip(player)
        md[STATE] = "done"
        watching[index] = nil
        return
    end

    local square = player:getCurrentSquare()
    if square == w.square then return end
    w.square = square
    if square ~= nil and onPicker(square) then
        md[STATE] = "picking"
        strip(player)
    end
end)
