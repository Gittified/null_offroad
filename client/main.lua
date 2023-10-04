local playerPed, playerVehicle, playerDriver, vehicleClass, vehicleModel, surfaceMaterial = nil, nil, nil, nil, nil, nil
local intensityType = type(Config.IntensityMultiplier)
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

local function getIntensityMultiplier()
	if intensityType == "number" then
		return Config.IntensityMultiplier or 1.0
	end

	return Config.IntensityMultiplier[surfaceMaterial] or Config.IntensityMultiplier.global or 1.0
end

CreateThread(function()
	while true do
		Wait(200)

		-- Is player in any vehicle?
		if IsPedInAnyVehicle(playerPed, false) and playerDriver and not InTable(Config.BypassWheels, GetVehicleWheelType(playerVehicle)) then
			if InTable(Config.Roads, surfaceMaterial) then
				-- Check if the slippery should go away
				if DoesEntityExist(playerVehicle) and Entity(playerVehicle).state['noGrip'] then
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
				if not (InTable(Config.BypassVehicleClasses, vehicleClass) or InTable(offroadVehicles, vehicleModel)) and DoesEntityExist(playerVehicle) and
						not Entity(playerVehicle).state['noGrip'] then
					-- Make grip go away!

					NetworkRequestControlOfEntity(playerVehicle)

					local defaultCurveMax = GetVehicleHandlingFloat(playerVehicle, 'CHandlingData', 'fTractionCurveMax')
					local defaultCurveMin = GetVehicleHandlingFloat(playerVehicle, 'CHandlingData', 'fTractionCurveMin')
					local defaultTractionLoss = GetVehicleHandlingFloat(playerVehicle, 'CHandlingData', 'fLowSpeedTractionLossMult')

					Entity(playerVehicle).state:set('defaultCurveMax', defaultCurveMax)
					Entity(playerVehicle).state:set('defaultCurveMin', defaultCurveMin)
					Entity(playerVehicle).state:set('defaultTractionLoss', defaultTractionLoss)

					local invensityMultiplier = getIntensityMultiplier()

					SetVehicleHandlingFloat(playerVehicle, 'CHandlingData', 'fTractionCurveMax',
						defaultCurveMax - (1.2 * invensityMultiplier))
					SetVehicleHandlingFloat(playerVehicle, 'CHandlingData', 'fTractionCurveMin',
						defaultCurveMin - (1.1 * invensityMultiplier))
					SetVehicleHandlingFloat(playerVehicle, 'CHandlingData', 'fLowSpeedTractionLossMult',
						defaultTractionLoss + (1.0 * invensityMultiplier))

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
			playerVehicle = GetVehiclePedIsIn(playerPed, false)
			surfaceMaterial = (playerVehicle and playerVehicle ~= 0) and GetVehicleWheelSurfaceMaterial(playerVehicle, 1) or
					nil

			if playerVehicle and surfaceMaterial then
				SetTextScale(0.65, 0.65)
				SetTextFont(4)
				SetTextCentre(true)
				SetTextColour(255, 255, 255, 200)

				AddTextEntry('debuggingOffroad', ('Currently ' ..
					(InTable(Config.Roads, surfaceMaterial) and 'ON' or 'OFF') ..
					' road, type: ' ..
					surfaceMaterial .. ', effect: ' .. tostring(Entity(playerVehicle).state['noGrip'] and 'ON' or 'OFF') .. ', intensity (multiplier): ' .. getIntensityMultiplier()))
				BeginTextCommandDisplayText('debuggingOffroad')
				EndTextCommandDisplayText(0.5, 0.85)
			end
		else
			Wait(5000)
		end
	end
end)

TriggerEvent('chat:addSuggestion', '/offroad',
	Config.Language.command_usage, {
		{
			name = "action",
			help = Config.EnableSQL and
					Config.Language.command_param_action_sql or
					Config.Language.command_param_action_nosql
		},
		Config.EnableSQL and
		{ name = "comment", help = Config.Language.command_param_comment } or nil
	})
