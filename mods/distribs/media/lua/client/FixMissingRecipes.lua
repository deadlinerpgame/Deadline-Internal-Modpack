
function grantProfessionRecipes()
    player = getPlayer()
    local profession = player:getDescriptor():getProfession()  
    print("YOUR OCCUPATION IS")
    print(profession)

    if player:HasTrait("Spiritual") then
        player:learnRecipe("Write down a Prayer")
    end

    if player:HasTrait("Farmaceutico") then
        player:learnRecipe("Make Adderall Compound");
        player:learnRecipe("Produce Adderall");
        player:learnRecipe("Make Clonazepam Compound");
        player:learnRecipe("Make Clonazepam");
        player:learnRecipe("Make Codeine Compound");
        player:learnRecipe("Make Codeine");
        player:learnRecipe("Make Lean");
        player:learnRecipe("Make Morphine Compound");
        player:learnRecipe("Make Morphine");
        player:learnRecipe("Make Oxycodone Compound");
        player:learnRecipe("Make Oxycodone");
        player:learnRecipe("Make Percocet Compound");
        player:learnRecipe("Make Percocet");
        player:learnRecipe("Make Phenobarbital Compound");
        player:learnRecipe("Make Phenobarbital");
        player:learnRecipe("Make Tramadol Compound");
        player:learnRecipe("Make Tramadol");
        player:learnRecipe("Make Vicodin Compound");
        player:learnRecipe("Make Vicodin");
        player:learnRecipe("Make Benzodiazepine Compound");
        player:learnRecipe("Produce Xanax Compound");
        player:learnRecipe("Dry Xanax Compound");
    end

    if player:HasTrait("WalterWhite") then
        player:learnRecipe("Make Ephedrine Compound");
        player:learnRecipe("Produce Meth Compound");
        player:learnRecipe("Dry the Meth Compound");

        player:learnRecipe("Make Acid Base");
        player:learnRecipe("Make Acid Compound");
        player:learnRecipe("Dry the Acid Compound");

        player:learnRecipe("Make Benzodiazepine Compound");
        player:learnRecipe("Produce Xanax Compound");
        player:learnRecipe("Dry Xanax Compound");

        player:learnRecipe("Make Raw Cocaine Compound");
        player:learnRecipe("Refine Cocaine Compound");
        player:learnRecipe("Dry Refined Cocaine");

        player:learnRecipe("Extract Psilocybin");
        player:learnRecipe("Mix Psilocybin Compound");
        player:learnRecipe("Grow and Pack Shrooms");

        player:learnRecipe("Extract Morphine Compound");
        player:learnRecipe("Produce Refined Heroin");
        player:learnRecipe("Dry Refined Morphine");

        player:learnRecipe("Make Fentanyl Compound");
        player:learnRecipe("Dry and Pack Fentanyl");

        player:learnRecipe("Make Amphetamine Salts");
        player:learnRecipe("Dry Amphetamine Salts");

        player:learnRecipe("Extract Crack Compound");
        player:learnRecipe("Dry and Pack the Crack");

        player:learnRecipe("Extract Phenylethylamine");
    end

    if profession == "cook" then
        player:learnRecipe("Remove Poison from Mushroom")
        player:learnRecipe("Remove Poison from Berries")
        player:learnRecipe("Make Cake Batter")
        player:learnRecipe("Make Pie Dough")
        player:learnRecipe("Make Chocolate Chip Cookie Dough")
        player:learnRecipe("Make Chocolate Cookie Dough")
        player:learnRecipe("Make Oatmeal Cookie Dough")
        player:learnRecipe("Make Sugar Cookie Dough")
        player:learnRecipe("Make Shortbread Cookie Dough")
        player:learnRecipe("Make Bread Dough")
        player:learnRecipe("Make Biscuits")
        player:learnRecipe("Make Pizza")
        player:learnRecipe("Make Flour Dough Wrapper")
        player:learnRecipe("Fill Dumplings with Minced Meat")
        player:learnRecipe("Fill Dumplings with Vegetables")
        player:learnRecipe("Make Saucepan with Shui Zhu Yu in Stock")
        player:learnRecipe("Cook Kung Pao Chicken in Wok Pan")
        player:learnRecipe("Prepare Yakisoba in Wok Pan")
        player:learnRecipe("Make Saucepan of Japanese Chicken Curry")
        player:learnRecipe("Prepare Borscht")
        player:learnRecipe("Prepare Risotto")
        player:learnRecipe("Cook Tortellini")
        player:learnRecipe("Cook Ravioli")
        player:learnRecipe("Make Roasting Pan of Confit Byaldi Ratattouile")
        player:learnRecipe("Roll out Croissaint Dough")
        player:learnRecipe("Roll out Dough with Rolling Pin")
        player:learnRecipe("Cut Doughnuts")
        player:learnRecipe("Make Pasta Dough")
        player:learnRecipe("Roll out Pasta Dough with Rolling Pin")
        player:learnRecipe("Cut Pasta Dough")
        player:learnRecipe("Fill Pasta Dough with Meat")
        player:learnRecipe("Cut Ravioli")
        player:learnRecipe("Cut Tortellini")
        player:learnRecipe("Make Sausage Casings")
        player:learnRecipe("Make Sausage Casings2")
        player:learnRecipe("Make Sausage Casings3")

    elseif profession == "healer" then
        player:learnRecipe("Make Adderall Compound")
        player:learnRecipe("Produce Adderall")
        player:learnRecipe("Make Clonazepam Compound")
        player:learnRecipe("Make Clonazepam")
        player:learnRecipe("Make Codeine Compound")
        player:learnRecipe("Make Codeine")
        player:learnRecipe("Make Lean")
        player:learnRecipe("Make Morphine Compound")
        player:learnRecipe("Make Morphine")
        player:learnRecipe("Make Oxycodone Compound")
        player:learnRecipe("Make Oxycodone")
        player:learnRecipe("Make Percocet Compound")
        player:learnRecipe("Make Percocet")
        player:learnRecipe("Make Phenobarbital Compound")
        player:learnRecipe("Make Phenobarbital")
        player:learnRecipe("Make Tramadol Compound")
        player:learnRecipe("Make Tramadol")
        player:learnRecipe("Make Vicodin Compound")
        player:learnRecipe("Make Vicodin")
        player:learnRecipe("Make Benzodiazepine Compound")
        player:learnRecipe("Produce Xanax Compound")
        player:learnRecipe("Dry Xanax Compound")

    elseif profession == "farmer" then
        player:learnRecipe("Make Mildew Cure")
        player:learnRecipe("Make Flies Cure")

    elseif profession == "mechanic" then
        player:learnRecipe("Basic Tuning")
        player:learnRecipe("ATAVanillaRecipes")
        player:learnRecipe("ATAFiliRecipes")
        player:learnRecipe("MechanicMag1")
        player:learnRecipe("Make Performance Suspensions Type Standard")
        player:learnRecipe("Make Performance Suspensions Type Heavy-Duty")
        player:learnRecipe("Make Performance Suspensions Type Sport")
        player:learnRecipe("Make Standard Gas Tank Type Standard")
        player:learnRecipe("Make Big Gas Tank Type Standard")
        player:learnRecipe("Make Standard Gas Tank Type Heavy-Duty")
        player:learnRecipe("Make Big Gas Tank Type Heavy-Duty")
        player:learnRecipe("Make Standard Gas Tank Type Sport")
        player:learnRecipe("Make Big Gas Tank Type Sport")
        player:learnRecipe("Make Average Muffler Type Standard")
        player:learnRecipe("Make Performance Muffler Type Standard")
        player:learnRecipe("Make Average Muffler Type Heavy-Duty")
        player:learnRecipe("Make Performance Muffler Type Heavy-Duty")
        player:learnRecipe("Make Average Muffler Type Sport")
        player:learnRecipe("Make Performance Muffler Type Sport")
        player:learnRecipe("Make Regular Tire Type Standard")
        player:learnRecipe("Make Performance Tire Type Standard")
        player:learnRecipe("Make Regular Tire Type Heavy-Duty")
        player:learnRecipe("Make Performance Tire Type Heavy-Duty")
        player:learnRecipe("Make Regular Tire Type Sport")
        player:learnRecipe("Make Performance Tire Type Sport")
        player:learnRecipe("Make Regular Brake Type Standard")
        player:learnRecipe("Make Performance Brake Type Standard")
        player:learnRecipe("Make Regular Brake Type Heavy-Duty")
        player:learnRecipe("Make Performance Brake Type Heavy-Duty")
        player:learnRecipe("Make Regular Brake Type Sport")
        player:learnRecipe("Make Performance Brake Type Sport")
        player:learnRecipe("Basic Mechanics")
        player:learnRecipe("Intermediate Mechanics")
        player:learnRecipe("Advanced Mechanics")

    elseif profession == "survivalist" then
        player:learnRecipe("Find Bait in Rotten Food")
        player:learnRecipe("Make Fishing Rod")
        player:learnRecipe("Fix Fishing Rod")
        player:learnRecipe("Make Fishing Net")
        player:learnRecipe("Get Wire Back")
        player:learnRecipe("Make Snare Trap")
        player:learnRecipe("Make Wooden Cage Trap")
        player:learnRecipe("Make Stick Trap")
        player:learnRecipe("Make Trap Box")
        player:learnRecipe("Make Cage Trap")
        player:learnRecipe("Craft Spear with Bone Head")
        player:learnRecipe("Craft Spear with Long Bone Head")
        player:learnRecipe("Craft a Bone Club")
        player:learnRecipe("Craft a Sturdy Bone Club")
        player:learnRecipe("Craft a Spiked Sturdy Bone Club")
        player:learnRecipe("Craft a Jawbone Club")
        player:learnRecipe("Craft a Jawbone Morningstar")
        player:learnRecipe("Craft Long Spiked Club")
        player:learnRecipe("Craft a Bone War Hatchet")
        player:learnRecipe("Craft a Jawbone War Axe")
    elseif profession == "forager" then
        player:learnRecipe("Herbalist")

    elseif profession == "tinkerer" then
        player:learnRecipe("Make Duct Tape from Glue")
        player:learnRecipe("Make Duct Tape from Wood Glue")
        player:learnRecipe("Generator")
        player:learnRecipe("Make Remote Controller V1")
        player:learnRecipe("Make Remote Controller V2")
        player:learnRecipe("Make Remote Controller V3")
        player:learnRecipe("Make Remote Trigger")
        player:learnRecipe("Make Timer")
        player:learnRecipe("Craft Makeshift Radio")
        player:learnRecipe("Craft Makeshift HAM Radio")
        player:learnRecipe("Craft Makeshift Walkie Talkie")
        player:learnRecipe("Make Aerosol bomb")
        player:learnRecipe("Make Flame bomb")
        player:learnRecipe("Make Pipe bomb")
        player:learnRecipe("Make Noise generator")
        player:learnRecipe("Make Smoke Bomb")
        player:learnRecipe("raft a Tailoring Table Kit")
        player:learnRecipe("Craft a Brewing Station Kit")
        player:learnRecipe("Craft a Paint Mixing Kit")
        player:learnRecipe("Craft a Hand Press Kit")
        player:learnRecipe("Craft a Sculpting Table Kit")
        player:learnRecipe("Craft a Anaerobic Digester Kit")
        player:learnRecipe("Craft a Tailoring Table Kit")
    end
end


Events.OnCreatePlayer.Add(grantProfessionRecipes)

