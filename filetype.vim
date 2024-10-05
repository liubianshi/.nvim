function! s:DefaultFileType()
    if empty(&l:filetype) && empty('&l:buftype')
        let &l:filetype = "unknown"
        return
    end

    let ft = s:CheatsheetsFileType()
    if ft != ""
        let &l:filetype = ft
        return
    endif
endfunction

function! s:CheatsheetsFileType()
    let current_path = expand('%:p')
    if current_path !~? '\/cheatsheets\/personal\/'
        return ""
    endif

    let syntax_check_regex = '\v^syntax: (\w+)\s*$'
    if getline(2) =~? syntax_check_regex
        return substitute(getline(2), syntax_check_regex, "\\1", 'g')
    endif

    let filetype_map = {
                \ "R":     "r",
                \ "perl":  "perl",
                \ "stata": "stata",
                \ "nvim":  "vim",
                \ "vim":   "vim",
                \ "bash":  "sh",
                \}
    if current_path =~? '\/cheatsheets\/personal\/(\w+)\/'
        let key = substitute(current_path, '\/cheatsheets\/personal\/(\w+)\/', "\\1", 'g')
        return filetype_map[key]
    endif
    return "sh"
endfunction


augroup filetypedetect
    autocmd BufNewFile,BufRead *.sxhkdrc                      set filetype=sxhkd
    autocmd BufNewFile,BufRead *.lfrc                         set filetype=lf
    autocmd BufNewFile,BufRead *.tsv                          set filetype=tsv
    autocmd BufNewFile,BufRead *.[Rr]md,*.[Rr]markdown        set filetype=rmd
    autocmd BufNewFile,BufRead *.sthlp                        set filetype=smcl
    autocmd BufNewFile,BufRead *.ihlp                         set filetype=smcl
    autocmd BufNewFile,BufRead .gitignore                     set filetype=gitignore
    autocmd BufNewFile,BufRead /tmp/newsboat-article.*        set filetype=newsboat
    autocmd BufNewFile,BufRead *.newsboat                     set filetype=newsboat
    autocmd BufWinEnter *                                     call s:DefaultFileType()
augroup END
