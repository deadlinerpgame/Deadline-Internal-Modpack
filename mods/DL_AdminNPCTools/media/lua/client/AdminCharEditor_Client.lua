
require "AdminCharEditor_Shared"

local function isAdmin()
    local player = getPlayer()
    if not player then return false end
    
    if not isClient() then
        return true
    end
    
    local accessLevel = player:getAccessLevel()
    if accessLevel then
        return accessLevel == "Admin"
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
function AdminCharEditor_ChangeSkin(player, skinIndex)
    if not player or skinIndex == nil then return false end

    local success = applySkinTone(player, skinIndex)

    if success and isClient() then
        sendClientCommand(player, "AdminCharEditor", AdminCharEditor.Commands.REQUEST_CHANGE_SKIN, {
            skinIndex = skinIndex
        })
        sendVisual(player)
    end
    
    return success
end

function AdminCharEditor_ChangeGender(player, isFemale)
    if not player or isFemale == nil then return false end

    local success = applyGenderChange(player, isFemale)
    
    if success and isClient() then
        sendClientCommand(player, "AdminCharEditor", AdminCharEditor.Commands.REQUEST_CHANGE_GENDER, {
            isFemale = isFemale
        })
        sendVisual(player)
    end
    
    return success
end

local function onFillWorldObjectContextMenu(playerNum, context, worldobjects, test)
    if test then return end
    if not isAdmin() then return end
    
    local player = getSpecificPlayer(playerNum)
    if not player then return end
    
    local desc = player:getDescriptor()

    local mainOption = context:addOption("Admin Character Editor")
    local mainSubMenu = ISContextMenu:getNew(context)
    context:addSubMenu(mainOption, mainSubMenu)
    
    local genderOption = mainSubMenu:addOption("Change Gender (requires relog)")
    local genderSubMenu = ISContextMenu:getNew(mainSubMenu)
    mainSubMenu:addSubMenu(genderOption, genderSubMenu)
    
    local currentIsFemale = desc and desc:isFemale() or false
    
    genderSubMenu:addOption("Male" .. (not currentIsFemale and " [Current]" or ""), player, function(p)
        AdminCharEditor_ChangeGender(p, false)
        p:Say("Gender set to Male - save and relog to apply")
    end)
    
    genderSubMenu:addOption("Female" .. (currentIsFemale and " [Current]" or ""), player, function(p)
        AdminCharEditor_ChangeGender(p, true)
        p:Say("Gender set to Female - save and relog to apply")
    end)
    
    local skinOption = mainSubMenu:addOption("Change Skin Color")
    local skinSubMenu = ISContextMenu:getNew(mainSubMenu)
    mainSubMenu:addSubMenu(skinOption, skinSubMenu)
    
    local humanVisual = player:getHumanVisual()
    local currentSkinIndex = humanVisual and humanVisual:getSkinTextureIndex() or 0
    
    for _, skin in ipairs(AdminCharEditor.SkinColors) do
        local label = skin.name
        if skin.index == currentSkinIndex then
            label = label .. " [Current]"
        end
        local idx = skin.index 
        skinSubMenu:addOption(label, player, function(p)
            AdminCharEditor_ChangeSkin(p, idx)
        end)
    end
end

local function onServerCommand(module, command, args)
    if module ~= "AdminCharEditor" then return end
    
    if command == AdminCharEditor.Commands.SYNC_VISUAL then
        if args and args.message then
            local player = getPlayer()
            if player then
                player:Say(args.message)
            end
        end
    end
end

Events.OnFillWorldObjectContextMenu.Add(onFillWorldObjectContextMenu)
Events.OnServerCommand.Add(onServerCommand)

print("[AdminCharEditor] Client module loaded")
