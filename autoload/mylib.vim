let s:mylib_command_list = ['new', 'tag', 'note', 'edit', 'open']
let s:note_type = "obsidian"

function! s:mylib_open(method = "vsplit")
    call s:mylib_new()
    if ! has_key(b:, "mylib_key") || b:mylib_key == ""
        call luaeval('vim.notify("No related library iterm!!", "Error", {title = "Mylib"})')
        return v:false
    endif

    let paper = system("mylib get newsboat -- " .. b:mylib_key)
    if paper !=? ""
        let key = b:mylib_key
        let paper = fnameescape(trim(paper))
        exec a:method . " " . paper
        let b:mylib_key = key
        call utils#ToggleZenMode()
    else
        call job_start(["mylib", "open", b:mylib_key])
    endif

    return v:true
endfunction

function! s:mylib_edit()
    call s:mylib_new()
    if ! has_key(b:, "mylib_key") || b:mylib_key == ""
        call luaeval('vim.notify("No related library iterm!!", "Error", {title = "Mylib"})')
        return v:false
    endif

    call job_start(["mylib", "edit", "--", b:mylib_key])
    return v:true
endfunction

function! s:gen_newsboat_base_current_buffer(url)
    let key = systemlist("mylib new --nonewsboat '" . a:url . "'")[-1]
    let key = trim(key)
    if key !~? '\v[a-f0-9]{32}'
        lua vim.notify("Failed to generate mylibrary entry", vim.log.levels.ERROR)
        return ""
    endif

    let filename = system("mylib get html -- '" . key . "'")
    let filename = fnamemodify(filename, ":p:r") . ".newsboat"
    let filename_escape = fnameescape(filename)
    if filereadable(filename)
        let bufnr = bufnr()
        exec "edit " . filename_escape
        call utils#ToggleZenMode()
        exec "bwipeout " . bufnr
    else
        setlocal buftype=
        exec 'write ' . fnameescape(filename)
    endif
    return key
endfunction


function! s:mylib_new(item = "", cmd = "vsplit") abort
    if a:item != ""
        let key = system("mylib new " . shellescape(a:item))
        let key = trim(key)
        if key =~? '\v^[a-f0-9]{32}$' 
            let filename = system("mylib get newsboat -- '" . key . "'")
            let filename = fnameescape(trim(filename))
            exec a:cmd . " " . filename
            let b:mylib_key = key
            return b:mylib_key
        endif
        return
    endif
    if has_key(b:, "mylib_key") && b:mylib_key != ""
        return b:mylib_key
    endif
    let key = system("mylib get md5_long -- " . fnameescape(expand('%')))
    let key = trim(key)
    if key =~? '\v^[a-f0-9]{32}$' 
        let b:mylib_key = key
        return b:mylib_key
    endif

    if &filetype !=? 'newsboat'
        let b:mylib_key = system("mylib get md5_long")
        return b:mylib_key
    endif

    let url = b:fetched_urls[0]
    if url == "" | return | endif
    let linenum = line('$')

    if linenum > 15
        let key = s:gen_newsboat_base_current_buffer(url)
        let b:mylib_key = key
    else
        let key = systemlist("mylib new '" . url . "'")[-1]
        let filename = system("mylib get newsboat -- '" . key . "'")
        " let filename_escape = fnameescape(filename)
        let bufnr = bufnr()
        exec "edit " . filename
        let b:mylib_key = key
        call utils#ToggleZenMode()
        exec "bwipeout " . bufnr
    endif

    return b:mylib_key
endfunction

function! s:mylib_edit()
    call s:mylib_new()
    call system("mylib edit " . b:mylib_key)
endfunction

function! s:mylib_note(method = "") abort
    call s:mylib_new()
    if ! has_key(b:, "mylib_note")
        let b:mylib_note = system("mylib note --type " . s:note_type . " " . b:mylib_key)
    endif
    if b:mylib_note ==# @%  | return | endif

    let bufnr = bufnr(b:mylib_note, 1)
    if bufnr == 0 | return 0 | endif
    if ! bufloaded(b:mylib_note) | call bufload(bufnr) | endif

    if a:method ==? "quiet" | return | endif

    let note_wnr = bufwinid(bufnr)
    if note_wnr != -1
        return win_gotoid(note_wnr)
    endif
    let method = a:method
    let notepath = fnameescape(b:mylib_note)
    if method ==? "popup"
        exec 'lua require("util.ui").mylib_popup(' . bufnr . ')'
    elseif method == "" &&  &columns < 120
        exec "split " . notepath
    elseif method == "" &&  &columns >= 120
        exec "vsplit " . notepath
        wincmd L
    else
        exec method . " " . notepath
    endif
endfunction


function! s:mylib_tag(...)
    let tags = join(a:000, ":")
    if ! has_key(b:, "mylib_key") | return | endif
    let tags = system("mylib tag -o " . tags . " -- " . b:mylib_key)
    if tags == "" | return | endif

    if ! has_key(b:, "mylib_note") 
      let notes = systemlist("mylib get note -- " . b:mylib_key)
      let no_notes = v:true
      for nt in notes
        if split(nt, ":")[0] == s:note_type 
          let no_notes = v:false
          break
        endif
      endfor
      if no_notes | return | end
    endif

    Mylib note popup
    normal! mmgg
    if &filetype == "org"
        let filetags = searchpos('^#+filetags:', 'nW')[0]
        let titletag_pos = searchpos('^#+title:', 'nW')[0]
        if filetags != 0
            call setline(filetags, "#+filetags: :". tags . ":")
        elseif titletag_pos != 0
            exec "normal! " . titletag_pos . "G"
            call append(titletag_pos, "#+filetags: :". tags . ":")
        endif
    elseif &filetype == "markdown" && match(getline(1), '\v^\-{3,}') == 0
        let tags_line = searchpos('^tags:', 'nW')[0]
        let end_meta_line = searchpos('\v^\-{3,}')[0]
        if end_meta_line == 0 | return | end

        let tags = "tags: [" . join(map(split(tags, "[:：]"), '"\"" . v:val . "\""'), ", ") .. "]"
        if tags_line != 0
            while(getline(tags_line + 1) =~? '\v^\s+\-')
                exec 'normal! ' . (tags_line + 1) . "Gdd"
            endwhile
            call setline(tags_line, tags)
        else
            call append(end_meta_line - 1, tags)
        endif
    endif

    normal! `m
    write
    if win_gettype() == "popup"
        quit
    else
        wincmd p
    endif
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

