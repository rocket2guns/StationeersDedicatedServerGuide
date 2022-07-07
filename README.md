# Stationeers Dedicated Server Guide

All instructions will work for both Windows and Linux servers. However the example I will give will be with the Linux syntax. 

In most cases you can simply substitute `./rocketstation_DedicatedServer.x86_64` for `.\rocketstation_DedicatedServer.exe` the rest of it is all the same.

## Working Directory

In all cases we want the working directory to be where the install is. For my examples this will be in

```bash
~/.steam/debian-installation/steamapps/common/Stationeers Dedicated Server
```

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

`-loadlatest` command will scan the saves directory and use the latest modified `world.xml` save.

`-loadlatest` works identical to `-load` in the way it handles fallbacks.

`-loadlatest` is a replacement for `-load` command and must not be used at the same time otherwise it wont work.

If no `world.xml` is found within the `saves` directory it will fallback to using the first argument, a named save. If that also fails it will use the second argument world name.

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


# Known Issues

- On Linux the console clearing is messing with buffer of the terminal and resulting in really strange behaviour. Input can still be made i.e manually saving via `save` command, however nothing will print to console with any useful feedback.

- No server admins yet. I.e selected clients being able to do server commands without needing to ssh into their server or whatever.

- Help message formatting is terribly hard to read.

# Stationeers Commands - 0.2.3401.16711
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
| `rocketbinary` | False | toggleloglength, togglelogbps | Starts logging the size of each section of a delta update.
| `imgui` | False |  | Toggles ImguiInWorldTestCube on/off
| `atmos` | False | pipe, world, room, global, thing | Enables atmosphere debugging
| `thing` | False | No args returns total thing count, find, delete, spawn | Thing related commands
| `keybindings` | False | reset (Resets the keybindings stack. Can help solve input issues) | Displays all the keybindings bound to LocalHuman
| `reset` | False |  | Restarts the application
| `version` | False |  | Returns the game version
| `logtoclipboard` | False |  | Copies the content of the console buffer to the system clipboard buffer
| `kick` | False | clientId - disconnects the client from the game | Kick clients from server commands
| `ban` | False | clientId | Bans a client from the server (server only command)
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
| `debugthreads` | False | GameTick | Show the times that the worker threads take to run
| `status` | False |  | Displays a bunch of info to give insight into state of server.
| `masterserver` | False | refresh | Commands to help with interacting with the Master Server
| `test` | False |  | Testing all the colours of the rainbow

