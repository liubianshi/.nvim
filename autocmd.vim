" function: css {{{1
function! s:CSS()
     set equalprg="prettier --tab-width 4"
endfunction

" function: c anc c++ {{{1
function! s:C_CPP()
    nnoremap <buffer><silent> <localleader>D :<c-u>AsyncRun gcc -Wall -O2 "$(VIM_FILEPATH)" -o "$(VIM_FILEDIR)/$(VIM_FILENOEXT)"<cr>
    nnoremap <buffer><silent> <localleader>L :<c-u>AsyncRun -raw -cwd=$(VIM_FILEDIR) "$(VIM_FILEDIR)/$(VIM_FILENOEXT)"<cr>
endfunction

" function: r and rmd {{{1
function! s:R_Rmd()
    nmap <buffer> <localleader>tv yiw:<c-u>call R_view_df_sample('ht')<cr>
    nmap <buffer> <localleader>tr yiw:<c-u>call R_view_df_sample('r')<cr>
    nmap <buffer> <localleader>th yiw:<c-u>call R_view_df_sample('h')<cr>
    nmap <buffer> <localleader>tt yiw:<c-u>call R_view_df_sample('t')<cr>
    nmap <buffer> <localleader>tV yiw:<c-u>call R_view_df_full(30)<cr>
    vmap <buffer> <localleader>tv y:<c-u>call R_view_df_sample('ht')<cr>
    vmap <buffer> <localleader>tr y:<c-u>call R_view_df_sample('r')<cr>
    vmap <buffer> <localleader>th y:<c-u>call R_view_df_sample('h')<cr>
    vmap <buffer> <localleader>tt y:<c-u>call R_view_df_sample('t')<cr>
    vmap <buffer> <localleader>tV y:<c-u>call R_view_df_full(30)<cr>
    nmap <buffer> <localleader>t1 :<c-u>call R_view_srdm_table()<cr>
    nmap <buffer> <localleader>t2 :<c-u>call R_view_srdm_var()<cr>

    inoremap <buffer> <A-\>          %>%
    inoremap <buffer> <A-=>          <-<Space>
    imap     <buffer> <A-1>          <Esc><Plug>RDSendLine<CR>
    nmap     <buffer> <A-1>          <Plug>RDSendLine<CR>
    nmap     <buffer> ,              <Plug>RDSendLine
    vmap     <buffer> ,              <Plug>REDSendSelection
    nmap     <buffer> <LocalLeader>: :RSend 

    inoremap <buffer> ;rq                     <esc>vap:LbsRF<cr>
    nnoremap <buffer> <tab>rq                 vap:LbsRF<cr>
    vnoremap <buffer> <tab>rq                 :LbsRF<cr>

    inoremap <buffer> ;<CR> <Esc>A;<CR>
    nnoremap <buffer> <tab><CR> <Esc>A;<CR>
endfunction

function! s:Rscript()
    nnoremap <localleader>L :<c-u>RSend devtools::load_all()<cr>
    nnoremap <localleader>D :<c-u>RSend devtools::document()<cr>
    nnoremap <localleader>T :<c-u>RSend devtools::test()<cr>
endfunction

" function: md and rmd {{{1
function! s:Markdown_Rmd()
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
endfunction  
             
" function: rmd {{{1
function! s:Rmd()
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
endfunction

" function: Markdown {{{1
function! s:Markdown()
    nnoremap <buffer> <leader>pp               :Pandoc pdf -H ~/useScript/header.tex<cr>
    nnoremap <buffer> <leader>ph               :Pandoc html<cr>
    nnoremap <buffer> <silent> <localleader>pi :<c-u>call mdip#MarkdownClipboardImage()<CR>
endfunction

" function: stata {{{1
function! s:Stata()
    if(has("mac"))
        inoremap <buffer> ¡ <esc>V:<c-u>call RunDoLines()<cr>
        nnoremap <buffer> ¡ V:call RunDoLines()<cr>
        vnoremap <buffer> ¡ :<C-U>call RunDoLines()<cr>
    else
        inoremap <buffer> <A-1> <esc>V:<c-u>call RunDoLines()<cr>
        nnoremap <buffer> <A-1> V:call RunDoLines()<cr>
        vnoremap <buffer> <A-1> :<C-U>call RunDoLines()<cr>
    endif
    nnoremap <buffer> , <esc>V:<C-U>call RunDoLines()<cr>
    vnoremap <buffer> , :<C-U>call RunDoLines()<cr>

    let b:AutoPairs = g:AutoPairs
    let b:AutoPairs['`']="'" 
    setlocal foldmethod=marker
    setlocal foldmarker={,}
endfunction

" function: sql {{{1
function! s:Sql()
    vnoremap <buffer> <localleader>l :DB<cr>
    nnoremap <buffer> <localleader>l V:DB<cr>
    nnoremap <buffer> <localleader>L :<c-u>DB < "%"<cr>
    nmap     <buffer> <localleader>E <Plug>(DBUI_EditBindParameters)
    nmap     <buffer> <localleader>W <Plug>(DBUI_SaveQuery) 
endfunction

" function: qf {{{1
function! s:Qf()
    nnoremap <silent><buffer> p :PreviewQuickfix<cr>
    nnoremap <silent><buffer> P :PreviewClose<cr>
    noremap <buffer> [u :PreviewScroll -1<cr>
    noremap <buffer> ]u :PreviewScroll +1<cr>
endfunction

" function: dot {{{1
function! s:Dot()
    nnoremap <buffer> <localleader>d :<c-u>AsyncRun dot -Tpdf % -o "%:r.pdf"<cr> 
endfunction

" function: complete_init {{{1
function! s:FileType_init()
    if &ft =~? '^\(r\|rmd\|rmarkdown\)$'
        call Ncm2CompleteEngine()
    else
        call CocCompleteEngine()
    endif
    if ! &ft =~ 'ruby\|javascript\|perl'
        %s/\s\+$//e
    endif
    return 0
endfunction

" function: raku {{{1
function! s:Raku() 
    let b:AutoPairs = g:AutoPairs
    let b:AutoPairs['<']=">"
    abbr << « 
    abbr >> »
    setlocal foldmethod=marker
    nnoremap <buffer> <silent> <localleader>r :<c-u>AsyncRun raku "%"<cr>
    inoremap <buffer> <A-\> ==><cr>
    inoremap <buffer> <A-=> =>
    inoremap <buffer> <A--> ->
    inoremap <buffer> ;i    $
    inoremap <buffer> ;o    ~
    inoremap <buffer> ;l    <esc>A
    inoremap <buffer> ;<CR> <Esc>A;<CR>

    if(has("mac"))
        inoremap <buffer> <A-\> ==><cr>
    endif
endfunction

" cmd: start {{{1
augroup LOAD_ENTER
autocmd!

" cmd: global setting {{{1
autocmd BufNewFile,BufRead   *.md                       setlocal filetype=pandoc
autocmd BufNewFile,BufRead   *.raku,*.p6,*.pl6,*.p6     setlocal filetype=raku
autocmd BufNewFile,BufRead   *.csv                      setlocal filetype=csv
autocmd BufNewFile,BufRead   sxhkdrc                    setlocal filetype=sxhkd
autocmd BufNewFile,BufRead   */cheatsheets/personal/R/* setlocal filetype=r
autocmd BufNewFile,BufRead   *.[Rr]md,*.[Rr]markdown    setlocal filetype=rmd
autocmd BufNewFile,BufRead   *                          call plug#load('vim-snippets')
autocmd BufNewFile,BufRead   *                          call plug#load('vim-fugitive')
autocmd BufNewFile,BufRead   *                          call plug#load('vimcdoc')
autocmd BufNewFile,BufRead   *                          call <sid>FileType_init()
autocmd InsertLeave,WinEnter *                          setlocal cursorline
autocmd InsertEnter,WinLeave *                          setlocal nocursorline
autocmd TermOpen             *                          setlocal nonumber norelativenumber bufhidden=hide
autocmd BufEnter             *                          if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
autocmd BufEnter             *                          call Status()

" cmd: 中文输入法切换 {{{1
if(has("mac"))
    autocmd BufNewFile,BufRead * call plug#load('fcitx-vim-osx')
else
    autocmd BufNewFile,BufRead * call plug#load('fcitx.vim')
endif

" cmd: TMUX {{{1
if exists('$TMUX')
    autocmd BufNewFile,BufRead * call plug#load('vim-obsession')
endif

" cmd: floaterm {{{1
autocmd FileType floaterm nnoremap <buffer> <leader>r :<C-U>FloatermUpdate --wintype=normal --position=right<cr>
autocmd FileType floaterm nnoremap <buffer> <leader>l :<C-U>FloatermUpdate --wintype=normal --position=left<cr>
autocmd FileType floaterm nnoremap <buffer> <leader>f :<C-U>FloatermUpdate --wintype=floating --position=topright<cr>

" cmd: filetype {{{1
autocmd FileType pandoc,md,markdown,rmd,rmarkdown call <sid>Markdown_Rmd()
autocmd FileType pandoc,md,markdown               call <sid>Markdown()
autocmd FileType r,rmd,rmarkdown                  call <sid>Rscript()
autocmd FileType rmd,rmarkdown                    call <sid>Rmd()
autocmd FileType r,rmd,rmarkdown                  call <sid>R_Rmd()
autocmd FileType stata                            call <sid>Stata()
autocmd FileType sql                              call <sid>Sql()
autocmd FileType dot                              call <sid>Dot()
autocmd FileType qf                               call <sid>Qf()
autocmd FileType c                                call <sid>C_CPP()
autocmd FileType dbui nmap <buffer> v <Plug>(DBUI_SelectLineVsplit)<cr>
autocmd FileType mail setlocal tw=0 wrap
autocmd FileType css  set formatprg="prettier --tab-width 4"


" cmd: restore {{{1
augroup END
