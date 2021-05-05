
function GunMenu() --creating all the buy menu
	
	local sbW = ScrW() * 0.15
	local sbH = ScrH() * 0.035
	
	Frame = vgui.Create( "DFrame" )
	Frame:SetPos( ScrW() * 0.1, ScrH() * 0.01 )
	Frame:SetSize( ScrW() * 0.8, ScrH() * 0.89 )
	Frame:SetTitle( "" )
	Frame:SetDraggable( false )
	Frame:MakePopup()
	Frame:ShowCloseButton(false)
	Frame:GetSizable(false)
	
	
	
	-- loop for creating the left list (weapons categories). less code , more efficiency 
	tblnames = {"Pistol","Shotgun","SMG","Rifle","LMG","Ammo","Equipment"}	
	
	for k, v in pairs( tblnames ) do
	
		local Hpos = (ScrH() * k * 0.075) + 28					-- the height position of a button 
		local Buttontext = k .."  " .. string.upper(v) .. "S" 
		
		
		
		if v == "Ammo" then			-- the ammo button use another function !
			Button[v] = vgui.Create( "DButton", Frame )					
			Button[v]:SetText( "" )
			Button[v]:SetPos( ScrW() * 0.05 , Hpos ) 
			Button[v]:SetSize( sbW, sbH )
			Button[v].DoClick = function() buyAmmo() end
			Button[v].Paint = function()
				surface.SetDrawColor( 0, 0, 0, 100 )
				surface.DrawRect( 0, 0, Button[v]:GetWide(), Button[v]:GetTall() )
				surface.SetDrawColor( 250, 180, 0, 150 )
				surface.DrawOutlinedRect( 0, 0, Button[v]:GetWide(), Button[v]:GetTall() )
				draw.WordBox( 0, 10, 10 , "6 AMMO " , "HudHintTextLarge", Color( 0, 0, 0, 0 ) , Color( 250, 180, 0, 170 ) )
			end
		else
			Button[v] = vgui.Create( "DButton", Frame )					
			Button[v]:SetText( "" )								
			Button[v]:SetPos( ScrW() * 0.05 , Hpos ) 
			Button[v]:SetSize( sbW, sbH )
			Button[v].DoClick = function() LoadWeaponClass(v) end
			Button[v].Paint = function()
				surface.SetDrawColor( 0, 0, 0, 100 )
				surface.DrawRect( 0, 0, Button[v]:GetWide(), Button[v]:GetTall() )
				surface.SetDrawColor( 250, 180, 0, 150 )
				surface.DrawOutlinedRect( 0, 0, Button[v]:GetWide(), Button[v]:GetTall() )
				draw.WordBox( 0, 10, 10 , Buttontext , "HudHintTextLarge", Color( 0, 0, 0, 0 ) , Color( 250, 180, 0, 170 ) ) 
				
			end

		end
		
	end
	
	
	local buytimeLabel = vgui.Create( "DLabel", Frame )
	buytimeLabel:SetPos( 40, 40 )
	
	
	hook.Add( "Tick", "CheckPlayerMenucontrol", function()
		
		if buytime > 0 then
			buytimeLabel:SetText( "Time left : " .. math.floor(timer.TimeLeft( "thebuytime" )) )
		else
			buytimeLabel:SetText( "" ) 
		end
	
		
		-- child 1,2 and 3 are the close button of the frame
		if input.IsKeyDown( 38 ) then 
			Frame:GetChild(4).DoClick() -- Pistols
		end
		if input.IsKeyDown( 39 ) then
			Frame:GetChild(5).DoClick() -- Shotguns
		end
		if input.IsKeyDown( 40 ) then
			Frame:GetChild(6).DoClick() -- Smgs
		end
		if input.IsKeyDown( 41 ) then
			Frame:GetChild(7).DoClick() -- Rifles
		end
		if input.IsKeyDown( 42 ) then
			Frame:GetChild(8).DoClick() -- Lmgs
		end
		if input.IsKeyDown( 43 ) then
			Frame:GetChild(9).DoClick()-- ammo
			CloseTheMenu()
		end
		if input.IsKeyDown( 44 ) then
			Frame:GetChild(10).DoClick() -- equipment
		end
		if input.IsKeyDown( 37 ) or  input.IsKeyDown( 70 ) then 	-- close
			CloseTheMenu()
		end
		
	end)

	

	
	local iconK = vgui.Create( "DKillIcon", Frame )
	iconK:SetName( "weapon_crowbar" )
	iconK:SetPos( ScrW() * 0.1, ScrH() * 0.04 )				 
	iconK:SetSize( 10,10 )
	


	closeButton = vgui.Create( "DButton", Frame )					
	closeButton:SetText( "" )								
	closeButton:SetPos( ScrW() * 0.05 , ScrH() * 0.8 )				 
	closeButton:SetSize( sbW, sbH )			 							
	closeButton.DoClick = function() CloseTheMenu() end
	closeButton.Paint = function()
		surface.SetDrawColor( 0, 0, 0, 100 )
		surface.DrawRect( 0, 0, closeButton:GetWide(), closeButton:GetTall() )
		surface.SetDrawColor( 250, 180, 0, 150 )
		surface.DrawOutlinedRect( 0, 0, closeButton:GetWide(), closeButton:GetTall() )
		draw.WordBox( 0, 10, 10 , "0  CANCEL ", "HudHintTextLarge", Color( 0, 0, 0, 0 ) , Color( 250, 180, 0, 150 ) ) 
	end

	
	local ShapeL = vgui.Create( "DShape", Frame )
	ShapeL:SetType( "Rect" ) 
	ShapeL:SetSize( 5, ScrH() * 0.74 )
	ShapeL:SetPos( ScrW() * 0.21 , ScrH() * 0.1 )
	ShapeL:SetColor( Color( 250, 180, 0, 40 ) )
	
	function CloseTheMenu()
		Frame:Close() 
		popmenu = true 
		hook.Remove( "Tick", "CheckPlayerMenucontrol" )
	end

	
	
	
	

-- Weapons Content Creation Here ! -- 	

	ScrollCenter = vgui.Create( "DScrollPanel", Frame ) 
	ScrollCenter:SetSize( ScrW() * 0.4 , ScrH() * 0.73 )
	ScrollCenter:SetPos( ScrW() * 0.25 , ScrH() * 0.1 )
	

	ListCenter = vgui.Create( "DIconLayout", ScrollCenter )
	ListCenter:SetSize( ScrW() * 0.2 , ScrH() * 0.6 )
	ListCenter:SetPos( 0,5 )
	ListCenter:SetSpaceY( (ScrH() * 0.04 ) )  -- 
	ListCenter:SetSpaceX( 20 )	
	
	

	
	-- This loop create the center menu when a button (category) is pressed 
	function LoadWeaponClass(laClasse)
	
		ListCenter:Clear()
		local icon = {}
		local weaponSort = {}
		
		-- the armor exception (its use another function for giving armor ..)
		if laClasse == "Equipment" then 
			
			ButtonArmor = vgui.Create( "DButton", Frame )					
			ButtonArmor:SetText( "" )												 
			ButtonArmor:SetSize( sbW, sbH )			 							
			ButtonArmor.DoClick = function() buyArmor() end
			ButtonArmor.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 100 )
				surface.DrawRect( 0, 0, ButtonArmor:GetWide(), ButtonArmor:GetTall() )
				surface.SetDrawColor( 250, 180, 0, 150 )
				surface.DrawOutlinedRect( 0, 0, ButtonArmor:GetWide(), ButtonArmor:GetTall() )
				draw.WordBox( 0, 10, 10 , "Armor : 1000$", "HudHintTextLarge", Color( 0, 0, 0, 0 ) , Color( 250, 180, 0, 150 ) ) 
			end
			
			ListCenter:Add(ButtonArmor)
			
		end
		
		net.Start( "ShowAllWeaps" )
		net.SendToServer()
		net.Receive( "ShowAllWeaps", function(ln, pl)

			weaponlistdata = net.ReadTable()

			for k, v in pairs( weaponlistdata ) do
			
				if(v.class == laClasse) then

					Button[k] = vgui.Create( "DButton", Frame )					
					Button[k]:SetText( "" )												 
					Button[k]:SetSize( sbW, sbH )			 							
					Button[k].DoClick = function()  SendToServerSpawnWeapon(v.key_name, tonumber(v.price) )  end
					Button[k].Paint = function()
						surface.SetDrawColor( 0, 0, 0, 100 )
						surface.DrawRect( 0, 0, Button[k]:GetWide(), Button[k]:GetTall() )
						surface.SetDrawColor( 250, 180, 0, 150 )
						surface.DrawOutlinedRect( 0, 0, Button[k]:GetWide(), Button[k]:GetTall() )
						draw.WordBox( 0, 10, 10 , v.name .. " : " .. v.price .. "$" , "HudHintTextLarge", Color( 0, 0, 0, 0 ) , Color( 250, 180, 0, 150 ) ) 
					end
					
					ListCenter:Add(Button[k])
				end

			end
		end)

	end
	
	
	--final frame painting
	
	Frame.Paint = function()
		draw.RoundedBox( 20, 0, 0, Frame:GetWide(), Frame:GetTall(),  Color( 0 ,0 ,0 , 240 ) )	
	end	
	
	
end