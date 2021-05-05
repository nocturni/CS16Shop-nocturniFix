

function SQLinit()
	
	sql.Query( "CREATE TABLE IF NOT EXISTS main.playermoney (steamid VARCHAR PRIMARY KEY  NOT NULL , playername VARCHAR NOT NULL , money NOT NULL)" )

	print("buymenumod Database SQLite loaded")
end


function SQLCheckPlayer(steamid)

	return sql.QueryValue("SELECT EXISTS( SELECT steamid FROM main.playermoney WHERE steamid = '"..steamid .."')") 
	
end


function SQLNewPlayer(steamid,playername,money)
	
	local plyname = string.Replace( playername, "'", "" )
	
	sql.Query("INSERT INTO main.playermoney VALUES ('".. steamid .."','".. plyname .."',".. money ..") ")

end


function SQLGetMoneyFromPlayer(steamid)
	

	local data = sql.QueryRow(" SELECT * FROM main.playermoney  WHERE steamid =  '".. steamid .."' ")
	return data["money"] 
	
end


function SQLUpdatePlayer(steamid,playername,money)
	
	local plyname = string.Replace( playername, "'", "" )
	
	sql.Query( "UPDATE main.playermoney SET playername = '".. plyname .."', money = ".. money .." WHERE steamid = '".. steamid .."'" )
	
end

-- first load here ! don't move this ... 
if GetConVar( "buymenumod_sqlenabled" ):GetInt() == 1 then 
	SQLinit()
end






-- storage weaps functions : 

sql.Query( "CREATE  TABLE  IF NOT EXISTS 'main'.'weaponlist' ('key_name' VARCHAR PRIMARY KEY  NOT NULL , 'name' VARCHAR NOT NULL , 'price' NUMERIC NOT NULL , 'class' VARCHAR NOT NULL)" )

function SQLShowAll()

	return sql.Query("SELECT * FROM 'main'.'weaponlist' ORDER BY price ")

end

function SQLAddWeapon(kn,n,p,c)

	local qr = "INSERT INTO 'main'.'weaponlist' ('key_name','name','price','class') VALUES ('"..kn.."','"..n.."',"..p..",'"..c.."')"
	sql.Query(qr)
end


function SQLRemoveItem(key_name)

	sql.Query("DELETE FROM weaponlist WHERE key_name = '"..key_name.."'")

end


	-- local qr = sql.SQLStr() 
	-- sql.Query(qr)