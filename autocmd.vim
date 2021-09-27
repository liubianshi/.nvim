" filetype related init {{{1
"
" cmd: start {{{1
augroup LOAD_ENTER
autocmd!

" cmd: global setting {{{1
autocmd InsertLeave,WinEnter *                          setlocal cursorline
autocmd InsertEnter,WinLeave *                          setlocal nocursorline
autocmd TermOpen             *                          setlocal nonumber norelativenumber bufhidden=hide

" cmd: TMUX {{{1
if exists('$TMUX')
    autocmd BufNewFile,BufRead * call Lbs_Load_Plug('vim-obsession')
endif

" cmd: floaterm {{{1
autocmd FileType floaterm nnoremap <buffer> <leader>r :<C-U>FloatermUpdate --wintype=normal --position=right<cr>
autocmd FileType floaterm nnoremap <buffer> <leader>l :<C-U>FloatermUpdate --wintype=normal --position=left<cr>
autocmd FileType floaterm nnoremap <buffer> <leader>f :<C-U>FloatermUpdate --wintype=floating --position=topright<cr>

augroup END

" Wiki Autocmds {{{1
"augroup MyWikiAutocmds
"    autocmd!
"    autocmd User WikiLinkOpened PandocHighlight r
"augroup END
