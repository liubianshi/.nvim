let g:wiki_root = "~/Documents/Writing/Knowledge"
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
