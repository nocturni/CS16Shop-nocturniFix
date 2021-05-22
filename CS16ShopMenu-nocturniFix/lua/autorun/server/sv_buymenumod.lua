CreateConVar( "buymenumod_buytime", "0", {FCVAR_REPLICATED,FCVAR_NOTIFY,FCVAR_ARCHIVE} , "maximum time a player can buy weapons, 0 is infinite") --FCVAR_ARCHIVE is needed to save the value ! 
CreateConVar( "buymenumod_startmoney", "1000" , {FCVAR_REPLICATED,FCVAR_NOTIFY,FCVAR_ARCHIVE} , "money given the first spawn")
CreateConVar( "buymenumod_sqlenabled", "0" , {FCVAR_REPLICATED,FCVAR_ARCHIVE} , "enable server database, for keep money for players")



-- Configure client to the specified buytime 
util.AddNetworkString( "buymenutime" )
hook.Add( "PlayerSpawn", "KKOIJEF", function(ply)
	
	net.Start( "buymenutime" )
	local buytime = GetConVar( "buymenumod_buytime" ):GetInt()
	net.WriteInt(buytime , 16)
	net.Send( ply )
	
	

end)

-- send start money when the client come to the server
util.AddNetworkString( "startmoney" )
hook.Add( "PlayerInitialSpawn", "startmoneyspawn1", function(ply)
	
	local stmne = GetConVar( "buymenumod_startmoney" ):GetInt()
	
	if GetConVar( "buymenumod_sqlenabled" ):GetInt() == 1 then 
		util.AddNetworkString( "sqlenabled" )
		net.Start( "sqlenabled" )
		local sqltg = GetConVar( "buymenumod_sqlenabled" ):GetInt()
		net.WriteInt(sqltg , 16)
		net.Send( ply )
		
		
		local res = SQLCheckPlayer( ply:SteamID() ) 
		
		if res == "0" then
			SQLNewPlayer(ply:SteamID(),ply:Nick(),stmne)
		else
			stmne = tonumber( SQLGetMoneyFromPlayer(ply:SteamID()) )
		end
	end
	
	net.Start( "startmoney" )
	net.WriteInt(stmne , 32)
	net.Send( ply )
	
end)



util.AddNetworkString( "updatedb" )
net.Receive( "updatedb", function( ln, pl )

	local playermoney = net.ReadInt(32)
	
	SQLUpdatePlayer(pl:SteamID(),pl:Nick(),playermoney)

end)




-- this is called when the player click on a weapon in the menu -- 
util.AddNetworkString( "giveweapon" )
 
net.Receive( "giveweapon", function(ln, pl)
	
	local wep = net.ReadString()
	pl:Give(wep)

end)



-- this is called when the player want to buy ammo -- 
util.AddNetworkString( "giveAMMO" )
 
net.Receive( "giveAMMO", function(ln, pl)
	
	local AmmoNeeded = net.ReadInt(16)
	local idammo = net.ReadString()
		
	pl:GiveAmmo( AmmoNeeded , tonumber(idammo) , false )

end)


-- this is called when the player want Armor -- 
util.AddNetworkString( "giveArmor" )
 
net.Receive( "giveArmor", function(ln, pl)
	
	pl:SetArmor( 100 )
	pl:PrintMessage( HUD_PRINTTALK, "Armor Given :) " )
	
end)




util.AddNetworkString( "ShowAllWeaps" )
net.Receive( "ShowAllWeaps", function(ln, pl)

	local data = SQLShowAll()
	net.Start("ShowAllWeaps")
	
	if data != nil then 
		net.WriteTable(data)
	else
		net.WriteTable({})
	end
	
	net.Send(pl)

end)


util.AddNetworkString( "addweap" )
net.Receive( "addweap", function(ln, pl)

	local lolz = net.ReadTable()
	SQLAddWeapon(lolz[1],lolz[2],tonumber(lolz[3]),lolz[4])

end)

util.AddNetworkString( "deleteweap" )
net.Receive( "deleteweap", function(ln, pl)

	SQLRemoveItem(net.ReadString())
	
end)
