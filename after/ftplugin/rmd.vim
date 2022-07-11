for plugname in ['Nvim-R', 'vim-pandoc', 'vim-pandoc-syntax', 'md-img-paste.vim', 'pangu.vim']
    call Lbs_Load_Plug(plugname)
endfor

let g:PasteImageFunction = 'g:RmarkdownPasteImage'

" set fdm=expr
runtime ftplugin/pandoc.vim
" init vim-pandoc-after, if present {{{2
try
    call pandoc#after#Init()
catch /E117/
endtry


nmap <silent> <localleader>tv yiw:<c-u>call R_view_df_sample('ht')<cr>
nmap <silent> <localleader>tr yiw:<c-u>call R_view_df_sample('r')<cr>
nmap <silent> <localleader>th yiw:<c-u>call R_view_df_sample('h')<cr>
nmap <silent> <localleader>tt yiw:<c-u>call R_view_df_sample('t')<cr>
nmap <silent> <localleader>tV yiw:<c-u>call R_view_df_full(30)<cr>
vmap <silent> <localleader>tv y:<c-u>call   R_view_df_sample('ht')<cr>
vmap <silent> <localleader>tr y:<c-u>call   R_view_df_sample('r')<cr>
vmap <silent> <localleader>th y:<c-u>call   R_view_df_sample('h')<cr>
vmap <silent> <localleader>tt y:<c-u>call   R_view_df_sample('t')<cr>
vmap <silent> <localleader>tV y:<c-u>call   R_view_df_full(30)<cr>
nmap <silent> <localleader>t1 :<c-u>call    R_view_srdm_table()<cr>
nmap <silent> <localleader>t2 :<c-u>call    R_view_srdm_var()<cr>

inoremap <silent> <A-\>          %>%
inoremap <silent> <A-\|>         %<>%
inoremap <silent> <A-=>          <-<Space>
"inoremap <buffer> <A-j>          x<left><enter><esc>lxi
imap     <silent> <A-1>          <Esc><Plug>RDSendLine
nmap     <silent> <A-1>          <Plug>RDSendLine
nmap     <silent> ,              <Plug>RDSendLine
vmap     <silent> ,              <Plug>REDSendSelection
nmap     <silent> <LocalLeader>: :RSend 

inoremap <silent> ;rq                     <esc>vap:LbsRF<cr>
nnoremap <silent> <tab>rq                 vap:LbsRF<cr>
vnoremap <silent> <tab>rq                 :LbsRF<cr>

inoremap <silent> ;<CR> <Esc>A;<CR>
nnoremap <silent> <tab><CR> <Esc>A;<CR>

inoremap <silent> ;1              <esc>0i#<space><esc>A
inoremap <silent> ;2              <esc>0i##<space><esc>A
inoremap <silent> ;3              <esc>0i###<space><esc>A
inoremap <silent> ;-              <esc>^d0i-<tab><esc>A
inoremap <silent> ;_              <esc>^d0i<tab>-<tab><esc>A
inoremap <silent> ;=              <esc>^d0i1.<tab><esc>A
inoremap <silent> ;+              <esc>^d0i<tab>1.<tab><esc>A
inoremap <silent> ;c              ` `<C-o>F <c-o>x
inoremap <silent> ;m              $ $<C-o>F <c-o>x
inoremap <silent> ;i              * *<C-o>F <c-o>x
inoremap <silent> ;b              ** **<C-o>F <c-o>x
nnoremap <silent> <localleader>ic ysiW`
nnoremap <silent> <localleader>ab :<c-u>AsyncRun 
    \ xsel -ob >> %:p:h/ref.bib; xsel -ob \| perl -ne 'print "\@$1\n" if ($_ =~ /^\@\w+\{([^,]+)\,/)' >> ~/.config/nvim/paper.dict<cr>
nnoremap <silent> <leader>nH
    \ :w !pandoc --from=markdown+east_asian_line_breaks -t html - \| xclip -t text/html -sel clip -i<cr>
noremap <silent> <leader>nh
    \ :r  !xclip -o -t text/html -sel clip \| pandoc -f html -t markdown_strict<cr>
setlocal tw=78 formatoptions=tcroqlnmB1j tabstop=4 shiftwidth=4
    \ brk= formatexpr= formatprg=r-format indentexpr=
UltiSnipsAddFiletype rmd.r.markdown.pandoc


nnoremap <silent> <leader>rp               :AsyncRun ~/useScript/rmarkdown.sh %<cr>
nnoremap <silent> <leader>rh               :AsyncRun ~/useScript/rmarkdown.sh -o bookdown::html_document2 %<cr>
nnoremap <silent> <leader>nc               :RNrrw<cr>:set filetype=r<cr>
nnoremap <silent> <localleader>pr :<c-u>call RmdClipBoardImage()<CR>
nnoremap <silent> <localleader>kbp         :<c-u>RSend bookdown::render_book("index.Rmd", "bookdown::pdf_book")<cr>
nnoremap <silent> <localleader>kbh         :<c-u>RSend bookdown::render_book("index.Rmd", "bookdown::html_book")<cr>
nnoremap <silent> <localleader>kbo         :<c-u>! xdg-open ./_book/draft.pdf<cr> 
nnoremap <silent> <localleader>kbv         :<c-u>RSend bookdown::preview_chapter(%)<cr>
nnoremap <silent> <localleader>P           :<c-u>call RMakeRmd("bookdown::pdf_document2")<cr>
nnoremap <silent> <localleader>H           :<c-u>call RMakeRmd("bookdown::html_document2")<cr>
nnoremap <silent> <localleader>W           :<c-u>call RMakeRmd("bookdown::word_document2")<cr>

if(has("mac"))
    nnoremap <silent> <localleader>kbo  :<c-u>! open ./_book/draft.pdf<cr> 
    inoremap <silent> « %>%<cr>
    inoremap <silent> ≠ <-<cr> 
    imap     <silent> ¡ <Esc><Plug>RDSendLine<CR>
    nmap     <silent> ¡ <Plug>RDSendLine<CR>
endif


