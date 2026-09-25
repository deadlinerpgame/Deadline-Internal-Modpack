local MenuDock = require("ElyonLib/UI/MenuDock/MenuDock")
local Options = require("KnoxBuildworks/Options")
local KBW = require("KnoxBuildworks/Core")

local CatalogDock = {}

local function dockVisible()
    local option = Options:getOption("ShowMenuDock")
    return not option or option:getValue() == true
end

local function planningVisible()
    return dockVisible() and KBW.sandboxValue("KnoxBuildworks.EnablePlanningMode", true) == true
end

local function openCatalog(playerNum)
    local player = getSpecificPlayer(playerNum) or getPlayer()
    if not player then return end
    local Catalog = require("KnoxBuildworks/UI/Catalog")
    if KBWPlanningMode and KBWPlanningMode.instance then KBWPlanningMode.instance:close() end
    if KBWCatalog and KBWCatalog.instance then
        KBWCatalog.instance:close()
    else
        Catalog.open(player)
    end
end

local function openPlanning(playerNum)
    local player = getSpecificPlayer(playerNum) or getPlayer()
    if not player then return end
    local PlanningMode = require("KnoxBuildworks/UI/PlanningMode")
    if KBWCatalog and KBWCatalog.instance then KBWCatalog.instance:close() end
    if PlanningMode.instance then
        PlanningMode.instance:close()
    else
        PlanningMode.open(player)
    end
end

function CatalogDock.register()
    MenuDock.registerButton({
        id = "KnoxBuildworks.Catalog",
        title = getText("IGUI_KBW_Title"),
        label = getText("IGUI_KBW_Title"),
        icon = "media/ui/KBW_Planning_Mode.png",
        onClick = openCatalog,
        visibleWhen = dockVisible
    })
    MenuDock.registerButton({
        id = "KnoxBuildworks.PlanningMode",
        title = getText("IGUI_KBW_PlanningMode"),
        label = getText("IGUI_KBW_PlanningMode"),
        icon = "media/ui/KBW_Planning_Mode.png",
        onClick = openPlanning,
        visibleWhen = planningVisible
    })
end

CatalogDock.register()

return CatalogDock
