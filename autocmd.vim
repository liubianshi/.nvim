" filetype related init {{{1
"
" function: csv_tsv {{{2
function s:Table()
    call Lbs_Load_Plug("rainbow_csv")
endfunction

" function: css {{{2
function! s:CSS()
    call Lbs_Load_Plug('ale')
    set equalprg="prettier --tab-width 4"
endfunction

" function: c anc c++ {{{2
function! s:C_CPP()
    call Lbs_Load_Plug('vimspector')
    call Lbs_Load_Plug('ale')
    nnoremap <buffer><silent> <localleader>D :<c-u>AsyncRun gcc -Wall -O2 "$(VIM_FILEPATH)" -o "$(VIM_FILEDIR)/$(VIM_FILENOEXT)"<cr>
    nnoremap <buffer><silent> <localleader>L :<c-u>AsyncRun -raw -cwd=$(VIM_FILEDIR) "$(VIM_FILEDIR)/$(VIM_FILENOEXT)"<cr>
endfunction

" function: r and rmd {{{2
function! s:R_Rmd()
    call Lbs_Load_Plug("Nvim-R")
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
endfunction

" function: r {{{2
function! s:Rscript()
    call Lbs_Load_Plug('ale')
    nnoremap <buffer> <localleader>L :<c-u>RSend devtools::load_all()<cr>
    nnoremap <buffer> <localleader>D :<c-u>RSend devtools::document()<cr>
    nnoremap <buffer> <localleader>T :<c-u>RSend devtools::test()<cr>
endfunction

" function: md and rmd {{{2
function! s:Markdown_Rmd()
    for plugname in ['vim-pandoc', 'vim-pandoc-syntax', 'md-img-paste.vim', 'pangu.vim']
        call Lbs_Load_Plug(plugname)
    endfor
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

" function: rmd {{{2
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

" function: Markdown {{{2
function! s:Markdown()
    nnoremap <buffer> <leader>pp               :Pandoc pdf -H ~/useScript/header.tex<cr>
    nnoremap <buffer> <leader>ph               :Pandoc html<cr>
    nnoremap <buffer> <silent> <localleader>pi :<c-u>call mdip#MarkdownClipboardImage()<CR>
endfunction

" function: stata {{{2
function! s:Stata()
    call Lbs_Load_Plug('stata-vim')
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

" function: sql {{{2
function! s:Sql()
    call Lbs_Load_Plug("vim-dadbod")
    call Lbs_Load_Plug("vim-dadbod-ui")
    call Lbs_Load_Plug("vim-dadbod-competion")
    vnoremap <buffer> <localleader>l :DB<cr>
    nnoremap <buffer> <localleader>l V:DB<cr>
    nnoremap <buffer> <localleader>L :<c-u>DB < "%"<cr>
    nmap     <buffer> <localleader>E <Plug>(DBUI_EditBindParameters)
    nmap     <buffer> <localleader>W <Plug>(DBUI_SaveQuery) 
endfunction

" function: qf {{{2
function! s:Qf()
    nnoremap <silent><buffer> p :PreviewQuickfix<cr>
    nnoremap <silent><buffer> P :PreviewClose<cr>
    noremap <buffer> [u :PreviewScroll -1<cr>
    noremap <buffer> ]u :PreviewScroll +1<cr>
endfunction

" function: dot {{{2
function! s:Dot()
    nnoremap <buffer> <localleader>d :<c-u>AsyncRun dot -Tpdf % -o "%:r.pdf"<cr> 
endfunction

" function: tex {{{2
function! s:Tex()
    call Lbs_Load_Plug("vimtex")
endfunction

" function: raku {{{2
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


" function: FileType_init {{{2
function! s:FileType_init()
    "if &ft =~? '^\(r\|rmd\|rmarkdown\)$'
        "call Ncm2CompleteEngine()
    "else
        "call CocCompleteEngine()
    "endif
    if ! &ft =~? '^\(ruby\|javascript\|perl\|vim\)$'
        %s/\s\+$//e
    endif
    return 0
endfunction

" cmd: start {{{1
augroup LOAD_ENTER
autocmd!

" cmd: global setting {{{1
autocmd InsertLeave,WinEnter *                          setlocal cursorline
autocmd InsertEnter,WinLeave *                          setlocal nocursorline
autocmd TermOpen             *                          setlocal nonumber norelativenumber bufhidden=hide
autocmd BufEnter             *                          call Status()

" cmd: TMUX {{{1
if exists('$TMUX')
    autocmd BufNewFile,BufRead * call Lbs_Load_Plug('vim-obsession')
endif

" cmd: floaterm {{{1
autocmd FileType floaterm nnoremap <buffer> <leader>r :<C-U>FloatermUpdate --wintype=normal --position=right<cr>
autocmd FileType floaterm nnoremap <buffer> <leader>l :<C-U>FloatermUpdate --wintype=normal --position=left<cr>
autocmd FileType floaterm nnoremap <buffer> <leader>f :<C-U>FloatermUpdate --wintype=floating --position=topright<cr>

" cmd: filetype {{{1
"au FileType pandoc,md,markdown,rmd,rmarkdown call <sid>Markdown_Rmd()
"au FileType pandoc,md,markdown               call <sid>Markdown()
"au FileType r,rmd,rmarkdown                  call <sid>Rscript()
"au FileType r,rmd,rmarkdown                  call <sid>R_Rmd()
"au FileType rmd,rmarkdown                    call <sid>Rmd()
"au FileType sh,bash,stata                    call Lbs_Load_Plug("vimcmdline")
"au FileType stata                            call <sid>Stata()
"au FileType sql                              call <sid>Sql()
"au FileType dot                              call <sid>Dot()
"au FileType qf                               call <sid>Qf()
"au FileType c                                call <sid>C_CPP()
"au FileType dbui nmap <buffer> v <Plug>(DBUI_SelectLineVsplit)<cr>
"au FileType mail setlocal tw=0 wrap
"au FileType css  set formatprg="prettier --tab-width 4"
"au FileType csv,tsv                          call <sid>Table()


" cmd: restore {{{1
augroup END

" Wiki Autocmds {{{1
augroup MyWikiAutocmds
    autocmd!
    autocmd User WikiLinkOpened PandocHighlight r
augroup END
