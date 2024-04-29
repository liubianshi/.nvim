" if exists("b:rmd_plugin_on")
"     finish
" endif
" let b:rmd_plugin_on = v:true
" setlocal ft=r
" setlocal ft=rmd
"
" setlocal formatoptions=tcq,ro/,n,lm]1,Bj tabstop=4 shiftwidth=4
" UltiSnipsAddFiletype rmd.r.markdown.pandoc
"
"
"
" nnoremap <silent> <localleader>pr          :<c-u>call utils#RmdClipBoardImage()<CR>
" nnoremap <silent> <localleader>kbp         :<c-u>RSend bookdown::render_book("index.Rmd", "bookdown::pdf_book")<cr>
" nnoremap <silent> <localleader>kbh         :<c-u>RSend bookdown::render_book("index.Rmd", "bookdown::html_book")<cr>
" nnoremap <silent> <localleader>kbo         :<c-u>! xdg-open ./_book/draft.pdf<cr> 
" nnoremap <silent> <localleader>kbv         :<c-u>RSend bookdown::preview_chapter(%)<cr>
" nnoremap <silent> <localleader>P           :<c-u>call RMakeRmd("bookdown::pdf_document2")<cr>
" nnoremap <silent> <localleader>H           :<c-u>call RMakeRmd("bookdown::html_document2")<cr>
" nnoremap <silent> <localleader>W           :<c-u>call RMakeRmd("bookdown::word_document2")<cr>
"
