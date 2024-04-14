return {
	corkarganetht4 = {
		maxacc = 0.1104,
		maxdec = 0.8211,
		energycost = 120000,
		metalcost = 12000,
		buildpic = "CORKARGANETHT4.DDS",
		buildtime = 120000,
		canmove = true,
		category = "BOT WEAPON ALL NOTSUB NOTAIR NOTHOVER SURFACE EMPABLE",
		collisionvolumeoffsets = "0.0 -2.0 1",
		collisionvolumescales = "56.0 60.0 40.0",
		collisionvolumetype = "box",
		corpse = "DEAD",
		explodeas = "explosiont3xxl",
		footprintx = 4,
		footprintz = 4,
		idleautoheal = 5,
		idletime = 1800,
		mass = 1000000,
		health = 50000,
		maxslope = 160,
		speed = 30.0,
		maxwaterdepth = 12,
		movementclass = "EPICALLTERRAIN",
		nochasecategory = "VTOL",
		objectname = "Units/scavboss/corkarganetht4.s3o",
		script = "Units/scavboss/corkarganetht4.COB",
		seismicsignature = 0,
		selfdestructas = "explosiont3xxl",
		sightdistance = 550,
		turninplace = true,
		turninplaceanglelimit = 90,
		turninplacespeedlimit = 0.99,
		turnrate = 457.20001,
		upright = false,
		customparams = {
			unitgroup = 'weapon',
			model_author = "Flaka",
			normaltex = "unittextures/cor_normal.dds",
			subfolder = "corgantry",
			techlevel = 3,
		},
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				collisionvolumeoffsets = "3.89811706543 -12.9994070068 -38.2052841187",
				collisionvolumescales = "77.9624938965 23.0893859863 76.4105682373",
				collisionvolumetype = "Box",
				damage = 45000,
				footprintx = 4,
				footprintz = 4,
				height = 40,
				metal = 6000,
				object = "Units/scavboss/corkarganetht4_dead.s3o",
				reclaimable = true,
			},
		},
		sfxtypes = {
			pieceexplosiongenerators = {
				[1] = "deathceg2",
				[2] = "deathceg3",
				[3] = "deathceg4",
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
				[1] = "mavbok1",
			},
			select = {
				[1] = "mavbsel1",
			},
		},
		weapondefs = {
			--karg_head = {
			--	areaofeffect = 16,
			--	avoidfeature = false,
			--	burnblow = true,
			--	canattackground = false,
			--	cegtag = "missiletrailaa",
			--	craterareaofeffect = 0,
			--	craterboost = 0,
			--	cratermult = 0,
			--	edgeeffectiveness = 0.15,
			--	explosiongenerator = "custom:genericshellexplosion-tiny-aa",
			--	firestarter = 72,
			--	flighttime = 1.75,
			--	impulseboost = 0,
			--	impulsefactor = 0,
			--	model = "cormissile.s3o",
			--	name = "HeadRockets",
			--	noselfdamage = true,
			--	proximitypriority = -1,
			--	range = 650,
			--	reloadtime = 4,
			--	smoketrail = false,
			--	soundhit = "packohit",
			--	soundhitwet = "splshbig",
			--	soundstart = "packolau",
			--	soundtrigger = true,
			--	startvelocity = 480,
			--	texture1 = "null",
			--	texture2 = "smoketrailbar",
			--	tolerance = 9950,
			--	tracks = true,
			--	turnrate = 68000,
			--	turret = true,
			--	weaponacceleration = 200,
			--	weapontimer = 2,
			--	weapontype = "MissileLauncher",
			--	weaponvelocity = 900,
			--	damage = {
			--		bombers = 150,
			--		fighters = 120,
			--		vtol = 150,
			--	},
			--},
			karg_shoulder = {
				areaofeffect = 80,
				avoidfeature = false,
				burnblow = true,
				canattackground = false,
				cegtag = "missiletrailaa",
				craterareaofeffect = 0,
				craterboost = 0,
				cratermult = 0,
				edgeeffectiveness = 0.15,
				explosiongenerator = "custom:genericshellexplosion-tiny-aa",
				firestarter = 72,
				flighttime = 1.75,
				impulseboost = 0,
				impulsefactor = 0,
				model = "cormissile.s3o",
				name = "ShoulderRockets",
				noselfdamage = true,
				proximitypriority = 1,
				range = 1050,
				reloadtime = 10,
				smoketrail = true,
				smokePeriod = 8,
				smoketime = 20,
				smokesize = 6,
				smokecolor = 0.95,
				smokeTrailCastShadow = false,
				castshadow = false, --projectile
				soundhit = "packohit",
				soundhitwet = "splshbig",
				soundstart = "packolau",
				soundtrigger = false,
				startvelocity = 520,
				texture1 = "null",
				texture2 = "smoketrailaa3",
				tolerance = 9950,
				tracks = true,
				turnrate = 68000,
				turret = true,
				weaponacceleration = 160,
				weapontimer = 2,
				weapontype = "MissileLauncher",
				weaponvelocity = 820,
				damage = {
					vtol = 750,
				},
			},
			kargkick = {
				areaofeffect = 160,
				avoidfeature = false,
				camerashake = 500,
				collidefriendly = false,
				craterareaofeffect = 0,
				craterboost = 0,
				cratermult = 0,
				cylindertargeting = 1,
				edgeeffectiveness = 0.15,
				explosiongenerator = "custom:crusherkrog",
				firestarter = 40,
				impulseboost = 1.5,
				impulsefactor = 1.5,
				name = "KargCrush",
				noselfdamage = true,
				proximitypriority = 5,
				range = 55,
				reloadtime = 0.2,
				rgbcolor = "0 0 0",
				soundhitwet = "splssml",
				soundstart = "xplosml2",
				thickness = 0,
				tolerance = 9000,
				turnrate = 50000,
				turret = true,
				weapontype = "Cannon",
				weaponvelocity = 1650,
				customparams = {
					nofire = true,
				},
				damage = {
					default = 1,
				},
			},
			super_missile = {
				areaofeffect = 128,
				avoidfeature = false,
				cegtag = "missiletrailsmall-simple",
				craterareaofeffect = 0,
				craterboost = 0,
				cratermult = 0,
				edgeeffectiveness = 0.15,
				explosiongenerator = "custom:genericshellexplosion-large",
				firestarter = 5,
				flighttime = 2.5,
				impulseboost = 0.123,
				impulsefactor = 0.123,
				model = "cormissile3.s3o",
				name = "KarganethMissiles",
				noselfdamage = true,
				range = 750,
				reloadtime = 0.37,
				smoketrail = false,
				soundhit = "xplosml2",
				soundhitwet = "splssml",
				soundstart = "rocklit1",
				startvelocity = 180,
				texture1 = "null",
				texture2 = "smoketrailbar",
				tolerance = 15000,
				tracks = true,
				turnrate = 65384,
				turret = true,
				weaponacceleration = 250,
				weapontimer = 5,
				weapontype = "MissileLauncher",
				weaponvelocity = 500,
				damage = {
					default = 1000,
					subs = 150,
					vtol = 1000,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "GROUNDSCOUT VTOL",
				def = "SUPER_MISSILE",
				onlytargetcategory = "NOTSUB",
			},
			[2] = {
				badtargetcategory = "GROUNDSCOUT",
				def = "KARG_SHOULDER",
				onlytargetcategory = "VTOL",
			},
			--[3] = {
			--	def = "KARG_HEAD",
			--	onlytargetcategory = "VTOL",
			--},
		},
	},
}
