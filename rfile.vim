" 函数定义 {{{1
function! R_view_df(dfname, row, method, max_width)
    call g:SendCmdToR('fViewDFonVim("' . a:dfname . '", ' . a:row . ', "' . a:method . '", ' . a:max_width . ')')
endfunction
function! R_view_df_sample(method)
    let dfname = @"
    let row = 40
    let max_width = 30
    return R_view_df(dfname, row, a:method, max_width)
endfunction
function! R_view_df_full(max_width)
    let dfname = @"
    let row = 0 
    let method = 'ht'
    return R_view_df(dfname, row, method, a:max_width)
endfunction

" Nvim-R 变量设置{{{1
let R_cmd = "R"
let R_hl_term = 1
let R_openpdf = 1
let R_bracketed_paste = 0
let R_rcomment_string = '#> '
let Rout_more_colors = 1
let R_hi_fun_globenv = 1
let R_hi_fun_paren = 1
let R_assign = 0
let R_rmdchunk = 0
let R_in_buffer = 1
let R_csv_app = "terminal:/home/liubianshi/useScript/viewdata"
let R_start_libs = 'base,stats,graphics,grDevices,utils,methods,rlang,data.table,fread,readxl,tidyverse,haven,lbs'
"let R_app = "/usr/bin/radian"
"let R_assign_map = '<A-=>'
"let R_csv_app = 'terminal:sc-im'
"let R_csv_delim = '\t'
"let R_csv_app = 'tmux new-window sc-im'

" 自动启动命令组 {{{1
augroup r_setup
    autocmd!
    autocmd BufNewFile,BufRead *.[Rr]md,*.[Rr] call Ncm2CompleteEngine()
    autocmd BufNewFile,BufRead *.[Rr]md set filetype=rmd
    autocmd FileType rmd,rmarkdown nnoremap <leader>nc    :RNrrw<cr>:set filetype=r<cr>
    autocmd FileType r,rmd,rmarkdown,pandoc,rmd.rmarkdown setlocal
        \ tw=78 formatoptions=tqcnmB1jo tabstop=4 shiftwidth=4
        \ brk= formatexpr="" formatprg=r-format
    autocmd FileType r,rmd,rmarkdown,pandoc,rmd.rmarkdown UltiSnipsAddFiletype=rmd.r.markdown

" 便捷符号输入{{{2
    autocmd FileType rmd,rmarkdown,pandoc,rmd.rmarkdown   inoremap ;- <esc>^d0i-<tab><esc>A
    autocmd FileType rmd,rmarkdown,pandoc,rmd.rmarkdown   inoremap ;_ <esc>^d0i<tab>-<tab><esc>A
    autocmd FileType rmd,rmarkdown,pandoc,rmd.rmarkdown   inoremap ;= <esc>^d0i1.<tab><esc>A
    autocmd FileType rmd,rmarkdown,pandoc,rmd.rmarkdown   inoremap ;+ <esc>^d0i<tab>1.<tab><esc>A
    autocmd FileType rmd,rmarkdown,pandoc,rmd.rmarkdown   inoremap ;0 ` `<C-o>F <c-o>x
    autocmd FileType rmd,rmarkdown,pandoc,rmd.rmarkdown   inoremap ;9 $ $<C-o>F <c-o>x
    autocmd FileType rmd,rmarkdown,pandoc,rmd.rmarkdown   inoremap ;I * *<C-o>F <c-o>x
    autocmd FileType rmd,rmarkdown,pandoc,rmd.rmarkdown   inoremap ;B ** **<C-o>F <c-o>x

" Nvim-R 相关的快捷键{{{2
    autocmd FileType r nnoremap <localleader>dl :<c-u>RSend devtools::load_all()<cr>
    autocmd FileType r nnoremap <localleader>dd :<c-u>RSend devtools::document()<cr>
    autocmd FileType r,rmd,rmarkdown nmap <localleader>tv yiw:<c-u>call R_view_df_sample('ht')<cr>
    autocmd FileType r,rmd,rmarkdown nmap <localleader>tr yiw:<c-u>call R_view_df_sample('r')<cr>
    autocmd FileType r,rmd,rmarkdown nmap <localleader>th yiw:<c-u>call R_view_df_sample('h')<cr>
    autocmd FileType r,rmd,rmarkdown nmap <localleader>tt yiw:<c-u>call R_view_df_sample('t')<cr>
    autocmd FileType r,rmd,rmarkdown nmap <localleader>tV yiw:<c-u>call R_view_df_full(0)<cr>
    autocmd FileType r,rmd,rmarkdown vmap <localleader>tv y:<c-u>call R_view_df_sample('ht')<cr>
    autocmd FileType r,rmd,rmarkdown vmap <localleader>tr y:<c-u>call R_view_df_sample('r')<cr>
    autocmd FileType r,rmd,rmarkdown vmap <localleader>th y:<c-u>call R_view_df_sample('h')<cr>
    autocmd FileType r,rmd,rmarkdown vmap <localleader>tt y:<c-u>call R_view_df_sample('t')<cr>
    autocmd FileType r,rmd,rmarkdown vmap <localleader>tV y:<c-u>call R_view_df_full(0)<cr>
    autocmd FileType r,rmd,rmarkdown,pandoc,rmd.rmarkdown inoremap ;rq <esc>vap:LbsRF<cr>
    autocmd FileType r,rmd,rmarkdown,pandoc,rmd.rmarkdown nnoremap <tab>rq vap:LbsRF<cr>
    autocmd FileType r,rmd,rmarkdown,pandoc,rmd.rmarkdown vnoremap <tab>rq :LbsRF<cr>
    autocmd FileType r,rmd,rmarkdown inoremap <buffer> <A-\> %>%<cr>
    autocmd FileType r,rmd,rmarkdown inoremap <buffer> <A-=> <-<Space>
    autocmd FileType r,rmd,rmarkdown imap     <buffer> <A-1> <Esc><Plug>RDSendLine<CR>
    autocmd FileType r,rmd,rmarkdown nmap     <buffer> <A-1> <Plug>RDSendLine<CR>
    autocmd FileType r,rmd,rmarkdown nmap     , <Plug>RDSendLine
    autocmd FileType r,rmd,rmarkdown vmap     , <Plug>REDSendSelection
    autocmd FileType r,rmd,rmarkdown nmap     <LocalLeader>: :RSend 
    autocmd FileType rmd,rmarkdown   nnoremap <localleader>kbp :<c-u>RSend bookdown::render_book("index.Rmd", "bookdown::pdf_book")<cr>
    autocmd FileType rmd,rmarkdown   nnoremap <localleader>kbh :<c-u>RSend bookdown::render_book("index.Rmd", "bookdown::html_book")<cr>
    autocmd FileType rmd,rmarkdown   nnoremap <localleader>kbo :<c-u>! xdg-open ./_book/draft.pdf<cr> 
    autocmd FileType rmd,rmarkdown   nnoremap <localleader>kbv :<c-u>RSend bookdown::preview_chapter(%)<cr>
    autocmd FileType rmd,rmarkdown   nnoremap <localleader>P :<c-u>call RMakeRmd("bookdown::pdf_document2")<cr>
    autocmd FileType rmd,rmarkdown   nnoremap <localleader>H :<c-u>call RMakeRmd("bookdown::html_document2")<cr>
    autocmd FileType rmd,rmarkdown   nnoremap <localleader>W :<c-u>call RMakeRmd("bookdown::word_document2")<cr>

    if(has("mac"))
        autocmd FileType rmd,rmarkdown nnoremap <localleader>kbo  :<c-u>! open ./_book/draft.pdf<cr> 
        autocmd FileType r,rmd,rmarkdown,rnoweb,rmd.rmarkdown    inoremap <buffer> « %>%<cr>
        autocmd FileType r,rmd,rmarkdown,rnoweb,rmd.rmarkdown    inoremap <buffer> ≠ <-<cr> 
        autocmd FileType r,rmd,rmarkdown,rnoweb,rmd.rmarkdown    imap <buffer> ¡ <Esc><Plug>RDSendLine<CR>
        autocmd FileType r,rmd,rmarkdown,rnoweb,rmd.rmarkdown    nmap <buffer> ¡ <Plug>RDSendLine<CR>
    endif

augroup END
