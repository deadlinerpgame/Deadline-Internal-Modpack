if isClient() then return end;

Recipe = {}
Recipe.GetItemTypes = {}
Recipe.OnCanPerform = {}
Recipe.OnCreate = {}
Recipe.OnGiveXP = {}
Recipe.OnTest = {}
Recipe.iveryXP = {};

function Recipe.OnGiveXP.Cooking5(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Cooking, 5);
end

function Recipe.OnGiveXP.Cooking15(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Cooking, 15);
end

function Recipe.iveryXP.WoodWork1(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Woodwork, 1);
end

function Give20MetalWeldingXp(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.MetalWelding, 20);
end

function Give20WoodworkXP(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Woodwork, 20);
end

function Give2MWXP(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.MetalWelding, 2);
end

function Recipe.OnGiveXP.Tailoring1(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Tailoring, 1);
end

function ClothMendingXP05(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Tailoring, 5);
end

function Recipe.GetItemTypes.Drill(scriptItems)
	scriptItems:addAll(getScriptManager():getItemsTag("Drill"));
end

function Recipe.GetItemTypes.Pliers(scriptItems)
	scriptItems:addAll(getScriptManager():getItemsTag("Pliers"));
end