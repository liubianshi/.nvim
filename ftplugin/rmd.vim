for plugname in ['Nvim-R', 'vim-pandoc', 'vim-pandoc-syntax', 'md-img-paste.vim', 'pangu.vim']
    call Lbs_Load_Plug(plugname)
endfor

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
inoremap <buffer> <A-=>          <-<Space>
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

inoremap <buffer> ;1              <esc>0i#<space><esc>A
inoremap <buffer> ;2              <esc>0i##<space><esc>A
inoremap <buffer> ;3              <esc>0i###<space><esc>A
inoremap <buffer> ;-              <esc>^d0i-<tab><esc>A
inoremap <buffer> ;_              <esc>^d0i<tab>-<tab><esc>A
inoremap <buffer> ;=              <esc>^d0i1.<tab><esc>A
inoremap <buffer> ;+              <esc>^d0i<tab>1.<tab><esc>A
inoremap <buffer> ;c              ` `<C-o>F <c-o>x
inoremap <buffer> ;m              $ $<C-o>F <c-o>x
inoremap <buffer> ;i              * *<C-o>F <c-o>x
inoremap <buffer> ;b              ** **<C-o>F <c-o>x
nnoremap <buffer> <localleader>ic ysiW`
nnoremap <buffer> <localleader>ab :<c-u>AsyncRun 
    \ xsel -ob >> %:p:h/ref.bib; xsel -ob \| perl -ne 'print "\@$1\n" if ($_ =~ /^\@\w+\{([^,]+)\,/)' >> ~/.config/nvim/paper.dict<cr>
nnoremap <buffer> <silent> <leader>nH
    \ :w !pandoc --from=markdown+east_asian_line_breaks -t html - \| xclip -t text/html -sel clip -i<cr>
noremap <buffer> <silent> <leader>nh
    \ :r  !xclip -o -t text/html -sel clip \| pandoc -f html -t markdown_strict<cr>
setlocal tw=78 formatoptions=tcroqlnmB1j tabstop=4 shiftwidth=4
    \ brk= formatexpr= formatprg=r-format indentexpr=
UltiSnipsAddFiletype rmd.r.markdown.pandoc


nnoremap <buffer> <leader>rp               :AsyncRun ~/useScript/rmarkdown.sh %<cr>
nnoremap <buffer> <leader>rh               :AsyncRun ~/useScript/rmarkdown.sh -o bookdown::html_document2 %<cr>
nnoremap <buffer> <leader>nc               :RNrrw<cr>:set filetype=r<cr>
nnoremap <buffer> <silent> <localleader>pi :<c-u>call RmdClipBoardImage()<CR>
nnoremap <buffer> <localleader>kbp         :<c-u>RSend bookdown::render_book("index.Rmd", "bookdown::pdf_book")<cr>
nnoremap <buffer> <localleader>kbh         :<c-u>RSend bookdown::render_book("index.Rmd", "bookdown::html_book")<cr>
nnoremap <buffer> <localleader>kbo         :<c-u>! xdg-open ./_book/draft.pdf<cr> 
nnoremap <buffer> <localleader>kbv         :<c-u>RSend bookdown::preview_chapter(%)<cr>
nnoremap <buffer> <localleader>P           :<c-u>call RMakeRmd("bookdown::pdf_document2")<cr>
nnoremap <buffer> <localleader>H           :<c-u>call RMakeRmd("bookdown::html_document2")<cr>
nnoremap <buffer> <localleader>W           :<c-u>call RMakeRmd("bookdown::word_document2")<cr>

if(has("mac"))
    nnoremap <buffer> <localleader>kbo  :<c-u>! open ./_book/draft.pdf<cr> 
    inoremap <buffer> « %>%<cr>
    inoremap <buffer> ≠ <-<cr> 
    imap     <buffer> ¡ <Esc><Plug>RDSendLine<CR>
    nmap     <buffer> ¡ <Plug>RDSendLine<CR>
endif
