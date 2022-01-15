#!/bin/sh
# script to play an internet radio stream

# add required library

export LD_LIBRARY_PATH=/mnt/us/extensions/sox/library:$LD_LIBRARY_PATH

# need two arguments to this script: fmt and URL

fmt=$1
url=$2

# determine how to play it

driver="unknown"

which gst-launch>/dev/null && driver="gst"

which aplay>/dev/null && aplay /mnt/us/extensions/sox/silence.wav 2>/dev/null &&  driver="alsa"

# now start playing

case "$driver" in

     alsa)
     
     echo "Playing via ALSA."

     /mnt/us/extensions/sox/sox -t $fmt $url -t wav - -- |  aplay&
     ;;

     gst)

     # assume this is a stream and not a playlist

     testurl=$2

     # check to see if this is a playlist (pls or m3u)

     echo $url | grep pls >/var/tmp/is_pls
     echo $url | grep m3u >/var/tmp/is_m3u

     testfile=/var/tmp/testdata.$fmt

     if [ -s /var/tmp/is_pls ] || [ -s /var/tmp/is_m3u ]
        then
        curl -s -m 4 $url -o $testfile
        cat $testfile | grep :// | sed 's/File[0-9][0-9]*=//' >/var/tmp/playlist.m3u
        if [ -s /var/tmp/playlist.m3u ] ; then
           testurl=`head -n 1 /var/tmp/playlist.m3u | awk 'gsub(/\r/,""){printf $0;next}{print}'`
        fi
        rm /var/tmp/playlist.m3u
     fi

     rm /var/tmp/is_pls
     rm /var/tmp/is_m3u

     # retrieve a test sample from the stream

     curl -s -m 4 -o $testfile "$testurl"

     # get soxi data from file to be played

     /mnt/us/extensions/sox/soxi $testfile >/var/tmp/soxidata.txt

     # now to parse necessary information

     Chan=$(awk -F: '/Channels/ {gsub(" ","");print $2}' /var/tmp/soxidata.txt)

     Wide=$(awk -F: '/Precision/ {gsub(" ","");gsub("-bit","");print $2}' /var/tmp/soxidata.txt)

     Rate=$(awk -F: '/Sample Rate/ {gsub(" ","");print $2}' /var/tmp/soxidata.txt)

     rm $testfile
     rm /var/tmp/soxidata.txt

     /mnt/us/extensions/sox/sox -t $fmt $url -t raw - -- |  /usr/bin/gst-launch \
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
