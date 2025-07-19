## Project Zomboid Mod: Crafting Enhanced Mod
![](https://img.shields.io/badge/ProjectZomboid-41.78-orange)
![](https://img.shields.io/badge/language-lua-blue)
![](https://img.shields.io/badge/version-1.0.1-green)
* Project: Crafting Enhanced Mod
* Author: ThatHunterJP
* Date: January 26, 2023

* Portuguese and Brazilian translation: ?XIM?

#### Description
* This mod add a couple of new crafting table to use as a core component on crafting enhanced mods.

#### How to add recipes

To add a new recipe that uses this tables just add the `NearItem:Table_ID` on the recipe. Doing so will ensure that to
perform the recipe, the player needs to be close to the specified table.


```
Table IDs:
Laboratory Table: "Laboratory Table"
Forge: "Forge Table"
Armory Table: "Armory Table"
Mechanic Table: "Mechanic Table"
Tailoring Table: "Tailoring Table"
```

**Simple recipe example:**
```
module Example_Recipes
{
	imports
	{
		Base
	}


    recipe Make Convert Nails
    {
        Screws=1,
        keep Hammer,

        Result:Nails,
        Time:100.0,
        Category:Chemistry,
        Sound:Anvil,
        NearItem:Laboratory Table,
        AnimNode:BuildHigh,
        Prop1:Hammer,
        Prop2:Source=1,
    }
}
```

#### External link
* [Steam WorkShop](https://steamcommunity.com/sharedfiles/filedetails/?id=515555911)