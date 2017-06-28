return {
	corartic = {
		acceleration = 2.25/30,
		activatewhenbuilt = true,
		brakerate = 2.25/60,
		buildangle = 16384,
		buildcostenergy = 3840,
		buildcostmetal = 480,
		buildpic = "CORARTIC.DDS",
		buildtime = 9000*0.8,
		canmove = true,
		category = "ALL WEAPON SHIP NOTSUB NOTAIR NOTHOVER SURFACE CORVETTE",
		collisionvolumeoffsets = "0 -3 -1",
		collisionvolumescales = "21 21 59",
		collisionvolumetype = "CylZ",
		corpse = "DEAD",
		description = "Artillery Corvette (Good vs Buildings)",
		energymake = 3,
		explodeas = "mediumexplosiongeneric",
		floater = true,
		footprintx = 1,
		footprintz = 3,
		icontype = "sea",
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 950,
		maxvelocity = 2.25,
		minwaterdepth = 12,
		movementclass = "BOATCORVETTE1X3",
		name = "Artic",
		nochasecategory = "UNDERWATER VTOL",
		objectname = "CORARTIC",
		seismicsignature = 0,
		selfdestructas = "mediumExplosionGenericSelfd",
		sightdistance = 0.8 *800,
		turninplace = true,
		turninplaceanglelimit = 10,
		turninplacespeedlimit = 2.145,
		turnrate = 520,
		waterline = 3,
		customparams = {
			
		},
		featuredefs = {
			dead = {
				blocking = false,
				category = "corpses",
				collisionvolumeoffsets = "2.05702972412 -6.65740128174 -1.55792999268",
				collisionvolumescales = "37.2419281006 12.2129974365 67.4956207275",
				collisionvolumetype = "Box",
				damage = 150,
				description = "Artic Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 1,
				footprintz = 3,
				height = 20,
				hitdensity = 100,
				metal = 120,
				object = "CORESUPP_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 250,
				description = "Artic Heap",
				energy = 0,
				footprintx = 4,
				footprintz = 4,
				height = 4,
				hitdensity = 100,
				metal = 60,
				object = "4X4B",
                collisionvolumescales = "85.0 14.0 6.0",
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
			artillery = {
				areaofeffect = 92,
				accuracy = 2048,
				avoidfeature = false,
				craterareaofeffect = 92,
				craterboost = 0,
				cratermult = 0,
				cegTag = "missiletrailcorroyspecial",
				explosiongenerator = "custom:genericshellexplosion-large",
				gravityaffected = "true",
				impulseboost = 0.123,
				impulsefactor = 0.123,
				name = "MediumPlasmaCannon",
				noselfdamage = true,
				range = 0.8 * 1200,
				reloadtime = 8,
				soundhit = "xplomed2",
				soundhitwet = "splssml",
				soundhitwetvolume = 0.5,
				soundstart = "cannhvy1",
				turret = true,
				sizedecay = 0,
				model = "bomb2",
				alphadecay = 0.5,
				separation = 1.0,
				nogap = false,
				stages = 0,
				weapontype = "Cannon",
				weaponvelocity = 320,
				damage = {
					bombers = 45*3,
					default = 390,
					fighters = 45*3,
					subs = 5*3,
					vtol = 45*3,
					scouts = 90*3,
					corvettes = 65*3,
					destroyers = 130*3,
					cruisers = 130*3,
					carriers = 130*3,
					flagships = 130*3,
					battleships = 130*3,
				},
			},
		},
		weapons = {
			[1] = {
				def = "ARTILLERY",
				maindir = "0 0 1",
				maxangledif = 160,
				onlytargetcategory = "NOTSUB",
			},
		},
	},
}
