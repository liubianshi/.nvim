" Liubianshi's Neovim
if $TERM != "dvtm-256color"
    set termguicolors
endif


function! s:Load(con) abort
    exec "source " . stdpath('config') . "/vim/" . a:con . ".vim"
endfunction

runtime plugin/man.lua

" 加载全局变量
call <SID>Load("global")

" 加载自定义 lua 全局函数
lua require('global_functions')

" 管理插件
if has_key(g:, "plug_manage_tool") && g:plug_manage_tool == "lazyvim"
    lua require("plug")
else
    call <SID>Load("plug")                 
endif

" 设置选项
call <SID>Load("option")

" 设置 KeyMap
call <SID>Load("keymap")
lua require('keymap')

" 创建命令
call <SID>Load("command")                  

" 加载自动命令组
call <SID>Load("autocmd")

" 加载必要的简写
call <SID>Load("abbr")

" 设置 UI
lua require("theme")

" 初始化后的操作
lua require("after_init")
