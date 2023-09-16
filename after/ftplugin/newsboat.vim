" Function Definition --------------------------------------------------- {{{1
function! s:get_link_under_cursur_line()
    let content = utils#GetContentBetween('[', ']')
    if content =~? '\v^[0-9]+$'
        return b:newsboat_url_dict[content]
    elseif content =~? '\v\(link #[0-9]+\)'
        let content = substitute(content, '\v.*\(link #([0-9]+)\).*$', '\1', '')
        return b:newsboat_url_dict[content]
    else
        try
            DeleteImage
            catch /Not an editor command/
        endtry
        return ""
    endif
endfunction


function! s:generate_url_dict() " --------------------------------------- {{{1
    if has_key(b:, "newsboat_url_dict") | return | end
    let perl_commands = 'say "$1\t$2\t$3" if m/^\s* \[(\d+)\] :\s+ ([^\s]+) \s \(([^)]+)\) \s*$/x'
    let urls = systemlist("perl -nlE '" . perl_commands . "'", getline(1, '$'))
    let url_dict = {}
    for url in urls
        let info = split(url, '\t')
        let url_dict[info[0]] = { 'url': info[1], 'type': info[2]}
    endfo
    if len(url_dict) != 0
        let b:newsboat_url_dict= url_dict
    endif
endfunction

function! s:mylib_extact_note(line = -1)
    if ! has_key(b:, "mylib_key")
        echo "Need save html file to lib first"
        return
    endif
    if @+ == "" | return | end
    let ori = @+
    let @+ = "\n#+begin_quote\n" . trim(@+) . "\n#+end_quote\n"
    let current_wnr = bufwinid('%')

    Mylib note quiet
    let note_wnr = bufwinid(b:mylib_note)
      
    if note_wnr == -1
        Mylib note
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

function! s:cache_link_snapshot()
    if has_key(b:, "newsboat_link_cached") | return | end
    if !has_key(b:, "newsboat_url_dict") | return | end
    let tmpfile = tempname()
    let url_list = []
    for i in keys(b:newsboat_url_dict)
        let url = b:newsboat_url_dict[i]
        echom url['url']
        call insert(url_list, url['url'] . "\t" . url['type'])
    endfor
    call system("cat >" . tmpfile, url_list)
    call asyncrun#run("", {'silent': 1, 'pos': 'hide'}, "cache_url_snapshot " . tmpfile)
    let b:newsboat_link_cached = v:true
endfunction

" set options ----------------------------------------------------------- {{{1
call s:generate_url_dict()
call utils#Fetch_urls()
call s:cache_link_snapshot()
set wrap

" Keymap ---------------------------------------------------------------- {{{1
nnoremap <silent><buffer> <localleader>s :Mylib new<cr>
nnoremap <silent><buffer> <localleader>e :Mylib edit<cr>
nnoremap <silent><buffer> <localleader>n :Mylib note<cr>
nnoremap <silent><buffer> <localleader>O :Urlopen<cr>
nnoremap <silent><buffer> <localleader>o "+yiu:call utils#OpenUrl(@+, "in")<cr>
vnoremap <silent><buffer> <localleader>y "+y:<c-u>call <sid>mylib_extact_note()<cr>
nnoremap <silent><buffer> <localleader>y vip"+y:<c-u>call <sid>mylib_extact_note()<cr>
nnoremap <silent><buffer> <localleader>q :qall<cr>
nnoremap <silent><buffer> <enter> :<c-u>call utils#OpenUrl(<sid>get_link_under_cursur_line(), "in")<cr>

