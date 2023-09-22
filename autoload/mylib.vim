let s:mylib_command_list = ['new', 'tag', 'note', 'edit', 'open']

function! s:mylib_new() abort
    if has_key(b:, "mylib_key") && b:mylib_key != ""
        return b:mylib_key
    endif
    if &filetype ==# "newsboat"
        let url = b:fetched_urls[0]
        if url == "" | return | endif
        let b:mylib_key = system("mylib new '" . url . "'")
    else
        let key = substitute(expand("%:t"), '\.\w\+$', "", "")
        let key = system("mylib get md5_long -- " . key)
        if key == "" | return | endif
        let b:mylib_key = key
    endif
    let file = system("mylib get html -- '" . b:mylib_key . "'")
    let file = fnamemodify(file, ":p:r") . ".newsboat"
    if filereadable(file)
        normal! ggdG
        exec "read " . file
        normal! ggdd
    endif
    setlocal buftype=
    exec 'file! ' . file
    exec 'write! ' . file
    return b:mylib_key
endfunction

function! s:mylib_edit()
    call s:mylib_new()
    call system("mylib edit " . b:mylib_key)
endfunction

function! s:mylib_note(method = "")
    call s:mylib_new()
    if ! has_key(b:, "mylib_note")
        let b:mylib_note = system("mylib note " . b:mylib_key)
    endif
    if b:mylib_note ==# @%  | return | endif
    if a:method ==? "quiet" | return | endif

    let note_wnr = bufwinid(b:mylib_note)
    if note_wnr != -1
        return win_gotoid(note_wnr)
    endif

    let method = a:method
    if method == ""
        if &columns < 120
            let method = "split"
        else
            let method = "vsplit"
        endif
    endif
    exec method . " " . b:mylib_note
endfunction


function! s:mylib_tag(...)
    let tags = join(a:000, ":")
    if ! has_key(b:, "mylib_key") | return | endif
    let tags = system("mylib tag -o " . tags . " -- " . b:mylib_key)
    if tags == "" | return | endif

    Mylib note
    normal! mmgg
    let filtag_pos = searchpos('^#+filetags:', 'nW')[0]
    let titletag_pos = searchpos('^#+title:', 'nW')[0]
    if filtag_pos != 0
        call setline(filtag_pos, "#+filetags: :". tags . ":")
    elseif titletag_pos != 0
        exec "normal! " . titletag_pos . "Go"
        call setline(titletag_pos + 1, "#+filetags: :". tags . ":")
    endif
    normal! 'm
endfunction

function! mylib#run(command, ...)
    call call("s:mylib_" . a:command, a:000)
endfunction

function! mylib#Complete(ArgLead, CmdLine, CursorPos)
    let len = len(a:ArgLead)
    let ret = {}
    for command in s:mylib_command_list
        if command[0:(len-1)] ==# a:ArgLead 
            let ret[command] = 1
        endif
    endfor
    return sort(keys(ret))
endfunction
