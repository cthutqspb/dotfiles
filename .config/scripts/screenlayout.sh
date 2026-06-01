#!/bin/sh
#sleep 2
for output in $(xrandr --verbose | grep " connected" | grep -v "disconnected" | cut -d' ' -f1); do
    xrandr --output $output --auto
done
exit 0
