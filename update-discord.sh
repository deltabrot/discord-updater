#!/bin/sh

# global variables
WORK_DIR="$HOME/.discord-updater"
DOWNLOAD_URL="https://discord.com/api/download?platform=linux&format=tar.gz"
TARGET_LOCATION="/usr/bin/discord"

# ensure working directory exists
echo "ensuring '$WORK_DIR' exists"
mkdir -p $WORK_DIR

# navigate to the working directory
cd $WORK_DIR

# retrieve the redirection download URL from discord
echo "retrieving file server download URL from $DOWNLOAD_URL"
DISCORD_HTML_RESPONSE=$(curl -s $DOWNLOAD_URL)

# extract the URL from the response
FILE_SERVER_URL=$(echo $DISCORD_HTML_RESPONSE | sed -r 's/.*<a href="(.*)">.*/\1/')

# download the discord app tar.gz file
echo "downloading discord app archive"
curl $FILE_SERVER_URL > discord-latest.tar.gz

# extract the downloaded tar.gz file
echo "extracting discord-latest.tar.gz"
tar xvzf discord-latest.tar.gz &> /dev/null

# check if a symbolic link already exists
if [ -f "$TARGET_LOCATION" ]; then
    ls -l $TARGET_LOCATION | grep "$TARGET_LOCATION -> $WORK_DIR/Discord/Discord" &> /dev/null
    if [ $? -eq 0 ]; then
        echo "update complete"
        exit 0
    fi
fi

# ensure symbolic link is set appropriately
echo "please provide your password to configure the symbolic link to discord in /usr/bin/ (you will only need to do this once)"
sudo mv /usr/bin/discord $WORK_DIR/old-discord-binary 2> /dev/null
sudo ln -s $WORK_DIR/Discord/Discord /usr/bin/discord

echo "update complete"
