function! ref_link#GetID(url) abort
    let links_line = search('^<!-- Links -->$', 'n')
    if links_line == 0
        call append(line('$'), ["<!-- Links -->", "[1]: " .. a:url])
        return '1'
    endif
    let lno = links_line
    let linkid = 0
    while (lno <= line('$'))
        let lno += 1
        let line = getline(lno)
        let match_re = matchlist(line, '\v^\[([0-9]+)\]:\s+(.*)\s*$') 
        if len(match_re) == 0 | continue | endif
        let linkid = match_re[1]
        if match_re[2] ==? a:url
            return linkid
        endif
    endwhile
    call append(line('$'), "\[" . (linkid + 1) . "\]: " . a:url)
    return (linkid + 1)
endfunction

function! ref_link#add() abort
    let url = trim(getreg('+'))
    if url !~? '\v^https?:\/\/'
        let url = trim(input("Input url: "))
        call inputrestore()
        echo ""
        if url == '' | return | endif
    endif
    let linkid = ref_link#GetID(url)
    let title = utils#GetContentBetween('[', ']')
    if title == ""
        let title = trim( system('fetch-url-info "' . url . '"') )
        call luaeval('vim.api.nvim_put({_A}, "c", true, true)', " [" . title . "][" . linkid . "]")
    else
        if col('.') == 1
            normal! f]
        else
            normal! hf]
        endif
        call luaeval('vim.api.nvim_put({_A}, "c", true, true)', "[" . linkid . "]")
    endif    
endfun

