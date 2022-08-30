let g:floaterm_rootmarkers = ['.project', '.git', '.hg', '.svn', '.root', '.gitignore']
let g:floaterm_keymap_toggle = '<leader><space>'
"let g:floaterm_wintype = 'normal'
"let g:floaterm_position = 'bottom'
"let g:floaterm_height = 0.35
"
augroup Floaterm
    autocmd!
    autocmd FileType floaterm nnoremap <buffer> <leader>r
        \ :<C-U>FloatermUpdate --wintype=normal --position=right<cr>
    autocmd FileType floaterm nnoremap <buffer> <leader>l
        \ :<C-U>FloatermUpdate --wintype=normal --position=left<cr>
    autocmd FileType floaterm nnoremap <buffer> <leader>f
        \ :<C-U>FloatermUpdate --wintype=floating --position=topright<cr>
augroup END

nnoremap <leader>:n :<c-u>FloatermNew<cr>
nnoremap <leader>:R :<c-u>FloatermNew raku<cr>
nnoremap <leader>:r :<c-u>FloatermNew radian<cr>
nnoremap <leader>:p :<c-u>FloatermNew iPython<cr>
nnoremap <leader>:l :<c-u>FloatermSend<cr>
vnoremap <leader>:l :<c-u>FloatermSend<cr>
