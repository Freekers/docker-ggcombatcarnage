#!/bin/bash -e

# Ensure the script is not run as root, or rerun as user if needed
if [ "$UID" -eq 0 ]; then
    mkdir -p ~user/Steam
    chown user: ~user/Steam
    exec runuser -u user -- "$0" "$@"
fi

# Set game directory and Steam command variables
GAMEDIR="$HOME/Steam/steamapps/common/Gas Guzzlers Combat Carnage/Bin32"
STEAMCMD="./steamcmd.sh +@sSteamCmdForcePlatformType windows +login #{STEAM_USERNAME}# #{STEAM_PASSWORD}# +app_update 596620 +quit"

# Navigate to home directory and run SteamCMD to update the game
cd "$HOME"
eval "$STEAMCMD"

# Clean up any existing X server lock files and start Xvfb
rm -f /tmp/.X1-lock
Xvfb :1 -screen 0 800x600x24 &

# Set Wine environment variables
export WINEDLLOVERRIDES="mscoree,mshtml="
export DISPLAY=:1

# Navigate to game directory
cd "$GAMEDIR"

# If "bash" is passed as the first argument, execute bash, otherwise start the game server
if [ "$1" = "bash" ]; then
    exec "$@"
else
    exec wine ./GGDedicatedServer.exe
fi