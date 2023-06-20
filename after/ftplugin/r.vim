"call utils#Load_Plug("Nvim-R")

" Function =================================================================== {{{1
let b:cached_data = "/tmp/r_obj_preview.tsv"
setlocal foldmethod=expr
setlocal foldexpr=fold#GetFold()
setlocal formatprg=r-format
setlocal tags+=~/.cache/Nvim-R/Rtags,~/.cache/Nvim-R/RsrcTags 

" Keymap ===================================================================== {{{1
nnoremap <buffer> <localleader>dl :<c-u>RSend devtools::load_all()<cr>
nnoremap <buffer> <localleader>dd :<c-u>RSend devtools::document()<cr>
nnoremap <buffer> <localleader>dt :<c-u>RSend devtools::test()<cr>
nnoremap <buffer> <localleader>db :<c-u>RSend rlang::trace_back()<cr>

nnoremap <buffer> <localleader>tv yiw:<c-u>call utils#R_view_df_sample('ht')<cr>
nnoremap <buffer> <localleader>tr yiw:<c-u>call utils#R_view_df_sample('r')<cr>
nnoremap <buffer> <localleader>th yiw:<c-u>call utils#R_view_df_sample('h')<cr>
nnoremap <buffer> <localleader>tt yiw:<c-u>call utils#R_view_df_sample('t')<cr>
nnoremap <buffer> <localleader>tV yiw:<c-u>call utils#R_view_df_full(30)<cr>
vnoremap <buffer> <localleader>tv y:<c-u>call   utils#R_view_df_sample('ht')<cr>
vnoremap <buffer> <localleader>tr y:<c-u>call   utils#R_view_df_sample('r')<cr>
vnoremap <buffer> <localleader>th y:<c-u>call   utils#R_view_df_sample('h')<cr>
vnoremap <buffer> <localleader>tt y:<c-u>call   utils#R_view_df_sample('t')<cr>
vnoremap <buffer> <localleader>tV y:<c-u>call   utils#R_view_df_full(30)<cr>
nnoremap <buffer> <localleader>t1 :<c-u>call    utils#R_view_srdm_table()<cr>
nnoremap <buffer> <localleader>t2 :<c-u>call    utils#R_view_srdm_var()<cr>

inoremap <buffer> <A-\>          %>%
inoremap <buffer> <A-\|>         %<>%
inoremap <buffer> <A-=>          <-<Space>
imap     <buffer> <A-1>          <Esc><Plug>RSendLine
nmap     <buffer> <A-1>          <Plug>RSendLine
if has("mac")
    inoremap <buffer> «          %>%
    inoremap <buffer> »          %<>%
    inoremap <buffer> ≠          <-<Space>
    imap     <buffer> ¡          <Esc><Plug>RDSendLine
    nmap     <buffer> ¡          <Plug>RDSendLine
endif

nmap     <buffer> <localleader>l              <Plug>RSendLine
vmap     <buffer> <localleader>l              <Plug>RSendSelection
nmap     <buffer> <LocalLeader>: :RSend 

inoremap <buffer> ;rq                     <esc>vap:LbsRF<cr>
nnoremap <buffer> <tab>rq                 vap:LbsRF<cr>
vnoremap <buffer> <tab>rq                 :LbsRF<cr>

lua << EOF
wk = require("which-key")
wk.register({
['t'] = { name = "View Data Frame" },
['a'] = { name = "Send file / ALE" },
['b'] = { name = "Send block / debug" },
['d'] = { name = "devtools" },
['f'] = { name = "Send function" },
['k'] = { name = "Rmarkdown / Knitr" },
['p'] = { name = "Send paragraphs" },
['r'] = { name = "R command" },
['s'] = { name = "Send Selection" },
['u'] = { name = "Undebug" },
['v'] = { name = "View Object" },
['x'] = { name = "R comment" },
}, { buffer = 0, prefix = '<localleader>' })
EOF

