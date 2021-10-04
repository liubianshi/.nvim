augroup tex_textobjs
    autocmd!
    autocmd FileType tex call textobj#user#plugin('tex', {
    \   'paren-math': {
    \     'pattern': ['\\left(', '\\right)'],
    \     'select-a': '<buffer> a(',
    \     'select-i': '<buffer> i(',
    \   },
    \ })
    autocmd FileType stata call textobj#user#plugin('stata', {
    \   'macro-local': {
    \     'pattern': ['`', "'"],
    \     'select-a': '<buffer> a`',
    \     'select-i': '<buffer> i`',
    \   },
    \   'macro-global': {
    \     'pattern': ['\$', " "],
    \     'select-a': '<buffer> a$',
    \     'select-i': '<buffer> i$',
    \   },
    \ })
augroup END
