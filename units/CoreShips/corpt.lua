return {
	corpt = {
		acceleration = 4.88*0.9/15,
		autoheal = 1.5,
		brakerate = 4.88*0.9/15,
		buildcostenergy = 350,
		buildcostmetal = 70,
		buildpic = "CORPT.DDS",
		buildtime = 1470*0.8,
		blocking = true,
		canmove = true,
		category = "ALL MOBILE WEAPON NOTLAND SHIP NOTSUB NOTAIR NOTHOVER SURFACE LIGHTBOAT",
		collisionvolumeoffsets = "0 -4 0",
		collisionvolumescales = "16 16 48",
		collisionvolumetype = "CylZ",
		corpse = "DEAD",
		description = "Attack Boat (Good vs Light Boats)",
		energymake = 0.23,
		energyuse = 0.23,
		explodeas = "smallExplosionGeneric",
		floater = true,
		footprintx = 1,
		footprintz = 3,
		icontype = "sea",
		idleautoheal = 5,
		idletime = 900,
		maxdamage = 300,
		maxvelocity = 4.88*0.9,
		minwaterdepth = 6,
		movementclass = "BOATLIGHTBOAT",
		name = "Searcher",
		nochasecategory = "VTOL UNDERWATER",
		objectname = "CORPT",
		seismicsignature = 0,
		selfdestructas = "smallExplosionGenericSelfd",
		sightdistance = 0.8 *600,
		turninplace = true,
		turninplaceanglelimit = 16,
		turninplacespeedlimit = 3.4914,
		turnrate = 720,
		waterline = 1.5,
		customparams = {
			
		},
		featuredefs = {
			dead = {
				blocking = false,
				category = "corpses",
				collisionvolumeoffsets = "-3.69921112061 1.72119140629e-06 -0.0",
				collisionvolumescales = "32.8984222412 14.8354034424 64.0",
				collisionvolumetype = "Box",
				damage = 250,
				description = "Searcher Wreckage",
				energy = 0,
				featuredead = "HEAP",
				footprintx = 2,
				footprintz = 2,
				height = 4,
				hitdensity = 100,
				metal = 35,
				object = "CORPT_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 716,
				description = "Searcher Heap",
				energy = 0,
				footprintx = 3,
				footprintz = 3,
				height = 4,
				hitdensity = 100,
				metal = 17,
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
				[1] = "shcormov",
			},
			select = {
				[1] = "shcorsel",
			},
		},
		weapondefs = {
			corpt_kine = {
				accuracy = 128,
				areaofeffect = 8,
				avoidfeature = false,
				sizedecay = 0.1,
				alphadecay = 0.5,
				burst = 2,
				burstrate = 0.1,
				projectiles = 1,
				craterareaofeffect = 0,
				craterboost = 0,
				cratermult = 0,
				explosiongenerator = "custom:plasmahit-small",
				impulseboost = 0.123,
				impulsefactor = 0.123,
				name = "HeavyPlasmaCannon",
				noselfdamage = true,
				range = 0.8 * 320,
				reloadtime = 0.6,
				soundhit = "xplomed2",
				soundhitwet = "splshbig",
				soundhitwetvolume = 0.5,
				soundstart = "",
				targetmoveerror = 0.1,
				turret = true,
				size = 1.5,
				tolerance = 5000,
				firetolerance = 500,
				weapontype = "Cannon",
				weaponvelocity = 500,
				separation = 1.0,
				nogap = false,
				stages = 20,
				damage = {
					bombers = 1,
					default = 13,
					fighters = 1,
					subs = 1,
					vtol = 1,
					scouts = 20,
					corvettes = 13,
					destroyers = 2,
					cruisers = 2,
					carriers = 2,
					flagships = 2,
					battleships = 2,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "LIGHTAIRSCOUT CORVETTE CAPITALSHIP",
				def = "CORPT_KINE",
				onlytargetcategory = "NOTSUB",
			},

		},
	},
}
