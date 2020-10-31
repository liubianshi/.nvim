" 通过 Alt + 1 在运行当前行
augroup STATA
    autocmd!
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
augroup END
