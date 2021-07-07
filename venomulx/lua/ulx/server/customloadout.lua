-- Adds crowbar on playerspawn

function Custom_Loadout( ply )

	ply:Give("crowbar") --Gives the player weapon crowbar
 
end
 hook.Add( "PlayerLoadout", "CustomGamemodeLoadoutFunction", Custom_Loadout)