local function reapplyAllPlayers()
    for i = 0, 3 do
        local p = getSpecificPlayer(i)
        if p then DLRepair.reapplyForCharacter(p) end
    end
end

local function onCreatePlayer(playerIndex, player)
    DLRepair.reapplyForCharacter(player)
end

local function onEquip(character, item)
    if item and instanceof(item, "HandWeapon") then
        DLRepair.reapplyReinforcement(item)
    end
end

Events.OnGameStart.Add(reapplyAllPlayers)
Events.OnCreatePlayer.Add(onCreatePlayer)
Events.OnEquipPrimary.Add(onEquip)
Events.OnEquipSecondary.Add(onEquip)
