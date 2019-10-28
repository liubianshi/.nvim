augroup my_cm_setup
    autocmd!
    autocmd FileType * call ncm2#enable_for_buffer()
    set completeopt=noinsert,menuone,noselect
    "" Pandoc-Vim
    autocmd Filetype pandoc,rmd,rmarkdown,rmd.rmarkdown call ncm2#register_source({
        \ 'name': 'pandoc',
        \ 'priority': 8,
        \ 'scope': ['pandoc', 'markdown', 'rmarkdown', 'rmd'],
        \ 'mark': 'pandoc',
        \ 'word_pattern': '\w+',
        \ 'complete_pattern': ['@'],
        \ 'on_complete': ['ncm2#on_complete#omni', 'pandoc#completion#Complete'],
        \ })
    autocmd FileType r,rmd,rmarkdown,rmd.rmarkdown call ncm2#register_source({
        \ 'name': 'r',
        \ 'priority': 9,
        \ 'scope': ['r', 'rmd', 'rmarkdown'],
        \ 'mark': 'r',
        \ 'word_pattern': '[\w.]+',
        \ 'on_complete': ['ncm2_bufword#on_complete'],
        \ })
    " vimtex 配置
    autocmd Filetype tex call ncm2#register_source({
            \ 'name' : 'vimtex-cmds',
            \ 'priority': 8,
            \ 'complete_length': -1,
            \ 'scope': ['tex'],
            \ 'matcher': {'name': 'prefix', 'key': 'word'},
            \ 'word_pattern': '\w+',
            \ 'complete_pattern': g:vimtex#re#ncm2#cmds,
            \ 'on_complete': ['ncm2#on_complete#omni', 'vimtex#complete#omnifunc'],
            \ })
    autocmd Filetype tex call ncm2#register_source({
            \ 'name' : 'vimtex-labels',
            \ 'priority': 8,
            \ 'complete_length': -1,
            \ 'scope': ['tex'],
            \ 'matcher': {'name': 'combine',
            \             'matchers': [
            \               {'name': 'substr', 'key': 'word'},
            \               {'name': 'substr', 'key': 'menu'},
            \             ]},
            \ 'word_pattern': '\w+',
            \ 'complete_pattern': g:vimtex#re#ncm2#labels,
            \ 'on_complete': ['ncm2#on_complete#omni', 'vimtex#complete#omnifunc'],
            \ })
    autocmd Filetype tex call ncm2#register_source({
            \ 'name' : 'vimtex-files',
            \ 'priority': 8,
            \ 'complete_length': -1,
            \ 'scope': ['tex'],
            \ 'matcher': {'name': 'combine',
            \             'matchers': [
            \               {'name': 'abbrfuzzy', 'key': 'word'},
            \               {'name': 'abbrfuzzy', 'key': 'abbr'},
            \             ]},
            \ 'word_pattern': '\w+',
            \ 'complete_pattern': g:vimtex#re#ncm2#files,
            \ 'on_complete': ['ncm2#on_complete#omni', 'vimtex#complete#omnifunc'],
            \ })
    autocmd Filetype tex call ncm2#register_source({
            \ 'name' : 'bibtex',
            \ 'priority': 8,
            \ 'complete_length': -1,
            \ 'scope': ['tex'],
            \ 'matcher': {'name': 'combine',
            \             'matchers': [
            \               {'name': 'prefix', 'key': 'word'},
            \               {'name': 'abbrfuzzy', 'key': 'abbr'},
            \               {'name': 'abbrfuzzy', 'key': 'menu'},
            \             ]},
            \ 'word_pattern': '\w+',
            \ 'complete_pattern': g:vimtex#re#ncm2#bibtex,
            \ 'on_complete': ['ncm2#on_complete#omni', 'vimtex#complete#omnifunc'],
            \ })
augroup END

