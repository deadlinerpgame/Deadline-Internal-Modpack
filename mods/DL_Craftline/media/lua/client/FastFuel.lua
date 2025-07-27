function ISFireplaceAddFuel:new(character, fireplace, item, fuelAmt, time)
	local o = {}
	local iweight = 0;
	local modtime = 0;
	
	setmetatable(o, self)
	self.__index = self
	o.character = character;
	o.stopOnWalk = true;
	o.stopOnRun = true;

	
	
    if getPlayer():isGodMod() then
		modtime  = 0;
	else
		modtime = 11;
    end
	
	o.maxTime = modtime;
	o.fireplace = fireplace
	o.fuelAmt = fuelAmt
	o.item = item;
	return o;
end


function ISBBQAddFuel:new(character, fireplace, item, fuelAmt, time)
	local o = {}
	local iweight = 0;
	local modtime = 0;
	
	setmetatable(o, self)
	self.__index = self
	o.character = character;
	o.stopOnWalk = true;
	o.stopOnRun = true;

	
    if getPlayer():isGodMod() then
		modtime  = 0;
	else
		modtime = 11;
    end
	
	o.maxTime = modtime;
	o.fireplace = fireplace
	o.fuelAmt = fuelAmt
	o.item = item;
	return o;
end

function ISAddFuelAction:new(character, campfire, item, fuelAmt, time)
	local o = {}
    local iweight = 0;
	local modtime = 0;

	setmetatable(o, self)
	self.__index = self
	o.character = character;
	o.stopOnWalk = true;
	o.stopOnRun = true;

    
    if getPlayer():isGodMod() then
		modtime  = 0;
	else
		modtime = 11;
    end
    
	o.maxTime = modtime;
	o.campfire = campfire
	o.fuelAmt = fuelAmt
	o.item = item;
	return o;
end

