xnoremap <buffer><silent> ic :<C-U>call text_obj#MdCodeBlock('i')<CR>
xnoremap <buffer><silent> ac :<C-U>call text_obj#MdCodeBlock('a')<CR>
onoremap <buffer><silent> ic :<C-U>call text_obj#MdCodeBlock('i')<CR>

nnoremap <buffer><silent> <M-t> :<c-u>Voom pandoc<cr>

inoremap <buffer> ;1              <esc>0i#<space><esc>A
inoremap <buffer> ;2              <esc>0i##<space><esc>A
inoremap <buffer> ;3              <esc>0i###<space><esc>A
inoremap <buffer> ;-              <esc>^d0i-<tab><esc>A
inoremap <buffer> ;_              <esc>^d0i<tab>-<tab><esc>A
inoremap <buffer> ;=              <esc>^d0i1.<tab><esc>A
inoremap <buffer> ;+              <esc>^d0i<tab>1.<tab><esc>A
inoremap <buffer> ;c              ` `<C-o>F <c-o>x
inoremap <buffer> ;m              $ $<C-o>F <c-o>x
inoremap <buffer> ;i              * *<C-o>F <c-o>x
inoremap <buffer> ;b              ** **<C-o>F <c-o>x

" preview markdown snippet ============================================== {{{1
nnoremap <A-v> vip:call utils#MdPreview()<cr>
nnoremap <A-V>V vip:call utils#MdPreview(1)<cr>
vnoremap <A-v> :call utils#MdPreview()<cr>
vnoremap <A-V> :call utils#MdPreview(1)<cr>

nnoremap <buffer> <localleader>ic ysiW`
if !has('mac')
    nnoremap <buffer> <silent> <localleader>nH
        \ :!!pandoc --from=markdown+east_asian_line_breaks -t html - \| xclip -t text/html -sel clip -i<cr>
    noremap <buffer> <silent> <localleader>nh
        \ :r  !xclip -o -t text/html -sel clip \| pandoc -f html -t markdown_strict<cr>
endif

setlocal formatoptions=tcq,ro/,n,lm]1,Bj tabstop=4 shiftwidth=4

"set formatexpr=format#Markdown()
let &l:formatprg="prettier --tab-width 4 --parser markdown"
let &l:formatlistpat = '^\s*\d\+\.\s\+\|^[-*+]\s\+\|^\[^\ze[^\]]\+\]:'

" UltiSnipsAddFiletype rmd.r.markdown.pandoc
