local MenuDock = require("ElyonLib/UI/MenuDock/MenuDock")
local AccessLevelUtils = require("ElyonLib/PlayerUtils/AccessLevelUtils")
local Options = require("KnoxBuildworks/Options")

local EditorDock = {}

local function isEditorAllowed(playerObj)
    if AccessLevelUtils.isSinglePlayer() then
        return isDebugEnabled() == true
    end
    return AccessLevelUtils.hasAdminAccess(playerObj)
end

local function visibleWhen(playerNum, playerObj)
    local option = Options:getOption("ShowMenuDock")
    if option and option:getValue() ~= true then return false end
    return isEditorAllowed(playerObj or AccessLevelUtils.getPlayer(playerNum))
end

local function openEditor(playerNum)
    local player = getSpecificPlayer(playerNum)
    if not player then return end
    if not isEditorAllowed(player) then return end
    local Editor = require("KnoxBuildworks/Admin/BuildableEditor")
    Editor.open(player)
end

function EditorDock.register()
    MenuDock.registerButton({
        id = "KnoxBuildworks.BuildableEditor",
        title = getText("IGUI_KBW_AdminEditorDockTooltip"),
        label = getText("IGUI_KBW_AdminEditorDockLabel"),
        icon = "media/ui/KBW_Dock_BuildableRules.png",
        onClick = openEditor,
        visibleWhen = visibleWhen,
        minimumAccessLevel = "Admin",
        allowSinglePlayer = true
    })
end

EditorDock.register()

return EditorDock
