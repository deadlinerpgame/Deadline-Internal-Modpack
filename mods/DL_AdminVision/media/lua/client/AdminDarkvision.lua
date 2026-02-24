AdminNightvision = {}

AdminNightvision.range = 120
AdminNightvision.indoorBrightness = 0.3
AdminNightvision.outdoorBrightness = 0.8

AdminNightvision.enabled = {}
AdminNightvision.light = {}
AdminNightvision.cell = {}

AdminNightvision.isAdmin = function(player)
    if not player then return false end

    if not isClient() and not isServer() then
        return true
    end

    if isClient() then
        local accessLevel = player:getAccessLevel()
        if accessLevel then
            return accessLevel == "Admin"
        end
    end
    
    return false
end

AdminNightvision.toggle = function(playerIndex)
    local player = getSpecificPlayer(playerIndex)
    if not player or not AdminNightvision.isAdmin(player) then return end
    
    AdminNightvision.enabled[playerIndex] = not AdminNightvision.enabled[playerIndex]
    
    if AdminNightvision.enabled[playerIndex] then
        HaloTextHelper.addText(player, "Nightvision ON", HaloTextHelper.getColorGreen())
    else
        HaloTextHelper.addText(player, "Nightvision OFF", HaloTextHelper.getColorRed())
    end
end

AdminNightvision.removeLight = function(playerIndex)
    local light = AdminNightvision.light[playerIndex]
    local cell = AdminNightvision.cell[playerIndex]
    if light and cell then
        cell:removeLamppost(light)
    end
    AdminNightvision.light[playerIndex] = nil
end

AdminNightvision.onTick = function(ticks)
    if ticks % 5 ~= 0 then return end
    
    for playerIndex = 0, getNumActivePlayers() - 1 do
        local player = getSpecificPlayer(playerIndex)
        if not player then break end

        AdminNightvision.removeLight(playerIndex)

        if player:isAlive() and AdminNightvision.isAdmin(player) and AdminNightvision.enabled[playerIndex] then
            local brightness = AdminNightvision.indoorBrightness
            if player:isOutside() then
                brightness = AdminNightvision.outdoorBrightness
            end
            
            AdminNightvision.light[playerIndex] = IsoLightSource.new(
                player:getX(), player:getY(), player:getZ(),
                brightness, brightness, brightness,
                AdminNightvision.range
            )
            AdminNightvision.cell[playerIndex] = player:getCell()
            player:getCell():addLamppost(AdminNightvision.light[playerIndex])
        end
    end
end

AdminNightvision.onContextMenu = function(playerIndex, context, worldObjects, test)
    if test then return true end
    
    local player = getSpecificPlayer(playerIndex)
    if not player or not AdminNightvision.isAdmin(player) then return end
    
    local isOn = AdminNightvision.enabled[playerIndex]
    local text = isOn and "Turn Off Nightvision" or "Turn On Nightvision"
    
    context:addOption(text, playerIndex, AdminNightvision.toggle)
end

Events.OnTick.Add(AdminNightvision.onTick)
Events.OnFillWorldObjectContextMenu.Add(AdminNightvision.onContextMenu)
