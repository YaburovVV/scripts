#!/bin/bash

# manualy change monitor resolution
sudo xrandr --newmode "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
sudo xrandr --verbose --addmode DP-2 "1920x1080_60.00"
sudo xrandr --output DP-2 --mode "1920x1080_60.00"
