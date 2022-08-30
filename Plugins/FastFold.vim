let g:tex_fold_enabled=1
let g:vimsyn_folding='af'
let g:xml_syntax_folding = 1
let g:javaScript_fold = 1
let g:ruby_fold = 1
let g:sh_fold_enabled= 7
let g:php_folding = 1
let g:perl_fold = 1
let g:r_syntax_folding = 1
let g:markdown_folding = 1
let g:pandoc_folding = 1
let g:rmd_folding = 1


nnoremap <silent> <leader>zu <Plug>(FastFoldUpdate)
xnoremap iz :<c-u>FastFoldUpdate<cr><esc>:<c-u>normal! ]zv[z<cr>
xnoremap az :<c-u>FastFoldUpdate<cr><esc>:<c-u>normal! ]zV[z<cr>
