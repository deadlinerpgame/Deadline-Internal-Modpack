require "ATA2TuningTable"
require "SVUC_TuningTable"
require "SVUC2_TuningTable"

local function copy(obj, seen)
	if type(obj) ~= 'table' then return obj end
	if seen and seen[obj] then return seen[obj] end
	local s = seen or {}
	local res = setmetatable({}, getmetatable(obj))
	s[obj] = res
	for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
	return res
end
local function SVU_FRTuningTable()
	if not getActivatedMods():contains("SCKCO") and not getActivatedMods():contains("VVSR_Continued") then
		local TemplateTuningTable = SVUC_TemplateVehicleFR()
		local NewCarTuningTable2 = {}

		-- Entries
		NewCarTuningTable2["51chevy3100"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["51chevy3100old"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["64mustang"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["65gto"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["68elcamino"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["68wildcat"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["68wildcatconvert"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["69charger"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["69chargerdaytona"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["70chevelle"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["70elcamino"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["71chevyc10lb"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["71chevyc10offroadlb"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["71chevyc10offroadsb"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["71chevyc10offroadstepside"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["71chevyc10sb"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["71chevyc10stepside"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["71impala"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["72beetle"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["73falcon"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["73pinto"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["77transam"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["79brougham"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["79datsun280z"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["80f350"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["80f350quad"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["80f350ambulance"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["80f350offroad"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["83hilux"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["83hiluxoffroad"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["85vicsed"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["85vicwag"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["85vicwag2"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["85vicranger"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["85vicsheriff"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["86bounder"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["86econoline"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["86econolineambulance"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["86econolineflorist"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["86econolinerv"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["86montecarlo"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["86yugo"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["87blazer"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["87blazeroffroad"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["87c10sb"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["87c10lb"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["87c10offroadsb"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["87c10offroadlb"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["87c10utility"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["87c10mccoy"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["87c10fire"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["87caprice"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["87capricePD"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["87suburban"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["90corolla"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["90ramsb"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["90ramlb"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["90ramoffroadsb"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["90ramoffroadlb"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["91blazerpd"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["91celica"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["91chevys10"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["91chevys10ext"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["91chevys10offroad"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["91chevys10offroadext"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["91crx"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["91wagoneer"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["92crownvic"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["92crownvicPD"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["92wrangler"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["92wranglerjurassic"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["92wrangleroffroad"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["92wranglerranger"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["93explorer"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["93explorerjurassic"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["93jeepcherokee"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["93jeepcherokeeoffroad"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["astrovan"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["isuzubox"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["isuzuboxmccoy"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["isuzuboxfood"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["isuzuboxelec"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["chevystepvan"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["chevystepvanswat"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["f700box"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["f700dump"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["f700flatbed"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["f700propane"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["firepumper"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["generallee"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["generalmeh"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["hmmwvht"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["hmmwvtr"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["m35a2bed"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["m35a2covered"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["m35a2fuel"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["m151canvas"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["moveurself"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["pursuitspecial"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["schoolbus"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["schoolbusshort"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["tractorford7810"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["volvo244"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["Trailercamperscamp"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["Trailer51chevy"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["Trailermovingmedium"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["Trailermovingbig"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["Trailerfuelsmall"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}
		NewCarTuningTable2["Trailerfuelmedium"] = {
			addPartsFromVehicleScript = "",
			parts = {}
		}


-- 51chevy3100 - 2 door pickup without rack
NewCarTuningTable2["51chevy3100"].parts["ATA2ProtectionWindowFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"])
NewCarTuningTable2["51chevy3100"].parts["ATA2ProtectionWindowFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontRight"])
NewCarTuningTable2["51chevy3100"].parts["ATA2ProtectionWindshield"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"])
NewCarTuningTable2["51chevy3100"].parts["ATA2ProtectionWindshieldRear"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshieldRear"])
NewCarTuningTable2["51chevy3100"].parts["ATA2Bullbar"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2Bullbar"])
NewCarTuningTable2["51chevy3100"].parts["ATA2ProtectionTrunk"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"])
NewCarTuningTable2["51chevy3100"].parts["ATA2ProtectionHood"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHood"])
NewCarTuningTable2["51chevy3100"].parts["ATA2ProtectionDoorFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"])
NewCarTuningTable2["51chevy3100"].parts["ATA2ProtectionDoorFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontRight"])
NewCarTuningTable2["51chevy3100"].parts["ATA2ProtectionWheels"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWheels"])

-- 64mustang - 2 door car with rack
NewCarTuningTable2["64mustang"].parts["ATA2ProtectionWindowFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"])
NewCarTuningTable2["64mustang"].parts["ATA2ProtectionWindowFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontRight"])
NewCarTuningTable2["64mustang"].parts["ATA2ProtectionWindshield"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"])
NewCarTuningTable2["64mustang"].parts["ATA2ProtectionWindshieldRear"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshieldRear"])
NewCarTuningTable2["64mustang"].parts["ATA2Bullbar"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2Bullbar"])
NewCarTuningTable2["64mustang"].parts["ATA2ProtectionTrunk"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"])
NewCarTuningTable2["64mustang"].parts["ATA2ProtectionHood"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHood"])
NewCarTuningTable2["64mustang"].parts["ATA2ProtectionDoorFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"])
NewCarTuningTable2["64mustang"].parts["ATA2ProtectionDoorFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontRight"])
NewCarTuningTable2["64mustang"].parts["ATA2InteractiveTrunkRoofRack"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2InteractiveTrunkRoofRack"])
NewCarTuningTable2["64mustang"].parts["ATA2ProtectionWheels"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWheels"])
-- 68wildcat  - 4 door sedan with rack
NewCarTuningTable2["68wildcat"].parts["ATA2ProtectionWindowFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"])
NewCarTuningTable2["68wildcat"].parts["ATA2ProtectionWindowFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontRight"])
NewCarTuningTable2["68wildcat"].parts["ATA2ProtectionWindowRearLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearLeft"])
NewCarTuningTable2["68wildcat"].parts["ATA2ProtectionWindowRearRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearRight"])
NewCarTuningTable2["68wildcat"].parts["ATA2ProtectionWindshield"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"])
NewCarTuningTable2["68wildcat"].parts["ATA2ProtectionWindshieldRear"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshieldRear"])
NewCarTuningTable2["68wildcat"].parts["ATA2Bullbar"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2Bullbar"])
NewCarTuningTable2["68wildcat"].parts["ATA2ProtectionTrunk"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"])
NewCarTuningTable2["68wildcat"].parts["ATA2ProtectionHood"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHood"])
NewCarTuningTable2["68wildcat"].parts["ATA2ProtectionDoorFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"])
NewCarTuningTable2["68wildcat"].parts["ATA2ProtectionDoorFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontRight"])
NewCarTuningTable2["68wildcat"].parts["ATA2ProtectionDoorRearLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearLeft"])
NewCarTuningTable2["68wildcat"].parts["ATA2ProtectionDoorRearRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearRight"])
NewCarTuningTable2["68wildcat"].parts["ATA2InteractiveTrunkRoofRack"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2InteractiveTrunkRoofRack"])
NewCarTuningTable2["68wildcat"].parts["ATA2ProtectionWheels"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWheels"])


-- 68wildcatconvert - 2 door car without rack
NewCarTuningTable2["68wildcatconvert"].parts["ATA2ProtectionWindowFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"])
NewCarTuningTable2["68wildcatconvert"].parts["ATA2ProtectionWindowFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontRight"])
NewCarTuningTable2["68wildcatconvert"].parts["ATA2ProtectionWindshield"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"])
NewCarTuningTable2["68wildcatconvert"].parts["ATA2ProtectionWindshieldRear"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshieldRear"])
NewCarTuningTable2["68wildcatconvert"].parts["ATA2Bullbar"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2Bullbar"])
NewCarTuningTable2["68wildcatconvert"].parts["ATA2ProtectionTrunk"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"])
NewCarTuningTable2["68wildcatconvert"].parts["ATA2ProtectionHood"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHood"])
NewCarTuningTable2["68wildcatconvert"].parts["ATA2ProtectionDoorFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"])
NewCarTuningTable2["68wildcatconvert"].parts["ATA2ProtectionDoorFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontRight"])
NewCarTuningTable2["68wildcatconvert"].parts["ATA2ProtectionWheels"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWheels"])


-- 69chargerdaytona - 2 door car with rack, no bullbar
NewCarTuningTable2["69chargerdaytona"].parts["ATA2ProtectionWindowFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"])
NewCarTuningTable2["69chargerdaytona"].parts["ATA2ProtectionWindowFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontRight"])
NewCarTuningTable2["69chargerdaytona"].parts["ATA2ProtectionWindshield"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"])
NewCarTuningTable2["69chargerdaytona"].parts["ATA2ProtectionWindshieldRear"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshieldRear"])
NewCarTuningTable2["69chargerdaytona"].parts["ATA2ProtectionTrunk"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"])
NewCarTuningTable2["69chargerdaytona"].parts["ATA2ProtectionHood"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHood"])
NewCarTuningTable2["69chargerdaytona"].parts["ATA2ProtectionHood"].Light.protection = {"HeadlightLeft", "HeadlightRight", "EngineDoor"}
NewCarTuningTable2["69chargerdaytona"].parts["ATA2ProtectionHood"].Heavy.protection = {"HeadlightLeft", "HeadlightRight", "EngineDoor"}
NewCarTuningTable2["69chargerdaytona"].parts["ATA2ProtectionDoorFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"])
NewCarTuningTable2["69chargerdaytona"].parts["ATA2ProtectionDoorFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontRight"])
NewCarTuningTable2["69chargerdaytona"].parts["ATA2InteractiveTrunkRoofRack"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2InteractiveTrunkRoofRack"])
NewCarTuningTable2["69chargerdaytona"].parts["ATA2ProtectionWheels"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWheels"])


-- 71chevyc10offroadlb - 2 door pickup without rack, no bullbar
NewCarTuningTable2["71chevyc10offroadlb"].parts["ATA2ProtectionWindowFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"])
NewCarTuningTable2["71chevyc10offroadlb"].parts["ATA2ProtectionWindowFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontRight"])
NewCarTuningTable2["71chevyc10offroadlb"].parts["ATA2ProtectionWindshield"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"])
NewCarTuningTable2["71chevyc10offroadlb"].parts["ATA2ProtectionWindshieldRear"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshieldRear"])
NewCarTuningTable2["71chevyc10offroadlb"].parts["ATA2ProtectionTrunk"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"])
NewCarTuningTable2["71chevyc10offroadlb"].parts["ATA2ProtectionTrunk"].Light.protection = {"TruckBedOpen", "GasTank"}
NewCarTuningTable2["71chevyc10offroadlb"].parts["ATA2ProtectionTrunk"].Heavy.protection = {"TruckBedOpen", "GasTank"}
NewCarTuningTable2["71chevyc10offroadlb"].parts["ATA2ProtectionHood"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHood"])
NewCarTuningTable2["71chevyc10offroadlb"].parts["ATA2ProtectionHood"].Light.protection = {"HeadlightLeft", "HeadlightRight", "EngineDoor"}
NewCarTuningTable2["71chevyc10offroadlb"].parts["ATA2ProtectionHood"].Heavy.protection = {"HeadlightLeft", "HeadlightRight", "EngineDoor"}
NewCarTuningTable2["71chevyc10offroadlb"].parts["ATA2ProtectionDoorFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"])
NewCarTuningTable2["71chevyc10offroadlb"].parts["ATA2ProtectionDoorFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontRight"])
NewCarTuningTable2["71chevyc10offroadlb"].parts["ATA2ProtectionWheels"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWheels"])


-- 73pinto - 2 door, 4 window car with rack
NewCarTuningTable2["73pinto"].parts["ATA2ProtectionWindowFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"])
NewCarTuningTable2["73pinto"].parts["ATA2ProtectionWindowFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontRight"])
NewCarTuningTable2["73pinto"].parts["ATA2ProtectionWindowRearLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"])
NewCarTuningTable2["73pinto"].parts["ATA2ProtectionWindowRearRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearRight"])
NewCarTuningTable2["73pinto"].parts["ATA2ProtectionWindshield"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"])
NewCarTuningTable2["73pinto"].parts["ATA2ProtectionWindshieldRear"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshieldRear"])
NewCarTuningTable2["73pinto"].parts["ATA2Bullbar"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2Bullbar"])
NewCarTuningTable2["73pinto"].parts["ATA2ProtectionTrunk"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"])
NewCarTuningTable2["73pinto"].parts["ATA2ProtectionHood"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHood"])
NewCarTuningTable2["73pinto"].parts["ATA2ProtectionDoorFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"])
NewCarTuningTable2["73pinto"].parts["ATA2ProtectionDoorFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontRight"])
NewCarTuningTable2["73pinto"].parts["ATA2InteractiveTrunkRoofRack"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2InteractiveTrunkRoofRack"])
NewCarTuningTable2["73pinto"].parts["ATA2ProtectionWheels"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWheels"])


-- 80f350quad - 4 door 2 window pickup with expanded rack
NewCarTuningTable2["80f350quad"].parts["ATA2ProtectionWindowFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"])
NewCarTuningTable2["80f350quad"].parts["ATA2ProtectionWindowFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontRight"])
NewCarTuningTable2["80f350quad"].parts["ATA2ProtectionWindowFrontRight"].Heavy.protection = {"WindowFrontRight"}
NewCarTuningTable2["80f350quad"].parts["ATA2ProtectionWindshield"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"])
NewCarTuningTable2["80f350quad"].parts["ATA2ProtectionWindshieldRear"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshieldRear"])
NewCarTuningTable2["80f350quad"].parts["ATA2Bullbar"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2Bullbar"])
NewCarTuningTable2["80f350quad"].parts["ATA2ProtectionTrunk"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"])
NewCarTuningTable2["80f350quad"].parts["ATA2ProtectionTrunk"].Light.protection = {"TruckBedOpen", "GasTank"}
NewCarTuningTable2["80f350quad"].parts["ATA2ProtectionTrunk"].Heavy.protection = {"TruckBedOpen", "GasTank"}
NewCarTuningTable2["80f350quad"].parts["ATA2ProtectionHood"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHood"])
NewCarTuningTable2["80f350quad"].parts["ATA2ProtectionDoorFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"])
NewCarTuningTable2["80f350quad"].parts["ATA2ProtectionDoorFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontRight"])
NewCarTuningTable2["80f350quad"].parts["ATA2ProtectionDoorRearLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearLeft"])
NewCarTuningTable2["80f350quad"].parts["ATA2ProtectionDoorRearRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearRight"])
NewCarTuningTable2["80f350quad"].parts["ATA2InteractiveTrunkRoofRack"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2InteractiveTrunkRoofRack"])
NewCarTuningTable2["80f350quad"].parts["ATA2InteractiveTrunkRoofRack"].Default.containerCapacity = 100
NewCarTuningTable2["80f350quad"].parts["ATA2ProtectionWheels"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWheels"])


-- 80f350ambulance - 2 door van with expanded rack
NewCarTuningTable2["80f350ambulance"].parts["ATA2ProtectionWindowFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"])
NewCarTuningTable2["80f350ambulance"].parts["ATA2ProtectionWindowFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontRight"])
NewCarTuningTable2["80f350ambulance"].parts["ATA2ProtectionWindshield"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"])
NewCarTuningTable2["80f350ambulance"].parts["ATA2ProtectionWindshieldRear"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshieldRear"])
NewCarTuningTable2["80f350ambulance"].parts["ATA2Bullbar"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2Bullbar"])
NewCarTuningTable2["80f350ambulance"].parts["ATA2ProtectionDoorsRear"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorsRear"])
NewCarTuningTable2["80f350ambulance"].parts["ATA2ProtectionHood"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHood"])
NewCarTuningTable2["80f350ambulance"].parts["ATA2ProtectionDoorFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"])
NewCarTuningTable2["80f350ambulance"].parts["ATA2ProtectionDoorFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontRight"])
NewCarTuningTable2["80f350ambulance"].parts["ATA2InteractiveTrunkRoofRack"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2InteractiveTrunkRoofRack"])
NewCarTuningTable2["80f350ambulance"].parts["ATA2InteractiveTrunkRoofRack"].Default.containerCapacity = 100
NewCarTuningTable2["80f350ambulance"].parts["ATA2ProtectionWheels"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWheels"])


-- 85vicwag - 4 door car with expanded rack
NewCarTuningTable2["85vicwag"].parts["ATA2ProtectionWindowFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"])
NewCarTuningTable2["85vicwag"].parts["ATA2ProtectionWindowFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontRight"])
NewCarTuningTable2["85vicwag"].parts["ATA2ProtectionWindowRearLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearLeft"])
NewCarTuningTable2["85vicwag"].parts["ATA2ProtectionWindowRearRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearRight"])
NewCarTuningTable2["85vicwag"].parts["ATA2ProtectionWindshield"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"])
NewCarTuningTable2["85vicwag"].parts["ATA2ProtectionWindshieldRear"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshieldRear"])
NewCarTuningTable2["85vicwag"].parts["ATA2Bullbar"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2Bullbar"])
NewCarTuningTable2["85vicwag"].parts["ATA2ProtectionTrunk"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"])
NewCarTuningTable2["85vicwag"].parts["ATA2ProtectionHood"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHood"])
NewCarTuningTable2["85vicwag"].parts["ATA2ProtectionDoorFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"])
NewCarTuningTable2["85vicwag"].parts["ATA2ProtectionDoorFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontRight"])
NewCarTuningTable2["85vicwag"].parts["ATA2ProtectionDoorRearLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearLeft"])
NewCarTuningTable2["85vicwag"].parts["ATA2ProtectionDoorRearRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearRight"])
NewCarTuningTable2["85vicwag"].parts["ATA2InteractiveTrunkRoofRack"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2InteractiveTrunkRoofRack"])
NewCarTuningTable2["85vicwag"].parts["ATA2InteractiveTrunkRoofRack"].Default.containerCapacity = 100
NewCarTuningTable2["85vicwag"].parts["ATA2ProtectionWheels"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWheels"])


-- 85vicsheriff - 4 door car without rack, no bullbar
NewCarTuningTable2["85vicsheriff"].parts["ATA2ProtectionWindowFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"])
NewCarTuningTable2["85vicsheriff"].parts["ATA2ProtectionWindowFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontRight"])
NewCarTuningTable2["85vicsheriff"].parts["ATA2ProtectionWindowRearLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearLeft"])
NewCarTuningTable2["85vicsheriff"].parts["ATA2ProtectionWindowRearRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearRight"])
NewCarTuningTable2["85vicsheriff"].parts["ATA2ProtectionWindshield"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"])
NewCarTuningTable2["85vicsheriff"].parts["ATA2ProtectionWindshieldRear"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshieldRear"])
NewCarTuningTable2["85vicsheriff"].parts["ATA2ProtectionTrunk"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"])
NewCarTuningTable2["85vicsheriff"].parts["ATA2ProtectionHood"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHood"])
NewCarTuningTable2["85vicsheriff"].parts["ATA2ProtectionHood"].Light.protection = {"HeadlightLeft", "HeadlightRight", "EngineDoor"}
NewCarTuningTable2["85vicsheriff"].parts["ATA2ProtectionHood"].Heavy.protection = {"HeadlightLeft", "HeadlightRight", "EngineDoor"}
NewCarTuningTable2["85vicsheriff"].parts["ATA2ProtectionDoorFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"])
NewCarTuningTable2["85vicsheriff"].parts["ATA2ProtectionDoorFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontRight"])
NewCarTuningTable2["85vicsheriff"].parts["ATA2ProtectionDoorRearLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearLeft"])
NewCarTuningTable2["85vicsheriff"].parts["ATA2ProtectionDoorRearRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearRight"])
NewCarTuningTable2["85vicsheriff"].parts["ATA2ProtectionWheels"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWheels"])


-- 85vicranger - 4 door car without rack
NewCarTuningTable2["85vicranger"].parts["ATA2ProtectionWindowFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"])
NewCarTuningTable2["85vicranger"].parts["ATA2ProtectionWindowFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontRight"])
NewCarTuningTable2["85vicranger"].parts["ATA2ProtectionWindowRearLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearLeft"])
NewCarTuningTable2["85vicranger"].parts["ATA2ProtectionWindowRearRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearRight"])
NewCarTuningTable2["85vicranger"].parts["ATA2ProtectionWindshield"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"])
NewCarTuningTable2["85vicranger"].parts["ATA2ProtectionWindshieldRear"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshieldRear"])
NewCarTuningTable2["85vicranger"].parts["ATA2Bullbar"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2Bullbar"])
NewCarTuningTable2["85vicranger"].parts["ATA2ProtectionTrunk"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"])
NewCarTuningTable2["85vicranger"].parts["ATA2ProtectionHood"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHood"])
NewCarTuningTable2["85vicranger"].parts["ATA2ProtectionDoorFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"])
NewCarTuningTable2["85vicranger"].parts["ATA2ProtectionDoorFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontRight"])
NewCarTuningTable2["85vicranger"].parts["ATA2ProtectionDoorRearLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearLeft"])
NewCarTuningTable2["85vicranger"].parts["ATA2ProtectionDoorRearRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearRight"])
NewCarTuningTable2["85vicranger"].parts["ATA2ProtectionWheels"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWheels"])


-- 86bounder - RV, expanded rack and stupid levels of annoying to work with
NewCarTuningTable2["86bounder"].parts["ATA2ProtectionWindshield"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"])
NewCarTuningTable2["86bounder"].parts["ATA2ProtectionWindshieldRear"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshieldRear"])
NewCarTuningTable2["86bounder"].parts["ATA2Bullbar"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2Bullbar"])
NewCarTuningTable2["86bounder"].parts["ATA2ProtectionTrunk"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"])
NewCarTuningTable2["86bounder"].parts["ATA2ProtectionHood"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHood"])
NewCarTuningTable2["86bounder"].parts["ATA2ProtectionDoorMiddleRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorMiddleRight"])
NewCarTuningTable2["86bounder"].parts["ATA2InteractiveTrunkRoofRack"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2InteractiveTrunkRoofRack"])
NewCarTuningTable2["86bounder"].parts["ATA2InteractiveTrunkRoofRack"].Default.containerCapacity = 100
NewCarTuningTable2["86bounder"].parts["ATA2ProtectionWheels"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWheels"])


-- 86econolinerv - RV, expanded rack and stupid levels of annoying to work with
NewCarTuningTable2["86econolinerv"].parts["ATA2ProtectionWindowFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"])
NewCarTuningTable2["86econolinerv"].parts["ATA2ProtectionWindowFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontRight"])
NewCarTuningTable2["86econolinerv"].parts["ATA2ProtectionWindowMiddleLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowMiddleLeft"])
NewCarTuningTable2["86econolinerv"].parts["ATA2ProtectionWindshield"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"])
NewCarTuningTable2["86econolinerv"].parts["ATA2ProtectionWindshieldRear"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshieldRear"])
NewCarTuningTable2["86econolinerv"].parts["ATA2Bullbar"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2Bullbar"])
NewCarTuningTable2["86econolinerv"].parts["ATA2ProtectionTrunk"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"])
NewCarTuningTable2["86econolinerv"].parts["ATA2ProtectionTrunk"].Light.protection = {"TruckBed", "GasTank"}
NewCarTuningTable2["86econolinerv"].parts["ATA2ProtectionTrunk"].Heavy.protection = {"TruckBed", "GasTank"}
NewCarTuningTable2["86econolinerv"].parts["ATA2ProtectionHood"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHood"])
NewCarTuningTable2["86econolinerv"].parts["ATA2ProtectionDoorFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"])
NewCarTuningTable2["86econolinerv"].parts["ATA2ProtectionDoorFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontRight"])
NewCarTuningTable2["86econolinerv"].parts["ATA2ProtectionDoorRearRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearRight"])
NewCarTuningTable2["86econolinerv"].parts["ATA2InteractiveTrunkRoofRack"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2InteractiveTrunkRoofRack"])
NewCarTuningTable2["86econolinerv"].parts["ATA2InteractiveTrunkRoofRack"].Default.containerCapacity = 100
NewCarTuningTable2["86econolinerv"].parts["ATA2ProtectionWheels"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWheels"])


-- 87blazeroffroad - 2 door pickup with rack, no bullbar
NewCarTuningTable2["87blazeroffroad"].parts["ATA2ProtectionWindowFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"])
NewCarTuningTable2["87blazeroffroad"].parts["ATA2ProtectionWindowFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontRight"])
NewCarTuningTable2["87blazeroffroad"].parts["ATA2ProtectionWindshield"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"])
NewCarTuningTable2["87blazeroffroad"].parts["ATA2ProtectionWindshieldRear"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshieldRear"])
NewCarTuningTable2["87blazeroffroad"].parts["ATA2ProtectionTrunk"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"])
NewCarTuningTable2["87blazeroffroad"].parts["ATA2ProtectionHood"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHood"])
NewCarTuningTable2["87blazeroffroad"].parts["ATA2ProtectionHood"].Light.protection = {"HeadlightLeft", "HeadlightRight", "EngineDoor"}
NewCarTuningTable2["87blazeroffroad"].parts["ATA2ProtectionHood"].Heavy.protection = {"HeadlightLeft", "HeadlightRight", "EngineDoor"}
NewCarTuningTable2["87blazeroffroad"].parts["ATA2ProtectionDoorFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"])
NewCarTuningTable2["87blazeroffroad"].parts["ATA2ProtectionDoorFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontRight"])
NewCarTuningTable2["87blazeroffroad"].parts["ATA2InteractiveTrunkRoofRack"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2InteractiveTrunkRoofRack"])
NewCarTuningTable2["87blazeroffroad"].parts["ATA2ProtectionWheels"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWheels"])


-- 87suburban - 4 door suv with expanded rack
NewCarTuningTable2["87suburban"].parts["ATA2ProtectionWindowFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"])
NewCarTuningTable2["87suburban"].parts["ATA2ProtectionWindowFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontRight"])
NewCarTuningTable2["87suburban"].parts["ATA2ProtectionWindowMiddleLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowMiddleLeft"])
NewCarTuningTable2["87suburban"].parts["ATA2ProtectionWindowMiddleRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowMiddleRight"])
NewCarTuningTable2["87suburban"].parts["ATA2ProtectionWindshield"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"])
NewCarTuningTable2["87suburban"].parts["ATA2ProtectionWindshieldRear"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshieldRear"])
NewCarTuningTable2["87suburban"].parts["ATA2Bullbar"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2Bullbar"])
NewCarTuningTable2["87suburban"].parts["ATA2ProtectionDoorsRear"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorsRear"])
NewCarTuningTable2["87suburban"].parts["ATA2ProtectionHood"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHood"])
NewCarTuningTable2["87suburban"].parts["ATA2ProtectionDoorFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"])
NewCarTuningTable2["87suburban"].parts["ATA2ProtectionDoorFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontRight"])
NewCarTuningTable2["87suburban"].parts["ATA2ProtectionDoorMiddleLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorMiddleLeft"])
NewCarTuningTable2["87suburban"].parts["ATA2ProtectionDoorMiddleRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorMiddleRight"])
NewCarTuningTable2["87suburban"].parts["ATA2InteractiveTrunkRoofRack"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2InteractiveTrunkRoofRack"])
NewCarTuningTable2["87suburban"].parts["ATA2InteractiveTrunkRoofRack"].Default.containerCapacity = 100
NewCarTuningTable2["87suburban"].parts["ATA2ProtectionWheels"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWheels"])


-- 92wrangler - 2 door, 4 window jeep without rack
NewCarTuningTable2["92wrangler"].parts["ATA2ProtectionWindowFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"])
NewCarTuningTable2["92wrangler"].parts["ATA2ProtectionWindowFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontRight"])
NewCarTuningTable2["92wrangler"].parts["ATA2ProtectionWindowRearLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearLeft"])
NewCarTuningTable2["92wrangler"].parts["ATA2ProtectionWindowRearRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearRight"])
NewCarTuningTable2["92wrangler"].parts["ATA2ProtectionWindshield"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"])
NewCarTuningTable2["92wrangler"].parts["ATA2ProtectionWindshieldRear"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshieldRear"])
NewCarTuningTable2["92wrangler"].parts["ATA2Bullbar"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2Bullbar"])
NewCarTuningTable2["92wrangler"].parts["ATA2ProtectionTrunk"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"])
NewCarTuningTable2["92wrangler"].parts["ATA2ProtectionHood"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHood"])
NewCarTuningTable2["92wrangler"].parts["ATA2ProtectionDoorFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"])
NewCarTuningTable2["92wrangler"].parts["ATA2ProtectionDoorFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontRight"])
NewCarTuningTable2["92wrangler"].parts["ATA2ProtectionWheels"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWheels"])


-- astrovan 4 door minivan with expanded rack
NewCarTuningTable2["astrovan"].parts["ATA2ProtectionWindowFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"])
NewCarTuningTable2["astrovan"].parts["ATA2ProtectionWindowFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontRight"])
NewCarTuningTable2["astrovan"].parts["ATA2ProtectionWindowMiddleLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowMiddleLeft"])
NewCarTuningTable2["astrovan"].parts["ATA2ProtectionWindowMiddleRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowMiddleRight"])
NewCarTuningTable2["astrovan"].parts["ATA2ProtectionWindshield"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"])
NewCarTuningTable2["astrovan"].parts["ATA2ProtectionWindshieldRear"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshieldRear"])
NewCarTuningTable2["astrovan"].parts["ATA2Bullbar"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2Bullbar"])
NewCarTuningTable2["astrovan"].parts["ATA2ProtectionTrunk"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"])
NewCarTuningTable2["astrovan"].parts["ATA2ProtectionHood"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHood"])
NewCarTuningTable2["astrovan"].parts["ATA2ProtectionDoorFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"])
NewCarTuningTable2["astrovan"].parts["ATA2ProtectionDoorFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontRight"])
NewCarTuningTable2["astrovan"].parts["ATA2ProtectionDoorMiddleRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorMiddleRight"])
NewCarTuningTable2["astrovan"].parts["ATA2InteractiveTrunkRoofRack"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2InteractiveTrunkRoofRack"])
NewCarTuningTable2["astrovan"].parts["ATA2InteractiveTrunkRoofRack"].Default.containerCapacity = 100
NewCarTuningTable2["astrovan"].parts["ATA2ProtectionWheels"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWheels"])


-- chevystepvanswat - stepvan with expanded rack, has a special trunk
NewCarTuningTable2["chevystepvanswat"].parts["ATA2ProtectionWindowFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"])
NewCarTuningTable2["chevystepvanswat"].parts["ATA2ProtectionWindowFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontRight"])
NewCarTuningTable2["chevystepvanswat"].parts["ATA2ProtectionWindshield"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"])
NewCarTuningTable2["chevystepvanswat"].parts["ATA2ProtectionWindshieldRear"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshieldRear"])
NewCarTuningTable2["chevystepvanswat"].parts["ATA2Bullbar"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2Bullbar"])
NewCarTuningTable2["chevystepvanswat"].parts["ATA2ProtectionHood"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHood"])
NewCarTuningTable2["chevystepvanswat"].parts["ATA2ProtectionHood"].Light.protection = {"EngineDoor", "GasTank"}
NewCarTuningTable2["chevystepvanswat"].parts["ATA2ProtectionHood"].Heavy.protection = {"EngineDoor", "GasTank"}
NewCarTuningTable2["chevystepvanswat"].parts["ATA2ProtectionDoorFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"])
NewCarTuningTable2["chevystepvanswat"].parts["ATA2ProtectionDoorFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontRight"])
NewCarTuningTable2["chevystepvanswat"].parts["ATA2ProtectionDoorRearLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearLeft"])
NewCarTuningTable2["chevystepvanswat"].parts["ATA2ProtectionDoorRearLeft"].Light.protection = {"DoorRearLeft", "FR_VehicleArmory", "FR_VehicleArmory2"}
NewCarTuningTable2["chevystepvanswat"].parts["ATA2ProtectionDoorRearRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearRight"])
NewCarTuningTable2["chevystepvanswat"].parts["ATA2ProtectionDoorRearRight"].Light.protection = {"DoorRearRight", "FR_VehicleArmory", "FR_VehicleArmory2"}
NewCarTuningTable2["chevystepvanswat"].parts["ATA2ProtectionDoorFrontRight"].Heavy.protection = {"DoorFrontRight"}
NewCarTuningTable2["chevystepvanswat"].parts["ATA2ProtectionDoorRearLeft"].Heavy.protection = {"DoorRearLeft", "FR_VehicleArmory", "FR_VehicleArmory2"}
NewCarTuningTable2["chevystepvanswat"].parts["ATA2ProtectionDoorRearRight"].Heavy.protection = {"DoorRearRight", "FR_VehicleArmory", "FR_VehicleArmory2"}
--NewCarTuningTable2["chevystepvanswat"].parts["ATA2InteractiveTrunkRoofRack"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2InteractiveTrunkRoofRack"])
--NewCarTuningTable2["chevystepvanswat"].parts["ATA2InteractiveTrunkRoofRack"].Default.containerCapacity = 100
NewCarTuningTable2["chevystepvanswat"].parts["ATA2ProtectionWheels"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWheels"])


-- f700box - large box truck with extra large rack
NewCarTuningTable2["f700box"].parts["ATA2ProtectionWindowFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"])
NewCarTuningTable2["f700box"].parts["ATA2ProtectionWindowFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontRight"])
NewCarTuningTable2["f700box"].parts["ATA2ProtectionWindshield"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"])
NewCarTuningTable2["f700box"].parts["ATA2ProtectionWindshieldRear"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshieldRear"])
NewCarTuningTable2["f700box"].parts["ATA2Bullbar"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2Bullbar"])
NewCarTuningTable2["f700box"].parts["ATA2ProtectionTrunk"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"])
NewCarTuningTable2["f700box"].parts["ATA2ProtectionHood"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHood"])
NewCarTuningTable2["f700box"].parts["ATA2ProtectionDoorFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"])
NewCarTuningTable2["f700box"].parts["ATA2ProtectionDoorFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontRight"])
NewCarTuningTable2["f700box"].parts["ATA2InteractiveTrunkRoofRack"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2InteractiveTrunkRoofRack"])
NewCarTuningTable2["f700box"].parts["ATA2InteractiveTrunkRoofRack"].Default.containerCapacity = 200
NewCarTuningTable2["f700box"].parts["ATA2ProtectionWheels"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWheels"])


-- Humvee with Hardtop - 4 door truck without rack, no bullbar, no rear windshield
NewCarTuningTable2["hmmwvht"].parts["ATA2ProtectionWindowFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"])
NewCarTuningTable2["hmmwvht"].parts["ATA2ProtectionWindowFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontRight"])
NewCarTuningTable2["hmmwvht"].parts["ATA2ProtectionWindowRearLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearLeft"])
NewCarTuningTable2["hmmwvht"].parts["ATA2ProtectionWindowRearRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearRight"])
NewCarTuningTable2["hmmwvht"].parts["ATA2ProtectionWindshield"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"])
NewCarTuningTable2["hmmwvht"].parts["ATA2ProtectionTrunk"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"])
NewCarTuningTable2["hmmwvht"].parts["ATA2ProtectionHood"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHood"])
NewCarTuningTable2["hmmwvht"].parts["ATA2ProtectionHood"].Light.protection = {"HeadlightLeft", "HeadlightRight", "EngineDoor"}
NewCarTuningTable2["hmmwvht"].parts["ATA2ProtectionHood"].Heavy.protection = {"HeadlightLeft", "HeadlightRight", "EngineDoor"}
NewCarTuningTable2["hmmwvht"].parts["ATA2ProtectionDoorFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"])
NewCarTuningTable2["hmmwvht"].parts["ATA2ProtectionDoorFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontRight"])
NewCarTuningTable2["hmmwvht"].parts["ATA2ProtectionDoorRearLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearLeft"])
NewCarTuningTable2["hmmwvht"].parts["ATA2ProtectionDoorRearRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearRight"])
NewCarTuningTable2["hmmwvht"].parts["ATA2ProtectionWheels"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWheels"])


-- schoolbus - large bus with extra large rack
NewCarTuningTable2["schoolbus"].parts["ATA2ProtectionWindowFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"])
NewCarTuningTable2["schoolbus"].parts["ATA2ProtectionWindowFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontRight"])
NewCarTuningTable2["schoolbus"].parts["ATA2ProtectionWindowRearRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearRight"])
NewCarTuningTable2["schoolbus"].parts["ATA2ProtectionWindshield"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"])
NewCarTuningTable2["schoolbus"].parts["ATA2ProtectionWindshieldRear"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshieldRear"])
NewCarTuningTable2["schoolbus"].parts["ATA2Bullbar"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2Bullbar"])
NewCarTuningTable2["schoolbus"].parts["ATA2ProtectionTrunk"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"])
NewCarTuningTable2["schoolbus"].parts["ATA2ProtectionHood"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHood"])
NewCarTuningTable2["schoolbus"].parts["ATA2ProtectionDoorFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontRight"])
NewCarTuningTable2["schoolbus"].parts["ATA2ProtectionDoorRearRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearRight"])
NewCarTuningTable2["schoolbus"].parts["ATA2InteractiveTrunkRoofRack"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2InteractiveTrunkRoofRack"])
NewCarTuningTable2["schoolbus"].parts["ATA2InteractiveTrunkRoofRack"].Default.containerCapacity = 200
NewCarTuningTable2["schoolbus"].parts["ATA2ProtectionWheels"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWheels"])


-- tractorford7810 - it's a hecking tractor! A no rack, no bullbar, no trunk, 2 door monstrosity!
NewCarTuningTable2["tractorford7810"].parts["ATA2ProtectionWindowFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"])
NewCarTuningTable2["tractorford7810"].parts["ATA2ProtectionWindowFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontRight"])
NewCarTuningTable2["tractorford7810"].parts["ATA2ProtectionWindshield"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"])
NewCarTuningTable2["tractorford7810"].parts["ATA2ProtectionWindshieldRear"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshieldRear"])
NewCarTuningTable2["tractorford7810"].parts["ATA2ProtectionDoorFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"])
NewCarTuningTable2["tractorford7810"].parts["ATA2ProtectionDoorFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontRight"])
NewCarTuningTable2["tractorford7810"].parts["ATA2ProtectionWheels"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWheels"])


-- 91blazerpd - 2 door truck without rack, no bullbar
NewCarTuningTable2["91blazerpd"].parts["ATA2ProtectionWindowFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"])
NewCarTuningTable2["91blazerpd"].parts["ATA2ProtectionWindowFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontRight"])
NewCarTuningTable2["91blazerpd"].parts["ATA2ProtectionWindshield"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"])
NewCarTuningTable2["91blazerpd"].parts["ATA2ProtectionWindshieldRear"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshieldRear"])
NewCarTuningTable2["91blazerpd"].parts["ATA2ProtectionTrunk"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"])
NewCarTuningTable2["91blazerpd"].parts["ATA2ProtectionHood"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHood"])
NewCarTuningTable2["91blazerpd"].parts["ATA2ProtectionHood"].Light.protection = {"HeadlightLeft", "HeadlightRight", "EngineDoor"}
NewCarTuningTable2["91blazerpd"].parts["ATA2ProtectionHood"].Heavy.protection = {"HeadlightLeft", "HeadlightRight", "EngineDoor"}
NewCarTuningTable2["91blazerpd"].parts["ATA2ProtectionDoorFrontLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"])
NewCarTuningTable2["91blazerpd"].parts["ATA2ProtectionDoorFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontRight"])
NewCarTuningTable2["91blazerpd"].parts["ATA2ProtectionWheels"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWheels"])


-- scamp - camper trailer with no windows, and an expanded rack. No bullbar.
NewCarTuningTable2["Trailercamperscamp"].parts["ATA2ProtectionTrunk"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"])
NewCarTuningTable2["Trailercamperscamp"].parts["ATA2ProtectionTrunk"].Light.protection = {"TruckBedOpen", "TrunkDoor", "DoorRear"}
NewCarTuningTable2["Trailercamperscamp"].parts["ATA2ProtectionTrunk"].Heavy.protection = {"TruckBedOpen", "TrunkDoor", "DoorRear"}
NewCarTuningTable2["Trailercamperscamp"].parts["ATA2ProtectionDoorFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontRight"])
NewCarTuningTable2["Trailercamperscamp"].parts["ATA2InteractiveTrunkRoofRack"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2InteractiveTrunkRoofRack"])
NewCarTuningTable2["Trailercamperscamp"].parts["ATA2InteractiveTrunkRoofRack"].Default.containerCapacity = 100
NewCarTuningTable2["Trailercamperscamp"].parts["ATA2ProtectionWheels"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWheels"])
NewCarTuningTable2["Trailercamperscamp"].parts["ATA2ProtectionWheels"].ATAProtection.protection = {"TireFrontLeft", "TireFrontRight"}


-- 51chevy trailer - old trailer with no windows, no rack, and no bullbar.
NewCarTuningTable2["Trailer51chevy"].parts["ATA2ProtectionTrunk"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"])
NewCarTuningTable2["Trailer51chevy"].parts["ATA2ProtectionTrunk"].Light.protection = {"TruckBedOpen"}
NewCarTuningTable2["Trailer51chevy"].parts["ATA2ProtectionTrunk"].Heavy.protection = {"TruckBedOpen"}
NewCarTuningTable2["Trailer51chevy"].parts["ATA2ProtectionWheels"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWheels"])
NewCarTuningTable2["Trailer51chevy"].parts["ATA2ProtectionWheels"].ATAProtection.protection = {"TireFrontLeft", "TireFrontRight"}


-- medium moving trailer - box trailer with no windows, and an expanded rack. No bullbar.
NewCarTuningTable2["Trailermovingmedium"].parts["ATA2ProtectionTrunk"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"])
NewCarTuningTable2["Trailermovingmedium"].parts["ATA2ProtectionTrunk"].Light.protection = {"TruckBedOpen", "DoorRear"}
NewCarTuningTable2["Trailermovingmedium"].parts["ATA2ProtectionTrunk"].Heavy.protection = {"TruckBedOpen", "DoorRear"}
NewCarTuningTable2["Trailermovingmedium"].parts["ATA2InteractiveTrunkRoofRack"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2InteractiveTrunkRoofRack"])
NewCarTuningTable2["Trailermovingmedium"].parts["ATA2InteractiveTrunkRoofRack"].Default.containerCapacity = 100
NewCarTuningTable2["Trailermovingmedium"].parts["ATA2ProtectionWheels"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWheels"])
NewCarTuningTable2["Trailermovingmedium"].parts["ATA2ProtectionWheels"].ATAProtection.protection = {"TireFrontLeft", "TireFrontRight"}


-- big moving trailer - box trailer with no windows, and an extra large rack. No bullbar.
NewCarTuningTable2["Trailermovingbig"].parts["ATA2ProtectionTrunk"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"])
NewCarTuningTable2["Trailermovingbig"].parts["ATA2ProtectionTrunk"].Light.protection = {"TruckBedOpen", "DoorRear"}
NewCarTuningTable2["Trailermovingbig"].parts["ATA2ProtectionTrunk"].Heavy.protection = {"TruckBedOpen", "DoorRear"}
NewCarTuningTable2["Trailermovingbig"].parts["ATA2InteractiveTrunkRoofRack"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2InteractiveTrunkRoofRack"])
NewCarTuningTable2["Trailermovingbig"].parts["ATA2InteractiveTrunkRoofRack"].Default.containerCapacity = 200
NewCarTuningTable2["Trailermovingbig"].parts["ATA2ProtectionWheels"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWheels"])


-- big fuel trailer - tanker trailer with no windows, no rack, and no bullbar.
NewCarTuningTable2["Trailerfuelmedium"].parts["ATA2ProtectionWheels"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWheels"])

-- small fuel trailer - tanker trailer with no windows, no rack, and no bullbar.
NewCarTuningTable2["Trailerfuelsmall"].parts["ATA2ProtectionWheels"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWheels"])
NewCarTuningTable2["Trailerfuelsmall"].parts["ATA2ProtectionWheels"].ATAProtection.protection = {"TireFrontLeft", "TireFrontRight"}




		NewCarTuningTable2["51chevy3100old"] = NewCarTuningTable2["51chevy3100"]
		NewCarTuningTable2["65gto"] = NewCarTuningTable2["64mustang"]
		NewCarTuningTable2["68elcamino"] = NewCarTuningTable2["51chevy3100"]
		NewCarTuningTable2["69charger"] = NewCarTuningTable2["64mustang"]
		NewCarTuningTable2["70chevelle"] = NewCarTuningTable2["64mustang"]
		NewCarTuningTable2["70elcamino"] = NewCarTuningTable2["51chevy3100"]
		NewCarTuningTable2["71chevyc10lb"] = NewCarTuningTable2["51chevy3100"]
		NewCarTuningTable2["71chevyc10offroadsb"] = NewCarTuningTable2["71chevyc10offroadlb"]
		NewCarTuningTable2["71chevyc10offroadstepside"] = NewCarTuningTable2["71chevyc10offroadlb"]
		NewCarTuningTable2["71chevyc10sb"] = NewCarTuningTable2["51chevy3100"]
		NewCarTuningTable2["71chevyc10stepside"] = NewCarTuningTable2["51chevy3100"]
		NewCarTuningTable2["71impala"] = NewCarTuningTable2["68wildcat"]
		NewCarTuningTable2["72beetle"] = NewCarTuningTable2["73pinto"]
		NewCarTuningTable2["73falcon"] = NewCarTuningTable2["64mustang"]
		NewCarTuningTable2["77transam"] = NewCarTuningTable2["64mustang"]
		NewCarTuningTable2["79brougham"] = NewCarTuningTable2["68wildcat"]
		NewCarTuningTable2["79datsun280z"] = NewCarTuningTable2["68wildcatconvert"]
		NewCarTuningTable2["80f350"] = NewCarTuningTable2["51chevy3100"]
		NewCarTuningTable2["80f350offroad"] = NewCarTuningTable2["71chevyc10offroadlb"]
		NewCarTuningTable2["83hilux"] = NewCarTuningTable2["51chevy3100"]
		NewCarTuningTable2["83hiluxoffroad"] = NewCarTuningTable2["71chevyc10offroadlb"]
		NewCarTuningTable2["85vicsed"] = NewCarTuningTable2["68wildcat"]
		NewCarTuningTable2["85vicwag2"] = NewCarTuningTable2["85vicwag"]
		NewCarTuningTable2["86econoline"] = NewCarTuningTable2["80f350ambulance"]
		NewCarTuningTable2["86econolineflorist"] = NewCarTuningTable2["80f350ambulance"]
		NewCarTuningTable2["86econolineambulance"] = NewCarTuningTable2["80f350ambulance"]
		NewCarTuningTable2["86montecarlo"] = NewCarTuningTable2["64mustang"]
		NewCarTuningTable2["86yugo"] = NewCarTuningTable2["73pinto"]
		NewCarTuningTable2["87blazer"] = NewCarTuningTable2["64mustang"]
		NewCarTuningTable2["87c10sb"] = NewCarTuningTable2["51chevy3100"]
		NewCarTuningTable2["87c10lb"] = NewCarTuningTable2["51chevy3100"]
		NewCarTuningTable2["87c10offroadsb"] = NewCarTuningTable2["71chevyc10offroadlb"]
		NewCarTuningTable2["87c10offroadlb"] = NewCarTuningTable2["71chevyc10offroadlb"]
		NewCarTuningTable2["87c10utility"] = NewCarTuningTable2["51chevy3100"]
		NewCarTuningTable2["87c10mccoy"] = NewCarTuningTable2["51chevy3100"]
		NewCarTuningTable2["87c10fire"] = NewCarTuningTable2["51chevy3100"]
		NewCarTuningTable2["87caprice"] = NewCarTuningTable2["68wildcat"]
		NewCarTuningTable2["87capricePD"] = NewCarTuningTable2["85vicsheriff"]
		NewCarTuningTable2["90corolla"] = NewCarTuningTable2["68wildcat"]
		NewCarTuningTable2["90ramsb"] = NewCarTuningTable2["51chevy3100"]
		NewCarTuningTable2["90ramlb"] = NewCarTuningTable2["51chevy3100"]
		NewCarTuningTable2["90ramoffroadsb"] = NewCarTuningTable2["71chevyc10offroadlb"]
		NewCarTuningTable2["90ramoffroadlb"] = NewCarTuningTable2["71chevyc10offroadlb"]
		NewCarTuningTable2["91celica"] = NewCarTuningTable2["73pinto"]
		NewCarTuningTable2["91chevys10"] = NewCarTuningTable2["51chevy3100"]
		NewCarTuningTable2["91chevys10ext"] = NewCarTuningTable2["51chevy3100"]
		NewCarTuningTable2["91chevys10offroad"] = NewCarTuningTable2["71chevyc10offroadlb"]
		NewCarTuningTable2["91chevys10offroadext"] = NewCarTuningTable2["71chevyc10offroadlb"]
		NewCarTuningTable2["91crx"] = NewCarTuningTable2["73pinto"]
		NewCarTuningTable2["91wagoneer"] = NewCarTuningTable2["85vicwag"]
		NewCarTuningTable2["92crownvic"] = NewCarTuningTable2["68wildcat"]
		NewCarTuningTable2["92crownvicPD"] = NewCarTuningTable2["85vicsheriff"]
		NewCarTuningTable2["92wranglerjurassic"] = NewCarTuningTable2["92wrangler"]
		NewCarTuningTable2["92wrangleroffroad"] = NewCarTuningTable2["92wrangler"]
		NewCarTuningTable2["92wranglerranger"] = NewCarTuningTable2["92wrangler"]
		NewCarTuningTable2["93explorer"] = NewCarTuningTable2["85vicwag"]
		NewCarTuningTable2["93explorerjurassic"] = NewCarTuningTable2["85vicsheriff"]
		NewCarTuningTable2["93jeepcherokee"] = NewCarTuningTable2["85vicsed"]
		NewCarTuningTable2["93jeepcherokeeoffroad"] = NewCarTuningTable2["85vicsheriff"]
		NewCarTuningTable2["chevystepvan"] = NewCarTuningTable2["80f350ambulance"]
		NewCarTuningTable2["isuzubox"] = NewCarTuningTable2["80f350ambulance"]
		NewCarTuningTable2["isuzuboxfood"] = NewCarTuningTable2["80f350ambulance"]
		NewCarTuningTable2["isuzuboxelec"] = NewCarTuningTable2["80f350ambulance"]
		NewCarTuningTable2["f700dump"] = NewCarTuningTable2["68wildcatconvert"]
		NewCarTuningTable2["f700flatbed"] = NewCarTuningTable2["51chevy3100"]
		NewCarTuningTable2["f700propane"] = NewCarTuningTable2["68wildcatconvert"]
		NewCarTuningTable2["firepumper"] = NewCarTuningTable2["85vicsheriff"]
		NewCarTuningTable2["generallee"] = NewCarTuningTable2["64mustang"]
		NewCarTuningTable2["generalmeh"] = NewCarTuningTable2["73pinto"]
		NewCarTuningTable2["hmmwvtr"] = NewCarTuningTable2["91blazerpd"]
		NewCarTuningTable2["isuzuboxmccoy"] = NewCarTuningTable2["68wildcatconvert"]
		NewCarTuningTable2["m35a2bed"] = NewCarTuningTable2["91blazerpd"]
		NewCarTuningTable2["m35a2covered"] = NewCarTuningTable2["91blazerpd"]
		NewCarTuningTable2["m35a2fuel"] = NewCarTuningTable2["91blazerpd"]
		NewCarTuningTable2["m151canvas"] = NewCarTuningTable2["91blazerpd"]
		NewCarTuningTable2["pursuitspecial"] = NewCarTuningTable2["64mustang"]
		NewCarTuningTable2["moveurself"] = NewCarTuningTable2["80f350ambulance"]
		NewCarTuningTable2["schoolbusshort"] = NewCarTuningTable2["schoolbus"]
		NewCarTuningTable2["volvo244"] = NewCarTuningTable2["68wildcat"]

		local carRecipe = "MechanicMag1"

		SVUC2_setVehicleRecipesArmor(NewCarTuningTable2, carRecipe, "51chevy3100", "ATA2ProtectionWindowFrontLeft")
		SVUC2_setVehicleRecipesArmor(NewCarTuningTable2, carRecipe, "51chevy3100", "ATA2ProtectionWindowFrontRight")
		SVUC2_setVehicleRecipesArmor(NewCarTuningTable2, carRecipe, "51chevy3100", "ATA2ProtectionWindshield")
		SVUC2_setVehicleRecipesArmor(NewCarTuningTable2, carRecipe, "51chevy3100", "ATA2ProtectionWindshieldRear")
		SVUC2_setVehicleRecipesBullbars(NewCarTuningTable2, carRecipe, "51chevy3100", "ATA2Bullbar")
		SVUC2_setVehicleRecipesArmor(NewCarTuningTable2, carRecipe, "51chevy3100", "ATA2ProtectionTrunk")
		SVUC2_setVehicleRecipesArmorHood(NewCarTuningTable2, carRecipe, "51chevy3100", "ATA2ProtectionHood")
		SVUC2_setVehicleRecipesArmor(NewCarTuningTable2, carRecipe, "51chevy3100", "ATA2ProtectionDoorFrontLeft")
		SVUC2_setVehicleRecipesArmor(NewCarTuningTable2, carRecipe, "51chevy3100", "ATA2ProtectionDoorFrontRight")
		SVUC2_setVehicleRecipesWheels(NewCarTuningTable2, carRecipe, "51chevy3100", "ATA2ProtectionWheels")

		ATA2Tuning_AddNewCars(NewCarTuningTable2)
	end
end
Events.OnInitGlobalModData.Add(SVU_FRTuningTable)

