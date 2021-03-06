" function: add symbol at the end of current line {{{1 
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

function! s:lf_task_source(...)
	let rows = asynctasks#source(&columns * 48 / 100)
	let source = []
	for row in rows
		let name = row[0]
		let source += [name . '  ' . row[1] . '  : ' . row[2]]
	endfor
	return source
endfunction

function! s:lf_task_accept(line, arg)
	let pos = stridx(a:line, '<')
	if pos < 0
		return
	endif
	let name = strpart(a:line, 0, pos)
	let name = substitute(name, '^\s*\(.\{-}\)\s*$', '\1', '')
	if name != ''
		exec "AsyncTask " . name
	endif
endfunction

function! s:lf_task_digest(line, mode)
	let pos = stridx(a:line, '<')
	if pos < 0
		return [a:line, 0]
	endif
	let name = strpart(a:line, 0, pos)
	return [name, 0]
endfunction

function! s:lf_win_init(...)
	setlocal nonumber
	setlocal nowrap
endfunction

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
    execute ':normal! i' . r
    call feedkeys('a', 'n')
endfunction

" Terminal {{{1 
tnoremap <A-space> <C-\><C-n>
nnoremap <leader>:n :<c-u>FloatermNew<cr>
nnoremap <leader>:R :<c-u>FloatermNew raku<cr>
nnoremap <leader>:r :<c-u>FloatermNew radian<cr>
nnoremap <leader>:p :<c-u>FloatermNew iPython<cr>
nnoremap <leader>:l :<c-u>FloatermSend<cr>
vnoremap <leader>:l :<c-u>FloatermSend<cr>

" 文件操作 {{{1
nnoremap <silent> <leader>.  :call fzf#run(fzf#wrap({'source': 'fd -H -t f', 'dir': expand("%:p:h"), 'options': '--ansi --no-sort --tac --tiebreak=index --multi', }))<cr>
nnoremap <silent> <leader>ff  :FzfFiles<CR>
nnoremap <silent> <leader>fr  :<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>
nnoremap <silent> <leader>fs  :write<CR>
nnoremap <silent> <leader>fS  :write!<CR>
nnoremap <silent> <leader>fo  :Lf<cr>
nnoremap <silent> <leader>fls :split +Lf<cr>
nnoremap <silent> <leader>flv :vertical split +Lf<cr>
nnoremap <silent> <leader>flt :LfNewTab<cr>
nnoremap <silent> <leader>ft  :NERDTreeToggle<cr>
nnoremap <silent> <leader>fn  :new<CR>
nnoremap <silent> <leader>fw  :WikiFzfPages<CR>
" Fasd {{{2
function! s:fasd_update() abort
  if empty(&buftype) || &filetype ==# 'dirvish'
    call jobstart(['fasd', '-A', expand('%:p')])
  endif
endfunction
augroup fasd
  autocmd!
  autocmd BufWinEnter,BufFilePost * call s:fasd_update()
augroup END
nnoremap <silent> <Leader>fz :call fzf#run(fzf#wrap({'source': 'fasd -al', 'options': '--no-sort --tac --tiebreak=index'}))<CR>

" Buffer {{{1
nnoremap <silent> <leader>bb :LeaderfBuffer<cr>
nnoremap <silent> <leader>bB :LeaderfBufferAll<cr>
nnoremap <silent> <leader>bc :<c-u>call Lilydjwg_cleanbufs()<cr>
nnoremap <silent> <leader>bd :<c-u>Bclose<cr>
nnoremap <silent> <leader>bp :<c-u>bp<cr>
nnoremap <silent> <leader>bn :<c-u>bn<cr>
nnoremap <silent> <leader>bq :q<cr>
nnoremap <silent> <leader>bQ :q!<cr>
nnoremap <silent> <leader>bw :w<cr>
nnoremap <silent> <leader>bW :w!<cr>

" 管理 quickfix {{{1
nnoremap <leader>qq :call QuickfixToggle()<cr>

" window manager {{{1
nnoremap <silent> <leader>wo :<c-u>only<cr>
nnoremap <silent> <leader>ww <c-w>w
nnoremap <silent> <leader>wW <c-w>W
nnoremap <silent> <leader>w= <c-w>=
nnoremap <silent> <leader>w- <c-w>-
nnoremap <silent> <leader>w_ <c-w>_
nnoremap <silent> <leader>w< <c-w><
nnoremap <silent> <leader>w> <c-w><
nnoremap <silent> <leader>w<bar> <c-w><bar>
nnoremap <silent> <leader>w+ <c-w>+
nnoremap <silent> <leader>wj <c-w>j
nnoremap <silent> <leader>wk <c-w>k
nnoremap <silent> <leader>wh <c-w>h
nnoremap <silent> <leader>wl <c-w>l
nnoremap <silent> <leader>wJ <c-w>J
nnoremap <silent> <leader>wK <c-w>K
nnoremap <silent> <leader>wH <c-w>H
nnoremap <silent> <leader>wL <c-w>L
nnoremap <silent> <leader>ws <c-w>s
nnoremap <silent> <leader>wv <c-w>v

" tab managing{{{1
nnoremap <silent> <leader>tt :tabnew<cr>
nnoremap <silent> <leader>tx :tabclose<cr>
nnoremap <silent> <leader>tn :tabnext<cr>
nnoremap <silent> <leader>tp :tabprevious<cr>

" run {{{1 
let g:floaterm_keymap_toggle = '<leader><space>'
noremap <silent> <leader><enter> :noh<cr>
let g:Lf_Extensions = get(g:, 'Lf_Extensions', {})
let g:Lf_Extensions.task = {
			\ 'source': string(function('s:lf_task_source'))[10:-3],
			\ 'accept': string(function('s:lf_task_accept'))[10:-3],
			\ 'get_digest': string(function('s:lf_task_digest'))[10:-3],
			\ 'highlights_def': {
			\     'Lf_hl_funcScope': '^\S\+',
			\     'Lf_hl_funcDirname': '^\S\+\s*\zs<.*>\ze\s*:',
			\ },
		\ }
nnoremap <silent> <leader>o: :<C-U>FloatermNew 
nnoremap <silent> <leader>ob :call Status()<cr>
nnoremap <silent> <leader>od :source $MYVIMRC<cr>
nnoremap <silent> <leader>oh :noh<cr>
nnoremap <silent> <leader>ol :<C-R>=printf("FloatermSend%s", "")<CR><CR>
nnoremap <silent> <leader>on :FloatermNew nnn<CR>
nnoremap <silent> <leader>oo :AsyncRun xdg-open "%"<cr>
nnoremap <silent> <leader>op :<c-u>execute "cd" expand("%:p:h")<cr>
nnoremap <silent> <leader>or :<C-U>AsyncRun 
nnoremap <silent> <leader>ot :<C-U>Leaderf! task --nowrap<cr>
nnoremap <silent> <leader>oz :<c-u>call ToggleZenMode()<cr>
nnoremap <silent> <leader>oZ :Goyo<cr>
command! RUN FloatermNew --name=repl --wintype=normal --position=right

" 翻译 {{{1
vnoremap <silent> <leader>Tc "*y:AsyncRun xclip -o \| tr "\n" " " \| trans -b --no-ansi \| tee >(xclip -i -sel clip)<CR>
nnoremap <silent> <leader>Tc vip:AsyncRun tr "\n" " " \| trans -b --no-ansi \| tee >(xclip -i -sel clip)<CR>
vnoremap <silent> <leader>Te "*y:AsyncRun xclip -o \| tr "\n" " " \| trans -b --no-ansi zh:en \| tee >(xclip -i -sel clip)<CR>
nnoremap <silent> <leader>Te vip:AsyncRun tr "\n" " " \| trans -b --no-ansi zh:en \| tee >(xclip -i -sel clip)<CR>

" Edit Specific file {{{1
nnoremap <leader>ev :tabedit $MYVIMRC<cr>
nnoremap <leader>ek :tabedit ~/.config/nvim/KeyMap.vim<cr>

" search {{{1
vnoremap <silent> S "0y:<C-U>AsyncRun sr google <C-R>0<CR>
nnoremap <silent> S :<C-U><C-R>=printf("AsyncRun sr", expand("<cword>"))<CR><CR>
noremap <silent> <leader>sc :<C-U><C-R>=printf("Leaderf command %s", "")<CR><CR>
noremap <silent> <leader>sC :<C-U><C-R>=printf("Leaderf colorscheme %s", "")<CR><CR>
noremap <silent> <leader>st :<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>
noremap <silent> <leader>sT :<C-U><C-R>=printf("Leaderf bufTag --all %s", "")<CR><CR>
noremap <silent> <leader>sl :<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>
noremap <silent> <leader>ss :<C-U>!sr 
noremap <silent> <leader>s: :<C-U><C-R>=printf("Leaderf cmdHistory %s", "")<CR><CR>
noremap <silent> <leader>s/ :<C-U><C-R>=printf("Leaderf searchHistory %s", "")<CR><CR>
noremap <silent> <leader>sg :<C-U><C-R>=printf("Leaderf gtags --all %s", "")<CR><CR>
noremap <silent> <leader>sr :<C-U>Leaderf rg --current-buffer -e 
noremap <silent> <leader>sR :<C-U>Leaderf rg -e 
nmap    <silent> <leader>sm <plug>(fzf-maps-n)
xmap    <silent> <leader>sm <plug>(fzf-maps-x)
omap    <silent> <leader>sm <plug>(fzf-maps-o)
noremap <C-B> :<C-U><C-R>=printf("Leaderf rg --current-buffer -e %s ", expand("<cword>"))<CR><CR>
noremap <C-F> :<C-U><C-R>=printf("Leaderf rg -e %s", expand("<cword>"))<CR><CR>

" diff 相关 {{{1
map <silent> <leader>d1 :diffget 1<CR> :diffupdate<CR>
map <silent> <leader>d2 :diffget 2<CR> :diffupdate<CR>
map <silent> <leader>d3 :diffget 3<CR> :diffupdate<CR>
map <silent> <leader>d4 :diffget 4<CR> :diffupdate<CR>

" add content {{{1 
nnoremap <silent> <leader>a- :<c-u>call <sid>AddDash("-")<cr>
nnoremap <silent> <leader>a= :<c-u>call <sid>AddDash("=")<cr>
nnoremap <silent> <leader>a. :<c-u>call <sid>AddDash(".")<cr>
" bring up fzf to insert citation to selected items.
nnoremap <silent> <leader>ac :call fzf#run({
                        \ 'source': <sid>Bibtex_ls(),
                        \ 'sink*': function('<sid>bibtex_cite_sink'),
                        \ 'up': '40%',
                        \ 'options': '--ansi --layout=reverse-list --multi --prompt "Cite> "'})<CR>
" bring up fzf to insert pretty markdown versions of selected items.
nnoremap <silent> <leader>am :call fzf#run({
                        \ 'source': <sid>Bibtex_ls(),
                        \ 'sink*': function('<sid>bibtex_markdown_sink'),
                        \ 'up': '40%',
                        \ 'options': '--ansi --layout=reverse-list --multi --prompt "Markdown> "'})<CR>

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
nnoremap ]b :<c-u>bnext<cr>
nnoremap [b :<c-u>bprevious<cr>
nnoremap ]B :<c-u>blast<cr>
nnoremap [B :<c-u>bfirst<cr>
nnoremap ]t :<c-u>tabnext<cr>
nnoremap [t :<c-u>tabprevious<cr>
nnoremap ]T :<c-u>tablast<cr>
nnoremap [T :<c-u>tabfirst<cr>


" Visual mode pressing * or # searches for the current selection{{{1
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>:

" Easymotion and vim-sneak Related{{{1
nnoremap <silent> f :<C-U>call sneak#wrap('',           1, 0, 1, 1)<CR>
nnoremap <silent> F :<C-U>call sneak#wrap('',           1, 1, 1, 1)<CR>
xnoremap <silent> f :<C-U>call sneak#wrap(visualmode(), 1, 0, 1, 1)<CR>
xnoremap <silent> F :<C-U>call sneak#wrap(visualmode(), 1, 1, 1, 1)<CR>
onoremap <silent> f :<C-U>call sneak#wrap(v:operator,   1, 0, 1, 1)<CR>
onoremap <silent> F :<C-U>call sneak#wrap(v:operator,   1, 1, 1, 1)<CR>
nnoremap <silent> t :<C-U>call sneak#wrap('',           1, 0, 0, 1)<CR>
nnoremap <silent> T :<C-U>call sneak#wrap('',           1, 1, 0, 1)<CR>
xnoremap <silent> t :<C-U>call sneak#wrap(visualmode(), 1, 0, 0, 1)<CR>
xnoremap <silent> T :<C-U>call sneak#wrap(visualmode(), 1, 1, 0, 1)<CR>
onoremap <silent> t :<C-U>call sneak#wrap(v:operator,   1, 0, 0, 1)<CR>
onoremap <silent> T :<C-U>call sneak#wrap(v:operator,   1, 1, 0, 1)<CR>
nmap ss <Plug>Sneak_s
nmap sS <Plug>Sneak_S
nmap sl <Plug>(easymotion-sl)
nmap sj <plug>(easymotion-j)
nmap sJ <plug>(easymotion-eol-j)
nmap sk <plug>(easymotion-k)
nmap sK <plug>(easymotion-eol-k)
nmap sn <Plug>(easymotion-n)
nmap sN <Plug>(easymotion-N)
nmap sw <Plug>(easymotion-w)
nmap sW <Plug>(easymotion-W)
nmap sb <Plug>(easymotion-b)
nmap sB <Plug>(easymotion-B)
nmap se <Plug>(easymotion-e)
nmap sE <Plug>(easymotion-E)
nnoremap <silent> sc :<c-u>call <sid>SearchChinese_forward()<cr>
nnoremap <silent> sC :<c-u>call <sid>SearchChinese_backword()<cr>
xnoremap <silent> sc :<c-u>call <sid>SearchChinese_forward()<cr>
xnoremap <silent> sC :<c-u>call <sid>SearchChinese_backword()<cr>
function! s:SearchChinese_forward() 
     silent execute '!fcitx5-remote -o'
     call sneak#wrap('', 2, 0, 1, 1)
     silent exe '!fcitx5-remote -c'
 endfunction 
function! s:SearchChinese_backword() 
     silent execute '!fcitx5-remote -o'
     call sneak#wrap('', 2, 1, 1, 1)
     silent exe '!fcitx5-remote -c'
 endfunction 

" wiki.vim{{{1
let g:wiki_mappings_global = {
        \ '<plug>(wiki-index)'   : '<leader>ew',
        \ '<plug>(wiki-journal)' : '<leader>ej',
        \ '<plug>(wiki-open)'    : '<leader>en',
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

" Fold: 折叠 {{{1
nnoremap <silent> <leader>zf g_a <esc>3a{<esc>
nnoremap <silent> <leader>z1 g_a <esc>3a{<esc>a1<esc>
nnoremap <silent> <leader>z2 g_a <esc>3a{<esc>a2<esc>
nnoremap <silent> <leader>z3 g_a <esc>3a{<esc>a3<esc>
nnoremap <silent> <leader>zu <Plug>(FastFoldUpdate)
xnoremap iz :<c-u>FastFoldUpdate<cr><esc>:<c-u>normal! ]zv[z<cr>
xnoremap az :<c-u>FastFoldUpdate<cr><esc>:<c-u>normal! ]zV[z<cr>

" Debug {{{1
nnoremap <leader>xx <cmd>TroubleToggle<cr>
nnoremap <leader>xw <cmd>TroubleToggle lsp_workspace_diagnostics<cr>
nnoremap <leader>xd <cmd>TroubleToggle lsp_document_diagnostics<cr>
nnoremap <leader>xq <cmd>TroubleToggle quickfix<cr>
nnoremap <leader>xl <cmd>TroubleToggle loclist<cr>
nnoremap gR <cmd>TroubleToggle lsp_references<cr>

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

" 左括号和右括号
inoremap ;e <C-v>uFF08
inoremap ;r <C-v>uFF09
" 左书名号和右书名号
inoremap ;g <C-v>u300A
inoremap ;b <C-v>u300B<BS>
" 左双引号和右双引号
inoremap ;z <C-v>u201C
inoremap ;c <C-v>u201D
" 感叹号
inoremap ;a <C-v>ff01
inoremap ;w <C-v>ff1f
" 其他半角符号
inoremap ;q `
inoremap ;h #
inoremap ;j _
inoremap ;k *
inoremap ;l /
inoremap ;u $

inoremap <silent> ;@ <c-g>u<c-o>:call fzf#run({
                        \ 'source': <sid>Bibtex_ls(),
                        \ 'sink*': function('<sid>bibtex_cite_sink_insert'),
                        \ 'up': '40%',
                        \ 'options': '--ansi --layout=reverse-list --multi --prompt "Cite> "'})<CR>

" visual multi {{{1
nmap <silent> <leader>mj <Plug>(VM-Add-Cursor-Down)
nmap <silent> <leader>mk <Plug>(VM-Add-Cursor-Up)

" preview {{{1
noremap <silent> gv  :PreviewTag<CR>
noremap <silent> gV  :PreviewClose<CR>
noremap  <m-u> :PreviewScroll -1<cr>
noremap  <m-d> :PreviewScroll +1<cr>
inoremap <m-u> <c-\><c-o>:PreviewScroll -1<cr>
inoremap <m-d> <c-\><c-o>:PreviewScroll +1<cr>

" ctags and gtags {{{1
noremap <silent> gd :<C-U><C-R>=printf("Leaderf gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>
noremap <silent> gf :<C-U><C-R>=printf("Leaderf function %s", "")<CR><CR>
noremap <silent> gF :<C-U><C-R>=printf("Leaderf function --all %s", "")<CR><CR>
noremap <silent> gn :<C-U><C-R>=printf("Leaderf gtags --next %s", "")<CR><CR>
noremap <silent> go :<C-U><C-R>=printf("Leaderf gtags --recall %s", "")<CR><CR>
noremap <silent> gp :<C-U><C-R>=printf("Leaderf gtags --previous %s", "")<CR><CR>
noremap <silent> gr :<C-U><C-R>=printf("Leaderf gtags -r %s --auto-jump", expand("<cword>"))<CR><CR>

" 输入法切换 {{{1
inoremap <expr> <PageUp>   Lbs_Input_Env_Zh()
inoremap <expr> <PageDown> Lbs_Input_Env_En()
inoremap <expr> <bs>       Lbs_bs()







 








