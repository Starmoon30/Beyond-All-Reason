-- This file has been automatically generated by texture_atlas_builder.ipynb
-- Do not edit this file!
-- Note that the UV coordinates are unpadded, if you must avoid bleed then pad it with 0.5/atlas size 
local atlas = {
	atlasimage = "luaui/images/particlesGL4/particlesgl4_minus.dds",
	width = 4096,
	height = 4096,
	flip = function(t) for k,v in pairs(t) do if type(v) == "table" then v[3], v[4] = 1.0 - v[3], 1.0 - v[4] end end end ,
	pad = function(t,p) for k,v in pairs(t) do if type(v) == "table" then p = p or 0.5; local px,py = p/t.width, p/t.height; v[1], v[2], v[3], v[4] = v[1] + px, v[2]-px, v[3] + py, v[4] - py end end end ,
	getUVCoords = function(t, name) if t[name] then return t[name][1], t[name][2], t[name][3], t[name][4] else return 0,1,0,1 end end ,
	["luaui/images/particlesGL4/TXT_Pyro_SmokeLoop_A_N.tga"] = {0.25,0.5,0.5,0.75,1024,1024}, 
	["luaui/images/particlesGL4/TXT_Pyro_SmokeLoop_Top_A_N.tga"] = {0.25,0.5,0.25,0.5,1024,1024}, 
	["luaui/images/particlesGL4/TX_Pyro_AerialBurst_N.tga"] = {0.5,0.75,0.75,1.0,1024,1024}, 
	["luaui/images/particlesGL4/TX_Pyro_CloudsWisp_A_2x2_N.tga"] = {0.0,0.25,0.25,0.375,1024,512}, 
	["luaui/images/particlesGL4/TX_Pyro_Clouds_A_2x4_N.tga"] = {0.5,0.75,0.5,0.75,1024,1024}, 
	["luaui/images/particlesGL4/TX_Pyro_Fireball_A_N.tga"] = {0.25,0.5,0.875,1.0,1024,512}, 
	["luaui/images/particlesGL4/TX_Pyro_GazExplosion_A_N.tga"] = {0.5,0.75,0.25,0.5,1024,1024}, 
	["luaui/images/particlesGL4/TX_Pyro_GazExplosion_B_N.tga"] = {0.125,0.25,0.625,0.875,512,1024}, 
	["luaui/images/particlesGL4/TX_Pyro_GazExplosion_C_N.tga"] = {0.125,0.25,0.375,0.625,512,1024}, 
	["luaui/images/particlesGL4/TX_Pyro_GroundExplosion_A_N.tga"] = {0.75,1.0,0.75,1.0,1024,1024}, 
	["luaui/images/particlesGL4/TX_Pyro_GroundExplosion_B_N.tga"] = {0.75,1.0,0.5,0.75,1024,1024}, 
	["luaui/images/particlesGL4/TX_Pyro_RollingBall_A_N.tga"] = {0.75,1.0,0.25,0.5,1024,1024}, 
	["luaui/images/particlesGL4/TX_Pyro_Shockwave_Side_N.tga"] = {0.75,1.0,0.0,0.25,1024,1024}, 
	["luaui/images/particlesGL4/TX_Pyro_Shockwave_Top_N.tga"] = {0.5,0.75,0.0,0.25,1024,1024}, 
	["luaui/images/particlesGL4/TX_Pyro_SideExplosion_A_N.tga"] = {0.25,0.5,0.75,0.875,1024,512}, 
	["luaui/images/particlesGL4/TX_Pyro_SmokeStack_A_N.tga"] = {0.0,0.125,0.375,0.625,512,1024}, 
	["luaui/images/particlesGL4/TX_Pyro_SmokeSteam_A_N.tga"] = {0.125,0.25,0.875,0.9375,512,256}, 
	["luaui/images/particlesGL4/TX_Pyro_SteamBall_A_N.tga"] = {0.25,0.5,0.0,0.25,1024,1024}, 
	["luaui/images/particlesGL4/TX_Pyro_Tendril_A_N.tga"] = {0.0,0.25,0.0,0.25,1024,1024}, 

}
return atlas
