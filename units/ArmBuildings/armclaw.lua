return {
	armclaw = {
		acceleration = 0,
		buildangle = 8192,
		buildcostenergy = 1600,
		buildcostmetal = 340,
		buildinggrounddecaldecayspeed = 30,
		buildinggrounddecalsizex = 4,
		buildinggrounddecalsizey = 4,
		buildinggrounddecaltype = "armclaw_aoplane.dds",
		buildpic = "ARMCLAW.DDS",
		buildtime = 4638,
		category = "ALL NOTLAND WEAPON NOTSUB NOTSHIP NOTAIR NOTHOVER SURFACE",
		corpse = "DEAD",
		damagemodifier = 0.25,
		description = "Pop-up Lightning Turret",
		energystorage = 15,
		explodeas = "tinyBuildingexplosiongeneric",
		footprintx = 2,
		footprintz = 2,
		hidedamage = true,
		icontype = "building",
		idleautoheal = 10,
		idletime = 900,
		levelground = false,
		mass = 10000000000,
		maxdamage = 1200,
		maxslope = 18,
		maxwaterdepth = 0,
		name = "Dragon's Claw",
		nochasecategory = "MOBILE",
		objectname = "ARMCLAW",
		radardistancejam = 8,
		seismicsignature = 0,
		selfdestructas = "tinyBuildingExplosionGenericSelfd",
		sightdistance = 440,
		stealth = true,
		turnrate = 0,
		upright = true,
		usebuildinggrounddecal = true,
		customparams = {
			
		},
		featuredefs = {
			dead = {
				autoreclaimable = 0,
				blocking = true,
				category = "corpses",
				collisionvolumeoffsets = "0.0 2.37060546837e-06 -0.0625",
				collisionvolumescales = "32.0 17.7499847412 31.375",
				collisionvolumetype = "Box",
				damage = 540,
				description = "Dragon's Claw Wreckage",
				energy = 0,
				featuredead = "ROCKTEETH",
				featurereclamate = "SMUDGE01",
				footprintx = 2,
				footprintz = 2,
				height = 20,
				hitdensity = 100,
				metal = 205,
				object = "ARMDRAG",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			rockteeth = {
				animating = 0,
				animtrans = 0,
				blocking = false,
				category = "heaps",
				damage = 500,
				description = "Rubble",
				footprintx = 2,
				footprintz = 2,
				height = 20,
				hitdensity = 100,
				metal = 2,
				object = "2X2A",
                collisionvolumescales = "35.0 4.0 6.0",
                collisionvolumetype = "cylY",
				reclaimable = true,
				resurrectable = 0,
				shadtrans = 1,
				world = "greenworld",
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
				[1] = "servmed2",
			},
			select = {
				[1] = "servmed2",
			},
		},
		weapondefs = {
			dclaw = {
				areaofeffect = 8,
				avoidfeature = false,
				beamttl = 10,
				craterareaofeffect = 0,
				craterboost = 0,
				cratermult = 0,
				duration = 8,
				explosiongenerator = "custom:genericshellexplosion-medium-lightning",
				firestarter = 50,
				impactonly = 1,
				impulseboost = 0,
				impulsefactor = 0,
				name = "LightningGun",
				noselfdamage = true,
				range = 440,
				reloadtime = 1.15,
				rgbcolor = ".2 .5 .9",
				rgbcolor2 = "0 0 1",
				soundhit = "lashit",
				soundhitwet = "sizzle",
				soundhitwetvolume = 0.5,
				soundstart = "lghthvy1",
				soundtrigger = true,
				turret = true,
				weapontype = "LightningCannon",
				weaponvelocity = 450,
				damage = {
					bombers = 25,
					commanders = 390,
					default = 210,
					fighters = 25,
					subs = 3,
					vtol = 25,
				},
			},
		},
		weapons = {
			[1] = {
				def = "DCLAW",
				onlytargetcategory = "SURFACE",
			},
		},
	},
}
