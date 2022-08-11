" Load Once: {{{2
if &cp || exists("g:loaded_fcitx_auto_toggle") || (!exists('$DISPLAY') && !exists('$WAYLAND_DISPLAY'))
  finish
endif

" 获取光标前 b 个字符开始的 l 个字符 {{{2
function! s:GetChar_before_cursor(b, l = 1)
    return getline('.')[max([0, col('.') - a:b]):col('.') - max([0, a:b - a:l + 1])]
endfunction

" 判断当前环境是否为中文输入法 {{{3
function! s:ChineseInputOn()
    return (trim(system(g:lbs_input_status)) == g:lbs_input_method_on)
endfunction

"echo "Change to Chinese Mode" {{{2
function! Lbs_Input_Env_Zh(insert_entry = 0)
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
        let g:LBS_INPUT_ENV = 1
        if !<SID>ChineseInputOn()
            call system(g:lbs_input_method_activate)
        endif
    endif
    return("")
endfunction

"echo "Change to English Mode" {{{2
function! Lbs_Input_Env_En(insert_leave = 0)
    if a:insert_leave == '1'
        if <SID>ChineseInputOn()
            let b:inputtoggle = 1
            call system(g:lbs_input_method_inactivate)
        endif
    else
        let g:LBS_INPUT_ENV = 0
        if <SID>ChineseInputOn()
            call system(g:lbs_input_method_inactivate)
        endif
    endif
    return("")
endfunction

" 自动切换输入中文输入法 {{{2
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

" 通过 space 实现自动切换 {{{2
function! Lbs_Space(symbol_dict)
    if !(exists("g:LBS_INPUT_ENV") && g:LBS_INPUT_ENV == 1)
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
function! Lbs_bs()
    if !(exists("g:LBS_INPUT_ENV") && g:LBS_INPUT_ENV == 1)
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

let g:loaded_fcitx_auto_toggle = 1
" 加载自动命令 {{{2
let symbol_dict = {
            \  ',': "，",
            \  '.': "。",
            \  '\': "、",
            \  ':': "：",
            \  ';': "；",
            \  '!': "！",
            \  '?': "？",
            \  }
augroup Fcitx
    autocmd!
    autocmd InsertLeavePre * call Lbs_Input_Env_En(1)
    autocmd InsertEnter * call Lbs_Input_Env_Zh(1)
    autocmd CmdlineEnter [/\?] call Lbs_Input_Env_Zh(1)
    autocmd CmdlineLeave [/\?] call Lbs_Input_Env_En(1)
    autocmd BufRead,BufNew *.hlp,*.md,*.[Rr]md,*.[Rr]markdown,*.org inoremap <silent><expr><buffer>
                \ <space>  Lbs_Space(symbol_dict)
    autocmd BufRead,BufNew *.hlp,*.md,*.[Rr]md,*.[Rr]markdown,*.org inoremap <silent><expr><buffer>
                \ <bs> Lbs_bs()
    autocmd FileType mail,org inoremap <silent><expr><buffer> <space>  Lbs_Space(symbol_dict)
    autocmd FileType mail,org inoremap <silent><expr><buffer> <bs> Lbs_bs()
augroup END
