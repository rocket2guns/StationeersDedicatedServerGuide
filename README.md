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
Runtime commands are the same name but with the `-`.

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

## Latest game (Not support yet)

Currently there isn't a way to load to load a game or its more current auto save. A `-loadlatest` command is underway and will come out in a future patch.

This must be used before the `-load` command otherwise it wont work. 

This command will scan the saves directory and use the latest modified `world.xml` save.
If none is found it will be ignored.
If one is found the `-load` command will be ignored.

**Example:**

This will scan and use the latest modified `world.xml` if one is found. Otherwise it will fall back to `-load "My saved game"`, if that directory doesn't exist it will start a new game with world `moon` and save the game with given name.

```bash
$ ./rocketstation_DedicatedServer.x86_64 -loadlatest -load "My saved game" moon
```

# Settings

`-settings` You can access an settings property within the `setting.xml` which is located at the root directory with executable.

This is can be useful for setting server names, ports, passwords, visibility etc.

Properties of note are:
- **StartLocalHost**: Starts the server on the machine allowing any client connection to take place. Default `false`
- **ServerVisible**: Starts pining our Master server which will allow the server to show on the server list on the client. Default `true`
- **GamePort**: The port the server will be listening on. Default `27016`
- **ServerName**: The name of the server to be displayed on the server list. Default `Stationeers`
- **Password**: An optional password to lock the server. Default `null`
- **AutoSave**: turns on/off autosaving in game. Default `true`
- **SaveInterval**: If AutoSave is on, the amount of seconds the game will save. Default `300`
- **ServerMaxPlayers**: The maximin amount of players allowed on the server. Range 1 - 30. Default `10`
- **UPNPEnabled**: Turn on/off UPnP connection feature. Default `true`
- **SavePath**: An optional custom location for the game saves. Default `null`

The settings arguments are separated by a space and are grouped in a key value pair.

**Example:**
```bash
$ ./rocketstation_DedicatedServer.x86_64 -settings ServerName "My Cool Game" StartLocalHost true ServerVisible true GamePort 27016 AutoSave true SaveInterval 300 Password abc123 ServerMaxPlayers 13 UPNPEnabled true
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

# Known Issues

- On Linux the console clearing is messing with buffer of the terminal and resulting in really strange behaviour. Input can still be made i.e manually saving via `save` command, however nothing will print to console with any useful feedback.

- No server admins yet. I.e selected clients being able to do server commands without needing to ssh into their server or whatever.
