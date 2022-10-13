local playerPed, playerVehicle, playerDriver, vehicleClass, vehicleModel, surfaceMaterial = nil, nil, nil, nil, nil, nil
local offroadVehicles = {}

AddEventHandler('onResourceStart', function(resName)
	if resourceName == resName then
		TriggerServerEvent(serverEvent('requestUpdate'))
	end
end)

RegisterNetEvent(clientEvent('receiveUpdate'), function(vehicleList)
	offroadVehicles = vehicleList
end)

RegisterNetEvent(clientEvent('toggleDebug'), function()
	LocalPlayer.state:set('debuggingOffroad', not LocalPlayer.state['debuggingOffroad'])
end)

RegisterNetEvent(clientEvent('showNotification'), function(message)
	Config.Notification(message)
end)

CreateThread(function()
	while true do
		Wait(200)

		-- Is player in any vehicle?
		if IsPedInAnyVehicle(playerPed, false) and playerDriver then
			if InTable(Config.GripRoads, surfaceMaterial) then
				-- Check if the slippery should go away
				if Entity(playerVehicle).state['noGrip'] and DoesEntityExist(playerVehicle) then
					Entity(playerVehicle).state:set('noGrip', false)

					NetworkRequestControlOfEntity(playerVehicle)

					SetVehicleHandlingFloat(playerVehicle, 'CHandlingData', 'fTractionCurveMax',
						Entity(playerVehicle).state['defaultCurveMax'])
					SetVehicleHandlingFloat(playerVehicle, 'CHandlingData', 'fTractionCurveMin',
						Entity(playerVehicle).state['defaultCurveMin'])
					SetVehicleHandlingFloat(playerVehicle, 'CHandlingData', 'fLowSpeedTractionLossMult',
						Entity(playerVehicle).state['defaultTractionLoss'])

					ModifyVehicleTopSpeed(playerVehicle, 1.0)

					Wait(100)
				else
					Wait(500)
				end
			else
				if not (InTable(Config.OffroadClass, vehicleClass) or InTable(offroadVehicles, vehicleModel)) and
					not Entity(playerVehicle).state['noGrip'] and DoesEntityExist(playerVehicle) then
					-- Make grip go away!

					NetworkRequestControlOfEntity(playerVehicle)

					local defaultCurveMax = GetVehicleHandlingFloat(playerVehicle, 'CHandlingData', 'fTractionCurveMax')
					local defaultCurveMin = GetVehicleHandlingFloat(playerVehicle, 'CHandlingData', 'fTractionCurveMin')
					local defaultTractionLoss = GetVehicleHandlingFloat(playerVehicle, 'CHandlingData', 'fLowSpeedTractionLossMult')

					Entity(playerVehicle).state:set('defaultCurveMax', defaultCurveMax)
					Entity(playerVehicle).state:set('defaultCurveMin', defaultCurveMin)
					Entity(playerVehicle).state:set('defaultTractionLoss', defaultTractionLoss)

					SetVehicleHandlingFloat(playerVehicle, 'CHandlingData', 'fTractionCurveMax', defaultCurveMax - 1.2)
					SetVehicleHandlingFloat(playerVehicle, 'CHandlingData', 'fTractionCurveMin', defaultCurveMin - 1.1)
					SetVehicleHandlingFloat(playerVehicle, 'CHandlingData', 'fLowSpeedTractionLossMult', defaultTractionLoss + 1.0)

					ModifyVehicleTopSpeed(playerVehicle, 1.0)

					Entity(playerVehicle).state:set('noGrip', true)

					Wait(100)
				else
					-- Do not apply effect, let thread sleep
					Wait(500)
				end
			end
		else
			-- Let thread sleep.
			Wait(500)
		end
	end
end)

CreateThread(function()
	while true do
		Wait(1500)

		playerPed = PlayerPedId()
		playerVehicle = GetVehiclePedIsIn(playerPed, false)
		playerDriver = (playerVehicle and playerVehicle ~= 0) and GetPedInVehicleSeat(playerVehicle, -1) == playerPed or nil
		vehicleModel = (playerVehicle and playerVehicle ~= 0) and GetEntityModel(playerVehicle) or nil
		vehicleClass = (playerVehicle and playerVehicle ~= 0) and GetVehicleClass(playerVehicle) or nil
		surfaceMaterial = (playerVehicle and playerVehicle ~= 0) and GetVehicleWheelSurfaceMaterial(playerVehicle, 1) or nil
	end
end)

CreateThread(function()
	while true do
		Wait(0)

		if LocalPlayer.state['debuggingOffroad'] then
			surfaceMaterial = (playerVehicle and playerVehicle ~= 0) and GetVehicleWheelSurfaceMaterial(playerVehicle, 1) or nil

			if playerVehicle and surfaceMaterial then
				SetTextScale(0.7, 0.7)
				SetTextFont(4)
				SetTextProportional(1)
				SetTextEntry("STRING")
				SetTextCentre(1)
				SetTextColour(255, 255, 255, 215)
				AddTextComponentString('Currently ' ..
					(InTable(Config.GripRoads, surfaceMaterial) and 'ON' or 'OFF') .. ' road, type: ' .. surfaceMaterial)
				DrawText(0.5, 0.85)
			end
		else
			Wait(5000)
		end
	end
end)

TriggerEvent('chat:addSuggestion', '/offroad',
	'Check if the current vehicle is added to the offroad list, or add/remove it from the list.', {
	{ name = "action", help = "add|remove|debug: do you want to add or remove the current vehicle? Debug will toggle debugging mode. (optional)" },
	{ name = "comment", help = "Do you want to add a comment in the database? (optional, action 'add' required)" }
})