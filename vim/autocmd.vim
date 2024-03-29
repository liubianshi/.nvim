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

function! s:adjust_zen_mode(event)
    let windows = a:event['windows']
    for win in windows
        let ww = winwidth(win)

        let bufnr = winbufnr(win)
        let zen_oriwin = getbufvar(bufnr, "zen_oriwin")
        if type(zen_oriwin) == v:t_dict && zen_oriwin['zenmode']
            if ww < 81
                call luaeval('vim.api.nvim_win_set_option(' . win . ", 'foldcolumn', '0')")
            elseif ww < 91
                call luaeval('vim.api.nvim_win_set_option(' . win . ", 'foldcolumn', '1')")
            else
                call luaeval('vim.api.nvim_win_set_option(' . win . ", 'foldcolumn', '" . min([((ww - 89) / 2), 9]) . "')")
            endif
        else
            if ww < 40
                call luaeval('vim.api.nvim_win_set_option(' . win . ", 'foldcolumn', '0')")
            else
                call luaeval('vim.api.nvim_win_set_option(' . win . ", 'foldcolumn', '1')")
            endif
        endif
    endfor
endfunction

function! s:adjust_window_based_on_zen_mode_status() abort
    let isZenBuffer = (exists('b:zen_oriwin') && b:zen_oriwin['zenmode'])
    let isZenWindow = (exists('w:zen_mode') && w:zen_mode)
    if (isZenWindow == isZenBuffer)
        return
    endif
    
    if (isZenBuffer)
        call utils#ZenMode_Insert(v:false)
    else
        call utils#ZenMode_Leave(v:false)
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
autocmd WinResized           * call s:adjust_zen_mode(v:event)
" autocmd BufWinLeave          * call utils#ZenMode_Leave(v:false)
" autocmd BufWinEnter,BufRead,BufEnter  * call utils#ZenMode_Insert(v:false)
autocmd BufWinEnter,BufRead,BufEnter  * call s:adjust_window_based_on_zen_mode_status()
" autocmd VimEnter * lua require('lspconfig').rime_ls.launch()



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


