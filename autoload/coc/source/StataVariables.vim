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
    let items = b:macrolist + b:varlist + b:graphlist + b:keywordlist
    call a:cb(items)
endfunction
