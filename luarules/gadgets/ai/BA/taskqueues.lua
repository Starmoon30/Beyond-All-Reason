--[[
 Task Queues! -- Author: Damgam
]]--

math.randomseed( os.time() )
math.random(); math.random(); math.random()




-- Locals
----------------------------------------------------------------------
-- c = current, s = storage, p = pull(?), i = income, e = expense (Ctrl C Ctrl V into functions)
--local mc, ms, mp, mi, me = Spring.GetTeamResources(ai.id, "metal")
--local ec, es, ep, ei, ee = Spring.GetTeamResources(ai.id, "energy")
----------------------------------------------------------------------
-- for example ------------- UDC(ai.id, UDN.cormex.id) ---------------
local UDC = Spring.GetTeamUnitDefCount
local UDN = UnitDefNames
----------------------------------------------------------------------

local unitoptions = {}
--------------------------------------------------------------------------------------------
--------------------------------------- Main Functions -------------------------------------
--------------------------------------------------------------------------------------------

---- RESOURCES RELATED ----
function curstorperc(ai, resource) -- Returns % of storage for resource in real time
	local c, s, p, i, e = Spring.GetTeamResources(ai.id, resource)
	return ((c / s) * 100)
end

function timetostore(ai, resource, amount) -- Returns time to gather necessary resource amount in real time
	local c, s, p, i, e = Spring.GetTeamResources(ai.id, resource)
	local income = (i-e > 0 and i-e) or 0.00001
	return (amount-c)/(income)
end

function income(ai, resource) -- Returns income of resource in realtime
	local c, s, p, i, e = Spring.GetTeamResources(ai.id, resource)
	return i
end

---- TECHTREE RELATED ----
function KbotOrVeh()
	local veh = 0
	local kbot = 0
	-- mapsize
	mapsize = Game.mapSizeX * Game.mapSizeZ
	local randomnumber = math.random(1,mapsize+1)
	if randomnumber >= 48 then
		veh = veh + 1
	else
		kbot = kbot + 1
	end
	-- windAvg
	local avgWind = (Game.windMin + Game.windMax)/2
	randomnumber = math.random(0, math.floor(avgWind + 1))
	if randomnumber >= 3 then
		veh = veh + 1
	else
		kbot = kbot + 1
	end
	-- numberPlayers
	local teamList = Spring.GetTeamList()
	local nTeams = #teamList
	randomnumber = math.random(1, nTeams+1)
	if randomnumber <= 6 then
		veh = veh + 1
	else
		kbot = kbot + 1
	end
	-- Height diffs
	local min, max = Spring.GetGroundExtremes()
	local diff = max-min
	randomnumber = math.random(1, math.floor(diff+1))
	if randomnumber <= 100 then
		veh = veh + 1
	else
		kbot = kbot + 1
	end
	if kbot > veh then 
		return 'kbot'
	elseif veh > kbot then
		return 'veh'
	elseif math.random(1,2) == 2 then
		return 'veh'
	else
		return 'kbot'
	end
end

function FindBest(unitoptions,ai)
	if GG.info and GG.info[ai.id] and unitoptions and unitoptions[1] then
		local effect = {}
		local randomization = 1
		local randomunit = {}
		for n, unitName in pairs(unitoptions) do
			local cost = UnitDefs[UnitDefNames[unitName].id].energyCost / 60 + UnitDefs[UnitDefNames[unitName].id].metalCost
			local avgkilled_cost = GG.info and GG.info[ai.id] and GG.info[ai.id][UnitDefNames[unitName].id] and GG.info[ai.id][UnitDefNames[unitName].id].avgkilled_cost or 200 --start at 200 so that costly units aren't made from the start
			effect[unitName] = math.max(math.floor((avgkilled_cost/cost)^4*100),10)
			for i = randomization, randomization + effect[unitName] do
				randomunit[i] = unitName
			end
			randomization = randomization + effect[unitName]
		end
		if randomization < 1 then
			return {action = "nexttask"}
		end
		return randomunit[math.random(1,randomization)]	
	else
		return unitoptions[math.random(1,#unitoptions)]
	end
end

function UUDC(unitName, teamID) -- Unfinished UnitDef Count
	local count = 0
	if UnitDefNames[unitName] then
		local tableUnits = Spring.GetTeamUnitsByDefs(teamID, UnitDefNames[unitName].id)
		for k, v in pairs(tableUnits) do
			local _,_,_,_,bp = Spring.GetUnitHealth(v)
			if bp < 1 then
				count = count + 1
			end
		end
	end
	return count
end

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--------------------------------------- Core Functions -------------------------------------
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

function CorWindOrSolar(tqb, ai, unit)
    local _,_,_,curWind = Spring.GetWind()
    local avgWind = (Game.windMin + Game.windMax)/2
	if ai and ai.id then
		if not (UDC(ai.id, UDN.armfus.id) + UDC(ai.id, UDN.corfus.id) > 1) then
			if curWind > 7 then
				return "corwin"
			else
				local ec, es, ep, ei, ee = Spring.GetTeamResources(ai.id, "energy")
				local mc, ms, mp, mi, me = Spring.GetTeamResources(ai.id, "metal")
				if ei > 200 and mi > 15 and (UUDC("armadvsol", ai.id) + UUDC("coradvsol", ai.id)) < 2 then
					return "coradvsol"
				else
					return "corsolar"
				end
			end
		else
			return {action = "nexttask"}	
		end
	else
		return "corsolar"
	end
end

function CorLLT(tqb, ai, unit)
	if Spring.GetGameSeconds() < 240 then
		return "corllt"
	elseif Spring.GetGameSeconds() < 480 then
		local unitoptions = {"corllt", "corhllt", "corhlt", "cormaw", "corrl"}
		return FindBest(unitoptions,ai)
	else
		local unitoptions = {"corllt", "corhllt", "corhlt", "cormaw", "corrl", "cormadsam", "corerad"}
		return FindBest(unitoptions,ai)
	end
end

function CorNanoT(tqb, ai, unit)
	local ec, es, ep, ei, ee = Spring.GetTeamResources(ai.id, "energy")
	local mc, ms, mp, mi, me = Spring.GetTeamResources(ai.id, "metal")
	local countAdvBuilders = UDC(ai.id, UDN.armack.id) + UDC(ai.id, UDN.armacv.id) + UDC(ai.id, UDN.armaca.id) + UDC(ai.id, UDN.corack.id) + UDC(ai.id, UDN.coracv.id) + UDC(ai.id, UDN.coraca.id)
	if not (countAdvBuilders >= 1) then
		if (UDC(ai.id, UDN.armnanotc.id) + UDC(ai.id, UDN.cornanotc.id)) < 4 and timetostore(ai, "energy", 5000) < 10 and timetostore(ai, "metal", 300) < 10 then
			return "cornanotc"
		else
			return {action = "nexttask"}
		end
	elseif timetostore(ai, "energy", 5000) < 10 and timetostore(ai, "metal", 300) < 10 then
		return "cornanotc"
	else
		return {action = "nexttask"}
	end
end

function CorEnT1( tqb, ai, unit )	
	local ec, es, ep, ei, ee = Spring.GetTeamResources(ai.id, "energy")
	local mc, ms, mp, mi, me = Spring.GetTeamResources(ai.id, "metal")
	local countEstore = UDC(ai.id, UDN.corestor.id) + UDC(ai.id, UDN.armestor.id)
	if (income(ai, "energy") < 750) and ei - ee < 0 and ec < 0.5 * es then
        return (CorWindOrSolar(tqb, ai, unit))
    elseif ei - ee > 0 and ec > 0.8 * es then
        return "cormakr"
	elseif es < (ei * 8) and ec > (es * 0.8) and countEstore < (ei*8)/6000 then
		return "corestor"
	elseif ms < (mi * 8) or mc > (ms*0.9) then
		return "cormstor"
	else
		return {action = "nexttask"}
	end
end

function CorEcoT1( tqb, ai, unit )
-- c = current, s = storage, p = pull(?), i = income, e = expense (Ctrl C Ctrl V into functions)
	local ec, es, ep, ei, ee = Spring.GetTeamResources(ai.id, "energy")
	local mc, ms, mp, mi, me = Spring.GetTeamResources(ai.id, "metal")
	if tqb.ai.map:AverageWind() > 7 and ec < es*0.10 then
		return "corwin"
	elseif tqb.ai.map:AverageWind() <= 7 and ec < es*0.10 then
		return "corsolar"
	elseif mc < ms*0.1 and ec > es*0.90 then
		return "cormakr"
	else
		return {action = "nexttask"}
	end
end


function CorEnT2( tqb, ai, unit )
	local ec, es, ep, ei, ee = Spring.GetTeamResources(ai.id, "energy")
	local mc, ms, mp, mi, me = Spring.GetTeamResources(ai.id, "metal")
	if ei - ep < 0 and ec < 0.5 * es and ei > 800 and mi > 35 and (UUDC("armfus", ai.id) + UUDC("corfus", ai.id)) < 2 then
        return "corfus"
    elseif ei - ep > 0 and ec > 0.8 * es then
        return "cormmkr"
	else
		return "cormoho"
	end
end

function CorMexT1( tqb, ai, unit )
	
	local ec, es, ep, ei, ee = Spring.GetTeamResources(ai.id, "energy")
	local mc, ms, mp, mi, me = Spring.GetTeamResources(ai.id, "metal")
	if mc < ms*0.1 then
		return "cormex"
	elseif mc < ms*0.3 then
		return "corexp"
	elseif ec < es*0.10 then
        return (CorWindOrSolar(tqb, ai, unit))
    elseif ei - Spring.GetTeamRulesParam(ai.id, "mmCapacity") > 0 then
        return "cormakr"
	else
		return {action = "nexttask"}
	end
end

function CorStarterLabT1(tqb, ai, unit)
	local countStarterFacs = UDC(ai.id, UDN.corvp.id) + UDC(ai.id, UDN.corlab.id) + UDC(ai.id, UDN.corap.id)
	if countStarterFacs < 1 then
		local labtype = KbotOrVeh()
		if labtype == "kbot" then
			return "corlab"
		else
			return "corvp"
		end
	else
		return {action = "nexttask"}
	end
end

function CorRandomLab(tqb, ai, unit)
	local mc, ms, mp, mi, me = Spring.GetTeamResources(ai.id, "metal")
	local ec, es, ep, ei, ee = Spring.GetTeamResources(ai.id, "energy")
	local countBasicFacs = UDC(ai.id, UDN.corvp.id) + UDC(ai.id, UDN.corlab.id) + UDC(ai.id, UDN.corap.id) + UDC(ai.id, UDN.corhp.id)
	--local countAdvFacs = UDC(ai.id, UDN.coravp.id) + UDC(ai.id, UDN.coralab.id) + UDC(ai.id, UDN.coraap.id) + UDC(ai.id, UDN.corgant.id)
	local m = (mi - mp)*200 + mc
	local e = (ei - ep)*200 + ec
	if UDC(ai.id, UDN.corlab.id) == 1 and UDC(ai.id, UDN.corvp.id) == 0 and UDC(ai.id, UDN.coralab.id) == 0 and (((m > 2000 and e > 18000) and Spring.GetGameSeconds() >= 300) or Spring.GetGameSeconds() >= math.random(480, 720)) then
		return "coralab"
	elseif UDC(ai.id, UDN.corlab.id) == 0 and UDC(ai.id, UDN.corvp.id) == 1 and UDC(ai.id, UDN.coravp.id) == 0 and (((m > 2000 and e > 18000) and Spring.GetGameSeconds() >= 300) or Spring.GetGameSeconds() >= math.random(480, 720)) then
		return "coravp"
	end
	
	if (UDC(ai.id, UDN.armavp.id) + UDC(ai.id, UDN.armalab.id) + UDC(ai.id, UDN.coravp.id) + UDC(ai.id, UDN.coralab.id)) >= 1 and (m > 2000 and e > 18000) and Spring.GetGameSeconds() > 300 and not ((UUDC("corap", ai.id) + UUDC("coraap", ai.id) + UUDC("corvp", ai.id) + UUDC("coravp", ai.id) + UUDC("corlab", ai.id) + UUDC( "coralab", ai.id) + UUDC("armap", ai.id) + UUDC("armaap", ai.id) + UUDC("armvp", ai.id) + UUDC("armavp", ai.id) + UUDC("armlab", ai.id) + UUDC( "armalab", ai.id)) > 0) then
		if UDC(ai.id, UDN.corap.id) < 1 then
			return "corap"
		elseif UDC(ai.id, UDN.coraap.id) < 1 then
			return "coraap"
		elseif UDC(ai.id, UDN.corlab.id) < 1 then
			return "corlab"
		elseif UDC(ai.id, UDN.coralab.id) < 1 then
			return "coralab"
		elseif UDC(ai.id, UDN.corvp.id) < 1 then
			return "corvp"
		elseif UDC(ai.id, UDN.coravp.id) < 1 then
			return "coravp"
		elseif UDC(ai.id, UDN.corhp.id) < 1 then
			return "corhp"
		elseif UDC(ai.id, UDN.corgant.id) < 1 then
			return "corgant"
		else
			return {action = "nexttask"}
		end
	else
		return {action = "nexttask"}
	end
end

function CorGroundAdvDefT1(tqb, ai, unit)
	local r = math.random(0,100)
	local ec, es, ep, ei, ee = Spring.GetTeamResources(ai.id, "energy")
	local mc, ms, mp, mi, me = Spring.GetTeamResources(ai.id, "metal")
	if mc > ms*0.1 and ec > es*0.1 then
		if r == 0 and Spring.GetGameSeconds() > 600 then
			return "corpun"
		else
			local unitoptions = {"cormaw", "corhllt", "corhlt",}
			return FindBest(unitoptions,ai)
		end
	else
		return {action = "nexttask"}
	end
end

function CorAirAdvDefT1(tqb, ai, unit)
	local ec, es, ep, ei, ee = Spring.GetTeamResources(ai.id, "energy")
	local mc, ms, mp, mi, me = Spring.GetTeamResources(ai.id, "metal")
	if mc > ms*0.1 and ec > es*0.1 then
		local unitoptions = {"cormadsam", "corrl",}
		return FindBest(unitoptions,ai)
	else
		return {action = "nexttask"}
	end
end

function CorAirAdvDefT2(tqb, ai, unit)
	local ec, es, ep, ei, ee = Spring.GetTeamResources(ai.id, "energy")
	local mc, ms, mp, mi, me = Spring.GetTeamResources(ai.id, "metal")
	if mc > ms*0.1 and ec > es*0.1 then
		local unitoptions = {"corflak","corscreamer" }
		return FindBest(unitoptions,ai)
	else
		return {action = "nexttask"}
	end
end

function CorTacticalAdvDefT2(tqb, ai, unit)
	local ec, es, ep, ei, ee = Spring.GetTeamResources(ai.id, "energy")
	local mc, ms, mp, mi, me = Spring.GetTeamResources(ai.id, "metal")
	if mc > ms*0.1 and ec > es*0.1 then
		local unitoptions = {"corvipe","cortoast","cordoom", "corint"}
		return FindBest(unitoptions,ai)
	else
		return {action = "nexttask"}
	end
end

function CorTacticalOffDefT2(tqb, ai, unit)
	local ec, es, ep, ei, ee = Spring.GetTeamResources(ai.id, "energy")
	local mc, ms, mp, mi, me = Spring.GetTeamResources(ai.id, "metal")
	if mc > ms*0.1 and ec > es*0.1 then
		if  UDC(ai.id, UDN.corfmd.id) < 3 then
			return "corfmd"
		elseif 	 UDC(ai.id, UDN.corgate.id) < 6 then
			return "corgate"
		else
			return {action = "nexttask"}
		end
	else
		return {action = "nexttask"}
	end
end
	--local unitoptions = {"corfmd", "corsilo",}
	--return unitoptions[math.random(1,#unitoptions)]


function CorKBotsT1(tqb, ai, unit)
	local countAdvBuilders = UDC(ai.id, UDN.armack.id) + UDC(ai.id, UDN.armacv.id) + UDC(ai.id, UDN.armaca.id) + UDC(ai.id, UDN.corack.id) + UDC(ai.id, UDN.coracv.id) + UDC(ai.id, UDN.coraca.id)
	local ec, es, ep, ei, ee = Spring.GetTeamResources(ai.id, "energy")
	local mc, ms, mp, mi, me = Spring.GetTeamResources(ai.id, "metal")
	if not (countAdvBuilders > 0 and (ec < es*0.3 or mc < ms*0.3)) then
		local unitoptions = {"corak", "corthud", "corstorm", "cornecro", "corcrash",}
		return FindBest(unitoptions,ai)
	else
		return {action = "nexttask"}
	end
end

function CorVehT1(tqb, ai, unit)
	local countAdvBuilders = UDC(ai.id, UDN.armack.id) + UDC(ai.id, UDN.armacv.id) + UDC(ai.id, UDN.armaca.id) + UDC(ai.id, UDN.corack.id) + UDC(ai.id, UDN.coracv.id) + UDC(ai.id, UDN.coraca.id)
	local ec, es, ep, ei, ee = Spring.GetTeamResources(ai.id, "energy")
	local mc, ms, mp, mi, me = Spring.GetTeamResources(ai.id, "metal")
	if not (countAdvBuilders > 0 and (ec < es*0.3 or mc < ms*0.3)) then
		local unitoptions = {"corfav", "corgator", "corraid", "corlevlr", "cormist", "corwolv", "corgarp",}
		return FindBest(unitoptions,ai)
	else
		return {action = "nexttask"}
	end
end

function CorAirT1(tqb, ai, unit)
	local countAdvBuilders = UDC(ai.id, UDN.armack.id) + UDC(ai.id, UDN.armacv.id) + UDC(ai.id, UDN.armaca.id) + UDC(ai.id, UDN.corack.id) + UDC(ai.id, UDN.coracv.id) + UDC(ai.id, UDN.coraca.id)
	local ec, es, ep, ei, ee = Spring.GetTeamResources(ai.id, "energy")
	local mc, ms, mp, mi, me = Spring.GetTeamResources(ai.id, "metal")
	if not (countAdvBuilders > 0 and (ec < es*0.3 or mc < ms*0.3)) then
		local unitoptions = {"corveng", "corshad", "corbw", "corfink",}
		return FindBest(unitoptions,ai)
	else
		return {action = "nexttask"}
	end
end

function CorKBotsT2(tqb, ai, unit)
	
	local unitoptions = {"coraak", "coramph", "corcan", "corhrk", "cormort", "corpyro", "corroach", "cortermite", "corspec", "corsumo",}
	return FindBest(unitoptions,ai)
end

function CorVehT2(tqb, ai, unit)
	if Spring.GetGameSeconds() < 1200 then
		local unitoptions = {"corban", "corgol", "cormart", "correap", "corsent",}
		return FindBest(unitoptions,ai)
	else
		local unitoptions = {"corban", "coreter", "corgol", "cormart", "corparrow", "correap", "corseal", "corsent", "cortrem", "corvroc",}
		return FindBest(unitoptions,ai)
	end
end

function CorAirT2(tqb, ai, unit)
	
	local unitoptions = {"corape", "corcrw", "corhurc", "corvamp",}
	return FindBest(unitoptions,ai)
end

function CorHover(tqb, ai, unit)
	
	local unitoptions = {"corah", "corch", "corhal", "cormh", "corsh", "corsnap","corsok",}
	return FindBest(unitoptions,ai)
end 
--[[
function CorSeaPlanes()
	
	local unitoptions = {"corcsa", "corcut", "corhunt", "corsb", "corseap", "corsfig", }
	return unitoptions[math.random(1,#unitoptions)]
end 		

function CorShipT1()
	
	local unitoptions = {"corcs", "cordship", "coresupp", "corpship", "corpt", "correcl", "corroy", "corrship", "corsub", "cortship",}
	return unitoptions[math.random(1,#unitoptions)]
end		

function CorShipT2()
	
	local unitoptions = {"coracsub", "corarch", "corbats", "corblackhy", "corcarry", "corcrus", "cormls", "cormship", "corshark", "corsjam", "corssub", }
	return unitoptions[math.random(1,#unitoptions)]
end				
]]--

function CorGantry(tqb, ai, unit)
	
	local unitoptions = {"corcat", "corjugg", "corkarg", "corkrog", "corshiva", }
	return FindBest(unitoptions,ai)
end 

--constructors:

function CorT1KbotCon(tqb, ai, unit)
	return "corck"
end

function CorStartT1KbotCon(tqb, ai, unit)
	return (((Spring.GetGameSeconds() < 180) and"corck") or CorKBotsT1(tqb, ai, unit))
end


function CorT1RezBot(tqb, ai, unit)
	local CountRez = UDC(ai.id, UDN.cornecro.id)
	if CountRez <= 10 then
		return "cornecro"
	else
		return {action = "nexttask"}
	end
end

function CorT1VehCon(tqb, ai, unit)
		return "corcv"
end

function CorStartT1VehCon(tqb, ai, unit)
	return (((Spring.GetGameSeconds() < 180) and"corcv") or CorVehT1(tqb, ai, unit))
	end

function CorT1AirCon(tqb, ai, unit)
	local CountCons = UDC(ai.id, UDN.corca.id)
	if CountCons <= 4 then
		return "corca"
	else
		return {action = "nexttask"}
	end
end

function CorFirstT2Mexes(tqb, ai, unit)
	if not ai.firstt2mexes then
		ai.firstt2mexes = 1
		return "cormoho"
	elseif ai.firstt2mexes and ai.firstt2mexes <= 3 then
		ai.firstt2mexes = ai.firstt2mexes + 1
		return "cormoho"
	else
		return {action = "nexttask"}
	end
end

function CorFirstT1Mexes(tqb, ai, unit)
	if not ai.firstt1mexes then
		ai.firstt1mexes = 1
		return "cormex"
	elseif ai.firstt1mexes and ai.firstt1mexes <= 3 then
		ai.firstt1mexes = ai.firstt1mexes + 1
		return "cormex"
	else
		return {action = "nexttask"}
	end
end

function CorThirdMex(tqb, ai, unit)
	if income(ai, "metal") < 5.5 then
		return 'cormex'
	else
		return {action = "nexttask"}
	end
end

--------------------------------------------------------------------------------------------
----------------------------------------- CoreTasks ----------------------------------------
--------------------------------------------------------------------------------------------

local corcommanderfirst = {
	"cormex",
	"cormex",
	CorThirdMex,
	CorWindOrSolar,
	CorWindOrSolar,
	CorStarterLabT1,
	"corllt",
	"corrad",
}

local cort1construction = {
	CorRandomLab,
	CorFirstT1Mexes,
	CorFirstT1Mexes,
	CorFirstT1Mexes,
	-- CorLLT,
	CorEnT1,
	CorEnT1,
	CorEnT1,
	CorNanoT,
	CorEnT1,
	CorEnT1,
	CorEnT1,
	"corrad",
	CorLLT,
	CorLLT,
	CorRandomLab,
	CorNanoT,
	CorNanoT,
	CorNanoT,
	CorGroundAdvDefT1,
	CorEnT1,
	CorEnT1,
	CorEnT1,
	CorLLT,
	CorEnT1,
	CorEnT1,
	CorEnT1,
	CorNanoT,
	CorLLT,
	CorLLT,
	"corrad",
	CorMexT1,
	CorNanoT,
	"cormex",
	CorLLT,
	CorEnT1,
	CorEnT1,
	CorAirAdvDefT1,
	"corgeo",
}

local cort2construction = {
	CorFirstT2Mexes,
	CorFirstT2Mexes,
	CorFirstT2Mexes,
	CorTacticalAdvDefT2,
	CorEnT2,
	CorEnT2,
	CorEnT2,
	"corarad",
	CorTacticalAdvDefT2,
	CorRandomLab,
	CorTacticalOffDefT2,
	CorAirAdvDefT2,
}

local corkbotlab = {
	CorStartT1KbotCon,
	CorT1KbotCon,	--	Constructor
	CorKBotsT1,
	CorStartT1KbotCon,
	CorKBotsT1,
	CorStartT1KbotCon,
	CorKBotsT1,
	CorKBotsT1,
	CorKBotsT1,
	CorKBotsT1,
	CorKBotsT1,
	CorKBotsT1,
	CorT1RezBot,
}

local corvehlab = {
	CorStartT1VehCon,
	CorT1VehCon,	--	Constructor
	CorVehT1,
	CorStartT1VehCon,
	CorVehT1,
	CorStartT1VehCon,
	CorVehT1,
	CorVehT1,
	CorVehT1,
}

local corairlab = {
	CorT1AirCon,	-- 	Constructor
	CorAirT1,
	CorAirT1,
	CorAirT1,
	CorAirT1,
	CorAirT1,
	CorAirT1,
	CorAirT1,
	CorAirT1,
}

corkbotlabT2 = {
	"corack",
	"corfast",
	CorKBotsT2,
	CorKBotsT2,
	CorKBotsT2,
	CorKBotsT2,
	CorKBotsT2,
	CorKBotsT2,
	CorKBotsT2,
	CorKBotsT2,
	CorKBotsT2,
	CorKBotsT2,
}

corvehlabT2 = {
	"coracv",
	CorVehT2,
	CorVehT2,
	CorVehT2,
	CorVehT2,
	CorVehT2,
	CorVehT2,
	CorVehT2,
	CorVehT2,
	CorVehT2,
	CorVehT2,
}

corairlabT2 = {
	"coraca",
	CorAirT2,
	CorAirT2,
	CorAirT2,
	CorAirT2,
	CorAirT2,
	CorAirT2,
	CorAirT2,
	CorAirT2,
	CorAirT2,
	CorAirT2,
}
corhoverlabT2 = {
	"armch",
	CorHover,
	CorHover,
	CorHover,
	CorHover,
	CorHover,
	CorHover,
	CorHover,
	CorHover,
	CorHover,
	CorHover,
}
corgantryT3 = {
	CorGantry,
}

assistqueue = {
	{ action = "fightrelative", position = {x = 0, y = 0, z = 0} },
}

--------------------------------------------------------------------------------------------
-------------------------------------- CoreQueuePicker -------------------------------------
--------------------------------------------------------------------------------------------

local function corcommander(tqb, ai, unit)
	local countBasicFacs = UDC(ai.id, UDN.corvp.id) + UDC(ai.id, UDN.corlab.id) + UDC(ai.id, UDN.corap.id) + UDC(ai.id, UDN.corhp.id)
	if countBasicFacs > 0 then
	--return armcommanderq
		return assistqueue
	elseif ai.engineerfirst then
		return {"corlab"}
	else
		ai.engineerfirst = true
		return corcommanderfirst
	end
end

--local function corT1constructorrandommexer()
	--if ai.engineerfirst1 == true then
			--local r = math.random(0,1)
		--if r == 0 or Spring.GetGameSeconds() < 300 then
			--return cort1mexingqueue
		--else
			--return cort1construction
		--end
	--else
        --ai.engineerfirst1 = true
        --return corT1ConFirst
    --end
--end

--------------------------------------------------------------------------------------------	
--------------------------------------------------------------------------------------------
--------------------------------------- Arm Functions --------------------------------------
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

function ArmWindOrSolar(tqb, ai, unit)
    local _,_,_,curWind = Spring.GetWind()
    local avgWind = (Game.windMin + Game.windMax)/2
	if ai and ai.id then
		if not (UDC(ai.id, UDN.armfus.id) + UDC(ai.id, UDN.corfus.id) > 1) then
			if curWind > 7 then
				return "armwin"
			else
				local ec, es, ep, ei, ee = Spring.GetTeamResources(ai.id, "energy")
				local mc, ms, mp, mi, me = Spring.GetTeamResources(ai.id, "metal")
				if ei > 200 and mi > 15 and (UUDC("armadvsol", ai.id) + UUDC("coradvsol", ai.id)) < 2 then
					return "armadvsol"
				else
					return "armsolar"
				end
			end
		else
			return {action = "nexttask"}	
		end
	else
		return "armsolar"
	end
end

function ArmLLT(tqb, ai, unit)
	if Spring.GetGameSeconds() < 240 then
		return "armllt"
	elseif Spring.GetGameSeconds() < 480 then
		local unitoptions = {"armllt", "armbeamer", "armhlt", "armclaw", "armrl"}
		return FindBest(unitoptions,ai)
	else
		local unitoptions = {"armllt", "armbeamer", "armhlt", "armclaw", "armrl", "armpacko", "armcir"}
		return FindBest(unitoptions,ai)
	end
end

function ArmNanoT(tqb, ai, unit)
	local ec, es, ep, ei, ee = Spring.GetTeamResources(ai.id, "energy")
	local mc, ms, mp, mi, me = Spring.GetTeamResources(ai.id, "metal")
	local countAdvBuilders = UDC(ai.id, UDN.armack.id) + UDC(ai.id, UDN.armacv.id) + UDC(ai.id, UDN.armaca.id) + UDC(ai.id, UDN.corack.id) + UDC(ai.id, UDN.coracv.id) + UDC(ai.id, UDN.coraca.id)
	if not (countAdvBuilders >= 1) then
		if (UDC(ai.id, UDN.armnanotc.id) + UDC(ai.id, UDN.cornanotc.id)) < 4 and timetostore(ai, "energy", 5000) < 10 and timetostore(ai, "metal", 300) < 10 then
			return "armnanotc"
		else
			return {action = "nexttask"}
		end
	elseif timetostore(ai, "energy", 5000) < 10 and timetostore(ai, "metal", 300) < 10 then
		return "armnanotc"
	else
		return {action = "nexttask"}
	end
end


function ArmEnT1( tqb, ai, unit)
	local ec, es, ep, ei, ee = Spring.GetTeamResources(ai.id, "energy")
	local mc, ms, mp, mi, me = Spring.GetTeamResources(ai.id, "metal")
	local countEstore = UDC(ai.id, UDN.corestor.id) + UDC(ai.id, UDN.armestor.id)
	if (income(ai, "energy") < 750) and ei - ee < 0 and ec < 0.8 * es then
		return (ArmWindOrSolar(tqb, ai, unit))
	elseif ei - ee > 0 and ec > 0.8 * es then
		return "armmakr"
	elseif es < (ei * 8) and ec > (es * 0.8) and countEstore < (ei *8) / 6000 then
		return "armestor"
	elseif ms < (mi * 8) or mc > (ms*0.9) then
		return "armmstor"
	else
		return {action = "nexttask"}
	end
end

function ArmEcoT1( tqb, ai, unit )
-- c = current, s = storage, p = pull(?), i = income, e = expense (Ctrl C Ctrl V into functions)
	local ec, es, ep, ei, ee = Spring.GetTeamResources(ai.id, "energy")
	local mc, ms, mp, mi, me = Spring.GetTeamResources(ai.id, "metal")
	if tqb.ai.map:AverageWind() > 7 and ec < es*0.10 then
		return "armwin"
	elseif tqb.ai.map:AverageWind() <= 7 and ec < es*0.10 then
		return "armsolar"
	elseif mc < ms*0.1 and ec > es*0.90 then
		return "armmakr"
	else
		return {action = "nexttask"}
	end
end



function ArmEnT2( tqb, ai, unit )
	local ec, es, ep, ei, ee = Spring.GetTeamResources(ai.id, "energy")
	local mc, ms, mp, mi, me = Spring.GetTeamResources(ai.id, "metal")
	if ei - ep < 0 and ec < 0.5 * es and ei > 800 and mi > 35 and (UUDC("armfus",ai.id) + UUDC("corfus",ai.id)) < 2 then
        return "armfus"
    elseif ei - ep > 0 and ec > 0.8 * es then
        return "armmmkr"
	else
		return "armmoho"
	end
end

function ArmMexT1( tqb, ai, unit )
	local ec, es, ep, ei, ee = Spring.GetTeamResources(ai.id, "energy")
	local mc, ms, mp, mi, me = Spring.GetTeamResources(ai.id, "metal")
	if mc < ms - ms*0.8 then
		return "armmex"
	elseif ec < es*0.10 then
        return (ArmWindOrSolar(tqb, ai, unit))
    elseif ei - Spring.GetTeamRulesParam(ai.id, "mmCapacity") > 0 then
        return "armmakr"
	else
		return {action = "nexttask"}
	end
end

function ArmStarterLabT1(tqb, ai, unit)
	local countStarterFacs = UDC(ai.id, UDN.armvp.id) + UDC(ai.id, UDN.armlab.id) + UDC(ai.id, UDN.armap.id)
	if countStarterFacs < 1 then
		local labtype = KbotOrVeh()
		if labtype == "kbot" then
			return "armlab"
		else
			return "armvp"
		end
	else
		return {action = "nexttask"}
	end
end

function ArmRandomLab(tqb, ai, unit)
	local mc, ms, mp, mi, me = Spring.GetTeamResources(ai.id, "metal")
	local ec, es, ep, ei, ee = Spring.GetTeamResources(ai.id, "energy")
	local countBasicFacs = UDC(ai.id, UDN.armvp.id) + UDC(ai.id, UDN.armlab.id) + UDC(ai.id, UDN.armap.id) + UDC(ai.id, UDN.armhp.id)
	--local countAdvFacs = UDC(ai.id, UDN.armavp.id) + UDC(ai.id, UDN.armalab.id) + UDC(ai.id, UDN.armaap.id) + UDC(ai.id, UDN.armgant.id)
	local m = (mi - mp)*200 + mc
	local e = (ei - ep)*200 + ec
	if UDC(ai.id, UDN.armlab.id) == 1 and UDC(ai.id, UDN.armvp.id) == 0 and UDC(ai.id, UDN.armalab.id) == 0 and (((m > 2000 and e > 18000) and Spring.GetGameSeconds() >= 300) or Spring.GetGameSeconds() >= math.random(480, 720)) then
		return "armalab"
	elseif UDC(ai.id, UDN.armlab.id) == 0 and UDC(ai.id, UDN.armvp.id) == 1 and UDC(ai.id, UDN.armavp.id) == 0 and (((m > 2000 and e > 18000) and Spring.GetGameSeconds() >= 300) or Spring.GetGameSeconds() >= math.random(480, 720)) then
		return "armavp"
	end
	
	if (UDC(ai.id, UDN.armavp.id) + UDC(ai.id, UDN.armalab.id) + UDC(ai.id, UDN.coravp.id) + UDC(ai.id, UDN.coralab.id)) >= 1 and (m > 2000 and e > 18000) and Spring.GetGameSeconds() > 300 and not ((UUDC("corap", ai.id) + UUDC("coraap", ai.id) + UUDC("corvp", ai.id) + UUDC("coravp", ai.id) + UUDC("corlab", ai.id) + UUDC( "coralab", ai.id) + UUDC("armap", ai.id) + UUDC("armaap", ai.id) + UUDC("armvp", ai.id) + UUDC("armavp", ai.id) + UUDC("armlab", ai.id) + UUDC( "armalab", ai.id)) > 0) then
		if UDC(ai.id, UDN.armap.id) < 1 then
			return "armap"
		elseif UDC(ai.id, UDN.armaap.id) < 1 then
			return "armaap"
		elseif UDC(ai.id, UDN.armlab.id) < 1 then
			return "armlab"
		elseif UDC(ai.id, UDN.armalab.id) < 1 then
			return "armalab"
		elseif UDC(ai.id, UDN.armvp.id) < 1 then
			return "armvp"
		elseif UDC(ai.id, UDN.armavp.id) < 1 then
			return "armavp"
		elseif UDC(ai.id, UDN.armhp.id) < 1 then
			return "armhp"
		elseif UDC(ai.id, UDN.armshltx.id) < 1 then
			return "armshltx"
		else
			return {action = "nexttask"}
		end
	else
		return {action = "nexttask"}
	end
end

function ArmGroundAdvDefT1(tqb, ai, unit)
	local r = math.random(0,100)
	local ec, es, ep, ei, ee = Spring.GetTeamResources(ai.id, "energy")
	local mc, ms, mp, mi, me = Spring.GetTeamResources(ai.id, "metal")
	if mc > ms*0.1 and ec > es*0.1 then
		if r == 0 and Spring.GetGameSeconds() > 600 then
			return "armguard"
		else
			local unitoptions = {"armclaw", "armbeamer","armhlt",}
			return FindBest(unitoptions,ai)
		end
	else
		return {action = "nexttask"}
	end
end

function ArmAirAdvDefT1(tqb, ai, unit)
	local ec, es, ep, ei, ee = Spring.GetTeamResources(ai.id, "energy")
	local mc, ms, mp, mi, me = Spring.GetTeamResources(ai.id, "metal")
	if mc > ms*0.1 and ec > es*0.1 then
		local unitoptions = {"armrl", "armpacko",}
		return FindBest(unitoptions,ai)
	else
		return {action = "nexttask"}
	end
end

function ArmAirAdvDefT2(tqb, ai, unit)
	local unitoptions = {"armmercury", "armflak",}
	return FindBest(unitoptions,ai)
end

function ArmTacticalAdvDefT2(tqb, ai, unit)
    local ec, es, ep, ei, ee = Spring.GetTeamResources(ai.id, "energy")
	local mc, ms, mp, mi, me = Spring.GetTeamResources(ai.id, "metal")
	if mc > ms*0.1 and ec > es*0.1 then
		local unitoptions = {"armpb","armamb","armanni", "armbrtha"}
		return FindBest(unitoptions,ai)
	else
		return {action = "nexttask"}
	end
end

function ArmTacticalOffDefT2(tqb, ai, unit)
	local ec, es, ep, ei, ee = Spring.GetTeamResources(ai.id, "energy")
	local mc, ms, mp, mi, me = Spring.GetTeamResources(ai.id, "metal")
	if mc > ms*0.1 and ec > es*0.1 then
		if  UDC(ai.id, UDN.armamd.id) < 3 then
			return "armamd"
		elseif 	 UDC(ai.id, UDN.armgate.id) < 6 then
			return "armgate"
		else
			return "corkrog"
		end
	else
		return {action = "nexttask"}
	end
end
	--local unitoptions = {"armamd", "armsilo",}
	--return FindBest(unitoptions,ai)

function ArmKBotsT1(tqb, ai, unit)
	local countAdvBuilders = UDC(ai.id, UDN.armack.id) + UDC(ai.id, UDN.armacv.id) + UDC(ai.id, UDN.armaca.id) + UDC(ai.id, UDN.corack.id) + UDC(ai.id, UDN.coracv.id) + UDC(ai.id, UDN.coraca.id)
	local ec, es, ep, ei, ee = Spring.GetTeamResources(ai.id, "energy")
	local mc, ms, mp, mi, me = Spring.GetTeamResources(ai.id, "metal")
	if not (countAdvBuilders > 0 and (ec < es*0.3 or mc < ms*0.3)) then
		local unitoptions = {"armpw", "armham", "armrectr", "armrock", "armwar", "armjeth",}
		return FindBest(unitoptions,ai)
	else
		return {action = "nexttask"}
	end
end

function ArmVehT1(tqb, ai, unit)
	local countAdvBuilders = UDC(ai.id, UDN.armack.id) + UDC(ai.id, UDN.armacv.id) + UDC(ai.id, UDN.armaca.id) + UDC(ai.id, UDN.corack.id) + UDC(ai.id, UDN.coracv.id) + UDC(ai.id, UDN.coraca.id)
	local ec, es, ep, ei, ee = Spring.GetTeamResources(ai.id, "energy")
	local mc, ms, mp, mi, me = Spring.GetTeamResources(ai.id, "metal")
	if not (countAdvBuilders > 0 and (ec < es*0.3 or mc < ms*0.3)) then
		local unitoptions = {"armstump", "armjanus", "armsam", "armfav", "armflash", "armart", "armpincer",}
		return FindBest(unitoptions,ai)
	else
		return {action = "nexttask"}
	end
end

function ArmAirT1(tqb, ai, unit)
	local countAdvBuilders = UDC(ai.id, UDN.armack.id) + UDC(ai.id, UDN.armacv.id) + UDC(ai.id, UDN.armaca.id) + UDC(ai.id, UDN.corack.id) + UDC(ai.id, UDN.coracv.id) + UDC(ai.id, UDN.coraca.id)
	local ec, es, ep, ei, ee = Spring.GetTeamResources(ai.id, "energy")
	local mc, ms, mp, mi, me = Spring.GetTeamResources(ai.id, "metal")
	if not (countAdvBuilders > 0 and (ec < es*0.3 or mc < ms*0.3)) then
		local unitoptions = {"armpeep", "armthund", "armfig", "armkam",}
		return FindBest(unitoptions,ai)
	else
		return {action = "nexttask"}
	end
end	

function ArmKBotsT2(tqb, ai, unit)
	
	local unitoptions = {"armaak", "armamph", "armaser", "armfast", "armfboy", "armfido", "armmav", "armsnipe", "armspid", "armzeus", "armvader",}
	return FindBest(unitoptions,ai)
end

function ArmVehT2(tqb, ai, unit)
	if Spring.GetGameSeconds() < 1200 then
		local unitoptions = {"armbull", "armlatnk", "armmanni", "armmart", "armyork",}
		return FindBest(unitoptions,ai)
	else
		local unitoptions = {"armbull", "armcroc", "armlatnk", "armmanni", "armmart", "armmerl", "armst", "armyork",}
		return FindBest(unitoptions,ai)
	end
end

function ArmAirT2(tqb, ai, unit)
	
	local unitoptions = {"armblade", "armbrawl", "armhawk", "armliche", "armpnix", "armstil",}
	return FindBest(unitoptions,ai)
end

function ArmHover(tqb, ai, unit)
	
	local unitoptions = {"armah", "armanac", "armch", "armlun", "armmh", "armsh",}
	return FindBest(unitoptions,ai)
end

--[[
function ArmSeaPlanes()
	
	local unitoptions = {"armcsa", "armsaber", "armsb", "armseap", "armsehak", "armsfig", }
	return unitoptions[math.random(1,#unitoptions)]
end 		

function ArmShipT1()
	
	local unitoptions = {"armcs", "armdecade", "armdship", "armpship", "armpt", "armrecl", "armroy", "armrship", "armsub", "armtship",}
	return unitoptions[math.random(1,#unitoptions)]
end		

function ArmShipT2()
	
	local unitoptions = {"armaas", "armacsub", "armbats", "armcarry", "armcrus", "armepoch", "armmls", "armmship", "armserp", "armsjam", "armsubk", }
	return unitoptions[math.random(1,#unitoptions)]
end		
]]--

function ArmGantry(tqb, ai, unit)
	
	local unitoptions = {"armbanth", "armmar", "armraz", "armvang", }
	return FindBest(unitoptions,ai)
end

--constructors:

function ArmT1KbotCon(tqb, ai, unit)
	local CountCons = UDC(ai.id, UDN.armck.id)
	return "armck"
end

function ArmStartT1KbotCon(tqb, ai, unit)
	return (((Spring.GetGameSeconds() < 180) and "armck") or ArmKBotsT1(tqb,ai,unit))
end

function ArmT1RezBot(tqb, ai, unit)
	local CountRez = UDC(ai.id, UDN.armrectr.id)
	if CountRez <= 10 then
		return "armrectr"
	else
		return {action = "nexttask"}
	end
end

function ArmT1VehCon(tqb, ai, unit)
		return "armcv"
end

function ArmStartT1VehCon(tqb, ai, unit)
	return (((Spring.GetGameSeconds() < 180) and "armcv") or ArmVehT1(tqb, ai, unit))
end

function ArmT1AirCon(tqb, ai, unit)
	local CountCons = UDC(ai.id, UDN.armca.id)
	if CountCons <= 4 then
		return "armca"
	else
		return {action = "nexttask"}
	end
end

function ArmFirstT2Mexes(tqb, ai, unit)
	if not ai.firstt2mexes then
		ai.firstt2mexes = 1
		return "armmoho"
	elseif ai.firstt2mexes and ai.firstt2mexes <= 3 then
		ai.firstt2mexes = ai.firstt2mexes + 1
		return "armmoho"
	else
		return {action = "nexttask"}
	end
end

function ArmFirstT1Mexes(tqb, ai, unit)
	if not ai.firstt1mexes then
		ai.firstt1mexes = 1
		return "armmex"
	elseif ai.firstt1mexes and ai.firstt1mexes <= 3 then
		ai.firstt1mexes = ai.firstt1mexes + 1
		return "armmex"
	else
		return {action = "nexttask"}
	end
end

function ArmThirdMex(tqb, ai, unit)
	if income(ai, "metal") < 5.5 then
		return 'armmex'
	else
		return ArmWindOrSolar(tqb,ai,unit)
	end
end
--------------------------------------------------------------------------------------------
----------------------------------------- ArmTasks -----------------------------------------
--------------------------------------------------------------------------------------------

local armcommanderfirst = {
	"armmex",
	"armmex",
	ArmThirdMex,
	ArmWindOrSolar,
	ArmWindOrSolar,
	ArmStarterLabT1,
	"armllt",
	"armrad",
}

local armt1construction = {
	ArmRandomLab,
	ArmFirstT1Mexes,
	ArmFirstT1Mexes,
	ArmFirstT1Mexes,
	-- ArmLLT,
	ArmEnT1,
	ArmEnT1,
	ArmEnT1,
	ArmNanoT,
	ArmEnT1,
	ArmEnT1,
	ArmEnT1,
	"armrad",
	ArmLLT,
	ArmLLT,
	ArmRandomLab,
	ArmNanoT,
	ArmNanoT,
	ArmNanoT,
	ArmGroundAdvDefT1,
	ArmEnT1,
	ArmEnT1,
	ArmEnT1,
	ArmLLT,
	ArmEnT1,
	ArmEnT1,
	ArmEnT1,
	ArmNanoT,
	ArmLLT,
	ArmLLT,
	"armrad",
	ArmMexT1,
	ArmNanoT,
	"armmex",
	ArmLLT,
	ArmEnT1,
	ArmEnT1,
	ArmAirAdvDefT1,
	"armgeo",
}

local armt2construction = {
	ArmFirstT2Mexes,
	ArmFirstT2Mexes,
	ArmFirstT2Mexes,
	ArmTacticalAdvDefT2,
	ArmEnT2,
	ArmEnT2,
	ArmEnT2,
	"armarad",
	ArmTacticalAdvDefT2,
	ArmRandomLab,
	ArmTacticalOffDefT2,
	ArmAirAdvDefT2,
}

local armkbotlab = {
	ArmStartT1KbotCon,	-- 	Constructor
	ArmT1KbotCon,	-- 	Constructor
	ArmKBotsT1,
	ArmStartT1KbotCon,	-- 	Constructor
	ArmKBotsT1,
	ArmStartT1KbotCon,	-- 	Constructor
	ArmKBotsT1,
	ArmKBotsT1,
	ArmKBotsT1,
	ArmKBotsT1,
	ArmKBotsT1,
	ArmKBotsT1,
	ArmT1RezBot,
}

local armvehlab = {
	ArmStartT1VehCon,	--	Constructor
	ArmT1VehCon,	--	Constructor
	ArmVehT1,
	ArmVehT1,
	ArmStartT1VehCon,	--	Constructor
	ArmVehT1,
	ArmStartT1VehCon,	--	Constructor
	ArmVehT1,
	ArmVehT1,
}

local armairlab = {
	ArmT1AirCon,	--	Constructor
	ArmAirT1,
	ArmAirT1,
	ArmAirT1,
	ArmAirT1,
	ArmAirT1,
	ArmAirT1,
	ArmAirT1,
	ArmAirT1,
}

armkbotlabT2 = {
	"armack",
	"armfark",
	ArmKBotsT2,
	ArmKBotsT2,
	ArmKBotsT2,
	ArmKBotsT2,
	ArmKBotsT2,
	ArmKBotsT2,
	ArmKBotsT2,
	ArmKBotsT2,
	ArmKBotsT2,
	ArmKBotsT2,
}

armvehlabT2 = {
	"armacv",
	"armconsul",
	ArmVehT2,
	ArmVehT2,
	ArmVehT2,
	ArmVehT2,
	ArmVehT2,
	ArmVehT2,
	ArmVehT2,
	ArmVehT2,
	ArmVehT2,
	ArmVehT2,
}

armairlabT2 = {
	"armaca",
	ArmAirT2,
	ArmAirT2,
	ArmAirT2,
	ArmAirT2,
	ArmAirT2,
	ArmAirT2,
	ArmAirT2,
	ArmAirT2,
	ArmAirT2,
	ArmAirT2,
}

armhoverlabT2 = {
	"armch",
	ArmHover,
	ArmHover,
	ArmHover,
	ArmHover,
	ArmHover,
	ArmHover,
	ArmHover,
	ArmHover,
	ArmHover,
	ArmHover,
}
armgantryT3 = {
	ArmGantry,
}

assistqueue = {
	{ action = "fightrelative", position = {x = 0, y = 0, z = 0} },
}

--------------------------------------------------------------------------------------------
-------------------------------------- ArmQueuePicker --------------------------------------
--------------------------------------------------------------------------------------------

local function armcommander(tqb, ai, unit)
	local countBasicFacs = UDC(ai.id, UDN.armvp.id) + UDC(ai.id, UDN.armlab.id) + UDC(ai.id, UDN.armap.id) + UDC(ai.id, UDN.armhp.id)
	if countBasicFacs > 0 then
	--return armcommanderq
		return assistqueue
	elseif ai.engineerfirst then
		return {"armlab"}
	else
		ai.engineerfirst = true
		return armcommanderfirst
	end
end

local function armt1con(tqb, ai, unit)
	if math.random(0,10) > 9 then
		return assistqueue
	else
		return armt1construction
	end
end

local function cort1con(tqb, ai, unit)
	if math.random(0,10) > 9 then
		return assistqueue
	else
		return cort1construction
	end
end

local function armt2con(tqb, ai, unit)
	if math.random(0,10) > 9 then
		return assistqueue
	else
		return armt2construction
	end
end

local function cort2con(tqb, ai, unit)
	if math.random(0,10) > 9 then
		return assistqueue
	else
		return cort2construction
	end
end


--local function armT1constructorrandommexer()
    --if ai.engineerfirst1 == true then
		--return armt1construction
    --else
        --ai.engineerfirst1 = true
		--return armT1ConFirst
    --end
--end

--------------------------------------------------------------------------------------------
---------------------------------------- TASKQUEUES ----------------------------------------
--------------------------------------------------------------------------------------------

taskqueues = {
	---CORE
	--constructors
	corcom = corcommander,
	corck = cort1con,
	corcv = cort1con,
	corca = cort1con,
	corch = cort1con,
	cornanotc = assistqueue,
	corack = cort2con,
	coracv = cort2con,
	coraca = cort2con,
	-- ASSIST
	corfast = assistqueue,
	--factories
	corlab = corkbotlab,
	corvp = corvehlab,
	corap = corairlab,
	coralab = corkbotlabT2,
	coravp = corvehlabT2,
	coraap = corairlabT2,
	corhp = corhoverlabT2,
	corgant = corgantryT3,

	---ARM
	--constructors
	armcom = armcommander,
	armck = armt1con,
	armcv = armt1con,
	armca = armt1con,
	armch = armt1con,
	armnanotc = assistqueue,
	armack = armt2con,
	armacv = armt2con,
	armaca = armt2con,
	--ASSIST
	armconsul = assistqueue,
	armfark = assistqueue,
	--factories
	armlab = armkbotlab,
	armvp = armvehlab,
	armap = armairlab,
	armalab = armkbotlabT2,
	armavp = armvehlabT2,
	armaap = armairlabT2,
	armhp = armhoverlabT2,
	armshltx = armgantryT3,
}
