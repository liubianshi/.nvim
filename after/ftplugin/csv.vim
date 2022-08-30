set nowrap
call utils#Load_Plug("rainbow_csv")
call utils#Load_Plug("rainbow_csv")
nnoremap <silent> <localleader>a :<c-u>RainbowAlign<cr>
nnoremap <silent> <localleader>l :call utils#ViewLines()<cr>
vnoremap <silent> <localleader>l :call utils#ViewLines()<cr>
