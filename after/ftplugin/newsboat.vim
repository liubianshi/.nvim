" Function Definition --------------------------------------------------- {{{1
function! s:mylib_new()
    if has_key(b:, "mylib_key") | return | endif
    let url = b:fetched_urls[0]
    if url != ""
        let b:mylib_key = system("mylib new '" . url . "'")
    endif
endfunction

function! s:mylib_edit()
    call s:mylib_new()
    call system("mylib edit " . b:mylib_key)
endfunction

function! s:mylib_note(method = "vsplit")
    call s:mylib_new()
    if ! has_key(b:, "mylib_note")
        let b:mylib_note = system("mylib note " . b:mylib_key)
    endif
    if a:method !=? "quiet"
        exec a:method . " " . b:mylib_note
    endif
endfunction

function! s:mylib_extact_note(line = -1)
    if @+ == "" | return | end
    let ori = @+
    let @+ = "\n#+begin_quote\n" . trim(@+) . "\n#+end_quote\n"
    let current_wnr = bufwinid('%')

    call s:mylib_note("quiet")
    let note_wnr = bufwinid(b:mylib_note)
      
    if note_wnr == -1
        exec "vsplit " . b:mylib_note
    else
        call win_gotoid(note_wnr)
    endif    

    if a:line == -1
        normal! Gzt
    else
        exec "normal! " . a:line . 'Gzt'
    endif

    normal! "+p
    let @+ = ori
    write
    call win_gotoid(current_wnr)
endfunction

" Basic Setting
if !has_key(b:, "fetched_urls")
    let b:fetched_urls = systemlist("xurls", getline(1, '$'))
endif
set wrap

" Keymap ---------------------------------------------------------------- {{1
nnoremap <silent><buffer> <localleader>s :call <sid>mylib_new()<cr>
nnoremap <silent><buffer> <localleader>e :call <sid>mylib_edit()<cr>
nnoremap <silent><buffer> <localleader>n :call <sid>mylib_note()<cr>
nnoremap <silent><buffer> <localleader>o :Urlopen<cr>
vnoremap <silent><buffer> <localleader>y "+y:<c-u>call <sid>mylib_extact_note()<cr>

