
require "AdminCharEditor_Shared"

local function isAdmin(player)
    if not player then return false end
    local accessLevel = player:getAccessLevel()
    if accessLevel then
        accessLevel = accessLevel:lower()
        return accessLevel == "admin" or accessLevel == "moderator" 
            or accessLevel == "gm" or accessLevel == "observer"
    end
    return false
end

local function applySkinTone(player, skinIndex)
    if not player then return false end
    
    local humanVisual = player:getHumanVisual()
    if not humanVisual then return false end
    
    humanVisual:setSkinTextureIndex(skinIndex)
    player:resetModelNextFrame()
    triggerEvent("OnClothingUpdated", player)
    
    return true
end


local function applyGenderChange(player, isFemale)
    if not player then return false end
    
    local desc = player:getDescriptor()
    if not desc then return false end
    
    local humanVisual = player:getHumanVisual()
    if not humanVisual then return false end
    
    local currentSkin = humanVisual:getSkinTextureIndex()
    
    desc:setFemale(isFemale)
    
    if isFemale then
        humanVisual:setBeardModel("")
    end
    
    humanVisual:setSkinTextureIndex(currentSkin)
    player:resetModelNextFrame()
    triggerEvent("OnClothingUpdated", player)
    
    return true
end

local function onChangeSkinCommand(player, args)
    if not isAdmin(player) then
        print("[AdminCharEditor] Non-admin tried to change skin: " .. tostring(player:getUsername()))
        return
    end
    
    local skinIndex = args.skinIndex
    if skinIndex == nil then return end
    
    if skinIndex < 0 or skinIndex > 4 then
        sendServerCommand(player, "AdminCharEditor", AdminCharEditor.Commands.SYNC_VISUAL, {
            success = false,
            message = "Invalid skin index (0-4)"
        })
        return
    end
    
    local success = applySkinTone(player, skinIndex)
    
    if success then
        print("[AdminCharEditor] Server: " .. player:getUsername() .. " changed skin to " .. AdminCharEditor.getSkinColorName(skinIndex))
    end
end

local function onChangeGenderCommand(player, args)
    if not isAdmin(player) then
        print("[AdminCharEditor] Non-admin tried to change gender: " .. tostring(player:getUsername()))
        return
    end
    
    local isFemale = args.isFemale
    if isFemale == nil then return end
    
    local success = applyGenderChange(player, isFemale)
    
    if success then
        print("[AdminCharEditor] Server: " .. player:getUsername() .. " changed gender to " .. AdminCharEditor.getGenderName(isFemale))
    end
end

local function onClientCommand(module, command, player, args)
    if module ~= "AdminCharEditor" then return end
    
    if command == AdminCharEditor.Commands.REQUEST_CHANGE_SKIN then
        onChangeSkinCommand(player, args)
    elseif command == AdminCharEditor.Commands.REQUEST_CHANGE_GENDER then
        onChangeGenderCommand(player, args)
    end
end

Events.OnClientCommand.Add(onClientCommand)

print("[AdminCharEditor] Server module loaded")
