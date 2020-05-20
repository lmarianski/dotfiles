#!/bin/bash

export DISPLAY=:0
eval "export $(egrep -z DBUS_SESSION_BUS_ADDRESS /proc/$(pgrep -u $LOGNAME gnome-session)/environ)";

LAST_URL_FILE="$HOME/.local/share/lastUrl"

RES=$(curl "https://www.nvidia.pl/Download/processDriver.aspx?psid=95&pfid=727&rpf=1&osid=57&lid=14&lang=pl&ctk=0&dtid=1&dtcid=0")

if [ -f $LAST_URL_FILE ]; then
    LAST_URL=$(cat $LAST_URL_FILE)

   if [ $LAST_URL != $RES ]; then 
       /usr/bin/notify-send "New NVIDIA Driver available!" "$RES"
   fi
fi

echo $RES>$LAST_URL_FILE
