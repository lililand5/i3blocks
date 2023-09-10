#!/bin/sh

VOLUME_MUTE="🔇"
VOLUME_LOW="🔈"
VOLUME_MID="🔉"
VOLUME_HIGH="🔊"

# Получаем информацию о текущем активном источнике и его громкости
ACTIVE_SINK=$(pactl list short sinks | awk '/RUNNING/{print $1; exit}')
if [ -z "$ACTIVE_SINK" ]; then
    ACTIVE_SINK=$(pactl list short sinks | awk '{print $1}' | head -n 1)
fi

VOLUME=$(pactl list sinks | grep "^[[:space:]]Volume:" | head -n $(( $ACTIVE_SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')
MUTE=$(pactl list sinks | grep "^[[:space:]]Mute:" | head -n $(( $ACTIVE_SINK + 1 )) | tail -n 1 | sed 's/[^a-z]//g')

ICON="$VOLUME_HIGH"
if [ "$MUTE" = "yes" ]; then
    ICON="$VOLUME_MUTE"
else
    if [ "$VOLUME" -lt 34 ]; then
        ICON="$VOLUME_LOW"
    elif [ "$VOLUME" -lt 67 ]; then
        ICON="$VOLUME_MID"
    fi
fi

echo "$ICON" "$VOLUME%" | awk '{ printf(" %s:%s \n", $1, $2) }'

