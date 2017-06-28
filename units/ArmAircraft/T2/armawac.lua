return {
	armawac = {
		acceleration = 0.114,
		brakerate = 0.05,
		buildcostenergy = 8600,
		buildcostmetal = 180,
		buildpic = "ARMAWAC.DDS",
		buildtime = 12819,
		canfly = true,
		canmove = true,
		category = "ALL ANTIEMG NOTLAND MOBILE NOTSUB ANTIFLAME ANTILASER VTOL NOWEAPON NOTSHIP NOTHOVER",
		collide = false,
		cruisealt = 160,
		description = "Radar/Sonar Plane",
		energymake = 23,
		energyuse = 23,
		explodeas = "mediumexplosiongeneric",
		footprintx = 3,
		footprintz = 3,
		icontype = "air",
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 800,
		maxslope = 10,
		maxvelocity = 10.58,
		maxwaterdepth = 0,
		name = "Eagle",
		objectname = "ARMAWAC",
		radardistance = 2500,
		seismicsignature = 0,
		selfdestructas = "mediumExplosionGenericSelfd",
		sightdistance = 1275,
		sonardistance = 1200,
		turnrate = 392,
		blocking = false,
		customparams = {
			
		},
		sfxtypes = { 
 			pieceExplosionGenerators = { 
				"deathceg3",
				"deathceg4",
				"deathceg2",
			},
		},
		sounds = {
			canceldestruct = "cancel2",
			underattack = "warning1",
			cant = {
				[1] = "cantdo4",
			},
			count = {
				[1] = "count6",
				[2] = "count5",
				[3] = "count4",
				[4] = "count3",
				[5] = "count2",
				[6] = "count1",
			},
			ok = {
				[1] = "vtolarmv",
			},
			select = {
				[1] = "aaradsel",
			},
		},
	},
}
