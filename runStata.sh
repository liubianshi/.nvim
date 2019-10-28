#!/bin/bash
win_active=$(xdotool getactivewindow | head -1)
win_stata=$(xdotool search --name "Stata/MP 14.1" | head -1)
echo 'do /tmp/statacmd.do' | xsel -ib

xdotool windowactivate $win_stata
xdotool windowfocus $win_stata
xdotool key ctrl+1
xdotool key ctrl+a
xdotool key ctrl+v
xdotool key 104 
xdotool windowactivate $win_active


