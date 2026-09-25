local KBW = require("KnoxBuildworks/Core")
local I18n = require("KnoxBuildworks/I18n")
local Options = require("KnoxBuildworks/Options")

local ContextMenu = {}

local function planningEnabled()
    return KBW.sandboxValue("KnoxBuildworks.EnablePlanningMode", true) == true
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

local function fillContextMenu(playerNum, context, worldObjects, test)
    if test and ISWorldObjectContextMenu.Test then return true end
    local player = getSpecificPlayer(playerNum)
    if not player or player:isDead() then return false end
    if test then return ISWorldObjectContextMenu.setTest() end

    local title = I18n.text("IGUI_KBW_Title", "Knox Buildworks")
    local parent = context:addOption(title, playerNum, nil)
    local submenu = ISContextMenu:getNew(context)
    context:addSubMenu(parent, submenu)

    local catalogOption = submenu:addOption(
        I18n.text("IGUI_KBW_ContextOpenCatalog", "Open Build Catalog"), playerNum, openCatalog
    )
    local binding = Options:getOption("OpenCatalog")
    local keyCode = binding and binding:getValue() or nil
    if keyCode and getKeyName then
        local keyName = getKeyName(keyCode)
        if keyName and keyName ~= "" then
            catalogOption.toolTip = ISWorldObjectContextMenu.addToolTip()
            catalogOption.toolTip:setName(title)
            catalogOption.toolTip.description = I18n.text(
                "IGUI_KBW_ContextCatalogTooltip", "Shortcut"
            ) .. ": " .. tostring(keyName)
        end
    end

    if planningEnabled() then
        submenu:addOption(
            I18n.text("IGUI_KBW_PlanningMode", "Planning Mode"), playerNum, openPlanning
        )
    end
    return true
end

ContextMenu.fill = fillContextMenu

local KBWB41 = require("KnoxBuildworks/Compat/B41")
KBWB41.addEvent("OnFillWorldObjectContextMenu", fillContextMenu)

return ContextMenu
