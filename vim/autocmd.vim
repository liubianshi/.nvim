function! s:fasd_update() abort
  if empty(&buftype) || &filetype ==# 'dirvish'
    call jobstart(['fasd', '-A', fnameescape(expand('%:p'))])
  endif
endfunction

function! s:FoldMethodSetting() abort
    if &l:foldmethod ==# "manual"
        if &l:foldexpr == 0 | setlocal foldexpr=fold#GetFold() | endif
        setlocal foldmethod=expr
    endif
endfunction

function! s:checktime() abort
    if getcmdwintype() == ""
        checktime
    endif
endfunction

" 初始 ================================================================== {{{1
augroup LOAD_ENTER
autocmd!



" cmd: global setting --------------------------------------------------- {{{2
autocmd InsertLeave,WinEnter *  setlocal cursorline
autocmd InsertEnter,WinLeave *  setlocal nocursorline
autocmd TermOpen             *  setlocal nonumber norelativenumber bufhidden=hide
autocmd FileType   r,stata,vim  call s:FoldMethodSetting()
autocmd TermOpen      term://*  call v:lua.set_terminal_keymaps()
autocmd FileType   norg,org,markdown,rmd,rmarkdown
            \ syntax match NonText /​/ conceal

" Fasd ------------------------------------------------------------------ {{{2
autocmd BufWinEnter,BufFilePost * call <SID>fasd_update()

" Resize all windows when we resize the terminal ------------------------ {{{2
" From:
"   https://github.com/jdhao/nvim-config/blob/master/lua/custom-autocmd.lua
autocmd VimResized * lua require('focus').resize()

" Automatically reload the file if it is changed outside of Nvim
" From:
"   https://github.com/jdhao/nvim-config/blob/master/lua/custom-autocmd.lua
autocmd FileChangedShellPost   * 
        \ lua vim.notify("File changed on disk. Buffer reloaded!",
        \                vim.log.levels.WARN,
        \                { title = "nvim-config" })
autocmd FocusGained,CursorHold * call <SID>checktime()
augroup END

" Input Method Toggle =================================================== {{{1
" augroup Method_Toggle
"     autocmd!
    " autocmd InsertLeavePre *   call input_method#LeaveInsertMode()
    " autocmd InsertEnter *      call input_method#RestoreInsertMode()
    " autocmd CmdlineEnter [/\?] call input_method#RestoreInsertMode()
    " autocmd CmdlineLeave [/\?] call input_method#LeaveInsertMode()
    " autocmd BufRead,BufNew *
    "     \ inoremap <silent><expr><buffer> <space>
    "     \ input_method#AutoSwitchAfterSpace()
    " autocmd BufRead,BufNew *
    "     \ inoremap <silent><expr><buffer> <bs>
    "     \ input_method#AutoSwitchAfterBackspace()
    " autocmd FileType mail,org
    "     \ inoremap <silent><expr><buffer> <space>
    "     \ input_method#AutoSwitchAfterSpace()
    " autocmd FileType mail,org
    "     \ inoremap <silent><expr><buffer <bs>
    "     \ input_method#AutoSwitchAfterBackspace()
" augroup END
"
"
"


