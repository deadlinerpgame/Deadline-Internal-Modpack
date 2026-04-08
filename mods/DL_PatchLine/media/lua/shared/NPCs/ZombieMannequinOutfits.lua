require 'NPCs/ZombiesZoneDefinition'


AZ_ZombiesZoneDefinition = ZombiesZoneDefinition or {};

-- name of the zone for the zone type ZombiesType (in worldzed)

ZombiesZoneDefinition.MannequinB = {
	MannequinB = {
		name="MannequinB",
		chance=0,
	},
}

ZombiesZoneDefinition.MannequinW = {
	MannequinW = {
		name="MannequinW",
		chance=0,
	},
}

ZombiesZoneDefinition.MannequinG = {
	MannequinG = {
		name="MannequinG",
		chance=2,
		gender="male",		
	},
}

ZombiesZoneDefinition.MannequinS = {
	MannequinS = {
		name="MannequinS",
		chance=0,
		gender="male",		
	},
}
