#!/bin/bash
ARG=$1
if [ "$ARG" = "+5" ]; then
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
elif [ "$ARG" = "-5" ]; then
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
elif [ "$ARG" = "mute" ]; then
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
fi

# Get current volume and whether it's muted
MUTE=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep "MUTED")
VOL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -oP '\d+\.\d+' | awk '{print int($1*100)}')

if [ ! -z "$MUTE" ]; then
    VOL=0
fi

qs -c quickshell-launcher ipc call osd volume $VOL
