let g:fzf_command_prefix = 'Fzf'    " 给 fzf.vim 命令加前缀

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" fzf search
nnoremap <silent> <leader>ff  :FzfFiles<CR>
nnoremap <silent> <leader>fb  :FzfBuffers<CR>
nnoremap <silent> <leader>fc  :FzfColors<CR>
nnoremap <silent> <leader>fa  :<c-u>FzfAg 
nnoremap <silent> <leader>fh  :FzfHistory<CR>
nnoremap <silent> <leader>f:  :FzfHistory:<CR>
nnoremap <silent> <leader>f/  :FzfHistory/<CR>
nnoremap <silent> <leader>fs  :FzfSnippets<CR>
nnoremap <silent> <leader>fm  :FzfCommands<CR>
nnoremap <silent> <leader>fl  :FzfBLines<CR>
nnoremap <silent> <leader>fL  :FzfLines<CR>
nnoremap <silent> <leader>ft  :FzfBTags<CR>
nnoremap <silent> <leader>fT  :FzfTags<CR>





