function! s:fasd_update() abort
  if empty(&buftype) || &filetype ==# 'dirvish'
      if expand('%') == "" | return | endif
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
        let winnr = win_id2win(win)
        if winnr == 0 | continue | endif

        let ww = winwidth(win)
        let bufnr = winbufnr(win)
        let zen_oriwin = getbufvar(bufnr, "zen_oriwin")
        if luaeval('vim.api.nvim_get_option_value("syntax", {buf = _A})', bufnr) == "rbrowser"
            if ww <= 30 | continue | endif
            exec "vertical " . winnr . "resize 30"
            return
        elseif type(zen_oriwin) == v:t_dict && zen_oriwin['zenmode']
            if ww <= 84
                call luaeval('vim.api.nvim_set_option_value("signcolumn", "yes:1",  { win = _A})', win)
            elseif ww <= 126
                call luaeval('vim.api.nvim_set_option_value("signcolumn", "yes:" .. _A[2], { win = _A[1]})', [win, min([((ww - 81) / 4), 9])])
            endif
        else
            if ww < 40
                call luaeval('vim.api.nvim_set_option_value("signcolumn", "no",     { win = _A})', win)
                call luaeval('vim.api.nvim_set_option_value("foldcolumn", "0",      { win = _A})', win)
            else
                call luaeval('vim.api.nvim_set_option_value("signcolumn", "yes:1",  { win = _A})', win)
                call luaeval('vim.api.nvim_set_option_value("foldcolumn", vim.o.foldcolumn, { win = _A})', win)
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

function! s:disable_touchpad() abort
  let hostn = trim(system("hostname"))
  if hostn ==? "lbsgram"
    call system("touchpad off")
  endif
endfunction

function! s:enable_touchpad() abort
  let hostn = trim(system("hostname"))
  if hostn ==? "lbsgram"
    call system("touchpad on")
  endif
endfunction

" 初始 ================================================================== {{{1
augroup LOAD_ENTER
autocmd!

" Error when closing Neovim with VimLeavePre autocommands that execute shell
" commands. #21856
" https://github.com/neovim/neovim/issues/21856
" autocmd VimLeave * call jobstart('notify-send "Neovim Exit!"', {"detach": v:true})


" cmd: global setting --------------------------------------------------- {{{2
autocmd InsertEnter,WinLeave *  setlocal nocursorline
"autocmd InsertEnter * call s:disable_touchpad()
autocmd InsertLeave,WinEnter *  setlocal cursorline | 
" autocmd InsertLeave * call s:enable_touchpad()
autocmd TermOpen             *  setlocal nonumber norelativenumber bufhidden=hide foldcolumn=0
autocmd FileType   r,stata,vim  call s:FoldMethodSetting()
autocmd FileType   norg,org,markdown,rmd,rmarkdown
            \ syntax match NonText /​/ conceal
autocmd WinResized           * call s:adjust_zen_mode(v:event)
" autocmd BufWinLeave          * call utils#ZenMode_Leave(v:false)
" autocmd BufWinEnter,BufRead,BufEnter  * call utils#ZenMode_Insert(v:false)
autocmd BufWinEnter,BufRead,BufEnter  * call s:adjust_window_based_on_zen_mode_status()
" autocmd VimEnter * lua require('lspconfig').rime_ls.launch()
autocmd LspAttach * set formatoptions-=cro


" Fasd ------------------------------------------------------------------ {{{2
autocmd BufRead,BufNew,BufNewFile * call s:fasd_update()

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
"     autocmd InsertLeavePre *   call input_method#LeaveInsertMode()
"     autocmd InsertEnter *      call input_method#RestoreInsertMode()
"     autocmd CmdlineLeave *     call system(g:lbs_input_method_inactivate)
"     autocmd CmdlineEnter [/\?] call input_method#RestoreInsertMode()
" augroup END

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


