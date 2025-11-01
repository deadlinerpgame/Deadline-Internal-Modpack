local MeltingReference = {}
MeltingReference = {
	["Smithing.OreCopper"] = {copper = 10,},
	["Smithing.OreTin"] = {tin = 10,},
	["Smithing.OreAluminum"] = {aluminum = 10,},
	["Smithing.OreIron"] = {iron = 10,},
	["Smithing.OreLead"] = {lead = 10,},
	["Smithing.OreSilver"] = {silver = 10,},
	["Smithing.OreGold"] = {gold = 10,},
	["Smithing.OreZinc"] = {zinc = 10,},
	["Smithing.OreNickel"] = {nickel = 10,},
	["Smithing.OreCrushedCopper"] = {copper = 1,},
	["Smithing.OreCrushedTin"] = {tin = 1,},
	["Smithing.OreCrushedAluminum"] = {aluminum = 1,},
	["Smithing.OreCrushedIron"] = {iron = 1,},
	["Smithing.OreCrushedLead"] = {lead = 1,},
	["Smithing.OreCrushedSilver"] = {silver = 1,},
	["Smithing.OreCrushedGold"] = {gold = 1,},
	["Smithing.OreCrushedZinc"] = {zinc = 1,},
	["Smithing.OreCrushedNickel"] = {nickel = 1,},

	["aerx.AluminumScrap"] = {aluminum = 10,},
	["aerx.AluminumFragments"] = {aluminum = 1,},

	["aerx.NickelScrap"] = {nickel = 10,},
	["aerx.NickelFragments"] = {nickel = 1,},

	["aerx.IronScrap"] = {iron = 10,},
	["aerx.IronFragments"] = {iron = 1,},

	["aerx.TinScrap"] = {tin = 10,},
	["aerx.TinFragments"] = {tin = 1,},

	["aerx.CopperScrap"] = {copper = 10,},
	["aerx.CopperFragments"] = {copper = 1,},

	["aerx.ZincScrap"] = {zinc = 10,},
	["aerx.ZincFragments"] = {zinc = 1,},

	["aerx.LeadScrap"] = {lead = 10,},
	["aerx.LeadFragments"] = {lead = 1,},

	["aerx.GoldScrap"] = {gold = 1,},
	["aerx.SilverScrap"] = {silver = 1,},

}


local MetalReference = {
	copper = 0,
	tin = 0,
	aluminum = 0,
	iron = 0,
	lead = 0,
	silver = 0,
	gold = 0,
	zinc = 0,
	nickel = 0,
}

local AlloyRules = {}
AlloyRules = {
	{
	name = "Pure Copper Ingot",
    criteria = { copper = 100 },
    output = { pure = true, item = 'Smithing.IngotA',},
    },
	{
	name = "Pure Tin Ingot",
    criteria = { tin = 100 },
    output = { pure = true, item = 'Smithing.IngotB',},
    },
	{
	name = "Pure Aluminum Ingot",
    criteria = { aluminum = 100 },
    output = { pure = true, item = 'Smithing.IngotC',},
    },
	{
	name = "Pure Iron Ingot",
    criteria = { iron = 100 },
    output = { pure = true, item = 'Smithing.IngotD',},
    },
	{
	name = "Pure Lead Ingot",
    criteria = { lead = 100 },
    output = { pure = true, item = 'Smithing.IngotE',},
    },
	{
	name = "Pure Silver Ingot",
    criteria = { silver = 100 },
    output = { pure = true, item = 'Smithing.IngotF',},
    },
	{
	name = "Pure Gold Ingot",
    criteria = { gold = 100 },
    output = { pure = true, item = 'Smithing.IngotG',},
    },
	{
	name = "Pure Zinc Ingot",
    criteria = { zinc = 100 },
    output = { pure = true, item = 'Smithing.IngotH',},
    },
	{
	name = "Pure Nickel Ingot",
    criteria = { nickel = 100 },
    output = { pure = true, item = 'Smithing.IngotI',},
    },
	
	{
	name = "Abyssinian Gold Ingot",
    criteria = {copper = 90, tin = 10,},
    output = { pure = false, item = 'Smithing.IngotP',},
    },
	{
	name = "Constantan Ingot",
    criteria = {copper = 55, nickel = 45,},
    output = { pure = false, item = 'Smithing.IngotQ',},
    },
	{
	name = "Duralumin Ingot",
    criteria = {copper = 5, aluminum = 95,},
    output = { pure = false, item = 'Smithing.IngotR',},
    },
	{
	name = "Electrum Ingot",
    criteria = {silver = 50, gold = 50,},
    output = { pure = true, item = 'Smithing.IngotS',},
    },
	{
	name = "Nordic Gold Ingot",
    criteria = {copper = 89, tin = 1, zinc = 5, aluminum = 5,},
    output = { pure = true, item = 'Smithing.IngotT',},
    },
	{
	name = "Prince's Metal Ingot",
    criteria = {copper = 75, zinc = 25,},
    output = { pure = false, item = 'Smithing.IngotU',},
    },
	{
	name = "Molybdochalkos Ingot",
    criteria = {copper = 10, lead = 90,},
    output = { pure = true, item = 'Smithing.IngotV',},
    },
	{
	name = "Panchaloha Ingot",
    criteria = {copper = 20, zinc = 20, iron = 20, silver = 20, gold = 20,},
    output = { pure = false, item = 'Smithing.IngotW',},
    },
	{
	name = "Sterling Silver Ingot",
    criteria = {copper = 8, silver = 92,},
    output = { pure = false, item = 'Smithing.IngotX',},
    },
	{
	name = "White Bronze Ingot",
    criteria = {copper = 55, tin = 30, zinc = 15,},
    output = { pure = true, item = 'Smithing.IngotY',},
    },
	{
	name = "Pinchbeck Ingot",
    criteria = {copper = 93, zinc = 7,},
    output = { pure = true, item = 'Smithing.IngotZ',},
    },
	{
	name = "Bronze Ingot",
    criteria = {
		copper = { min = 60, max = 80,},
		tin = { min = 20, max = 40, },
		},
    output = { pure = true, item = 'Smithing.IngotJ',},
    },
	{
	name = "Brass Ingot",
    criteria = {
		copper = { min = 55, max = 80,},
		zinc = { min = 20, max = 45,},
		},
    output = { pure = true, item = 'Smithing.IngotK',},
    },
	{
	name = "Shakudo Ingot",
    criteria = {
		copper = { min = 90, max = 95,},
		gold = { min = 5, max = 10, },
		},
    output = { pure = false, item = 'Smithing.IngotL',},
    },
	{
	name = "Invar Ingot",
    criteria = {
		iron = { min = 60, max = 75,},
		nickel = { min = 25, max = 40, },
		},
    output = { pure = true, item = 'Smithing.IngotM',},
    },
	{
	name = "Orichalcum Ingot",
    criteria = {
		copper = { min = 70, max = 70,},
		zinc = { min = 15, max = 25,},
		lead = { min = 5, max = 7,},
		nickel = {min = 1, max = 2,},
		},
    output = { pure = false, item = 'Smithing.IngotN',},
    },
	{
	name = "Pewter Ingot",
    criteria = {
		copper = { min = 70, max = 70,},
		tin = { min = 15, max = 25,},
		lead = { min = 5, max = 15,},
		silver = {min = 0, max = 5,},
		},
    output = { pure = false, item = 'Smithing.IngotO',},
    },
	{
	name = "Crude Copper Ingot",
    criteria = {
		copper = { min = 50, max = 99,},
		},
    output = { pure = false, item = 'Smithing.IngotTestingAlloy',},
    },
	{
	name = "Crude Tin Ingot",
    criteria = {
		tin = { min = 50, max = 99,},
		},
    output = { pure = false, item = 'Smithing.IngotTestingAlloy',},
    },
	{
	name = "Crude Aluminum Ingot",
    criteria = {
		aluminum = { min = 50, max = 99,},
		},
    output = { pure = false, item = 'Smithing.IngotTestingAlloy',},
    },
	{
	name = "Crude Iron Ingot",
    criteria = {
		iron = { min = 50, max = 99,},
		},
    output = { pure = false, item = 'Smithing.IngotTestingAlloy',},
    },
	{
	name = "Crude Lead Ingot",
    criteria = {
		lead = { min = 50, max = 99,},
		},
    output = { pure = false, item = 'Smithing.IngotTestingAlloy',},
    },
	{
	name = "Crude Silver Ingot",
    criteria = {
		silver = { min = 50, max = 99,},
		},
    output = { pure = false, item = 'Smithing.IngotTestingAlloy',},
    },
	{
	name = "Crude Gold Ingot",
    criteria = {
		gold = { min = 50, max = 99,},
		},
    output = { pure = false, item = 'Smithing.IngotTestingAlloy',},
    },
	{
	name = "Crude Zinc Ingot",
    criteria = {
		zinc = { min = 50, max = 99,},
		},
    output = { pure = false, item = 'Smithing.IngotTestingAlloy',},
    },
	{
	name = "Crude Nickel Ingot",
    criteria = {
		nickel = { min = 50, max = 99,},
		},
    output = { pure = false, item = 'Smithing.IngotTestingAlloy',},
    },
	
	{
	name = "Crude Alloy Ingot",
    criteria = {
		copper = { min = 0, max = 50,},
		tin = { min = 0, max = 50,},
		aluminum = { min = 0, max = 50,},
		iron = { min = 0, max = 50,},
		lead = { min = 0, max = 50,},
		silver = { min = 0, max = 50,},
		gold = { min = 0, max = 50,},
		zinc = { min = 0, max = 50,},
		nickel = { min = 0, max = 50,},
		},
    output = { pure = false, item = 'Smithing.IngotTestingAlloy',},
    },
}

function AdjustWeaponStatsFromMWLevel(item, level)
	if not item then return end;
	if not level or level < 8 then return end;

	local levelModifier = 0.5;
	local baseLevel = 1;

	if not instanceof(item, "HandWeapon") then
		print("[Craftline Blacksmithing] AdjustWeaponStatsFromMWLevel called on nonhandweapon item: " .. item:getName());
		return;
	end

	local totalModifier = baseLevel + ((level - 7) * levelModifier);
	if totalModifier < 1 then
		print("[Craftline Blacksmithing] Total level modifier is less than 1 so would nerf the weapon.");
		return;
	end

	local currentMaxDamage = item:getMaxDamage();
	local currentEnduranceMod = item:getEnduranceMod();
	local currentConditionMax = item:getConditionMax();
	local currentConditionLowerChanceOneIn = item:getConditionLowerChance();

	item:setMaxDamage(currentMaxDamage * totalModifier);
	print("Set max damage: " .. tostring(currentMaxDamage * totalModifier));

	item:setEnduranceMod(currentEnduranceMod / totalModifier);
	print("Set current endurance mod: " .. tostring(currentEnduranceMod / totalModifier));

	item:setConditionMax(currentConditionMax * totalModifier);
	print("Set condition max: " .. tostring(currentConditionMax * totalModifier));

	item:setCondition(item:getConditionMax());
	print("Set condition: " .. tostring(item:getConditionMax()));

	item:setConditionLowerChance(currentConditionLowerChanceOneIn * totalModifier);
	print("Set condition lower chance: " .. tostring(currentConditionLowerChanceOneIn * totalModifier));

	item:getModData()["CraftLine_ForgedBy"] = player:getDescriptor():getForename();
end


function Recipe.OnCreate.MeltMetal(items, result, player)
	player:getInventory():AddItem('aerx.CeramicCrucible')
--[[ Part 1, creates the table for the resulting ingot ]]--
	local alloyTally = {total = 0, copper = 0, tin = 0, aluminum = 0, iron = 0, lead = 0, silver = 0, gold = 0, zinc = 0, nickel = 0,}
	local alloyPercent = {total = 0, copper = 0, tin = 0, aluminum = 0, iron = 0, lead = 0, silver = 0, gold = 0, zinc = 0, nickel = 0,}
	local crucible = {}
	local crucibleContents = {}

--[[ Identifies the crucible ]]--
	for i=0,items:size() - 1 do
		local temp = items:get(i)
		if temp:IsInventoryContainer() == true then
			crucible = temp
		end
	end
	
	print('Test1: ' .. tostring(crucible:IsInventoryContainer()))
	print('Test2: ' .. tostring(crucible:getInventoryWeight()))
	print('Test3: ' .. crucible:getItemContainer():getCountTag('meltable'))
	print(crucible:getItemContainer():getCapacityWeight())
	if crucible:getItemContainer():getCapacityWeight() < 0.9999 or crucible:getItemContainer():getCapacityWeight() > 1.0001 then
		getPlayer():Say("I need one weight unit of metals to make an alloy.")
		local items = crucible:getItemContainer():getItems()
		if items:size() > 0 then
			local itemsToMove = {}
			for i = 0, items:size() - 1 do
				table.insert(itemsToMove, items:get(i))
			end

			for _, item in ipairs(itemsToMove) do
				player:getInventory():AddItem(item)
			end
		end
		return
	end

	
	crucibleContents = crucible:getItemContainer():getItems()

	for i=0, crucible:getItemContainer():getCountTag('meltable') - 1 do
		local meltable = crucibleContents:get(i)
		local mustard = MeltingReference[meltable:getFullType()]
		for key, value in pairs(mustard) do
			if alloyTally[key] then
				alloyTally[key] = alloyTally[key] + mustard[key]
				alloyTally['total'] = alloyTally['total'] + mustard[key]
			end
		end
	end

	for key, value in pairs(alloyTally) do
		local alloyRef = value
		if key == 'total' then
			alloyPercent['total'] = alloyTally['total']
		else
			alloyPercent[key] = (alloyTally[key] / alloyTally['total']) * 100 or 0
		end
	end
 
	local resultAlloy = {}
	resultAlloy = MetalCheck(alloyPercent)
	tablePLZ("MetalCheck: ", resultAlloy)

	local endProduct = player:getInventory():AddItem(resultAlloy.output.item)
	endProduct:getModData().AlloyType = resultAlloy.name
	endProduct:setName(resultAlloy['name'])

	crucible:getItemContainer():removeAllItems()

end

function MetalCheck(metals)
    for _, alloy in pairs(AlloyRules) do
        if meetsCriteria(metals, alloy.criteria) then
            return alloy
        end
    end
end

function meetsCriteria(metals, criteria)
    for metal, value in pairs(criteria) do
        local tempvalue = metals[metal] or 0
        if type(value) == "table" then
            if value.min and tempvalue < value.min then return false end
            if value.max and tempvalue > value.max then return false end
        else
            if tempvalue ~= value then return false end
        end
    end
    return true
end

function tablePLZ(startingString, myTable)
	print(startingString)
	if type(myTable) == 'table' then 
		for key, value in pairs(myTable) do
			print(key, value)
		end
	else
		print("Oops! Looks like you dont have a table where you are supposed to!")
	end
end