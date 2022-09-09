augroup filetypedetect
    autocmd BufNewFile,BufRead *.sxhkdrc setlocal filetype=sxhkd
    autocmd BufNewFile,BufRead */cheatsheets/personal/R/* set filetype=r
    autocmd BufNewFile,BufRead */cheatsheets/personal/perl/* set filetype=perl
    autocmd BufNewFile,BufRead */cheatsheets/personal/stata/* set filetype=stata
    autocmd BufNewFile,BufRead */cheatsheets/personal/bash/* set filetype=sh
    autocmd BufNewFile,BufRead *.tsv   set filetype=tsv
    " autocmd BufNewFile,BufRead *.md,*.markdown set filetype=pandoc
    " autocmd BufNewFile,BufRead *.[Rr]md,*.[Rr]markdown set filetype=rmd
    autocmd BufNewFile,BufRead *.sthlp set filetype=smcl
    autocmd BufNewFile,BufRead *.ihlp   set filetype=smcl
    " autocmd BufNewFile,BufRead *.smcl   set filetype=smcl
    " autocmd BufNewFile,BufRead *.org   set filetype=org
    " autocmd BufNewFile,BufRead *.bibtex   set filetype=bibtex
    autocmd BufNewFile,BufRead .gitignore set filetype=gitignore
augroup END
