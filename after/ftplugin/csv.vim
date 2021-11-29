set nowrap
call Lbs_Load_Plug("rainbow_csv")
nnoremap <silent> <localleader>a :<c-u>RainbowAlign<cr>
nnoremap <silent> <localleader>l :call LbsViewLines()<cr>
vnoremap <silent> <localleader>l :call LbsViewLines()<cr>
