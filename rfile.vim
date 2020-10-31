" Nvim-R 变量设置{{{1
let r_syntax_folding = 1
let R_cmd = "R"
let R_app = "radian"
let R_hl_term = 1
let R_openpdf = 1
let R_bracketed_paste = 0
let R_rcomment_string = '#> '
let R_nvimpager = "vertical"
let Rout_more_colors = 1
let R_hi_fun_globenv = 1
let R_hi_fun_paren = 1
let R_assign = 0
let R_rmdchunk = 0
let R_in_buffer = 1
let R_external_term = 'st -n R -e'
let R_csv_app = "terminal:/home/liubianshi/useScript/viewdata"
let R_start_libs = 'base,stats,graphics,grDevices,utils,methods,rlang,data.table,fread,readxl,tidyverse,haven,lbs'
"let R_assign_map = '<A-=>'
"let R_csv_app = 'terminal:sc-im'
"let R_csv_delim = '\t'
"let R_csv_app = 'tmux new-window sc-im'
"在普通 buffer 开启 nvim-r 的方法
command! RStart let oldft=&ft | set ft=r | exe 'set ft='.oldft | let b:IsInRCode = function("DefaultIsInRCode") | normal <LocalLeader>rf

