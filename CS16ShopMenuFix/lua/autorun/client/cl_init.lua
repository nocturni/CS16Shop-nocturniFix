hook.Add( "InitPostEntity", "initialize player ?", function()

	ply = LocalPlayer()
	AddCSLuaFile("cl_buymenumod.lua")
	AddCSLuaFile("cl_moneyweapon.lua")
	AddCSLuaFile("cl_menuweaponoption.lua")
	AddCSLuaFile("cl_buymenucreation.lua") 

end)