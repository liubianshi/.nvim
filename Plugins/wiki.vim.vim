let g:wiki_root = '/home/liubianshi/Documents/WikiHome'
let g:wiki_cache_root = '~/.cache/wiki.vim'
let g:wiki_link_target_type = 'md'
let g:wiki_filetypes = ['md', 'pandoc', 'rmd', 'Rmd', 'tex']
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
