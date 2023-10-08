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
    let file = fnameescape(file)
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

function! s:mylib_note(method = "") abort
    call s:mylib_new()
    if ! has_key(b:, "mylib_note")
        let b:mylib_note = system("mylib note " . b:mylib_key)
    endif
    if b:mylib_note ==# @%  | return | endif
    if ! bufloaded(b:mylib_note)
        let bufnr = bufadd(b:mylib_note)
        call bufload(bufnr)
    endif

    if a:method ==? "quiet" | return | endif

    let note_wnr = bufwinid(b:mylib_note)
    if note_wnr != -1
        return win_gotoid(note_wnr)
    endif

    let method = a:method
    if method ==? "popup"
        normal zt
        let notebufnr = bufadd(b:mylib_note)
        exec 'lua require("ui").mylib_popup(' . notebufnr . ')'
    elseif method == "" &&  &columns < 120
        exec "split " . b:mylib_note
    elseif method == "" &&  &columns >= 120
        exec "vsplit " . b:mylib_note
        wincmd L
    else
        exec method . " " . b:mylib_note
    endif
endfunction


function! s:mylib_tag(...)
    let tags = join(a:000, ":")
    if ! has_key(b:, "mylib_key") | return | endif
    let tags = system("mylib tag -o " . tags . " -- " . b:mylib_key)
    if tags == "" | return | endif

    Mylib note popup
    normal! mmgg
    let filtag_pos = searchpos('^#+filetags:', 'nW')[0]
    let titletag_pos = searchpos('^#+title:', 'nW')[0]
    if filtag_pos != 0
        call setline(filtag_pos, "#+filetags: :". tags . ":")
    elseif titletag_pos != 0
        exec "normal! " . titletag_pos . "G"
        call append(titletag_pos, "#+filetags: :". tags . ":")
    endif
    write
    wincmd w
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

