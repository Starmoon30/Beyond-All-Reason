
return {
	legcomlvl3 = {
		maxacc = 0.18,
		activatewhenbuilt = true,
		autoheal = 5,
		maxdec = 1.125,
		energycost = 40000,
		metalcost = 4000,
		builddistance = 175,
		builder = true,
		buildpic = "LEGCOM.DDS",
		buildtime = 150000,
		cancapture = true,
		cancloak = true,
		cloakcost = 100,
		cloakcostmoving = 1000,
		canmanualfire = true,
		canmove = true,
		capturable = false,
		capturespeed = 1800,
		category = "ALL WEAPON NOTSUB COMMANDER NOTSHIP NOTAIR NOTHOVER SURFACE CANBEUW EMPABLE",
		collisionvolumeoffsets = "0 3 0",
		collisionvolumescales = "34 63 34",
		collisionvolumetype = "CylY",
		corpse = "DEAD",
		energymake = 75,
		energystorage = 500,
		explodeas = "commanderExplosion",
		footprintx = 2,
		footprintz = 2,
		hidedamage = true,
    	holdsteady = true,
		idleautoheal = 5,
		idletime = 1800,
		sightemitheight = 40,
		mass = 4900,
		health = 8000,
		maxslope = 20,
		speed = 37.5,
		maxwaterdepth = 35,
		metalmake = 5,
		metalstorage = 500,
		mincloakdistance = 50,
		movementclass = "COMMANDERBOT",
		nochasecategory = "ALL",
		objectname = "Units/LEGCOMLVL3.s3o",
		pushresistant = true,
		radardistance = 900,
		radaremitheight = 49,
		reclaimable = false,
   		releaseheld  = true,
		script = "Units/legcomlvl3.cob",
		seismicsignature = 0,
		selfdestructas = "commanderexplosion",
		selfdestructcountdown = 5,
		showplayername = true,
		sightdistance = 550,
		sonardistance = 550,
		terraformspeed = 1500,
		turninplaceanglelimit = 140,
		turninplacespeedlimit = 0.825,
		turnrate = 1148,
		upright = true,
		workertime = 400,
		buildoptions = {
			[1] = "legmex",
			[2] = "legsolar",
			[3] = "legwin",
			[4] = "legadvsol",
			[5] = "legeconv",
			[6] = "legmext15",
			[7] = "corgeo",
			[8] = "legtide",
			[9] = "corestor",
			[10] = "legmstor",
			[11] = "coruwes",
			[12] = "legfmkr",
			[13] = "coruwms",
			[14] = "coruwgeo",
			[15] = "leggat",
			[16] = "legbar",
			[17] = "legkark",
			[18] = "legcen",
			[19] = "leginfestor",
			[20] = "legrail",
			[21] = "legmg",
			[22] = "cortl",
			[23] = "leghive",
			[24] = "legdtr",
			--[25] = "legdtf",
			--[26] = "legdtm",
			[27] = "legrl",
			[28] = "corjuno",
			[29] = "cordl",
			[30] = "corfrt",
			[31] = "coreyes",
			[32] = "corvoyr",
			[33] = "corspec",
			[34] = "legdrag",
			[35] = "legrad",
			[36] = "corfrad",
            [37] = "legstronghold",
			[38] = "corfdrag",
			[39] = "leglab",
			[40] = "legvp",
			[41] = "legap",
			[42] = "corsy",
			[43] = "leghp",
			[44] = "legfhp",
			[45] = "cornanotc",
			[46] = "cornanotcplat",
		},
		customparams = {
			unitgroup = 'builder',
			iscommander = true,
			effigy_offset = 1,
			evocomlvl = 3,
			model_author = "FireStorm",
			normaltex = "unittextures/Arm_normal.dds",
			paralyzemultiplier = 0.025,
			subfolder = "",
			workertimeboost = 3,
			wtboostunittype = "MOBILE",
			evolution_health_transfer = "percentage",
			evolution_target = "legcomlvl4",
			evolution_condition = "timer",
			evolution_timer = 99999,
			evolution_power_threshold = 53000,
			evolution_power_multiplier = 1,
			combatradius = 0,
			inheritxpratemultiplier = 0.25,
			childreninheritxp = "DRONE BOTCANNON",
			parentsinheritxp = "MOBILEBUILT DRONE BOTCANNON",
			effigy = "comeffigylvl2",
			minimum_respawn_stun = 5,
			distance_stun_multiplier = 1,
			fall_damage_multiplier = 5,--this ensures commander dies when it hits the ground so effigies can trigger respawn.
		},
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				collisionvolumeoffsets = "0 0 0",
				collisionvolumescales = "47 10 47",
				collisionvolumetype = "CylY",
				damage = 10000,
				featuredead = "HEAP",
				footprintx = 2,
				footprintz = 2,
				height = 20,
				metal = 2750,
				object = 'Units/armcom_dead.s3o',
				reclaimable = true,
			},
			heap = {
				blocking = false,
				category = "heaps",
				collisionvolumescales = "35.0 4.0 6.0",
				collisionvolumetype = "cylY",
				damage = 5000,
				footprintx = 2,
				footprintz = 2,
				height = 4,
				metal = 1375,
				object = "Units/arm2X2F.s3o",
				reclaimable = true,
				resurrectable = 0,
			},
		},
		sfxtypes = {
			explosiongenerators = {
				[1] = "custom:com_sea_laser_bubbles",
				[2] = "custom:barrelshot-medium",
				[3] = "custom:footstep-medium",
				[4] = "custom:barrelshot-tiny",
			},
			pieceexplosiongenerators = {
				[1] = "deathceg3",
				[2] = "deathceg4",
			},
		},
		sounds = {
			build = "nanlath1",
			canceldestruct = "cancel2",
			capture = "capture1",
			cloak = "kloak1",
			repair = "repair1",
			uncloak = "kloak1un",
			underattack = "warning2",
			unitcomplete = "armcomsel",
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
				[1] = "armcom1",
				[2] = "armcom2",
				[3] = "armcom3",
				[4] = "armcom4",
			},
			select = {
				[1] = "armcomsel",
			},
		},
		weapondefs = {
			armmg_weapon = {
				accuracy = 7,
				areaofeffect = 16,
				avoidfeature = false,
				burst = 6,
				burstrate = 0.0675,
				burnblow = false,
				craterareaofeffect = 0,
				craterboost = 0,
				cratermult = 0,
				duration = 0.035,
				edgeeffectiveness = 0.85,
				explosiongenerator = "custom:plasmahit-sparkonly",
				fallOffRate = 0.2,
				firestarter = 0,
				impulseboost = 0.4,
				impulsefactor = 1.5,
				intensity = 0.8,
				minintensity = 1,
				name = "Rapid-fire a2g machine guns",
				noselfdamage = true,
				ownerExpAccWeight = 4.0,
				range = 350,
				reloadtime = 0.4,
				rgbcolor = "1 0.95 0.4",
				soundhit = "bimpact3",
				soundhitwet = "splshbig",
				soundstart = "minigun3",
				soundstartvolume = 6,
				sprayangle = 968,
				thickness = 1.15,
				tolerance = 6000,
				turret = true,
				weapontype = "LaserCannon",
				weaponvelocity = 921,
				damage = {
					default = 45,
				},
			},
			torpedo = {
				areaofeffect = 16,
				avoidfeature = false,
				avoidfriendly = true,
				burnblow = true,
				cegtag = "torpedotrail-tiny",
				collidefriendly = true,
				craterareaofeffect = 0,
				craterboost = 0,
				cratermult = 0,
				edgeeffectiveness = 0.55,
				explosiongenerator = "custom:genericshellexplosion-small-uw",
				flighttime = 1.8,
				impulseboost = 0.123,
				impulsefactor = 0.123,
				model = "cortorpedo.s3o",
				name = "Level1TorpedoLauncher",
				noselfdamage = true,
				predictboost = 1,
				range = 500,
				reloadtime = 1.2,
				soundhit = "xplodep2",
				soundstart = "torpedo1",
				startvelocity = 230,
				tracks = false,
				turnrate = 2500,
				turret = true,
				waterweapon = true,
				weaponacceleration = 50,
				weapontimer = 3,
				weapontype = "TorpedoLauncher",
				weaponvelocity = 425,
				damage = {
					default = 250,
					subs = 125,
				},
			},
			ferret_missile = {
				areaofeffect = 16,
				avoidfeature = false,
				burnblow = true,
				canattackground = false,
				cegtag = "missiletrailaa",
				craterareaofeffect = 0,
				craterboost = 0,
				cratermult = 0,
				edgeeffectiveness = 0.15,
				energypershot = 0,
				explosiongenerator = "custom:genericshellexplosion-tiny-aa",
				firestarter = 72,
				flighttime = 2.5,
				impulseboost = 0.123,
				impulsefactor = 0.123,
				metalpershot = 0,
				model = "cormissile.s3o",
				name = "Pop-up rapid-fire g2a missile launcher",
				noselfdamage = true,
				range = 400,
				reloadtime = 1.2,
				smoketrail = true,
				smokePeriod = 6,
				smoketime = 12,
				smokesize = 4.6,
				smokecolor = 0.95,
				smokeTrailCastShadow = false,
				castshadow = false,
				soundhit = "packohit",
				soundhitwet = "splshbig",
				soundstart = "packolau",
				soundtrigger = true,
				startvelocity = 1,
				texture1 = "null",
				texture2 = "smoketrailaa3",
				tolerance = 9950,
				tracks = true,
				turnrate = 68000,
				turret = true,
				weaponacceleration = 1200,
				weapontimer = 2,
				weapontype = "MissileLauncher",
				weaponvelocity = 1000,
				damage = {
					vtol = 150,
					commanders = 1,
				},
			},
			napalmmissile = { --unused, left here in case it replaces the Dgun again.
				areaofeffect = 300,
				avoidfeature = false,
				burnblow = true,
				cegtag = "missiletraillarge-red",
				commandfire = true,
				craterboost = 0,
				cratermult = 0,
				edgeeffectiveness = 1,
				explosiongenerator = "custom:burnfirecom-xl",
				gravityaffected = "true",
				impulsefactor = 2.7,
				model = "banishermissile.s3o",
				name = "napalmmissile",
				noselfdamage = true,
				range = 450,
				reloadtime = 5,
				smoketrail = true,
				smokePeriod = 7,
				smoketime = 48,
				smokesize = 11.3,
				smokecolor = 0.82,
				soundhit = "corban_b",
				soundhitwet = "splsmed",
				soundstart = "corban_a",
				startvelocity = 240,
				stockpile = true,
				stockpiletime = 25,
				texture1 = "null",
				texture2 = "railguntrail",
				tolerance = 9000,
				turret = true,
				turnrate = 5000,
				trajectoryheight = 0.45,
				weaponacceleration = 220,
				weapontimer = 5,
				weapontype = "MissileLauncher",
				weaponvelocity = 650,
				damage = {
					default = 150,
				},
			},
			botcannon = {
				accuracy = 0.2,
				areaofeffect = 10,
				avoidfeature = false,
				avoidfriendly = false,
				burst = 1,
				burstrate = 0.025,
				collidefriendly = false,
				craterareaofeffect = 116,
				craterboost = 0.1,
				cratermult = 0.1,
				edgeeffectiveness = 0.15,
				energypershot = 900,
				explosiongenerator = "custom:botrailspawn",
				gravityaffected = "true",
				heightboostfactor = 8,
				hightrajectory = 1,
				impulseboost = 0.5,
				impulsefactor = 0.5,
				leadbonus = 0,
				model = "Units/CORMINE2.s3o",
				movingaccuracy = 600,
				mygravity = 4.8,
				name = "Long range bot cannon",
				noselfdamage = true,
				projectiles = 3,
				range = 400,
				reloadtime = 0.9,
				sprayangle = 2800,
				stockpile = true,
				stockpiletime = 13,
				soundhit = "xplonuk1xs",
				soundhitwet = "splshbig",
				soundstart = "lrpcshot3",
				soundstartvolume = 50,
				turret = true,
				trajectoryheight = 1,
				waterbounce = true,
				bounceSlip = 0.74,
				bouncerebound = 0.5,
				numbounce = 10,
				weapontype = "Cannon",
				weaponvelocity = 2000,
				customparams = {
					spawns_name = "babyleggob babyleggob babyleggob babyleggob babyleggob babyleggob babyleggob babyleggob babyleggob babyleggob babyleggob babyleggob babyleggob babyleggob babyleggob babyleglob babyleglob babyleglob babyleglob babyleglob",
					spawns_expire = 25,
					spawns_surface = "LAND", -- Available: "LAND SEA"
					spawns_mode = "random",
				},
				damage = {
					default = 0,
					shields = 250,
				},
			},
			disintegrator = {
				areaofeffect = 36,
				avoidfeature = false,
				avoidfriendly = false,
				avoidground = false,
				bouncerebound = 0,
				cegtag = "dgunprojectile",
				commandfire = true,
				craterboost = 0,
				cratermult = 0.15,
				edgeeffectiveness = 0.15,
				energypershot = 500,
				explosiongenerator = "custom:expldgun",
				firestarter = 100,
				firesubmersed = false,
				groundbounce = true,
				impulseboost = 0,
				impulsefactor = 0,
				name = "Disintegrator",
				noexplode = true,
				noselfdamage = true,
				range = 250,
				reloadtime = 0.9,
				soundhit = "xplomas2",
				soundhitwet = "sizzlexs",
				soundstart = "disigun1",
				soundhitvolume = 36,
				soundstartvolume = 96,
				soundtrigger = true,
				tolerance = 20000,
				turret = true,
				waterweapon = true,
				weapontimer = 4.2,
				weapontype = "DGun",
				weaponvelocity = 300,
				damage = {
					commanders = 0,
					default = 99999,
					scavboss = 1000,
				},
			},
		},
		weapons = {
			[1] = {
				def = "ARMMG_WEAPON",
				onlytargetcategory = "NOTSUB",
			},
			[2] = {
				badtargetcategory = "VTOL",
				def = "TORPEDO",
				onlytargetcategory = "NOTAIR"
			},
			[3] = {
				def = "disintegrator",
				onlytargetcategory = "SURFACE",
			},
			[4] = {
				badtargetcategory = "NOTAIR GROUNDSCOUT",
				def = "FERRET_MISSILE",
				onlytargetcategory = "VTOL",
			},
			[5] = {
				badtargetcategory = "VTOL GROUNDSCOUT SHIP",
				def = "BOTCANNON",
				onlytargetcategory = "SURFACE",
			},
		},
	},
}
