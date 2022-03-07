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
