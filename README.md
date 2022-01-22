# docker-ggcombatcarnage
**Gas Guzzlers: Combat Carnage Dedicated Server in Docker using WINE**

The image itself contains WINE and steamcmd, along with an entrypoint.sh script that bootstraps the Gas Guzzlers: Combat Carnage dedicated server install via steamcmd.

When running the image, mount the volume /home/user/Steam, to persist the Gas Guzzlers: Combat Carnage install and avoid downloading it on each container start.

Sample invocation:
```
mkdir -p gamedir
docker run -di -p 3555:3555/udp -p 3555:3555/tcp --restart unless-stopped -v $PWD/gamedir:/home/user/Steam freekers/docker-ggcombatcarnage:latest
```

After starting the server, you can edit the GGDedicatedServer.xml file at 'gamedir/steamapps/common/Gas Guzzlers Combat Carnage/Bin32/GGDedicatedServer.xml'.
You'll need to restart the docker container after editing.

To append arguments to the steamcmd command, use `-e "STEAMCMD=..."`. Example: `-e "STEAMCMD=+runscript /home/user/Steam/addmods.txt"`.

This is a PRIVATE repository because to download the dedicated server files, you need to own the game. Hence SteamCMD logs in with credentials, which can be retrieved in plain text in the logging.

Credits: https://github.com/BitR/empyrion-docker
