local callActive = false
local haveTarget = false
local isCall = false
local work = {}
local target = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if IsControlJustPressed(1, 246) and callActive then
			if isCall == false then
				TriggerServerEvent("call:getCall", work)
                exports.nCoreStuff:Ninja_Core__ShowNinjaNotification("Notification Alert", "Vous avez pris l'appel.", "")
				target.blip = AddBlipForCoord(target.pos.x, target.pos.y, target.pos.z)
				SetBlipRoute(target.blip, true)
				haveTarget = true
				isCall = true
				callActive = false
			else
                exports.nCoreStuff:Ninja_Core__ShowNinjaNotification("Notification Alert", "Vous avez déjà une intervention.", "")
			end
        -- Press L key to decline the call
        elseif IsControlJustPressed(1, 182) and callActive then
            exports.nCoreStuff:Ninja_Core__ShowNinjaNotification("Notification Alert", "Vous avez refuser l'appel.", "")
            callActive = false
        end
        if haveTarget then
            DrawMarker(1, target.pos.x, target.pos.y, target.pos.z-1, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 255, 255, 0, 200, 0, 0, 0, 0)
            local playerPos = GetEntityCoords(GetPlayerPed(-1), true)
            if Vdist(target.pos.x, target.pos.y, target.pos.z, playerPos.x, playerPos.y, playerPos.z) < 2.0 then
                RemoveBlip(target.blip)
                haveTarget = false
				isCall = false
            end
        end
    end
end)

RegisterNetEvent("call:cancelCall")
AddEventHandler("call:cancelCall", function()
	if haveTarget then
		RemoveBlip(target.blip)
        haveTarget = false
		isCall = false
	end
end)

RegisterNetEvent("call:callIncoming")
AddEventHandler("call:callIncoming", function(job, pos, msg)
    callActive = true
    work = job
    target.pos = pos
    PlaySound(-1, "Out_Of_Bounds_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0, 0, 1)
    exports.nCoreStuff:Ninja_Core__ShowNinjaNotification("Notification Alert", "", "~y~ Y ~w~pour prendre l'appel, ~r~L ~w~ pour ignorer l'appel")
    Citizen.Wait(300)
    PlaySound(-1, "Out_Of_Bounds_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0, 0, 1)
    Citizen.Wait(600)
    PlaySound(-1, "Out_Of_Bounds_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0, 0, 1)
    Citizen.Wait(300)
    PlaySound(-1, "Out_Of_Bounds_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0, 0, 1)
	if work == "police" then
        exports.nCoreStuff:Ninja_Core__ShowNinjaNotification("Police : ","", "~h~ ~r~Urgence Situation~w~ :~h~ "..tostring(msg))
    elseif work == "medic" then
        exports.nCoreStuff:Ninja_Core__ShowNinjaNotification("Ambulance : ", " ","~h~ ~r~Urgence Situation~w~ :~h~ "..tostring(msg))
	end
end)

RegisterNetEvent("call:taken")
AddEventHandler("call:taken", function()
    callActive = false
    exports.nCoreStuff:Ninja_Core__ShowNinjaNotification("~h~ ~r~Alert ~w~:", "", "Coordonnées gps enregistré !")
end)

RegisterNetEvent("target:call:taken")
AddEventHandler("target:call:taken", function(taken)
    if taken == 1 then
        exports.nCoreStuff:Ninja_Core__ShowNinjaNotification("~h~ ~r~Alert ~w~:", "", "Une personne a pris en charge votre urgence, ne pas bouger !")
    elseif taken == 0 then
        exports.nCoreStuff:Ninja_Core__ShowNinjaNotification("~h~ ~r~Alert ~w~:", "", "Votre urgence, n'a pas pus êtres passé, réessayé.")
    elseif taken == 2 then
        exports.nCoreStuff:Ninja_Core__ShowNinjaNotification("~h~ ~r~Alert ~w~:", "", "Tous nos service, sont occupés.")
    end
end)

-- If player disconnect, remove him from the inService server table
AddEventHandler('playerDropped', function()
	TriggerServerEvent("player:serviceOff", nil)
end)



--------------||SYSTEM DE CALL||------------------

RegisterNetEvent('nAppelMobile:callPolice') -------> POLICE
AddEventHandler('nAppelMobile:callPolice', function()
    local plyPos = GetEntityCoords(GetPlayerPed(-1), true)
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 200)
    while (UpdateOnscreenKeyboard() == 0) do
      DisableAllControlActions(0);
      Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
      message =  GetOnscreenKeyboardResult()
    end
    if message ~= nil and message ~= "" then
        TriggerServerEvent("call:makeCall", "police", {x=plyPos.x,y=plyPos.y,z=plyPos.z}, message)
    end
end)

RegisterNetEvent('nAppelMobile:callMedic') -------> MEDIC
AddEventHandler('nAppelMobile:callMedic', function()
    local plyPos = GetEntityCoords(GetPlayerPed(-1), true)
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 200)
    while (UpdateOnscreenKeyboard() == 0) do
      DisableAllControlActions(0);
      Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
      message =  GetOnscreenKeyboardResult()
    end
    if message ~= nil and message ~= "" then
        TriggerServerEvent("call:makeCall", "medic", {x=plyPos.x,y=plyPos.y,z=plyPos.z}, message)
    end
end)