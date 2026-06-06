DL = DL or {}
DL.Wounds = DL.Wounds or {}
DL.Purgatory = DL.Purgatory or {}
DL.Respawn = DL.Respawn or {}
DL.Purgatory._desc = DL.Purgatory._desc or nil

if ISPostDeathUI == nil then
    DL.warn("purgatory: ISPostDeathUI not found; override not installed")
    return
end

local function captureTraits(player)
    local out = {}
    local t = (function() return player:getTraits() end)()
    if t then for i = 0, t:size() - 1 do out[#out + 1] = t:get(i) end end
    return out
end

local function copyDesc(player)
    local desc = (function() return player:getDescriptor() end)()
    if desc == nil then return nil end
    local copy = (function() return SurvivorDesc.new(desc) end)()
    return copy or desc
end

local function syncVisualFromPlayer(player, desc)
    local _ = (function()
        local lv = player:getHumanVisual()
        local dv = desc and desc:getHumanVisual()
        if lv and dv then dv:copyFrom(lv) end
    end)()
end

local function stageSpawn(hc)
    local x, y, z = hc.x or 0, hc.y or 0, hc.z or 0
    getWorld():setLuaSpawnCellX(math.floor(x / 300))
    getWorld():setLuaSpawnCellY(math.floor(y / 300))
    getWorld():setLuaPosX(x % 300)
    getWorld():setLuaPosY(y % 300)
    getWorld():setLuaPosZ(z)
end

local function instantRespawn(coords, transferAll)
    local player = getPlayer()
    if player == nil then return false end

    local desc   = copyDesc(player)
    if desc then syncVisualFromPlayer(player, desc) end
    local traits = transferAll and captureTraits(player) or {}
    if not transferAll and desc and desc.setProfession then
        pcall(function() desc:setProfession("unemployed") end)
    end
    coords = coords or { x = 10010, y = 11000, z = 0 }

    DL.Purgatory._desc = desc

    CoopCharacterCreation:newPlayerMouse()
    local inst = CoopCharacterCreation.instance
    if inst == nil then return false end

    if desc then MainScreen.instance.desc = desc end

    inst.initPlayer = function() end
    inst.accept1 = function()
        stageSpawn(coords)
        getWorld():setLuaPlayerDesc(MainScreen.instance.desc)
        local lt = getWorld():getLuaTraits()
        lt:clear()
        for _, tr in ipairs(traits) do getWorld():addLuaTrait(tr) end
        MainScreen.instance.avatar = nil
        return true
    end

    inst:accept()
    return true
end

Events.OnCreatePlayer.Add(function(playerIndex, player)
    local d = DL.Purgatory._desc
    if d == nil then return end
    player = player or getSpecificPlayer(playerIndex)
    if player == nil or not player:isLocalPlayer() then return end
    DL.Purgatory._desc = nil
    local _ = (function()
        local nv = player:getHumanVisual()
        local dv = d:getHumanVisual()
        if nv and dv then nv:copyFrom(dv) end

        local ndesc = player.getDescriptor and player:getDescriptor()
        if ndesc and ndesc:getHumanVisual() and dv then ndesc:getHumanVisual():copyFrom(dv) end
        if player.resetModelNextFrame then player:resetModelNextFrame()
        elseif player.resetModel then player:resetModel() end
    end)()
    DL.log("purgatory: applied saved appearance to respawned character")
end)

local _onRespawn = ISPostDeathUI.onRespawn
function ISPostDeathUI:onRespawn()
    local coords, transferAll
    if DL.OverkillRescue and DL.OverkillRescue.pending then
        coords = DL.OverkillRescue.coords
              or (DL.Config and DL.Config.respawnDefault)
              or { x = 10010, y = 11000, z = 0 }
        transferAll = true
    elseif DL.Wounds and DL.Wounds.pendingToCell then
        coords = DL.Wounds.cell or { x = 10000, y = 11000, z = 0 }
        transferAll = true
    else
        coords = (DL.Respawn and DL.Respawn.point)
              or (DL.Config and DL.Config.respawnDefault)
              or { x = 10010, y = 11000, z = 0 }
        transferAll = false
    end
    local ok = (function() return instantRespawn(coords, transferAll) end)()
    if ok then return end
    DL.warn("instant respawn failed; falling back to vanilla respawn")
    _onRespawn(self)
end

DL.log("purgatory respawn override loaded")
