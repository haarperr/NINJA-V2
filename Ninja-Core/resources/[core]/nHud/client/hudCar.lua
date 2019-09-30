local UseBigMap = false
local BigMapKeyOnFoot = 44
local BigMapKeyInVehicle = 131
local BigMapInVehicles = true
local OnlyDriver = true
local Hide = false

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)
		mePlayerPedID = PlayerPedId()
		mePlayerId = PlayerId()
		BigMapHandle(IsPedInAnyVehicle(mePlayerPedID, true), OnlyDriver and (GetPedInVehicleSeat(GetVehiclePedIsIn(mePlayerPedID, false), -1) == mePlayerPedID))
		if IsPedInAnyVehicle(mePlayerPedID, true) then
			if (OnlyDriver and (GetPedInVehicleSeat(GetVehiclePedIsIn(mePlayerPedID, false), -1) == mePlayerPedID)) or not OnlyDriver then
				DisplayRadar(true)
			end
		else
			if not Hide then
				local PlayerHealth = GetEntityHealth(mePlayerPedID)
				local PlayerArmour = GetPedArmour(mePlayerPedID)
				local PlayerStamina = GetPlayerSprintStaminaRemaining(mePlayerId)

				local MM = GetMinimapAnchor()
				local BarY = MM.bottom_y - ((MM.yunit * 18.0) * 0.5)
				local BackgroundBarH = MM.yunit * 18.0
				local BarH = BackgroundBarH / 2
				local BarSpacer = MM.xunit * 3.0
				local BackgroundBar = {['R'] = 0, ['G'] = 0, ['B'] = 0, ['A'] = 125, ['L'] = 0}
				
				local HealthBaseBar = {['R'] = 57, ['G'] = 102, ['B'] = 57, ['A'] = 175, ['L'] = 1}
				local HealthBar = {['R'] = 114, ['G'] = 204, ['B'] = 114, ['A'] = 175, ['L'] = 2}
				
				local HealthHitBaseBar = {['R'] = 112, ['G'] = 25, ['B'] = 25, ['A'] = 175}
				local HealthHitBar = {['R'] = 224, ['G'] = 50, ['B'] = 50, ['A'] = 175}
				
				local ArmourBaseBar = {['R'] = 47, ['G'] = 92, ['B'] = 115, ['A'] = 175, ['L'] = 1}
				local ArmourBar = {['R'] = 93, ['G'] = 182, ['B'] = 229, ['A'] = 175, ['L'] = 2}
				
				local AirBaseBar = {['R'] = 67, ['G'] = 106, ['B'] = 130, ['A'] = 175, ['L'] = 1}
				local AirBar = {['R'] = 174, ['G'] = 219, ['B'] = 242, ['A'] = 175, ['L'] = 2}
				
				local BackgroundBarW = MM.width
				local BackgroundBarX = MM.x + (MM.width / 2)
				_DrawRect(BackgroundBarX, BarY, BackgroundBarW, BackgroundBarH, BackgroundBar.R, BackgroundBar.G, BackgroundBar.B, BackgroundBar.A, BackgroundBar.L)

				local HealthBaseBarW = (MM.width / 2) - (BarSpacer / 2)
				local HealthBaseBarX = MM.x + (HealthBaseBarW / 2)
				local HealthBaseBarR, HealthBaseBarG, HealthBaseBarB, HealthBaseBarA = HealthBaseBar.R, HealthBaseBar.G, HealthBaseBar.B, HealthBaseBar.A
				local HealthBarW = (MM.width / 2) - (BarSpacer / 2)
				if PlayerHealth < 175 and PlayerHealth > 100 then
					HealthBarW = ((MM.width / 2) - (BarSpacer / 2)) / 75 * (PlayerHealth - 100)
				elseif PlayerHealth < 100 then
					HealthBarW = 0
				end
				local HealthBarX = MM.x + (HealthBarW / 2)
				local HealthBarR, HealthBarG, HealthBarB, HealthBarA = HealthBar.R, HealthBar.G, HealthBar.B, HealthBar.A
				if PlayerHealth <= 118 or (PlayerStamina >= 90.0 and (IsPedRunning(mePlayerPedID) or IsPedSprinting(mePlayerPedID))) then
					HealthBaseBarR, HealthBaseBarG, HealthBaseBarB, HealthBaseBarA = HealthHitBaseBar.R, HealthHitBaseBar.G, HealthHitBaseBar.B, HealthHitBaseBar.A
					HealthBarR, HealthBarG, HealthBarB, HealthBarA = HealthHitBar.R, HealthHitBar.G, HealthHitBar.B, HealthHitBar.A
				end
				
				_DrawRect(HealthBaseBarX, BarY, HealthBaseBarW, BarH, HealthBaseBarR, HealthBaseBarG, HealthBaseBarB, HealthBaseBarA, HealthBaseBar.L)
				_DrawRect(HealthBarX, BarY, HealthBarW, BarH, HealthBarR, HealthBarG, HealthBarB, HealthBarA, HealthBar.L)

				if not IsPedSwimmingUnderWater(mePlayerPedID) then
					local ArmourBaseBarW = (MM.width / 2) - (BarSpacer / 2)
					local ArmourBaseBarX = MM.right_x - (ArmourBaseBarW / 2)
					local ArmourBarW = ((MM.width / 2) - (BarSpacer / 2)) / 100 * PlayerArmour
					local ArmourBarX = MM.right_x - ((MM.width / 2) - (BarSpacer / 2)) + (ArmourBarW / 2)

					_DrawRect(ArmourBaseBarX, BarY, ArmourBaseBarW, BarH, ArmourBaseBar.R, ArmourBaseBar.G, ArmourBaseBar.B, ArmourBaseBar.A, ArmourBaseBar.L)
					_DrawRect(ArmourBarX, BarY, ArmourBarW, BarH, ArmourBar.R, ArmourBar.G, ArmourBar.B, ArmourBar.A, ArmourBar.L)
				else
					local ArmourBaseBarW = (((MM.width / 2) - (BarSpacer / 2)) / 2) - (BarSpacer / 2)
					local ArmourBaseBarX = MM.right_x - (((MM.width / 2) - (BarSpacer / 2)) / 2) - (ArmourBaseBarW / 2) - (BarSpacer / 2)
					local ArmourBarW = ((((MM.width / 2) - (BarSpacer / 2)) / 2) - (BarSpacer / 2)) / 100 * PlayerArmour
					local ArmourBarX = MM.right_x - ((MM.width / 2) - (BarSpacer / 2)) + (ArmourBarW / 2)

					_DrawRect(ArmourBaseBarX, BarY, ArmourBaseBarW, BarH, ArmourBaseBar.R, ArmourBaseBar.G, ArmourBaseBar.B, ArmourBaseBar.A, ArmourBaseBar.L)
					_DrawRect(ArmourBarX, BarY, ArmourBarW, BarH, ArmourBar.R, ArmourBar.G, ArmourBar.B, ArmourBar.A, ArmourBar.L)
					
					local AirBaseBarW = (((MM.width / 2) - (BarSpacer / 2)) / 2) - (BarSpacer / 2)
					local AirBaseBarX = MM.right_x - (AirBaseBarW / 2)
					local Air = GetPlayerUnderwaterTimeRemaining(mePlayerId)
					if Air < 0.0 then
						Air = 0.0
					end
					local AirBarW = ((((MM.width / 2) - (BarSpacer / 2)) / 2) - (BarSpacer / 2)) / 10.0 * Air
					local AirBarX = MM.right_x - ((((MM.width / 2) - (BarSpacer / 2)) / 2) - (BarSpacer / 2)) + (AirBarW / 2)

					_DrawRect(AirBaseBarX, BarY, AirBaseBarW, BarH, AirBaseBar.R, AirBaseBar.G, AirBaseBar.B, AirBaseBar.A, AirBaseBar.L)
					_DrawRect(AirBarX, BarY, AirBarW, BarH, AirBar.R, AirBar.G, AirBar.B, AirBar.A, AirBar.L)
				end
			end
		end
	end
end)

function BigMapHandle(InVehicle, IsDriver)
	if UseBigMap and ((IsDriver) and InVehicle) then
		DisplayRadar(true)
		SetRadarBigmapEnabled(true, false)	
		Hide = true
	else
		if not InVehicle and not IsDriver then
			DisplayRadar(false)
		end
		SetRadarBigmapEnabled(false, false)
		Hide = false
	end
end

function _DrawRect(X, Y, W, H, R, G, B, A, L)
	SetUiLayer(L)
	DrawRect(X, Y, W, H, R, G, B, A)
end