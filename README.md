# Stationeers Dedicated Server Guide

All instructions will work for both Windows and Linux servers. However the example I will give will be with the Linux syntax. 

In most cases you can simply substitute `./rocketstation_DedicatedServer.x86_64` for `.\rocketstation_DedicatedServer.exe` the rest of it is all the same.

## Working Directory

In all cases we want the working directory to be where the install is. For my examples this will be in

```bash
~/.steam/debian-installation/steamapps/common/Stationeers Dedicated Server
```

## Unity Commands

You can also use Unity's commands line arguments list [here](https://docs.unity3d.com/Manual/CommandLineArguments.html)

### Log File

Most notable is `-logFile`

Specify where Unity writes the Editor or Windows/Linux/OSX standalone log file. To output to the console, specify - for the path name. On Windows, use `-logfile - <pathname>` to direct the output to `stdout`, which by default is not the console.

Using this also means you can not input into the console. So saving can only be done via autosave. This will be improved in future when we add something like RCON.


## Commands

All commands prefixed with a `-` are a launch command, most of which can also be used during runtime as well.
Runtime commands are the same name but without the `-`.

**Example:** `-load "My Saved Game"` becomes `load "My Saved Game"`

## World names
- moon
- mars
- europa
- europa2
- mimas
- vulcan
- vulcan2
- space
- loulan
- venus

# Starting a new game

`-new` command will start a new game with the given world name as an argument.

**Example:**
```bash
$ ./rocketstation_DedicatedServer.x86_64 -new moon
```

Using this wont be saving the game automatically though as a save directory is not created yet. You need to make a `save` command and then autosave will continue to work.

Because of this its generally not advised to use this command out side of testing your server.

# Loading a saved game

`-load` command will check the `saves` directory which is in the root directory with the executable.
It uses the directory name as the save name. Then checks if there is a `world.xml` within it. 
An error will be logged if neither the directory or the `world.xml` exists and the game will not load.

**Example:**
```bash
$ ./rocketstation_DedicatedServer.x86_64 -load "My saved game"
```

Additionally an extra argument can be added to `-load` which will create a new game if the directory doesn't exist from the first argument.
This can be useful for starting up a new server without worrying about if the save already exits. Just cuts out an extra step.

**Example:**
```bash
$ ./rocketstation_DedicatedServer.x86_64 -load "My saved game" moon
```

## Load Latest Game

`-loadlatest` command will scan the directory (save name based on first arg) and use the latest modified `world.xml` save from the root saved directory and the child Backup directory.

`-loadlatest` works identical to `-load` in the way it handles fallbacks.

`-loadlatest` is a replacement for `-load` command and must not be used at the same time otherwise it wont work.

If no `world.xml` is found within directory it will fallback to using the first argument, a named save. If that also fails it will use the second argument world name.

**Example:**

```bash
$ ./rocketstation_DedicatedServer.x86_64 -loadlatest "My saved game" moon
```

# Settings

`-settings` You can access an settings property within the `setting.xml` which is located at the root directory with executable.

This is can be useful for setting server names, ports, passwords, visibility etc.

Properties of note are:
- **StartLocalHost**: Starts the server on the machine allowing any client connection to take place. Default `false`
- **ServerVisible**: Starts pining our Master server which will allow the server to show on the server list on the client. Default `true`
- **LocalIpAddress**: The IP the server will bind to. Default `0.0.0.0`
- **GamePort**: The port the server will be listening on. Default `27016`
- **ServerName**: The name of the server to be displayed on the server list. Default `Stationeers`
- **ServerPassword**: An optional password to lock the server. Default `null`
- **AutoSave**: turns on/off autosaving in game. Default `true`
- **SaveInterval**: If AutoSave is on, the amount of seconds the game will save. Default `300`
- **ServerMaxPlayers**: The maximin amount of players allowed on the server. Range 1 - 30. Default `10`
- **UPNPEnabled**: Turn on/off UPnP connection feature. Default `true`
- **SavePath**: An optional custom location for the game saves. Default `null`

The settings arguments are separated by a space and are grouped in a key value pair.

**Example:**
```bash
$ ./rocketstation_DedicatedServer.x86_64 -settings ServerName "My Cool Game" StartLocalHost true ServerVisible true GamePort 27016 AutoSave true SaveInterval 300 ServerPassword abc123 ServerMaxPlayers 13 UPNPEnabled true
```

## Settings Path

`-settingspath` command can be used to create a custom location for the games settings. 
This must be used before the `-settings` command and must include `<filename>.xml` otherwise it wont work. 

**Example:**
```bash
$ ./rocketstation_DedicatedServer.x86_64 -settingspath "~/New Folder/CustomSettings.xml" -settings ServerName "My Cool Game"
```


# Saving a game

`save` command can only be used at run time and currently only used on server. 
Save can be made to override current save or create a new one. Just like on the client.

**Example:**
```bash
save "My saved game"
```

# In Game Help
`help` command during runtime will display all the help messages per command. It's a fairly large list so it might be more useful to only print the command help you need via `help <command>`, a list of commands can be printed using `help list` or `help l`.

Example:
```bash
help version
```

# Kicking and Banning Players

`kick <clientId>` can be used remove any player from your server instantly. Note: the player must exist in the world.

`ban <clientId>` can be used at anytime to ban a player. You can still use this command even if player isn't actively in the world. It will add the players clientId to a blacklist which is located at `SavePath` from your settings. 

You can lift the ban by removing the ClientID from the file and using `ban refresh` which will refresh servers blacklist without requiring a reboot.

# Client Authroised Server Commands

You can now run server command from any connected client.

There are two things you must have in order to run server commands on the client. 
1. A `ServerAuthSecret` set on server's `setting.xml` 

e.g:
```xml
<ServerAuthSecret>stationeers</ServerAuthSecret>
```

2. That exact same setting on the client

From there you can use the `serverrun` command on the client. It will send the secret every message. All messages will be rejected if the client and server secrets don't match or a server hasn't set a secret.

Example:
```bash
serverrun save "my world"
```

# Examples

All example scripts are within the [examples folder](./examples/) of this repository.


# Known Issues

- On Linux servers, which have multiple IPs assigned, you may run into issues when connecting. The server listed in the ingame browser, however when you attempt to connect you'll experience a timeout. This generally can be resolved by adding `LocalIpAddress` with it set to the desired IP to your configuration.

- On Linux the console clearing is messing with buffer of the terminal and resulting in really strange behaviour. Input can still be made i.e manually saving via `save` command, however nothing will print to console with any useful feedback.

- Help message formatting is terribly hard to read.


# Stationeers Commands - 0.2.3649.17688
| Command | Launch Command? | Arguments | Help |
| :------ | :-------------: | :-------- | :--- |
| `help` | False | commands, list (l), &lt;key&gt;, tofile: prints the help output to file | Displays helpful stuff
| `clear` | False |  | Clears all console text
| `quit` | False |  | immediately quits the game without any prompts
| `exit` | False |  | Leaves a game session and goes back to 'StartMenu'
| `leave` | False |  | Leaves a game session and goes back to 'StartMenu'
| `newgame` | True | worldName | Starts a new game at specific world automatically from launch.Must provide world name as argument
| `new` | True | worldName | Starts a new game at specific world automatically from launch.Must provide world name as argument
| `loadgame` | True | list, &lt;filename&gt;, &lt;filename&gt; (optional)&lt;worldname&gt; | Loads a saved world file. This can also be used to start a new game via launch command. e.g -load "my game save" moon
| `load` | True | list, &lt;filename&gt;, &lt;filename&gt; (optional)&lt;worldname&gt; | Loads a saved world file. This can also be used to start a new game via launch command. e.g -load "my game save" moon
| `loadlatest` | True | list, &lt;filename&gt;, &lt;filename&gt; (optional)&lt;worldname&gt; | Loads the latest saved file, including auto saves
| `joingame` | True | [address]:[port] | Joins a client to the server
| `join` | True | [address]:[port] | Joins a client to the server
| `steam` | False |  | Commands to test Facepunch API. Just checks if steam is initialised and if DLC is purchased
| `listnetworkdevices` | False | id | Lists all devices on a network. Includes: PipeNetwork, CableNetwork, ChuteNetwork
| `testbytearray` | False |  | Tests every item in world to check its network read/write functions are parallel. Only enabled in Editor. Supply a reference Id to check ONLY that item
| `rocketbinary` | False | togglelogbps | Starts logging the size of each section of a delta update.
| `imgui` | False |  | Toggles ImguiInWorldTestCube on/off
| `atmos` | False | pipe, world, room, global, thing, cleanup, count | Enables atmosphere debugging
| `thing` | False | No args returns total thing count, find, delete, spawn, info | Thing related commands
| `keybindings` | False | reset (Resets the keybindings stack. Can help solve input issues) | Displays all the keybindings bound to LocalHuman
| `reset` | False |  | Restarts the application
| `version` | False |  | Returns the game version
| `logtoclipboard` | False |  | Copies the content of the console buffer to the system clipboard buffer
| `kick` | False | &lt;clientId&gt; | Kick clients from server commands
| `ban` | False | &lt;clientId&gt;, refresh | Bans a client from the server (server only command)
| `upnp` | False |  | returns universal plug and play (upnp) state
| `network` | False |  | returns the current network status
| `pause` | False | true, false | will pause/unpause the game (including for clients)
| `say` | False |  | sends a message to all connected players
| `save` | False | &lt;filename&gt;, delete (d | rm) &lt;filename&gt;, list (l) | Saves the current game to specified path
| `log` | False | &lt;logname&gt; (optional), clear | Dumps all the logs to a file
| `discord` | False |  | Interaction with the Discord SDK
| `settings` | True | list, print, &lt;PropertyName&gt; &lt;Value&gt; | Change the settings.xml. e.g settings servermaxplayers 5
| `netconfig` | True | list, print, &lt;PropertyName&gt; &lt;Value&gt; | Change the NetConfig.xml. e.g netconfig ip 127.0.0.1
| `settingspath` | True | &lt;full-directory-path&gt; | Sets the default settings path to a new location. Launch command only. If none found default is used.
| `regeneraterooms` | False |  | Regenerates all rooms for the world
| `stormbegin` | False |  | Starts weather event
| `stormend` | False |  | Stops weather event
| `debugthreads` | False | GameTick | Show the times that the worker threads take to run
| `status` | False |  | Displays a bunch of info to give insight into state of server.
| `masterserver` | False | refresh | Commands to help with interacting with the Master Server
| `deletelooseitems` | False |  | Removes all items in world that isn't in a slot
| `emote` | False | emoteName | Makes the player character do the requested emote
| `serverrun` | False | Command | Sends a message to the server to perform server side commands
| `suntime` | False | time | Set the time of day between 0 and 1 (e.g. 0 is sunrise, 0.5 is sunset)
| `windowheight` | False | &lt;height&gt;, reset (r) | Sets the window height to a fixed number of lines or resets it to default behaviour.
| `cleanupplayers` | False | dead, disconnected, all | Cleans up player bodies
| `networkdebug` | False |  | Displays network debug window.
| `difficulty` | True | &lt;difficulty&gt; | Sets game difficulty to one of the predefined settings
| `addgas` | False | Oxygen, Nitrogen, CarbonDioxide, Volatiles, Pollutant, Water, NitrousOxide | Adds GasType to target thing of supplied ID of amount at temperature.
| `legacycpu` | False | enable, disable | Enables Legacy Cpu mode. Recommended for users with cpus below the recommended spec
| `test` | False |  | Testing all the colours of the rainbow
| `autosavecancel` | False |  | Starts an auto save process then instantly stops game from running

