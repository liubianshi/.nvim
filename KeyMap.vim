" 基础命令{{{1
"nnoremap <leader><leader> :<C-U><C-R>=printf("AsyncRun %s", "")<CR> 
nnoremap <silent> <leader>p :<c-u>execute "cd" expand("%:p:h")<cr>
nnoremap <silent> <leader>C :<c-u> call ChangeCompleteEngine()<cr>
nnoremap <silent> <leader>w :<c-u>:w<cr>
nnoremap <silent> <leader>x :<c-u>:q<cr>
nnoremap <leader>O :AsyncRun xdg-open "%"<cr>
inoremap <A-space> <Esc>
tnoremap <A-space> <C-\><C-n>
if(has("mac"))
    nnoremap <leader>O :AsyncRun open "%"<cr>
else
    nnoremap <A-d> 10j
    nnoremap <A-u> 10k
endif
nnoremap <leader>ev :tabedit $MYVIMRC<cr>
nnoremap <leader>ek :tabedit ~/.config/nvim/KeyMap.vim<cr>
nnoremap <leader>er :tabedit ~/.config/nvim/rfile.vim<cr>
nnoremap <leader>eV :source $MYVIMRC<cr>
nnoremap <silent> <leader><cr> :noh<cr>

" 管理 quickfix {{{1
nnoremap <leader>q :call QuickfixToggle()<cr>
let g:quickfix_is_open = 0
function! QuickfixToggle()
    if g:quickfix_is_open
        cclose
        let g:quickfix_is_open = 0
    else
        copen
        let g:quickfix_is_open = 1
    endif
endfunction

" buffer managing{{{1
nnoremap <silent> <leader>bc :<c-u>call Lilydjwg_cleanbufs()<cr>
nnoremap <silent> <leader>bd :<c-u>Bclose<cr>
nnoremap <silent> <leader>bj :<c-u>bp<cr>
nnoremap <silent> <leader>bk :<c-u>bn<cr>
nnoremap <silent> <leader>bq :q<cr>
nnoremap <silent> <leader>bQ :q!<cr>
nnoremap <silent> <leader>bw :w<cr>
nnoremap <silent> <leader>bW :w!<cr>

" 翻译{{{1
vnoremap <silent> <leader>tt "*y:AsyncRun xclip -o \| tr "\n" " " \| trans -b --no-ansi \| tee >(xclip -i -sel clip)<CR>
nnoremap <silent> <leader>tt vip:AsyncRun tr "\n" " " \| trans -b --no-ansi \| tee >(xclip -i -sel clip)<CR>
vnoremap <silent> <leader>te "*y:AsyncRun xclip -o \| tr "\n" " " \| trans -b --no-ansi zh:en \| tee >(xclip -i -sel clip)<CR>
nnoremap <silent> <leader>te vip:AsyncRun tr "\n" " " \| trans -b --no-ansi zh:en \| tee >(xclip -i -sel clip)<CR>

" 文件操作 lf-vim 相关快捷键{{{1
nnoremap <silent> <leader>lr :Lf<cr>
nnoremap <silent> <leader>ls :split +Lf<cr>
nnoremap <silent> <leader>lv :vertical split +Lf<cr>
nnoremap <silent> <leader>lt :LfNewTab<cr>
nnoremap <silent> <leader>lw :NERDTreeToggle<cr>
nnoremap <silent> <leader>nn :NnnPicker<CR>

" 补全相关 {{{1
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <Down> pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <silent><expr> <Up>   pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <silent><expr> <Tab>  pumvisible() ? "\<C-n>" : "\<Tab>"

inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

let g:UltiSnipsExpandTrigger		= "<c-u>"
let g:UltiSnipsJumpForwardTrigger	= "<c-j>"
let g:UltiSnipsJumpBackwardTrigger	= "<c-k>"
let g:UltiSnipsRemoveSelectModeMappings = 0

" Navigation {{{1
noremap j gj
noremap k gk
nnoremap J <C-w>j
nnoremap K <C-w>k
nnoremap H <C-w>h
nnoremap L <C-w>l
nnoremap <A-j> <Esc>Vj
nnoremap <A-k> <Esc>Vk
nnoremap <A-h> <Esc>v^
nnoremap <A-l> <Esc>v$
noremap <A-o> o<Esc>
noremap <A-O> O<Esc>
if(has("mac"))
    nnoremap ∆ <Esc>Vj
    nnoremap ˚ <Esc>Vk
    nnoremap ˙ <Esc>v^
    nnoremap ¬ <Esc>v$
    noremap ø o<Esc>
    noremap  Ø O<Esc>
endif
nnoremap ]b :<c-u>bnext<cr>
nnoremap [b :<c-u>bprevious<cr>
nnoremap ]B :<c-u>blast<cr>
nnoremap [B :<c-u>bfirst<cr>
nnoremap ]t :<c-u>tabnext<cr>
nnoremap [t :<c-u>tabprevious<cr>
nnoremap ]T :<c-u>tablast<cr>
nnoremap [T :<c-u>tabfirst<cr>

" tab managing{{{1
nnoremap <tab>o :only<cr>
nnoremap <tab>n :tabnew<cr>
nnoremap <tab>x :tabclose<cr>
nnoremap <tab>k :tabnext<cr>
nnoremap <tab>j :tabprevious<cr>

" 缩进{{{1
nnoremap <tab><tab> V>
vnoremap <tab> >gv
nnoremap <s-tab> V<
vnoremap <s-tab> <gv
nnoremap <tab>p "0p
nnoremap <tab>P "*p

" Visual mode pressing * or # searches for the current selection{{{1
" Super useful! From an idea by Michael Naumann
function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif
    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>:

" 处理 Markdown 和 Rmarkdown 文档{{{1
function! RmdClipBoardImage()
    execute "normal! i```{r, out.width = '70%', fig.pos = 'h', fig.show = 'hold'}\n"
    call mdip#MarkdownClipboardImage()
    execute "normal! \<esc>g_\"iyi)VCknitr::include_graphics(\"\")\<esc>F\"\"iPo```\n" 
endfunction

augroup MARKDOWN
    autocmd!
    autocmd FileType pandoc,md,markdown nnoremap <leader>pp
        \ :Pandoc pdf -H ~/useScript/header.tex<cr>
    autocmd FileType pandoc,md,markdown nnoremap <leader>ph
        \ :Pandoc html<cr>
    autocmd FileType rmd nnoremap <leader>rp
        \ :AsyncRun ~/useScript/rmarkdown.sh %<cr>
    autocmd FileType rmd nnoremap <leader>rh
        \ :AsyncRun ~/useScript/rmarkdown.sh -o bookdown::html_document2 %<cr>
    autocmd FileType pandoc,rmd,rmarkdown,raku,perl6,markdown
        \ inoremap ;<CR> <Esc>A;<CR>
    autocmd FileType pandoc,rmd,rmarkdown,raku,perl6,markdown
        \ nnoremap <tab><CR> <Esc>A;<CR>
    if(has("mac"))
        autocmd BufEnter,BufNewFile *.[Rr]md,*.md,*.tex nnoremap <leader>po
            \ :AsyncRun open "%:r.pdf"<cr> 
        autocmd BufEnter,BufNewFile *.[Rr]md,*.md nnoremap <leader>ho
            \ :AsyncRun open "%:r.html"<cr> 
    else
        autocmd BufEnter,BufNewFile *.[Rr]md,*.md,*.tex nnoremap <leader>po
            \ :AsyncRun xdg-open "%:r.pdf"<cr> 
        autocmd BufEnter,BufNewFile *.[Rr]md,*.md nnoremap <leader>ho
            \ :AsyncRun xdg-open "%:r.html"<cr> 
    endif
    autocmd FileType pandoc,markdown,md nnoremap <silent> <localleader>pi
        \ :<c-u>call mdip#MarkdownClipboardImage()<CR>
    autocmd FileType rmd,rmarkdown,rmd.rmarkdown nnoremap <silent> <localleader>pi
        \ :<c-u>call RmdClipBoardImage()<CR>
    autocmd FileType pandoc,md,markdown,Rmd,rmd,rmarkdown nmap <localleader>ic ysiW`

    autocmd BufEnter,BufNewFile *.[Rr]md,*.md,*.tex
        \ nnoremap <leader>ab :<c-u>AsyncRun 
        \ xsel -ob >> %:p:h/ref.bib; xsel -ob \| perl -ne 'print "\@$1\n" if ($_ =~ /^\@\w+\{([^,]+)\,/)' >> ~/.config/nvim/paper.dict<cr>
augroup END

" Easymotion Related{{{1
nmap ss <Plug>(easymotion-overwin-f2)
nmap sS <Plug>(easymotion-overwin-line)
nmap sl <Plug>(easymotion-sl)
nmap sj <plug>(easymotion-j)
nmap sJ <plug>(easymotion-eol-j)
nmap sk <plug>(easymotion-k)
nmap sK <plug>(easymotion-eol-k)
nmap sn <Plug>(easymotion-n)
nmap sN <Plug>(easymotion-N)
nmap sf <Plug>(easymotion-f2)
nmap sF <Plug>(easymotion-F2)
nmap st <Plug>(easymotion-t2)
nmap sT <Plug>(easymotion-T2)
nmap sw <Plug>(easymotion-w)
nmap sW <Plug>(easymotion-W)
nmap sb <Plug>(easymotion-b)
nmap sB <Plug>(easymotion-B)
nmap se <Plug>(easymotion-e)
nmap sE <Plug>(easymotion-E)
nmap sge <Plug>(easymotion-ge)
nmap sgE <Plug>(easymotion-gE)

function! SearchChinese() 
    silent execute '!fcitx5-remote -o'
    call EasyMotion#S(2,0,2)
    silent exe '!fcitx5-remote -c'
endfunction 
function! SearchChineseLine() 
    silent execute '!fcitx5-remote -o'
    call EasyMotion#SL(1,0,2)
    silent exe '!fcitx5-remote -c'
endfunction 
nmap sc :<c-u>call SearchChineseLine()<cr>
nmap sC :<c-u>call SearchChinese()<cr>


" wiki.vim{{{1
let g:wiki_mappings_global = {
    \ '<plug>(wiki-index)'   : '<tab>ww',
    \ '<plug>(wiki-journal)' : '<tab>wj',
    \ '<plug>(wiki-oen)'     : '<tab>wn',
    \ '<plug>(wiki-reload)'  : '<tab>wx',
    \}
let g:wiki_mappings_local = {
        \ '<plug>(wiki-page-delete)'     : '<tab>wd',
        \ '<plug>(wiki-page-rename)'     : '<tab>wr',
        \ '<plug>(wiki-list-toggle)'     : '<tab><c-s>',
        \ '<plug>(wiki-page-toc)'        : '<tab>wt',
        \ '<plug>(wiki-page-toc-local)'  : '<tab>wT',
        \ '<plug>(wiki-link-open)'       : '<tab><cr>',
        \ 'x_<plug>(wiki-link-open)'     : '<tab><cr>',
        \ '<plug>(wiki-link-open-split)' : '<tab><c-cr>',
        \ '<plug>(wiki-link-return)'     : '<tab><bs>',
        \ '<plug>(wiki-link-next)'       : '<tab><down>',
        \ '<plug>(wiki-link-prev)'       : '<tab><up>',
        \}

" dot file related{{{1
augroup DOTFILE
    autocmd FileType dot nnoremap <localleader>d :<c-u>AsyncRun dot -Tpdf % -o "%:r.pdf"<cr> 
augroup END

" vim-dadbod 相关{{{1
augroup VIMDADBOD
    autocmd!
    autocmd FileType sql  vnoremap <buffer> <localleader>l :DB<cr>
    autocmd FileType sql  nnoremap <buffer> <localleader>l V:DB<cr>
    autocmd FileType sql  nnoremap <buffer> <localleader>L :<c-u>DB < "%"<cr>
    autocmd FileType sql  nmap <buffer> <localleader>E <Plug>(DBUI_EditBindParameters) 
    autocmd FileType sql  nmap <buffer> <localleader>W <Plug>(DBUI_SaveQuery) 
    autocmd FileType dbui nmap <buffer> v <Plug>(DBUI_SelectLineVsplit)  
augroup END

" 注释 {{{1
nnoremap <tab>ff g_a <esc>3a{<esc>
nnoremap <tab>f1 g_a <esc>3a{<esc>a1<esc>
nnoremap <tab>f2 g_a <esc>3a{<esc>a2<esc>
nnoremap <tab>f3 g_a <esc>3a{<esc>a3<esc>

" vim-preview {{{1
augroup VIMPREVIW
    autocmd!
    autocmd FileType qf nnoremap <silent><buffer> p :PreviewQuickfix<cr>
    autocmd FileType qf nnoremap <silent><buffer> P :PreviewClose<cr>
augroup END
noremap [u :PreviewScroll -1<cr>
noremap ]u :PreviewScroll +1<cr>

" fuzzy search {{{1
noremap <silent> <leader>fa :<C-U><C-R>=printf("Leaderf! rg -e %s", expand("<cword>"))<CR><CR>
let g:Lf_ShortcutF = '<leader>fE'
let g:Lf_ShortcutB = '<leader>fb'
noremap <silent> <leader>fc :<C-U><C-R>=printf("Leaderf command %s", "")<CR><CR>
noremap <silent> <leader>fC :<C-U><C-R>=printf("Leaderf colorscheme %s", "")<CR><CR>
noremap <silent> <leader>fd :<C-U><C-R>=printf("Leaderf gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>
noremap <silent> <leader>fe  :FzfFiles<CR>
noremap <silent> <leader>ff :<C-U><C-R>=printf("Leaderf function %s", "")<CR><CR>
noremap <silent> <leader>fF :<C-U><C-R>=printf("Leaderf function --all %s", "")<CR><CR>
noremap <silent> <leader>ft :<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>
noremap <silent> <leader>fT :<C-U><C-R>=printf("Leaderf bufTag --all %s", "")<CR><CR>
noremap <silent> <leader>fm :<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>
noremap <silent> <leader>fn :<C-U><C-R>=printf("Leaderf gtags --next %s", "")<CR><CR>
noremap <silent> <leader>fw  :WikiFzfPages<CR>
noremap <silent> <leader>fl :<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>
noremap <silent> <leader>fo :<C-U><C-R>=printf("Leaderf gtags --recall %s", "")<CR><CR>
noremap <silent> <leader>fp :<C-U><C-R>=printf("Leaderf gtags --previous %s", "")<CR><CR>
noremap <silent> <leader>fr :<C-U><C-R>=printf("Leaderf gtags -r %s --auto-jump", expand("<cword>"))<CR><CR>
noremap <silent> <leader>fs  :FzfSnippets<CR>
noremap <silent> <leader>f: :<C-U><C-R>=printf("Leaderf cmdHistory %s", "")<CR><CR>
noremap <silent> <leader>f/ :<C-U><C-R>=printf("Leaderf searchHistory %s", "")<CR><CR>
noremap <C-B> :<C-U><C-R>=printf("Leaderf rg --current-buffer -e %s ", expand("<cword>"))<CR><CR>
noremap <C-F> :<C-U><C-R>=printf("Leaderf rg -e %s", "")<CR>
xnoremap gf :<C-U><C-R>=printf("Leaderf! rg -F -e %s ", leaderf#Rg#visual())<CR><CR>
noremap go :<C-U>Leaderf! rg --recall<CR>

" 日常编辑相关 {{{1
noremap <silent> <leader>nH :w !pandoc --from=markdown+east_asian_line_breaks -t html - \| xclip -t text/html -sel clip -i<cr>
noremap <silent> <leader>nh :r !xclip -o -t text/html -sel clip \| pandoc -f html -t markdown_strict<cr>

" zen-mod {{{1
function ToggleZenMode()
    if &number == 1
        setlocal nonumber
        setlocal norelativenumber
        setlocal foldcolumn=4
        highlight FoldColumn guifg=bg
        return 0
    endif
    if &number == 0
        highlight FoldColumn guifg=grey
        setlocal foldcolumn=2
        setlocal number
        setlocal relativenumber
        return 0
    endif
endfunction
nnoremap <leader>z :<c-u>call ToggleZenMode()<cr>
nnoremap <leader>Z :Goyo<cr>

" 中英文切换 {{{1
inoremap <nowait> f f
imap fj <C-R>=system("fcitx5-remote -o")<cr>
imap ff <C-R>=system("fcitx5-remote -c")<cr>

" Floaterm {{{1
let g:floaterm_keymap_toggle = '<leader>;'
noremap <leader><leader> :<C-R>=printf("FloatermSend%s", "")<CR> 
noremap <leader>: :<C-U><C-R>=printf("FloatermNew%s", "")<CR> 
command! RUN FloatermNew --name=repl --wintype=normal --position=right
augroup FLOAT
    autocmd!
    autocmd FileType floaterm nnoremap <leader>r :<C-U>FloatermUpdate --wintype=normal --position=right<cr>
    autocmd FileType floaterm nnoremap <leader>l :<C-U>FloatermUpdate --wintype=normal --position=left<cr>
    autocmd FileType floaterm nnoremap <leader>f :<C-U>FloatermUpdate --wintype=floating --position=topright<cr>
augroup END






