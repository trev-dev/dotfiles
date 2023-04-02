#! /usr/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar, using default config location ~/.config/polybar/config
hdmi_plugged=$(xrandr|grep ' connected'|grep 'HDMI'|awk '{print $1}')

if [ -z "$hdmi_plugged" ];
then
  polybar primary &
else
  polybar -c $HOME/.config/polybar/config-monitor primary &
fi

echo "Polybar launched..."
