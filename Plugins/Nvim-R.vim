let r_syntax_folding = 0
let r_syntax_fun_pattern = 1
let R_objbr_place = 'console,right'
let R_objbr_openlist = 1
let R_cmd = "R"
let R_args = ['--no-save', '--quiet']
"let R_app = "radian"
let R_hl_term = 1
let R_debug = 0
let R_dbg_jump = 0
let R_debug_center = 0
let R_openpdf = 0
let R_bracketed_paste = 1
if has('mac')
    let R_bracketed_paste = 0
endif
let R_rcomment_string = '#> '
let R_nvimpager = "vertical"
let Rout_more_colors = 1
let R_hi_fun = 1
let R_hi_fun_paren = 1
let R_assign = 0
let R_rmdchunk = 1
let R_listmethods = 1
let R_nvim_wd = 1   " Start R in working directory of vim
"let R_user_maps_only = 1
"let rmd_syn_hl_chunk = 1
"
"
let voom_ft_modes = {'rmd': 'pandoc', 'rnoweb': 'latex'}
"if ($SSH_CLIENT == "")
    ""let R_external_term = 'alacritty -t R -e'
    "let R_external_term = 'st -t R -e'
"endif

let R_notmuxconf = 1
" let R_csv_app = "terminal:viewdata"
let R_csv_app = "terminal:vd"

command! RStart
    \   let oldft=&ft
    \ | set ft=rmd
    \ | exe 'set ft='.oldft
    \ | let b:IsInRCode = function("RmdIsInRCode")
    \ | let b:SendChunkToR = function("SendRmdChunkToR")
    \ | normal! <localleader>rf

" for coc
let b:coc_additional_keywords = [ "." ]
