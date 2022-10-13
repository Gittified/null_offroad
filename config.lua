Config = {}

Config.UpdateCheck = true -- Check for update on resource start?

Config.BypassVehicles = {} -- Offroad vehicles that should bypass the script, use the model name e.g.: 'adder'
Config.GripRoads = { 1, 4, 3, 7, 181, 15, 13, 55, 68, 69, 12 }
Config.OffroadClass = { 9 }

Config.EnableSQL = false -- OxMySQL only! Ability to add/remove vehicles to the bypass list without having to restart.

-- Client side notifications!
Config.Notification = function(message)
    TriggerEvent('chat:addMessage', {
        color = { 255, 0, 0 },
        multiline = true,
        args = { 'null_offroad', message }
    })
end
