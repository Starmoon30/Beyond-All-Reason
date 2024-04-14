return {
	corenaa = {
		maxacc = 0,
		activatewhenbuilt = true,
		airsightdistance = 1000,
		maxdec = 0,
		buildangle = 16384,
		energycost = 25000,
		metalcost = 890,
		buildpic = "CORENAA.DDS",
		buildtime = 23100,
		canrepeat = false,
		category = "ALL WEAPON NOTSUB NOTAIR NOTHOVER SURFACE EMPABLE",
		collisionvolumeoffsets = "0 -10 0",
		collisionvolumescales = "42 44 42",
		collisionvolumetype = "CylY",
		corpse = "DEAD",
		energyupkeep = 0.1,
		explodeas = "largeexplosiongeneric",
		footprintx = 4,
		footprintz = 4,
		idleautoheal = 5,
		idletime = 1800,
		health = 2000,
		minwaterdepth = 2,
		objectname = "Units/CORENAA.s3o",
		script = "Units/CORENAA.cob",
		seismicsignature = 0,
		selfdestructas = "largeExplosionGenericSelfd",
		sightdistance = 550,
		waterline = 0.3,
		yardmap = "wwwwwwwwwwwwwwww",
		customparams = {
			unitgroup = 'aa',
			model_author = "Mr Bob",
			normaltex = "unittextures/cor_normal.dds",
			removewait = true,
			subfolder = "corbuildings/seadefence",
			techlevel = 2,
		},
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				collisionvolumeoffsets = "0.0857467651367 -0.0243953491211 7.02119445801",
				collisionvolumescales = "34.8984832764 33.2414093018 54.6983947754",
				collisionvolumetype = "Box",
				damage = 1092,
				footprintx = 1,
				footprintz = 1,
				height = 20,
				metal = 541,
				object = "Units/corenaa_dead.s3o",
				reclaimable = true,
			},
		},
		sfxtypes = {
			explosiongenerators = {
				[1] = "custom:barrelshot-medium-aa",
			},
			pieceexplosiongenerators = {
				[1] = "deathceg2",
				[2] = "deathceg3",
				[3] = "deathceg4",
			},
		},
		sounds = {
			canceldestruct = "cancel2",
			cloak = "kloak1",
			uncloak = "kloak1un",
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
				[1] = "twrturn3",
			},
			select = {
				[1] = "twrturn3",
			},
		},
		weapondefs = {
			armflak_gun = {
				accuracy = 1000,
				areaofeffect = 192,
				avoidfeature = false,
				avoidfriendly = false,
				burnblow = true,
				cegtag = "flaktrailaa",
				canattackground = false,
				collidefriendly = false,
				craterareaofeffect = 192,
				craterboost = 0,
				cratermult = 0,
				cylindertargeting = 1,
				edgeeffectiveness = 1,
				explosiongenerator = "custom:flak",
				gravityaffected = "true",
				impulseboost = 0,
				impulsefactor = 0,
				mygravity = 0.01,
				name = "Heavy g2a flak cannon",
				noselfdamage = true,
				predictboost = 1,
				range = 775,
				reloadtime = 0.53333,
				size = 4.5,
				sizedecay = 0.08,
				soundhit = "flakhit2",
				soundhitwet = "splslrg",
				soundstart = "flakfire",
				stages = 8,
				turret = true,
				weapontimer = 1,
				weapontype = "Cannon",
				weaponvelocity = 2450,
				damage = {
					vtol = 250,
				},
				rgbcolor = {
					[1] = 1,
					[2] = 0.33,
					[3] = 0.7,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "NOTAIR LIGHTAIRSCOUT",
				def = "ARMFLAK_GUN",
				onlytargetcategory = "VTOL",
			},
		},
	},
}
