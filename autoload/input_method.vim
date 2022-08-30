" 获取光标前 b 个字符开始的 l 个字符 {{{2
function! s:GetChar_before_cursor(b, l = 1)
    return getline('.')[max([0, col('.') - a:b]):col('.') - max([0, a:b - a:l + 1])]
endfunction

" 判断当前环境是否为中文输入法 {{{3
function! s:ChineseInputOn()
    return (trim(system(g:lbs_input_status)) == g:lbs_input_method_on)
endfunction

"echo "Change to Chinese Mode" {{{2
function! input_method#Zh(insert_entry = 0)
    if a:insert_entry == 1
        try
            if b:inputtoggle == 1
                call system(g:lbs_input_method_activate)
                let b:inputtoggle = 0
            endif
        catch /inputtoggle/
            let b:inputtoggle = 0
        endtry
    else
        let b:INPUT_ENV = 1
        if !<SID>ChineseInputOn()
            call system(g:lbs_input_method_activate)
        endif
    endif
    return("")
endfunction

"echo "Change to English Mode" {{{2
function! input_method#En(insert_leave = 0)
    if a:insert_leave == '1'
        if <SID>ChineseInputOn()
            let b:inputtoggle = 1
            call system(g:lbs_input_method_inactivate)
        endif
    else
        let b:INPUT_ENV = 0
        if <SID>ChineseInputOn()
            call system(g:lbs_input_method_inactivate)
        endif
    endif
    return("")
endfunction

" 自动切换输入中文输入法 {{{2
function! input_method#AUTO()
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
    if exists("b:INPUT_ENV") && b:INPUT_ENV == 1
        let cursor_before_char = <SID>GetChar_before_cursor(2, 1)
        if cursor_before_char =~ '[\x21-\x7d]'
            call system(g:lbs_input_method_activate)
        else
            call system(g:lbs_input_method_inactivate)
        endif
    endif
    return("")
endfunction

" 通过 space 实现自动切换 {{{2
function! input_method#Space(symbol_dict)
    if !(exists("b:INPUT_ENV") && b:INPUT_ENV == 1)
        return "\<space>"
    endif
    let cursor_before_char = <SID>GetChar_before_cursor(2, 1)
    if has_key(a:symbol_dict, cursor_before_char)
        if cursor_before_char =~ '[\x20-\x7d]'
            let cursor_before_char_2 = <SID>GetChar_before_cursor(3, 1)
        else 
            let cursor_before_char_2 = <SID>GetChar_before_cursor(5, 1)
        endif
        if ! (cursor_before_char_2 =~ '[\x21-\x7d]')
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

" 按回车键后的自动切换 {{{2
function! input_method#BS()
    if !(exists("b:INPUT_ENV") && b:INPUT_ENV == 1)
        return "\<bs>"
    endif

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

    return("\<bs>")
endfunction

