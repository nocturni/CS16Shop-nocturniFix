
-- BUY MENU CONFIGURATION -- 


net.Receive( "buymenutime", function(ln, pl)
	
	timer.Stop( "thebuytime" )
	timer.Remove( "thebuytime" )
	popmenu = true	
	buytime = net.ReadInt(16)

	if buytime > 0 then 
		timer.Create( "thebuytime" ,buytime,1, function()
			
			if popmenu == false then
				CloseTheMenu()
			end

			buymenutimeEnded = true
			popmenu = false
			
		end)
	end 

end)
 

timer.Simple(1,function()
	hook.Add( "Tick", "check_openmenu", function()
	    if input.IsKeyDown( ply:GetPData("openbuymenu_bind",12) )then
	        
	        -- open the buy menu if the player is alive or is not typing in the chat 
			if not ply:IsTyping() and ply:Alive() and popmenu then 
				
				GunMenu()				--open the buy menu
				popmenu = false 		--can open once until you click on the close button
				
			end
	    end
	end)
end)



-- SEND WEAPON GIVE -- 
function SendToServerSpawnWeapon(weaponName,price)

local haveweapon = false

	for k, v in pairs( ply:GetWeapons() ) do --test if the player have already this weapon, prevent buying two time the same weapon

		if v ==	ply:GetWeapon( weaponName ) then 
			haveweapon = true
			ply:PrintMessage( HUD_PRINTTALK, "You have already this weapon ! " )
		end
	end
	
	if haveweapon == false then
	
		if Transaction(price) == true then
		
			net.Start( "giveweapon" ) 
			net.WriteString( weaponName )
			net.SendToServer()
		else
			ply:PrintMessage( HUD_PRINTTALK, "Not enough money to buy this ... " )
		
		end
	end
end


------------------ drop empty nades -----------------

local grenades = {"weapon_frag"}

hook.Add( "KeyRelease", "keypress_tamer", function( ply, key )
	
	if  key == IN_ATTACK or key == IN_ATTACK2 then
	
		if ply:GetActiveWeapon():IsValid() then
			local weapabcd =  ply:GetActiveWeapon()
			
			if table.HasValue( grenades , weapabcd:GetClass() ) then
			
				timer.Create( "checkammo", 0.5 , 5, function()  
				
					if ply:Alive() then
						if not weapabcd:HasAmmo() then
						
							timer.Remove( "checkammo" )
							net.Start( "destroyNade" ) -- send to server the weapon to strip
							net.WriteString( weapabcd:GetClass() )
							net.SendToServer()
						
						end
					end
				end)
			end
		end
	end

end)

