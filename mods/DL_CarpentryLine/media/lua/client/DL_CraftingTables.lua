DLCraftingTables = {}

DLCraftingTables.list = {
    {
        name = "Distiller",
        label = "ContextMenu_Distiller",
        description = "Tooltip_Distiller_Description",
        icon = "dl_workbenches_15",
        kit = "Base.DistillerConstructionSet",
        tool = "Screwdriver",
        anim = "VehicleTrailer",
        sound = "RepairWithWrench",
        sprites = {
            west = { "dl_workbenches_14", "dl_workbenches_15" },
            north = { "dl_workbenches_18", "dl_workbenches_19" },
            east = { "dl_workbenches_12", "dl_workbenches_13" },
            south = { "dl_workbenches_16", "dl_workbenches_17" },
        },
    },
    {
        name = "BrewingStation",
        label = "ContextMenu_BrewingStation",
        description = "Tooltip_BrewingStation_Description",
        icon = "dl_workbenches_20",
        kit = "Base.BrewingStationConstructionSet",
        tool = "Hammer",
        skills = { Woodwork = 4 },
        anim = "VehicleTrailer",
        sound = "RepairWithWrench",
        sprites = {
            west = { "dl_workbenches_21" },
            north = { "dl_workbenches_20" },
            east = { "dl_workbenches_21" },
            south = { "dl_workbenches_20" },
        },
    },
    {
        name = "Digester",
        label = "ContextMenu_Digester",
        description = "Tooltip_Digester_Description",
        icon = "dl_workbenches_0",
        kit = "Base.DigesterConstructionSet",
        tool = "Hammer",
        anim = "VehicleTrailer",
        sound = "RepairWithWrench",
        sprites = {
            west = { "dl_workbenches_3" },
            north = { "dl_workbenches_1" },
            east = { "dl_workbenches_2" },
            south = { "dl_workbenches_0" },
        },
    },
    {
        name = "Drying Rack",
        label = "ContextMenu_DryingRack",
        description = "Tooltip_DryingRack_Description",
        icon = "aerx_tools_82",
        kit = "Base.DryingRackConstructionSet",
        tool = "Hammer",
        anim = "Build",
        sprites = {
            west = { "aerx_tools_82", "aerx_tools_83" },
            north = { "aerx_tools_84", "aerx_tools_85" },
            east = { "aerx_tools_82", "aerx_tools_83" },
            south = { "aerx_tools_84", "aerx_tools_85" },
        },
    },
    {
        name = "Butchering Hook",
        label = "ContextMenu_ButcheringHook",
        description = "Tooltip_ButcheringHook_Description",
        icon = "aerx_tools_15",
        kit = "Base.ButcheringHookConstructionSet",
        tool = "Hammer",
        anim = "VehicleTrailer",
        sound = "RepairWithWrench",
        sprites = {
            west = { "aerx_tools_15" },
            north = { "aerx_tools_15" },
            east = { "aerx_tools_15" },
            south = { "aerx_tools_15" },
        },
    },
    {
        name = "PaintMixingTable",
        label = "ContextMenu_PaintMixingTable",
        description = "Tooltip_PaintMixingTable_Description",
        icon = "core_workbenches_1",
        kit = "Base.PaintMixingConstructionSet",
        tool = "Hammer",
        skills = { Woodwork = 6 },
        anim = "VehicleTrailer",
        sound = "RepairWithWrench",
        sprites = {
            west = { "core_workbenches_0", "core_workbenches_1" },
            north = { "core_workbenches_2", "core_workbenches_3" },
            east = { "core_workbenches_4", "core_workbenches_5" },
            south = { "core_workbenches_6", "core_workbenches_7" },
        },
    },
}

local function notBroken(item)
    return not item:isBroken()
end

local function newBuildObject(def)
    local s = def.sprites
    local obj
    if s.west[2] then
        obj = DLDoubleTileTable:new(def.name, s.west[1], s.west[2], s.north[1], s.north[2], s.east[1], s.east[2], s.south[1], s.south[2])
    else
        obj = ISSimpleFurniture:new(def.name, s.west[1], s.north[1])
        obj:setEastSprite(s.east[1])
        obj:setSouthSprite(s.south[1])
    end
    obj.name = def.name
    obj.actionAnim = def.anim
    if def.sound then
        obj.craftingBank = def.sound
        obj.noNeedHammer = true
    end
    obj.modData["need:" .. def.kit] = 1
    return obj
end

local function onBuild(_, def, playerNum)
    local obj = newBuildObject(def)
    obj.player = playerNum
    getCell():setDrag(obj, playerNum)
end

local function line(ok, text)
    return (ok and " <RGB:1,1,1> " or " <RGB:1,0,0> ") .. text .. " <LINE> "
end

local function addTable(subMenu, playerNum, playerObj, def)
    local option = subMenu:addOption(getText(def.label), nil, onBuild, def, playerNum)
    local inv = playerObj:getInventory()
    local cheat = ISBuildMenu.cheat
    local text = getText(def.description) .. " <LINE> "

    local hasTool = cheat or inv:getFirstTypeEvalRecurse(def.tool, notBroken) ~= nil
    text = text .. line(hasTool, getText("ContextMenu_RequireTool") .. " " .. getItemNameFromFullType("Base." .. def.tool))

    local kits = inv:getItemCountFromTypeRecurse(def.kit)
    local hasKit = cheat or kits >= 1
    text = text .. line(hasKit, getItemNameFromFullType(def.kit) .. " " .. math.min(kits, 1) .. "/1")

    local hasSkills = true
    for perk, level in pairs(def.skills or {}) do
        local current = playerObj:getPerkLevel(Perks[perk])
        local ok = cheat or current >= level
        hasSkills = hasSkills and ok
        text = text .. line(ok, getText("IGUI_perks_" .. perk) .. " " .. current .. "/" .. level)
    end

    local tooltip = ISWorldObjectContextMenu.addToolTip()
    tooltip:setName(getText(def.label))
    tooltip:setTexture(def.icon)
    tooltip.description = text
    option.toolTip = tooltip
    option.notAvailable = not (hasTool and hasKit and hasSkills)
end

function DLCraftingTables.onFillWorldObjectContextMenu(playerNum, context, worldobjects, test)
    if test then return end
    local playerObj = getSpecificPlayer(playerNum)
    if playerObj:getVehicle() then return end

    local option = context:insertOptionAfter(getText("ContextMenu_Build"), getText("ContextMenu_Tables"))
    local subMenu = ISContextMenu:getNew(context)
    context:addSubMenu(option, subMenu)
    for _, def in ipairs(DLCraftingTables.list) do
        addTable(subMenu, playerNum, playerObj, def)
    end
end

Events.OnFillWorldObjectContextMenu.Add(DLCraftingTables.onFillWorldObjectContextMenu)
