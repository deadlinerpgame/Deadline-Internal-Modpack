Recipe = Recipe or {}
Recipe.OnCreate = Recipe.OnCreate or {}
Recipe.OnGiveXP = Recipe.OnGiveXP or {}

function Recipe.OnCreate.GiveEmptyPot(items, result, player)
    player:getInventory():AddItem("Pot");
end

function Recipe.OnCreate.ReturnOliveJar(items, result, player)
    local item, itemType;
    local ropeItems = {};
    for i = 0, items:size() - 1 do
        item = items:get(i);
        if item then
            itemType = item:getFullType();
            if itemType == "Base.OilOlive" then
                player:getInventory():AddItem("Base.EmptyJar");
                player:getInventory():AddItem("Base.JarLid");
            end;
        end;
    end;
end
