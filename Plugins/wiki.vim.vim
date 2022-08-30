let g:wiki_root = "~/Documents/Writing/Knowledge"
let g:wiki_link_target_type = 'md'
let g:wiki_filetypes = ['md', 'pandoc', 'rmd', 'Rmd', 'tex', 'org']
let g:wiki_mappings_use_defaults = 'none'
let g:wiki_journal = {
    \ 'name': 'journal',
    \ 'frequency': 'daily',
    \ 'date_format': {
    \   'daily' : '%Y-%m-%d',
    \   'weekly' : '%Y_w%V',
    \   'monthly' : '%Y_m%m',
    \ },
    \}

nnoremap <silent> <leader>fw  :WikiFzfPages<CR>
" wiki.vim{{{1
let g:wiki_mappings_global = {
        \ '<plug>(wiki-index)'   : '<leader>ew',
        \ '<plug>(wiki-journal)' : '<leader>ej',
        \ '<plug>(wiki-open)'    : '<leader>en',
        \ '<plug>(wiki-reload)'  : '<tab>wx',
        \}

let g:wiki_mappings_local = {
        \ '<plug>(wiki-page-delete)'     : '<tab>wd',
        \ '<plug>(wiki-page-rename)'     : '<tab>wr',
        \ '<plug>(wiki-list-toggle)'     : '<tab><c-s>',
        \ '<plug>(wiki-page-toc)'        : '<tab>wt',
        \ '<plug>(wiki-page-toc-local)'  : '<tab>wT',
        \ '<plug>(wiki-link-follow)'       : '<tab><cr>',
        \ 'x_<plug>(wiki-link-follow)'     : '<tab><cr>',
        \ '<plug>(wiki-link-follow-vsplit)' : '<tab><c-cr>',
        \ '<plug>(wiki-link-return)'     : '<tab><bs>',
        \ '<plug>(wiki-link-next)'       : '<tab><down>',
        \ '<plug>(wiki-link-prev)'       : '<tab><up>',
        \}
