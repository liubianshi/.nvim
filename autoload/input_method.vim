let s:symbol_dict = {
            \  ',': "，",
            \  '.': "。",
            \  '\': "、",
            \  ':': "：",
            \  ';': "；",
            \  '!': "！",
            \  '?': "？",
            \  }

let s:character_pattern = {
    \ 'space': '[\t\x1d\x20]',
    \ 'ascii': '[\x20-\x7e]',
    \ 'ascii_without_space': '[\x21-\x7e]',
    \ }

function! s:Is_rime_ls_start()
    if has_key(b:, "rime_enabled")
        return b:rime_enabled
    else
        return v:false
    end
endfunction

" 获取光标前 b 个字符开始的 l 个字符
function! s:GetChar_before_cursor(preceding_num, length = 1, colnum = -1)
    let colnum     = (a:colnum == -1 ? col('.') : a:colnum)
    let char_start = max([0, colnum - a:preceding_num]) 
    let char_end   = min([colnum, char_start + a:length - 1])
    return getline('.')[char_start:char_end]
endfunction

function! s:ChineseInputOn()
    if <SID>Is_rime_ls_start()
        if has_key(b:, "rime_enabled")
            return g:rime_enabled && b:rime_enabled
        else
            return g:rime_enabled
        endif
    else
        return (trim(system(g:lbs_input_status)) == g:lbs_input_method_on)
    endif
endfunction

function! s:InputMethodOfLastInsertMode() abort
    if has_key(b:, "input_method_of_last_insert_mode")
        return b:input_method_of_last_insert_mode
    else
        return s:GetBufferCurrentInputMethod()
    endif
endfunction

function! s:GetBufferCurrentInputMethod() abort
    if has_key(b:, "current_input_method")
        return b:current_input_method
    else
        return -2
    endif
endfunction

function! s:Active_Input_method()
    if <sid>Is_rime_ls_start()
        if !g:rime_enabled
            call luaeval('require("rime-ls").ToggleRime()')
        else
            let b:rime_enabled = v:true
        endif
    else
        call system(g:lbs_input_method_activate)
        inoremap <silent><expr><buffer> <space> input_method#AutoSwitchAfterSpace()
        inoremap <silent><expr><buffer> <bs>    input_method#AutoSwitchAfterBackspace()
    endif
endfunction

function! s:Inactive_Input_method()
    if <sid>Is_rime_ls_start()
        let b:rime_enabled = v:false
    else
        call system(g:lbs_input_method_inactivate)
    endif
endfunction


" Switch to chinese input method when entering insert mode
function! input_method#Zh()
    let b:current_input_method = "zh"
    if has_key(b:, "rime_enabled")
        let b:rime_enabled = v:true
    endif
    if !<sid>ChineseInputOn()
        call <sid>Active_Input_method()
    endif
    return ""
endfunction

function! input_method#En()
    let b:current_input_method = 'en'
    if <sid>ChineseInputOn() 
        call <SID>Inactive_Input_method()
    endif
    return ""
endfunction

function! input_method#RestoreInsertMode() abort
    if <sid>Is_rime_ls_start()
        return
    endif
    if s:InputMethodOfLastInsertMode() =~? "zh"
        call <sid>Active_Input_method()
    endif
endfunction

function! input_method#LeaveInsertMode() abort
    if <sid>Is_rime_ls_start()
        return
    endif
        
    let b:input_method_of_last_insert_mode =
        \ <SID>ChineseInputOn() ? "zh" : "en"
    call <sid>Inactive_Input_method()
endfunction

function! s:PreviousCharacterIsHalfWidth(preceding_num) abort
    let l:previous_char = s:GetChar_before_cursor(a:preceding_num, 1)
    return cursor_before_char =~? '[\x20-\x7e]'
endfunction

function! input_method#AutoSwitchAfterSpace()
    if <sid>Is_rime_ls_start() || s:GetBufferCurrentInputMethod() !~? 'zh'
        return "\<space>"
    endif

    let cursor_before_char = <SID>GetChar_before_cursor(2, 1)
    if has_key(s:symbol_dict, cursor_before_char)
        let cursor_before_symbol = <SID>GetChar_before_cursor(3, 1)
        if cursor_before_symbol !~? s:character_pattern.ascii
            return ("\<bs>" . s:symbol_dict[cursor_before_char])
        endif
    endif

    if cursor_before_char =~ s:character_pattern.ascii_without_space
        call <sid>Active_Input_method()
    else
        call <sid>Inactive_Input_method()
    endif
    return "\<space>"
endfunction

function! input_method#AutoSwitchAfterBackspace()
    if <sid>Is_rime_ls_start() || s:GetBufferCurrentInputMethod() !~? 'zh'
        return "\<bs>"
    endif

    let cursor_char = <SID>GetChar_before_cursor(2, 1)
    if cursor_char =~? s:character_pattern.space
        let cursor_before_char = <SID>GetChar_before_cursor(3, 1)
    else
        return "\<bs>"
    endif

    " if cursor_char =~? s:character_pattern.ascii
    "     let cursor_before_char = <SID>GetChar_before_cursor(3, 1)
    " else 
    "     let cursor_before_char = <SID>GetChar_before_cursor(5, 1)
    " endif

    if cursor_before_char =~? s:character_pattern.ascii_without_space
        call <sid>Inactive_Input_method()
    elseif cursor_before_char !~? s:character_pattern.space
        call <sid>Active_Input_method()
    endif

    return "\<bs>"
endfunction

