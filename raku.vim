
augroup reku_setup
    autocmd!
    function! Rakudo()
        let b:AutoPairs = g:AutoPairs
        "let b:AutoPairs['<']=">"
        abbr << « 
        abbr >> »
        setlocal foldmethod=marker
    endfunction

    au FileType raku call Rakudo()
    au FileType raku 
    au FileType raku nnoremap <silent> <localleader>R :<c-u>AsyncRun raku "%"
    
    if(has("mac"))
        autocmd FileType raku
            \ inoremap <buffer> <A-\> ==><cr>
    else 
        autocmd FileType raku inoremap <buffer> <A-\> ==><cr>
        autocmd FileType raku inoremap <buffer> <A-=> => 
        autocmd FileType raku inoremap <buffer> <A--> -> 
        autocmd FileType raku inoremap <buffer> ;i $
        autocmd FileType raku inoremap <buffer> ;o ~
        autocmd FileType raku inoremap <buffer> ;l <esc>A
    endif
augroup END

