local weaponJamChances = {
    T1Pistol1   = 25,
    T1Pistol2   = 25,
    T1Shotgun1  = 30,
    T1Shotgun2  = 30,
    T1Revolver  = 40,
}


Events.OnWeaponSwing.Add(function(player, weapon)
    if not player or not weapon then return end

    local weaponType = weapon:getType()
    local jamChance = weaponJamChances[weaponType]

    if jamChance then
        if ZombRand(100) < jamChance then
            weapon:setJammed(true)

        end
    end
end)