local function addItems(inventory, item, count)
    for i = 1, count do
        inventory:AddItem(item)
    end
end

---------------------------------------------------------------

function Recipe.OnCreate.ButcherCow(items, result, player)
    local inv = player:getInventory()
    local hasTrait = player:HasTrait("profsurvivalist3")

    if hasTrait or ZombRand(4) == 0 then
        addItems(inv, "aerx.CowLeather_Simmental_Full", 2)
    end

    addItems(inv, "aerx.Cow_Skull", 1)
    addItems(inv, "aerx.JawboneBovide", 1)
    addItems(inv, "aerx.LargeAnimalBone", 1)
    addItems(inv, "aerx.AnimalBone", 5)
    addItems(inv, "aerx.SmallAnimalBone", 9)

    local steakCount = hasTrait and 25 or 18
    local lardCount = hasTrait and 5 or 3

    addItems(inv, "Base.Steak", steakCount)
    addItems(inv, "Base.Lard", lardCount)
end


function Recipe.OnCreate.ButcherCowHalf(items, result, player)
    local inv = player:getInventory()
    local hasTrait = player:HasTrait("profsurvivalist3")

    if hasTrait or ZombRand(4) == 0 then
        addItems(inv, "aerx.CowLeather_Simmental_Full", 1)
    end

    addItems(inv, "aerx.AnimalBone", 2)
    addItems(inv, "aerx.SmallAnimalBone", 4)

    local steakCount = hasTrait and 12 or 8
    local lardCount = hasTrait and 2 or 1

    addItems(inv, "Base.Steak", steakCount)
    addItems(inv, "Base.Lard", lardCount)
end

---------------------------------------------------------------

function Recipe.OnCreate.ButcherDeer(items, result, player)
    local inv = player:getInventory()
    local hasTrait = player:HasTrait("profsurvivalist3")

    if hasTrait or ZombRand(4) == 0 then
        addItems(inv, "aerx.DeerLeather_Full", 2)
    end

    addItems(inv, "aerx.DeerStag_Skull", 1)
    addItems(inv, "aerx.LargeAnimalBone", 1)
    addItems(inv, "aerx.AnimalBone", 5)
    addItems(inv, "aerx.SmallAnimalBone", 9)

    local steakCount = hasTrait and 12 or 9

    addItems(inv, "Base.Steak", steakCount)

end

function Recipe.OnCreate.ButcherDeerHalf(items, result, player)
    local inv = player:getInventory()
    local hasTrait = player:HasTrait("profsurvivalist3")

    if hasTrait or ZombRand(4) == 0 then
        addItems(inv, "aerx.DeerLeather_Full", 1)
    end

    addItems(inv, "aerx.AnimalBone", 2)
    addItems(inv, "aerx.SmallAnimalBone", 4)

    local steakCount = hasTrait and 7 or 5

    addItems(inv, "Base.Steak", steakCount)

end

---------------------------------------------------------------

function Recipe.OnCreate.ButcherPig(items, result, player)
    local inv = player:getInventory()
    local hasTrait = player:HasTrait("profsurvivalist3")

    if hasTrait or ZombRand(4) == 0 then
        addItems(inv, "aerx.PigLeather_Landrace_Full", 2)
    end

    addItems(inv, "aerx.Pig_Skull", 1)
    addItems(inv, "aerx.LargeAnimalBone", 1)
    addItems(inv, "aerx.AnimalBone", 5)
    addItems(inv, "aerx.SmallAnimalBone", 9)

    local baconCount = hasTrait and 2 or 1
    local lardCount = hasTrait and 3 or 2

    addItems(inv, "Base.Ham", baconCount)
    addItems(inv, "Base.Lard", lardCount)
end

function Recipe.OnCreate.ButcherPigHalf(items, result, player)
    local inv = player:getInventory()
    local hasTrait = player:HasTrait("profsurvivalist3")

    if hasTrait or ZombRand(4) == 0 then
        addItems(inv, "aerx.PigLeather_Landrace_Full", 1)
    end

    addItems(inv, "aerx.AnimalBone", 2)
    addItems(inv, "aerx.SmallAnimalBone", 4)

    local baconCount = hasTrait and 1 or 0
    local lardCount = hasTrait and 2 or 1

    addItems(inv, "Base.Ham", baconCount)
    addItems(inv, "Base.Lard", lardCount)
end

---------------------------------------------------------------

function Recipe.OnCreate.ButcherRabbit(items, result, player)
    local inv = player:getInventory()
    local hasTrait = player:HasTrait("profsurvivalist3")

    if hasTrait or ZombRand(4) == 0 then
        addItems(inv, "aerx.RabbitLeather_Full", 1)
    end

    addItems(inv, "aerx.Rabbit_Skull", 1)
    addItems(inv, "aerx.AnimalBone", 1)
    addItems(inv, "aerx.SmallAnimalBone", 3)

    local meatCount = hasTrait and 2 or 1
    local lardCount = hasTrait and 1 or 0

    addItems(inv, "Base.Rabbitmeat", meatCount)
    addItems(inv, "Base.Lard", lardCount)
end


function Recipe.OnCreate.ButcherRabbitHalf(items, result, player)
    local inv = player:getInventory()
    local hasTrait = player:HasTrait("profsurvivalist3")

    if hasTrait or ZombRand(4) == 0 then
        addItems(inv, "aerx.RabbitLeather_Full", 1)
    end

    addItems(inv, "aerx.AnimalBone", 1)
    addItems(inv, "aerx.SmallAnimalBone", 2)

    local meatCount = hasTrait and 1 or 1
    local lardCount = hasTrait and 1 or 0

    addItems(inv, "Base.Rabbitmeat", meatCount)
    if lardCount > 0 then
        addItems(inv, "Base.Lard", lardCount)
    end
end

---------------------------------------------------------------

function Recipe.OnCreate.ButcherSheep(items, result, player)
    local inv = player:getInventory()
    local hasTrait = player:HasTrait("profsurvivalist3")

    if hasTrait or ZombRand(4) == 0 then
        addItems(inv, "aerx.SheepLeather_Full", 2)
    end

    addItems(inv, "aerx.Ram_Skull", 1)
    addItems(inv, "aerx.AnimalBone", 3)
    addItems(inv, "aerx.SmallAnimalBone", 5)

    local meatCount = hasTrait and 12 or 9
    local lardCount = hasTrait and 3 or 2

    addItems(inv, "Base.MuttonChop", meatCount)
    addItems(inv, "Base.Lard", lardCount)
end


function Recipe.OnCreate.ButcherSheepHalf(items, result, player)
    player = getPlayer()
    local inv = player:getInventory()
    local hasTrait = player:HasTrait("profsurvivalist3")

    if hasTrait or ZombRand(4) == 0 then
        addItems(inv, "aerx.SheepLeather_Full", 1)
    end

    addItems(inv, "aerx.AnimalBone", 1)
    addItems(inv, "aerx.SmallAnimalBone", 3)

    local meatCount = hasTrait and 6 or 4
    local lardCount = hasTrait and 2 or 1

    addItems(inv, "Base.MuttonChop", meatCount)
    addItems(inv, "Base.Lard", lardCount)
end