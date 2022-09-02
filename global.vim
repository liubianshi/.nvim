" 设置全局变量 ========================================================== {{{1
let g:mapleader = " "
let g:maplocalleader = ';'
if has('mac')
    let g:lbs_input_method_on         = 0
    let g:lbs_input_method_off        = 1
    let g:lbs_input_status            = "os_input_change -g"
    let g:lbs_input_method_inactivate = "os_input_change -s 1"
    let g:lbs_input_method_activate   = "os_input_change -s 0"
else
    let g:lbs_input_status            = "fcitx5-remote"
    let g:lbs_input_method_inactivate = "fcitx5-remote -c"
    let g:lbs_input_method_activate   = "fcitx5-remote -o"
    let g:lbs_input_method_off        = 1
    let g:lbs_input_method_on         = 2
endif
let g:plugs_lbs_conf                  = {}         " 用于记录插件个人配置文件的载入情况
let g:quickfix_is_open                = 0          " 用于记录 quickfix 的打开状态
let g:input_toggle                    = 1          " 用于记录输入法状态
let g:complete_method                 = "nvim-cmp" " 用于设定补全的框架

