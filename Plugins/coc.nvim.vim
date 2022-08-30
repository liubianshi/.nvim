let g:coc_global_extensions = [
            \ 'coc-yank',
            \ 'coc-vimlsp',
            \ 'coc-ultisnips',
            \ 'coc-syntax',
            \ 'coc-omni',
            \ 'coc-marketplace',
            \ 'coc-dictionary',
            \ 'coc-json',
            \ 'coc-lua',
            \ 'coc-db',
            \ 'coc-sql',
            \ 'coc-sh',
            \ 'coc-pyright',
            \ 'coc-clangd',
            \ 'coc-r-lsp',
            \ ]

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
" from Coc suggest config
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" objects: ctags and gtags {{{1
"nmap <silent> gd <Plug>(coc-definition)
"nmap <silent> gr <Plug>(coc-references)
