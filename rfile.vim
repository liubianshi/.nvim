" Nvim-R 变量设置{{{
let R_app = "radian"
let R_cmd = "R"
let R_hl_term = 0
let R_args = []  " if you had set any
let R_openpdf = 1
let R_bracketed_paste = 1
let R_rcomment_string = '#> '
let R_hi_fun_globenv = 1
let R_assign = 0
let R_in_buffer = 1
let R_csv_app = "terminal:/home/liubianshi/useScript/viewdata"
"let R_assign_map = '<A-=>'
"let R_csv_app = 'terminal:sc-im'
"let R_csv_delim = '\t'
"let R_csv_app = 'tmux new-window sc-im'
" 配置语法高亮的函数
let R_start_libs = 'base,stats,graphics,grDevices,utils,methods,data.table,fread,ggplot2,dplyr,tibble,stringr,forcats,readr,tidyr,purrr,fread,readxl,tidyverse'
"}}}
" 自动启动命令组 {{{
augroup r_setup
    autocmd!
" Format Setting{{{
    autocmd BufNewFile,BufRead *.[Rr]md set filetype=rmd
    autocmd FileType rmd,rmarkdown nnoremap <leader>nc
        \ :RNrrw<cr>:set filetype=r<cr>
    autocmd FileType r,rmd,rmarkdown,pandoc,rmd.rmarkdown setlocal 
        \ formatoptions=tqcnmB1jo
    autocmd FileType r,rmd,rmarkdown,pandoc,rmd.rmarkdown setlocal 
        \ tabstop=4
    autocmd FileType rmd,rmarkdown,pandoc,rmd.rmarkdown setlocal 
        \ shiftwidth=4
    autocmd FileType rmd,rmarkdown,pandoc,rmd.rmarkdown setlocal 
        \ breakat=""
"}}}
" 便捷符号输入{{{
    autocmd FileType rmd,rmarkdown,pandoc,rmd.rmarkdown
        \ inoremap <tab>- <esc>m0^d0i-<space><esc>`0a
    autocmd FileType rmd,rmarkdown,pandoc,rmd.rmarkdown
        \ inoremap <tab>= <esc>m0^d0i1.<space><esc>`0a
    autocmd FileType rmd,rmarkdown,pandoc,rmd.rmarkdown
        \ inoremap <tab>_ <esc>m0^d0i<tab>-<space><esc>`0a
    autocmd FileType rmd,rmarkdown,pandoc,rmd.rmarkdown
        \ inoremap <tab>+ <esc>m0^d0i<tab>1.<space><esc>`0a
    autocmd FileType rmd,rmarkdown,pandoc,rmd.rmarkdown 
        \ inoremap <tab>0 ` `<C-o>F <c-o>x
    autocmd FileType rmd,rmarkdown,pandoc,rmd.rmarkdown 
        \ inoremap <tab>9 $ $<C-o>F <c-o>x
"}}}
" Nvim-R 相关的快捷键{{{
    nmap , <Plug>RDSendLine
    vmap , <Plug>REDSendSelection
    nmap <LocalLeader>: :RSend 
    autocmd FileType rmd,rmarkdown nnoremap <localleader>kbp
        \ :<c-u>RSend bookdown::render_book("index.Rmd", "bookdown::pdf_book")<cr>
    autocmd FileType rmd,rmarkdown nnoremap <localleader>kbh
        \ :<c-u>RSend bookdown::render_book("index.Rmd", "bookdown::html_book")<cr>
    if(has("mac"))
        autocmd FileType rmd,rmarkdown nnoremap <localleader>kbo
            \ :<c-u>! open ./_book/draft.pdf<cr> 
        autocmd FileType r,rmd,rmarkdown,rnoweb,rmd.rmarkdown
            \ inoremap <buffer> « <Esc>:normal! a%>%<CR>a
        autocmd FileType r,rmd,rmarkdown,rnoweb,rmd.rmarkdown 
            \ inoremap <buffer> ≠ <Esc>:normal! a<-<CR>a 
        autocmd FileType r,rmd,rmarkdown,rnoweb,rmd.rmarkdown
            \ inoremap <buffer> ¡ <Esc><Plug>RDSendLine<CR>
        autocmd FileType r,rmd,rmarkdown,rnoweb,rmd.rmarkdown
            \ nnoremap <buffer> ¡ <Plug>RDSendLine<CR>
        imap … <Esc>:RSend 
    else 
        autocmd FileType rmd,rmarkdown nnoremap <localleader>kbo
            \ :<c-u>! xdg-open ./_book/draft.pdf<cr> 
        " Keymap
        autocmd FileType r,rmd,rmarkdown,rnoweb,rmd.rmarkdown
            \ inoremap <buffer> <A-\> <Esc>:normal! a%>%<CR>a
        autocmd FileType r,rmd,rmarkdown,rnoweb,rmd.rmarkdown 
            \ inoremap <buffer> <A-=> <Esc>:normal! a<-<CR>a 
        autocmd FileType r,rmd,rmarkdown,rnoweb,rmd.rmarkdown
            \ inoremap <buffer> <A-1> <Esc><Plug>RDSendLine<CR>
        autocmd FileType r,rmd,rmarkdown,rnoweb,rmd.rmarkdown
            \ nnoremap <buffer> <A-1> <Plug>RDSendLine<CR>
        imap <A-;> <Esc>:RSend 
    endif
    autocmd FileType rmd,rmarkdown nnoremap <localleader>kbv
        \ :<c-u>RSend bookdown::preview_chapter(%)<cr>
    autocmd FileType rmd,rmarkdown nnoremap <localleader>P
        \ :<c-u>call RMakeRmd("bookdown::pdf_document2")<cr>
    autocmd FileType rmd,rmarkdown nnoremap <localleader>H
        \ :<c-u>call RMakeRmd("bookdown::html_document2")<cr>
    " R package development
    autocmd FileType r nnoremap <localleader>dl :<c-u>RSend devtools::load_all()<cr>
    autocmd FileType r nnoremap <localleader>dd :<c-u>RSend devtools::document()<cr>
"}}}
" view dataframe{{{
    function! R_view_df(row, method)
        let dfname = expand("<cword>")
        call g:SendCmdToR('fViewDFonVim("' . dfname . '", ' . a:row . ', "' . a:method . '")')
    endfunction
    autocmd FileType r,rmd,rmarkdown nmap <localleader>tv :<c-u>call R_view_df(40, 'ht')<cr>
    autocmd FileType r,rmd,rmarkdown nmap <localleader>tr :<c-u>call R_view_df(40, 'r')<cr>
    autocmd FileType r,rmd,rmarkdown nmap <localleader>th :<c-u>call R_view_df(40, 'h')<cr>
    autocmd FileType r,rmd,rmarkdown nmap <localleader>tt :<c-u>call R_view_df(40, 't')<cr>
"}}}
augroup END
     "}}}
