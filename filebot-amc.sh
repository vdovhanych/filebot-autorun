#!/bin/bash

#Folder where all present media will be processed by filebot. Ajust based on your directory.
 mydir=/volume1/Main/Downloads

#Destination folder where all media will be organized. Ajust based on your directory.
 destination=/volume1/Media

#Inotify service on move action
do_action() {
        #amc script setup. More info at https://www.filebot.net/
        filebot \
            -script fn:amc \
            --output "$destination" \
            --action move \
            --conflict auto \
            -non-strict "$mydir" \
            --def subtitles=ces \
            --def clean=y \
            --def unsorted=y \
            --def artwork=y \
            --def extras=y \
            --def excludeList=amc.txt

        filebot \
             -script fn:suball "$destination" \
             -non-strict --def maxAgeDays=7 \
             --lang ces \
             --lang eng
}

while true; do
    inotifywait -r -e create,moved_to "$mydir"
    do_action
done
