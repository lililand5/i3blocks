#!/bin/sh

pactl subscribe |
    while read -r event; do
        if echo "$event" | grep --quiet "sink"; then
            pkill -RTMIN+1 i3blocks
        fi
    done

