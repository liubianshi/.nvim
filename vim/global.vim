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
let g:plug_manage_tool                = "lazyvim"
if $NVIM_COMPLETE_METHOD ==? ""                    " 设定补全的框架
    let g:complete_method             = "cmp"
else
    let g:complete_method             = $NVIM_COMPLETE_METHOD
endif

let g:Perldoc_path = $HOME . "/.cache/perldoc/"
let g:R_start_libs = "base,stats,graphics,grDevices,utils,methods," . 
                   \ "rlang,data.table,readxl,haven,lbs,purrr,stringr," .
                   \ "fst,box,future,devtools,ggplot,fixest"

let g:page_popup_winblend = 25

" Man page related
let g:ft_man_open_mode = 'vert'
let g:ft_man_no_sect_fallback = 1
let g:ft_man_folding_enable = 1

