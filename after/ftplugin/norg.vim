" Text objects for Markdown code blocks.
inoremap <buffer> ;c              ` `<C-o>F <c-o>x
inoremap <buffer> ;m              $ $<C-o>F <c-o>x

if &l:foldmethod ==? 'manual' && ! v:lua.BufIsBig()
    setlocal foldexpr=nvim_treesitter#foldexpr()
    setlocal foldmethod=expr
endif

setlocal conceallevel=2
let &l:formatlistpat = '^\s*[-\d~]\+[\]:.)}\t\s]\s*'


