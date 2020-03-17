" IMPORTANT: :help Ncm2PopupOpen for more information
" use <TAB> to select the popup menu:
inoremap <silent><expr> <Down> pumvisible() ? "\<C-n>" : "\<down>"
inoremap <expr> <Up> pumvisible() ? "\<C-p>" : "\<up>"

" UltiSnips 相关配置
imap <c-u> <Plug>(ultisnips_expand)
smap <c-u> <Plug>(ultisnips_expand)
xmap <c-u> <Plug>(ultisnips_expand)
let g:UltiSnipsExpandTrigger="<Plug>(ultisnips_expand)"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsUsePythonVersion = 3
let g:UltiSnipsRemoveSelectModeMappings = 0
" Key Map Config
nnoremap <leader>zz :<c-u>call Status()<CR>
nnoremap <leader><leader> :AsyncRun<space>
nnoremap <leader>pwd :silent execute ":lcd" . expand("%:p:h")<cr>
inoremap <tab><space> <Esc>
inoremap <A-space> <Esc>

nnoremap <leader>ev :tabedit $MYVIMRC<cr>
nnoremap <leader>ek :tabedit ~/.config/nvim/KeyMap.vim<cr>
nnoremap <leader>eV :source $MYVIMRC<cr>

" 1. Normal 模式下
nnoremap J <C-w>j
nnoremap K <C-w>k
nnoremap H <C-w>h
nnoremap L <C-w>l
if(has("mac"))
    nnoremap ∆ <Esc>Vj
    nnoremap ˚ <Esc>Vk
    nnoremap ˙ <Esc>v^
    nnoremap ¬ <Esc>v$
    nnoremap ø o<Esc>
    nnoremap  Ø O<Esc>

else
    nnoremap <A-j> <Esc>Vj
    nnoremap <A-k> <Esc>Vk
    nnoremap <A-h> <Esc>v^
    nnoremap <A-l> <Esc>v$
    noremap <A-o> o<Esc>
    noremap <A-O> O<Esc>
endif


nnoremap <leader>w :w!<cr>
nnoremap <leader>q :q<cr>
nnoremap <leader>p "0p

if(has("mac"))
    nnoremap <leader>O :AsyncRun open "%"<cr>
else
    nnoremap <leader>O :AsyncRun xdg-open "%"<cr>
endif
nnoremap <silent> <leader><cr> :noh<cr>

" tab managing
nnoremap <tab>n :tabnew<cr>
nnoremap <tab>x :tabclose<cr>
nnoremap <tab>k :tabnext<cr>
nnoremap <tab>j :tabprevious<cr>

" buffer managing
nnoremap <space>bk :<c-u>bn<cr>
nnoremap <space>bj :<c-u>bp<cr>

" 缩进
inoremap <tab> noh
nnoremap <tab><tab> V>
vnoremap <tab> >gv
nnoremap <s-tab> V<
vnoremap <s-tab> <gv

" Visual mode pressing * or # searches for the current selection
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

vnoremap <silent> <leader>T :TranslateVisual<CR>:b Translation<CR>y$:b #<CR>
nnoremap <silent> <leader>T :TranslateClear<CR>:set nopaste<CR>

" 4. 命令模式下
cnoremap sw w !sudo tee >/dev/null % 

" 5. 终端模式下
if(has('mac'))
    tnoremap <A-space> <C-\><C-n>
else
    tnoremap <A-space> <C-\><C-n>
endif

" Goyo and zenroom2
nnoremap <leader>z :Goyo<cr>

" 行操作
noremap j gj
noremap k gk

" 格式化
noremap <leader>q Vgq
noremap <leader>Q vipJVgq

" 文件操作 lf-vim 相关快捷键
noremap <leader>lr :Lf<cr>
noremap <leader>ls :split +Lf<cr>
noremap <leader>lv :vertical split +Lf<cr>
noremap <leader>lt :LfNewTab<cr>

" Coc.nvim 相关
" Remap for format selected region
xnoremap <leader>F  <Plug>(coc-format-selected)
nnoremap <leader>F  <Plug>(coc-format-selected)
" Using CocList
" Show all diagnostics
nnoremap <silent> <leader>la  :<C-u>CocList --normal diagnostics<cr>
" Manage extensions
nnoremap <silent> <leader>le  :<C-u>CocList --normal extensions<cr>
" Show commands
nnoremap <silent> <leader>lc  :<C-u>CocList --normal commands<cr>
" Show snippet
nnoremap <silent> <leader>lS  :<C-u>CocList snippets<cr>
" Show files 
nnoremap <silent> <leader>lf  :<C-u>CocList --normal --number-select files<cr>
" Resume latest coc list
nnoremap <silent> <leader>lp  :<C-u>CocListResume<CR>

" 处理 Markdown 和 Rmarkdown 文档
autocmd FileType pandoc,md,markdown nnoremap <leader>pp
    \ :Pandoc pdf -H ~/useScript/header.tex<cr>
autocmd FileType pandoc,md,markdown nnoremap <leader>ph
    \ :Pandoc html<cr>
autocmd BufEnter,BufNewFile *.[Rr]md nnoremap <leader>rp
    \ :AsyncRun ~/useScript/rmarkdown.sh %<cr>
autocmd BufEnter,BufNewFile *.[Rr]md nnoremap <leader>rh
    \ :AsyncRun ~/useScript/rmarkdown.sh -o bookdown::html_document2 %<cr>
autocmd FileType pandoc,rmd,rmarkdown,raku,perl6,markdown
    \ inoremap <tab><CR> <Esc>A;<CR>
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

" Bib 相关
if(has("mac"))
    autocmd BufEnter,BufNewFile *.[Rr]md,*.md,*.tex nnoremap <leader>ab
        \ :<c-u>!xsel -ob >> %:r.bib<cr>
else
    autocmd BufEnter,BufNewFile *.[Rr]md,*.md,*.tex nnoremap <leader>ab
        \ :<c-u>!xsel -ob >> "%:p:h/ref.bib"<cr>
    nnoremap <leader>ab :<c-u>!xsel -ob >> %:p:h/ref.bib<cr>
endif

function! RmdClipBoardImage()
    execute "normal! i```{r, out.width = '70%', fig.pos = 'h', fig.show = 'hold'}\n"
    call mdip#MarkdownClipboardImage()
    execute "normal! g_\"iyi)VCknitr::include_graphics('')\<esc>F'\"iPo```\n" 
endfunction
autocmd FileType pandoc,markdown,md nnoremap <silent> <localleader>pi
    \ :<c-u>call mdip#MarkdownClipboardImage()<CR>
autocmd FileType rmd,rmarkdown,rmd.rmarkdown nnoremap <silent> <localleader>pi
    \ :<c-u>call RmdClipBoardImage()<CR>
autocmd FileType pandoc,md,markdown,Rmd,rmd,rmarkdown nmap <localleader>ic ysiW`

" Easymotion Related
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



