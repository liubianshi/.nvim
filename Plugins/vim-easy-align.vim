" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

let g:easy_align_delimiters = {
\ '>': { 'pattern': '>>\|=>\|>' },
\ '/': {
\     'pattern':         '//\+\|/\*\|\*/',
\     'delimiter_align': 'l',
\     'ignore_groups':   [] },
\ ']': {
\     'pattern':       '[[\]]',
\     'left_margin':   0,
\     'right_margin':  0,
\     'stick_to_left': 0
\   },
\ ')': {
\     'pattern':       '[()]',
\     'left_margin':   0,
\     'right_margin':  0,
\     'stick_to_left': 0
\   },
\ 'd': {
\     'pattern':      ' \(\S\+\s*[;=]\)\@=',
\     'left_margin':  0,
\     'right_margin': 0
\   },
\ '|': {
\     'pattern': ' %>\S*%\| |>',
\     'left_margin': 4,
\     'right_margin': 0,
\     'delimiter_align': 'l',
\     'stick_to_left': 0
\   },
\ '<': {
\    'pattern': '<-',
\     'left_margin': 1,
\     'right_margin': 1,
\     'delimiter_align': 'l',
\     'stick_to_left': 0
\   }
\ }

