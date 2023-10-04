Config = {}

-------------------------------------------------------------------------------------------
--                             ____          ________                     __             --
--                ____  __  __/ / /   ____  / __/ __/________  ____ _____/ /             --
--               / __ \/ / / / / /   / __ \/ /_/ /_/ ___/ __ \/ __ `/ __  /              --
--              / / / / /_/ / / /   / /_/ / __/ __/ /  / /_/ / /_/ / /_/ /               --
--             /_/ /_/\__,_/_/_/____\____/_/ /_/ /_/   \____/\__,_/\__,_/                --
--               v1.3.0       /_____/           Made by Nullified                        --
-------------------------------------------------------------------------------------------

--[[ General Information & Required variables
Welcome to the configuration section of null_offroad, the variables below should not be edited unless
you know what you are doing. If you edit them and something breaks it is your own fault. The configuration
options are explained well and you should be able to easily configure the script. Please send me a message
if anything goes wrong or if you have questions about the configuration of the script.
--]]

Config.UpdateCheck = true -- Checks for updates on resource startup

--[[ Database Integration
This script has features that require a SQL database to be connected to the server using oxmysql. If that is
not installed or if you do not wish to use a database those features will be disabled automatically. If you have
any issues setting up the database, please contact me.

!! IMPORTANT: TO ENABLE SQL INTEGRATION, MODIFY THE FXMANIFEST AND UNCOMMENT THE OXMYSQL SCRIPT IMPORT !!
--]]

Config.EnableSQL = false -- Enable SQL integration

--[[ Framework Integration
This script is standalone out of the box, but you can modify these variables to integrate it with your
framework. Do not mess with this if you do not know what you are doing.
--]]

Config.Notification = function(message)
    TriggerEvent('chat:addMessage', {
        color = { 255, 0, 0 },
        multiline = true,
        args = { 'null_offroad', message }
    })
end

--[[ Script Specific
In this section you configure variables that will change the way that the script works, some of these might
seem confusing. If that is the case do not hesitate to contact me so I can help you properly configure the script
to your wishes.
--]]

-- Example: Config.BypassVehicles = { 'adder', 'tezeract' }: will bypass the class check.
Config.BypassVehicles = {}

-- The list of possible vehicle classes can be found here: https://docs.fivem.net/natives/?_0x29439776AAA00A62
Config.BypassVehicleClasses = { 9 }

-- These wheel types are completely immune to the effects of the script.
-- The list of possible wheel types can be found here: https://docs.fivem.net/natives/?_0xB3ED1BFB4BE636DC
Config.BypassWheels = { 4 }

-- Material types that should not cause loss of grip. You can find these numbers using the debug command.
Config.Roads = { 0, 1, 4, 3, 7, 181, 15, 13, 55, 68, 69, 12, 31, 36, 35, 173, 64, 70, 86 }

-- This will multiply the intensity of the effect that is applied when a vehicle goes off-road. The default is 1 for none.
-- The effect of this variable can be pretty big, and there are also max values from where it will completely break.
--[[ Since v1.3.0, this also supports multipliers per material type, this will require a different configuration object:
Config.IntensityMultiplier = {
    global = 1.0
    [2] = 2.0
}]]
-- This is an example, test and adjust appropriately
Config.IntensityMultiplier = 1.0

--[[ Language Settings
Change the values of the items below to modify the text and messages that the script is using.
--]]

Config.Language = {
    ['command_usage'] = "Check if the current vehicle is added to the offroad list, or add/remove it from the list.",
    ['command_param_action_nosql'] = "debug: toggle debugging mode. (optional)",
    ['command_param_action_sql'] = "add|remove|debug: do you want to add or remove the current vehicle? Debug will toggle debugging mode. (optional)",
    ['command_param_comment'] = "Do you want to add a comment in the database? (optional, action 'add' required)",

    ['command_default_comment'] = "No comment",
    ['command_vehicle_removed'] = "Vehicle has been removed from the list.",
    ['command_vehicle_added'] = "Vehicle has been added to the list.",
    ['command_vehicle_already_added'] = "Vehicle already on the list.",
    ['command_vehicle_not_on_list'] = "Vehicle is not on the list.",
    ['command_vehicle_in_config'] = "Vehicle has to be removed from the configuration.",
    ['command_vehicle_not_found'] = "Unable to detect a vehicle.",
    ['command_unexpected_param'] = "Unexpected parameter found at the first argument.",
    ['command_vehicle_on_list'] = "Vehicle is on the list",

}
