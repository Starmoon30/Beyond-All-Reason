--------------------------
-- DOCUMENTATION
-------------------------

-- BAR contains weapondefs in its unitdef files
-- Standalone weapondefs are only loaded by Spring after unitdefs are loaded
-- So, if we want to do post processing and include all the unit+weapon defs, and have the ability to bake these changes into files, we must do it after both have been loaded
-- That means, ALL UNIT AND WEAPON DEF POST PROCESSING IS DONE HERE

-- What happens:
-- unitdefs_post.lua calls the _Post functions for unitDefs and any weaponDefs that are contained in the unitdef files
-- unitdefs_post.lua writes the corresponding unitDefs to customparams (if wanted)
-- weapondefs_post.lua fetches any weapondefs from the unitdefs,
-- weapondefs_post.lua fetches the standlaone weapondefs, calls the _post functions for them, writes them to customparams (if wanted)
-- strictly speaking, alldefs.lua is a misnomer since this file does not handle armordefs, featuredefs or movedefs

-- Switch for when we want to save defs into customparams as strings (so as a widget can then write them to file)
-- The widget to do so is included in the game and detects these customparams auto-enables itself
-- and writes them to Spring/baked_defs
SaveDefsToCustomParams = false

-------------------------
-- DEFS PRE-BAKING
--
-- This section is for testing changes to defs and baking them into the def files
-- Only the changes in this section will get baked, all other changes made in post will not
--
-- 1. Add desired def changes to this section
-- 2. Test changes in-game
-- 3. Bake changes into def files
-- 4. Delete changes from this section
-------------------------

function PrebakeUnitDefs()
	for name, unitDef in pairs(UnitDefs) do
		-- UnitDef changes go here
	end
end

-------------------------
-- DEFS POST PROCESSING
-------------------------

-- process unitdef
--local vehAdditionalTurnrate = 0
--local vehTurnrateMultiplier = 1.0
--
--local vehAdditionalAcceleration = 0.00
--local vehAccelerationMultiplier = 1
--
--local vehAdditionalVelocity = 0
--local vehVelocityMultiplier = 1

--[[ Sanitize to whole frames (plus leeways because float arithmetic is bonkers).
     The engine uses full frames for actual reload times, but forwards the raw
     value to LuaUI (so for example calculated DPS is incorrect without sanitisation). ]]
local function round_to_frames(name, wd, key)
	local original_value = wd[key]
	if not original_value then
		-- even reloadtime can be nil (shields, death explosions)
		return
	end

	local Game_gameSpeed = 30 --for mission editor backwards compat (engine 104.0.1-287)
	if Game and Game.gameSpeed then Game_gameSpeed = Game.gameSpeed end

	local frames = math.max(1, math.floor((original_value + 1E-3) * Game_gameSpeed))
	local sanitized_value = frames / Game_gameSpeed

	return sanitized_value
end

local function processWeapons(unitDefName, unitDef)
	local weaponDefs = unitDef.weapondefs
	if not weaponDefs then
		return
	end

	for weaponDefName, weaponDef in pairs (weaponDefs) do
		local fullWeaponName = unitDefName .. "." .. weaponDefName
		weaponDef.reloadtime = round_to_frames(fullWeaponName, weaponDef, "reloadtime")
		weaponDef.burstrate = round_to_frames(fullWeaponName, weaponDef, "burstrate")
	end
end

function UnitDef_Post(name, uDef)
	local modOptions = Spring.GetModOptions()

	if not uDef.icontype then
		uDef.icontype = name
	end

	-- Reverse Gear
	if modOptions.experimentalreversegear == true then
		if (not uDef.canfly) and uDef.speed then
			uDef.rspeed = uDef.speed*0.65
		end
	end

	-- Rebalance Candidates

	if modOptions.experimentalrebalancet2labs == true then --
		if name == "cortex_advancedbotlab" or name == "cortex_advancedvehicleplant" or name == "armada_advancedbotlab" or name == "armada_advancedvehicleplant" then
			uDef.metalcost = 1800 --2900
		end
		if name == "cortex_advancedaircraftplant" or name == "cortex_advancedshipyard" or name == "armada_advancedaircraftplant" or name == "armada_advancedshipyard" then
			uDef.metalcost = 2100 --3200
		end
	end

	if modOptions.experimentalrebalancet2metalextractors == true then
		if name == "armada_advancedmetalextractor" or name == "armada_navaladvancedmetalextractor" then
			uDef.extractsmetal = 0.002 --0.004
			uDef.metalcost = 240 --620
			uDef.energycost = 3000 --7700
			uDef.buildtime = 12000 --14938
			uDef.health = 1000 --2500
			uDef.energyupkeep = 10 --20
		end
		if name == "cortex_advancedmetalextractor" or name == "cortex_navaladvancedmetalextractor" then
			uDef.extractsmetal = 0.002 --0.004
			uDef.metalcost = 250 --640
			uDef.energycost = 3100 --8100
			uDef.buildtime = 11000 --14125
			uDef.health = 1400 --3500
			uDef.energyupkeep = 10 --20
		end
		if name == "cortex_advancedexploiter" then
			uDef.extractsmetal = 0.002 --0.004
			uDef.metalcost = 2000 --2400
			uDef.energycost = 8500 --12000
			uDef.health = 2800 --3500
			uDef.energyupkeep = 10 --20
		end
	end

	if modOptions.experimentalrebalancet2energy == true then
		if name == "armada_advancedconstructionaircraft" or name == "armada_advancedconstructionbot" or name == "armada_advancedconstructionvehicle" then
			local numBuildoptions = #uDef.buildoptions
			uDef.buildoptions[numBuildoptions+1] = "armada_windturbinet2"
		end
		if name == "cortex_advancedconstructionaircraft" or name == "cortex_advancedconstructionbot" or name == "cortex_advancedconstructionvehicle" then
			local numBuildoptions = #uDef.buildoptions
			uDef.buildoptions[numBuildoptions+1] = "cortex_advancedwindturbine"
		end
	end

	-- Control Mode Tweaks
	if modOptions.scoremode ~= "disabled" then
		if modOptions.scoremode_chess == true then
			-- Disable Wrecks
			uDef.corpse = nil
			-- Disable Bad Units
			local factories = {
				armada_advancedaircraftplant = true,
				armada_advancedbotlab = true,
				armada_aircraftplant = true,
				armada_advancedvehicleplant = true,
				armada_hovercraftplatform = true,
				armada_botlab = true,
				armada_experimentalgantry = true,
				armada_vehicleplant = true,
				armada_amphibiouscomplex = true,
				armada_advancedshipyard = true,
				armada_navalhovercraftplatform = true,
				armada_seaplaneplatform = true,
				armada_experimentalgantryuw = true,
				armada_shipyard = true,
				cortex_advancedaircraftplant = true,
				cortex_advancedbotlab = true,
				cortex_aircraftplant = true,
				cortex_advancedvehicleplant = true,
				cortex_experimentalgantry = true,
				cortex_hovercraftplatform = true,
				cortex_botlab = true,
				cortex_vehicleplant = true,
				cortex_amphibiouscomplex = true,
				cortex_advancedshipyard = true,
				cortex_navalhovercraftplatform = true,
				cortex_seaplaneplatform = true,
				cortex_underwaterexperimentalgantry = true,
				cortex_shipyard = true,
				armada_aircraftplantt3 = true,	-- scav T3 air factory
				cortex_experimentalaircraftplant = true,	-- scav T3 air factory
				armada_constructionturret = true,
				armada_navalconstructionturret = true,
				cortex_constructionturret = true,
				cortex_navalconstructionturret = true,
				armbotrail = true, -- it spawns units so it will add dead launched peewees to respawn queue.
			}
			if factories[name] then
				uDef.maxthisunit = 0
			end
		else

		end
	end

	-- test New sound system!
	--VFS.Include('luarules/configs/gui_soundeffects.lua')
	--if not (GUIUnitSoundEffects[name] or (GUIUnitSoundEffects[string.sub(name, 1, string.len(name)-5)] and string.find(name, "_scav"))) then
	--	Spring.Echo("[gui_soundeffects.lua] Missing Sound Effects for unit: "..name)
	--end

	if uDef.sounds then
		if uDef.sounds.ok then
			uDef.sounds.ok = nil
		end
	end

	if uDef.sounds then
		if uDef.sounds.select then
			uDef.sounds.select = nil
		end
	end

	if uDef.sounds then
		if uDef.sounds.activate then
			uDef.sounds.activate = nil
		end
		if uDef.sounds.deactivate then
			uDef.sounds.deactivate = nil
		end
		if uDef.sounds.build then
			uDef.sounds.build = nil
		end
	end

	-- Unit Restrictions
	if uDef.customparams then
		if not uDef.customparams.techlevel then uDef.customparams.techlevel = 1 end
		if not uDef.customparams.subfolder then uDef.customparams.subfolder = "none" end
		if modOptions.unit_restrictions_notech2 then
			if tonumber(uDef.customparams.techlevel) == 2 or tonumber(uDef.customparams.techlevel) == 3 then
				uDef.maxthisunit = 0
			end
		end

		if modOptions.unit_restrictions_notech3 then
			if tonumber(uDef.customparams.techlevel) == 3 then
				uDef.maxthisunit = 0
			end
		end

		if modOptions.unit_restrictions_noair then
			if string.find(uDef.customparams.subfolder, "Aircraft") then
				uDef.maxthisunit = 0
			elseif uDef.customparams.unitgroup and uDef.customparams.unitgroup == "aa" then
				uDef.maxthisunit = 0
			elseif uDef.canfly then
				uDef.maxthisunit = 0
			end
			local AircraftFactories = {
				armada_aircraftplant = true,
				armada_advancedaircraftplant = true,
				armada_seaplaneplatform = true,
				cortex_aircraftplant = true,
				cortex_advancedaircraftplant = true,
				cortex_seaplaneplatform = true,
				cortex_experimentalaircraftplant = true,
				armada_aircraftplantt3 = true,
				legap = true,
				legaap = true,
				armada_aircraftplant_scav = true,
				armada_advancedaircraftplant_scav = true,
				armada_seaplaneplatform_scav = true,
				cortex_aircraftplant_scav = true,
				cortex_advancedaircraftplant_scav = true,
				cortex_seaplaneplatform_scav = true,
				cortex_experimentalaircraftplant_scav = true,
				armada_aircraftplantt3_scav = true,
				legap_scav = true,
				legaap_scav = true,

			}
			if AircraftFactories[name] then
				uDef.maxthisunit = 0
			end
		end

		if modOptions.unit_restrictions_noextractors then
			if (uDef.extractsmetal and uDef.extractsmetal > 0) and (uDef.customparams.metal_extractor and uDef.customparams.metal_extractor > 0) then
				uDef.maxthisunit = 0
			end
		end

		if modOptions.unit_restrictions_noconverters then
			if uDef.customparams.energyconv_capacity and uDef.customparams.energyconv_efficiency then
				uDef.maxthisunit = 0
			end
		end

		if modOptions.unit_restrictions_nonukes then
			local Nukes = {
				armada_citadel = true,
				armada_armageddon = true,
				armada_umbrella = true,
				cortex_prevailer = true,
				cortex_apocalypse = true,
				cortex_saviour = true,
				armada_citadel_scav = true,
				armada_armageddon_scav = true,
				armada_umbrella_scav = true,
				cortex_prevailer_scav = true,
				cortex_apocalypse_scav = true,
				cortex_saviour_scav = true,
			}
			if Nukes[name] then
				uDef.maxthisunit = 0
			end
		end

		if modOptions.unit_restrictions_notacnukes then
			local TacNukes = {
				armada_paralyzer = true,
				cortex_catalyst = true,
				armada_paralyzer_scav = true,
				cortex_catalyst_scav = true,
			}
			if TacNukes[name] then
				uDef.maxthisunit = 0
			end
		end

		if modOptions.unit_restrictions_nolrpc then
			local LRPCs = {
				armbotrail = true,
				armada_basilica = true,
				armada_ragnarok = true,
				cortex_basilisk = true,
				cortex_calamity = true,
				legstarfall = true,
				armbotrail_scav = true,
				armada_basilica_scav = true,
				armada_ragnarok_scav = true,
				cortex_basilisk_scav = true,
				cortex_calamity_scav = true,
				legstarfall_scav = true,
			}
			if LRPCs[name] then
				uDef.maxthisunit = 0
			end
		end
	end

	-- Add balanced extras
	if modOptions.releasecandidates then

		--Shockwave mex
		if name == "armada_advancedconstructionaircraft" or name == "armada_advancedconstructionbot" or name == "armada_advancedconstructionvehicle" then
			local numBuildoptions = #uDef.buildoptions
			uDef.buildoptions[numBuildoptions+1] = "armada_shockwave"
		end

		--Printer

		if name == "cortex_advancedvehicleplant" then
			local numBuildoptions = #uDef.buildoptions
			uDef.buildoptions[numBuildoptions+1] = "corvac" --corprinter
			--uDef.buildoptions[numBuildoptions+2] = "corsala"
			--uDef.buildoptions[numBuildoptions+3] = "corforge"
			--uDef.buildoptions[numBuildoptions+4] = "cortorch"
		end
		if name == "legavp" then
			local numBuildoptions = #uDef.buildoptions
			uDef.buildoptions[numBuildoptions+1] = "corvac" --corprinter
		end
		
		--Drone Carriers
		
		if name == "armada_advancedshipyard" then
			local numBuildoptions = #uDef.buildoptions
			uDef.buildoptions[numBuildoptions+1] = "armada_dronecarrier"
		end
		if name == "cortex_advancedshipyard" then
			local numBuildoptions = #uDef.buildoptions
			uDef.buildoptions[numBuildoptions+1] = "cortex_dronecarrier"
		end
		
	end

	-- Add scav units to normal factories and builders
	if modOptions.experimentalextraunits then

		if name == "armada_experimentalgantry" then
			local numBuildoptions = #uDef.buildoptions
			uDef.buildoptions[numBuildoptions+1] = "armrattet4"
			uDef.buildoptions[numBuildoptions+2] = "armada_recluset4"
			uDef.buildoptions[numBuildoptions+3] = "armada_pawnt4"
			uDef.buildoptions[numBuildoptions+4] = "armada_tumbleweedt4"
			-- uDef.buildoptions[numBuildoptions+5] = "armada_lunchbox"
			uDef.buildoptions[numBuildoptions+6] = "armmeatball"
			uDef.buildoptions[numBuildoptions+7] = "armassimilator"
			uDef.buildoptions[numBuildoptions+8] = "armada_dronecarrierland"
		elseif name == "armada_experimentalgantryuw" then
			local numBuildoptions = #uDef.buildoptions
			uDef.buildoptions[numBuildoptions+1] = "armrattet4"
			uDef.buildoptions[numBuildoptions+2] = "armada_pawnt4"
			uDef.buildoptions[numBuildoptions+3] = "armada_tumbleweedt4"
			uDef.buildoptions[numBuildoptions+4] = "armmeatball"
		elseif name == "cortex_underwaterexperimentalgantry" then
			local numBuildoptions = #uDef.buildoptions
			uDef.buildoptions[numBuildoptions+1] = "cortex_tzart4"
			uDef.buildoptions[numBuildoptions+2] = "cortex_gruntt4"
		elseif name == "armada_vehicleplant" then
			local numBuildoptions = #uDef.buildoptions
			uDef.buildoptions[numBuildoptions+1] = "armzapper"
		elseif name == "legavp" then
			local numBuildoptions = #uDef.buildoptions
			uDef.buildoptions[numBuildoptions+1] = "corgatreap"
			uDef.buildoptions[numBuildoptions+2] = "corforge"
			uDef.buildoptions[numBuildoptions+3] = "corftiger"
			uDef.buildoptions[numBuildoptions+4] = "cortorch"
			uDef.buildoptions[numBuildoptions+5] = "corvac" --corprinter
		elseif name == "cortex_advancedvehicleplant" then
			printerpresent = false
			for ix, UnitName in pairs(uDef.buildoptions) do
				if UnitName == "corvac" then
					printerpresent = true
				end
			end
			local numBuildoptions = #uDef.buildoptions
			uDef.buildoptions[numBuildoptions+1] = "corgatreap"
			uDef.buildoptions[numBuildoptions+2] = "corforge"
			uDef.buildoptions[numBuildoptions+3] = "corftiger"
			uDef.buildoptions[numBuildoptions+4] = "cortorch"
			if (printerpresent==false) then -- assuming sala and vac stay paired, this is tidiest solution
				uDef.buildoptions[numBuildoptions+5] = "corsala"
				uDef.buildoptions[numBuildoptions+6] = "corvac" --corprinter
			end
		elseif name == "cortex_experimentalgantry" or name == "leggant" then
			local numBuildoptions = #uDef.buildoptions
			uDef.buildoptions[numBuildoptions+1] = "cortex_karganetht4"
			uDef.buildoptions[numBuildoptions+2] = "cortex_tzart4"
			uDef.buildoptions[numBuildoptions+3] = "cortex_gruntt4"
			uDef.buildoptions[numBuildoptions+4] = "corthermite"
		elseif name == "armada_constructionaircraft" or name == "armada_constructionbot" or name == "armada_constructionvehicle" then
			--local numBuildoptions = #uDef.buildoptions
		elseif name == "cortex_constructionaircraft" or name == "cortex_constructionbot" or name == "cortex_constructionvehicle" then
			--local numBuildoptions = #uDef.buildoptions
		elseif name == "legca" or name == "legck" or name == "legcv" then
			--local numBuildoptions = #uDef.buildoptions
		elseif name == "cortex_constructionship" or name == "cortex_constructionseaplane" then
			local numBuildoptions = #uDef.buildoptions
			uDef.buildoptions[numBuildoptions+1] = "cortex_gunplatform"
			uDef.buildoptions[numBuildoptions+2] = "cortex_janitor"
		elseif name == "armada_constructionship" or name == "armada_constructionseaplane" then
			local numBuildoptions = #uDef.buildoptions
			uDef.buildoptions[numBuildoptions+1] = "armada_gunplatform"
			uDef.buildoptions[numBuildoptions+2] = "armada_scumbag"
		elseif name == "cortex_advancedconstructionsub" then
			local numBuildoptions = #uDef.buildoptions
			uDef.buildoptions[numBuildoptions+1] = "cortex_atoll"
		elseif name == "armada_advancedconstructionsub" then
			local numBuildoptions = #uDef.buildoptions
			uDef.buildoptions[numBuildoptions+1] = "armada_aurora"
		elseif name == "armada_advancedconstructionaircraft" or name == "armada_advancedconstructionbot" or name == "armada_advancedconstructionvehicle" then
			local numBuildoptions = #uDef.buildoptions
			uDef.buildoptions[numBuildoptions+1] = "armada_aircraftplantt3"
			uDef.buildoptions[numBuildoptions+2] = "armminivulc"
			uDef.buildoptions[numBuildoptions+3] = "armada_windturbinet2"
			uDef.buildoptions[numBuildoptions+5] = "armbotrail"
			uDef.buildoptions[numBuildoptions+6] = "armada_pulsart3"
			uDef.buildoptions[numBuildoptions+7] = "armada_advancedconstructionturret"
			uDef.buildoptions[numBuildoptions+8] = "armlwall"
		elseif name == "cortex_advancedconstructionaircraft" or name == "cortex_advancedconstructionbot" or name == "cortex_advancedconstructionvehicle" then
			local numBuildoptions = #uDef.buildoptions
			uDef.buildoptions[numBuildoptions+1] = "cortex_experimentalaircraftplant"
			uDef.buildoptions[numBuildoptions+2] = "corminibuzz"
      		uDef.buildoptions[numBuildoptions+3] = "cortex_advancedwindturbine"
			uDef.buildoptions[numBuildoptions+4] = "corhllllt"
			uDef.buildoptions[numBuildoptions+6] = "cortex_bulwarkt3"
			uDef.buildoptions[numBuildoptions+7] = "cortex_advancedconstructionturret"
			uDef.buildoptions[numBuildoptions+8] = "cormwall"
		elseif name == "legaca" or name == "legack" or name == "legacv" then
			local numBuildoptions = #uDef.buildoptions
			uDef.buildoptions[numBuildoptions+1] = "cortex_experimentalaircraftplant"
			uDef.buildoptions[numBuildoptions+2] = "legministarfall"
      		uDef.buildoptions[numBuildoptions+3] = "cortex_advancedwindturbine"
			uDef.buildoptions[numBuildoptions+4] = "corhllllt"
			uDef.buildoptions[numBuildoptions+6] = "cortex_bulwarkt3"
			uDef.buildoptions[numBuildoptions+7] = "cortex_advancedconstructionturret"
		elseif name == "armada_advancedshipyard" then
			local numBuildoptions = #uDef.buildoptions
			uDef.buildoptions[numBuildoptions+1] = "armada_skatert2"
			uDef.buildoptions[numBuildoptions+2] = "armada_dolphint3"
			uDef.buildoptions[numBuildoptions+3] = "armada_ellysawt3"
			uDef.buildoptions[numBuildoptions+4] = "armada_serpentt3"
			uDef.buildoptions[numBuildoptions+5] = "armada_haven2"
		elseif name == "cortex_advancedshipyard" then
			local numBuildoptions = #uDef.buildoptions
			uDef.buildoptions[numBuildoptions+1] = "corslrpc"
			uDef.buildoptions[numBuildoptions+2] = "cortex_supportert3"
			uDef.buildoptions[numBuildoptions+3] = "cortex_oasis2"
		end
	end

	-- if Spring.GetModOptions().experimentalmassoverride then
	-- 	-- mass override
	-- 	Spring.Echo("-------------------------")
	-- 	if uDef.name then
	-- 		Spring.Echo("Processing Mass Override for unit: "..uDef.name)
	-- 	else
	-- 		Spring.Echo("Processing Mass Override for unit: unknown-unit")
	-- 	end
	-- 	Spring.Echo("-------------------------")

	-- 	massoverrideFootprintX = 1
	-- 	if uDef.footprintx and uDef.footprintx > 0 then
	-- 		massoverrideFootprintX = uDef.footprintx
	-- 		Spring.Echo("Footprint X: "..uDef.footprintx)
	-- 	else
	-- 		Spring.Echo("Missing Footprint X")
	-- 	end

	-- 	massoverrideFootprintZ = 1
	-- 	if uDef.footprintz and uDef.footprintz > 0 then
	-- 		massoverrideFootprintZ = uDef.footprintz
	-- 		Spring.Echo("Footprint Z: "..uDef.footprintz)
	-- 	else
	-- 		Spring.Echo("Missing Footprint Z")
	-- 	end

	-- 	massoverrideMetalCost = 1
	-- 	if uDef.metalcost and uDef.metalcost > 0 then
	-- 		massoverrideMetalCost = uDef.metalcost
	-- 		Spring.Echo("Metal Cost: "..uDef.metalcost)
	-- 	else
	-- 		Spring.Echo("Missing Metal Cost")
	-- 	end

	-- 	massoverrideHealth = 1
	-- 	if uDef.health and uDef.health > 0 then
	-- 		massoverrideHealth = uDef.health
	-- 		Spring.Echo("Max Health: "..uDef.health)
	-- 	else
	-- 		Spring.Echo("Missing Max Health")
	-- 	end

	-- 	uDef.mass = math.ceil((massoverrideFootprintX * massoverrideFootprintZ * (massoverrideMetalCost + massoverrideHealth))*0.33)
	-- 	Spring.Echo("-------------------------")
	-- 	Spring.Echo("Result Mass: "..uDef.mass)
	-- 	Spring.Echo("-------------------------")
	-- end

	-- mass remove push resistance
	if uDef.pushresistant and uDef.pushresistant == true then
		uDef.pushresistant = false
		if not uDef.mass then
			--Spring.Echo("[PUSH RESISTANCE REMOVER] Push Resistant Unit with no mass: "..name)
			uDef.mass = 4999
		end
	end

	--[[
	if uDef.metalcost and uDef.health then
		uDef.mass = uDef.metalcost
		if uDef.mass and uDef.name then
			Spring.Echo(uDef.name.."'s mass is:"..uDef.mass)
		end
	end
	]]
	if string.find(name, "raptor") and uDef.health then
		local raptorHealth = uDef.health
		uDef.activatewhenbuilt = true
		uDef.metalcost = raptorHealth*0.5
		uDef.energycost = math.min(raptorHealth*5, 16000000)
		uDef.buildtime = math.min(raptorHealth*10, 16000000)
		uDef.hidedamage = true
		uDef.mass = raptorHealth
		uDef.canhover = true
		uDef.autoheal = math.ceil(math.sqrt(raptorHealth * 0.2))
		uDef.customparams.paralyzemultiplier = uDef.customparams.paralyzemultiplier or .2
		uDef.idleautoheal = math.ceil(math.sqrt(raptorHealth * 0.2))
		uDef.idletime = 1
		uDef.customparams.areadamageresistance = "_RAPTORACID_"
		uDef.upright = false
		uDef.floater = true
		uDef.turninplace = true
		uDef.turninplaceanglelimit = 360
		uDef.capturable = false
		uDef.leavetracks = false
		uDef.maxwaterdepth = 0

		if uDef.cancloak then
			uDef.cloakcost = 0
			uDef.cloakcostmoving = 0
			uDef.mincloakdistance = 100
			uDef.seismicsignature = 3
			uDef.initcloaked = 1
		else
			uDef.seismicsignature = 0
		end

		if uDef.sightdistance then
			uDef.sonardistance = uDef.sightdistance*2
			uDef.radardistance = uDef.sightdistance*2
			uDef.airsightdistance = uDef.sightdistance*2
		end

		if (not uDef.canfly) and uDef.speed then
			uDef.rspeed = uDef.speed*0.65
			uDef.turnrate = uDef.speed*10
			uDef.maxacc = uDef.speed*0.00166
			uDef.maxdec  = uDef.speed*0.00166
		elseif uDef.canfly then
			if modOptions.air_rework == true then
				uDef.speed = uDef.speed*0.65
				uDef.health = uDef.health*1.5

				uDef.maxacc = 1
				uDef.maxdec  = 1
				uDef.usesmoothmesh = true

				-- flightmodel
				uDef.maxaileron = 0.025
				uDef.maxbank = 0.65
				uDef.maxelevator = 0.025
				uDef.maxpitch = 0.75
				uDef.maxrudder = 0.18
				uDef.wingangle = 0.06593
				uDef.wingdrag = 0.02
				uDef.turnradius = 64
				uDef.turnrate = 50
				uDef.speedtofront = 0.06
				uDef.cruisealtitude = 220
				--uDef.attackrunlength = 32
			else
				uDef.maxacc = 1
				uDef.maxdec  = 0.25
				uDef.usesmoothmesh = true

				-- flightmodel
				uDef.maxaileron = 0.025
				uDef.maxbank = 0.8
				uDef.maxelevator = 0.025
				uDef.maxpitch = 0.75
				uDef.maxrudder = 0.025
				uDef.wingangle = 0.06593
				uDef.wingdrag = 0.835
				uDef.turnradius = 64
				uDef.turnrate = 1600
				uDef.speedtofront = 0.01
				uDef.cruisealtitude = 220
				--uDef.attackrunlength = 32
			end
		end
	end

	-- if (uDef.buildpic and uDef.buildpic == "") or not uDef.buildpic then
	-- 	Spring.Echo("[BUILDPIC] Missing Buildpic: ".. uDef.name)
	-- end

	--[[ Sanitize to whole frames (plus leeways because float arithmetic is bonkers).
         The engine uses full frames for actual reload times, but forwards the raw
         value to LuaUI (so for example calculated DPS is incorrect without sanitisation). ]]
	processWeapons(name, uDef)

	-- make los height a bit more forgiving	(20 is the default)
	--uDef.sightemitheight = (uDef.sightemitheight and uDef.sightemitheight or 20) + 20
	if true then
		uDef.sightemitheight = 0
		uDef.radaremitheight = 0
		if uDef.collisionvolumescales then
			local x = uDef.collisionvolumescales
			--Spring.Echo(x)
			local xtab = {}
			for i in string.gmatch(x, "%S+") do
				xtab[#xtab+1] = i
			end
			--Spring.Echo("Result of volume scales: "..tonumber(xtab[2]))
			uDef.sightemitheight = uDef.sightemitheight+tonumber(xtab[2])
			uDef.radaremitheight = uDef.radaremitheight+tonumber(xtab[2])
		end
		if uDef.collisionvolumeoffsets then
			local x = uDef.collisionvolumeoffsets
			--Spring.Echo(x)
			local xtab = {}
			for i in string.gmatch(x, "%S+") do
				xtab[#xtab+1] = i
			end
			--Spring.Echo("Result of volume offsets: "..tonumber(xtab[2]))
			uDef.sightemitheight = uDef.sightemitheight+tonumber(xtab[2])
			uDef.radaremitheight = uDef.radaremitheight+tonumber(xtab[2])
		end
                if uDef.sightemitheight < 40 then
                        uDef.sightemitheight = 40
                        uDef.radaremitheight = 40
                end
		--Spring.Echo("Final Emit Height: ".. uDef.sightemitheight)
	end

	if not uDef.customparams.iscommander then
		--local wreckinfo = ''
		if uDef.featuredefs and uDef.health then
			if uDef.featuredefs.dead then
				uDef.featuredefs.dead.damage = uDef.health
				if modOptions.experimentalrebalancewreckstandarization then
					if uDef.metalcost and uDef.energycost then
						if name and not string.find(name, "_scav") then
							-- if (name and uDef.featuredefs.dead.metal) or uDef.name then
							-- 	--wreckinfo = wreckinfo .. name ..  " Wreck Before: " .. tostring(uDef.featuredefs.dead.metal) .. ','
							-- end
							uDef.featuredefs.dead.metal = math.floor(uDef.metalcost*0.6)
							-- if name and not string.find(name, "_scav") then
							-- 	--wreckinfo = wreckinfo .. " Wreck After: " .. tostring(uDef.featuredefs.dead.metal) .. " ; "
							-- end
						end
					end
				end
			end
		end

		if uDef.featuredefs and uDef.health then
			if uDef.featuredefs.heap then
				uDef.featuredefs.heap.damage = uDef.health
				if modOptions.experimentalrebalancewreckstandarization then
					if uDef.metalcost and uDef.energycost then
						if name and not string.find(name, "_scav") then
							-- if (name and uDef.featuredefs.heap.metal) or uDef.name then
							-- 	--wreckinfo = wreckinfo .. name ..  " Heap Before: " .. tostring(uDef.featuredefs.heap.metal) .. ','
							-- end
							uDef.featuredefs.heap.metal = math.floor(uDef.metalcost*0.25)
							-- if name and not string.find(name, "_scav") then
							-- 	--wreckinfo = wreckinfo ..  " Heap After: " .. tostring(uDef.featuredefs.heap.metal)
							-- end
						end
					end
				end
			end
		end
		--if wreckinfo ~= '' then Spring.Echo(wreckinfo) end
    end

	if uDef.maxslope then
		uDef.maxslope = math.floor((uDef.maxslope * 1.5) + 0.5)
	end

	-- make sure all paralyzable units have the correct EMPABLE category applied (or removed)
	if uDef.category then
		local empable = string.find(uDef.category, "EMPABLE")
		if uDef.customparams and uDef.customparams.paralyzemultiplier then
			if tonumber(uDef.customparams.paralyzemultiplier) == 0 then
				if empable then
					uDef.category = string.sub(uDef.category, 1, empable) .. string.sub(uDef.category, empable+7)
				end
			elseif not empable then
				uDef.category = uDef.category .. ' EMPABLE'
			end
		elseif not empable then
			uDef.category = uDef.category .. ' EMPABLE'
		end
	end

	--if Spring.GetModOptions().airrebalance then
		--if uDef.weapons then
		--	local aaMult = 1.05
		--	for weaponID, w in pairs(uDef.weapons) do
		--		if w.onlytargetcategory == 'VTOL' then
		--			local wdef = string.lower(w.def)
		--			if uDef.weapondefs[wdef] and uDef.weapondefs[wdef].range < 2000 then -- excluding mercury/screamer
		--				uDef.weapondefs[wdef].range = math.floor((uDef.weapondefs[wdef].range * aaMult) + 0.5)
		--				if uDef.weapondefs[wdef].flighttime then
		--					uDef.weapondefs[wdef].flighttime = uDef.weapondefs[wdef].flighttime * (aaMult-((aaMult-1)/3))
		--				end
		--			end
		--		end
		--	end
		--end

		if uDef.canfly then

			uDef.crashdrag = 0.01	-- default 0.005

			if not (string.find(name, "fepoch") or string.find(name, "fblackhy") or string.find(name, "cortex_dragonold") or string.find(name, "legfort")) then--(string.find(name, "liche") or string.find(name, "crw") or string.find(name, "fepoch") or string.find(name, "fblackhy")) then
				if not modOptions.experimentalnoaircollisions then
					uDef.collide = false
				else
					uDef.collide = true
				end

				--local airmult = 1.3
				--if uDef.energycost then
				--	uDef.energycost = math.ceil(uDef.energycost*airmult)
				--end
				--
				--if uDef.buildtime then
				--	uDef.buildtime = math.ceil(uDef.buildtime*airmult)
				--end
				--
				--if uDef.metalcost then
				--	uDef.metalcost = math.ceil(uDef.metalcost*airmult)
				--end
				--
				--if uDef.builder then
				--	uDef.workertime = math.floor((uDef.workertime*airmult) + 0.5)
				--end

				if uDef.customparams.fighter then

					--if uDef.health then
					--	uDef.health = math.ceil(uDef.health*1.8)
					--end
--
					--if uDef.weapondefs then
					--	local reloadtimeMult = 1.8
					--	for weaponDefName, weaponDef in pairs (uDef.weapondefs) do
					--		uDef.weapondefs[weaponDefName].reloadtime = uDef.weapondefs[weaponDefName].reloadtime * reloadtimeMult
					--		for category, damage in pairs (weaponDef.damage) do
					--			uDef.weapondefs[weaponDefName].damage[category] = math.floor((damage * reloadtimeMult) + 0.5)
					--		end
					--	end
					--end
					--
					--uDef.speed = uDef.maxvelocity*1.15
					--
					--uDef.maxacc = uDef.maxacc*1.3
					--
					---- turn speeds x,y,z
					--local movementMult = 1.1
					--uDef.maxelevator = uDef.maxelevator*movementMult
					--uDef.maxrudder  = uDef.maxrudder*movementMult
					--uDef.maxaileron = uDef.maxaileron*movementMult
					--
					--uDef.turnradius = uDef.turnradius*0.9
					--
					--uDef.maxbank = uDef.maxbank*movementMult
					--uDef.maxpitch = uDef.maxpitch*movementMult
					--
					--uDef.maxbank = uDef.maxbank*movementMult
					--uDef.maxpitch = uDef.maxpitch*movementMult

				else 	-- not fighters

					--local rangeMult = 0.65
					--if uDef.airsightdistance then
					--	uDef.airsightdistance = math.floor((uDef.airsightdistance*rangeMult) + 0.5)
					--end
					--
					--if uDef.health then
					--	uDef.health = math.floor((uDef.health*airmult) + 0.5)
					--end
					--
					--if uDef.weapondefs then
					--	for weaponDefName, weaponDef in pairs (uDef.weapondefs) do
					--		uDef.weapondefs[weaponDefName].range = math.floor((uDef.weapondefs[weaponDefName].range * rangeMult) + 0.5)
					--		for category, damage in pairs (weaponDef.damage) do
					--			uDef.weapondefs[weaponDefName].damage[category] = math.floor((damage * airmult) + 0.5)
					--		end
					--	end
					--end
				end
			end
		end
	--end

	-- vehicles
    --if uDef.category and string.find(uDef.category, "TANK") then
    --	if uDef.turnrate ~= nil then
    --		uDef.turnrate = (uDef.turnrate + vehAdditionalTurnrate) * vehTurnrateMultiplier
    --	end
    --    	if uDef.maxacc~= nil then
    --		uDef.maxacc= (uDef.maxacc+ vehAdditionalAcceleration) * vehAccelerationMultiplier
    --	end
    --    	if uDef.speed ~= nil then
    --		uDef.speed = (uDef.speed + vehAdditionalVelocity) * vehVelocityMultiplier
    --	end
    --end


if modOptions.emprework == true then

		if name == "armada_stiletto" then
			uDef.weapondefs.stiletto_bomb.areaofeffect = 250
			uDef.weapondefs.stiletto_bomb.burst = 3
			uDef.weapondefs.stiletto_bomb.burstrate = 0.3333
			uDef.weapondefs.stiletto_bomb.edgeeffectiveness = 0.30
			uDef.weapondefs.stiletto_bomb.damage.default = 1200
			uDef.weapondefs.stiletto_bomb.paralyzetime = 5
		end

		if name == "armada_webber" then
			uDef.weapondefs.spider.paralyzetime = 5
			--uDef.weapondefs.spider.damage.default = 1500
		end

		if name == "armada_abductor" then
			uDef.weapondefs.armada_abductor_paralyzer.paralyzetime = 5
		end


		if name == "armada_paralyzer" then
			uDef.weapondefs.armada_paralyzer_weapon.areaofeffect = 512
			uDef.weapondefs.armada_paralyzer_weapon.burstrate = 0.3333
			uDef.weapondefs.armada_paralyzer_weapon.edgeeffectiveness = -0.10
			uDef.weapondefs.armada_paralyzer_weapon.paralyzetime = 15
			uDef.weapondefs.armada_paralyzer_weapon.damage.default = 60000

		end
		if name == "armada_shockwave" then
			uDef.weapondefs.hllt_bottom.areaofeffect = 150
			uDef.weapondefs.hllt_bottom.edgeeffectiveness = 0.15
			uDef.weapondefs.hllt_bottom.reloadtime = 1.4
			uDef.weapondefs.hllt_bottom.paralyzetime = 5
			uDef.weapondefs.hllt_bottom.damage.default = 800
		end


		if name == "armada_thor" then
			uDef.weapondefs.empmissile.areaofeffect = 250
			uDef.weapondefs.empmissile.edgeeffectiveness = -0.50
			uDef.weapondefs.empmissile.damage.default = 20000
			uDef.weapondefs.empmissile.paralyzetime = 5
			uDef.weapondefs.emp.damage.default = 450
			uDef.weapondefs.emp.paralyzetime = 5
		end

		if name == "cortex_shuriken" then
			uDef.weapondefs.bladewing_lyzer.damage.default = 400
			uDef.weapondefs.bladewing_lyzer.paralyzetime = 5
		end


		if name == "cortex_mammoth" then
			uDef.customparams.paralyzemultiplier = 0.9
		end

		if name == "armada_marauder" then
			uDef.customparams.paralyzemultiplier = 1.3
		end

		if name == "armada_titan" then
			uDef.customparams.paralyzemultiplier = 2
		end

		if name == "armada_razorback" then
			uDef.customparams.paralyzemultiplier = 1.2
		end
		if name == "armada_vanguard" then
			uDef.customparams.paralyzemultiplier = 1.1
		end

		if name == "armada_lunkhead" then
			uDef.customparams.paralyzemultiplier = 1.05
		end

		if name == "cortex_shiva" then
			uDef.customparams.paralyzemultiplier = 1.1
		end

		if name == "cortex_catapult" then
			uDef.customparams.paralyzemultiplier = 1.05
		end

		if name == "cortex_karganeth" then
			uDef.customparams.paralyzemultiplier = 1.2
		end
		if name == "cortex_cataphract" then
			uDef.customparams.paralyzemultiplier = 1.1
		end
		if name == "cortex_demon" then
			uDef.customparams.paralyzemultiplier = 1.2
		end

end


--Air rework
if modOptions.air_rework == true then
	if name == "armada_highwind" then
		uDef.metalcost = 205
		uDef.energycost = 6500
		uDef.buildtime = uDef.buildtime * 1.15
		uDef.maxaileron = 0.02
		uDef.maxacc = 0.6
		uDef.speed = 233
		uDef.maxrudder = 0.016
		uDef.maxbank = 0.65
		uDef.health = 730
		uDef.sightdistance = 550
		uDef.cruisealtitude = 220
		uDef.weapondefs.armvtol_advmissile.proximitypriority = 0
		uDef.weapondefs.armvtol_advmissile.areaofeffect = 52
		uDef.weapondefs.armvtol_advmissile.impactonly = 0
		uDef.weapondefs.armvtol_advmissile.flighttime = 2.7
		uDef.weapondefs.armvtol_advmissile.range = 1430
		uDef.weapondefs.armvtol_advmissile.reloadtime = 2.7
		uDef.weapondefs.armvtol_advmissile.startvelocity = 120
		uDef.weapondefs.armvtol_advmissile.tolerance = 16500
		uDef.weapondefs.armvtol_advmissile.turnrate = 26000
		uDef.weapondefs.armvtol_advmissile.weaponacceleration = 350
		uDef.weapondefs.armvtol_advmissile.damage = {
			default = 1,
			vtol = 550,
		}
	end
	if name == "armada_falcon" then
		uDef.metalcost = 126
		uDef.energycost = 3700
		uDef.buildtime = 4350
		uDef.speed = 188
		uDef.maxacc = 0.36
		uDef.maxrudder = 0.013
		uDef.maxbank = 0.65
		uDef.health = 290
		uDef.sightdistance = 460
		uDef.cruisealtitude = 110
		uDef.weapondefs.armvtol_missile.explosiongenerator = "custom:genericshellexplosion-tiny"
		uDef.weapondefs.armvtol_missile.smokePeriod = 8
		uDef.weapondefs.armvtol_missile.smoketime = 14
		uDef.weapondefs.armvtol_missile.smokesize = 5.0
		uDef.weapondefs.armvtol_missile.smokecolor = 0.66
		uDef.weapondefs.armvtol_missile.cegtag = "missiletrailtiny"
		uDef.weapondefs.armvtol_missile.proximitypriority = 0
		uDef.weapondefs.armvtol_missile.flighttime = 1.7
		uDef.weapondefs.armvtol_missile.range = 530
		uDef.weapondefs.armvtol_missile.reloadtime = 3
		uDef.weapondefs.armvtol_missile.startvelocity = 110
		uDef.weapondefs.armvtol_missile.tolerance = 11000
		uDef.weapondefs.armvtol_missile.turnrate = 23000
		uDef.weapondefs.armvtol_missile.name = "Light guided a2a/a2g missile launcher"
		uDef.weapondefs.armvtol_missile.weaponacceleration = 350
		uDef.weapondefs.armvtol_missile.canattackground = true
		uDef.weapondefs.armvtol_missile.damage = {
			default = 64,
			vtol = 200,
		}
		uDef.weapons[1].onlytargetcategory = "NOTSUB"
	end
	if name == "armada_cyclone2" then
		uDef.metalcost = 450
		uDef.energycost = 6500
		uDef.buildtime = 10000
		uDef.speed = 150
		uDef.maxacc = 0.8
		uDef.maxrudder = 0.02
		uDef.maxbank = 0.15
		--uDef.maxpitch = 0.02
		--uDef.maxelevator = 0.02
		uDef.health = 2250
		uDef.sightdistance = 460
		uDef.cruisealtitude = 110
		--uDef.turnradius = 128
		uDef.weapondefs.armada_cyclone_weapon.proximitypriority = 0
		uDef.weapondefs.armada_cyclone_weapon.flighttime = 1.4
		uDef.weapondefs.armada_cyclone_weapon.range = 650
		uDef.weapondefs.armada_cyclone_weapon.burst = 4
		uDef.weapondefs.armada_cyclone_weapon.burstrate = 0.15
		uDef.weapondefs.armada_cyclone_weapon.explosiongenerator = "custom:genericshellexplosion-medium-bomb"
		uDef.weapondefs.armada_cyclone_weapon.smokePeriod = 7
		uDef.weapondefs.armada_cyclone_weapon.smoketime = 48
		uDef.weapondefs.armada_cyclone_weapon.smokesize = 10
		uDef.weapondefs.armada_cyclone_weapon.smoketrail = true
		uDef.weapondefs.armada_cyclone_weapon.areaofeffect = 200
		uDef.weapondefs.armada_cyclone_weapon.reloadtime = 3
		uDef.weapondefs.armada_cyclone_weapon.startvelocity = 180
		uDef.weapondefs.armada_cyclone_weapon.tolerance = 1000
		uDef.weapondefs.armada_cyclone_weapon.turnrate = 4000
		uDef.weapondefs.armada_cyclone_weapon.weaponacceleration = 450
		uDef.weapondefs.armada_cyclone_weapon.weaponvelocity = 1000
		uDef.weapondefs.armada_cyclone_weapon.wobble = 5
		uDef.weapondefs.armada_cyclone_weapon.dance = 30
		uDef.weapondefs.armada_cyclone_weapon.damage = {
			default = 1,
			vtol = 180,
		}
	end
	if name == "armada_oracle" then
		uDef.metalcost = uDef.metalcost * 1.15 + uDef.energycost / 70 * 0.15 - (uDef.metalcost * 1.15 + uDef.energycost / 70 * 0.15)%1
		uDef.speed = uDef.speed * 0.7
		uDef.maxrudder = 0.017
		uDef.maxbank = 0.66
		uDef.health = 1040
		uDef.maxacc = 0.4
		uDef.cruisealtitude = 250
	end
	if name == "armada_blink" then
		uDef.metalcost = uDef.metalcost * 1.15 + uDef.energycost / 70 * 0.15 - (uDef.metalcost * 1.15 + uDef.energycost / 70 * 0.15)%1
		uDef.health = 133
		uDef.speed = uDef.speed * 0.7
		uDef.maxrudder = 0.024
		uDef.maxbank = 0.66
		uDef.maxacc = 0.4
		uDef.cruisealtitude = 120
	end
	if name == "cortex_condor" then
		uDef.metalcost = uDef.metalcost * 1.15 + uDef.energycost / 70 * 0.15 - (uDef.metalcost * 1.15 + uDef.energycost / 70 * 0.15)%1
		uDef.speed = uDef.speed * 0.7
		uDef.maxrudder = 0.017
		uDef.maxbank = 0.66
		uDef.health = 1140
		uDef.maxacc = 0.4
		uDef.cruisealtitude = 250
	end
	if name == "corfink" then
		uDef.metalcost = uDef.metalcost * 1.15 + uDef.energycost / 70 * 0.15 - (uDef.metalcost * 1.15 + uDef.energycost / 70 * 0.15)%1
		uDef.health = 150
		uDef.speed = uDef.speed * 0.7
		uDef.maxrudder = 0.024
		uDef.maxbank = 0.66
		uDef.maxacc = 0.4
	end
	if name == "cortex_watcher" then
		uDef.metalcost = uDef.metalcost * 1.15 + uDef.energycost / 70 * 0.15 - (uDef.metalcost * 1.15 + uDef.energycost / 70 * 0.15)%1
		uDef.speed = uDef.speed * 0.7
		uDef.maxrudder = 0.015
		uDef.maxbank = 0.66
		uDef.maxacc = 0.4
		uDef.cruisealtitude = 220
	end
	if name == "armada_horizon" then
		uDef.metalcost = uDef.metalcost * 1.15 + uDef.energycost / 70 * 0.15 - (uDef.metalcost * 1.15 + uDef.energycost / 70 * 0.15)%1
		uDef.speed = uDef.speed * 0.7
		uDef.maxrudder = 0.015
		uDef.maxbank = 0.66
		uDef.maxacc = 0.4
		uDef.cruisealtitude = 220
	end
	if name == "cortex_nighthawk" then
		uDef.metalcost = 200
		uDef.energycost = 5500
		uDef.buildtime = uDef.buildtime * 1.15
		uDef.maxaileron = 0.02
		uDef.maxacc = 0.78
		uDef.maxdec = 0.11
		uDef.speed = 250
		uDef.maxrudder = 0.018
		uDef.maxbank = 0.65
		uDef.health = 600
		uDef.sightdistance = 550
		uDef.cruisealtitude = 220
		uDef.weapondefs.corvtol_advmissile.impactonly = 0
		uDef.weapondefs.corvtol_advmissile.proximitypriority = 0
		uDef.weapondefs.corvtol_advmissile.areaofeffect = 64
		uDef.weapondefs.corvtol_advmissile.flighttime = 2.4
		uDef.weapondefs.corvtol_advmissile.range = 1050
		uDef.weapondefs.corvtol_advmissile.reloadtime = 1.15
		uDef.weapondefs.corvtol_advmissile.startvelocity = 170
		uDef.weapondefs.corvtol_advmissile.tolerance = 15500
		uDef.weapondefs.corvtol_advmissile.turnrate = 27000
		uDef.weapondefs.corvtol_advmissile.weaponacceleration = 350
		uDef.weapondefs.corvtol_advmissile.damage = {
			default = 1,
			vtol = 340,
		}
	end
	if name == "cortex_valiant" then
		uDef.metalcost = 125
		uDef.energycost = 3700
		uDef.buildtime = 4350
		uDef.speed = 188
		uDef.maxacc = 0.36
		uDef.maxrudder = 0.013
		uDef.maxbank = 0.65
		uDef.health = 290
		uDef.sightdistance = 460
		uDef.cruisealtitude = 110
		uDef.weapondefs.corvtol_missile.explosiongenerator = "custom:genericshellexplosion-tiny"
		uDef.weapondefs.corvtol_missile.smokePeriod = 8
		uDef.weapondefs.corvtol_missile.smoketime = 14
		uDef.weapondefs.corvtol_missile.smokesize = 5.0
		uDef.weapondefs.corvtol_missile.smokecolor = 0.66
		uDef.weapondefs.corvtol_missile.cegtag = "missiletrailtiny"
		uDef.weapondefs.corvtol_missile.proximitypriority = 0
		uDef.weapondefs.corvtol_missile.flighttime = 1.7
		uDef.weapondefs.corvtol_missile.range = 530
		uDef.weapondefs.corvtol_missile.reloadtime = 3
		uDef.weapondefs.corvtol_missile.startvelocity = 110
		uDef.weapondefs.corvtol_missile.tolerance = 11000
		uDef.weapondefs.corvtol_missile.turnrate = 23000
		uDef.weapondefs.corvtol_missile.weaponacceleration = 350
		uDef.weapondefs.corvtol_missile.canattackground = true
		uDef.weapondefs.corvtol_missile.name = "Light guided a2a/a2g missile launcher"
		uDef.weapondefs.corvtol_missile.damage = {
			default = 64,
			vtol = 200,
		}
		uDef.weapons[1].onlytargetcategory = "NOTSUB"
	end
	if name == "cortex_bat2" then
		uDef.metalcost = 520
		uDef.energycost = 8000
		uDef.buildtime = 11000
		uDef.speed = 138
		uDef.maxacc = 0.8
		uDef.maxrudder = 0.025
		uDef.maxbank = 0.15
		--uDef.maxpitch = 0.02
		--uDef.maxelevator = 0.02
		uDef.health = 2450
		uDef.sightdistance = 460
		uDef.cruisealtitude = 110
		uDef.turnradius = 128
		uDef.weapondefs.cortex_bat_weapon.proximitypriority = -1
		uDef.weapondefs.cortex_bat_weapon.flighttime = 1.7
		uDef.weapondefs.cortex_bat_weapon.range = 680
		uDef.weapondefs.cortex_bat_weapon.areaofeffect = 200
		uDef.weapondefs.cortex_bat_weapon.edgeeffectiveness = 0.55
		uDef.weapondefs.cortex_bat_weapon.reloadtime = 6.1
		uDef.weapondefs.cortex_bat_weapon.startvelocity = 100
		uDef.weapondefs.cortex_bat_weapon.tolerance = 12500
		uDef.weapondefs.cortex_bat_weapon.turnrate = 19000
		uDef.weapondefs.cortex_bat_weapon.weaponacceleration = 250
		uDef.weapondefs.cortex_bat_weapon.cegtag = "missiletraillarge-red"
		uDef.weapondefs.cortex_bat_weapon.explosiongenerator = "custom:genericshellexplosion-large-bomb"
		uDef.weapondefs.cortex_bat_weapon.model = "banishermissile.s3o"
		uDef.weapondefs.cortex_bat_weapon.smoketrail = true
		uDef.weapondefs.cortex_bat_weapon.smokePeriod = 7
		uDef.weapondefs.cortex_bat_weapon.smoketime = 48
		uDef.weapondefs.cortex_bat_weapon.smokesize = 11.3
		uDef.weapondefs.cortex_bat_weapon.smokecolor = 0.82
		uDef.weapondefs.cortex_bat_weapon.soundhit = "cortex_banisher_b"
		uDef.weapondefs.cortex_bat_weapon.soundhitwet = "splsmed"
		uDef.weapondefs.cortex_bat_weapon.soundstart = "cortex_banisher_a"
		uDef.weapondefs.cortex_bat_weapon.texture1 = "null"
		uDef.weapondefs.cortex_bat_weapon.texture2 = "railguntrail"
		uDef.weapondefs.cortex_bat_weapon.weaponvelocity = 650
		uDef.weapondefs.cortex_bat_weapon.damage = {
			default = 1,
			vtol = 1000,
		}
	end
	if name == "armada_roughneck" or name == "armada_banshee" or name == "armada_abductor" or name == "armada_stork" or name == "cortex_hercules" or name == "cortex_skyhook"  or name == "cortex_wasp" then
		uDef.health = uDef.health * 1.5
		uDef.speed = uDef.speed * 0.75
		uDef.turnrate = uDef.turnrate * 1.5
		uDef.cruisealtitude = 100
		uDef.buildtime = uDef.buildtime * 0.8
	end
	if name == "armada_banshee" then
		uDef.weapondefs.med_emg.burstrate = 0.08
		uDef.weapondefs.med_emg.reloadtime = 1.15
	end
	if name == "cortex_dragonold" or name == "cortex_dragon" then
		uDef.health = uDef.health * 1.5
		uDef.speed = uDef.speed * 0.75
		--uDef.turnrate = uDef.turnrate * 1.5
		uDef.cruisealtitude = 80
	end
	if name == "armada_constructionaircraft" or name == "armada_advancedconstructionaircraft" or name == "cortex_constructionaircraft" or name == "cortex_constructionseaplane" or name == "armada_constructionseaplane" or name == "cortex_advancedconstructionaircraft" then
		uDef.health = uDef.health * 1.5
		uDef.speed = uDef.speed * 0.75
		uDef.turnrate = uDef.turnrate * 1.5
		uDef.workertime = (uDef.workertime * 7/6) - (uDef.workertime * 7/6 - 5)%5
		uDef.metalcost = uDef.metalcost * 7/6 - (uDef.metalcost * 7/6)%1
	end
	if name == "cortex_shuriken" then
		uDef.health = 105
		uDef.speed = 210
		uDef.cruisealtitude = 80
	end
	if name == "armada_puffin" or name == "cortex_monsoon" then
		uDef.health = uDef.health * 1.5
		uDef.speed = uDef.speed * 0.65
		uDef.turnrate = uDef.turnrate * 1.5
	end
	if  name == "armada_sabre" then
		uDef.health = uDef.health * 1.5
		uDef.speed = uDef.speed * 0.65
		--uDef.turnrate = uDef.turnrate * 1.5
		uDef.cruisealtitude = 100
		uDef.weapondefs.vtol_emg2.range = 740
		uDef.weapondefs.vtol_emg2.reloadtime = 3.1
		uDef.airStrafe = false
		uDef.weapondefs.vtol_emg2.damage = {
			default = 120,
			vtol = 20,
		}
	end
	if name == "cortex_cutlass" then
		uDef.health = uDef.health * 2
		uDef.metalcost = 370
		uDef.energycost = 9500
		uDef.buildtime = 14500
		uDef.speed = uDef.speed * 0.6
		--uDef.turnrate = uDef.turnrate * 1.5
		uDef.cruisealtitude = 100
		uDef.weapondefs.vtol_rocket2.range = 690
		uDef.airStrafe = false
		uDef.weapondefs.vtol_rocket2.areaofeffect = 72
		uDef.weapondefs.vtol_rocket2.reloadtime = 9.5
		uDef.weapondefs.vtol_rocket2.sprayangle = 1700
		uDef.weapondefs.vtol_rocket2.burst = 4
		uDef.weapondefs.vtol_rocket2.burstrate = 0.15
		uDef.weapondefs.vtol_rocket2.explosiongenerator = "custom:genericshellexplosion-medium"
		uDef.weapondefs.vtol_rocket2.weaponvelocity = 550
		uDef.weapondefs.vtol_rocket2.damage = {
			default = 140,
			vtol = 28,
		}
	end
	if name == "armada_hornet" then
		uDef.health = uDef.health * 1.5
		uDef.speed = uDef.speed * 0.75
		uDef.turnrate = uDef.turnrate * 1.5
		uDef.cruisealtitude = 100
		uDef.weapondefs.vtol_sabot.areaofeffect = 64
		uDef.weapondefs.vtol_sabot.reloadtime = 6.6
		uDef.weapondefs.vtol_sabot.range = 630
		uDef.weapondefs.vtol_sabot.startvelocity = 170
		uDef.weapondefs.vtol_sabot.damage = {
			default = 500,
		}
	end
	if name == "cortex_wasp" then
		uDef.weapondefs.vtol_rocket.turnrate = 15000
	end
	if name == "cortex_angler" or name == "cortex_whirlwind" or name == "armada_stormbringer" or name == "armada_liche" or name == "armada_stiletto" or name == "armada_cormorant" then
		uDef.metalcost = uDef.metalcost * 1.15 + uDef.energycost / 70 * 0.15 - (uDef.metalcost * 1.15 + uDef.energycost / 70 * 0.15)%1
		uDef.speed = uDef.speed * 0.65
		uDef.maxacc = uDef.maxacc * 1.3
		uDef.maxbank = 0.65
		uDef.maxrudder = uDef.maxrudder * 2.2
		uDef.health = uDef.health * 1.6
		uDef.sightdistance = 550
		uDef.cruisealtitude = 120
	end
	if name == "cortex_hailstorm" then
		uDef.metalcost = uDef.metalcost * 1.3 + uDef.energycost / 70 * 0.3 - (uDef.metalcost * 1.3 + uDef.energycost / 70 * 0.3)%1
		uDef.speed = uDef.speed * 0.55
		uDef.maxbank = 0.5
		uDef.maxrudder = uDef.maxrudder * 2
		uDef.maxaileron = uDef.maxaileron *0.7
		uDef.health = uDef.health * 2.3
		uDef.sightdistance = 520
		uDef.weapondefs.coradvbomb.burstrate = 0.26
		uDef.weapondefs.coradvbomb.damage = {
			default = 500
		}
	end
	if name == "armada_blizzard" then
		uDef.metalcost = uDef.metalcost * 1.3 + uDef.energycost / 70 * 0.3 - (uDef.metalcost * 1.3 + uDef.energycost / 70 * 0.3)%1
		uDef.speed = uDef.speed * 0.55
		uDef.maxbank = 0.5
		uDef.maxrudder = uDef.maxrudder * 2
		uDef.maxaileron = uDef.maxaileron *0.7
		uDef.health = uDef.health * 2.3
		uDef.sightdistance = 520
		uDef.weapondefs.armadvbomb.burstrate = 0.35
		uDef.weapondefs.armadvbomb.burst = 6
		uDef.weapondefs.armadvbomb.areaofeffect = 220
	end
	if name == "cortex_dambuster" or name == "armada_tsunami" then
		uDef.metalcost = uDef.metalcost * 1.15 + uDef.energycost / 70 * 0.15 - (uDef.metalcost * 1.15 + uDef.energycost / 70 * 0.15)%1
		uDef.speed = uDef.speed * 0.78
		uDef.maxacc = 0.35
		uDef.maxbank = 0.68
		uDef.maxrudder = uDef.maxrudder * 2.5
		uDef.health = uDef.health * 1.4
		uDef.sightdistance = 720
		uDef.cruisealtitude = 120
	end
	if name == "armada_advancedaircraftplant" then
		local numBuildoptions = #uDef.buildoptions
		uDef.buildoptions[numBuildoptions+1] = "armada_tsunami"
		uDef.buildoptions[numBuildoptions+2] = "armada_cyclone2"
		uDef.buildoptions[numBuildoptions+3] = "armada_sabre"
		uDef.buildoptions[numBuildoptions+4] = "armada_puffin"
	end
	if name == "cortex_advancedaircraftplant" then
		local numBuildoptions = #uDef.buildoptions
		uDef.buildoptions[numBuildoptions+1] = "cortex_dambuster"
		uDef.buildoptions[numBuildoptions+2] = "cortex_bat2"
		uDef.buildoptions[numBuildoptions+3] = "cortex_cutlass"
		uDef.buildoptions[numBuildoptions+4] = "cortex_monsoon"
	end
	if name == "cortex_seaplaneplatform" then
		uDef.buildoptions[5] = "cortex_bat2"
	end
	if name == "armada_seaplaneplatform" then
		uDef.buildoptions[5] = "armada_cyclone2"
	end
	if name == "armada_nettle" then
		uDef.weapondefs.armada_nettle_missile.startvelocity = 111
		uDef.weapondefs.armada_nettle_missile.flighttime = 2.6
	end
	if name == "armada_navalnettle" then
		uDef.weapondefs.armada_nettle_missile.startvelocity = 111
		uDef.weapondefs.armada_nettle_missile.flighttime = 2.6
		uDef.weapondefs.armada_nettle_missile.weaponacceleration = 200
	end
	if name == "cortex_slingshot" then
		uDef.weapondefs.armada_nettle_missile.startvelocity = 111
		uDef.weapondefs.armada_nettle_missile.flighttime = 2.6
		uDef.weapondefs.armada_nettle_missile.weaponacceleration = 200
	end
	if name == "cortex_thistle" then
		uDef.weapondefs.cortex_thistle_missile.startvelocity = 111
		uDef.weapondefs.cortex_thistle_missile.flighttime = 2.6
	end
	if name == "armada_ferret" then
		uDef.weapondefs.ferret_missile.areaofeffect = 48
		uDef.weapondefs.ferret_missile.startvelocity = 120
		uDef.weapondefs.ferret_missile.weaponacceleration = 210
		uDef.weapondefs.ferret_missile.weaponvelocity = 1100
	end
	if name == "cortex_sam" then
		uDef.weapondefs.madsam_missile.areaofeffect = 48
		uDef.weapondefs.madsam_missile.startvelocity = 120
		uDef.weapondefs.madsam_missile.weaponacceleration = 210
		uDef.weapondefs.madsam_missile.weaponvelocity = 1100
	end
	if name == "armada_mercury" then
		uDef.weapondefs.arm_advsam.startvelocity = 140
		uDef.weapondefs.arm_advsam.stockpile = false
		uDef.weapondefs.arm_advsam.reloadtime = 25
		uDef.weapondefs.arm_advsam.weaponacceleration = 760
		uDef.weapondefs.arm_advsam.energypershot = 0
		uDef.weapondefs.arm_advsam.flighttime = 2.5
		uDef.weapondefs.arm_advsam.damage.vtol = 1500
	end
	if name == "cortex_screamer" then
		uDef.weapondefs.cor_advsam.startvelocity = 140
		uDef.weapondefs.cor_advsam.stockpile = false
		uDef.weapondefs.cor_advsam.reloadtime = 25
		uDef.weapondefs.cor_advsam.weaponacceleration = 760
		uDef.weapondefs.cor_advsam.energypershot = 0
		uDef.weapondefs.cor_advsam.flighttime = 2.5
		uDef.weapondefs.cor_advsam.damage.vtol = 1500
	end
	if name == "armada_chainsaw" then
		uDef.weapondefs.arm_cir.startvelocity = 100
		uDef.weapondefs.arm_cir.weaponvelocity = 1050
		uDef.weapondefs.arm_cir.flighttime = 2.7
	end
	if name == "cortex_eradicator" then
		uDef.weapondefs.cor_erad.startvelocity = 100
		uDef.weapondefs.cor_erad.weaponvelocity = 1050
		uDef.weapondefs.cor_erad.flighttime = 2.7
	end
	if name == "armada_crossbow" then
		uDef.weapondefs.armbot_missile.startvelocity = 130
		uDef.weapondefs.armbot_missile.weaponacceleration = 230
		uDef.weapondefs.armbot_missile.flighttime = 2.4
	end
	if name == "cortex_trasher" then
		uDef.weapondefs.corbot_missile.startvelocity = 130
		uDef.weapondefs.corbot_missile.weaponacceleration = 230
		uDef.weapondefs.corbot_missile.flighttime = 2.4
	end
	if name == "armada_archangel" then
		uDef.health = uDef.health * 2
		uDef.weapondefs.armaabot_missile1.range = 1300
		uDef.weapondefs.armaabot_missile1.reloadtime = 1.5
		uDef.weapondefs.armaabot_missile1.startvelocity = 130
		uDef.weapondefs.armaabot_missile1.weaponacceleration = 320
		uDef.weapondefs.armaabot_missile1.flighttime = 2.55
		uDef.weapondefs.armaabot_missile2.startvelocity = 110
		uDef.weapondefs.armaabot_missile2.weaponacceleration = 300
		uDef.weapondefs.armaabot_missile2.flighttime = 2.4
		uDef.weapondefs.armaabot_missile2.reloadtime = 1.4
		uDef.weapondefs.armaabot_missile2.range = 880
		uDef.weapons[5].def = ""
	end
	if name == "cortex_manticore" then
		uDef.health = uDef.health * 2
		uDef.weapondefs.coraabot_missile4.range = 1400
		uDef.weapondefs.coraabot_missile4.reloadtime = 1.6
		uDef.weapondefs.coraabot_missile4.startvelocity = 130
		uDef.weapondefs.coraabot_missile4.weaponacceleration = 320
		uDef.weapondefs.coraabot_missile4.flighttime = 2.55
		uDef.weapondefs.coraabot_missile3.range = 970
		uDef.weapondefs.coraabot_missile3.reloadtime = 1.2
		uDef.weapondefs.coraabot_missile3.startvelocity = 110
		uDef.weapondefs.coraabot_missile3.weaponacceleration = 300
		uDef.weapondefs.coraabot_missile3.flighttime = 2.4
		uDef.weapondefs.coraabot_missile2.range = 870
		uDef.weapondefs.coraabot_missile2.startvelocity = 100
		uDef.weapondefs.coraabot_missile2.weaponacceleration = 290
		uDef.weapondefs.coraabot_missile2.flighttime = 2.4
		uDef.weapondefs.coraabot_missile2.reloadtime = 1
		uDef.weapons[6].def = ""
	end
	if name == "armada_shredder" then
		uDef.weapondefs.mobileflak.weaponvelocity = 1000
	end
	if name == "cortex_fury" then
		uDef.weapondefs.mobileflak.weaponvelocity = 1000
	end
	if name == "armada_arbalest" then
		uDef.weapondefs.armada_arbalest_gun.weaponvelocity = 1100
	end
	if name == "cortex_birdshot" then
		uDef.weapondefs.armada_arbalest_gun.weaponvelocity = 1100
	end
	if name == "armada_whistler" then
		uDef.weapondefs.armtruck_missile.startvelocity = 135
		uDef.weapondefs.armtruck_missile.weaponacceleration = 230
		uDef.weapondefs.armtruck_missile.damage.vtol = 200
	end
	if name == "cortex_lasher" then
		uDef.weapondefs.cortruck_missile.startvelocity = 135
		uDef.weapondefs.cortruck_missile.weaponacceleration = 230
		uDef.weapondefs.cortruck_missile.damage.vtol = 150
	end
	if name == "cortex_herring" then
		uDef.weapondefs.cortruck_missile.startvelocity = 135
		uDef.weapondefs.cortruck_missile.weaponacceleration = 250
		uDef.weapondefs.cortruck_missile.damage.vtol = 150
	end
	if name == "armada_skater" then
		uDef.weapondefs.aamissile.startvelocity = 140
		uDef.weapondefs.aamissile.weaponacceleration = 270
		uDef.weapondefs.aamissile.flighttime = 2.1
	end
	if name == "cortex_navalbirdshot" then
		uDef.weapondefs.armada_arbalest_gun.weaponvelocity = 1100
	end
	if name == "armada_navalarbalest" then
		uDef.weapondefs.armada_arbalest_gun.weaponvelocity = 1100
	end
	if name == "armada_jaguar" then
		uDef.weapondefs.armada_amphibiousbot_missile.startvelocity = 150
		uDef.weapondefs.armada_amphibiousbot_missile.weaponacceleration = 250
		uDef.weapondefs.armada_amphibiousbot_missile.flighttime = 2
	end
	if name == "armada_amphibiousbot" then
		uDef.weapondefs.armada_amphibiousbot_missile.startvelocity = 150
		uDef.weapondefs.armada_amphibiousbot_missile.weaponacceleration = 250
		uDef.weapondefs.armada_amphibiousbot_missile.flighttime = 2
	end
	if name == "armada_marauder" then
		uDef.weapondefs.armada_amphibiousbot_missile.startvelocity = 150
		uDef.weapondefs.armada_amphibiousbot_missile.weaponacceleration = 250
		uDef.weapondefs.armada_amphibiousbot_missile.flighttime = 2
	end
	if name == "armada_dragonslayer" then
		uDef.weapondefs.ga2.startvelocity = 150
		uDef.weapondefs.ga2.weaponacceleration = 230
		uDef.weapondefs.ga2.flighttime = 2.5
		uDef.weapondefs.mobileflak.weaponvelocity = 1000
	end
	if name == "cortex_arrowstorm" then
		uDef.weapondefs.ga2.startvelocity = 150
		uDef.weapondefs.ga2.weaponacceleration = 230
		uDef.weapondefs.ga2.flighttime = 2.5
		uDef.weapondefs.mobileflak.weaponvelocity = 1000
	end
end

-- Skyshift: Air rework
if Spring.GetModOptions().skyshift == true then
	skyshiftUnits = VFS.Include("units/other/Skyshift/skyshiftunits_post.lua")
	uDef = skyshiftUnits.skyshiftUnitTweaks(name, uDef)
end

--Lategame Rebalance
if Spring.GetModOptions().lategame_rebalance == true then
	if name == "armada_rattlesnake" then
		uDef.weapondefs.armada_rattlesnake_gun.reloadtime = 2
		uDef.weapondefs.armada_rattlesnake_gun_high.reloadtime = 7.7
	end
	if name == "cortex_persecutor" then
		uDef.weapondefs.cortex_persecutor_gun.reloadtime = 2.35
		uDef.weapondefs.cortex_persecutor_gun_high.reloadtime = 8.8
	end
	if name == "armada_pitbull" then
		uDef.weapondefs.armada_pitbull_weapon.reloadtime = 1.7
		uDef.weapondefs.armada_pitbull_weapon.range = 700
	end
	if name == "cortex_scorpion" then
		uDef.weapondefs.vipersabot.reloadtime = 2.1
		uDef.weapondefs.vipersabot.range = 700
	end
	if name == "armada_pulsar" then
		uDef.metalcost = 4000
		uDef.energycost = 85000
		uDef.buildtime = 59000
	end
	if name == "cortex_cerberus" then
		uDef.metalcost = 3600
		uDef.energycost = 40000
		uDef.buildtime = 70000
	end
	if name == "armada_basilica" then
		uDef.metalcost = 5000
		uDef.energycost = 71000
		uDef.buildtime = 94000
	end
	if name == "cortex_basilisk" then
		uDef.metalcost = 5100
		uDef.energycost = 74000
		uDef.buildtime = 103000
	end
	if name == "armada_ragnarok" then
		uDef.metalcost = 75600
		uDef.energycost = 902400
		uDef.buildtime = 1680000
	end
	if name == "cortex_calamity" then
		uDef.metalcost = 73200
		uDef.energycost = 861600
		uDef.buildtime = 1680000
	end
	if name == "armada_marauder" then
		uDef.metalcost = 1070
		uDef.energycost = 23000
		uDef.buildtime = 28700
	end
	if name == "armada_razorback" then
		uDef.metalcost = 4200
		uDef.energycost = 75000
		uDef.buildtime = 97000
	end
	if name == "armada_thor" then
		uDef.metalcost = 9450
		uDef.energycost = 255000
		uDef.buildtime = 265000
	end
	if name == "cortex_shiva" then
		uDef.metalcost = 1800
		uDef.energycost = 26500
		uDef.buildtime = 35000
		uDef.speed = 50.8
		uDef.weapondefs.shiva_rocket.tracks = true
		uDef.weapondefs.shiva_rocket.turnrate = 7500
	end
	if name == "cortex_karganeth" then
		uDef.metalcost = 2625
		uDef.energycost = 60000
		uDef.buildtime = 79000
	end
	if name == "cortex_demon" then
		uDef.metalcost = 6300
		uDef.energycost = 94500
		uDef.buildtime = 94500
	end
	if name == "armada_stiletto" then
		uDef.health = 1300
		uDef.weapondefs.stiletto_bomb.burst = 3
		uDef.weapondefs.stiletto_bomb.burstrate = 0.2333
		uDef.weapondefs.stiletto_bomb.damage = {
			default = 3000
		}
	end
	if name == "armada_cormorant" then
		uDef.health = 1750
	end
	if name == "cortex_angler" then
		uDef.health = 1800
	end
	if name == "armada_shredder" then
		uDef.weapondefs.mobileflak.reloadtime = 0.8333
	end
	if name == "cortex_fury" then
		uDef.weapondefs.mobileflak.reloadtime = 0.8333
	end
	if name == "armada_dragonslayer" then
		uDef.weapondefs.mobileflak.reloadtime = 0.8333
	end
	if name == "cortex_arrowstorm" then
		uDef.weapondefs.mobileflak.reloadtime = 0.8333
	end
	if name == "armada_arbalest" then
		uDef.weapondefs.armada_arbalest_gun.reloadtime = 0.6
	end
	if name == "cortex_birdshot" then
		uDef.weapondefs.armada_arbalest_gun.reloadtime = 0.6
	end
	if name == "armada_mercury" then
		uDef.weapondefs.arm_advsam.reloadtime = 11
		uDef.weapondefs.arm_advsam.stockpile = false
	end
	if name == "cortex_screamer" then
		uDef.weapondefs.cor_advsam.reloadtime = 11
		uDef.weapondefs.cor_advsam.stockpile = false
	end
	if name == "armada_falcon" then
		uDef.metalcost = 77
		uDef.energycost = 3100
		uDef.buildtime = 3700
	end
	if name == "armada_cyclone" then
		uDef.metalcost = 95
		uDef.energycost = 4750
		uDef.buildtime = 5700
	end
	if name == "armada_highwind" then
		uDef.metalcost = 155
		uDef.energycost = 6300
		uDef.buildtime = 9800
	end
	if name == "cortex_valiant" then
		uDef.metalcost = 77
		uDef.energycost = 3000
		uDef.buildtime = 3600
	end
	if name == "cortex_bat" then
		uDef.metalcost = 95
		uDef.energycost = 4850
		uDef.buildtime = 5400
	end
	if name == "cortex_nighthawk" then
		uDef.metalcost = 150
		uDef.energycost = 5250
		uDef.buildtime = 9250
	end
end
	-- Multipliers Modoptions

	-- Health
	if uDef.health then
		local x = modOptions.multiplier_maxdamage
		if x ~= 1 then
			if uDef.health*x > 15000000 then
				uDef.health = 15000000
			else
				uDef.health = uDef.health*x
			end
			if uDef.autoheal then
				uDef.autoheal = uDef.autoheal*x
			end
			if uDef.idleautoheal then
				uDef.idleautoheal = uDef.idleautoheal*x
			end
		end
	end

	-- Max Speed
	if uDef.speed then
		local x = modOptions.multiplier_maxvelocity
		if x ~= 1 then
			uDef.speed = uDef.speed*x
			if uDef.maxdec  then
				uDef.maxdec  = uDef.maxdec *((x-1)/2 + 1)
			end
			if uDef.maxacc then
				uDef.maxacc= uDef.maxacc*((x-1)/2 + 1)
			end
		end
	end

	-- Turn Speed
	if uDef.turnrate then
		local x = modOptions.multiplier_turnrate
		if x ~= 1 then
			uDef.turnrate = uDef.turnrate*x
		end
	end

	-- Build Distance
	if uDef.builddistance then
		local x = modOptions.multiplier_builddistance
		if x ~= 1 then
			uDef.builddistance = uDef.builddistance*x
		end
	end

	-- Buildpower
	if uDef.workertime then
		local x = modOptions.multiplier_buildpower
		if x ~= 1 then
			uDef.workertime = uDef.workertime*x
		end

		-- increase terraformspeed to be able to restore ground faster
		uDef.terraformspeed = uDef.workertime * 30
	end

	-- Unit Cost
	if uDef.metalcost then
		local x = modOptions.multiplier_metalcost
		if x ~= 1 then
			uDef.metalcost = math.min(uDef.metalcost*x, 16000000)
		end
	end
	if uDef.energycost then
		local x = modOptions.multiplier_energycost
		if x ~= 1 then
			uDef.energycost = math.min(uDef.energycost*x, 16000000)
		end
	end
	if uDef.buildtime then
		local x = modOptions.multiplier_buildtimecost
		if x ~= 1 then
			uDef.buildtime = math.min(uDef.buildtime*x, 16000000)
		end
	end



	--energystorage
	--metalstorage
	-- Metal Extraction Multiplier
	if (uDef.extractsmetal and uDef.extractsmetal > 0) and (uDef.customparams.metal_extractor and uDef.customparams.metal_extractor > 0) then
		local x = modOptions.multiplier_metalextraction * modOptions.multiplier_resourceincome
		uDef.extractsmetal = uDef.extractsmetal * x
		uDef.customparams.metal_extractor = uDef.customparams.metal_extractor * x
		if uDef.metalstorage then
			uDef.metalstorage = uDef.metalstorage * x
		end
	end

	-- Energy Production Multiplier
	if uDef.energymake then
		local x = modOptions.multiplier_energyproduction * modOptions.multiplier_resourceincome
		uDef.energymake = uDef.energymake * x
		if uDef.energystorage then
			uDef.energystorage = uDef.energystorage * x
		end
	end
	if uDef.windgenerator and uDef.windgenerator > 0 then
		local x = modOptions.multiplier_energyproduction * modOptions.multiplier_resourceincome
		uDef.windgenerator = uDef.windgenerator * x
		if uDef.customparams.energymultiplier then
			uDef.customparams.energymultiplier = tonumber(uDef.customparams.energymultiplier) * x
		else
			uDef.customparams.energymultiplier = x
		end
		if uDef.energystorage then
			uDef.energystorage = uDef.energystorage * x
		end
	end
	if uDef.tidalgenerator then
		local x = modOptions.multiplier_energyproduction * modOptions.multiplier_resourceincome
		uDef.tidalgenerator = uDef.tidalgenerator * x
		if uDef.energystorage then
			uDef.energystorage = uDef.energystorage * x
		end
	end
	if name == "armada_solarcollector" or name == "cortex_solarcollector" then -- special case
		local x = modOptions.multiplier_energyproduction * modOptions.multiplier_resourceincome
		uDef.energyupkeep = uDef.energyupkeep * x
		if uDef.energystorage then
			uDef.energystorage = uDef.energystorage * x
		end
	end

	-- Energy Conversion Multiplier
	if uDef.customparams.energyconv_capacity and uDef.customparams.energyconv_efficiency then
		local x = modOptions.multiplier_energyconversion * modOptions.multiplier_resourceincome
		--uDef.customparams.energyconv_capacity = uDef.customparams.energyconv_capacity * x
		uDef.customparams.energyconv_efficiency = uDef.customparams.energyconv_efficiency * x
		if uDef.metalstorage then
			uDef.metalstorage = uDef.metalstorage * x
		end
		if uDef.energystorage then
			uDef.energystorage = uDef.energystorage * x
		end
	end

	-- Sensors range
	if uDef.sightdistance then
		local x = modOptions.multiplier_losrange
		if x ~= 1 then
			uDef.sightdistance = uDef.sightdistance*x
		end
	end

	if uDef.airsightdistance then
		local x = modOptions.multiplier_losrange
		if x ~= 1 then
			uDef.airsightdistance = uDef.airsightdistance*x
		end
	end

	if uDef.radardistance then
		local x = modOptions.multiplier_radarrange
		if x ~= 1 then
			uDef.radardistance = uDef.radardistance*x
		end
	end

	if uDef.sonardistance then
		local x = modOptions.multiplier_radarrange
		if x ~= 1 then
			uDef.sonardistance = uDef.sonardistance*x
		end
	end

	-- add model vertex displacement
	local vertexDisplacement = 5.5 + ((uDef.footprintx + uDef.footprintz) / 12)
	if vertexDisplacement > 10 then
		vertexDisplacement = 10
	end
	uDef.customparams.vertdisp = 1.0 * vertexDisplacement
	uDef.customparams.healthlookmod = 0
end

local function ProcessSoundDefaults(wd)
	local forceSetVolume = not wd.soundstartvolume or not wd.soundhitvolume or not wd.soundhitwetvolume
	if not forceSetVolume then
		return
	end

	local defaultDamage = wd.damage and wd.damage.default

	if not defaultDamage or defaultDamage <= 50 then
	-- old filter that gave small weapons a base-minumum sound volume, now fixed with noew math.min(math.max)
	-- if not defaultDamage then
		wd.soundstartvolume = 5
		wd.soundhitvolume = 5
		wd.soundhitwetvolume = 5
		return
	end

	local soundVolume = math.sqrt(defaultDamage * 0.5)

	if wd.weapontype == "LaserCannon" then
		soundVolume = soundVolume*0.5
	end

	if not wd.soundstartvolume then
		wd.soundstartvolume = soundVolume
	end
	if not wd.soundhitvolume then
		wd.soundhitvolume = soundVolume
	end
	if not wd.soundhitwetvolume then
		if wd.weapontype == "LaserCannon" or "BeamLaser" then
			wd.soundhitwetvolume = soundVolume * 0.3
		else
			wd.soundhitwetvolume = soundVolume * 1.4
		end
	end
end

-- process weapondef
function WeaponDef_Post(name, wDef)
	local modOptions = Spring.GetModOptions()

	if not SaveDefsToCustomParams then
		-------------- EXPERIMENTAL MODOPTIONS
		-- Standard Gravity
		local gravityModOption = modOptions.experimentalstandardgravity

		--Spring.Echo(wDef.name,wDef.mygravity)
		if gravityModOption == "low" then
			if wDef.mygravity == nil then
				wDef.mygravity = 0.0889 --80/900
			end
		elseif gravityModOption == "standard" then
			if wDef.mygravity == nil then
				wDef.mygravity = 0.1333 --120/900
			end
		elseif gravityModOption == "high" then
			if wDef.mygravity == nil then
				wDef.mygravity = 0.1667 --150/900
			end
		end


		----EMP rework

		if modOptions.emprework then

			if name == 'empblast' then
				wDef.areaofeffect = 350
				wDef.edgeeffectiveness = 0.6
				wDef.paralyzetime = 12
				wDef.damage.default = 50000
			end
			if name == 'spybombx' then
				wDef.areaofeffect = 350
				wDef.edgeeffectiveness = 0.30
				wDef.paralyzetime = 12
				wDef.damage.default = 20000
			end
			if name == 'spybombxscav' then
				wDef.edgeeffectiveness = 0.50
				wDef.paralyzetime = 12
				wDef.damage.default = 35000
			end


		end

		--Air rework
		if modOptions.air_rework == true then
			if wDef.weapontype == "BeamLaser" or wDef.weapontype == "LaserCannon" then
				wDef.damage.vtol = wDef.damage.default * 0.25
			end
			if wDef.range == 300 and wDef.reloadtime == 0.4 then --comm lasers
				wDef.damage.vtol = wDef.damage.default
			end
			if wDef.weapontype == "Cannon" and wDef.damage.default ~= nil then
				wDef.damage.vtol = wDef.damage.default * 0.35
			end
		end

		-- Skyshift: Air rework
		if Spring.GetModOptions().skyshift == true then
			skyshiftUnits = VFS.Include("units/other/Skyshift/skyshiftunits_post.lua")
			wDef = skyshiftUnits.skyshiftWeaponTweaks(name, wDef)
		end

		---- SHIELD CHANGES
		local shieldModOption = modOptions.experimentalshields

		if shieldModOption == "absorbplasma" then
			if wDef.shield and wDef.shield.repulser and wDef.shield.repulser ~= false then
				wDef.shield.repulser = false
			end
		elseif shieldModOption == "absorbeverything" then
			if wDef.shield and wDef.shield.repulser and wDef.shield.repulser ~= false then
				wDef.shield.repulser = false
			end
			if (not wDef.interceptedbyshieldtype) or wDef.interceptedbyshieldtype ~= 1 then
				wDef.interceptedbyshieldtype = 1
			end
		elseif shieldModOption == "bounceeverything" then
			if wDef.shield then
				wDef.shield.repulser = true
			end
			if (not wDef.interceptedbyshieldtype) or wDef.interceptedbyshieldtype ~= 1 then
				wDef.interceptedbyshieldtype = 1
			end
		end

		if modOptions.multiplier_shieldpower then
			if wDef.shield then
				local multiplier = modOptions.multiplier_shieldpower
				if wDef.shield.power then
					wDef.shield.power = wDef.shield.power*multiplier
				end
				if wDef.shield.powerregen then
					wDef.shield.powerregen = wDef.shield.powerregen*multiplier
				end
				if wDef.shield.powerregenenergy then
					wDef.shield.powerregenenergy = wDef.shield.powerregenenergy*multiplier
				end
				if wDef.shield.startingpower then
					wDef.shield.startingpower = wDef.shield.startingpower*multiplier
				end
			end
		end
		----------------------------------------

		--Use targetborderoverride in weapondef customparams to override this global setting
		--Controls whether the weapon aims for the center or the edge of its target's collision volume. Clamped between -1.0 - target the far border, and 1.0 - target the near border.
		if wDef.customparams and wDef.customparams.targetborderoverride == nil then
			wDef.targetborder = 1 --Aim for just inside the hitsphere
		elseif wDef.customparams and wDef.customparams.targetborderoverride ~= nil then
			wDef.targetborder = tonumber(wDef.customparams.targetborderoverride)
		end

		if wDef.craterareaofeffect then
			wDef.cratermult = (wDef.cratermult or 0) + wDef.craterareaofeffect/2000
		end

		-- Target borders of unit hitboxes rather than center (-1 = far border, 0 = center, 1 = near border)
		-- wDef.targetborder = 1.0

		if wDef.weapontype == "Cannon" then
			if not wDef.model then -- do not cast shadows on plasma shells
				wDef.castshadow = false
			end

			if wDef.stages == nil then
				wDef.stages = 10
				if wDef.damage ~= nil and wDef.damage.default ~= nil and wDef.areaofeffect ~= nil then
					wDef.stages = math.floor(7.5 + math.min(wDef.damage.default * 0.0033, wDef.areaofeffect * 0.13))
					wDef.alphadecay = 1 - ((1/wDef.stages)/1.5)
					wDef.sizedecay = 0.4 / wDef.stages
				end
			end
		end

		if modOptions.xmas and wDef.weapontype == "StarburstLauncher" and wDef.model and  VFS.FileExists('objects3d\\candycane_'..wDef.model) then
			wDef.model = 'candycane_'..wDef.model
		end

		-- prepared to strip these customparams for when we remove old deferred lighting widgets
		--if wDef.customparams then
		--	wDef.customparams.expl_light_opacity = nil
		--	wDef.customparams.expl_light_heat_radius = nil
		--	wDef.customparams.expl_light_radius = nil
		--	wDef.customparams.expl_light_color = nil
		--	wDef.customparams.expl_light_nuke = nil
		--	wDef.customparams.expl_light_skip = nil
		--	wDef.customparams.expl_light_heat_life_mult = nil
		--	wDef.customparams.expl_light_heat_radius_mult = nil
		--	wDef.customparams.expl_light_heat_strength_mult = nil
		--	wDef.customparams.expl_light_life = nil
		--	wDef.customparams.expl_light_life_mult = nil
		--	wDef.customparams.expl_noheatdistortion = nil
		--	wDef.customparams.light_skip = nil
		--	wDef.customparams.light_fade_time = nil
		--	wDef.customparams.light_fade_offset = nil
		--	wDef.customparams.light_beam_mult = nil
		--	wDef.customparams.light_beam_start = nil
		--	wDef.customparams.light_beam_mult_frames = nil
		--	wDef.customparams.light_camera_height = nil
		--	wDef.customparams.light_ground_height = nil
		--	wDef.customparams.light_color = nil
		--	wDef.customparams.light_radius = nil
		--	wDef.customparams.light_radius_mult = nil
		--	wDef.customparams.light_mult = nil
		--	wDef.customparams.fake_Weapon = nil
		--end

		if wDef.damage ~= nil then
			wDef.damage.indestructable = 0
		end

		if wDef.weapontype == "BeamLaser" then
			if wDef.beamttl == nil then
				wDef.beamttl = 3
				wDef.beamdecay = 0.7
			end
			if wDef.corethickness then
				wDef.corethickness = wDef.corethickness * 1.21
			end
			if wDef.thickness then
				wDef.thickness = wDef.thickness * 1.27
			end
			if wDef.laserflaresize then
				wDef.laserflaresize = wDef.laserflaresize * 1.15		-- note: thickness affects this too
			end
			wDef.texture1 = "largebeam"		-- The projectile texture
			--wDef.texture2 = ""		-- The end-of-beam texture for #LaserCannon, #BeamLaser
			wDef.texture3 = "flare2"	-- Flare texture for #BeamLaser
			wDef.texture4 = "flare2"	-- Flare texture for #BeamLaser with largeBeamLaser = true
		end

		-- scavengers
		if string.find(name, '_scav') then
			VFS.Include("gamedata/scavengers/weapondef_post.lua")
			wDef = scav_Wdef_Post(name, wDef)
		end

		ProcessSoundDefaults(wDef)
	end

	-- Multipliers

	-- Weapon Range
	if true then -- dumb way to keep the x local here
		local x = modOptions.multiplier_weaponrange
		if x ~= 1 then
			if wDef.range then
				wDef.range = wDef.range*x
			end
			if wDef.flighttime then
				wDef.flighttime = wDef.flighttime*(x*1.5)
			end
			-- if wDef.mygravity and wDef.mygravity ~= 0 then
			-- 	wDef.mygravity = wDef.mygravity*(1/x)
			-- else
			-- 	wDef.mygravity = Game.gravity / (Game.gameSpeed ^ 2) / x
			-- end
			if wDef.weaponvelocity and wDef.weapontype == "Cannon" and wDef.gravityaffected == "true" then
				wDef.weaponvelocity = wDef.weaponvelocity*math.sqrt(x)
			end
			if wDef.weapontype == "StarburstLauncher" and wDef.weapontimer then
				wDef.weapontimer = wDef.weapontimer+(wDef.weapontimer*((x-1)*0.4))
			end
		end
	end

	-- Weapon Damage
	if true then -- dumb way to keep the x local here
		local x = modOptions.multiplier_weapondamage
		if x ~= 1 then
			if wDef.damage then
				for damageClass, damageValue in pairs(wDef.damage) do
					wDef.damage[damageClass] = wDef.damage[damageClass] * x
				end
			end
		end
	end

	-- ExplosionSpeed is calculated same way engine does it, and then doubled
	-- Note that this modifier will only effect weapons fired from actual units, via super clever hax of using the weapon name as prefix
	if wDef.damage and wDef.damage.default then
		if string.find(name,'_', nil, true) then
			local prefix = string.sub(name,1,3)
			if prefix == 'arm' or prefix == 'cor' or prefix == 'leg' or prefix == 'rap' then
				local globaldamage = math.max(30, wDef.damage.default / 20)
				local defExpSpeed = (8 + (globaldamage * 2.5))/ (9 + (math.sqrt(globaldamage) * 0.70)) * 0.5
				wDef.explosionSpeed = defExpSpeed * 2
				--Spring.Echo("Changing explosionSpeed for weapon:", name, wDef.name, wDef.weapontype, wDef.damage.default, wDef.explosionSpeed)
			end
		end
	end
end
-- process effects
function ExplosionDef_Post(name, eDef)
	--[[
    -- WIP on #645
    Spring.Echo(name)
    for k,v in pairs(eDef) do
        Spring.Echo(" ", k, v, type(k), type(v))
        if type(v)=="table" then
            for k1,v1 in pairs(v) do
                Spring.Echo("  ", k1,v1)
            end
        end
    end
    if eDef.usedefaultexplosions=="1" then

    end
    ]]
end

--------------------------
-- MODOPTIONS
-------------------------

-- process modoptions (last, because they should not get baked)
function ModOptions_Post (UnitDefs, WeaponDefs)

	-- transporting enemy coms
	if Spring.GetModOptions().transportenemy == "notcoms" then
		for name,ud in pairs(UnitDefs) do
			if ud.customparams.iscommander then
				ud.transportbyenemy = false
			end
		end
	elseif Spring.GetModOptions().transportenemy == "none" then
		for name, ud in pairs(UnitDefs) do
			ud.transportbyenemy = false
		end
	end

	-- For Decals GL4, disables default groundscars for explosions
	for id,wDef in pairs(WeaponDefs) do
		wDef.explosionScar = false
	end


	--[[
	-- Make BeamLasers do their damage up front instead of over time
	-- Do this at the end so that we don't mess up any magic math
	for id,wDef in pairs(WeaponDefs) do
		-- Beamlasers do damage up front
		if wDef.beamtime ~= nil then
			beamTimeInFrames = wDef.beamtime * 30
			--Spring.Echo(wDef.name)
			--Spring.Echo(beamTimeInFrames)
			wDef.beamttl = beamTimeInFrames
			--Spring.Echo(wDef.beamttl)
			wDef.beamtime = 0.01
		end
	end
	]]--
end
