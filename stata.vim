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
  	silent exec "!bash ~/.config/nvim/runStata.sh"
endfun

" 通过 Alt + 1 在运行当前行
autocmd FileType stata imap <buffer> <A-1> <Esc>V:call RunDoLines()<cr>
autocmd FileType stata nmap <buffer> <A-1> V:call RunDoLines()<cr>
autocmd FileType stata vmap <buffer> <A-1> :<C-U>call RunDoLines()<cr>
