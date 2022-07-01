"let b:AutoPairs = g:AutoPairs
"let b:AutoPairs['<']=">"
abbr << « 
abbr >> »
setlocal foldmethod=marker
nnoremap <buffer> <silent> <localleader>r :<c-u>AsyncRun raku "%"<cr>
inoremap <buffer> <A-\> ==><cr>
inoremap <buffer> <A-=> =>
inoremap <buffer> <A--> ->
inoremap <buffer> ;i    $
inoremap <buffer> ;o    ~
inoremap <buffer> ;l    <esc>A
inoremap <buffer> ;<CR> <Esc>A;<CR>

if(has("mac"))
    inoremap <buffer> <A-\> ==><cr>
endif
