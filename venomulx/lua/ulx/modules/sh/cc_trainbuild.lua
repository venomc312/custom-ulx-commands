ulx.GotoExt = {}
ulx.GotoExt.Locations = {}

// Global Variables
local tabf = file.Read("ulx/locs.txt","DATA") or ""
local map = game.GetMap()

// Loc Management functions and hooks
ulx.GotoExt.Locations = util.JSONToTable(tabf)

if !ulx.GotoExt.Locations then
    ulx.GotoExt.Locations = {}
end

if !ulx.GotoExt.Locations[map] then
    ulx.GotoExt.Locations[map] = {}
end

local function save()
    file.Write("ulx/locs.txt",util.TableToJSON(ulx.GotoExt.Locations,true))
end
ulx.GotoExt.Save = save

function ulx.GotoExt.AddLocation(nam, loc)
    local nam = string.lower(nam)
    if ulx.GotoExt.Locations[map][nam] then
        return false, "This location already exists "
    end
    ulx.GotoExt.Locations[map][nam] = loc
    save()
    return true 
end

function ulx.GotoExt.RemoveLocation(nam)
    local nam = string.lower(nam)
    if !ulx.GotoExt.Locations[map][nam] then
        return false, "Location does not exist "
    end
    ulx.GotoExt.Locations[map][nam] = nil 
    save()
    return true
end

function ulx.GotoExt.GetLocation(nam)
    local nam = string.lower(nam)
    if !ulx.GotoExt.Locations[map][nam] then
        return false, "Location was not found in table"
    end
    return ulx.GotoExt.Locations[map][nam]
end

function ulx.GotoExt.GetTable(nam)
    return table.Copy(ulx.GotoExt.Locations[map])
end




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

---------------------------------------------tp commands------------------------------------------
function ulx.locadd( calling_ply, name)
    if !name then
        ulx.fancyLogAdmin("No name was given.")
    end

    local res,err = ulx.GotoExt.AddLocation(name,calling_ply:GetEyeTraceNoCursor().HitPos)
    if !res then
        ulx.fancyLogAdmin(err, "#A")
        return;
    end
    ulx.fancyLogAdmin( calling_ply, "#A has added location #s", name)

end

local locadd = ulx.command( "Location Management", "ulx locadd", ulx.locadd, "!locadd")
locadd:addParam{ type=ULib.cmds.StringArg, hint="Location name"}
locadd:defaultAccess( ULib.ACCESS_SUPERADMIN)
locadd:help("Adds a location that everyone on the server can teleport too.")


// HOOKS
hook.Add("PlayerLeaveVehicle","Ulx_Backseat", function(P,V)
P.UlxLastVehicle = V

end)
