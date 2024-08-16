function widget:GetInfo()
	return {
		name = "Start Polygons",
		desc = "Displays Start Polygons",
		author = "Beherith",
		date = "2024.08.16",
		license = "GNU GPL, v2 or later",
		layer = -1,
		enabled = true,
	}
end

-- Note: this is now updated to support arbitrary start polygons via GL.SHADER_STORAGE_BUFFER

-- The format of the buffer is the following:
-- Triplets of :teamID, triangleID, x, z

-- Spring.Echo(Spring.GetTeamInfo(Spring.GetMyTeamID()))

local scavengerAITeamID = 999
local raptorsAITeamID = 999
local scavengerAIAllyTeamID = 999
local raptorsAIAllyTeamID = 999
local teams = Spring.GetTeamList()

for i = 1, #teams do
	local luaAI = Spring.GetTeamLuaAI(teams[i])
	if luaAI and luaAI ~= "" and string.sub(luaAI, 1, 12) == 'ScavengersAI' then
		scavengerAITeamID = i - 1
		scavengerAIAllyTeamID = select(6, Spring.GetTeamInfo(scavengerAITeamID))
		break
	end
end
for i = 1, #teams do
	local luaAI = Spring.GetTeamLuaAI(teams[i])
	if luaAI and luaAI ~= "" and string.sub(luaAI, 1, 12) == 'RaptorsAI' then
		raptorsAITeamID = i - 1
		raptorsAIAllyTeamID = select(6, Spring.GetTeamInfo(raptorsAITeamID))
		break
	end
end

---- Config stuff ------------------
local autoReload = true -- refresh shader code every second (disable in production!)

local StartPolygons = {} -- list of points in clockwise order

local luaShaderDir = "LuaUI/Widgets/Include/"
local LuaShader = VFS.Include(luaShaderDir.."LuaShader.lua")
VFS.Include(luaShaderDir.."instancevbotable.lua")

local minY, maxY = Spring.GetGroundExtremes()

local shaderSourceCache = {
		vssrcpath = "LuaUI/Widgets/Shaders/map_startpolygon_gl4.vert.glsl",
		fssrcpath = "LuaUI/Widgets/Shaders/map_startpolygon_gl4.frag.glsl",
		uniformInt = {
			mapDepths = 0,
			myTeamID = -1,
		},
		uniformFloat = {
		},
		shaderName = "Start Polygons GL4",
		shaderConfig = {
			ALPHA = 0.5,
			NUM_BOXES = NUM_POLYGONS,
			MINY = minY - 10,
			MAXY = maxY + 100,
		},
	}

local fullScreenRectVAO
local startPolygonShader

-- Locals for speedups
local glTexture = gl.Texture
local glCulling = gl.Culling
local glDepthTest = gl.DepthTest
local spIsGUIHidden			= Spring.IsGUIHidden

local startPolygonBuffer = nil -- GL.SHADER_STORAGE_BUFFER for polygon

function widget:RecvLuaMsg(msg, playerID)
	--Spring.Echo("widget:RecvLuaMsg",msg)
	if msg:sub(1,18) == 'LobbyOverlayActive' then
		chobbyInterface = (msg:sub(1,19) == 'LobbyOverlayActive1')
	end
end

function widget:DrawWorldPreUnit()
	if autoReload then
		startPolygonShader = LuaShader.CheckShaderUpdates(shaderSourceCache) or startPolygonShader
	end

	if chobbyInterface or spIsGUIHidden() then return end

	local advUnitShading, advMapShading = Spring.HaveAdvShading()

	if advMapShading then 
		gl.Texture(0, "$map_gbuffer_zvaltex")
	else
		if WG['screencopymanager'] and WG['screencopymanager'].GetDepthCopy() then
			gl.Texture(0, WG['screencopymanager'].GetDepthCopy())
		else return	end
	end
	
	startPolygonBuffer:BindBufferRange(4)

	glCulling(GL.FRONT)
	glDepthTest(false)
	gl.DepthMask(false)

	startPolygonShader:Activate()
	for i, startBox in ipairs(StartPolygons) do
		--Spring.Echo("StartPolygons["..i.."]", startBox[1],startBox[2],startBox[3],startBox[4])
		startPolygonShader:SetUniform("StartPolygons["..( i-1) .."]", startBox[1],startBox[2],startBox[3],startBox[4])
	end
	startPolygonShader:SetUniform("noRushTimer", noRushTime)
	startPolygonShader:SetUniform("myTeamID", Spring.GetMyAllyTeamID() or -1) 
	fullScreenRectVAO:DrawArrays(GL.TRIANGLES)
	startPolygonShader:Deactivate()
	glTexture(0, false)
	glCulling(false)
	glDepthTest(false)
end

function widget:GameFrame(n)
	-- TODO: Remove the widget when the timer is up?
end

function widget:Initialize()
	Spring.Echo("Norush Timer GL4: HELLO	", numtriangles)
	local gaiaAllyTeamID
	if Spring.GetGaiaTeamID() then 
		gaiaAllyTeamID = select(6, Spring.GetTeamInfo(Spring.GetGaiaTeamID() , false))
	end
	for i, teamID in ipairs(Spring.GetAllyTeamList()) do
		if teamID ~= gaiaAllyTeamID and teamID ~= scavengerAIAllyTeamID and teamID ~= raptorsAIAllyTeamID then
			local xn, zn, xp, zp = Spring.GetAllyTeamStartBox(teamID)
			--Spring.Echo("Allyteam",teamID,"startbox",xn, zn, xp, zp)	
			StartPolygons[teamID] = {{xn, zn}, {xp, zn}, {xp, zp}, {xn, zp}}
		end
	end
	
	if autoReload then
		-- MANUAL OVERRIDE FOR DEBUGGING
		-- lets add a bunch of silly StartPolygons:
		StartPolygons = {}
		for i = 2,8 do
			local x0 = math.random(0, Game.mapSizeX)
			local y0 = math.random(0, Game.mapSizeZ)
			local polygon = {{x0, y0}}

			for j = 2, math.ceil(math.random() * 10) do 
				local x1 = math.random(0, Game.mapSizeX / 20)
				local y1 = math.random(0, Game.mapSizeZ / 20)
				polygon[#polygon+1] = {x0+x1, y0+y1}
			end
			StartPolygons[#StartPolygons+1] = polygon
		end
	end

	shaderSourceCache.shaderConfig.NUM_BOXES = #StartPolygons

	local numvertices = 0
	local numtriangles = 0
	local bufferdata = {}
	local numPolygons = 0
	for teamID, polygon in pairs(StartPolygons) do
		numPolygons = numPolygons + 1
		local numPoints = #polygon
		for vertexID, vertex in ipairs(polygon) do
			local x, z = vertex[1], vertex[2]
			bufferdata[#bufferdata+1] = teamID
			bufferdata[#bufferdata+1] = numPoints
			bufferdata[#bufferdata+1] = x
			bufferdata[#bufferdata+1] = z
			numvertices = numvertices + 1
		end
	end

	-- SHADER_STORAGE_BUFFER MUST HAVE 64 byte aligned data 
	Spring.Echo("what", numvertices, ' - ',(4 - (numvertices % 4)) * 4 , #bufferdata)
	if numvertices % 4 ~= 0 then 
		for i=1, ((4 - (numvertices % 4)) * 4) do bufferdata[#bufferdata+1] = -1 end
		numvertices = numvertices + (4 - numvertices % 4)
	end

	Spring.Echo('startPolygonBuffer', numvertices, numPolygons, #bufferdata)
	startPolygonBuffer = gl.GetVBO(GL.SHADER_STORAGE_BUFFER)
	startPolygonBuffer:Define(numvertices, {{id = 0, name = 'starttriangles', size = 4}})
	local success = startPolygonBuffer:Upload(bufferdata)--, -1, 0, 0, numvertices-1)

	shaderSourceCache.shaderConfig.NUM_POLYGONS = numPolygons
	startPolygonShader = LuaShader.CheckShaderUpdates(shaderSourceCache) or startPolygonShader

	if not startPolygonShader then
		Spring.Echo("Error: Norush Timer GL4 shader not initialized")
		widgetHandler:RemoveWidget()
		return
	end
	fullScreenRectVAO = MakeTexRectVAO()
end
