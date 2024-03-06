runtime macros/sandwich/keymap/surround.vim
let g:sandwich#recipes += [
    \   {
    \      'buns': ["`", "'"],
    \      'filetype': ["stata"],
    \      'nesting': 1,
    \      'kind': ["add", "delete", "replace", 'textobj'],
    \      'input': ["`"]
    \   },
    \   {
    \      'buns': ["[[", "]]"],
    \      'filetype': ["markdown"],
    \      'nesting': 1,
    \      'kind': ["add", "delete", "replace", 'textobj'],
    \      'input': ["w"]
    \   },
    \   {
    \      'buns': ["==", "=="],
    \      'filetype': ["markdown"],
    \      'nesting': 1,
    \      'kind': ["add", "delete", "replace", 'textobj'],
    \      'input': ["h"]
    \   },
    \   {
    \      'buns': ['`"', "\"'"],
    \      'filetype': ["stata"],
    \      'nesting': 1,
    \      'kind': ["add", "delete", "replace", 'textobj'],
    \      'input': ["'"]
    \   }
    \ ]

