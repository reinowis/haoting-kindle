#!/bin/sh
# script to update playlist
# Kill the current player
killall sox
rm /var/tmp/bookmark
rm /var/tmp/progress
# Reset the media playlist
state=0
cp menu.state${state} menu.json
# Create initial variables
MUSICDIR=/mnt/us/music
OBJECT=''
COUNT=0
LENGTH=`find $MUSICDIR -maxdepth 1 -type f -regex '.*\.\(3gp\|aac\|flac\|ogg\|m3u\|m4a\|mp3\|pls\|wav\|wma\)' -name '[^(._)]*.*' | wc -l`
replace_object(){
    ACTION="./playfile.sh '${1}'"
    NAME=`basename "${1}"`
    PRIORITY=$2
    if [ "$2" -eq "0" ]
    then
        OBJECT="\n\t\t\t{\n\t\t\t\t\"name\": \"${NAME}\",\n\t\t\t\t\"priority\": \"${PRIORITY}\",\n\t\t\t\t\"action\": \"${ACTION}\",\n\t\t\t\t\"exitmenu\": false,\n\t\t\t\t\"status\": false,\n\t\t\t\t\"internal\": \"status Playing media ${NAME}\"\n\t\t\t}"
    else
        OBJECT="${OBJECT},\n\t\t\t{\n\t\t\t\t\"name\": \"${NAME}\",\n\t\t\t\t\"priority\": \"${PRIORITY}\",\n\t\t\t\t\"action\": \"${ACTION}\",\n\t\t\t\t\"exitmenu\": false,\n\t\t\t\t\"status\": false,\n\t\t\t\t\"internal\": \"status Playing media ${NAME}\"\n\t\t\t}"
    fi
}
# Read media files in the music folder
find $MUSICDIR -maxdepth 1 -type f -regex '.*\.\(3gp\|aac\|flac\|ogg\|m3u\|m4a\|mp3\|pls\|wav\|wma\)' -name '[^(._)]*.*' | while read FILE; do
    replace_object "$FILE" $COUNT
    COUNT=`expr $COUNT + 1`
    if [ "$COUNT" -eq "$LENGTH"  ] 
    then
        sed -i "s|\"markListItem\":true|\"items\":\[${OBJECT}\]|g" menu.json
    fi
done