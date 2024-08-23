" vim: set fdm=marker nowrap:
" Nvim Keymap
" function: add symbol at the end of current line ======================== {{{1
" Use K to show documentation in preview window. ------------------------- {{{2
function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    elseif (index(['perl','perldoc'], &filetype) >= 0)
        execute 'Perldoc '.expand('<cword>')
    elseif (index(['stata','statadoc'], &filetype) >= 0)
        execute 'Shelp '.expand('<cword>')
    elseif (index(['r', 'rmd', 'rdoc'], &filetype) >= 0)
        if (has_key(g:, 'rplugin') && g:rplugin['jobs']['R'] != 0)
            execute 'Rhelp '.expand('<cword>')
        else
            execute 'Rdoc '.expand('<cword>')
        endif
    else
        execute &keywordprg . " " . expand('<cword>')
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


" Global ================================================================= {{{1
xnoremap <silent> iB :<C-U>call text_obj#Buffer()<CR>
onoremap <silent> iB :<C-U>call text_obj#Buffer()<CR>

inoremap <silent> <A-;> <esc>A;<enter>
inoremap <silent> <A-space> <esc>A
inoremap <silent> <A-enter> <esc>A<cr>
inoremap <silent> ;a <esc>A

" nnoremap <silent> K :call <SID>show_documentation()<CR>
" xnoremap <silent> p "_dP
vnoremap <silent> < <gv
vnoremap <silent> > >gv

" 中文语境下断行 -------------------------------------------------------- {{{2
nnoremap <buffer><silent> <A-/> ?\v[,.:?")，。)，。：》”；？、」） ]<cr>:noh<cr>a<enter><esc>`^g_
inoremap <buffer><silent> <A-/> <esc>?\v[,.:?")，。)，。：》”；？、」） ]<cr>:noh<cr>a<enter><esc>`^A
inoremap <buffer><silent> <localleader><enter> 
    \ <esc>?\v[,.:?")，。)，。：》”；？、」） ]<cr>:noh<cr>a<enter><esc>`^A

" Change text without putting it into the vim register, ------------------ {{{2
" see https://stackoverflow.com/q/54255/6064933
nnoremap c "_c
nnoremap C "_C
nnoremap cc "_cc
xnoremap c "_c

" Text objects for URL --------------------------------------------------- {{{2
xnoremap <silent> iu :<C-U>call text_obj#URL()<CR>
onoremap <silent> iu :<C-U>call text_obj#URL()<CR>
xnoremap <silent> il ^o$h
onoremap <silent> il :normal vil<cr>
xnoremap <silent> al ^o$
onoremap <silent> al :normal val<cr>

" 管理 quickfix ========================================================== {{{1
nnoremap <leader>qq :call utils#QuickfixToggle()<cr>

" 翻译 =================================================================== {{{1
nnoremap <expr><silent>   L utils#Trans2clip()
xnoremap <expr><silent>   L utils#Trans2clip()
inoremap <silent>        ;l <esc>:call utils#Trans_Subs()<cr>

" 管理文件 ============================================================== {{{1
nnoremap <silent> <leader>fs  :write<CR>
nnoremap <silent> <leader>fS  :write!<CR>


" search ================================================================= {{{1
" check the syntax group of current cursor position
" if has('nvim')
"     nnoremap <silent> <leader>sg :<C-U>call utils#Extract_hl_group_link()<CR>
" else
"     nnoremap <silent> <leader>sg :<C-U>call utils#SynGroup()<CR>
" endif

" search by surfraw ------------------------------------------------------ {{{2
vnoremap <silent> <c-s>      "0y:<C-U>SR google <C-R>0<CR>
nnoremap <silent> <c-s>      :<C-U><C-R>=printf("SR google %s", expand("<cword>"))<CR><CR>
nnoremap <silent> srh        :<C-U><C-R>=printf("SR github %s", expand("<cword>"))<CR><CR>
vnoremap <silent> srh        "0y:<C-U>SR github <C-R>0<CR>

" diff 相关 ============================================================== {{{1
nnoremap <silent> <leader>d1 :diffget 1<CR>:diffupdate<CR>
nnoremap <silent> <leader>d2 :diffget 2<CR>:diffupdate<CR>
nnoremap <silent> <leader>d3 :diffget 3<CR>:diffupdate<CR>
nnoremap <silent> <leader>d4 :diffget 4<CR>:diffupdate<CR>
nnoremap <silent> <leader>dl :diffget LOCAL<CR>:diffupdate<CR>
nnoremap <silent> <leader>dr :diffget REMOTE<CR>:diffupdate<CR>

" add content ============================================================ {{{1
nnoremap <silent> <leader>z- :<c-u>call utils#AddFoldMark("-")<cr>
nnoremap <silent> <leader>z= :<c-u>call utils#AddFoldMark("=")<cr>
nnoremap <silent> <leader>z. :<c-u>call utils#AddFoldMark(".")<cr>
nnoremap <silent> <leader>z* :<c-u>call utils#AddFoldMark("*")<cr>
nnoremap <silent> <leader>a- :<c-u>call utils#AddDash("-")<cr>
nnoremap <silent> <leader>a= :<c-u>call utils#AddDash("=")<cr>
nnoremap <silent> <leader>a. :<c-u>call utils#AddDash(".")<cr>
nnoremap <silent> <leader>a* :<c-u>call utils#AddDash("*")<cr>

" 补全相关 =============================================================== {{{1
inoremap <silent> <A-j> <esc>:call utils#AutoFormatNewline()<cr>a
" 注释掉的原因：导致 mac iterm2 输入中文引号时乱码
" if has("mac")
"     inoremap <silent> ∆ <esc>:call utils#AutoFormatNewline()<cr>a
" endif
inoremap <silent><expr> <Down> pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <silent><expr> <Up>   pumvisible() ? "\<C-p>" : "\<Up>"


" Navigation ============================================================= {{{1
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

" Visual mode pressing * or # searches for the current selection ========= {{{1
vnoremap <silent> * :<C-u>call utils#VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call utils#VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>:

" Fold: 折叠 ============================================================= {{{1
nnoremap <silent> <leader>zf g_a <esc>3a{<esc>
nnoremap <silent> <leader>z1 g_a <esc>3a{<esc>a1<esc>
nnoremap <silent> <leader>z2 g_a <esc>3a{<esc>a2<esc>
nnoremap <silent> <leader>z3 g_a <esc>3a{<esc>a3<esc>

" 输入法 ================================================================= {{{1
inoremap ;<space> ;
" inoremap <silent> ;; <esc>:<c-u>call input_method#En()<cr>a
" inoremap <silent> ;f <esc>:<c-u>call input_method#Zh()<cr>a

" 移动光标到指定位置 ==================================================== {{{1
noremap  <A-m> <esc>:call utils#MoveCursorTo()<cr>
noremap  <A-M> <esc>:call utils#ShiftLine(line('.') + 1, col('.') - 1)<cr>
inoremap <A-m> <esc>:call utils#MoveCursorTo()<cr>
inoremap <A-M> <esc>:call utils#MoveCursorTo("")<cr>a

