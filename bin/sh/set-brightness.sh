#!/bin/sh
#
brightness=$(rofi -dmenu -p "Enter brightness (0 to 1.0):" -lines 1)

# Check if the input is '2' and set brightness to 0.5 by default
if [ "$brightness" = "2" ]; then
  brightness="0.8"
fi

if [ "$brightness" = "3" ]; then
  brightness="0.5"
fi

if [ "$brightness" = "4" ]; then
  brightness="0.4"
fi

if [ "$brightness" = "5" ]; then
  brightness="0.3"
fi

if [ "$brightness" = "6" ]; then
  brightness="0.25"
fi

if [ "$brightness" = "7" ]; then
  brightness="0.2"
fi

xrandr --output HDMI-2 --brightness "$brightness"
