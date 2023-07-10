" Text objects for Markdown code blocks.
xnoremap <buffer><silent> ic :<C-U>call text_obj#MdCodeBlock('i')<CR>
xnoremap <buffer><silent> ac :<C-U>call text_obj#MdCodeBlock('a')<CR>
onoremap <buffer><silent> ic :<C-U>call text_obj#MdCodeBlock('i')<CR>


inoremap <buffer> ;1              <esc>0i#<space><esc>A
inoremap <buffer> ;2              <esc>0i##<space><esc>A
inoremap <buffer> ;3              <esc>0i###<space><esc>A
inoremap <buffer> ;c              ` `<C-o>F <c-o>x
inoremap <buffer> ;m              $ $<C-o>F <c-o>x

if &l:foldmethod ==? 'manual' && ! v:lua.BufIsBig()
    setlocal foldexpr=nvim_treesitter#foldexpr()
    setlocal foldmethod=expr
endif
let &l:formatlistpat = '^\s*[-\d~]\+[\]:.)}\t ]\s*'
