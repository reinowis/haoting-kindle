#!/bin/sh
# script to play all files in music directory
# kill the current player
killall sox
rm /var/tmp/bookmark
rm /var/tmp/progress

MUSICDIR=/mnt/us/music

# We can't allow non-valid file in the playlist
find $MUSICDIR -type f -regex '.*\.\(3gp\|aac\|flac\|ogg\|m3u\|m4a\|mp3\|pls\|wav\|wma\)'  -name '[^(._)]*.*' | sort >/var/tmp/playlist.m3u

export LD_LIBRARY_PATH=/mnt/us/extensions/sox/library:$LD_LIBRARY_PATH

offset=0

if [ -s /var/tmp/bookmark ]
   then
   offset=`cat /var/tmp/bookmark`
   mv -f /var/tmp/bookmark /var/tmp/progress
fi

# now determine how to play it

driver="unknown"

which gst-launch>/dev/null && driver="gst"

which aplay>/dev/null && aplay /mnt/us/extensions/sox/silence.wav 2>/dev/null &&  driver="alsa"

# now start playing

case "$driver" in

     alsa)
     
     echo "Playing via ALSA."

     date +"%s" >/var/tmp/started

     /mnt/us/extensions/sox/sox /var/tmp/playlist.m3u -t wav - trim $offset | aplay&
     ;;

     gst)

     echo "Playing via Gstreamer"

     # NOTE: ALL FILES MUST BE SAME encoding/channels/width/rate for Gstreamer to work!

     # now pull parameters from first file

     filename=`head -n 1 /var/tmp/playlist.m3u`

     # get soxi data from file to be played

     /mnt/us/extensions/sox/soxi "$filename" >/var/tmp/soxidata.txt

     # now to parse necessary information

     Chan=$(awk -F: '/Channels/ {gsub(" ","");print $2}' /var/tmp/soxidata.txt)

     Wide=$(awk -F: '/Precision/ {gsub(" ","");gsub("-bit","");print $2}' /var/tmp/soxidata.txt)

     Rate=$(awk -F: '/Sample Rate/ {gsub(" ","");print $2}' /var/tmp/soxidata.txt)

     rm /var/tmp/soxidata.txt

     # now start playing

     date +"%s" >/var/tmp/started

     /mnt/us/extensions/sox/sox /var/tmp/playlist.m3u -t raw - trim $offset |  /usr/bin/gst-launch \
     filesrc location=/dev/stdin \
     ! audio/x-raw-int, \
       endianness='(int)'1234, \
       signed='(boolean)'true, \
       width='(int)'$Wide, \
       depth='(int)'$Wide, \
       rate='(int)'$Rate, \
       channels='(int)'$Chan \
     ! queue \
     ! mixersink&
     ;;

     *)

     echo "Unknown sound driver, cannot play media."
     ;;
esac

