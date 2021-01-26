#!/bin/bash
set -ev

# 获取当前系统所使用窗口管理器，如果是 dwm，需要做额外的处理
wm=$(wmctrl -m | grep 'Name' | cut -d' ' -f2)

# 获取当前窗口 ID 和 stata 窗口 ID，如果 stata 没有打开，则打开后，获取相应 ID
win_active=$(xdotool getactivewindow | head -1)
win_stata=$(xdotool search --name "Stata/MP 14.1" | head -1)

if [[ -z $win_stata ]]; then
    #st -t "Stata/MP 14.1" -c "Stata-mp" -e sh -c 'stata-mp -q' \
        #|| { echo "Error: Cannot open xstata-mp" >&2; exit 1; } &
    xstata-mp
    sleep 0.5
    win_stata=$(xdotool getactivewindow | head -1)
fi

# 将 Stata 命令文件拷贝到剪切板
echo 'do /tmp/statacmd.do' | xclip -sel clip

# 根据窗口管理器，选择合适的跳转方式
if [[ $wm == 'dwm' ]]; then
    xdotool set_window --urgency 1 "$win_stata"
    dwmc focusurgent
else
    xdotool windowactivate "$win_stata"
    xdotool windowfocus "$win_stata"
fi

# 在 Focus Stata 后，运行命令，根据 Stata 是否为 GUI，选择不同的处理方法
if [[ $(xprop -id "$win_stata" | grep -c "Xstata-mp") == 1 ]]; then
    xdotool key ctrl+1
    xdotool key ctrl+a
    xdotool key ctrl+v
    xdotool key 104 
else
    xdotool key ctrl+shift+v
    xdotool key 104
fi

# 跳转到原来而窗口
if [[ $wm == 'dwm' ]]; then
    xdotool set_window --urgency 1 "$win_active"
    dwmc focusurgent
else
    xdotool windowactivate "$win_active"
fi


