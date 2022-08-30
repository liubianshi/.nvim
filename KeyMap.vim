" vim: set fdm=marker nowrap:
" function: add symbol at the end of current line ============================ {{{1
" 在末尾添加符号 ------------------------------------------------------------- {{{2
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
    let l = (w - virtcol('$')) / strlen(a:symbol) - 5
    let back = @"
    let @" = a:symbol
    exec "normal! A \<esc>" . l . '""p'
    let @" = back
endfunction

" Use K to show documentation in preview window. --------------------------- {{{2
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" 列出当前文件可运行的命令 ----------------------------------------------- {{{2
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

" Command ==================================================================== {{{1
augroup LBS
    autocmd!
    command! -nargs=* SR call system(printf("sr %s &>/dev/null &", "<args>"))
augroup END

" Global {{{1
inoremap <silent> <A-;> <esc>A;<enter>
inoremap <silent> <A-space> <esc>A
inoremap <silent> <A-enter> <esc>A<cr>

nnoremap <silent> K :call <SID>show_documentation()<CR>
vnoremap <silent> p "_dP
vnoremap <silent> < <gv
vnoremap <silent> > >gv

" Terminal {{{1 
tnoremap <A-space> <C-\><C-n>

" Buffer {{{1
nnoremap <silent> <leader>bc :<c-u>call Lilydjwg_cleanbufs()<cr>
nnoremap <silent> <leader>bd :<c-u>Bclose<cr>
nnoremap <silent> <leader>bp :<c-u>bp<cr>
nnoremap <silent> <leader>bn :<c-u>bn<cr>
nnoremap <silent> <leader>bq :q<cr>
nnoremap <silent> <leader>bQ :q!<cr>
nnoremap <silent> <leader>bw :w<cr>
nnoremap <silent> <leader>bW :w!<cr>

" 管理 quickfix {{{1
nnoremap <leader>qq :call utils#QuickfixToggle()<cr>

" window manager {{{1
nnoremap <silent> w<space> :FzfWindows<cr>
nnoremap <silent> w0 <C-U>:85wincmd \|<cr>
nnoremap <silent> wt <C-U>:wincmd T<cr>
nnoremap <silent> wo :<c-u>only<cr>
nnoremap <silent> wv <c-w>v
nnoremap <silent> ws <c-w>s
nnoremap <silent> w= <c-w>=
nnoremap <silent> ww <c-w>w
nnoremap <silent> wj <c-w>j
nnoremap <silent> wk <c-w>k
nnoremap <silent> wh <c-w>h
nnoremap <silent> wl <c-w>l
nnoremap <silent> wq <c-w>q
nnoremap <silent> wx <c-w>x
nnoremap <silent> wn :vsplit \| enew<cr>
nnoremap <silent> <C-J>    :resize -2<CR>
nnoremap <silent> <C-K>  :resize +2<CR>
nnoremap <silent> <C-H>  :vertical resize -2<CR>
nnoremap <silent> <C-L> :vertical resize +2<CR>

" tab managing{{{1
nnoremap <silent> <leader>tt :tabnew<cr>
nnoremap <silent> <leader>tx :tabclose<cr>
nnoremap <silent> <leader>tn :tabnext<cr>
nnoremap <silent> <leader>tp :tabprevious<cr>
nnoremap <silent> <leader>tP :tabfirst<cr>
nnoremap <silent> <leader>tN :tablast<cr>

" run {{{1 
noremap <silent> <leader><enter> :noh<cr>
nnoremap <silent> <leader>o: :<C-U>FloatermNew 
nnoremap <silent> <leader>ob :call utils#Status()<cr>
nnoremap <silent> <leader>od :source $MYVIMRC<cr>
nnoremap <silent> <leader>oh :noh<cr>
nnoremap <silent> <leader>ol :<C-R>=printf("FloatermSend%s", "")<CR><CR>
nnoremap <silent> <leader>on :FloatermNew nnn<CR>
nnoremap <silent> <leader>oo :AsyncRun xdg-open "%"<cr>
nnoremap <silent> <leader>op :<c-u>execute "cd" expand("%:p:h")<cr>
nnoremap <silent> <leader>or :<C-U>AsyncRun 
nnoremap <silent> <leader>oz :<c-u>call utils#ToggleZenMode()<cr>
nnoremap <silent> <leader>oZ :Goyo<cr>
command! RUN FloatermNew --name=repl --wintype=normal --position=right

" 翻译 {{{1
nnoremap <expr>   L utils#Trans2clip()
xnoremap <expr>   L utils#rans2clip()

" Edit Specific file {{{1
nnoremap <leader>ev :edit $MYVIMRC<cr>
nnoremap <leader>ek :edit ~/.config/nvim/KeyMap.vim<cr>
nnoremap <leader>er :edit ~/.Rprofile<cr>
nnoremap <leader>es :edit ~/.config/stata/profile.do<cr>
nnoremap <leader>ez :edit ~/.zshrc<cr>
nnoremap <leader>eZ :edit ~/useScript/usr.zshrc<cr>
nnoremap <leader>ea :edit ~/useScript/alias<cr>
nnoremap <leader>eu :edit ~/.config/nvim/UltiSnips<cr>

" search {{{1

" search by surfraw {{{2
noremap <silent> <leader>ss :<C-U>SR<space>
vnoremap <silent> <c-s> "0y:<C-U>SR google <C-R>0<CR>
nnoremap <silent> <c-s> :<C-U><C-R>=printf("SR google %s", expand("<cword>"))<CR><CR>
nnoremap <silent> srh :<C-U><C-R>=printf("SR github %s", expand("<cword>"))<CR><CR>
vnoremap <silent> srh "0y:<C-U>SR github <C-R>0<CR>

" diff 相关 {{{1
map <silent> <leader>d1 :diffget 1<CR>:diffupdate<CR>
map <silent> <leader>d2 :diffget 2<CR>:diffupdate<CR>
map <silent> <leader>d3 :diffget 3<CR>:diffupdate<CR>
map <silent> <leader>d4 :diffget 4<CR>:diffupdate<CR>

" add content {{{1 
nnoremap <silent> <leader>a- :<c-u>call <sid>AddDash("-")<cr>
nnoremap <silent> <leader>a= :<c-u>call <sid>AddDash("=")<cr>
nnoremap <silent> <leader>a. :<c-u>call <sid>AddDash(".")<cr>
" 补全相关 {{{1
inoremap <silent> <A-j> <esc>:call utils#AutoFormatNewline()<cr>a
" 注释掉的原因：导致 mac iterm2 输入中文引号时乱码
" if has("mac")
"     inoremap <silent> ∆ <esc>:call utils#AutoFormatNewline()<cr>a
" endif
let g:UltiSnipsExpandTrigger		    = "<c-l>"
let g:UltiSnipsJumpForwardTrigger	    = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger	    = "<c-k>"
let g:UltiSnipsRemoveSelectModeMappings = 0
inoremap <silent><expr> <Down> pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <silent><expr> <Up>   pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> ;<tab> coc#refresh()


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
vnoremap <silent> * :<C-u>call utils#VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call utils#VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>:

" Fold: 折叠 {{{1
nnoremap <silent> <leader>zf g_a <esc>3a{<esc>
nnoremap <silent> <leader>z1 g_a <esc>3a{<esc>a1<esc>
nnoremap <silent> <leader>z2 g_a <esc>3a{<esc>a2<esc>
nnoremap <silent> <leader>z3 g_a <esc>3a{<esc>a3<esc>

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
inoremap ;<space> ;


" preview {{{1
nnoremap <localleader>v vip:call utils#MdPreview()<cr>
nnoremap <localleader>V vip:call utils#MdPreview(1)<cr>
vnoremap <localleader>v :call utils#MdPreview()<cr>
vnoremap <localleader>V :call utils#MdPreview(1)<cr>

" 输入法 {{{1
inoremap <silent><expr> ;; input_method#En()
inoremap <silent><expr> ;f input_method#Zh()










 








