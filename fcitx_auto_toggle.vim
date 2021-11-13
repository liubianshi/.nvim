function! Lbs_Input_Env_Zh()
    "echo "Change to Chinese Mode"
    call system(g:lbs_input_method_activate)
    let g:LBS_INPUT_ENV = 1
    return("")
endfunction
function! Lbs_Input_Env_En()
    "echo "Change to English Mode"
    call system(g:lbs_input_method_inactivate)
    let g:LBS_INPUT_ENV = 0
    return("")
endfunction

function! Lbs_Fcitx_Auto()
    if exists("g:LBS_INPUT_ENV") && g:LBS_INPUT_ENV == 1
        if v:char == '\x1d' || v:char == ' ' " 待输入的字符是空格或 <ctrl-]>
            let cursor_before_char = getline('.')[max([0, col('.') - 2]):]
            if cursor_before_char =~ '[\x21-\x7d]'
                call system(g:lbs_input_method_activate)
            else
                call system(g:lbs_input_method_inactivate)
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
            call system(g:lbs_input_method_inactivate)
        else
            call system(g:lbs_input_method_activate)
        endif
    endif
    return("\<bs>")
endfunction

augroup Fcitx
    autocmd!
    autocmd InsertCharPre  *.hlp,*.md,*.[Rr]md,*.org call Lbs_Fcitx_Auto()
    autocmd BufRead,BufNew *.hlp,*.md,*.[Rr]md,*.org inoremap <expr> <bs> Lbs_bs()
augroup END

