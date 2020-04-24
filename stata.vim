function! RunDoLines()
    let selectedLines = getbufline('%', line("'<"), line("'>"))
    if col("'>") < strlen(getline(line("'>")))
        let selectedLines[-1] = strpart(selectedLines[-1], 0, col("'>"))
    endif
    if col("'<") != 1
        let selectedLines[0] = strpart(selectedLines[0], col("'<")-1)
    endif
    let temp = "/tmp/statacmd.do"
    call writefile(selectedLines, temp)

	" *** CHANGE PATH AND NAME TO REFLECT YOUR SETUP. USE \\ INSTEAD OF \ ***
    if(has("mac"))
        silent exec "!open /tmp/statacmd.do" 
    else
        silent exec "! nohup bash ~/.config/nvim/runStata.sh >/dev/null 2>&1 &"
    endif
endfun

" 通过 Alt + 1 在运行当前行
if(has("mac"))
    autocmd FileType stata inoremap <buffer> ¡ <esc>V:<c-u>call RunDoLines()<cr>
    autocmd FileType stata nnoremap <buffer> ¡ V:call RunDoLines()<cr>
    autocmd FileType stata vnoremap <buffer> ¡ :<C-U>call RunDoLines()<cr>
else
    autocmd FileType stata inoremap <buffer> <A-1> <esc>V:<c-u>call RunDoLines()<cr>
    autocmd FileType stata nnoremap <buffer> <A-1> V:call RunDoLines()<cr>
    autocmd FileType stata vnoremap <buffer> <A-1> :<C-U>call RunDoLines()<cr>
endif

autocmd FileType stata vnoremap <buffer> , :<C-U>call RunDoLines()<cr>
autocmd FileType stata nnoremap <buffer> ;l V:<c-u>call RunDoLines()<cr>

" 自动完成
autocmd FileType stata let b:AutoPairs = g:AutoPairs
autocmd FileType stata let b:AutoPairs['`']="'" 
autocmd FileType stata set foldmethod=marker
autocmd FileType stata set foldmarker={,}
