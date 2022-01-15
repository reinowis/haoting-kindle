#!/bin/sh
# script to kill the sox stream playing and save a bookmark

killall sox

progress=0

if [ -s /var/tmp/progress ]
   then
   progress=`cat /var/tmp/progress`
fi

started=`cat /var/tmp/started`
ended=`date +"%s"`
elapsed=`expr $progress + $ended - $started`
echo $elapsed >/var/tmp/bookmark
