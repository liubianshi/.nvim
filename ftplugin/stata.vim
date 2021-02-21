call Lbs_Load_Plug('stata-vim')
call Lbs_Load_Plug("vimcmdline")
if(has("mac"))
    inoremap <buffer> ¡ <esc>V:<c-u>call RunDoLines()<cr>
    nnoremap <buffer> ¡ V:call RunDoLines()<cr>
    vnoremap <buffer> ¡ :<C-U>call RunDoLines()<cr>
else
    inoremap <buffer> <A-1> <esc>V:<c-u>call RunDoLines()<cr>
    nnoremap <buffer> <A-1> V:call RunDoLines()<cr>
    vnoremap <buffer> <A-1> :<C-U>call RunDoLines()<cr>
endif
nnoremap <buffer> , <esc>V:<C-U>call RunDoLines()<cr>
vnoremap <buffer> , :<C-U>call RunDoLines()<cr>

let b:AutoPairs = g:AutoPairs
let b:AutoPairs['`']="'" 
setlocal foldmethod=marker
setlocal foldmarker={,}
