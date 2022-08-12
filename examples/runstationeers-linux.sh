#!/bin/bash

# create place to store save/ scripts/ setting.xml etc...
DATA_DIR="${PWD}/data"

# set exe
EXECUTABLE="~/.steam/debian-installation/steamapps/common/Stationeers Dedicated Server/rocketstation_DedicatedServer.x86_64"

# Define settings
SERVER_NAME="Test Dedi Server"
SAVE_NAME="Dedi Test"
WORLD_TYPE="mars"
SERVER_PASSWORD="123"
SERVER_AUTH_SECRET="stationeers"
GAME_PORT=27016
START_LOCAL_HOST=true
SERVER_VISIBLE=true
UPNP_ENABLED=false
SERVER_MAX_PLAYERS=13
AUTO_SAVE=true
SAVE_INTERVAL=60
SAVE_PATH="$DATA_DIR/saves"
LOG_FILE="$DATA_DIR/log.txt"
SETTINGS_PATH="$DATA_DIR/settings.xml"

# Run the server
"$EXECUTABLE" \
-loadlatest "$SAVE_NAME" $WORLD_TYPE \
-logFile "$LOG_FILE" \
-settingspath "$SETTINGS_PATH" \
-settings StartLocalHost $START_LOCAL_HOST ServerVisible $SERVER_VISIBLE \
    GamePort $GAME_PORT UPNPEnabled $UPNP_ENABLED ServerName "$SERVER_NAME" \
    ServerPassword "$SERVER_PASSWORD" ServerMaxPlayers $SERVER_MAX_PLAYERS \
    AutoSave $AUTO_SAVE SaveInterval $SAVE_INTERVAL \
    SavePath "$SAVE_PATH" \
    ServerAuthSecret "$SERVER_AUTH_SECRET"
