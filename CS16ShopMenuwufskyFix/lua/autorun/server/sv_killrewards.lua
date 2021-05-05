CreateConVar( "buymenumod_npckilledreward", "50" , {FCVAR_REPLICATED,FCVAR_NOTIFY,FCVAR_ARCHIVE} , "money given when you kill an npc")
CreateConVar( "buymenumod_playerkilledreward", "300" , {FCVAR_REPLICATED,FCVAR_NOTIFY,FCVAR_ARCHIVE} , "money given when you kill another player")
CreateConVar( "buymenumod_playerhitreward", "3" , {FCVAR_REPLICATED,FCVAR_NOTIFY,FCVAR_ARCHIVE} , "money given when you hit another player")


hook.Add( 'PlayerDeath', 'DeathReward', function( victim, inflictor, attacker )

	local reward = GetConVar( "buymenumod_playerkilledreward"):GetInt()
	RewardPlayer(victim, attacker , reward )
	
	if attacker:IsPlayer() and victim:IsPlayer() then
	
		countPlayerStats(victim, attacker)

	end
end)


hook.Add ( "PlayerHurt", "HitReward" ,function( player, attacker, healthleft, damage )
	
	if attacker:IsPlayer() then
	
		local reward = GetConVar("buymenumod_playerhitreward"):GetInt()
		RewardPlayer(player, attacker, damage*reward )
		
	end
end)



hook.Add( 'OnNPCKilled', 'KillNPC_Reward', function( victim, inflictor, attacker )
	
	if not table.HasValue( NpcBlacklist , victim:GetClass() ) then
		
		local reward = GetConVar( "buymenumod_npckilledreward" ):GetInt()
		RewardPlayer(victim, inflictor,reward)
		
	end
end)



util.AddNetworkString( "giveMoney" )
function RewardPlayer(victim, attacker, amount)
	if victim != attacker and attacker:IsPlayer() then 
		
		net.Start( "giveMoney" ) 
		net.WriteInt(amount, 16 )
		net.Send(attacker)

	end	
end



function countPlayerStats(victim, attacker)
	
	
	local MultOfTenfrag = attacker:Frags()/10
	for i = 1 , 9 do 
		if MultOfTenfrag == i then
		
			RewardPlayer(victim, attacker, 1000)
		
		end
	end
	
	if attacker:Frags() == 100 then
	
		RewardPlayer(victim, attacker, 10000)
	
	end
	
	-- give 1000$ to victim foreach 10 deaths
	local MultOfTendeath = victim:Deaths()/10
	for i = 1 , 9 do 
		if MultOfTendeath == i then
		
			RewardPlayer(attacker, victim, 1000)
		
		end
	end
	
	if victim:Deaths() == 100 then
	
		RewardPlayer(attacker,victim, 10000)
	
	end
end


 
NpcBlacklist = {
	"npc_citizen",
	"npc_mossman",
	"npc_eli",
	"npc_alyx",
	"npc_barney",
	"npc_dog",
	"npc_citizen",
	"npc_vortigaunt",
	"npc_kleiner",
	"npc_crow",
	"npc_pigeon",
	"npc_seagull"
}