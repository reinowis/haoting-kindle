#!/bin/sh
# script to play a local file on pw4
# kill the current player
killall sox
rm /var/tmp/bookmark
rm /var/tmp/progress
# add required library
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

     /mnt/us/extensions/sox/sox "$1" -t wav - trim $offset | aplay&
     ;;

     gst)

     echo "Playing via Gstreamer"

     # get soxi data from file to be played

     /mnt/us/extensions/sox/soxi "$1" >/var/tmp/soxidata.txt

     # now to parse necessary information

     Chan=$(awk -F: '/Channels/ {gsub(" ","");print $2}' /var/tmp/soxidata.txt)

     Wide=$(awk -F: '/Precision/ {gsub(" ","");gsub("-bit","");print $2}' /var/tmp/soxidata.txt)

     Rate=$(awk -F: '/Sample Rate/ {gsub(" ","");print $2}' /var/tmp/soxidata.txt)

     rm /var/tmp/soxidata.txt

     date +"%s" >/var/tmp/started

     /mnt/us/extensions/sox/sox "$1" -t raw - trim $offset |  /usr/bin/gst-launch \
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
