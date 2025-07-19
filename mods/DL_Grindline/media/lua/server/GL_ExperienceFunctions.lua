-- To add your own custom XP, just copy the part down below and change it's name and Perks.YourPerk
-- 1 value in here is equal 0.25 XP in game

-- function Recipe.OnGiveXP.Name(recipe, ingredients, result, player)
-- player:getXp():AddXP(Perks.PerkName, Value);
-- end

-- To have multiple stuff coming out of a Craft Recipe:
-- function Recipe.OnCreate.OpenKit(items, result, player)
--   getPlayer():getInventory():AddItem('Base.Pen')
-- getPlayer():getInventory():AddItem('Base.Eraser')
-- end

-- To add a Furniture Item(Movable) to the inventory
-- function Recipe.OnCreate.Yellow_Couch(items, result, player)
-- getPlayer():getInventory():AddItem('Moveables.Moveable'):ReadFromWorldSprite('furniture_seating_indoor_03_17')
-- end


-- Perks List
-- PASSIVE PERKS
-- Strength
-- Fitness

-- COMBAT PERKS
-- Blunt
-- SmallBlunt
-- LongBlade
-- SmallBlade
-- Axe
-- Spear
-- Maintenance

-- FIREARMS PERKS
-- Aiming
-- Reloading

-- AGILITY PERKS
-- Sprinting
-- Nimble
-- Sneak

-- CRAFTING PERKS
-- Carpentry
-- Woodwork
-- Cooking
-- Farming
-- Doctor
-- Electricity
-- Mechanics
-- MetalWelding
-- Tailoring

-- SURVIVALIST PERKS
-- Fishing
-- Trapping
-- Foraging


function Recipe.OnGiveXP.MetalWelding10(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.MetalWelding, 10);
end

function Recipe.OnGiveXP.MetalWelding20(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.MetalWelding, 20);
end

function Recipe.OnGiveXP.MetalWelding30(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.MetalWelding, 30);
end

function Recipe.OnGiveXP.MetalWelding40(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.MetalWelding, 40);
end

function Recipe.OnGiveXP.MetalWelding50(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.MetalWelding, 50);
end

function Recipe.OnGiveXP.MetalWelding60(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.MetalWelding, 60);
end

function Recipe.OnGiveXP.MetalWelding70(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.MetalWelding, 70);
end

function Recipe.OnGiveXP.MetalWelding80(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.MetalWelding, 80);
end

function Recipe.OnGiveXP.MetalWelding90(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.MetalWelding, 90);
end

function Recipe.OnGiveXP.MetalWelding100(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.MetalWelding, 100);
end

GiveMetalWelding10 = Recipe.OnGiveXP.MetalWelding10
GiveMetalWelding20 = Recipe.OnGiveXP.MetalWelding20
GiveMetalWelding30 = Recipe.OnGiveXP.MetalWelding30
GiveMetalWelding40 = Recipe.OnGiveXP.MetalWelding40
GiveMetalWelding50 = Recipe.OnGiveXP.MetalWelding50
GiveMetalWelding60 = Recipe.OnGiveXP.MetalWelding60
GiveMetalWelding70 = Recipe.OnGiveXP.MetalWelding70
GiveMetalWelding80 = Recipe.OnGiveXP.MetalWelding80
GiveMetalWelding90 = Recipe.OnGiveXP.MetalWelding90
GiveMetalWelding100 = Recipe.OnGiveXP.MetalWelding100

function Recipe.OnGiveXP.Tailoring10(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Tailoring, 10);
end

function Recipe.OnGiveXP.Tailoring20(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Tailoring, 20);
end

function Recipe.OnGiveXP.Tailoring30(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Tailoring, 30);
end

function Recipe.OnGiveXP.Tailoring40(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Tailoring, 40);
end

function Recipe.OnGiveXP.Tailoring50(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Tailoring, 50);
end

function Recipe.OnGiveXP.Tailoring60(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Tailoring, 60);
end

function Recipe.OnGiveXP.Tailoring70(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Tailoring, 70);
end

function Recipe.OnGiveXP.Tailoring80(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Tailoring, 80);
end

function Recipe.OnGiveXP.Tailoring90(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Tailoring, 90);
end

function Recipe.OnGiveXP.Tailoring100(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Tailoring, 100);
end

GiveTailoring10 = Recipe.OnGiveXP.Tailoring10
GiveTailoring20 = Recipe.OnGiveXP.Tailoring20
GiveTailoring30 = Recipe.OnGiveXP.Tailoring30
GiveTailoring40 = Recipe.OnGiveXP.Tailoring40
GiveTailoring50 = Recipe.OnGiveXP.Tailoring50
GiveTailoring60 = Recipe.OnGiveXP.Tailoring60
GiveTailoring70 = Recipe.OnGiveXP.Tailoring70
GiveTailoring80 = Recipe.OnGiveXP.Tailoring80
GiveTailoring90 = Recipe.OnGiveXP.Tailoring90
GiveTailoring100 = Recipe.OnGiveXP.Tailoring100

function Recipe.OnGiveXP.Woodwork10(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Woodwork, 10);
end

function Recipe.OnGiveXP.Woodwork20(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Woodwork, 20);
end

function Recipe.OnGiveXP.Woodwork30(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Woodwork, 30);
end

function Recipe.OnGiveXP.Woodwork40(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Woodwork, 40);
end

function Recipe.OnGiveXP.Woodwork50(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Woodwork, 50);
end

function Recipe.OnGiveXP.Woodwork60(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Woodwork, 60);
end

function Recipe.OnGiveXP.Woodwork70(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Woodwork, 70);
end

function Recipe.OnGiveXP.Woodwork80(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Woodwork, 80);
end

function Recipe.OnGiveXP.Woodwork90(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Woodwork, 90);
end

function Recipe.OnGiveXP.Woodwork100(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Woodwork, 100);
end

GiveWoodwork10 = Recipe.OnGiveXP.Woodwork10
GiveWoodwork20 = Recipe.OnGiveXP.Woodwork20
GiveWoodwork30 = Recipe.OnGiveXP.Woodwork30
GiveWoodwork40 = Recipe.OnGiveXP.Woodwork40
GiveWoodwork50 = Recipe.OnGiveXP.Woodwork50
GiveWoodwork60 = Recipe.OnGiveXP.Woodwork60
GiveWoodwork70 = Recipe.OnGiveXP.Woodwork70
GiveWoodwork80 = Recipe.OnGiveXP.Woodwork80
GiveWoodwork90 = Recipe.OnGiveXP.Woodwork90
GiveWoodwork100 = Recipe.OnGiveXP.Woodwork100

function Recipe.OnGiveXP.Electricity10(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Electricity, 10);
end

function Recipe.OnGiveXP.Electricity20(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Electricity, 20);
end

function Recipe.OnGiveXP.Electricity30(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Electricity, 30);
end

function Recipe.OnGiveXP.Electricity40(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Electricity, 40);
end

function Recipe.OnGiveXP.Electricity50(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Electricity, 50);
end

function Recipe.OnGiveXP.Electricity60(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Electricity, 60);
end

function Recipe.OnGiveXP.Electricity70(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Electricity, 70);
end

function Recipe.OnGiveXP.Electricity80(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Electricity, 80);
end

function Recipe.OnGiveXP.Electricity90(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Electricity, 90);
end

function Recipe.OnGiveXP.Electricity100(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Electricity, 100);
end

GiveElectricity10 = Recipe.OnGiveXP.Electricity10
GiveElectricity20 = Recipe.OnGiveXP.Electricity20
GiveElectricity30 = Recipe.OnGiveXP.Electricity30
GiveElectricity40 = Recipe.OnGiveXP.Electricity40
GiveElectricity50 = Recipe.OnGiveXP.Electricity50
GiveElectricity60 = Recipe.OnGiveXP.Electricity60
GiveElectricity70 = Recipe.OnGiveXP.Electricity70
GiveElectricity80 = Recipe.OnGiveXP.Electricity80
GiveElectricity90 = Recipe.OnGiveXP.Electricity90
GiveElectricity100 = Recipe.OnGiveXP.Electricity100

function Recipe.OnGiveXP.Mechanics10(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Mechanics, 10);
end

function Recipe.OnGiveXP.Mechanics20(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Mechanics, 20);
end

function Recipe.OnGiveXP.Mechanics30(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Mechanics, 30);
end

function Recipe.OnGiveXP.Mechanics40(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Mechanics, 40);
end

function Recipe.OnGiveXP.Mechanics50(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Mechanics, 50);
end

function Recipe.OnGiveXP.Mechanics60(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Mechanics, 60);
end

function Recipe.OnGiveXP.Mechanics70(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Mechanics, 70);
end

function Recipe.OnGiveXP.Mechanics80(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Mechanics, 80);
end

function Recipe.OnGiveXP.Mechanics90(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Mechanics, 90);
end

function Recipe.OnGiveXP.Mechanics100(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Mechanics, 100);
end

GiveMechanics10 = Recipe.OnGiveXP.Mechanics10
GiveMechanics20 = Recipe.OnGiveXP.Mechanics20
GiveMechanics30 = Recipe.OnGiveXP.Mechanics30
GiveMechanics40 = Recipe.OnGiveXP.Mechanics40
GiveMechanics50 = Recipe.OnGiveXP.Mechanics50
GiveMechanics60 = Recipe.OnGiveXP.Mechanics60
GiveMechanics70 = Recipe.OnGiveXP.Mechanics70
GiveMechanics80 = Recipe.OnGiveXP.Mechanics80
GiveMechanics90 = Recipe.OnGiveXP.Mechanics90
GiveMechanics100 = Recipe.OnGiveXP.Mechanics100

function Recipe.OnGiveXP.Doctor10(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Doctor, 10);
end

function Recipe.OnGiveXP.Doctor20(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Doctor, 20);
end

function Recipe.OnGiveXP.Doctor30(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Doctor, 30);
end

function Recipe.OnGiveXP.Doctor40(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Doctor, 40);
end

function Recipe.OnGiveXP.Doctor50(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Doctor, 50);
end

function Recipe.OnGiveXP.Doctor60(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Doctor, 60);
end

function Recipe.OnGiveXP.Doctor70(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Doctor, 70);
end

function Recipe.OnGiveXP.Doctor80(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Doctor, 80);
end

function Recipe.OnGiveXP.Doctor90(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Doctor, 90);
end

function Recipe.OnGiveXP.Doctor100(recipe, ingredients, result, player)
player:getXp():AddXP(Perks.Doctor, 100);
end

GiveDoctor10 = Recipe.OnGiveXP.Doctor10
GiveDoctor20 = Recipe.OnGiveXP.Doctor20
GiveDoctor30 = Recipe.OnGiveXP.Doctor30
GiveDoctor40 = Recipe.OnGiveXP.Doctor40
GiveDoctor50 = Recipe.OnGiveXP.Doctor50
GiveDoctor60 = Recipe.OnGiveXP.Doctor60
GiveDoctor70 = Recipe.OnGiveXP.Doctor70
GiveDoctor80 = Recipe.OnGiveXP.Doctor80
GiveDoctor90 = Recipe.OnGiveXP.Doctor90
GiveDoctor100 = Recipe.OnGiveXP.Doctor100