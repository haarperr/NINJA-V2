positions = {
    {{340.549, -595.53, 28.7915, 0}, {339.54, -584.692, 74.1657, 0},{36,237,157}, ""}, -- Medics Elevator ENTRER
    {{339.54, -584.692, 74.1657, 0}, {340.549, -595.53, 28.7915, 0},{0, 0, 0}, ""}, -- Medics Toit Sortie
}

Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(5)
        local player = GetPlayerPed(-1)
        local playerLoc = GetEntityCoords(player)

        for _,location in ipairs(positions) do
            teleport_text = location[4]
            loc1 = {
                x=location[1][1],
                y=location[1][2],
                z=location[1][3],
                heading=location[1][4]
            }
            loc2 = {
                x=location[2][1],
                y=location[2][2],
                z=location[2][3],
                heading=location[2][4]
            }
            Red = location[3][1]
            Green = location[3][2]
            Blue = location[3][3]

            DrawMarker(0, loc1.x, loc1.y, loc1.z-1, 0, 0, 0, 0, 0, 0, 1.501, 1.5001, 0.5001, 34, 181, 52, 180, 0, 0, 0, 0)
            DrawMarker(0, loc2.x, loc2.y, loc2.z-1, 0, 0, 0, 0, 0, 0, 1.501, 1.5001, 0.5001, 235, 171, 52, 180, 0, 0, 0, 0)

            if CheckPos(playerLoc.x, playerLoc.y, playerLoc.z, loc1.x, loc1.y, loc1.z, 1) then
                if GetLastInputMethod(0) then
                    exports.nCoreStuff:Ninja_Core__DisplayHelpAlert("~INPUT_TALK~ ~g~intéragir")
                else
                    exports.nCoreStuff:Ninja_Core__DisplayHelpAlert("~INPUT_CELLPHONE_RIGHT~ ~g~intéragir")
                end
                if (IsControlJustReleased(0, 54) or IsControlJustReleased(0, 175)) then
                    if IsPedInAnyVehicle(player, true) then
                        SetEntityCoords(GetVehiclePedIsUsing(player), loc2.x, loc2.y, loc2.z)
                        SetEntityHeading(GetVehiclePedIsUsing(player), loc2.heading)
                    else
                        SetEntityCoords(player, loc2.x, loc2.y, loc2.z)
                        SetEntityHeading(player, loc2.heading)
                    end
                end
            elseif CheckPos(playerLoc.x, playerLoc.y, playerLoc.z, loc2.x, loc2.y, loc2.z, 1) then
                if GetLastInputMethod(0) then
                    exports.nCoreStuff:Ninja_Core__DisplayHelpAlert("~INPUT_TALK~ ~y~intéragir")
                else
                    exports.nCoreStuff:Ninja_Core__DisplayHelpAlert("~INPUT_CELLPHONE_RIGHT~ ~y~intéragir")
                end
                if (IsControlJustReleased(0, 54) or IsControlJustReleased(0, 175)) then
                    if IsPedInAnyVehicle(player, true) then
                        SetEntityCoords(GetVehiclePedIsUsing(player), loc1.x, loc1.y, loc1.z)
                        SetEntityHeading(GetVehiclePedIsUsing(player), loc1.heading)
                    else
                        SetEntityCoords(player, loc1.x, loc1.y, loc1.z)
                        SetEntityHeading(player, loc1.heading)
                    end
                end
            end            
        end
    end
end)

function CheckPos(x, y, z, cx, cy, cz, radius)
    local t1 = x - cx
    local t12 = t1^2

    local t2 = y-cy
    local t21 = t2^2

    local t3 = z - cz
    local t31 = t3^2

    return (t12 + t21 + t31) <= radius^2
end