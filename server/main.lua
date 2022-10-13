local offroadVehicles = {}

local function refreshVehicles()
    MySQL.query('SELECT model FROM vehicles_offroad', function(result)
        if result then
            offroadVehicles = {}

            for i = 1, #result do
                table.insert(offroadVehicles, result[i].model)
            end

            TriggerClientEvent(clientEvent('receiveUpdate'), -1, offroadVehicles)
        end
    end)
end

RegisterNetEvent(serverEvent('requestUpdate'), function()
    TriggerClientEvent(clientEvent('receiveUpdate'), source, offroadVehicles)
end)

AddEventHandler('onResourceStart', function(resName)
    if resourceName == resName then
        MySQL.query.await("CREATE TABLE IF NOT EXISTS `vehicles_offroad` (`model` bigint(20) NOT NULL, `comment` longtext DEFAULT NULL, PRIMARY KEY (`model`))")

        CreateThread(function()
            while true do
                refreshVehicles()

                Wait(2 * 60 * 1000) -- 2 minutes
            end
        end)
    end
end)

RegisterCommand('offroad', function(source, args)
    if source > 0 then
        local playerPed = GetPlayerPed(source)

        if args[1] == "add" or args[1] == "remove" then
            -- Add or remove vehicle
            local playerVehicle = GetVehiclePedIsIn(playerPed, false)

            if playerVehicle ~= 0 then
                local vehicleModel = GetEntityModel(playerVehicle)

                if args[1] == "add" then
                    if not InTable(offroadVehicles, vehicleModel) then
                        local comment = 'No comment'

                        table.remove(args, 1)

                        if args[1] then
                            comment = table.concat(args, ' ')
                        end

                        MySQL.query.await('INSERT INTO vehicles_offroad SET model = ?, comment = ?',
                            { vehicleModel, comment })


                        TriggerClientEvent(clientEvent('showNotification'), source, "Vehicle has been added to the list.")
                    else
                        TriggerClientEvent(clientEvent('showNotification'), source, "Vehicle already in list.")
                    end
                else
                    if InTable(offroadVehicles, vehicleModel) then
                        MySQL.query.await('DELETE FROM vehicles_offroad WHERE model = ?', { vehicleModel })

                        TriggerClientEvent(clientEvent('showNotification'), source,
                            "Vehicle has been removed from the list.")
                    else
                        TriggerClientEvent(clientEvent('showNotification'), source, "Vehicle is not on list.")
                    end
                end

                refreshVehicles()
            else
                TriggerClientEvent(clientEvent('showNotification'), source, "Unable to detect a vehicle.")
            end
        elseif args[1] == "debug" then
            TriggerClientEvent(clientEvent('toggleDebug'), source)
        elseif not args[1] then
            -- Check current vehicle
            local playerVehicle = GetVehiclePedIsIn(playerPed, false)

            if playerVehicle ~= 0 then
                local vehicleModel = GetEntityModel(playerVehicle)

                if InTable(offroadVehicles, vehicleModel) then
                    local comment = MySQL.scalar.await('SELECT comment FROM vehicles_offroad WHERE model = ?',
                        { vehicleModel })

                    TriggerClientEvent(clientEvent('showNotification'), source,
                        "Vehicle is on the list, comment: '" .. comment .. "'")
                else
                    TriggerClientEvent(clientEvent('showNotification'), source,
                        "Vehicle is not added to the list, perhaps the class?")
                end
            else
                TriggerClientEvent(clientEvent('showNotification'), source, "Unable to detect a vehicle.")
            end
        else
            -- Invalid arguments
            TriggerClientEvent(clientEvent('showNotification'), source,
                "Unexpected parameter found at the first argument.")
        end
    else
        print('This command can only be used as a player!')
    end
end, true)
