CraftingEnhancedCore = getModInstance()

local function predicateNotBroken(item)
  return not item:isBroken()
end

CraftingEnhancedCore.OnFillWorldObjectContextMenu = function(player, context, worldobjects, test)
  if getCore():getGameMode() == 'LastStand' then return end
  if test and ISWorldObjectContextMenu.Test then return true end

  local playerObj = getSpecificPlayer(player)
  if playerObj:getVehicle() then return end

  local newCarpentryOption = context:insertOptionAfter(getText("ContextMenu_Build"), getText('ContextMenu_Tables'))
  local subMenu = ISContextMenu:getNew(context)
  context:addSubMenu(newCarpentryOption, subMenu)

  if subMenu then
    for _, value in pairs(CraftingEnhancedCore.tables) do
      CraftingEnhancedCore.TableMenuBuilder(subMenu, player, value)
    end
  end
end

CraftingEnhancedCore.canBuildObject = function(_tooltip, player, table)
  local inv = getPlayer(player):getInventory()
  if not inv:getFirstTypeEval(table.requireTool, predicateNotBroken) then
    _tooltip.description = _tooltip.description .. ' <RGB:1,0,0>' ..
      getText("ContextMenu_RequireTool") .. " " .. getItemNameFromFullType("Base." .. table.requireTool) .. ' <LINE>'
  end

  for _, material in pairs(table.recipe) do
    local invItemCount = inv:getItemCountFromTypeRecurse(material.type)
    if invItemCount >= material.amount or ISBuildMenu.cheat then
      _tooltip.description = _tooltip.description .. ' <RGB:1,1,1>' .. getItemNameFromFullType(material.type) .. ' ' .. material.amount .. '/' .. material.amount .. ' <LINE>'
    else
      _tooltip.description = _tooltip.description .. ' <RGB:1,0,0>' .. getItemNameFromFullType(material.type) .. ' ' .. invItemCount .. '/' .. material.amount .. ' <LINE>'
    end
  end
end

CraftingEnhancedCore.TableMenuBuilder = function(subMenu, player, table)
  local _option

  if table.size == 5 then
    _option = subMenu:addOption(table.displayName, nil, CraftingEnhancedCore.onBuildFiveTiled, table, player)
  elseif table.size == 4 then
    _option = subMenu:addOption(table.displayName, nil, CraftingEnhancedCore.onBuildQuadTiled, table, player)
  elseif table.size == 3 then
    _option = subMenu:addOption(table.displayName, nil, CraftingEnhancedCore.onBuildTripleTiled, table, player)
  elseif table.size == 2 then
    _option = subMenu:addOption(table.displayName, nil, CraftingEnhancedCore.onBuildDoubleTiled, table, player)
  elseif table.size == 1 then
    _option = subMenu:addOption(table.displayName, nil, CraftingEnhancedCore.onBuildSingleTiled, table, player)
  end

  CraftingEnhancedCore.AddTooltip(_option, player, table)
end

CraftingEnhancedCore.AddTooltip = function(option, player, table)
  local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, option, player);
  tooltip:setName(table.tooltipTitle);
  tooltip.description = tooltip.description .. table.tooltipDescription .. "<LINE>";
  tooltip:setTexture(table.tooltipTexture);
  CraftingEnhancedCore.canBuildObject(tooltip, player, table)
end

CraftingEnhancedCore.onBuildSingleTiled = function(ignoreThisArgument, table, player)
  local _table = ISSimpleFurniture:new(table.nameID,
    table.sprites.west[1],
    table.sprites.north[1],
    table.sprites.east[1],
    table.sprites.south[1])

  _table.player = player
  _table.name = table.nameID
  _table.isContainer = table.container ~= nil;
  _table.craftingBank = "BlowTorch"

  _table:setEastSprite(table.sprites.east[1])
  _table:setSouthSprite(table.sprites.south[1])

  if table.anim then _table.actionAnim = table.anim end
  if table.craftingSound then
    _table.craftingBank = table.craftingSound
    _table.noNeedHammer = true;
  end

  for _, material in pairs(table.recipe) do
    _table.modData['need:' .. material.type] = material.amount
  end

  getCell():setDrag(_table, player)
end

CraftingEnhancedCore.onBuildDoubleTiled = function(ignoreThisArgument, table, player)
  local _table = ISDoubleTileTable:new(table.nameID,
    table.sprites.west[1], table.sprites.west[2],
    table.sprites.north[1], table.sprites.north[2],
    table.sprites.east[1], table.sprites.east[2],
    table.sprites.south[1], table.sprites.south[2])

  _table.player = player
  _table.name = table.nameID

  if table.anim then _table.actionAnim = table.anim end
  if table.craftingSound then
    _table.craftingBank = table.craftingSound
    _table.noNeedHammer = true;
  end
  if table.container then
    _table.isContainer = true;
    _table.modData["containerData"] = table.container
  end

  for _, material in pairs(table.recipe) do
    _table.modData['need:' .. material.type] = material.amount
  end

  getCell():setDrag(_table, player)
end

CraftingEnhancedCore.onBuildTripleTiled = function(ignoreThisArgument, table, player)
  local _table = ISTripleTileFurniture:new(
    table.nameID,
    table.sprites.west[1], table.sprites.west[2], table.sprites.west[3],
    table.sprites.north,
    table.sprites.east,
    table.sprites.south,
    table.sprites.west
  )

  _table.player = player
  _table.name = table.nameID

  if table.anim then _table.actionAnim = table.anim end
  if table.craftingSound then
    _table.craftingBank = table.craftingSound
    _table.noNeedHammer = true
  end
  if table.container then
    _table.isContainer = true
    _table.modData["containerData"] = table.container
  end

  for _, material in pairs(table.recipe) do
    _table.modData['need:' .. material.type] = material.amount
  end

  getCell():setDrag(_table, player)
end

CraftingEnhancedCore.onBuildFiveTiled = function(ignoreThisArgument, table, player)
  local _table = ISFiveTileFurniture:new(table.nameID, table.sprites)

  _table.player = player
  _table.name = table.nameID

  if table.anim then _table.actionAnim = table.anim end
  if table.craftingSound then
    _table.craftingBank = table.craftingSound
    _table.noNeedHammer = true
  end
  if table.container then
    _table.isContainer = true
    _table.modData["containerData"] = table.container
  end

  for _, material in pairs(table.recipe) do
    _table.modData['need:' .. material.type] = material.amount
  end

  getCell():setDrag(_table, player)
end


CraftingEnhancedCore.onBuildQuadTiled = function(ignoreThisArgument, table, player)
  local _table = ISQuadTileFurniture:new(table.nameID, table.sprites)

  _table.player = player
  _table.name = table.nameID

  if table.anim then _table.actionAnim = table.anim end
  if table.craftingSound then
    _table.craftingBank = table.craftingSound
    _table.noNeedHammer = true
  end
  if table.container then
    _table.isContainer = true
    _table.modData["containerData"] = table.container
  end

  for _, material in pairs(table.recipe) do
    _table.modData['need:' .. material.type] = material.amount
  end

  getCell():setDrag(_table, player)
end

Events.OnFillWorldObjectContextMenu.Add(CraftingEnhancedCore.OnFillWorldObjectContextMenu)