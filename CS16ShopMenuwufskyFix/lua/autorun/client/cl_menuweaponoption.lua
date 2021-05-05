
function createthemenu()
	spawnmenu.AddToolMenuOption( "Options","CS 1.6 Shop Menu","Weapons Management","Manage weapons","","", TheMenu )
	spawnmenu.AddToolMenuOption( "Options","CS 1.6 Shop Menu","Configure Bind","Configure Bind","","", TheBindMenu )
end


hook.Add( "PopulateToolMenu", "pleasework", createthemenu )


function TheMenu( Panel )
if ply:IsAdmin() then

		reloadList( Panel )
		

		local DRemovebut = vgui.Create( "DButton",Panel )
		DRemovebut:SetPos( 80, 440 )
		DRemovebut:SetText( "Remove Selected Weapon" )
		DRemovebut:SetSize( 150, 30 )
		DRemovebut.DoClick = function()
			if AppList:GetSelectedLine() != nil then 
				local lol = AppList:GetLine(AppList:GetSelectedLine()):GetColumnText(1) 

				net.Start( "deleteweap" )
				net.WriteString(lol)
				net.SendToServer()

				reloadList( Panel )

			end
		end



		local TE1 = vgui.Create( "DComboBox", Panel )
		TE1:SetPos( 5, 530 )
		TE1:SetSize( 150, 20 )
		TE1:SetValue( "Choose a weapon : " )

		local allweaps = list.Get( "Weapon" )
		for k,v in pairs( allweaps ) do
			TE1:AddChoice( v.ClassName )
		end
		TE1.OnSelect = function( index, value, text )
		end

		
		TE2 = vgui.Create( "DTextEntry", Panel ) 
		TE2:SetPos( 5, 560 )
		TE2:SetSize( 150, 20 )
		TE2:SetText( "Enter weapon real name" )
		
		local DLer = vgui.Create( "DLabel", Panel )
		DLer:SetPos( 6, 590 )
		DLer:SetText( "Enter price :" )
		DLer:SetDark(true)

		local TE3 = vgui.Create( "DNumberWang", Panel ) 
		TE3:SetPos( 75, 590 )
		TE3:SetSize( 80, 20 )


		local TE4 = vgui.Create( "DComboBox", Panel )
		TE4:SetPos( 5, 620 )
		TE4:SetSize( 150, 20 )
		TE4:SetValue( "Choose a Class : " )
		TE4:AddChoice( "Pistol" )
		TE4:AddChoice( "Shotgun" )
		TE4:AddChoice( "SMG" )
		TE4:AddChoice( "Rifle" )
		TE4:AddChoice( "LMG" )
		TE4:AddChoice( "Equipment" )


		local DButton = vgui.Create( "DButton", Panel )
		DButton:SetPos( 5, 660 )
		DButton:SetText( "Add New Weapon" )
		DButton:SetSize( 150, 40 )
		DButton.DoClick = function()
			if TE1:GetSelected() != nil and TE2:GetText() != nil and TE4:GetSelected() != nil then 
		

				net.Start( "addweap" )
				net.WriteTable(  {TE1:GetSelected(),TE2:GetText(),TE3:GetValue(),TE4:GetSelected()}  )
				net.SendToServer()

				TE1:SetValue( "Choose a weapon : " )
				TE2:SetText("Enter Weapon Name")
				TE3:SetValue(0)
				TE4:SetValue( "Choose a Class : " )

				reloadList( Panel )

			end
		end
	else
		local Dlabel = vgui.Create( "DLabel", Panel )
		Dlabel:SetPos( 20, 20 )
		Dlabel:SetText( "YOU'RE NOT ADMIN " )
		Dlabel:SetDark(true)
	end
end


function reloadList( Panel )

	net.Start( "ShowAllWeaps" )
	net.SendToServer()
	net.Receive( "ShowAllWeaps", function(ln, pl)

		AppList = nil
		AppList = vgui.Create( "DListView",Panel )
		AppList:SetPos( 0, 20 )
		AppList:SetSize(320,420)
		AppList:SetMultiSelect( false )
		AppList:AddColumn( "Key name" )
		AppList:AddColumn( "Name" )
		AppList:AddColumn( "Price" )
		AppList:AddColumn( "class" )

		data = net.ReadTable()

		if data != nil then 
			for k ,v in pairs(data) do 
				AppList:AddLine(v.key_name,v.name,v.price,v.class)
			end
		end
		
	end)

end

	
function TheBindMenu( Panel )

	local binder = vgui.Create( "DBinder", Panel )
	binder:SetSize( 250, 50 )
	binder:SetPos( 25, 35 )

	binder:SetValue( ply:GetPData("openbuymenu_bind",12) )

	function binder:OnChange( num )
		
		ply:SetPData( "openbuymenu_bind", num ) 
		--print( ply:GetPData("openbuymenu_bind") , num )
	end

end