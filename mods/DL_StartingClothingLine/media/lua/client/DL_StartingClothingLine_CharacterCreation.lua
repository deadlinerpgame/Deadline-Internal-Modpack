require "OptionScreens/CharacterCreationMain"

local previousInitClothing = CharacterCreationMain.initClothing

function CharacterCreationMain:initClothing(...)
    if DL_StartingClothingLine_ApplyDefault then
        DL_StartingClothingLine_ApplyDefault()
    end
    return previousInitClothing(self, ...)
end
