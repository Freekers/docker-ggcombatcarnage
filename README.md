# docker-ggcombatcarnage
**Gas Guzzlers: Combat Carnage Dedicated Server in Docker using WINE**

The image itself contains WINE and steamcmd, along with an entrypoint.sh script that bootstraps the Gas Guzzlers: Combat Carnage dedicated server install via Steamcmd.

## Building the image

Sadly I cannot provide you with a prebuilt image, because in order to download the dedicated server executables, you'll need to own the game on Steam. Hence you'll have to build the image yourself, else I would be sharing copyrighted content. 

In order to do so, clone this repository or copy the contents of `Dockerfile` and `entrypoint.sh`, because those are the only two files you need to build the image.

Next, edit `entrypoint.sh` and replace `${{ secrets.STEAM_USERNAME }}` with your Steam username and `${{ secrets.STEAM_PASSWORD }}` with your Steam password. 
Note: Since Docker image building is non-interactive, Steam Guard must be disabled, as you cannot enter your Steam Guard code during the build. Hence it is recommended that you create a new Steam account just for your dedicated server, which indeed requires you to re-purchase the game.

Afterwards, type the following command to build the image: `docker build -t gasguzzlers:1`. This can take a while.
Once done, start the container using the instructions below.

## Running the container
When running the image, it is recommended to volume mount `/home/user/Steam` to persist the Gas Guzzlers: Combat Carnage install and avoid downloading it on each container start.

Example Docker run command:
```
mkdir -p gamedir
docker run -di -p 3555:3555/udp -p 3555:3555/tcp --restart unless-stopped -v $PWD/gamedir:/home/user/Steam gasguzzlers:1
```
An example docker-compose.yml can be found in this repository as well

## Customizing your server
After starting the server, you can edit the GGDedicatedServer.xml file at 'gamedir/steamapps/common/Gas Guzzlers Combat Carnage/Bin32/GGDedicatedServer.xml'. You'll need to restart the docker container after editing.

To append arguments to the steamcmd command, use `-e "STEAMCMD=..."`. Example: `-e "STEAMCMD=+runscript /home/user/Steam/addmods.txt"`.

## Credits
Based on the image of https://github.com/BitR/empyrion-docker
