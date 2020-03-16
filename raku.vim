
augroup reku_setup
    function! Rakudo()
        let b:AutoPairs = g:AutoPairs
        let b:AutoPairs['<']=">"
        abbr << « 
        abbr >> » 
    endfunction

    au FileType raku call Rakudo()
    au FileType <localleader>r AsyncRun raku "%"
    au FileType <localleader>R AsyncRun raku "%"
augroup END

