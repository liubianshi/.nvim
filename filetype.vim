function s:DefaultFileType()
    if empty(&l:filetype)
        let &l:filetype = "unknown"
    end
endfunction

augroup filetypedetect
    autocmd BufNewFile,BufRead *.sxhkdrc                      set filetype=sxhkd
    autocmd BufNewFile,BufRead */cheatsheets/personal/R/*     set filetype=r
    autocmd BufNewFile,BufRead */cheatsheets/personal/perl/*  set filetype=perl
    autocmd BufNewFile,BufRead */cheatsheets/personal/stata/* set filetype=stata
    autocmd BufNewFile,BufRead */cheatsheets/personal/bash/*  set filetype=sh
    autocmd BufNewFile,BufRead */cheatsheets/personal/vim/*   set filetype=vim
    autocmd BufNewFile,BufRead *.tsv                          set filetype=tsv
    autocmd BufNewFile,BufRead *.[Rr]md,*.[Rr]markdown        set filetype=rmd
    autocmd BufNewFile,BufRead *.sthlp                        set filetype=smcl
    autocmd BufNewFile,BufRead *.ihlp                         set filetype=smcl
    autocmd BufNewFile,BufRead .gitignore                     set filetype=gitignore
    autocmd BufWinEnter *                                     call s:DefaultFileType()
augroup END
