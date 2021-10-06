" vim source for stata
function! coc#source#StataVariables#init() abort
  return {
        \ 'priority': 9,
        \ 'shortcut': 'StataVar',
        \ 'filetypes': ['stata'],
        \ 'triggerCharacters': [''],
        \ 'firstMatch': 0,
        \}
endfunction

function! coc#source#StataVariables#complete(opt, cb) abort
  let items = split(system("cut -f1 ./.varlist.tsv"), "\n")
  call a:cb(items)
endfunction
