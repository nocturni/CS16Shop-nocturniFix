
----- GET THE MONEY IN THE BANK BITCH -----

hook.Add( "Think", "win money !", function()

	net.Receive( "giveMoney", function(ln, pl)
		playermoney = playermoney + net.ReadInt(16)
	end)
end)



net.Receive( "startmoney", function(ln, pl)
	
	playermoney = net.ReadInt(32)
	
end)



net.Receive( "sqlenabled", function(ln, pl)
	
	if net.ReadInt(16) == 1 then
		timer.Create("update database", 10, 0, function() 
			
			net.Start( "updatedb" )	
			net.WriteInt(playermoney, 32)
			net.SendToServer()

		end) 
	end
end)

	------ FUNCTIONS -------- 


----  money transaction functions -----
 

function Transaction(price)
	
	if playermoney >= price then 
		playermoney = playermoney - price
		return true 
	else
		return false
	end
	
	
end



-- buy the ammo and order (to the server)
AmmoBlackList = { "weapon_frag", "weapon_slam" }

clipsToClass = table.CollapseKeyValue(
{
	{ Key = "Pistol", Value = 5 },
	{ Key = "Shotgun", Value = 4 },
	{ Key = "SMG", Value = 4 },
	{ Key = "Rifle", Value = 3 },
	{ Key = "LMG", Value = 1 },

})

function buyAmmo()

	if ply:GetActiveWeapon():IsWeapon() then
		
		local Weap = ply:GetActiveWeapon()
		local clipSize = Weap:GetMaxClip1()
		nbclip = 5

		if clipSize != -1 then -- block crowbar causing error

			if  not table.HasValue( AmmoBlackList, Weap:GetClass()) then -- block grendes
				local AmmoID = Weap:GetPrimaryAmmoType()

				net.Start( "ShowAllWeaps" )
				net.SendToServer()
				net.Receive( "ShowAllWeaps", function(ln, pl) 

					data = net.ReadTable()

					for k,v in pairs(data) do 
						if v.key_name == Weap:GetClass() then 
							nbclip = clipsToClass[v.class]

						end
					end

					local AmmoNeeded = clipSize * nbclip - ply:GetAmmoCount( AmmoID )
					
					if AmmoNeeded > 1 then
						if playermoney < AmmoNeeded*2 then 			-- because 1 ammo cost 2$
							AmmoNeeded = playermoney/2
							playermoney = 0 
						else 
							playermoney = playermoney - AmmoNeeded*2 
						end
						
						net.Start( "giveAMMO" )	
						net.WriteInt(AmmoNeeded , 16)
						net.WriteString(AmmoID)
						net.SendToServer()
					end	

				end)
			end
		end
	end
end



function buyArmor()

	if ply:Armor() < 50  then 
		if playermoney >= 1000 then
			playermoney = playermoney - 1000
			net.Start( "giveArmor" ) 	--order a armor 
			net.SendToServer()
			surface.PlaySound( "items/suitchargeok1.wav" )
		else
			ply:PrintMessage( HUD_PRINTTALK, "Not enough money :/ " )
		end
	else
		ply:PrintMessage( HUD_PRINTTALK, "Your armor is > to 50" )
	end
	
end


-- draw the money hud 
hook.Add( "HUDPaint", "Money In The Wallet of the bitch client", function()

	draw.RoundedBox( 5 , ScrW() * 0.9, ScrH() * 0.85, 150, 50, Color(0, 0, 0, 128) )
	draw.DrawText( tostring(playermoney) .. " $ ", "DermaLarge", ScrW() * 0.95, ScrH() * 0.86, Color( 100, 250, 50, 255 ), TEXT_ALIGN_CENTER )

end) 