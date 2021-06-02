function! Lbs_Input_Env_Toggle()
    if !exists("g:LBS_INPUT_ENV")
        call Fcitx2zh() let g:LBS_INPUT_ENV = 1
        echo "Change to Chinese Mode"
    elseif g:LBS_INPUT_ENV == 0
        let g:LBS_INPUT_ENV = 1
        echo "Change to Chinese Mode"
    else
        let g:LBS_INPUT_ENV = 0
        echo "Change to ASCII Mode"
    endif
    return("")
endfunction

function! Lbs_Fcitx_Auto()
    if exists("g:LBS_INPUT_ENV") && g:LBS_INPUT_ENV == 1
        if v:char == '\x1d' || v:char == ' ' " 待输入的字符是空格或 <ctrl-]>
            let cursor_before_char = getline('.')[max([0, col('.') - 2]):]
            if cursor_before_char =~ '[\x21-\x7d]'
                call Fcitx2zh()
            else
                call Fcitx2en()
            endif
        endif
    endif
    return("")
endfunction

augroup Fcitx
    autocmd!
    autocmd InsertCharPre * call Lbs_Fcitx_Auto()
augroup END


" function! Lbs_test(lchar)
"     if v:char == "\<C-]>"
"         echom "got it"
"     endif
"     let g:LBS_TEST = v:char
"     return a:lchar
" endfunction

"inoremap <expr> <space><space> Lbs_Fcitx_Auto()
"iabbr <buffer> <expr> jj Lbs_test("jk")



"代567u11111111       11 jq1 1dde
" 34567891012141618202224262811111110000000 j000 fffddddddd    1234 
"    
"    000j00000


