inoremap <buffer> ;<enter> <cr><tab>\<space>
setlocal foldmethod=expr
setlocal foldexpr=fold#GetFold()
