Config = {}

Config.GripRoads = {1, 4, 3, 7, 181, 15, 13, 55, 68, 69, 12}
Config.OffroadClass = {9}

-- Client side notifications!
Config.Notification = function(message)
    TriggerEvent('chat:addMessage', {
        color = { 255, 0, 0 },
        multiline = true,
        args = { 'null_offroad', message }
    })
end