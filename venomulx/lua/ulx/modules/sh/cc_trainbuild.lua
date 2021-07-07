
// COMMANDS

-------------------------------------------------------------backseat---------------------------------------------------------------------------
function ulx.backseat (calling_ply)
    -- Caller is the player who issued the command.
    -- args is the string or player arguments that may have been passed.

    if IsValid(calling_ply) then
        if calling_ply.UlxLastVehicle and IsValid(calling_ply.UlxLastVehicle) then
            calling_ply:EnterVehicle(calling_ply.UlxLastVehicle)
        else
            ply:ChatPrint("Your last seat is invalid.")
        end
    end
    ulx.fancyLogAdmin( calling_ply, "#A has sent themselves to their last seat.")
end
local backseat = ulx.command( "Venom", "ulx backseat", ulx.backseat, "!backseat" )
backseat:defaultAccess( ULib.ACCESS_SUPERADMIN)
backseat:help("Sends you back to your previous seat.")

--------------------------------------------------------------freezeall---------------------------------------------------------------------------
function ulx.freezeall (calling_ply)
    for k,v in pairs(ents.GetAll()) do
        if v:CPPIGetOwner()==calling_ply then
            local phys = v:GetPhysicsObject()
            if IsValid(phys) then
                phys:EnableMotion(false )
            end
        end
    end
    ulx.fancyLogAdmin( calling_ply, "#A has frozen all of their entities.")
end

local freezeall = ulx.command( "Venom", "ulx freezeall", ulx.freezeall, "!freezeall")
freezeall:defaultAccess( ULib.ACCESS_SUPERADMIN)
freezeall:help("Freezes all of your entities.")

// HOOKS
hook.Add("PlayerLeaveVehicle","Ulx_Backseat", function(P,V)
P.UlxLastVehicle = V

end)
