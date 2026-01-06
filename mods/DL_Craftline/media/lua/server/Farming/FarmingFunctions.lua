require "Map/SGlobalObject"
require "Farming/SPlantGlobalObject";
require "Farming/SFarmingSystem";

SPlantGlobalObject = SPlantGlobalObject or {};

SFarmingSystemCommands = SFarmingSystemCommands or {};

function SFarmingSystemCommands.cureFungi(player, args)
	local plant = SFarmingSystem.instance:getLuaObjectAt(args.x, args.y, args.z);
	if plant and plant.aphidLvl > 0 then
		plant:cureFungi(nil, args.uses);
	elseif not plant then
		noise('no plant found at '..args.x..','..args.y..','..args.z)
	end
end

function SPlantGlobalObject:cureFungi(fungiCureSource, uses)
	for i=1,uses do
		if fungiCureSource then
			fungiCureSource:Use()
		end
		self.aphidLvl = self.aphidLvl - 5;
		if self.aphidLvl < 0 then
			self.aphidLvl = 0;
		end
	end
	self:saveData();
end