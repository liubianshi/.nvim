" Key Map Config
let mapleader = " "
let maplocalleader = ';'
let g:ctrlp_map = '<c-f>'
inoremap ;<space> <Esc>
inoremap <Down> <Esc>
inoremap ;; ;
inoremap <Esc> <nop>

nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>ek :vsplit ~/.config/nvim/KeyMap.vim<cr>
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
nnoremap <leader>ev :vsplit $MYVIMRC<cr>


nnoremap <leader>w :w!<cr>
if(has("mac"))
    nnoremap <leader>O :! open "%"<cr>
else
    nnoremap <leader>O :<silent>! xdg-open "%" &<cr>
endif
nnoremap <silent> <leader><cr> :noh<cr>


" tab managing
nnoremap <leader>tt :tabnew<cr>
nnoremap <leader>td :tabclose<cr>
nnoremap <leader>tn :tabnext<cr>
nnoremap <leader>tp :tabprevious<cr>
nnoremap <leader>tN :tablast<cr>
nnoremap <leader>tP :tabfirst<cr>
nnoremap <leader>tl :tabs<cr>

" buffer managing
nnoremap <leader>bn :bn<cr>
nnoremap <leader>bp :bp<cr>
nnoremap <leader>bl :ls!


" 缩进
nnoremap <tab> V>
nnoremap <s-tab> V<
vnoremap <tab> >gv
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
tnoremap ;<space> <C-\><C-n>

" Goyo and zenroom2
nnoremap <leader>z :Goyo<cr>

" 行操作
noremap j gj
noremap k gk
noremap <Down> gj
noremap <Up> gk

" 格式化
noremap <leader>q Vgq
noremap <leader>Q vipJVgq

" 文件操作 lf-vim 相关快捷键
noremap <leader>nt :NERDTreeToggle<cr>
noremap <leader>rr :Lf<cr>
noremap <leader>rs :split +Lf<cr>
noremap <leader>rv :vertical split +Lf<cr>
noremap <leader>rt :LfNewTab<cr>

" Coc.nvim 相关
" Remap for format selected region
xnoremap <leader>F  <Plug>(coc-format-selected)
nnoremap <leader>F  <Plug>(coc-format-selected)
" Using CocList
" Show all diagnostics
nnoremap <silent> <space>la  :<C-u>CocList --normal diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>le  :<C-u>CocList --normal extensions<cr>
" Show commands
nnoremap <silent> <space>lc  :<C-u>CocList --normal commands<cr>
" Show snippet
nnoremap <silent> <space>ls  :<C-u>CocList snippets<cr>
" Show files 
nnoremap <silent> <space>lf  :<C-u>CocList --normal --number-select files<cr>
" Resume latest coc list
nnoremap <silent> <space>lp  :<C-u>CocListResume<CR>

" 处理 Markdown 和 Rmarkdown 文档
autocmd FileType pandoc,md,markdown nnoremap <leader>pp
    \ :Pandoc pdf -H ~/useScript/header.tex<cr>
autocmd BufEnter,BufNewFile *.[Rr]md nnoremap <leader>pp
    \ :RMarkdown pdf<cr>
autocmd FileType pandoc,md,markdown nnoremap <leader>ph
    \ :Pandoc html<cr>

if(has("mac"))
    autocmd BufEnter,BufNewFile *.[Rr]md,*.md,*.tex nnoremap <leader>po
        \ :! xdg-open "%:r.pdf"<cr> 
else
    autocmd BufEnter,BufNewFile *.[Rr]md,*.md,*.tex nnoremap <leader>po
        \ :! open "%:r.pdf"<cr> 
endif

autocmd FileType pandoc,md,markdown,rmarkdown inoremap ;j
    \ $$<esc>i
autocmd FileType pandoc,md,markdown,rmarkdown inoremap ;k
    \ ``<esc>i
" Bib 相关
if(has("mac"))
    autocmd BufEnter,BufNewFile *.[Rr]md,*.md,*.tex nnoremap <leader>ab
        \ :<c-u>!xsel -ob >> %:r.bib<cr>
else
    autocmd BufEnter,BufNewFile *.[Rr]md,*.md,*.tex nnoremap <leader>ab
        \ :<c-u>!xsel -ob >> "%:p:h/ref.bib"<cr>
    nnoremap <leader>ab :<c-u>!xsel -ob >> %:p:h/ref.bib<cr>
endif

autocmd FileType rmd,rmarkdown,pandoc,rmd.rmarkdown nnoremap <silent> <leader>pi
    \ :<c-u>call mdip#MarkdownClipboardImage()<CR>

" Easymotion Related
nmap ss <Plug>(easymotion-overwin-f2)
nmap sS <Plug>(easymotion-overwin-line)
nmap sl <Plug>(easymotion-sl)
nmap sf <Plug>(easymotion-lineforward)
nmap sb <Plug>(easymotion-linebackward)
nmap sj <plug>(easymotion-j)
nmap sJ <plug>(easymotion-eol-j)
nmap sk <plug>(easymotion-k)
nmap sK <plug>(easymotion-eol-K)
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
