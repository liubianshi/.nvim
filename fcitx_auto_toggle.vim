function! s:GetChar_before_cursor(b, l = 1)
    " 获取光标前 b 个字符开始的 l 个字符
    return getline('.')[max([0, col('.') - a:b]):col('.') - max([0, a:b - a:l + 1])]
endfunction

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

function! Lbs_Chinese_auto()
    if v:char != '\x1d' && v:char != ' ' " 待输入的字符是空格或 <ctrl-]>
        return("")
    endif
    let symbol_dict = {
                \  ',': "，",
                \  '.': "。",
                \  '\': "、",
                \  ':': "：",
                \  ';': "；",
                \  '!': "！",
                \  '?': "？",
                \  }
    let cursor_before_char = <SID>GetChar_before_cursor(2, 1)
    let cursor_before_char_2 = <SID>GetChar_before_cursor(3, 1)
    if has_key(symbol_dict, cursor_before_char)
        stopinsert
        return "abc"
    endif
    if exists("g:LBS_INPUT_ENV") && g:LBS_INPUT_ENV == 1
        let cursor_before_char = <SID>GetChar_before_cursor(2, 1)
        if cursor_before_char =~ '[\x21-\x7d]'
            call system(g:lbs_input_method_activate)
        else
            call system(g:lbs_input_method_inactivate)
        endif
    endif
    return("")
endfunction


function! Lbs_Space(symbol_dict)
    let cursor_before_char = <SID>GetChar_before_cursor(2, 1)
    if has_key(a:symbol_dict, cursor_before_char)
        if cursor_before_char =~ '[\x20-\x7d]'
            let cursor_before_char_2 = <SID>GetChar_before_cursor(3, 1)
        else 
            let cursor_before_char_2 = <SID>GetChar_before_cursor(5, 1)
        endif
        if cursor_before_char_2 =~ '[\x21-\x7d]'
            call system(g:lbs_input_method_activate)
            return "\<space>"
        else
            return ("\<bs>" . a:symbol_dict[cursor_before_char])
        endif
    endif
    if cursor_before_char =~ '[\x21-\x7d]'
        call system(g:lbs_input_method_activate)
    else
        call system(g:lbs_input_method_inactivate)
    endif
    return "\<space>"
endfunction

function! Lbs_bs()
    if exists("g:LBS_INPUT_ENV") && g:LBS_INPUT_ENV == 1
        let cursor_char = <SID>GetChar_before_cursor(2, 1)
        if cursor_char =~ '[\x20-\x7d]'
            let cursor_before_char = <SID>GetChar_before_cursor(3, 1)
        else 
            let cursor_before_char = <SID>GetChar_before_cursor(5, 1)
        endif
        if cursor_before_char == '\x1d' || cursor_before_char == ' '
            return "\<bs>"
        endif
        if cursor_before_char =~ '[\x21-\x7d]'
            call system(g:lbs_input_method_inactivate)
        else
            call system(g:lbs_input_method_activate)
        endif
    endif
    return("\<bs>")
endfunction

let symbol_dict = {
            \  ',': "，",
            \  '.': "。",
            \  '\': "、",
            \  ':': "：",
            \  ';': "；",
            \  '!': "！",
            \  '?': "？",
            \  }
if has('mac')
else
    augroup Fcitx
        autocmd!
        "autocmd InsertCharPre  *.hlp,*.md,*.[Rr]md,*.[Rr]markdown,*.org call Lbs_Chinese_auto()
        autocmd BufRead,BufNew *.hlp,*.md,*.[Rr]md,*.[Rr]markdown,*.org inoremap <silent><expr> <space>  Lbs_Space(symbol_dict)
        autocmd BufRead,BufNew *.hlp,*.md,*.[Rr]md,*.[Rr]markdown,*.org inoremap <silent><expr> <bs> Lbs_bs()
    augroup END
endif
