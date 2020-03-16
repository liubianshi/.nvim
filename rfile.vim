let R_app = "radian"
let R_cmd = "R"
let R_hl_term = 0
let R_args = []  " if you had set any
let R_openpdf = 1
let R_bracketed_paste = 1
let R_rcomment_string = '#> '
let R_hi_fun_globenv = 1
"let R_assign_map = '<A-=>'
let R_assign = 0

let R_in_buffer = 1
"let R_csv_app = 'terminal:sc-im'
"let R_csv_delim = '\t'
"let R_csv_app = 'tmux new-window sc-im'
let R_csv_app = "terminal:/home/liubianshi/useScript/viewdata"

" 配置语法高亮的函数
let R_start_libs = 'base,stats,graphics,grDevices,utils,methods,data.table,fread,ggplot2,dplyr,tibble,stringr,forcats,readr,tidyr,purrr,fread,readxl,tidyverse'

" 设置 R 和 Rmarkdown 文档
augroup r_setup
    autocmd!
    " Format
    autocmd BufNewFile,BufRead *.[Rr]md set filetype=rmd
    autocmd FileType rmd,rmarkdown nnoremap <leader>nc
        \ :RNrrw<cr>:set filetype=r<cr>
    autocmd FileType r,rmd,rmarkdown,pandoc,rmd.rmarkdown setlocal 
        \ formatoptions=tqcnmB1jo
    autocmd FileType r,rmd,rmarkdown,pandoc,rmd.rmarkdown setlocal 
        \ tabstop=2
    autocmd FileType r,rmd,rmarkdown,pandoc,rmd.rmarkdown setlocal 
        \ shiftwidth=2
    autocmd FileType r,rmd,rmarkdown,pandoc,rmd.rmarkdown setlocal 
        \ breakat=

    " UltiSnips
    autocmd FileType rmd,rmarkdown :UltiSnipsAddFiletypes rmd.markdown
    " Abbreviate
    autocmd FileType r,rmd,rmarkdown,rmd.rmarkdown 
        \ :iabbrev <buffer> iff if ()<left>

    " 切换补全工具
    function! SourceNCM2 ()
        call plug#load('nvim-yarp', 'ncm2', 'ncm-R', 'ncm2-bufword', 'ncm2-path', 'ncm2-ultisnips')
        let b:coc_suggest_disable = 1 
        call ncm2#enable_for_buffer()
    endfunction
    autocmd FileType r,rmd,rmarkdown nnoremap <silent> <localleader>S
        \ :<c-u> call SourceNCM2()<cr>
     

    " Nvim-R
    nmap , <Plug>RDSendLine
    vmap , <Plug>REDSendSelection
    nmap <LocalLeader>: :RSend 
    autocmd FileType rmd,rmarkdown nnoremap ;kbp
        \ :<c-u>RSend bookdown::render_book("index.Rmd", "bookdown::pdf_book")<cr>
    autocmd FileType rmd,rmarkdown nnoremap ;kbh
        \ :<c-u>RSend bookdown::render_book("index.Rmd", "bookdown::html_book")<cr>
    if(has("mac"))
        autocmd FileType rmd,rmarkdown nnoremap ;kbo
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
        autocmd FileType rmd,rmarkdown nnoremap ;kbo
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
    autocmd FileType rmd,rmarkdown nnoremap ;kbv
        \ :<c-u>RSend bookdown::preview_chapter(%)<cr>
    autocmd FileType rmd,rmarkdown nnoremap ;P
        \ :<c-u>call RMakeRmd("bookdown::pdf_document2")<cr>
    autocmd FileType rmd,rmarkdown nnoremap ;H
        \ :<c-u>call RMakeRmd("bookdown::html_document2")<cr>
    " R package development
    autocmd FileType r nnoremap ;dl :<c-u>RSend devtools::load_all()<cr>
    autocmd FileType r nnoremap ;dd :<c-u>RSend devtools::document()<cr>
augroup END
     
