return {
	armch = {
		acceleration = 0.144,
		brakerate = 0.45,
		buildcostenergy = 2700,
		buildcostmetal = 150,
		builddistance = 112,
		builder = true,
		shownanospray = false,
		buildpic = "ARMCH.DDS",
		buildtime = 4472,
		canmove = true,
		category = "ALL HOVER MOBILE NOTSUB NOWEAPON NOTSHIP NOTAIR SURFACE",
		collisionvolumeoffsets = "0 0 0",
		collisionvolumescales = "31 12 31",
		collisionvolumetype = "CylY",
		corpse = "DEAD",
		description = "Tech Level 1",
		energymake = 11,
		energystorage = 75,
		energyuse = 11,
		explodeas = "smallexplosiongeneric",
		footprintx = 3,
		footprintz = 3,
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 1296,
		maxslope = 16,
		maxvelocity = 2.53,
		maxwaterdepth = 0,
		metalmake = 0.11,
		metalstorage = 75,
		movementclass = "HOVER3",
		name = "Construction Hovercraft",
		objectname = "ARMCH",
		radardistance = 50,
		seismicsignature = 0,
		selfdestructas = "smallExplosionGenericSelfd",
		sightdistance = 351,
		terraformspeed = 550,
		turninplace = 1,
		turninplaceanglelimit = 60,
		turninplacespeedlimit = 1.6698,
		turnrate = 425,
		workertime = 150,
		buildoptions = {
			[1] = "armsolar",
			[2] = "armadvsol",
			[3] = "armwin",
			[4] = "armgeo",
			[5] = "armmstor",
			[6] = "armestor",
			[7] = "armmex",
			[8] = "armamex",
			[9] = "armmakr",
			[10] = "armlab",
			[11] = "armvp",
			[12] = "armap",
			[13] = "armhp",
			[14] = "armnanotc",
			[15] = "armeyes",
			[16] = "armrad",
			[17] = "armdrag",
			[18] = "armclaw",
			[19] = "armllt",
			[20] = "armbeamer",
			[21] = "armhlt",
			[22] = "armguard",
			[23] = "armrl",
			[24] = "packo",
			[25] = "armcir",
			[26] = "armdl",
			[27] = "armjamt",
			[28] = "ajuno",
			[29] = "armfhp",
			[30] = "armsy",
			[31] = "armtide",
			[32] = "armuwmex",
			[33] = "armfmkr",
			[34] = "armuwms",
			[35] = "armuwes",
			[36] = "asubpen",
			[37] = "armsonar",
			[38] = "armfdrag",
			[39] = "armfrad",
			[40] = "armgplat",
			[41] = "armfhlt",
			[42] = "armfrt",
			[43] = "armtl",
			[44] = "armcube",
		},
		customparams = {
			
			area_mex_def = "armmex",
		},
		featuredefs = {
			dead = {
				blocking = false,
				category = "corpses",
				collisionvolumeoffsets = "0.0 -1.56249816895 0.0184326171875",
				collisionvolumescales = "24.4295043945 10.1600036621 29.846862793",
				collisionvolumetype = "Box",
				damage = 778,
				description = "Construction Hovercraft Wreckage",
				energy = 0,
				featuredead = "HEAP",
				footprintx = 3,
				footprintz = 3,
				height = 20,
				hitdensity = 100,
				metal = 88,
				object = "ARMCH_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 389,
				description = "Construction Hovercraft Heap",
				energy = 0,
				footprintx = 3,
				footprintz = 3,
				height = 4,
				hitdensity = 100,
				metal = 35,
				object = "3X3A",
                collisionvolumescales = "55.0 4.0 6.0",
                collisionvolumetype = "cylY",
				reclaimable = true,
				resurrectable = 0,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
		},
		sfxtypes = { 
 			pieceExplosionGenerators = { 
				"deathceg2",
				"deathceg3",
				"deathceg4",
			},
		},
		sounds = {
			build = "nanlath1",
			canceldestruct = "cancel2",
			repair = "repair1",
			underattack = "warning1",
			working = "reclaim1",
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
				[1] = "hovmdok1",
			},
			select = {
				[1] = "hovmdsl1",
			},
		},
	},
}
