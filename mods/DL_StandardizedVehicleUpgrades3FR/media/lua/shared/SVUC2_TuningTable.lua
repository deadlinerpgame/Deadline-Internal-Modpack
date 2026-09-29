require "ATA2TuningTable"

local function copy(obj, seen)
	if type(obj) ~= 'table' then return obj end
	if seen and seen[obj] then return seen[obj] end
	local s = seen or {}
	local res = setmetatable({}, getmetatable(obj))
	s[obj] = res
	for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
	return res
end

local function SVUC_SandboxVars(input)
	return SandboxVars.SVUC[input]
end
Events.OnInitGlobalModData.Add(SVUC_SandboxVars)
function SVUC_TemplateVehicleFR()
	local SVUC = {}
	SVUC.timeLight = SVUC_SandboxVars("timeLight")
	SVUC.timeHeavy = SVUC_SandboxVars("timeHeavy")
	SVUC.timeReinforced = SVUC_SandboxVars("timeReinforced")
	SVUC.timeMods = SVUC_SandboxVars("timeMods")
	SVUC.timeWheels = SVUC_SandboxVars("timeWheels")
	SVUC.protectionHealthTriger = SVUC_SandboxVars("protectionHealthTriger")
	SVUC.protectionLightHealthDelta = SVUC_SandboxVars("protectionLightHealthDelta")
	SVUC.protectionHeavyHealthDelta = SVUC_SandboxVars("protectionHeavyHealthDelta")
	SVUC.protectionReinforcedHealthDelta = SVUC_SandboxVars("protectionReinforcedHealthDelta")
	SVUC.protectionBullbarSmallHealthDelta = SVUC_SandboxVars("protectionBullbarSmallHealthDelta")
	SVUC.protectionBullbarMediumHealthDelta = SVUC_SandboxVars("protectionBullbarMediumHealthDelta")
	SVUC.protectionBullbarLargeHealthDelta = SVUC_SandboxVars("protectionBullbarLargeHealthDelta")
	SVUC.protectionPlowHealthDelta = SVUC_SandboxVars("protectionPlowHealthDelta")
	SVUC.protectionWheelsHealthDelta = SVUC_SandboxVars("protectionWheelsHealthDelta")
	SVUC.protectionEngineSmallPowerIncrease = SVUC_SandboxVars("protectionEngineSmallPowerIncrease") * 10
	SVUC.protectionEngineMediumPowerIncrease = SVUC_SandboxVars("protectionEngineMediumPowerIncrease") * 10
	SVUC.protectionEngineLargePowerIncrease = SVUC_SandboxVars("protectionEngineLargePowerIncrease") * 10
	SVUC.protectionEnginePipedPowerIncrease = SVUC_SandboxVars("protectionEnginePipedPowerIncrease") * 10
	SVUC.protectionEngineSnorkelPowerIncrease = SVUC_SandboxVars("protectionEngineSnorkelPowerIncrease") * 10
	SVUC.protectionMods = "protectionMods"
	SVUC.protectionEngineMods = "protectionEngineMods"
	SVUC.protectionLight = "protectionLight"
	SVUC.protectionHeavy = "protectionHeavy"
	SVUC.protectionLightSpiked = "protectionLightSpiked"
	SVUC.protectionHeavySpiked = "protectionHeavySpiked"
	SVUC.protectionLightRusted = "protectionLightRusted"
	SVUC.protectionHeavyRusted = "protectionHeavyRusted"
	SVUC.protectionLightSpikedRusted = "protectionLightSpikedRusted"
	SVUC.protectionHeavySpikedRusted = "protectionHeavySpikedRusted"
	SVUC.protectionReinforced = "protectionReinforced"
	SVUC.protectionReinforcedRusted = "protectionReinforcedRusted"

	TemplateTuningTable = {}
	-- Entries
	TemplateTuningTable["TemplateVehicleFR"] = {
		addPartsFromVehicleScript = "",
		parts = {}
	}

	-- TemplateVehicleFR
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2Bullbar"] = {
		Small = {
			icon = "media/ui/tuning2/mustang_bullbar_1.png",
			name = "IGUI_ATA2_Bullbar_Small",
			category = SVUC.protectionMods,
			protection = {"HeadlightLeft", "HeadlightRight", "EngineDoor"},
			protectionHealthDelta = SVUC.protectionBullbarSmallHealthDelta,
			protectionTriger = SVUC.protectionHealthTriger,
			removeIfBroken = true,
			install = {
				weight = "auto",
				animation = "ATA_PickLock",
				use = {
					MetalPipe = 4,
					MetalBar=2,
					Screws=4,
					BlowTorch = 5,
				},
				tools = {
					bodylocation = "Base.WeldingMask",
					primary = "Base.Wrench",
					secondary = "Base.Screwdriver",
				},
				skills = {
					Mechanics = 10,
				},
				time = SVUC.timeMods, 
			},
			uninstall = {
				weight = "auto",
				animation = "ATA_Crowbar_DoorLeft",
				use = {
					BlowTorch=4,
				},
				tools = {
					bodylocation = "Base.WeldingMask",
					both = "Base.Crowbar",
				},
				skills = {
					Mechanics = 10,
				},
				result = "auto",
				time = SVUC.timeMods,
			}
		}
	}

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"] = {
		Light = {
			icon = "media/ui/tuning2/protection_window_side.png",
			name = "IGUI_VehiclePartATA2ProtectionWindowFrontLeftLight",
			category = SVUC.protectionLight,
			protection = {"WindowFrontLeft"},
			protectionHealthDelta = SVUC.protectionLightHealthDelta,
			protectionTriger = SVUC.protectionHealthTriger,
			removeIfBroken = true,
			install = {
				area = "TireFrontLeft",
				weight = "auto",
				use = {
					MetalPipe = 4,
					MetalBar=4,
					Screws=6,
					BlowTorch = 5,
				},
				tools = {
					bodylocation = "Base.WeldingMask",
					primary = "Base.Wrench",
					secondary = "Base.Screwdriver",
				},
				skills = {
					Mechanics = 10,
				},
				requireInstalled = {"WindowFrontLeft"},
				time = SVUC.timeLight,
			},
			uninstall = {
				area = "TireFrontLeft",
				animation = "ATA_IdleLeverOpenMid",
				use = {
					BlowTorch=4,
				},
				tools = {
					bodylocation = "Base.WeldingMask",
					both = "Base.Crowbar",
				},
				skills = {
					Mechanics = 10,
				},
				result = "auto",
				time = SVUC.timeLight,
			}
		}
	}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"].Heavy = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"].Light)
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"].Heavy.icon = "media/ui/tuning2/protection_window_sheet_side.png"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"].Heavy.name = "IGUI_VehiclePartATA2ProtectionWindowFrontLeftHeavy"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"].Heavy.ArmorWFL = true
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"].Heavy.category = SVUC.protectionHeavy
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"].Heavy.disableOpenWindowFromSeat = "SeatFrontLeft"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"].Heavy.protectionHealthDelta = SVUC.protectionHeavyHealthDelta
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"].Heavy.install.use = {MetalPipe = 4, SheetMetal = 2, MetalBar=4, Screws=6, BlowTorch = 5,}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"].Heavy.install.skills = {Mechanics = 10}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"].Heavy.install.time = SVUC.timeHeavy
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"].Heavy.uninstall.skills = {Mechanics = 10}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"].Heavy.uninstall.time = SVUC.timeHeavy

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"])
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontRight"].Light.name = "IGUI_VehiclePartATA2ProtectionWindowFrontRightLight"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontRight"].Light.protection = {"WindowFrontRight"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontRight"].Light.install.requireInstalled = {"WindowFrontRight"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontRight"].Light.install.area = "TireFrontRight"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontRight"].Light.uninstall.area = "TireFrontRight"

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontRight"].Heavy.name = "IGUI_VehiclePartATA2ProtectionWindowFrontRightHeavy"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontRight"].Heavy.protection = {"WindowFrontRight"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontRight"].Heavy.ArmorWFR = true
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontRight"].Heavy.install.requireInstalled = {"WindowFrontRight"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontRight"].Heavy.disableOpenWindowFromSeat = "SeatFrontRight"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontRight"].Heavy.install.area = "TireFrontRight"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontRight"].Heavy.uninstall.area = "TireFrontRight"

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"])
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearLeft"].Light.name = "IGUI_VehiclePartATA2ProtectionWindowRearLeftLight"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearLeft"].Light.protection = {"WindowRearLeft"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearLeft"].Light.install.requireInstalled = {"WindowRearLeft"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearLeft"].Light.install.area = "TireRearLeft"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearLeft"].Light.uninstall.area = "TireRearLeft"

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearLeft"].Heavy.name = "IGUI_VehiclePartATA2ProtectionWindowRearLeftHeavy"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearLeft"].Heavy.protection = {"WindowRearLeft"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearLeft"].Heavy.ArmorWRL = true
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearLeft"].Heavy.install.requireInstalled = {"WindowRearLeft"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearLeft"].Heavy.disableOpenWindowFromSeat = "SeatRearLeft"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearLeft"].Heavy.install.area = "TireRearLeft"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearLeft"].Heavy.uninstall.area = "TireRearLeft"

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"])
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearRight"].Light.name = "IGUI_VehiclePartATA2ProtectionWindowRearRightLight"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearRight"].Light.protection = {"WindowRearRight"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearRight"].Light.install.requireInstalled = {"WindowRearRight"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearRight"].Light.install.area = "TireRearRight"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearRight"].Light.uninstall.area = "TireRearRight"

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearRight"].Heavy.name = "IGUI_VehiclePartATA2ProtectionWindowRearRightHeavy"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearRight"].Heavy.protection = {"WindowRearRight"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearRight"].Heavy.install.requireInstalled = {"WindowRearRight"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearRight"].Heavy.ArmorWRR = true
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearRight"].Heavy.disableOpenWindowFromSeat = "SeatRearRight"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearRight"].Heavy.install.area = "TireRearRight"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowRearRight"].Heavy.uninstall.area = "TireRearRight"

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowMiddleLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"])
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowMiddleLeft"].Light.name = "IGUI_VehiclePartATA2ProtectionWindowMiddleLeftLight"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowMiddleLeft"].Light.protection = {"WindowMiddleLeft"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowMiddleLeft"].Light.install.requireInstalled = {"WindowMiddleLeft"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowMiddleLeft"].Light.install.area = "TireFrontLeft"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowMiddleLeft"].Light.uninstall.area = "TireFrontLeft"

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowMiddleLeft"].Heavy.name = "IGUI_VehiclePartATA2ProtectionWindowMiddleLeftHeavy"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowMiddleLeft"].Heavy.protection = {"WindowMiddleLeft"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowMiddleLeft"].Heavy.ArmorWML = true
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowMiddleLeft"].Heavy.install.requireInstalled = {"WindowMiddleLeft"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowMiddleLeft"].Heavy.disableOpenWindowFromSeat = nil
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowMiddleLeft"].Heavy.install.area = "TireFrontLeft"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowMiddleLeft"].Heavy.uninstall.area = "TireFrontLeft"

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowMiddleRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowFrontLeft"])
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowMiddleRight"].Light.name = "IGUI_VehiclePartATA2ProtectionWindowMiddleRightLight"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowMiddleRight"].Light.protection = {"WindowMiddleRight"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowMiddleRight"].Light.install.requireInstalled = {"WindowMiddleRight"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowMiddleRight"].Light.install.area = "TireFrontRight"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowMiddleRight"].Light.uninstall.area = "TireFrontRight"

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowMiddleRight"].Heavy.name = "IGUI_VehiclePartATA2ProtectionWindowMiddleRightHeavy"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowMiddleRight"].Heavy.protection = {"WindowMiddleRight"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowMiddleRight"].Heavy.ArmorWMR = true
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowMiddleRight"].Heavy.install.requireInstalled = {"WindowMiddleRight"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowMiddleRight"].Heavy.disableOpenWindowFromSeat = nil
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowMiddleRight"].Heavy.install.area = "TireFrontRight"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindowMiddleRight"].Heavy.uninstall.area = "TireFrontRight"

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"] = {
		Light = {
			icon = "media/ui/tuning2/protection_window_windshield.png",
			name = "IGUI_VehiclePartATA2ProtectionWindshieldLight",
			category = SVUC.protectionLight,
			protection = {"Windshield"},
			protectionHealthDelta = SVUC.protectionLightHealthDelta,
			protectionTriger = SVUC.protectionHealthTriger,
			removeIfBroken = true,
			install = {
				area = "TireFrontRight",
				weight = "auto",
				use = {
					MetalPipe = 4,
					MetalBar=4,
					Screws=6,
					BlowTorch = 5,
				},
				tools = {
					bodylocation = "Base.WeldingMask",
					primary = "Base.Wrench",
					secondary = "Base.Screwdriver",
				},
				skills = {
					Mechanics = 10,
				},
				requireInstalled = {"Windshield"},
				time = SVUC.timeLight,
			},
			uninstall = {
				area = "TireFrontRight",
				animation = "ATA_IdleLeverOpenMid",
				use = {
					BlowTorch=4,
				},
				tools = {
					bodylocation = "Base.WeldingMask",
					both = "Base.Crowbar",
				},
				skills = {
					Mechanics = 10,
				},
				result = "auto",
				time = SVUC.timeLight,
			}
		}
	}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"].Heavy = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"].Light)
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"].Heavy.icon = "media/ui/tuning2/protection_window_sheet_windshield.png"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"].Heavy.name = "IGUI_VehiclePartATA2ProtectionWindshieldHeavy"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"].Heavy.ArmorWS = true
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"].Heavy.category = SVUC.protectionHeavy
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"].Heavy.protectionHealthDelta = SVUC.protectionHeavyHealthDelta
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"].Heavy.install.use = {MetalPipe = 4, SheetMetal = 2, MetalBar=4, Screws=6, BlowTorch = 5,}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"].Heavy.install.skills = {Mechanics = 10}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"].Heavy.install.time = SVUC.timeHeavy
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"].Heavy.uninstall.skills = {Mechanics = 10}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"].Heavy.uninstall.time = SVUC.timeHeavy

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshieldRear"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshield"])
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshieldRear"].Light.name = "IGUI_VehiclePartATA2ProtectionWindshieldRearLight"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshieldRear"].Light.protection = {"WindshieldRear"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshieldRear"].Light.install.requireInstalled = {"WindshieldRear"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshieldRear"].Light.install.area = "TireRearRight"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshieldRear"].Light.uninstall.area = "TireRearRight"

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshieldRear"].Heavy.name = "IGUI_VehiclePartATA2ProtectionWindshieldRearHeavy"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshieldRear"].Heavy.ArmorWSR = true
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshieldRear"].Heavy.protection = {"WindshieldRear"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshieldRear"].Heavy.install.requireInstalled = {"WindshieldRear"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshieldRear"].Heavy.install.area = "TireRearRight"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWindshieldRear"].Heavy.uninstall.area = "TireRearRight"

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"] = {
		Light = {
			icon = "media/ui/tuning2/bus_protection_window_side.png",
			name = "IGUI_VehiclePartATA2ProtectionTrunkLight",
			category = SVUC.protectionLight,
			protection = {"TruckBed", "TrunkDoor", "GasTank"},
			protectionHealthDelta = SVUC.protectionLightHealthDelta,
			protectionTriger = SVUC.protectionHealthTriger,
			removeIfBroken = true,
			install = {
				use = {
					MetalPipe = 4,
					MetalBar=4,
					Screws=6,
					BlowTorch = 5,
				},
				tools = {
					bodylocation = "Base.WeldingMask",
					primary = "Base.Wrench",
					secondary = "Base.Screwdriver",
				},
				skills = {
					Mechanics = 10,
				},
				requireInstalled = {"TruckBed"},
				time = SVUC.timeLight, 
			},
			uninstall = {
				animation = "ATA_IdleLeverOpenMid",
				use = {
					BlowTorch=4,
				},
				tools = {
					bodylocation = "Base.WeldingMask",
					both = "Base.Crowbar",
				},
				skills = {
					Mechanics = 10,
				},
				result = "auto",
				time = SVUC.timeLight,
			}
		}
	}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"].Heavy = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"].Light)
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"].Heavy.name = "IGUI_VehiclePartATA2ProtectionTrunkHeavy"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"].Heavy.ArmorTR = true
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"].Heavy.icon = "media/ui/tuning2/van_hood_protection.png"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"].Heavy.category = SVUC.protectionHeavy
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"].Heavy.protectionHealthDelta = SVUC.protectionHeavyHealthDelta
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"].Heavy.install.use = {SheetMetal = 4, MetalPipe = 4, MetalBar = 2, Screws = 6, BlowTorch = 4,}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"].Heavy.install.skills = {Mechanics = 10}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"].Heavy.install.time = SVUC.timeHeavy
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"].Heavy.uninstall.skills = {Mechanics = 10}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"].Heavy.uninstall.time = SVUC.timeHeavy

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorsRear"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"])
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorsRear"].Light.name = "IGUI_VehiclePartATA2ProtectionDoorsRearLight"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorsRear"].Light.protection = {"TruckBed", "DoorRear", "GasTank"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorsRear"].Heavy.name = "IGUI_VehiclePartATA2ProtectionDoorsRearHeavy"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorsRear"].Heavy.protection = {"TruckBed", "DoorRear", "GasTank"}

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHood"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"])
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHood"].Light.name = "IGUI_VehiclePartATA2ProtectionHoodLight"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHood"].Light.protection = {"EngineDoor"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHood"].Light.install.requireInstalled = {"EngineDoor"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHood"].Light.install.requireUninstalled = {"ATA2AirScoop"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHood"].Heavy.name = "IGUI_VehiclePartATA2ProtectionHoodHeavy"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHood"].Heavy.protection = {"EngineDoor"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHood"].Heavy.install.requireInstalled = {"EngineDoor"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHood"].Heavy.install.requireUninstalled = {"ATA2AirScoop"}

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHoodNoScoop"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionTrunk"])
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHoodNoScoop"].Light.name = "IGUI_VehiclePartATA2ProtectionHoodLight"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHoodNoScoop"].Heavy.ArmorHD = true
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHoodNoScoop"].Light.protection = {"EngineDoor"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHoodNoScoop"].Light.install.requireInstalled = {"EngineDoor"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHoodNoScoop"].Heavy.name = "IGUI_VehiclePartATA2ProtectionHoodHeavy"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHoodNoScoop"].Heavy.protection = {"EngineDoor"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionHoodNoScoop"].Heavy.install.requireInstalled = {"EngineDoor"}

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"] = {
		Light = {
			icon = "media/ui/tuning2/bus_protection_window_side.png",
			name = "IGUI_VehiclePartATA2ProtectionDoorFrontLeftLight",
			secondModel = "StaticPart",
			category = SVUC.protectionLight,
			protection = {"DoorFrontLeft"},
			protectionHealthDelta = SVUC.protectionLightHealthDelta,
			protectionTriger = SVUC.protectionHealthTriger,
			removeIfBroken = true,
			install = {
				area = "TireFrontLeft",
				weight = "auto",
				use = {
					MetalPipe = 4,
					MetalBar=4,
					Screws=6,
					BlowTorch = 5,
				},
				tools = {
					bodylocation = "Base.WeldingMask",
					primary = "Base.Wrench",
					secondary = "Base.Screwdriver",
				},
				skills = {
					Mechanics = 10,
				},
				requireInstalled = {"DoorFrontLeft"},
				time = SVUC.timeLight,
			},
			uninstall = {
				area = "TireFrontLeft",
				animation = "ATA_IdleLeverOpenMid",
				use = {
					BlowTorch=4,
				},
				tools = {
					bodylocation = "Base.WeldingMask",
					both = "Base.Crowbar",
				},
				skills = {
					Mechanics = 10,
				},
				result = "auto",
				time = SVUC.timeLight,
			}
		}
	}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"].Heavy = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"].Light)
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"].Heavy.icon = "media/ui/tuning2/van_hood_protection.png"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"].Heavy.name = "IGUI_VehiclePartATA2ProtectionDoorFrontLeftHeavy"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"].Heavy.ArmorDFL = true
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"].Heavy.category = SVUC.protectionHeavy
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"].Heavy.protectionHealthDelta = SVUC.protectionHeavyHealthDelta
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"].Heavy.install.use = {MetalPipe = 4, SheetMetal = 2, MetalBar=4, Screws=6, BlowTorch = 5,}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"].Heavy.install.skills = {Mechanics = 10}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"].Heavy.install.time = SVUC.timeHeavy
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"].Heavy.uninstall.skills = {Mechanics = 10}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"].Heavy.uninstall.time = SVUC.timeHeavy


	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"])
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontRight"].Light.name = "IGUI_VehiclePartATA2ProtectionDoorFrontRightLight"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontRight"].Light.protection = {"DoorFrontRight"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontRight"].Light.install.requireInstalled = {"DoorFrontRight"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontRight"].Light.install.area = "TireFrontRight"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontRight"].Light.uninstall.area = "TireFrontRight"

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontRight"].Heavy.protection = {"DoorFrontRight"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontRight"].Heavy.name = "IGUI_VehiclePartATA2ProtectionDoorFrontRightHeavy"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontRight"].Heavy.ArmorDFR = true
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontRight"].Heavy.install.requireInstalled = {"DoorFrontRight"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontRight"].Heavy.install.area = "TireFrontRight"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontRight"].Heavy.uninstall.area = "TireFrontRight"


	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"])
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearLeft"].Light.name = "IGUI_VehiclePartATA2ProtectionDoorRearLeftLight"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearLeft"].Light.protection = {"DoorRearLeft"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearLeft"].Light.install.requireInstalled = {"DoorRearLeft"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearLeft"].Light.install.area = "TireRearLeft"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearLeft"].Light.uninstall.area = "TireRearLeft"

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearLeft"].Heavy.protection = {"DoorRearLeft"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearLeft"].Heavy.name = "IGUI_VehiclePartATA2ProtectionDoorRearLeftHeavy"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearLeft"].Heavy.ArmorDRL = true
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearLeft"].Heavy.install.requireInstalled = {"DoorRearLeft"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearLeft"].Heavy.install.area = "TireRearLeft"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearLeft"].Heavy.uninstall.area = "TireRearLeft"


	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorMiddleLeft"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"])
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorMiddleLeft"].Light.name = "IGUI_VehiclePartATA2ProtectionDoorMiddleLeftLight"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorMiddleLeft"].Light.protection = {"DoorMiddleLeft"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorMiddleLeft"].Light.install.requireInstalled = {"DoorMiddleLeft"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorMiddleLeft"].Light.install.area = "TireFrontLeft"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorMiddleLeft"].Light.uninstall.area = "TireFrontLeft"

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorMiddleLeft"].Heavy.protection = {"DoorMiddleLeft"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorMiddleLeft"].Heavy.name = "IGUI_VehiclePartATA2ProtectionDoorMiddleLeftHeavy"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorMiddleLeft"].Heavy.ArmorDML = true
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorMiddleLeft"].Heavy.install.requireInstalled = {"DoorMiddleLeft"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorMiddleLeft"].Heavy.install.area = "TireFrontLeft"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorMiddleLeft"].Heavy.uninstall.area = "TireFrontLeft"

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorMiddleRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"])
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorMiddleRight"].Light.name = "IGUI_VehiclePartATA2ProtectionDoorMiddleRightLight"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorMiddleRight"].Light.protection = {"DoorMiddleRight"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorMiddleRight"].Light.install.requireInstalled = {"DoorMiddleRight"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorMiddleRight"].Light.install.area = "TireFrontRight"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorMiddleRight"].Light.uninstall.area = "TireFrontRight"

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorMiddleRight"].Heavy.protection = {"DoorMiddleRight"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorMiddleRight"].Heavy.name = "IGUI_VehiclePartATA2ProtectionDoorMiddleRightHeavy"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorMiddleRight"].Heavy.ArmorDMR = true
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorMiddleRight"].Heavy.install.requireInstalled = {"DoorMiddleRight"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorMiddleRight"].Heavy.install.area = "TireFrontRight"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorMiddleRight"].Heavy.uninstall.area = "TireFrontRight"

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearRight"] = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorFrontLeft"])
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearRight"].Light.name = "IGUI_VehiclePartATA2ProtectionDoorRearRightLight"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearRight"].Light.protection = {"DoorRearRight"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearRight"].Light.install.requireInstalled = {"DoorRearRight"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearRight"].Light.install.area = "TireRearRight"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearRight"].Light.uninstall.area = "TireRearRight"

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearRight"].Heavy.protection = {"DoorRearRight"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearRight"].Heavy.name = "IGUI_VehiclePartATA2ProtectionDoorRearRightHeavy"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearRight"].Heavy.ArmorDRR = true
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearRight"].Heavy.install.requireInstalled = {"DoorRearRight"}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearRight"].Heavy.install.area = "TireRearRight"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionDoorRearRight"].Heavy.uninstall.area = "TireRearRight"


	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2InteractiveTrunkRoofRack"] = {
		Default = {
			icon = "media/ui/tuning2/roof_rack_2.png",
			category = SVUC.protectionMods,
			--interactiveTrunk = {
				--filling = {"ATA_VanDeRumba_roof_bag1", "ATA_VanDeRumba_roof_bag2", "ATA_VanDeRumba_roof_bag3", "ATA_VanDeRumba_roof_bag4", "ATA_VanDeRumba_roof_bag5", "ATA_VanDeRumba_roof_bag6"},
				--items = {
					--{
						--itemTypes = {"MetalDrum"},
						--modelNameByCount = {"ATA_VanDeRumba_roof_barrel"},
					--},
					--{
						--itemTypes = {"PetrolCan", "EmptyPetrolCan"},
						--modelNameByCount = {"ATA_VanDeRumba_roof_gascan0", "ATA_VanDeRumba_roof_gascan1", "ATA_VanDeRumba_roof_gascan2", "ATA_VanDeRumba_roof_gascan3", "ATA_VanDeRumba_roof_gascan4", "ATA_VanDeRumba_roof_gascan5", "ATA_VanDeRumba_roof_gascan6", "ATA_VanDeRumba_roof_gascan7", "ATA_VanDeRumba_roof_gascan8", },
					--},
				--}
			--},
			containerCapacity = 50,
			install = {
				area = "TruckBed",
				use = {
					MetalPipe = 6,
					SheetMetal = 6,
					MetalBar=4,
					BlowTorch = 10,
					Screws=12,
				},
				tools = {
					bodylocation = "Base.WeldingMask",
					primary = "Base.Wrench",
					secondary = "Base.Screwdriver",
				},
				skills = {
					Mechanics = 10,
				},
				time = SVUC.timeMods, 
			},
			uninstall = {
				area = "TruckBed",
				animation = "ATA_IdleLeverOpenHigh",
				use = {
					BlowTorch=8,
				},
				tools = {
					bodylocation = "Base.WeldingMask",
					both = "Base.Crowbar",
				},
				skills = {
					Mechanics = 10,
				},
				result = "auto",
				time = SVUC.timeMods,
			}
		}
	}

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2RoofLightbar"] = {
		Normal = {
			icon = "media/ui/tuning2/roof_base.png",
			category = SVUC.protectionMods,
			name = "IGUI_VehiclePartATA2RoofLightbarNormal",
			spawnChance = 50,
			install = {
				area = "Engine",
				use = {
					ATA2__ATAFrontRoofLightItem = 1,
					MetalPipe = 2,
					SheetMetal = 1,
					MetalBar=2,
					Screws=6,
				},
				tools = {
					primary = "Base.Wrench",
					secondary = "Base.Screwdriver",
				},
				skills = {

					Mechanics = 10,
				},
				time = SVUC.timeMods, 
			},
			uninstall = {
				area = "Engine",
				animation = "ATA_IdleLeverOpenHigh",
				tools = {
					primary = "Base.Wrench",
					secondary = "Base.Screwdriver",
				},
				skills = {

					Mechanics = 10,
				},
				result = {
					ATA2__ATAFrontRoofLightItem = 1,
					MetalPipe = 1,
					SheetMetal = 1,
					MetalBar=1,
					Screws=2,
				},
				time = SVUC.timeMods,
			}
		}
	}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2RoofLightbar"].Box1 = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2RoofLightbar"].Normal)
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2RoofLightbar"].Box1.name = "IGUI_VehiclePartATA2RoofLightbarBox1"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2RoofLightbar"].Box1.spawnChance = 25
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2RoofLightbar"].Box2 = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2RoofLightbar"].Normal)
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2RoofLightbar"].Box2.name = "IGUI_VehiclePartATA2RoofLightbarBox2"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2RoofLightbar"].Box2.spawnChance = 50
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2RoofLightbar"].Single = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2RoofLightbar"].Normal)
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2RoofLightbar"].Single.name = "IGUI_VehiclePartATA2RoofLightbarSingle"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2RoofLightbar"].Single.spawnChance = 25
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2RoofLightbar"].Double = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2RoofLightbar"].Normal)
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2RoofLightbar"].Double.name = "IGUI_VehiclePartATA2RoofLightbarDouble"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2RoofLightbar"].Double.spawnChance = 25
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2RoofLightbar"].VShaped1 = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2RoofLightbar"].Normal)
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2RoofLightbar"].VShaped1.name = "IGUI_VehiclePartATA2RoofLightbarV1"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2RoofLightbar"].VShaped1.spawnChance = 50
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2RoofLightbar"].VShaped2 = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2RoofLightbar"].Normal)
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2RoofLightbar"].VShaped2.name = "IGUI_VehiclePartATA2RoofLightbarV2"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2RoofLightbar"].VShaped2.spawnChance = 50

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2RoofLightFront"] = {
		Default = {
			icon = "media/ui/tuning2/roof_light.png",
			modelList = {"SecondModel"},
			category = SVUC.protectionMods,
			install = {
				area = "Engine",
				transmitFirstItemCondition = true,
				use = {
					ATA2__ATAFrontRoofLightItem = 1,
					Screws=8,
				},
				tools = {
					primary = "Base.Screwdriver",
				},
				skills = {

					Mechanics = 10,
				},
				time = SVUC.timeMods,
			},
			uninstall = {
				area = "Engine",
				tools = {
					primary = "Base.Screwdriver",
				},
				skills = {

					Mechanics = 10,
				},
				transmitConditionOnFirstItem = true,
				result = {
					ATA2__ATAFrontRoofLightItem = 1,
				},
				time = SVUC.timeMods,
			}
		}
	}

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2ProtectionWheels"] = {
		ATAProtection = {
			removeIfBroken = true,
			icon = "media/ui/tuning2/wheel_chain.png",
			category = SVUC.protectionMods, 
			protectionModel = true,
			protection = {"TireFrontLeft", "TireFrontRight", "TireRearLeft", "TireRearRight"}, 
			protectionHealthDelta = SVUC.protectionWheelsHealthDelta,
			protectionTriger = SVUC.protectionHealthTriger,
			install = {
				area = "TireFrontLeft",
				sound = "ATA2InstallWheelChain",
				use = { 
					ATAProtectionWheelsChain = 1,
					BlowTorch = 4,
				},
				tools = { 
					bodylocation = "Base.WeldingMask", 
					primary = "Base.Wrench",
					secondary = "Base.Screwdriver",
				},
				skills = {

					Mechanics = 10,
				},
				requireInstalled = {"TireFrontLeft", "TireFrontRight", "TireRearLeft", "TireRearRight"},
				time = SVUC.timeWheels, 
			},
			uninstall = {
				area = "TireFrontLeft",
				sound = "ATA2InstallWheelChain",
				use = {
					BlowTorch=4,
				},
				tools = {
					bodylocation = "Base.WeldingMask",
					both = "Base.Crowbar",
				},
				skills = {

					Mechanics = 10,
				},
				result = {
					UnusableMetal=2,
				},
				time = SVUC.timeWheels,
			}
		}
	}

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"] = {
		Small = {
			icon = "media/ui/tuning2/delorean_protection_hood_bttf.png",
			category = SVUC.protectionEngineMods,
			name = "IGUI_VehiclePartATA2AirScoopSmall",
			engineUpgrade = true,
			powerIncrease = SVUC.protectionEngineSmallPowerIncrease,
			install = {
				area = "Engine",
				use = {
					MetalPipe = 6,
					SheetMetal = 2,
					MetalBar=4,
					BlowTorch = 10,
					Screws=12,
				},
				tools = {
					bodylocation = "Base.WeldingMask", 
					primary = "Base.Wrench",
					secondary = "Base.Screwdriver",
				},
				skills = {

					Mechanics = 10,
				},
				requireInstalled = {"EngineDoor"},
				requireUninstalled = {"ATA2ProtectionHood"},
				time = SVUC.timeMods,
			},
			uninstall = {
				area = "Engine",
				tools = {
					bodylocation = "Base.WeldingMask", 
					both = "Base.Crowbar",
				},
				skills = {

					MetalWelding = 10,
				},
				result = "auto",
				time = SVUC.timeMods,
				requireUninstalled = {"ATA2ProtectionHood"},
			}
		}
	}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].SmallRusted = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].Small)
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].SmallRusted.icon = "media/ui/tuning2/delorean_protection_hood_bttf.png"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].SmallRusted.name = "IGUI_VehiclePartATA2AirScoopSmallRusted"

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].Medium = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].Small)
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].Medium.icon = "media/ui/tuning2/delorean_protection_hood_bttf.png"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].Medium.name = "IGUI_VehiclePartATA2AirScoopMedium"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].Medium.powerIncrease = SVUC.protectionEngineMediumPowerIncrease
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].Medium.install.use = {MetalPipe = 6, SheetMetal = 4, MetalBar=4, BlowTorch = 10, Screws=12,}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].Medium.install.skills = {Mechanics = 10}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].Medium.uninstall.skills = {Mechanics = 10}

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].MediumRusted = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].Medium)
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].MediumRusted.icon = "media/ui/tuning2/delorean_protection_hood_bttf.png"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].MediumRusted.name = "IGUI_VehiclePartATA2AirScoopMediumRusted"

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].Large = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].Small)
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].Large.icon = "media/ui/tuning2/delorean_protection_hood_bttf.png"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].Large.name = "IGUI_VehiclePartATA2AirScoopLarge"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].Large.powerIncrease = SVUC.protectionEngineLargePowerIncrease
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].Large.install.use = {MetalPipe = 8, SheetMetal = 6, MetalBar=4, BlowTorch = 10, Screws=12,}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].Large.install.skills = { Mechanics = 10}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].Large.uninstall.skills = {Mechanics = 10}

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].LargeRusted = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].Large)
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].LargeRusted.icon = "media/ui/tuning2/delorean_protection_hood_bttf.png"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].LargeRusted.name = "IGUI_VehiclePartATA2AirScoopLargeRusted"

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].Piped = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].Small)
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].Piped.icon = "media/ui/tuning2/delorean_protection_hood_bttf.png"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].Piped.name = "IGUI_VehiclePartATA2AirScoopPiped"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].Piped.powerIncrease = SVUC.protectionEnginePipedPowerIncrease
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].Piped.install.use = {MetalPipe = 12, SheetMetal = 6, MetalBar=4, BlowTorch = 10, Screws=12,}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].Piped.install.skills = {Mechanics = 10}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].Piped.uninstall.skills = {Mechanics = 10}

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].PipedRusted = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].Piped)
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].PipedRusted.icon = "media/ui/tuning2/delorean_protection_hood_bttf.png"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].PipedRusted.name = "IGUI_VehiclePartATA2AirScoopPipedRusted"

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].SmallRound = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].Small)
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].SmallRound.icon = "media/ui/tuning2/delorean_protection_hood_bttf.png"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].SmallRound.name = "IGUI_VehiclePartATA2AirScoopSmallRound"

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].SmallRoundRusted = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].SmallRound)
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].SmallRoundRusted.icon = "media/ui/tuning2/delorean_protection_hood_bttf.png"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].SmallRoundRusted.name = "IGUI_VehiclePartATA2AirScoopSmallRoundRusted"

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].LargeRound = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].Large)
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].LargeRound.icon = "media/ui/tuning2/delorean_protection_hood_bttf.png"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].LargeRound.name = "IGUI_VehiclePartATA2AirScoopLargeRound"

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].LargeRoundRusted = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].LargeRound)
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].LargeRoundRusted.icon = "media/ui/tuning2/delorean_protection_hood_bttf.png"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].LargeRoundRusted.name = "IGUI_VehiclePartATA2AirScoopLargeRoundRusted"

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2Snorkel"] = {}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2Snorkel"].SnorkelLeft = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2AirScoop"].Small)
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2Snorkel"].SnorkelLeft.icon = "media/ui/tuning2/snorkel.png"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2Snorkel"].SnorkelLeft.name = "IGUI_VehiclePartATA2SnorkelLeft"
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2Snorkel"].SnorkelLeft.powerIncrease = SVUC.protectionEngineSnorkelPowerIncrease
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2Snorkel"].SnorkelLeft.install.requireUninstalled = {}
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2Snorkel"].SnorkelLeft.uninstall.requireUninstalled = {}

	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2Snorkel"].SnorkelRight = copy(TemplateTuningTable["TemplateVehicleFR"].parts["ATA2Snorkel"].SnorkelLeft)
	TemplateTuningTable["TemplateVehicleFR"].parts["ATA2Snorkel"].SnorkelRight.name = "IGUI_VehiclePartATA2SnorkelRight"

	return TemplateTuningTable
end
Events.OnInitGlobalModData.Add(SVUC_TemplateVehicleFR)


function SVUC2_setVehiclePickup(tuningtable, vehicle)
	tuningtable[vehicle].parts["ATA2ProtectionTrunk"].Light.protection = {"TruckBedOpen", "GasTank"}
	tuningtable[vehicle].parts["ATA2ProtectionTrunk"].Heavy.protection = {"TruckBedOpen", "GasTank"}
end
function SVUC2_setVehiclePickupTruck(tuningtable, vehicle)
	tuningtable[vehicle].parts["ATA2ProtectionDoorsRear"].Light.protection = {"TruckBedOpen", "GasTank"}
	tuningtable[vehicle].parts["ATA2ProtectionDoorsRear"].Heavy.protection = {"TruckBedOpen", "GasTank"}

end
function SVUC2_setVehiclePickupTrunkDoor(tuningtable, vehicle)
	tuningtable[vehicle].parts["ATA2ProtectionTrunk"].Light.protection = {"TrunkDoor", "TruckBedOpen", "GasTank"}
	tuningtable[vehicle].parts["ATA2ProtectionTrunk"].Heavy.protection = {"TrunkDoor", "TruckBedOpen", "GasTank"}

end
function SVUC2_setVehiclePickupDoorsRear(tuningtable, vehicle)
	tuningtable[vehicle].parts["ATA2ProtectionDoorsRear"].Light.protection = {"DoorRear", "TruckBedOpen", "GasTank"}
	tuningtable[vehicle].parts["ATA2ProtectionDoorsRear"].Heavy.protection = {"DoorRear", "TruckBedOpen", "GasTank"}

end
function SVUC2_setVehicleRecipesArmor(tuningtable, carRecipe, vehicle, part)
	tuningtable[vehicle].parts[part].Light.install.recipes = {carRecipe}
	tuningtable[vehicle].parts[part].Heavy.install.recipes = {carRecipe}
end
function SVUC2_setVehicleRecipesArmorHood(tuningtable, carRecipe, vehicle, part)
	tuningtable[vehicle].parts[part].Light.install.recipes = {carRecipe}
	tuningtable[vehicle].parts[part].Heavy.install.recipes = {carRecipe}
end
function SVUC2_setVehicleRecipesBullbars(tuningtable, carRecipe, vehicle, part)
	tuningtable[vehicle].parts[part].Small.install.recipes = {carRecipe}
end
function SVUC2_setVehicleRecipesBullbarsTruck(tuningtable, carRecipe, vehicle, part)
	tuningtable[vehicle].parts[part].Small.install.recipes = {carRecipe}
end
function SVUC2_setVehicleRecipesMods(tuningtable, carRecipe, vehicle, part)
	tuningtable[vehicle].parts[part].Default.install.recipes = {carRecipe}
end
function SVUC2_setVehicleRecipesWheels(tuningtable, carRecipe, vehicle, part)
	tuningtable[vehicle].parts[part].ATAProtection.install.recipes = {carRecipe}
end
function SVUC2_setVehicleRecipesScoops(tuningtable, carRecipe, vehicle, part)
	tuningtable[vehicle].parts[part].None.install.recipes = {carRecipe}

end
function SVUC2_setVehicleRecipesSnorkels(tuningtable, carRecipe, vehicle, part)
	tuningtable[vehicle].parts[part].SnorkelNone.install.recipes = {carRecipe}

end
function SVUC2_setVehicleRecipesRoofLightbar(tuningtable, carRecipe, vehicle, part)
	tuningtable[vehicle].parts[part].Normal.install.recipes = {carRecipe}
	tuningtable[vehicle].parts[part].Box1.install.recipes = {carRecipe}
	tuningtable[vehicle].parts[part].Box2.install.recipes = {carRecipe}
	tuningtable[vehicle].parts[part].Single.install.recipes = {carRecipe}
	tuningtable[vehicle].parts[part].Double.install.recipes = {carRecipe}
	tuningtable[vehicle].parts[part].VShaped1.install.recipes = {carRecipe}
	tuningtable[vehicle].parts[part].VShaped2.install.recipes = {carRecipe}
end
