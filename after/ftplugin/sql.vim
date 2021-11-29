call Lbs_Load_Plug("vim-dadbod")
call Lbs_Load_Plug("vim-dadbod-ui")
call Lbs_Load_Plug("vim-dadbod-competion")
vnoremap <buffer> <localleader>l :DB<cr>
nnoremap <buffer> <localleader>l V:DB<cr>
nnoremap <buffer> <localleader>L :<c-u>DB < "%"<cr>
nmap     <buffer> <localleader>E <Plug>(DBUI_EditBindParameters)
nmap     <buffer> <localleader>W <Plug>(DBUI_SaveQuery) 
