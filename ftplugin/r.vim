"call Lbs_Load_Plug("Nvim-R")
call Lbs_Load_Plug('ale')
nnoremap <buffer> <localleader>L :<c-u>RSend devtools::load_all()<cr>
nnoremap <buffer> <localleader>D :<c-u>RSend devtools::document()<cr>
nnoremap <buffer> <localleader>T :<c-u>RSend devtools::test()<cr>

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
"inoremap <buffer> <A-j>          x<left><enter><esc>lxi
imap     <buffer> <A-1>          <Esc><Plug>RDSendLine
nmap     <buffer> <A-1>          <Plug>RDSendLine
nmap     <buffer> ,              <Plug>RDSendLine
vmap     <buffer> ,              <Plug>REDSendSelection
nmap     <buffer> <LocalLeader>: :RSend 

inoremap <buffer> ;rq                     <esc>vap:LbsRF<cr>
nnoremap <buffer> <tab>rq                 vap:LbsRF<cr>
vnoremap <buffer> <tab>rq                 :LbsRF<cr>

inoremap <buffer> ;<CR> <Esc>A;<CR>
nnoremap <buffer> <tab><CR> <Esc>A;<CR>

"setlocal formatprg=r-format
