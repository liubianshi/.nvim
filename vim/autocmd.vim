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
augroup Method_Toggle
    autocmd!
    autocmd InsertLeavePre *   call input_method#LeaveInsertMode()
    autocmd InsertEnter *      call input_method#RestoreInsertMode()
    autocmd CmdlineLeave *     call system(g:lbs_input_method_inactivate)
    autocmd CmdlineEnter [/\?] call input_method#RestoreInsertMode()
augroup END
"
" Keywordprg
augroup Keyword_Group
    autocmd!
    autocmd FileType perl,perldoc   let &keywordprg = ":Perldoc"
    autocmd FileType stata,statadoc let &keywordprg = ":Shelp"
    autocmd FileType r,rmd,rdoc     let &keywordprg = 
        \ (has_key(g:, 'rplugin') && g:rplugin['jobs']['R'] != 0) ? ":Rhelp" : ":Rdoc"
    autocmd FileType man,sh,bash    let &keywordprg = ":Man"
augroup END


