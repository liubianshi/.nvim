" 基础命令{{{
nnoremap <leader><leader> :<C-U><C-R>=printf("AsyncRun %s", "")<CR> 
nnoremap <silent> <leader>p :<c-u>execute "cd" expand("%:p:h")<cr>
nnoremap <silent> <leader>C :<c-u> call ChangeCompleteEngine()<cr>
nnoremap <silent> <leader>w :<c-u>:w<cr>
nnoremap <silent> <leader>x :<c-u>:q<cr>
nnoremap <leader>O :AsyncRun xdg-open "%"<cr>
inoremap <A-space> <Esc>
tnoremap <A-space> <C-\><C-n>
if(has("mac"))
    nnoremap <leader>O :AsyncRun open "%"<cr>
endif
nnoremap <leader>ev :tabedit $MYVIMRC<cr>
nnoremap <leader>ek :tabedit ~/.config/nvim/KeyMap.vim<cr>
nnoremap <leader>er :tabedit ~/.config/nvim/rfile.vim<cr>
nnoremap <leader>eV :source $MYVIMRC<cr>
nnoremap <silent> <leader><cr> :noh<cr>
"}}}
" 管理 quickfix {{{
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
"}}}
" Goyo and zenroom2{{{
nnoremap <leader>z :Goyo<cr>
"}}}
" buffer managing{{{
nnoremap <silent> <leader>bk :<c-u>bn<cr>
nnoremap <silent> <leader>bj :<c-u>bp<cr>
nnoremap <silent> <leader>bq :q<cr>
nnoremap <silent> <leader>bQ :q!<cr>
nnoremap <silent> <leader>bw :w<cr>
nnoremap <silent> <leader>bW :w!<cr>
"}}}
" 翻译{{{
vnoremap <silent> <leader>T :TranslateVisual<CR>:b Translation<CR>y$:b #<CR>
nnoremap <silent> <leader>T :TranslateClear<CR>:set nopaste<CR>
"}}}
" 文件操作 lf-vim 相关快捷键{{{
noremap <leader>lr :Lf<cr>
noremap <leader>ls :split +Lf<cr>
noremap <leader>lv :vertical split +Lf<cr>
noremap <leader>lt :LfNewTab<cr>
"}}}
" UltiSnips 相关 {{{
inoremap <silent><expr> <Down> pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <silent><expr> <Up>   pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <silent><expr> <tab>  pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <s-tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

let g:UltiSnipsExpandTrigger		= "<c-u>"
let g:UltiSnipsJumpForwardTrigger	= "<c-j>"
let g:UltiSnipsJumpBackwardTrigger	= "<c-k>"
let g:UltiSnipsRemoveSelectModeMappings = 0
"}}}
" Navigation {{{
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
"}}}
" tab managing{{{
nnoremap <tab>o :only<cr>
nnoremap <tab>n :tabnew<cr>
nnoremap <tab>x :tabclose<cr>
nnoremap <tab>k :tabnext<cr>
nnoremap <tab>j :tabprevious<cr>
"}}}

" 缩进{{{
nnoremap <tab><tab> V>
vnoremap <tab> >gv
nnoremap <s-tab> V<
vnoremap <s-tab> <gv
nnoremap <tab>p "0p
nnoremap <tab>P "*p
"}}}
" Visual mode pressing * or # searches for the current selection{{{
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
"}}}
" 处理 Markdown 和 Rmarkdown 文档{{{
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
function! RmdClipBoardImage()
    execute "normal! i```{r, out.width = '70%', fig.pos = 'h', fig.show = 'hold'}\n"
    call mdip#MarkdownClipboardImage()
    execute "normal! \<esc>g_\"iyi)VCknitr::include_graphics(\"\")\<esc>F\"\"iPo```\n" 
endfunction
autocmd FileType pandoc,markdown,md nnoremap <silent> <localleader>pi
    \ :<c-u>call mdip#MarkdownClipboardImage()<CR>
autocmd FileType rmd,rmarkdown,rmd.rmarkdown nnoremap <silent> <localleader>pi
    \ :<c-u>call RmdClipBoardImage()<CR>
autocmd FileType pandoc,md,markdown,Rmd,rmd,rmarkdown nmap <localleader>ic ysiW`
"}}}
" Bib 相关{{{
autocmd BufEnter,BufNewFile *.[Rr]md,*.md,*.tex
    \ nnoremap <leader>ab :<c-u>AsyncRun 
    \ xsel -ob >> %:p:h/ref.bib; xsel -ob \| perl -ne 'print "\@$1\n" if ($_ =~ /^\@\w+\{([^,]+)\,/)' >> ~/.config/nvim/paper.dict<cr>
"}}}
" Easymotion Related{{{
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
    silent execute '!fcitx-remote -o'
    call EasyMotion#S(2,0,2)
    silent exe '!fcitx-remote -c'
endfunction 
function! SearchChineseLine() 
    silent execute '!fcitx-remote -o'
    call EasyMotion#SL(1,0,2)
    silent exe '!fcitx-remote -c'
endfunction 
nmap sc :<c-u>call SearchChineseLine()<cr>
nmap sC :<c-u>call SearchChinese()<cr>
"}}}
" wiki.vim{{{
let g:wiki_mappings_global = {
    \ '<plug>(wiki-index)'   : '<tab>ww',
    \ '<plug>(wiki-oen)'     : '<tab>wn',
    \ '<plug>(wiki-reload)'  : '<tab>wx',
    \}
let g:wiki_mappings_local = {
        \ '<plug>(wiki-page-delete)'     : '<tab>wd',
        \ '<plug>(wiki-page-rename)'     : '<tab>wr',
        \ '<plug>(wiki-list-toggle)'     : '<tab><c-s>',
        \ 'i_<plug>(wiki-list-toggle)'   : '<tab><c-s>',
        \ '<plug>(wiki-page-toc)'        : '<tab>wt',
        \ '<plug>(wiki-page-toc-local)'  : '<tab>wT',
        \ '<plug>(wiki-link-open)'       : '<tab><cr>',
        \ 'x_<plug>(wiki-link-open)'     : '<tab><cr>',
        \ '<plug>(wiki-link-open-split)' : '<tab><c-cr>',
        \ '<plug>(wiki-link-return)'     : '<tab><bs>',
        \ '<plug>(wiki-link-next)'       : '<tab><down>',
        \ '<plug>(wiki-link-prev)'       : '<tab><up>',
        \}
"}}}
" dot file related{{{
autocmd FileType dot nnoremap <localleader>d :<c-u>AsyncRun dot -Tpdf % -o "%:r.pdf"<cr> 
"}}}
" vim-dadbod 相关{{{
autocmd FileType sql  vnoremap <buffer> <localleader>l :DB<cr>
autocmd FileType sql  nnoremap <buffer> <localleader>l V:DB<cr>
autocmd FileType sql  nnoremap <buffer> <localleader>L :<c-u>DB < "%"<cr>
autocmd FileType sql  nmap <buffer> <localleader>E <Plug>(DBUI_EditBindParameters) 
autocmd FileType sql  nmap <buffer> <localleader>W <Plug>(DBUI_SaveQuery) 
autocmd FileType dbui nmap <buffer> v <Plug>(DBUI_SelectLineVsplit)  
"}}}
"   注释 {{{ 
nnoremap <tab>ff g_a <esc>3a{<esc>
nnoremap <tab>f1 g_a <esc>3a{<esc>a1<esc>
nnoremap <tab>f2 g_a <esc>3a{<esc>a2<esc>
nnoremap <tab>f3 g_a <esc>3a{<esc>a3<esc>
"}}}
" vim-preview {{{
autocmd FileType qf nnoremap <silent><buffer> p :PreviewQuickfix<cr>
autocmd FileType qf nnoremap <silent><buffer> P :PreviewClose<cr>
noremap [u :PreviewScroll -1<cr>
noremap ]u :PreviewScroll +1<cr>
"}}}
" fuzzy search {{{
let g:Lf_ShortcutF = '<leader>fF'
noremap <silent> <leader>fa :<C-U><C-R>=printf("Leaderf! rg -e %s", expand("<cword>"))<CR><CR>
let g:Lf_ShortcutB = '<leader>fb'
noremap <silent> <leader>fc :<C-U><C-R>=printf("Leaderf command %s", "")<CR><CR>
noremap <silent> <leader>fC :<C-U><C-R>=printf("Leaderf colorscheme %s", "")<CR><CR>
noremap <silent> <leader>fd :<C-U><C-R>=printf("Leaderf gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>
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
"}}}
" 日常编辑相关
noremap <silent> <leader>nh :w !pandoc --from=markdown+east_asian_line_breaks -t html - \| xclip -t text/html -sel clip -i<cr>

"
" gtags 相关



