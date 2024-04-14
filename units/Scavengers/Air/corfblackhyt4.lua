return {
	corfblackhyt4 = {
		maxacc = 0.015,
		activatewhenbuilt = true,
		bankingallowed = false,
		maxdec = 0.05,
		buildangle = 16384,
		energycost = 250000,
		metalcost = 25000,
		buildpic = "corfblackhyt4.DDS",
		buildtime = 250000,
		canfly = true,
		canmove = true,
		category = "ALL WEAPON NOTSUB VTOL NOTHOVER T4AIR",
		collide = true,
		collisionvolumeoffsets = "0 -14 10",
		collisionvolumescales = "70 70 170",
		collisionvolumetype = "CylZ",
		corpse = "DEAD",
		cruisealtitude = 100,
		explodeas = "FlagshipExplosion",
		footprintx = 6,
		footprintz = 6,
		hoverattack = true,
		idleautoheal = 25,
		idletime = 1800,
		sightemitheight = 64,
		mass = 1000000,
		health = 67000,
		speed = 36.0,
		maxwaterdepth = 15,
		objectname = "Units/scavboss/corfblackhyt4.s3o",
		script = "Units/scavboss/corfblackhyt4.cob",
		pushresistant = true,
		radardistance = 1510,
		radaremitheight = 64,
		seismicsignature = 0,
		selfdestructas = "FlagshipExplosionSelfd",
		sightdistance = 650,
		turninplace = true,
		turninplaceanglelimit = 90,
		turnrate = 129,
		upright = true,
		customparams = {
			unitgroup = 'weapon',
			model_author = "Beherith",
			normaltex = "unittextures/cor_normal.dds",
			paralyzemultiplier = 0,
			subfolder = "corships/t2",
			techlevel = 3,
		},
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				collisionvolumeoffsets = "17.3217697144 -6.85541303711 2.43087005615",
				collisionvolumescales = "88.47706604 56.7307739258 178.029220581",
				collisionvolumetype = "Box",
				damage = 30000,
				footprintx = 6,
				footprintz = 18,
				height = 4,
				metal = 18000,
				object = "Units/scavboss/corfblackhyt4_dead.s3o",
				reclaimable = true,
			},
		},
		sfxtypes = {
			explosiongenerators = {
				[1] = "custom:barrelshot-large",
			},
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
				[1] = "sharmmov",
			},
			select = {
				[1] = "sharmsel",
			},
		},
		weapondefs = {
			aamissile = {
				areaofeffect = 64,
				avoidfeature = false,
				burnblow = true,
				canattackground = false,
				craterareaofeffect = 0,
				craterboost = 0,
				cratermult = 0,
				edgeeffectiveness = 1,
				explosiongenerator = "custom:genericshellexplosion-tiny-aa",
				firestarter = 70,
				gravityaffected = "true",
				impulseboost = 0.123,
				impulsefactor = 0.123,
				model = "cormissile.s3o",
				name = "RapidSamMissile",
				noselfdamage = true,
				range = 950,
				reloadtime = 0.6,
				soundhit = "xplomed2",
				soundhitwet = "splssml",
				soundstart = "Rocklit3",
				startvelocity = 650,
				tolerance = 8000,
				tracks = true,
				turnrate = 72000,
				turret = true,
				weaponacceleration = 150,
				weapontimer = 7,
				weapontype = "Cannon",
				weaponvelocity = 950,
				damage = {
					default = 75,
				},
			},
			heavylaser = {
				areaofeffect = 8,
				avoidfeature = false,
				beamtime = 0.2,
				corethickness = 0.2,
				craterareaofeffect = 0,
				craterboost = 0,
				cratermult = 0,
				edgeeffectiveness = 0.15,
				energypershot = 125,
				explosiongenerator = "custom:laserhit-medium-green",
				firestarter = 90,
				impactonly = 1,
				impulseboost = 0,
				impulsefactor = 0,
				laserflaresize = 12.1,
				name = "HighEnergyLaser",
				noselfdamage = true,
				range = 830,
				reloadtime = 1,
				rgbcolor = "0 1 0",
				soundhitdry = "",
				soundhitwet = "sizzle",
				soundstart = "Lasrmas2",
				soundtrigger = 1,
				targetmoveerror = 0.2,
				thickness = 3,
				tolerance = 10000,
				turret = true,
				weapontype = "BeamLaser",
				weaponvelocity = 700,
				damage = {
					default = 270,
					vtol = 65,
				},
			},
			heavyplasma = {
				accuracy = 1200,
				areaofeffect = 128,
				avoidfeature = false,
				cegtag = "arty-heavy",
				craterboost = 0,
				cratermult = 0,
				edgeeffectiveness = 0.15,
				explosiongenerator = "custom:genericshellexplosion-large",
				gravityaffected = "true",
				impulseboost = 0.123,
				impulsefactor = 0.123,
				intensity = 1.1,
				name = "BattleshipCannon",
				noselfdamage = true,
				range = 1500,
				reloadtime = 1,
				soundhit = "xplomed2",
				soundhitwet = "splsmed",
				soundstart = "cannhvy1",
				turret = true,
				weapontype = "Cannon",
				weaponvelocity = 600,
				damage = {
					default = 465,
					subs = 100,
					vtol = 130,
				},
			},
			ferret_missile = {
				areaofeffect = 16,
				avoidfeature = false,
				burst = 2,
				burstrate = 0.2,
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
				range = 840,
				reloadtime = 3.4,
				smoketrail = true,
				smokePeriod = 5,
				smoketime = 12,
				smokesize = 4.4,
				smokecolor = 0.95,
				smokeTrailCastShadow = false,
				castshadow = false, --projectile
				soundhit = "packohit",
				soundhitwet = "splshbig",
				soundstart = "packolau",
				soundtrigger = true,
				startvelocity = 1,
				texture1 = "null",
				texture2 = "smoketrailaa",
				tolerance = 9950,
				tracks = true,
				turnrate = 68000,
				turret = true,
				weaponacceleration = 1500,
				weapontimer = 2,
				weapontype = "MissileLauncher",
				weaponvelocity = 1200,
				damage = {
					vtol = 50,
				},
			},
		},
		weapons = {
			[1] = {
				def = "HEAVYPLASMA",
				onlytargetcategory = "SURFACE T4AIR",
			},
			[2] = {
				def = "HEAVYLASER",
				maindir = "0 0 1",
				maxangledif = 300,
				onlytargetcategory = "SURFACE T4AIR",
			},
			[3] = {
				badtargetcategory = "NOTAIR GROUNDSCOUT",
				maindir = "-1.5 0 2",
				maxangledif = 300,
				def = "FERRET_MISSILE",
				onlytargetcategory = "VTOL",
			},
			[4] = {
				def = "HEAVYLASER",
				maindir = "0 0 1",
				maxangledif = 300,
				onlytargetcategory = "SURFACE T4AIR",
			},
			[5] = {
				def = "HEAVYLASER",
				maindir = "0 0 1",
				maxangledif = 300,
				onlytargetcategory = "SURFACE T4AIR",
			},
			[6] = {
				badtargetcategory = "NOTAIR GROUNDSCOUT",
				maindir = "1.5 0 2",
				maxangledif = 300,
				def = "FERRET_MISSILE",
				onlytargetcategory = "VTOL",
			},
		},
	},
}
