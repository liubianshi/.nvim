augroup filetypedetect
    autocmd BufNewFile,BufRead *.md,*.markdown set filetype=pandoc
    autocmd BufNewFile,BufRead *.[Rr]md set filetype=rmd
    autocmd BufNewFile,BufRead  *.sxhkdrc setlocal filetype=sxhkd
    autocmd BufNewFile,BufRead  */cheatsheets/personal/R/* set filetype=r
augroup END
