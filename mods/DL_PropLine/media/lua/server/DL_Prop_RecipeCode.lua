Recipe = Recipe or {}
Recipe.OnCreate = Recipe.OnCreate or {}
Recipe.OnGiveXP = Recipe.OnGiveXP or {}

function Recipe.OnCreate.CreateBranchStack(items, result, player)
    local item, itemType;
    local ropeItems = {};
    for i = 0, items:size() - 1 do
        item = items:get(i);
        if item then
            itemType = item:getFullType();
            if itemType ~= "Base.TreeBranch" then
                table.insert(ropeItems, itemType);
            end;
        end;
    end;
    result:getModData().ropeItems = ropeItems;
end

function Recipe.OnCreate.CreatePlankStack(items, result, player)
    local item, itemType;
    local ropeItems = {};
    for i = 0, items:size() - 1 do
        item = items:get(i);
        if item then
            itemType = item:getFullType();
            if itemType ~= "Base.Plank" then
                table.insert(ropeItems, itemType);
            end;
        end;
    end;
    result:getModData().ropeItems = ropeItems;
end

function Recipe.OnCreate.CreateTwigStack(items, result, player)
    local item, itemType;
    local ropeItems = {};
    for i = 0, items:size() - 1 do
        item = items:get(i);
        if item then
            itemType = item:getFullType();
            if itemType ~= "Base.Twigs" then
                table.insert(ropeItems, itemType);
            end;
        end;
    end;
    result:getModData().ropeItems = ropeItems;
end
