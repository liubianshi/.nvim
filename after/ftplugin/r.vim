"call Lbs_Load_Plug("Nvim-R")
"call Lbs_Load_Plug('ale')

" Function =================================================================== {{{1
let b:cached_data = "/tmp/r_obj_preview.tsv"
set fdm=marker

" Keymap ===================================================================== {{{1
nnoremap <buffer> <localleader>dl :<c-u>RSend devtools::load_all()<cr>
nnoremap <buffer> <localleader>dd :<c-u>RSend devtools::document()<cr>
nnoremap <buffer> <localleader>dt :<c-u>RSend devtools::test()<cr>

nmap <buffer> <localleader>tv yiw:<c-u>call R_view_df_sample('ht')<cr>
nmap <buffer> <localleader>tr yiw:<c-u>call R_view_df_sample('r')<cr>
nmap <buffer> <localleader>th yiw:<c-u>call R_view_df_sample('h')<cr>
nmap <buffer> <localleader>tt yiw:<c-u>call R_view_df_sample('t')<cr>
nmap <buffer> <localleader>tV yiw:<c-u>call R_view_df_full(30)<cr>
vmap <buffer> <localleader>tv y:<c-u>call   R_view_df_sample('ht')<cr>
vmap <buffer> <localleader>tr y:<c-u>call   R_view_df_sample('r')<cr>
vmap <buffer> <localleader>th y:<c-u>call   R_view_df_sample('h')<cr>
vmap <buffer> <localleader>tt y:<c-u>call   R_view_df_sample('t')<cr>
vmap <buffer> <localleader>tV y:<c-u>call   R_view_df_full(30)<cr>
nmap <buffer> <localleader>t1 :<c-u>call    R_view_srdm_table()<cr>
nmap <buffer> <localleader>t2 :<c-u>call    R_view_srdm_var()<cr>

inoremap <buffer> <A-\>          %>%
inoremap <buffer> <A-\|>         %<>%
inoremap <buffer> <A-=>          <-<Space>
imap     <buffer> <A-1>          <Esc><Plug>RDSendLine
nmap     <buffer> <A-1>          <Plug>RDSendLine
if has("mac")
	inoremap <buffer> «          %>%
	inoremap <buffer> »          %<>%
	inoremap <buffer> ≠          <-<Space>
	imap     <buffer> ¡          <Esc><Plug>RDSendLine
	nmap     <buffer> ¡          <Plug>RDSendLine
endif

nmap     <buffer> <localleader>l              <Plug>RDSendLine
vmap     <buffer> <localleader>l              <Plug>REDSendSelection
nmap     <buffer> <LocalLeader>: :RSend 

inoremap <buffer> ;rq                     <esc>vap:LbsRF<cr>
nnoremap <buffer> <tab>rq                 vap:LbsRF<cr>
vnoremap <buffer> <tab>rq                 :LbsRF<cr>

inoremap <buffer> ;<CR> <Esc>A;<CR>
nnoremap <buffer> <tab><CR> <Esc>A;<CR>


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

"setlocal formatprg=r-format

