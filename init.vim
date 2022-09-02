" Liubianshi's Neovim
function! s:Load(con) abort
    exec "source " . stdpath('config') . "/" . a:con . ".vim"
endfunction

call <SID>Load("global")         " 加载全局变量
call <SID>Load("plug")           " 管理插件
call <SID>Load("option")         " 设置选项
call <SID>Load("theme")          " 设置 UI
call <SID>Load("keymap")         " 设置 KeyMap
call <SID>Load("command")        " 创建命令
call <SID>Load("autocmd")        " 加载自动命令组
call <SID>Load("abbr")           " 加载必要的简写


