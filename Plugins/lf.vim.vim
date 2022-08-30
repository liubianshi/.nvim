let g:NERDTreeHijackNetrw = 0 " Add this line if you use NERDTree
let g:lf_replace_netrw = 1 " Open lf when vim opens a directory

nnoremap <silent> <leader>fs  :write<CR>
nnoremap <silent> <leader>fS  :write!<CR>
nnoremap <silent> <leader>fo  :Lf<cr>
nnoremap <silent> <leader>fls :split +Lf<cr>
nnoremap <silent> <leader>flv :vertical split +Lf<cr>
nnoremap <silent> <leader>flt :LfNewTab<cr>
