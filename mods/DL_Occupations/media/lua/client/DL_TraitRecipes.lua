DL = DL or {}
local O = DL.Occupations

local function grantTraitRecipes(index, player)
    if not player:isLocalPlayer() then return end
    for id, trait in pairs(O.traits) do
        if trait.recipes ~= nil and player:HasTrait(id) then
            for _, recipe in ipairs(trait.recipes) do
                if not player:isRecipeKnown(recipe) then
                    player:learnRecipe(recipe)
                end
            end
        end
    end
end

Events.OnCreatePlayer.Add(grantTraitRecipes)
