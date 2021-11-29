set wrap lbr cole=2
nnoremap <silent><buffer> p :PreviewQuickfix<cr>
nnoremap <silent><buffer> P :PreviewClose<cr>
noremap <buffer> [u :PreviewScroll -1<cr>
noremap <buffer> ]u :PreviewScroll +1<cr>
noremap <buffer> <localleader>t  :BqfDisable<cr><C-W>T
noremap <buffer> <localleader>b  :BqfToggle<cr>

