let r_syntax_folding = 1
let R_cmd = "R"
let R_app = "radian"
let R_hl_term = 1
let R_openpdf = 0
let R_bracketed_paste = 1
let R_rcomment_string = '#> '
let R_nvimpager = "vertical"
let Rout_more_colors = 1
let R_hi_fun = 1
let R_hi_fun_globenv = 2
let R_hi_fun_paren = 1
let R_assign = 0
let R_rmdchunk = 0
"let R_user_maps_only = 1
"let rmd_syn_hl_chunk = 1
if ($SSH_CLIENT == "")
    "let R_external_term = 'alacritty -t R -e'
    let R_external_term = 'st -t R -e'
endif
let R_notmuxconf = 1
let R_csv_app = "terminal:/home/liubianshi/useScript/viewdata"
let R_start_libs = 'base,stats,graphics,grDevices,utils,methods,rlang,data.table,fread,readxl,haven,lbs'
command! RStart let oldft=&ft
    \ | set ft=r
    \ | exe 'set ft='.oldft
    \ | let b:IsInRCode = function("DefaultIsInRCode")
    \ | normal <LocalLeader>rf


