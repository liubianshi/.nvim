let g:sneak#label = 1
let g:sneak#s_next = 1
let g:sneak#use_ic_scs = 1
let g:sneak#f_reset = 1
let g:sneak#t_reset = 1

nnoremap <silent> f :<C-U>call sneak#wrap('',           1, 0, 1, 1)<CR>
nnoremap <silent> F :<C-U>call sneak#wrap('',           1, 1, 1, 1)<CR>
xnoremap <silent> f :<C-U>call sneak#wrap(visualmode(), 1, 0, 1, 1)<CR>
xnoremap <silent> F :<C-U>call sneak#wrap(visualmode(), 1, 1, 1, 1)<CR>
onoremap <silent> f :<C-U>call sneak#wrap(v:operator,   1, 0, 1, 1)<CR>
onoremap <silent> F :<C-U>call sneak#wrap(v:operator,   1, 1, 1, 1)<CR>
nnoremap <silent> t :<C-U>call sneak#wrap('',           1, 0, 0, 1)<CR>
nnoremap <silent> T :<C-U>call sneak#wrap('',           1, 1, 0, 1)<CR>
xnoremap <silent> t :<C-U>call sneak#wrap(visualmode(), 1, 0, 0, 1)<CR>
xnoremap <silent> T :<C-U>call sneak#wrap(visualmode(), 1, 1, 0, 1)<CR>
onoremap <silent> t :<C-U>call sneak#wrap(v:operator,   1, 0, 0, 1)<CR>
onoremap <silent> T :<C-U>call sneak#wrap(v:operator,   1, 1, 0, 1)<CR>
nmap ss <Plug>Sneak_s
nmap sS <Plug>Sneak_S

nnoremap <silent> sc :<c-u>call <sid>SearchChinese_forward()<cr>
nnoremap <silent> sC :<c-u>call <sid>SearchChinese_backword()<cr>
xnoremap <silent> sc :<c-u>call <sid>SearchChinese_forward()<cr>
xnoremap <silent> sC :<c-u>call <sid>SearchChinese_backword()<cr>
function! s:SearchChinese_forward() 
     silent execute '!fcitx5-remote -o'
     call sneak#wrap('', 2, 0, 1, 1)
     silent exe '!fcitx5-remote -c'
 endfunction 
function! s:SearchChinese_backword() 
     silent execute '!fcitx5-remote -o'
     call sneak#wrap('', 2, 1, 1, 1)
     silent exe '!fcitx5-remote -c'
 endfunction 

