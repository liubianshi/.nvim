
augroup reku_setup
    function! Rakudo()
        let b:AutoPairs = g:AutoPairs
        "let b:AutoPairs['<']=">"
        abbr << « 
        abbr >> »
        setlocal foldmethod=marker
    endfunction

    au FileType raku call Rakudo()
    au FileType raku nnoremap <silent> <localleader>r :<c-u>AsyncRun raku "%"<cr>
    au FileType raku nnoremap <silent> <localleader>R :<c-u>AsyncRun raku "%"
    
    if(has("mac"))
        autocmd FileType raku
            \ inoremap <buffer> <A-\> ==><cr>
    else 
        autocmd FileType raku inoremap <buffer> <A-\> ==><cr>
        autocmd FileType raku inoremap <buffer> <A-=> => 
        autocmd FileType raku inoremap <buffer> <A--> -> 
        autocmd FileType raku inoremap <buffer> <tab>i $
        autocmd FileType raku inoremap <buffer> <tab>o ~
        autocmd FileType raku inoremap <buffer> <tab>l <esc>A
    endif
augroup END

