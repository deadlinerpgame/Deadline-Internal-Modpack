CraftingEnhancedCore = {}

CraftingEnhancedCore.NAME = 'Crafting Enhanced Core'
CraftingEnhancedCore.AUTHOR = 'TheHunterJP'
CraftingEnhancedCore.VERSION = '1.0.0'

CraftingEnhancedCore.tables = {}

CraftingEnhancedCore.init = function()
    print('Mod Loaded: ' ..
        CraftingEnhancedCore.NAME ..
        ' by ' .. CraftingEnhancedCore.AUTHOR .. ' (v' .. CraftingEnhancedCore.VERSION .. ')')
end

function getModInstance()
    return CraftingEnhancedCore
end

Events.OnGameStart.Add(CraftingEnhancedCore.init)
