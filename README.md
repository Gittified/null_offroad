# null_offroad

This script will adjust the handling of a specific vehicle when they go off-road, making it harder to accelerate, steer and break. It is completely standalone but can be integrated into a framework easily. 

## How does it work?

This script will reduce grip, breaking and steering when driving offroad with a vehicle that should not be able to do that. By default I only configured the “Offroad” vehicle class to bypass the script, but you can add classes from the list found [here](https://docs.fivem.net/natives/?_0x29439776AAA00A62), just add the number to the array.

The script includes adding specific vehicle models to the bypass list, I made a user-friendly command to do so. All you have to do is step into the vehicle and use the **/offroad** command. The command also includes checking the current status and all vehicles you add are saved in a database table. The script creates this table for your convenience. Please note that adding vehicles in runtime only works when the SQL option is enabled. You can always configure vehicles directly in the configuration if you prefer that.

The command includes a debug option, you can turn this on (will reduce performance drastically on the person who has it enabled) to see if you are driving on a road, what material the road is and if the effect is applied. You can add the material number to the Config.GripRoads array to include them as roads. In order to use this command, the user is required to have the ``command.offroad`` [ace](https://forum.cfx.re/t/basic-aces-principals-overview-guide/90917) granted.

If you know what you are doing, feel free to adjust [these 6 lines](https://github.com/Gittified/null_offroad/blob/main/client/main.lua#L63-L68) to change the effect of the script. The script could have problems if you changed the sv_filterRequestControl server variable, but this is untested.

## Features

If you would like to see more features added, please reply on the [FiveM post](https://forum.cfx.re/t/free-null-offroad-better-offroad-driving/4927518) or [create an issue](https://github.com/Gittified/null_offroad/issues) to make a suggestion!

---

- Standalone
- Debugging Mode (Material type, effect info and road info)
- Optimized code (0.00-0.01ms)
- Synchronized between clients
- Configure what vehicle classes can go off-road
- Configure what material is considered on-road
- Uses state bags to store information, so you can safely restart the script<sup>1</sup>
- Automatically handles database tables<sup>2</sup>
- Add and remove vehicle as exception with command in-game (updated live)<sup>2</sup>

---

<sup>1 The key of the statebag used to check if the effect is applied on a vehicle entity is **noGrip**</sup>
<br/>
<sup>2 This feature requires [OxMySQL](https://github.com/overextended/oxmysql) to be installed and working</sup>

## Dependencies

- OneSync enabled

## Issues & Contributing

If you are experiencing any trouble while using the script, please reply to the FiveM post or create an issue on the GitHub page. If you think you can solve the issue yourself feel free to open a pull request. Any other contributions are also welcome.

*For questions and requests you can add me on Discord: `nullifiedd`*

## License

Please respect the license, you can read more about it [here](https://www.gnu.org/licenses/gpl-3.0.html).
