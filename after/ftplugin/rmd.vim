" for plugname in ['Nvim-R', 'vim-pandoc', 'vim-pandoc-syntax',
"             \    'md-img-paste.vim', 'pangu.vim',
"             \   ]
"     call utils#Load_Plug(plugname)
" endfor

"let g:PasteImageFunction = 'g:RmarkdownPasteImage'

" set fdm=expr
runtime ftplugin/pandoc.vim
" init vim-pandoc-after, if present {{{2
try
    call pandoc#after#Init()
catch /E117/
endtry



nnoremap <buffer><silent> <M-t> :<c-u>Voom pandoc<cr>
nnoremap <buffer> <localleader>db :<c-u>RSend rlang::trace_back()<cr>

nnoremap <silent> <localleader>tv yiw:<c-u>call utils#R_view_df_sample('ht')<cr>
nnoremap <silent> <localleader>tr yiw:<c-u>call utils#R_view_df_sample('r')<cr>
nnoremap <silent> <localleader>th yiw:<c-u>call utils#R_view_df_sample('h')<cr>
nnoremap <silent> <localleader>tt yiw:<c-u>call utils#R_view_df_sample('t')<cr>
nnoremap <silent> <localleader>tV yiw:<c-u>call utils#R_view_df_full(30)<cr>
vnoremap <silent> <localleader>tv y:<c-u>call   utils#R_view_df_sample('ht')<cr>
vnoremap <silent> <localleader>tr y:<c-u>call   utils#R_view_df_sample('r')<cr>
vnoremap <silent> <localleader>th y:<c-u>call   utils#R_view_df_sample('h')<cr>
vnoremap <silent> <localleader>tt y:<c-u>call   utils#R_view_df_sample('t')<cr>
vnoremap <silent> <localleader>tV y:<c-u>call   utils#R_view_df_full(30)<cr>
nnoremap <silent> <localleader>t1 :<c-u>call    utils#R_view_srdm_table()<cr>
nnoremap <silent> <localleader>t2 :<c-u>call    utils#R_view_srdm_var()<cr>

inoremap <silent> <A-\>          %>%
inoremap <silent> <A-\|>         %<>%
inoremap <silent> <A-=>          <-<Space>
"inoremap <buffer> <A-j>          x<left><enter><esc>lxi
nmap     <buffer> <localleader>l              <Plug>RSendLine
vmap     <buffer> <localleader>l              <Plug>RendSelection
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
"nnoremap <silent> <leader>nH
"    \ :w !pandoc --from=markdown+east_asian_line_breaks -t html - \| xclip -t text/html -sel clip -i<cr>
"noremap <silent> <leader>nh
"    \ :r  !xclip -o -t text/html -sel clip \| pandoc -f html -t markdown_strict<cr>
setlocal tw=78 formatoptions=tcq,ro/,n,lm]1,Bj tabstop=4 shiftwidth=4
UltiSnipsAddFiletype rmd.r.markdown.pandoc


nnoremap <silent> <localleader>pr          :<c-u>call utils#RmdClipBoardImage()<CR>
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
    imap     <silent> ¡ <Esc><Plug>RSendLine<CR>
    nmap     <silent> ¡ <Plug>RSendLine<CR>
endif


