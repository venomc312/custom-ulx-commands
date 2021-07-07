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

---------------------------------------------tp commands------------------------------------------
function ulx.locadd( calling_ply, name)
    local res,err = ulx.GotoExt.AddLocation(name,calling_ply:GetEyeTraceNoCursor().HitPos)
    if !res then
        ulx.fancyLogAdmin(err, "#A")
        return
    end
    ulx.fancyLogAdmin( calling_ply, "#A has added location #s", name)

end

local locadd = ulx.command( "Location Management", "ulx locadd", ulx.locadd, "!locadd")
locadd:addParam{ type=ULib.cmds.StringArg, hint="Location name"}
locadd:defaultAccess( ULib.ACCESS_SUPERADMIN)
locadd:help("Adds a location that everyone on the server can teleport too.")

function ulx.locdel ( calling_ply, name)
    local res,err = ulx.GotoExt.RemoveLocation(name)
    if !res then
        return
    end
    ulx.fancyLogAdmin( calling_ply, "#A has removed location #s", name)

end
local locdel = ulx.command( "Location Management", "ulx locdel", ulx.locdel, "!locdel")
locdel:addParam{ type=ULib.cmds.StringArg, hint="Location name"}
locdel:defaultAccess( ULib.ACCESS_SUPERADMIN)
locdel:help("Removes a location from the location list.")

function ulx.lgo ( calling_ply, name)
    local res,err = ulx.GotoExt.GetLocation(name)
    if !res then
        return
    end

    calling_ply:SetPos(res)

    ulx.fancyLogAdmin( calling_ply, "#A has teleported to #s", name)

end
local lgo = ulx.command( "Location Management", "ulx lgo", ulx.lgo, "!lgo")
lgo:addParam{ type=ULib.cmds.StringArg, hint="Location name"}
lgo:defaultAccess( ULib.ACCESS_ALL)
lgo:help("Teleports you to the specified location.")

function ulx.loclist( calling_ply)
    for k,v in SortedPairs(ulx.GotoExt.GetTable()) do
        calling_ply:ChatPrint(k)
    end
end
local loclist = ulx.command( "Location Management", "ulx loclist", ulx.loclist, "!loclist")
loclist:defaultAccess( ULib.ACCESS_ALL)
loclist:help("Lists all of the possible locations you can teleport to.")