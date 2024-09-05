function s:MylibOpen()
    let fname = expand('%')
    Mylib new
    if ! has_key(b:, "mylib_key")
        return
    endif
    Mylib open
    let b:mylib_note = fname
endfunction

nnoremap <buffer><silent> <localleader>ms :<c-u>call <sid>MylibOpen()<cr>

" nnoremap <buffer><silent> <localleader>il :<c-u>call ref_link#add()<cr>
" inoremap <buffer><silent> <localleader>il <esc>:<c-u>call ref_link#add()<cr>

xnoremap <buffer><silent> ic :<C-U>call text_obj#MdCodeBlock('i')<CR>
xnoremap <buffer><silent> ac :<C-U>call text_obj#MdCodeBlock('a')<CR>
onoremap <buffer><silent> ic :<C-U>call text_obj#MdCodeBlock('i')<CR>

nnoremap <buffer><silent> <M-t> :<c-u>Voom pandoc<cr>

inoremap <buffer> ;b              ** **<C-o>F <c-o>x
inoremap <buffer> ;h              == ==<C-o>F <c-o>x


inoremap <buffer><silent> <localleader><enter> 
    \ <esc>?\v[,.:?")，。)，。：》”；？、」） ]<cr>:noh<cr>a<enter><esc>`^A

" preview markdown snippet ============================================== {{{1
nnoremap <A-v> vip:call utils#MdPreview()<cr>
nnoremap <A-V> vip:call utils#MdPreview(1)<cr>
vnoremap <A-v> :call utils#MdPreview()<cr>
vnoremap <A-V> :call utils#MdPreview(1)<cr>

nnoremap <buffer> <localleader>ic ysiW`
if !has('mac')
    nnoremap <buffer> <silent> <localleader>nH
        \ :!!pandoc --from=markdown+east_asian_line_breaks -t html - \| xclip -t text/html -sel clip -i<cr>
    noremap <buffer> <silent> <localleader>nh
        \ :r  !xclip -o -t text/html -sel clip \| pandoc -f html -t markdown_strict<cr>
endif

setlocal formatoptions=tcq,ro/,n,lm]1,Bj tabstop=2 shiftwidth=2

" setlocal foldexpr=nvim_treesitter#foldexpr() foldmethod=expr foldlevel=99 foldlevelstart=99

"set formatexpr=format#Markdown()
let &l:formatprg="text_wrap"
let &l:formatlistpat = '^\s*\d\+\.\s\+\|^\[-*+>]\s\+\|^\s*\[^[^\]]\+\]\[:\s]'
setlocal nonumber norelativenumber
" call utils#ToggleZenMode()

" UltiSnipsAddFiletype rmd.r.markdown.pandoc
