" function: add sybol at the end of current line {{{1 
function! s:AddDash(symbol)
    substitute/\s*$//g
    if &l:textwidth == 0
        let w = 79
    else
        let w = &l:textwidth
    endif
    if virtcol('$') >= w
        return 0
    endif
    let l = (w - virtcol('$')) / strlen(a:symbol)
    let back = @"
    let @" = a:symbol
    exec "normal! A \<esc>" . l . '""p'
    let @" = back
endfunction

" 基础命令{{{1
"nnoremap <leader><leader> :<C-U><C-R>=printf("AsyncRun %s", "")<CR> 
nnoremap <silent> <leader>a :<c-u>call <sid>AddDash("-")<cr>
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
nnoremap <leader>eV :source $MYVIMRC<cr>
nnoremap <silent> <leader><cr> :noh<cr>
nnoremap <silent> <leader>B :call Status()<cr>

" 管理 quickfix {{{1
nnoremap <leader>q :call QuickfixToggle()<cr>

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
let g:UltiSnipsExpandTrigger		    = "<c-u>"
let g:UltiSnipsJumpForwardTrigger	    = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger	    = "<c-k>"
let g:UltiSnipsRemoveSelectModeMappings = 0
inoremap <silent><expr> <Down> pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <silent><expr> <Up>   pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <silent><expr> <Tab>  pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Navigation {{{1
noremap j gj
noremap k gk
nnoremap J <C-w>j
nnoremap K <C-w>k
nnoremap H <C-w>h
nnoremap L <C-w>l
nnoremap <A-j> <Esc>Vj
nnoremap <A-k> <Esc>Vk
noremap  <A-o> o<Esc>
noremap  <A-O> O<Esc>
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
vnoremap <tab>      >gv
nnoremap <s-tab>    V<
vnoremap <s-tab>    <gv
nnoremap <tab>p     "0p
nnoremap <tab>P     "*p

" Visual mode pressing * or # searches for the current selection{{{1
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>:

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

nmap sc :<c-u>call <sid>SearchChinese_forward()<cr>
nmap sC :<c-u>call <sid>SearchChinese_backword()<cr>
nmap sL :<c-u>call <sid>SearchChineseLine()<cr>
function! s:SearchChinese_forward() 
     silent execute '!fcitx5-remote -o'
     call EasyMotion#S(2,0,0)
     silent exe '!fcitx5-remote -c'
 endfunction 
function! s:SearchChinese_backword() 
     silent execute '!fcitx5-remote -o'
     call EasyMotion#S(2,0,1)
     silent exe '!fcitx5-remote -c'
 endfunction 
function! s:SearchChineseLine() 
     silent execute '!fcitx5-remote -o'
     call EasyMotion#SL(2,0,2)
     silent exe '!fcitx5-remote -c'
 endfunction 

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

" 注释 {{{1
nnoremap <tab>ff g_a <esc>3a{<esc>
nnoremap <tab>f1 g_a <esc>3a{<esc>a1<esc>
nnoremap <tab>f2 g_a <esc>3a{<esc>a2<esc>
nnoremap <tab>f3 g_a <esc>3a{<esc>a3<esc>


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

" zen-mod {{{1
nnoremap <leader>z :<c-u>call ToggleZenMode()<cr>
nnoremap <leader>Z :Goyo<cr>

" Floaterm {{{1
let g:floaterm_keymap_toggle = '<leader>;'
noremap <leader><leader> :<C-R>=printf("FloatermSend%s", "")<CR> 
noremap <leader>: :<C-U><C-R>=printf("FloatermNew%s", "")<CR> 
command! RUN FloatermNew --name=repl --wintype=normal --position=right

" 快捷标点符号输入 {{{1
" 成对括号
inoremap ;) <C-v>uFF08 <C-v>uFF09<C-o>F <c-o>x
" 成对单引号
inoremap ;] <C-v>u2018 <C-v>u2019<C-o>F <c-o>x
" 成对双引号
inoremap ;} <C-v>u201C <C-v>u201D<C-o>F <c-o>x
" 逗号
inoremap ;, <C-v>uFF0C
" 句号
inoremap ;. <C-v>u3002
" 顿号
inoremap ;\ <C-v>u3001
" 问号
inoremap ;? <C-v>uFF1F
" 冒号
inoremap ;: <C-v>uFF1A
" 破折号
inoremap ;- <C-v>u2014
" 省略号
inoremap ;^ <C-v>u2026
" 左书名号
inoremap ;< <C-v>u300A
" 右书名号
inoremap ;> <C-v>u300B<BS>

" fzf-bibtex {{{1
" bring up fzf to insert citation to selected items.
nnoremap <silent> <tab>c :call fzf#run({
                        \ 'source': <sid>Bibtex_ls(),
                        \ 'sink*': function('<sid>bibtex_cite_sink'),
                        \ 'up': '40%',
                        \ 'options': '--ansi --layout=reverse-list --multi --prompt "Cite> "'})<CR>
" bring up fzf to insert pretty markdown versions of selected items.
nnoremap <silent> <tab>m :call fzf#run({
                        \ 'source': <sid>Bibtex_ls(),
                        \ 'sink*': function('<sid>bibtex_markdown_sink'),
                        \ 'up': '40%',
                        \ 'options': '--ansi --layout=reverse-list --multi --prompt "Markdown> "'})<CR>
inoremap <silent> @@ <c-g>u<c-o>:call fzf#run({
                        \ 'source': <sid>Bibtex_ls(),
                        \ 'sink*': function('<sid>bibtex_cite_sink_insert'),
                        \ 'up': '40%',
                        \ 'options': '--ansi --layout=reverse-list --multi --prompt "Cite> "'})<CR>

function! s:Bibtex_ls()
  let bibfiles = (
      \ globpath('~/Documents', '*ref.bib', v:true, v:true) +
      \ globpath('.', '*.bib', v:true, v:true) +
      \ globpath('..', '*.bib', v:true, v:true) +
      \ globpath('*/', '*.bib', v:true, v:true)
      \ )
  let bibfiles = join(bibfiles, ' ')
  let source_cmd = 'bibtex-ls '.bibfiles
  return source_cmd
endfunction
function! s:bibtex_cite_sink(lines)
    let r=system("bibtex-cite ", a:lines)
    execute ':normal! a' . r
endfunction
function! s:bibtex_markdown_sink(lines)
    let r=system("bibtex-markdown ", a:lines)
    execute ':normal! a' . r
endfunction
function! s:bibtex_cite_sink_insert(lines)
    let r=system("bibtex-cite -prefix='@' -postfix='' -separator='; @'", a:lines)
    "let r=system("bibtex-cite ", a:lines)
    execute ':normal! a' . r
    call feedkeys('a', 'n')
endfunction


" fzf-map {{{1
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" diff 相关 {{{1
map <silent> <leader>d1 :diffget 1<CR> :diffupdate<CR>
map <silent> <leader>d2 :diffget 2<CR> :diffupdate<CR>
map <silent> <leader>d3 :diffget 3<CR> :diffupdate<CR>
map <silent> <leader>d4 :diffget 4<CR> :diffupdate<CR>

