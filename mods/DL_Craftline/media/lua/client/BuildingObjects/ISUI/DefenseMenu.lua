-- Quick, dirty fix to force the level req to 10

local onWoodenChevalDeFrise = function(worldobjects, sprite, player)
    local defense = ISDoubleTileDefense:new("WoodenChevalDeFrise", sprite.sprite, sprite.sprite2, sprite.northSprite, sprite.northSprite2)
        defense:setSprite(sprite.sprite)
        defense:setNorthSprite(sprite.northSprite)
    defense.modData["xp:Woodwork"] = 20
    defense.modData["need:Base.Plank"] = "1" 
    defense.modData["need:Base.WoodenStick"] = "8" 
    local sheets = ISBuildMenu.countMaterial(player, "Base.RippedSheets");
    local sheetsDirty = ISBuildMenu.countMaterial(player, "Base.RippedSheetsDirty");
    if sheets >= 4 then sheets = 4; sheetsDirty = 0 end
    if sheetsDirty >= 4 then sheetsDirty = 4; sheets = 0 end
    if sheets < 4 and sheetsDirty > 0 then sheetsDirty = 4 - sheets; end
    if sheets + sheetsDirty >= 4 then
        if sheets > 0 then defense.modData["need:Base.RippedSheets"] = tostring(sheets); end
        if sheetsDirty > 0 then defense.modData["need:Base.RippedSheetsDirty"] = tostring(sheetsDirty); end 
    end
    defense.player = player
    defense.completionSound = "BuildWoodenStructureLarge"
    defense.modData.BarricadeDamageMultiplier = SandboxVars.ChevalDeFrise.WoodDamage
    getCell():setDrag(defense, player)
end

-- Display ObjectDefense tooltip and if buildable  
local WoodenChevalDeFrise = function(subMenu, sprite, player)
    local option_name = getText("ContextMenu_WoodenChevalDeFrise")
    WoodenChevalDeFriseOption = subMenu:addOption(option_name, worldobjects, onWoodenChevalDeFrise, sprite, player)
    -- create a new tooltip
    local tooltip = ISBuildMenu.addToolTip()
    WoodenChevalDeFriseOption.toolTip = tooltip
    local result = true
    tooltip.description = "<LINE> <LINE>" .. getText("Tooltip_craft_Needs") .. ": <LINE>"
    -- check for material count
    local mat1 = ISBuildMenu.countMaterial(player, "Base.Plank")
    local mat1_req = 1
    if mat1 >= mat1_req then
        tooltip.description = tooltip.description .. " <RGB:0,1,0> " .. getItemNameFromFullType("Base.Plank") .. " " .. mat1 .. "/" .. mat1_req .. " <LINE>";
    else
        tooltip.description = tooltip.description .. " <RGB:1,0,0> " .. getItemNameFromFullType("Base.Plank") .. " " .. mat1 .. "/" .. mat1_req .. " <LINE>";
        result = false
    end
    local mat2 = ISBuildMenu.countMaterial(player, "Base.WoodenStick")
    local mat2_req = 8
    if mat2 >= mat2_req then
        tooltip.description = tooltip.description .. " <RGB:0,1,0> " .. getItemNameFromFullType("Base.WoodenStick") .. " " .. mat2 .. "/" .. mat2_req .. " <LINE>";
    else
        tooltip.description = tooltip.description .. " <RGB:1,0,0> " .. getItemNameFromFullType("Base.WoodenStick") .. " " .. mat2 .. "/" .. mat2_req .. " <LINE>";
        result = false
    end
    local mat3 = ISBuildMenu.countMaterial(player, "Base.RippedSheets") + ISBuildMenu.countMaterial(player, "Base.RippedSheetsDirty")
    local mat3_req = 4
    if mat3 >= mat3_req then
        tooltip.description = tooltip.description .. " <RGB:0,1,0> " .. getItemNameFromFullType("Base.RippedSheets") .. " " .. mat3 .. "/" .. mat3_req .. " <LINE>";
    else		
        tooltip.description = tooltip.description .. " <RGB:1,0,0> " .. getItemNameFromFullType("Base.RippedSheets") .. " " .. mat3 .. "/" .. mat3_req .. " <LINE>";
        result = false 
    end

    -- check for specific skill
    local skill = getSpecificPlayer(player):getPerkLevel(Perks.Woodwork) 
    local skill_req = 10
    if skill >= skill_req then
        tooltip.description = tooltip.description .. " <RGB:0,1,0> " .. getText("IGUI_perks_Carpentry") .. " " .. skill .. "/" .. skill_req .. " <LINE>";
    else
        tooltip.description = tooltip.description .. " <RGB:1,0,0> " .. getText("IGUI_perks_Carpentry") .. " " .. skill .. "/" .. skill_req .. " <LINE>";
        result = false
    end 
    if not result and not ISBuildMenu.cheat then
        WoodenChevalDeFriseOption.onSelect = nil
        WoodenChevalDeFriseOption.notAvailable = true
    end
    tooltip.description = " " .. tooltip.description .. " "
    tooltip:setName(option_name)
    tooltip.description = getText("Tooltip_WoodenChevalDeFrise") .. tooltip.description
    tooltip:setTexture(sprite.sprite)
    ISBuildMenu.requireHammer(WoodenChevalDeFriseOption)
end

local onMetalChevalDeFrise1 = function(worldobjects, sprite, player, torchUse)
    local defense = ISDoubleTileDefense:new("MetalChevalDeFrise", sprite.sprite, sprite.sprite2, sprite.northSprite, sprite.northSprite2)
    defense:setSprite(sprite.sprite)
    defense:setNorthSprite(sprite.northSprite)
    defense.firstItem = "BlowTorch";
    defense.secondItem = "WeldingMask";
    defense.craftingBank = "BlowTorch";
    defense.noNeedHammer = true;
    defense.actionAnim = "BlowTorchMid";
    defense.modData["xp:MetalWelding"] = 20
    defense.modData["need:Base.ScrapMetal"] = "2" 
    defense.modData["need:Base.MetalPipe"] = "4" 
    defense.modData["use:Base.BlowTorch"] = "1";
    defense.modData["use:Base.WeldingRods"] = ISBlacksmithMenu.weldingRodUses(torchUse);
    defense.player = player
    defense.completionSound = "BuildMetalStructureMedium"
    defense.modData.BarricadeDamageMultiplier = SandboxVars.ChevalDeFrise.MetalDamage
    getCell():setDrag(defense, player)
end

-- Display ObjectDefense tooltip and if buildable  
local MetalChevalDeFrise1 = function(subMenu, sprite, player)
    local option_name = getText("ContextMenu_MetalChevalDeFrise")
    MetalChevalDeFriseOption = subMenu:addOption(option_name, worldobjects, onMetalChevalDeFrise1, sprite, player, "20")
    -- create a new tooltip
    local tooltip = ISBuildMenu.addToolTip()
    MetalChevalDeFriseOption.toolTip = tooltip
    local result = true
    tooltip.description = "<LINE> <LINE>" .. getText("Tooltip_craft_Needs") .. ": <LINE>"
    -- check for material count
    local mat1 = ISBuildMenu.countMaterial(player, "Base.ScrapMetal")
    local mat1_req = 2
    if mat1 >= mat1_req then
	tooltip.description = tooltip.description .. " <RGB:0,1,0> " .. getItemNameFromFullType("Base.ScrapMetal") .. " " .. mat1 .. "/" .. mat1_req .. " <LINE>";
    else
	tooltip.description = tooltip.description .. " <RGB:1,0,0> " .. getItemNameFromFullType("Base.ScrapMetal") .. " " .. mat1 .. "/" .. mat1_req .. " <LINE>";
	result = false
    end	
    local mat2 = ISBuildMenu.countMaterial(player, "Base.MetalPipe")
    local mat2_req = 4
    if mat2 >= mat2_req then
	tooltip.description = tooltip.description .. " <RGB:0,1,0> " .. getItemNameFromFullType("Base.MetalPipe") .. " " .. mat2 .. "/" .. mat2_req .. " <LINE>";
    else
	tooltip.description = tooltip.description .. " <RGB:1,0,0> " .. getItemNameFromFullType("Base.MetalPipe") .. " " .. mat2 .. "/" .. mat2_req .. " <LINE>";
	result = false
    end
    local mat3 = ISBuildMenu.countMaterial(player, "Base.WeldingRods")
    local mat3_req = 1
    if mat3 >= mat3_req then
        tooltip.description = tooltip.description .. " <RGB:0,1,0> " .. getItemNameFromFullType("Base.WeldingRods") .. " " .. mat3 .. "/" .. mat3_req .. " <LINE>";
    else		
        tooltip.description = tooltip.description .. " <RGB:1,0,0> " .. getItemNameFromFullType("Base.WeldingRods") .. " " .. mat3 .. "/" .. mat3_req .. " <LINE>";
        result = false 
    end
    -- check for specific skill
    local skill = getSpecificPlayer(player):getPerkLevel(Perks.MetalWelding) 
    local skill_req = 3
    if skill >= skill_req then
	tooltip.description = tooltip.description .. " <RGB:0,1,0> " .. getText("IGUI_perks_MetalWelding") .. " " .. skill .. "/" .. skill_req .. " <LINE>";
    else
	tooltip.description = tooltip.description .. " <RGB:1,0,0> " .. getText("IGUI_perks_MetalWelding") .. " " .. skill .. "/" .. skill_req .. " <LINE>";
	result = false
    end 
    if not result and not ISBuildMenu.cheat then
	MetalChevalDeFriseOption.onSelect = nil
	MetalChevalDeFriseOption.notAvailable = true
    end
    tooltip.description = " " .. tooltip.description .. " "
    tooltip:setName(option_name)
    tooltip.description = getText("Tooltip_MetalChevalDeFrise") .. tooltip.description
    tooltip:setTexture(sprite.sprite)
end

local onMetalChevalDeFrise2 = function(worldobjects, sprite, player, torchUse)
    local defense = ISDoubleTileDefense:new("MetalChevalDeFrise", sprite.sprite, sprite.sprite2, sprite.northSprite, sprite.northSprite2)
    defense:setSprite(sprite.sprite)
    defense:setNorthSprite(sprite.northSprite)
    defense.firstItem = "BlowTorch";
    defense.secondItem = "WeldingMask";
    defense.craftingBank = "BlowTorch";
    defense.noNeedHammer = true;
    defense.actionAnim = "BlowTorchMid";
    defense.modData["xp:MetalWelding"] = 20
    defense.modData["need:Base.ScrapMetal"] = "2" 
    defense.modData["need:Base.SmallSheetMetal"] = "3" 
    defense.modData["use:Base.BlowTorch"] = "1";
    defense.modData["use:Base.WeldingRods"] = ISBlacksmithMenu.weldingRodUses(torchUse);
    defense.player = player
    defense.completionSound = "BuildMetalStructureMedium"
    defense.modData.BarricadeDamageMultiplier = SandboxVars.ChevalDeFrise.MetalDamage
    getCell():setDrag(defense, player)
end
-- Display ObjectDefense tooltip and if buildable  
local MetalChevalDeFrise2 = function(subMenu, sprite, player)
    local option_name = getText("ContextMenu_MetalChevalDeFrise")
    MetalChevalDeFriseOption = subMenu:addOption(option_name, worldobjects, onMetalChevalDeFrise2, sprite, player, "20")
    -- create a new tooltip
    local tooltip = ISBuildMenu.addToolTip()
    MetalChevalDeFriseOption.toolTip = tooltip
    local result = true
    tooltip.description = "<LINE> <LINE>" .. getText("Tooltip_craft_Needs") .. ": <LINE>"
    -- check for material count
    local mat1 = ISBuildMenu.countMaterial(player, "Base.ScrapMetal")
    local mat1_req = 2
    if mat1 >= mat1_req then
	tooltip.description = tooltip.description .. " <RGB:0,1,0> " .. getItemNameFromFullType("Base.ScrapMetal") .. " " .. mat1 .. "/" .. mat1_req .. " <LINE>";
    else
	tooltip.description = tooltip.description .. " <RGB:1,0,0> " .. getItemNameFromFullType("Base.ScrapMetal") .. " " .. mat1 .. "/" .. mat1_req .. " <LINE>";
	result = false
    end	
    local mat2 = ISBuildMenu.countMaterial(player, "Base.SmallSheetMetal")
    local mat2_req = 3
    if mat2 >= mat2_req then
	tooltip.description = tooltip.description .. " <RGB:0,1,0> " .. getItemNameFromFullType("Base.SmallSheetMetal") .. " " .. mat2 .. "/" .. mat2_req .. " <LINE>";
    else
	tooltip.description = tooltip.description .. " <RGB:1,0,0> " .. getItemNameFromFullType("Base.SmallSheetMetal") .. " " .. mat2 .. "/" .. mat2_req .. " <LINE>";
	result = false
    end
    local mat3 = ISBuildMenu.countMaterial(player, "Base.WeldingRods")
    local mat3_req = 1
    if mat3 >= mat3_req then
	tooltip.description = tooltip.description .. " <RGB:0,1,0> " .. getItemNameFromFullType("Base.WeldingRods") .. " " .. mat3 .. "/" .. mat3_req .. " <LINE>";
    else		
	tooltip.description = tooltip.description .. " <RGB:1,0,0> " .. getItemNameFromFullType("Base.WeldingRods") .. " " .. mat3 .. "/" .. mat3_req .. " <LINE>";
	result = false 
    end
    -- check for specific skill
    local skill = getSpecificPlayer(player):getPerkLevel(Perks.MetalWelding) 
    local skill_req = 5
    if skill >= skill_req then
	tooltip.description = tooltip.description .. " <RGB:0,1,0> " .. getText("IGUI_perks_MetalWelding") .. " " .. skill .. "/" .. skill_req .. " <LINE>";
    else
	tooltip.description = tooltip.description .. " <RGB:1,0,0> " .. getText("IGUI_perks_MetalWelding") .. " " .. skill .. "/" .. skill_req .. " <LINE>";
	result = false
    end 
    if not result and not ISBuildMenu.cheat then
	MetalChevalDeFriseOption.onSelect = nil
	MetalChevalDeFriseOption.notAvailable = true
    end
    tooltip.description = " " .. tooltip.description .. " "
    tooltip:setName(option_name)
    tooltip.description = getText("Tooltip_MetalChevalDeFrise") .. tooltip.description
    tooltip:setTexture(sprite.sprite)
end


local function doBuildDefensesMenu(player, context, worldobjects)
    local buildMenu = context:getOptionFromName(getText("ContextMenu_Build"))
    if buildMenu then
	local subMenu = context:getSubMenu(buildMenu.subOption)
	-- Add our menu after vanilla one
	-- Add Wooden cheval de frise option
	sprite = {sprite="defenses_01_2", sprite2= "defenses_01_1",  northSprite= "defenses_01_4",  northSprite2= "defenses_01_3"}
	WoodenChevalDeFrise(subMenu, sprite, player)
    end   
    local blacksmithMenu = context:getOptionFromName(getText("ContextMenu_MetalWelding"))
    if blacksmithMenu then
	local subMenu = context:getSubMenu(blacksmithMenu.subOption)
    end
end

Events.OnFillWorldObjectContextMenu.Add(doBuildDefensesMenu)

