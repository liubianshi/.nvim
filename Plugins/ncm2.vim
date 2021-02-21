let g:ncm2_raku_source = {
    \ 'name': 'raku',
    \ 'priority': 8,
    \ 'auto_popup': 1,
    \ 'complete_length': 2,
    \ 'scope': ['raku', 'perl6'],
    \ 'mark': 'raku',
    \ 'enable': 1,
    \ 'word_pattern': "[A-za-z_]([\'\-]?[A-Za-z_]+)*",
    \ 'on_complete': 'ncm2_bufword#on_complete',
    \ }
let g:ncm2_r_source = {
    \ 'name': 'r',
    \ 'priority': 9,
    \ 'auto_popup': 1,
    \ 'complete_length': 2,
    \ 'scope': ['r', 'R','Rmd', 'rmd', 'rmarkdown'],
    \ 'mark': 'r',
    \ 'word_pattern': '[\w.]+',
    \ 'on_complete': ['ncm2_bufword#on_complete'],
    \ }
