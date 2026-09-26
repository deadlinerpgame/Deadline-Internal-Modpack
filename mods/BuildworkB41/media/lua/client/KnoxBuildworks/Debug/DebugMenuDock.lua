local MenuDock = require("ElyonLib/UI/MenuDock/MenuDock")
local Options = require("KnoxBuildworks/Options")

local DebugMenuDock = {}

local function visibleWhen()
    local option = Options:getOption("ShowMenuDock")
    return (not option or option:getValue() == true) and isDebugEnabled() == true
end

local function openBuildTests(playerNum)
    local player = getSpecificPlayer(playerNum)
    local Window = require("KnoxBuildworks/UI/DebugBuildTestWindow")
    Window.open(player)
end

local function openTileBrowser(playerNum)
    local player = getSpecificPlayer(playerNum)
    local Browser = require("KnoxBuildworks/UI/DebugTileBrowser")
    Browser.open(player)
end

function DebugMenuDock.register()
    MenuDock.registerButton({
        id = "KnoxBuildworks.DebugBuildTests",
        title = getText("IGUI_KBW_DebugTestDockTooltip"),
        label = getText("IGUI_KBW_DebugTestDockLabel"),
        icon = "media/ui/KBW_Dock_TestRunner.png",
        onClick = openBuildTests,
        visibleWhen = visibleWhen
    })
    MenuDock.registerButton({
        id = "KnoxBuildworks.DebugTileBrowser",
        title = getText("IGUI_KBW_DebugTilesDockTooltip"),
        label = getText("IGUI_KBW_DebugTilesDockLabel"),
        icon = "media/ui/KBW_Dock_TileBrowser.png",
        onClick = openTileBrowser,
        visibleWhen = visibleWhen
    })
end

DebugMenuDock.register()

return DebugMenuDock
