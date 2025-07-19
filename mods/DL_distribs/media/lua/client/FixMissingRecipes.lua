
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
        player:learnRecipe("Make Bone Bead from Small Bones")
        player:learnRecipe("Make Bone Bead from Large Bones")
        player:learnRecipe("Craft a Bone Cuirass")
        player:learnRecipe("Craft a Bone Left Shin Armor")
        player:learnRecipe("Craft a Bone Right Shin Armor")
        player:learnRecipe("Craft a Bone Left Forearm Armor")
        player:learnRecipe("Craft a Bone Right Forearm Armor")
        player:learnRecipe("Craft a Bone Left Shoulder Armor")
        player:learnRecipe("Craft a Bone Right Shoulder Armor")
        player:learnRecipe("Craft a Bone Choker")
        player:learnRecipe("Craft a Bone Left Thigh Armor")
        player:learnRecipe("Craft a Bone Right Thigh Armor")
        player:learnRecipe("Reinforce Gloves with Bones")
        player:learnRecipe("Craft Bone Mask")
        player:learnRecipe("Craft Bone Pectoral")
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
        player:learnRecipe("Craft a Tailoring Table Kit")
        player:learnRecipe("Craft a Brewing Station Kit")
        player:learnRecipe("Craft a Paint Mixing Kit")
        player:learnRecipe("Craft a Hand Press Kit")
        player:learnRecipe("Craft a Sculpting Table Kit")
        player:learnRecipe("Craft a Anaerobic Digester Kit")
        player:learnRecipe("Craft a Tailoring Table Kit")

    elseif profession == "tailor" then
        player:learnRecipe("Mix Paint into Black Hair Dye")
        player:learnRecipe("Mix Paint into Red Hair Dye")
        player:learnRecipe("Mix Paint into Blue Hair Dye")
        player:learnRecipe("Mix Paint into Green Hair Dye")
        player:learnRecipe("Mix Paint into Blonde Hair Dye")
        player:learnRecipe("Mix Paint into Yellow Hair Dye")
        player:learnRecipe("Mix Paint into Brown Hair Dye")
        player:learnRecipe("Mix Paint into Strawberry Blonde Hair Dye")
        player:learnRecipe("Mix Paint into White Hair Dye")
        player:learnRecipe("Mix Paint into Pink Hair Dye")
        
        player:learnRecipe("Make Earring: Hoop (Random Color)")
        player:learnRecipe("Make Earring: Cross (Random Color)")
        player:learnRecipe("Make Earring: Pillar (Random Color)")
        player:learnRecipe("Make Earring: Triangle (Random Color)")
        player:learnRecipe("Make Earring: Dot (Random Color)")
        player:learnRecipe("Make Earring: Dot Triangle (Random Color)")
        player:learnRecipe("Make Earring: X (Random Color)")
        player:learnRecipe("Make Earring: Cash (Random Color)")
        player:learnRecipe("Make Earring: Gun (Random Color)")
        player:learnRecipe("Make Earring: Triangle Closed (Random Color)")
        player:learnRecipe("Make Earring: Heart (Random Color)")
        player:learnRecipe("Make Earring: Lightning 1 (Random Color)")
        player:learnRecipe("Make Earring: Lightning 2 (Random Color)")

        player:learnRecipe("Make Glasses: Aviator Black (Random Color)")
        player:learnRecipe("Make Glasses: Aviator Silver (Random Color)")
        player:learnRecipe("Make Glasses: Aviator Gold (Random Color)")
        player:learnRecipe("Make Glasses: Polarized Black (Random Color)")
        player:learnRecipe("Make Glasses: Polarized Silver (Random Color)")
        player:learnRecipe("Make Glasses: Polarized Gold (Random Color)")
        player:learnRecipe("Make Glasses: Circular Black (Random Color)")
        player:learnRecipe("Make Glasses: Circular Silver (Random Color)")
        player:learnRecipe("Make Glasses: Circular Gold (Random Color)")
        player:learnRecipe("Make Glasses: Round Black (Random Color)")
        player:learnRecipe("Make Glasses: Round Silver (Random Color)")
        player:learnRecipe("Make Glasses: Round Gold (Random Color)")
        player:learnRecipe("Make Glasses: Pixel (Random Color)")
        player:learnRecipe("Make Glasses: Party (Random Color)")

        player:learnRecipe("Make Piercing: Round (Random Color)")
        player:learnRecipe("Make Piercing: Cross (Random Color)")
        player:learnRecipe("Make Piercing: Large Cross (Random Color)")


        player:learnRecipe("Make Necklace: Basic (Random Color)")
        player:learnRecipe("Make Necklace Pendant: Cross (Random Color)")
        player:learnRecipe("Make Necklace Pendant: Cash (Random Color)")
        player:learnRecipe("Make Necklace Pendant: X (Random Color)")
        player:learnRecipe("Make Necklace Pendant: Lightning1 (Random Color)")
        player:learnRecipe("Make Necklace Pendant: Lightning2 (Random Color)")
        player:learnRecipe("Make Necklace Pendant: Gun (Random Color)")
        player:learnRecipe("Make Necklace Pendant: Heart (Random Color)")
        player:learnRecipe("Make Necklace Pendant: Pillar (Random Color)")
        player:learnRecipe("Make Necklace Pendant: Triforce")

        player:learnRecipe("Make Cropped Sweater: Army (Random Pattern)")
        player:learnRecipe("Make Cropped Sweater: Solid (Random Pattern)")
        player:learnRecipe("Make Cropped Sweater: Bomber (Random Pattern)")
        player:learnRecipe("Make Cropped Sweater: Ink Print (Random Pattern)")
        player:learnRecipe("Make Cropped Sweater: Blur Print (Random Pattern)")
        player:learnRecipe("Make Cropped Sweater: Oriental Print (Random Pattern)")
        player:learnRecipe("Make Cropped Sweater: Zebra Print (Random Pattern)")
        player:learnRecipe("Make Cropped Sweater: Leopard Print (Random Pattern)")
        player:learnRecipe("Make Cropped Sweater: Geometric Print (Random Pattern)")

        player:learnRecipe("Make Cropped Sweater: White Tartan (Random Pattern)")
        player:learnRecipe("Make Cropped Sweater: Black Tartan (Random Pattern)")
        player:learnRecipe("Make Cropped Sweater: Red Tartan (Random Pattern)")
        player:learnRecipe("Make Cropped Sweater: Green Tartan (Random Pattern)")
        player:learnRecipe("Make Cropped Sweater: Blue Tartan (Random Pattern)")
        player:learnRecipe("Make Cropped Sweater: Orange Tartan (Random Pattern)")
        player:learnRecipe("Make Cropped Sweater: Purple Tartan (Random Pattern)")
        player:learnRecipe("Make Cropped Sweater: Pink Tartan (Random Pattern)")
        player:learnRecipe("Make Cropped Sweater: Tartan (Random Pattern)")
        player:learnRecipe("Make Cropped Sweater: Tartan with Leather (Random Pattern)")

        player:learnRecipe("Make Sleeveless Cropped Sweater: Army (Random Pattern)")
        player:learnRecipe("Make Sleeveless Cropped Sweater: Solid (Random Pattern)")
        player:learnRecipe("Make Sleeveless Cropped Sweater: Bomber (Random Pattern)")
        player:learnRecipe("Make Sleeveless Cropped Sweater: Ink Print (Random Pattern)")
        player:learnRecipe("Make Sleeveless Cropped Sweater: Blur Print (Random Pattern)")
        player:learnRecipe("Make Sleeveless Cropped Sweater: Oriental Print (Random Pattern)")
        player:learnRecipe("Make Sleeveless Cropped Sweater: Zebra Print (Random Pattern)")
        player:learnRecipe("Make Sleeveless Cropped Sweater: Leopard Print (Random Pattern)")
        player:learnRecipe("Make Sleeveless Cropped Sweater: Geometric Print (Random Pattern)")

        player:learnRecipe("Make Sleeveless Cropped Sweater: White Tartan (Random Pattern)")
        player:learnRecipe("Make Sleeveless Cropped Sweater: Black Tartan (Random Pattern)")
        player:learnRecipe("Make Sleeveless Cropped Sweater: Red Tartan (Random Pattern)")
        player:learnRecipe("Make Sleeveless Cropped Sweater: Green Tartan (Random Pattern)")
        player:learnRecipe("Make Sleeveless Cropped Sweater: Blue Tartan (Random Pattern)")
        player:learnRecipe("Make Sleeveless Cropped Sweater: Orange Tartan (Random Pattern)")
        player:learnRecipe("Make Sleeveless Cropped Sweater: Purple Tartan (Random Pattern)")
        player:learnRecipe("Make Sleeveless Cropped Sweater: Pink Tartan (Random Pattern)")
        player:learnRecipe("Make Sleeveless Cropped Sweater: Tartan (Random Pattern)")
        player:learnRecipe("Make Sleeveless Cropped Sweater: Tartan with Leather (Random Pattern)")

        player:learnRecipe("Make Jacket: Army (Random Pattern)")
        player:learnRecipe("Make Jacket: Solid (Random Pattern)")
        player:learnRecipe("Make Jacket: Bomber (Random Pattern)")
        player:learnRecipe("Make Jacket: Ink Print (Random Pattern)")
        player:learnRecipe("Make Jacket: Blur Print (Random Pattern)")
        player:learnRecipe("Make Jacket: Oriental Print (Random Pattern)")
        player:learnRecipe("Make Jacket: Zebra Print (Random Pattern)")
        player:learnRecipe("Make Jacket: Leopard Print (Random Pattern)")
        player:learnRecipe("Make Jacket: Geometric Print (Random Pattern)")

        player:learnRecipe("Make Jacket: White Tartan (Random Pattern)")
        player:learnRecipe("Make Jacket: Black Tartan (Random Pattern)")
        player:learnRecipe("Make Jacket: Red Tartan (Random Pattern)")
        player:learnRecipe("Make Jacket: Green Tartan (Random Pattern)")
        player:learnRecipe("Make Jacket: Blue Tartan (Random Pattern)")
        player:learnRecipe("Make Jacket: Orange Tartan (Random Pattern)")
        player:learnRecipe("Make Jacket: Purple Tartan (Random Pattern)")
        player:learnRecipe("Make Jacket: Pink Tartan (Random Pattern)")

        player:learnRecipe("Cropped Jacket: Army (Random Pattern)")
        player:learnRecipe("Cropped Jacket: Solid (Random Pattern)")
        player:learnRecipe("Cropped Jacket: Bomber (Random Pattern)")
        player:learnRecipe("Cropped Jacket: Ink Print (Random Pattern)")
        player:learnRecipe("Cropped Jacket: Blur Print (Random Pattern)")
        player:learnRecipe("Cropped Jacket: Oriental Print (Random Pattern)")
        player:learnRecipe("Cropped Jacket: Zebra Print (Random Pattern)")
        player:learnRecipe("Cropped Jacket: Leopard Print (Random Pattern)")
        player:learnRecipe("Cropped Jacket: Geometric Print (Random Pattern)")

        player:learnRecipe("Cropped Jacket: White Tartan (Random Pattern)")
        player:learnRecipe("Cropped Jacket: Black Tartan (Random Pattern)")
        player:learnRecipe("Cropped Jacket: Red Tartan (Random Pattern)")
        player:learnRecipe("Cropped Jacket: Green Tartan (Random Pattern)")
        player:learnRecipe("Cropped Jacket: Blue Tartan (Random Pattern)")
        player:learnRecipe("Cropped Jacket: Orange Tartan (Random Pattern)")
        player:learnRecipe("Cropped Jacket: Purple Tartan (Random Pattern)")
        player:learnRecipe("Cropped Jacket: Pink Tartan (Random Pattern)")

        player:learnRecipe("Make Pants: Army (Random Pattern)")
        player:learnRecipe("Make Pants: Silk (Random Pattern)")
        player:learnRecipe("Make Pants: Basic (Random Pattern)")

        player:learnRecipe("Make Long Dress: Army (Random Pattern)")
        player:learnRecipe("Make Long Dress: Tartan (Random Pattern)")
        player:learnRecipe("Make Long Dress: Denim (Random Pattern)")
        player:learnRecipe("Make Long Dress: Silk (Random Pattern)")
        player:learnRecipe("Make Long Dress: Stamp (Random Pattern)")

        player:learnRecipe("Make Sleeveless Long Dress: Army (Random Pattern)")
        player:learnRecipe("Make Sleeveless Long Dress: Tartan (Random Pattern)")
        player:learnRecipe("Make Sleeveless Long Dress: Denim (Random Pattern)")
        player:learnRecipe("Make Sleeveless Long Dress: Silk (Random Pattern)")
        player:learnRecipe("Make Sleeveless Long Dress: Stamp (Random Pattern)")

        player:learnRecipe("Make Sleeveless Short Dress: Army (Random Pattern)")
        player:learnRecipe("Make Sleeveless Short Dress: Tartan (Random Pattern)")
        player:learnRecipe("Make Sleeveless Short Dress: Denim (Random Pattern)")
        player:learnRecipe("Make Sleeveless Short Dress: Silk (Random Pattern)")
        player:learnRecipe("Make Sleeveless Short Dress: Stamp (Random Pattern)")

        player:learnRecipe("Make Short Dress: Army (Random Pattern)")
        player:learnRecipe("Make Short Dress: Tartan (Random Pattern)")
        player:learnRecipe("Make Short Dress: Denim (Random Pattern)")
        player:learnRecipe("Make Short Dress: Silk (Random Pattern)")
        player:learnRecipe("Make Short Dress: Stamp (Random Pattern)")

        player:learnRecipe("Make Shorts: Basic (Random Color)")
        player:learnRecipe("Make Shorts: Tartan (Random Color)")
        player:learnRecipe("Make Shorts: Denim (Random Color)")
        player:learnRecipe("Make Shorts: Silk (Random Color)")
        player:learnRecipe("Make Shorts: Camo (Random Pattern)")

        player:learnRecipe("Make Large Shorts: Basic (Random Color)")
        player:learnRecipe("Make Large Shorts: Tartan (Random Color)")
        player:learnRecipe("Make Large Shorts: Denim (Random Color)")
        player:learnRecipe("Make Large Shorts: Silk (Random Color)")
        player:learnRecipe("Make Large Shorts: Camo (Random Pattern)")

        player:learnRecipe("Make Short Shorts: Basic (Random Color)")
        player:learnRecipe("Make Short Shorts: Tartan (Random Color)")
        player:learnRecipe("Make Short Shorts: Denim (Random Color)")
        player:learnRecipe("Make Short Shorts: Silk (Random Color)")
        player:learnRecipe("Make Short Shorts: Camo (Random Pattern)")

        player:learnRecipe("Make Boxing Shorts: Basic (Random Color)")
        player:learnRecipe("Make Boxing Shorts: Sport (Random Pattern)")
        player:learnRecipe("Make Boxing Shorts: Camo (Random Pattern)")
    end
    
end


Events.OnCreatePlayer.Add(grantProfessionRecipes)

