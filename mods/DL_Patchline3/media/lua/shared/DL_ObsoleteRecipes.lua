function DLObsoleteRecipe_CanPerform()
    return false
end

local function blockObsoleteResults()
    local recipes = getScriptManager():getAllRecipes()
    for i = 0, recipes:size() - 1 do
        local recipe = recipes:get(i)
        local result = recipe:getResult()
        if result ~= nil then
            local item = getScriptManager():FindItem(result:getFullType())
            if item == nil or item:getObsolete() then
                recipe:setCanPerform("DLObsoleteRecipe_CanPerform")
            end
        end
    end
end

Events.OnGameBoot.Add(blockObsoleteResults)
Events.OnGameStart.Add(blockObsoleteResults)
Events.OnServerStarted.Add(blockObsoleteResults)
