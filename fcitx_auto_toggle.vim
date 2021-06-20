function! Lbs_Input_Env_Zh()
    call system("fcitx5-remote -o")
    let g:LBS_INPUT_ENV = 1
    "echo "Change to Chinese Mode"
    return("")
endfunction
function! Lbs_Input_Env_En()
    call system("fcitx5-remote -c")
    let g:LBS_INPUT_ENV = 0
    "echo "Change to English Mode"
    return("")
endfunction

function! Lbs_Fcitx_Auto()
    if exists("g:LBS_INPUT_ENV") && g:LBS_INPUT_ENV == 1
        if v:char == '\x1d' || v:char == ' ' " 待输入的字符是空格或 <ctrl-]>
            let cursor_before_char = getline('.')[max([0, col('.') - 2]):]
            if cursor_before_char =~ '[\x21-\x7d]'
                call system("fcitx5-remote -o")
            else
                call system("fcitx5-remote -c")
            endif
        endif
    endif
    return("")
endfunction

function! Lbs_bs()
    if exists("g:LBS_INPUT_ENV") && g:LBS_INPUT_ENV == 1
        let coursor_char = getline('.')[col('.') - 2:col('.') - 2]
        if coursor_char =~ '[\x20-\x7d]'
            let cursor_before_char = getline('.')[max([0, col('.') - 3]):max([0, col('.') - 3])]
        else 
            let cursor_before_char = getline('.')[max([0, col('.') - 5]):max([0, col('.') - 5])]
        endif
        if cursor_before_char =~ '[\x21-\x7d]'
            call system("fcitx5-remote -c")
        else
            call system("fcitx5-remote -o")
        endif
    endif
    return("\<bs>")
endfunction

augroup Fcitx
    autocmd!
    autocmd InsertCharPre *.md,*.[Rr]md,*.org call Lbs_Fcitx_Auto()
augroup END

