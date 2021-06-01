for plugname in ['vim-pandoc', 'vim-pandoc-syntax', 'md-img-paste.vim', 'pangu.vim', 'ale']
    call Lbs_Load_Plug(plugname)
endfor

nnoremap <buffer> <leader>pp               :Pandoc pdf -H ~/useScript/header.tex<cr>
nnoremap <buffer> <leader>ph               :Pandoc html<cr>
nnoremap <buffer> <silent> <localleader>pi :<c-u>call mdip#MarkdownClipboardImage()<CR>

inoremap <buffer> ;1              <esc>0i#<space><esc>A
inoremap <buffer> ;2              <esc>0i##<space><esc>A
inoremap <buffer> ;3              <esc>0i###<space><esc>A
inoremap <buffer> ;-              <esc>^d0i-<tab><esc>A
inoremap <buffer> ;_              <esc>^d0i<tab>-<tab><esc>A
inoremap <buffer> ;=              <esc>^d0i1.<tab><esc>A
inoremap <buffer> ;+              <esc>^d0i<tab>1.<tab><esc>A
inoremap <buffer> ;c              ` `<C-o>F <c-o>x
inoremap <buffer> ;m              $ $<C-o>F <c-o>x
inoremap <buffer> ;i              * *<C-o>F <c-o>x
inoremap <buffer> ;b              ** **<C-o>F <c-o>x

inoremap <expr> ` Fcitx2en()

nnoremap <buffer> <localleader>ic ysiW`
nnoremap <buffer> <localleader>ab :<c-u>AsyncRun 
    \ xsel -ob >> %:p:h/ref.bib; xsel -ob \| perl -ne 'print "\@$1\n" if ($_ =~ /^\@\w+\{([^,]+)\,/)' >> ~/.config/nvim/paper.dict<cr>
nnoremap <buffer> <silent> <leader>nH
    \ :w !pandoc --from=markdown+east_asian_line_breaks -t html - \| xclip -t text/html -sel clip -i<cr>
noremap <buffer> <silent> <leader>nh
    \ :r  !xclip -o -t text/html -sel clip \| pandoc -f html -t markdown_strict<cr>
setlocal tw=78 formatoptions=tcroqlnmB1j tabstop=4 shiftwidth=4
    \ brk= formatexpr= formatprg=r-format indentexpr=
UltiSnipsAddFiletype rmd.r.markdown.pandoc
